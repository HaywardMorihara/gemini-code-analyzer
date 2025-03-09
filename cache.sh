#!/bin/bash

# https://github.com/simonw/files-to-prompt
files_to_cach() {
  files-to-prompt . -o context.txt
}

# https://www.iana.org/assignments/media-types/media-types.xhtml#text
# systemInstruction 
cache() {
  echo '{
    "model": "models/gemini-1.5-flash-001",
    "contents":[
      {
        "parts":[
          {
            "inline_data": {
              "mime_type":"text/plain",
              "data": "'$(base64 -i a11.txt)'"
            }
          }
        ],
      "role": "user"
      }
    ],
    "systemInstruction": {
      "parts": [
        {
          "text": "You are an expert at analyzing transcripts."
        }
      ]
    },
    "ttl": "300s"
  }' > request.json

  # cat request.json

  curl -X POST "https://generativelanguage.googleapis.com/v1beta/cachedContents?key=$GOOGLE_API_KEY" \
   -H 'Content-Type: application/json' \
   -d @request.json \
   > cache.json

  # cat cache.json

  CACHE_NAME=$(cat cache.json | grep '"name":' | cut -d '"' -f 4 | head -n 1)
  echo $CACHE_NAME
}

# echo "Cache name: $CACHE_NAME"

curl -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-001:generateContent?key=$GOOGLE_API_KEY" \
-H 'Content-Type: application/json' \
-d '{
      "contents": [
        {
          "parts":[{
            "text": "Please summarize this transcript"
          }],
          "role": "user"
        },
      ],
      "cachedContent": "'$CACHE_NAME'"
    }'