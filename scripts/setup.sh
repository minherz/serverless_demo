#!/bin/bash
# Copyright 2019 Google LLC
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ $# -ne 1 ]; then
    echo "Define project id as an argument"
    exit 1
fi

echo "Setting '$1' as current project..."
gcloud config set project $1

echo "Enabling APIs..."
gcloud services enable compute.googleapis.com cloudfunctions.googleapis.com pubsub.googleapis.com vision.googleapis.com

echo "Creating buckets..."
region=europe-west2
gsutil mb -l $region -p $1 gs://$1-input
gsutil mb -l $region -p $1 gs://$1-output

echo "Creating app engine..."
gcloud app create --region=$region