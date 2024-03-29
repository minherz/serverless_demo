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

bucket_name=`gcloud config get-value project`-input
sed -i 's/  INPUT_BUCKET_NAME: PLACE_BUCKET_NAME_HERE/  INPUT_BUCKET_NAME: '$bucket_name'/g' app.yaml
gcloud app deploy --quiet
sed -i 's/  INPUT_BUCKET_NAME: '$bucket_name'/  INPUT_BUCKET_NAME: PLACE_BUCKET_NAME_HERE/g' app.yaml
