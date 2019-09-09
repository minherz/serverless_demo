#!/bin/bash
region=europe-west2
project_id=`gcloud config get-value project`
gcloud functions deploy face-detector --entry-point detect_faces --runtime python37 --trigger-bucket $project_id-input --source ../face-detector --set-env-vars RESULTS_BUCKET_NAME=$project_id-output --region $region