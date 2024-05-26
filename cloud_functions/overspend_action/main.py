import base64
import json

import functions_framework
from google.cloud import compute_v1

project_id = 'market-ai-2024'
zone_id = 'us-west1-c'

# Triggered from a message on a Cloud Pub/Sub topic.
@functions_framework.cloud_event
def pubsub(cloud_event):
    pubsub_data = base64.b64decode(cloud_event.data["message"]["data"]).decode("utf-8")
    pubsub_json = json.loads(pubsub_data)
    cost_amount = pubsub_json["costAmount"]
    alertThresholdExceeded = pubsub_json.get("alertThresholdExceeded", None)
    if alertThresholdExceeded is not None:
        if alertThresholdExceeded >= 1.0:
            # Get all Compute Engine instances
            client = compute_v1.InstancesClient()
            instances = client.list(project=project_id, zone=zone_id)
            # Stop each instance
            for instance in instances:
                print(f"Stopping instance: {instance.name}")
                client.stop(project=project_id, zone=zone_id, instance=instance.name)