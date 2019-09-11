# Event-driven serverless application demo

It demonstrates use of the serverless functions and serverless application components to setup an application for detecting human faces in the submitted images.
The application uses [Cloud Functions](https://cloud.google.com/functions/) and [Google App Engine](https://cloud.google.com/appengine/) together with [Cloud Vision API](https://cloud.google.com/ml-onramp/vision#Vision) to find out human faces in the ingested images and creating a copycat image with frames around the detected faces.
The application uses two [Cloud Storage](https://cloud.google.com/storage/docs/json_api/v1/buckets) buckets: the _input_ bucket for the ingress images and the _output_ bucket for the images that mark the detected faces.

## Setup

To run the demo one has to have an access to GCP project with permissions of the project owner or project editor.
Once the project is created, run the following command to enable APIs that the demo consumes and to create input and output buckets. Before running the command, make sure that you are authenticated (using `gcloud auth login` command).

```bash
. scripts/setup.sh [PROJECT_ID]
```

and the script will perform all necessary setups.

To install the serverless components the following commands should be executed:

```bash
cd face-detector && . ../scripts/install-face-detector.sh && cd ../image-ingester && . ../scripts/install-image-ingester.sh
```

After installation, open a URL `http://[YOUR_PROJECT_ID].appspot.com`. If the faces are found, an output image can be found in the `[PROJECT_ID]-output`.
