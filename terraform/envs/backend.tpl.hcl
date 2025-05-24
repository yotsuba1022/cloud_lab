bucket         = "${BUCKET}"
key            = "${KEY}/terraform.tfstate"
region         = "${REGION}"
encrypt        = true
dynamodb_table = "${LOCK_TABLE}"
