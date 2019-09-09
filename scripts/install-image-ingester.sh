#!/bin/bash
project_id=`gcloud config get-value project`
sed -i 's/  INPUT_BUCKET_NAME: PLACE_BUCKET_NAME_HERE/  INPUT_BUCKET_NAME: '$project_id'-input/g' app.yaml
gcloud app deploy --quiet
sed -i 's/  INPUT_BUCKET_NAME: '$project_id'-input/  INPUT_BUCKET_NAME: PLACE_BUCKET_NAME_HERE/g' app.yaml
