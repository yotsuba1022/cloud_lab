#!/bin/bash

ENV=$1
MODULE=$2
KEY=$3

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_PATH="$SCRIPT_DIR/$ENV/.env"

if [[ -f "$ENV_PATH" ]]; then
  source "$ENV_PATH"
else
  echo "❌ Can not find .env file: $ENV_PATH"
  exit 1
fi

# If not exported, the envsubst will not work
export BUCKET=$BUCKET
export REGION=$REGION
export ENV=$ENV
export LOCK_TABLE=$LOCK_TABLE
export MODULE=$MODULE
export KEY=$KEY

echo "DEBUG: BUCKET=$BUCKET, REGION=$REGION, ENV=$ENV, LOCK_TABLE=$LOCK_TABLE, MODULE=$MODULE, KEY=$KEY"

if [[ -z "$BUCKET" || -z "$REGION" || -z "$LOCK_TABLE" || -z "$MODULE" || -z "$KEY" ]]; then
  echo "❌ Some required environment variables are empty!"
  exit 1
fi

OUT_PATH="$SCRIPT_DIR/$ENV/$MODULE"
mkdir -p "$OUT_PATH"

echo "env file: $ENV_PATH"

envsubst < "$SCRIPT_DIR/backend.tpl.hcl" > "$OUT_PATH/backend.hcl"

echo "✅ backend.hcl already generated at $OUT_PATH/backend.hcl"
