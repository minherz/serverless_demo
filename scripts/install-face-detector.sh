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

region=europe-west2
trigger_bucket_name=`gcloud config get-value project`-input
results_bucket_name=`gcloud config get-value project`-output

gcloud functions deploy face-detector --entry-point detect_faces --runtime python37 --trigger-bucket $trigger_bucket_name --set-env-vars RESULTS_BUCKET_NAME=$results_bucket_name --region $region