#!/bin/bash
set -e

IMAGE_NAME="flask-app:test"
CONTAINER_NAME="flask-test"

# Start container in detached mode
docker run -d --rm --name $CONTAINER_NAME -p 5000:5000 $IMAGE_NAME
sleep 5

# Test API
RESPONSE=$(curl -s "http://localhost:5000/add?num1=5&num2=3")
EXPECTED="8.0"

if [ "$RESPONSE" == "$EXPECTED" ]; then
  echo "Test passed: $RESPONSE"
  docker stop $CONTAINER_NAME
  exit 0
else
  echo "Test failed: got $RESPONSE, expected $EXPECTED"
  docker stop $CONTAINER_NAME
  exit 1
fi

