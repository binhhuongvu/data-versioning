#!/bin/bash

echo "Container is running!!!"
echo "Architecture: $(uname -m)"
echo "Python version: $(python --version)"
echo "UV version: $(uv --version)"

gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
mkdir -p /mnt/gcs_bucket
# everything in bucket shows up in that folder & can read + write like normal
gcsfuse --key-file=$GOOGLE_APPLICATION_CREDENTIALS $GCS_BUCKET_NAME /mnt/gcs_data
echo 'GCS bucket mounted at /mnt/gcs_data'
mkdir -p /app/cheese_dataset
# app can read /app/cheese_dataset as if it were local, but it’s actually reading from GCS bucket
# map one directory to another path in the same filesystem (map images in bucket specifically to this container filepath)
mount --bind /mnt/gcs_data/images /app/cheese_dataset

# Activate virtual environment
echo "Activating virtual environment..."
source /.venv/bin/activate

# Keep a shell open
exec /bin/bash