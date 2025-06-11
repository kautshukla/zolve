import os
import time
import requests
import logging
import signal
import sys
from kubernetes import client, config
from kubernetes.client.rest import ApiException

log_level_str = os.getenv("LOG_LEVEL", "INFO").upper()
log_level = getattr(logging, log_level_str, logging.INFO)
logging.basicConfig(level=log_level, format='%(asctime)s - %(levelname)s - %(message)s')

webhook_url = os.getenv("SLACK_WEBHOOK_URL")

def send_slack_notification(webhook_url, message):
    if not webhook_url:
        logging.warning("SLACK_WEBHOOK_URL not set. Skipping notification.")
        return
    payload = {"text": message}
    response = requests.post(webhook_url, json=payload)
    if response.status_code != 200:
        logging.error(f"Failed to send Slack notification: {response.text}")

def get_pod_error_details(namespace, pod_name, v1):
    try:
        pod = v1.read_namespaced_pod(name=pod_name, namespace=namespace)
        container_statuses = pod.status.container_statuses or []
        details = []

        for container in container_statuses:
            name = container.name
            restarts = container.restart_count
            state = container.state
            last_state = container.last_state

            if state.waiting:
                details.append(f"*Container '{name}' waiting*:\n  Reason: {state.waiting.reason}\n  Message: {state.waiting.message}\n")
            if state.terminated:
                details.append(f"*Container '{name}' terminated*:\n  Reason: {state.terminated.reason}\n  Message: {state.terminated.message}\n")
            if last_state.terminated:
                details.append(f"*Last Terminated - '{name}'*:\n  Reason: {last_state.terminated.reason}\n  Message: {last_state.terminated.message}\n")
            details.append(f"♻️ Restart count for '{name}': {restarts}\n")

        # Add Kubernetes events
        events = v1.list_namespaced_event(namespace, field_selector=f"involvedObject.name={pod_name}")
        for event in events.items:
            if event.reason in ["Failed", "BackOff", "FailedScheduling"]:
                details.append(f"📌 *Event - {event.reason}*:\n  {event.message}\n  🕒 Time: {event.last_timestamp}\n")

        return "\n---\n".join(details) if details else "No specific error details available."
    except ApiException as e:
        logging.error(f"Error fetching pod or events: {e}")
        return "Error fetching pod details."

def check_pods():
    try:
        config.load_incluster_config()
        v1 = client.CoreV1Api()
        
        namespace = os.getenv("NAMESPACE", "onboarding")
        pods = v1.list_namespaced_pod(namespace)
        for pod in pods.items:
            pod_name = pod.metadata.name
            status = pod.status.phase
            container_statuses = pod.status.container_statuses or []

            error_message = None
            if status != "Running":
                error_message = f"*Pod `{namespace}/{pod_name}` is in `{status}` state*"
            else:
                for container in container_statuses:
                    if container.state.waiting and container.state.waiting.reason == "CrashLoopBackOff":
                        error_message = f"*Pod `{namespace}/{pod_name}` in CrashLoopBackOff*"
                        break

            if error_message:
                details = get_pod_error_details(namespace, pod_name, v1)
                full_message = f"{error_message}\n\n*Details:*\n{details}"
                send_slack_notification(webhook_url, full_message)
                logging.info(f"Sent notification: {full_message}")

    except Exception as e:
        logging.error(f"Unexpected error in check_pods: {e}")
        if webhook_url:
            send_slack_notification(webhook_url, f"❌ Pod monitor script failed:\n```{e}```")

def handle_shutdown(signum, frame):
    logging.info("Shutdown signal received. Exiting...")
    if webhook_url:
        send_slack_notification(webhook_url, "🛑 Pod monitor service is shutting down.")
    sys.exit(0)

def main():
    logging.info("Pod monitor starting...")
    if webhook_url:
        try:
            send_slack_notification(webhook_url, "✅ Pod monitor service started and running.")
        except Exception as e:
            logging.error(f"Failed to send startup notification: {e}")

    signal.signal(signal.SIGTERM, handle_shutdown)
    signal.signal(signal.SIGINT, handle_shutdown)

    while True:
        logging.debug("Checking pods...")
        check_pods()
        interval = int(os.getenv("POD_MONITOR_CHECK_INTERVAL_SECS", "300"))
        logging.debug(f"Sleeping for: {interval} seconds.")
        time.sleep(interval)

if __name__ == "__main__":
    main()