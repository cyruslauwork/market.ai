import base64
import json

import functions_framework
from google.cloud import compute_v1
from google.cloud import storage
from google.cloud import run_v2

PROJECT_ID = 'market-ai-2024'
ZONE_ID = 'us-west1-c'
BUCKET_NAME = 'market-ai-2024-minute-data-public_v74-x4b37-v_47'
CLOUD_RUN_SERVICE_NAME = 'minute-interval-data'
CLOUD_RUN_REGION = 'us-west1'

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
            instances = client.list(project=PROJECT_ID, zone=ZONE_ID)
            # Stop each instance
            for instance in instances:
                print(f"Stopping instance: {instance.name}")
                client.stop(project=PROJECT_ID, zone=ZONE_ID, instance=instance.name)
            # Make GCS bucket private
            make_bucket_private(BUCKET_NAME)
            # Require authentication for Cloud Run service
            require_authentication_for_cloud_run_service(CLOUD_RUN_SERVICE_NAME, CLOUD_RUN_REGION)

def make_bucket_private(bucket_name):
    storage_client = storage.Client()
    bucket = storage_client.bucket(BUCKET_NAME)

    # Remove allUsers and allAuthenticatedUsers access
    policy = bucket.get_iam_policy(requested_policy_version=3)
    policy.bindings = [
        binding for binding in policy.bindings 
        if not (
            binding['role'] in ['roles/storage.objectViewer', 'roles/storage.legacyObjectReader'] 
            and ('allUsers' in binding['members'] or 'allAuthenticatedUsers' in binding['members'])
        )
    ]

    bucket.set_iam_policy(policy)
    print(f"Bucket {bucket_name} is now private.")

def require_authentication_for_cloud_run_service(service_name, region):
    client = run_v2.ServicesClient()
    service_path = client.service_path(PROJECT_ID, region, service_name)

    # Get the current IAM policy
    policy = client.get_iam_policy(request={"resource": service_path})

    # Remove allUsers binding
    bindings = [binding for binding in policy.bindings if 'allUsers' not in binding['members']]

    policy.bindings = bindings

    # Set the updated IAM policy
    client.set_iam_policy(request={"resource": service_path, "policy": policy})
    print(f"Cloud Run service {service_name} now requires authentication.")