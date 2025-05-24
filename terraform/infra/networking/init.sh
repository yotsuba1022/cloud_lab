#!/bin/bash

# Usage: ./init.sh dev

ENV=$1

if [ -z "$ENV" ] ; then
  echo "❌ Please enter the environment, e.g. ./init.sh dev"
  exit 1
fi

BACKEND_PATH="../../envs/$ENV/infra/networking/backend.hcl"

if [ ! -f "$BACKEND_PATH" ]; then
  echo "❌ backend config file not found: $BACKEND_PATH" 
  exit 1
fi

echo "🚀 terraform init -backend-config=$BACKEND_PATH -reconfigure"
terraform init -backend-config="$BACKEND_PATH" -reconfigure
