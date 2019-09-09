# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


from io import BytesIO
import os
import sys

from google.cloud import storage, vision
from PIL import Image, ImageDraw

storage_client = storage.Client()
vision_client = vision.ImageAnnotatorClient()


# Detect and mark faces on uploaded image.
def detect_faces(data, context):
    
    # read event parameters
    file_name = data['name']
    bucket_name = data['bucket']

    print(f'Analyzing {file_name}.')

    # detect faces using Vision API
    image = vision.types.Image()
    image.source.image_uri = f'gs://{bucket_name}/{file_name}'
    response = vision_client.face_detection(image=image)
    faces = response.face_annotations

    if faces is not None and len(faces) > 0:

        # mark detected faces
        print(f'Found {len(faces)} in the image.')
        blob = storage_client.bucket(bucket_name).get_blob(file_name)
        if blob is None:
            sys.stderr.write(f'Failed to retrieve data for {file_name} from {bucket_name}')
            return

        bucket_name = os.environ['RESULTS_BUCKET_NAME']
        if bucket_name == "":
            sys.stderr.write('RESULTS_BUCKET_NAME must be set. Cannot store image with marked faces.')
            return

        im = Image.open(BytesIO(blob.download_as_string())).convert('RGBA')
        draw = ImageDraw.Draw(im)

        for index, face in enumerate(faces):
            print(f'face #{index} confidence level {face.detection_confidence}')
            _draw_polygon(draw=draw, vertices=face.bounding_poly.vertices, color=(0xfb, 0, 0), width=3)

        # save modified image to result bucket
        stream = BytesIO()
        im.save(stream, format='PNG', optimize=True)
        stream.seek(0, os.SEEK_SET)
        blob = storage_client.bucket(bucket_name).blob(file_name[:file_name.rfind('.')] + '.png')
        blob.upload_from_file(stream)
        print(f'Store {file_name} with marked face(s) into {bucket_name}.')
    else:
        print('No faces found.')
# [END detect_faces]


# draw polygon of defined line width
def _draw_polygon(draw, vertices, color, width):
    if not vertices:
        return
    
    # convert vertices to tuples of coordinates
    points = [(vertex.x, vertex.y) for vertex in vertices]
    points.append(points[0])
    # draw polygon
    draw.line(points, fill=color, width=width)
    # connect line endings in nice way
    radius = width // 2
    for pt in points:
        draw.ellipse((pt[0] - radius, pt[1] - radius, pt[0] + radius, pt[1] + radius), fill=color)
# [END _draw_polygon]
