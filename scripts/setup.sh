#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Define project id as an argument"
    exit 1
fi

echo "Setting '$1' as current project..."
gcloud config set project $1

echo "Enabling APIs..."
gcloud services enable compute.googleapis.com cloudfunctions.googleapis.com pubsub.googleapis.com vision.googleapis.com vision.googleapis.com

echo "Creating buckets..."
region=europe-west2
gsutil mb -l $region -p $1 gs://devzone-demo-input
gsutil mb -l $region -p $1 gs://devzone-demo-output

echo "Creating app engine..."
gcloud app create --region=$region