#!/bin/bash
region=europe-west2
gcloud functions deploy face-detector --entry-point detect_faces --runtime python37 --trigger-bucket devzone-demo-input --source ../face-detector --set-env-vars RESULTS_BUCKET_NAME=devzone-demo-output --region $region