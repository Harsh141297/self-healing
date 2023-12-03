#!/bin/bash

sed "s/blue/green/" "blue.yml" > "green.yml"

kubectl apply -f index_green_html.yml

kubectl apply -f green.yml

ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment/green -n udacity"
until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
  $ROLLOUT_STATUS_CMD
  ATTEMPTS=$((ATTEMPTS + 1))
  sleep 1
done

SERVICE_URL="blue-green.udacityproject.com"
ATTEMPTS=0
until curl -s -o /dev/null $SERVICE_URL || [ $ATTEMPTS -eq 30 ]; do
  echo "Waiting for the service to be reachable..."
  ATTEMPTS=$((ATTEMPTS + 1))
  sleep 5
done
