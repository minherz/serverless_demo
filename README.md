# Event-driven serverless application demo

Deploy facedetector: gcloud functions deploy devzone-demo-detect-function1 --entry-point detect_faces --runtime python37 --trigger-bucket demo-incoming --set-env-vars RESULTS_BUCKET_NAME=demo-results

## TODO List for 'image_uploader'

* discover the way to deploy cloud function using cloud SDK tools (i.e. gcloud)
* write the script that performs the deploy
* write an app the streams pub sub messages from the topic and do smth, e.g. creates audio file with the text and post it into bucket

Deploying Cloud commands:

gcloud functions deploy devzone-demo-function --entry-point detect_faces --runtime python37 --trigger-bucket devzone-demo-incoming --set-env-vars RESULT_BUCKET_NAME=devzone-demo-results --region europe-west2
