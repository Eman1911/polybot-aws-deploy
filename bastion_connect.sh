#!/bin/bash

if [ -z "$KEY_PATH" ]; then
  echo "KEY_PATH env var is expected"
  exit 5
fi

if [ -z "$1" ]; then
  echo "Please provide bastion IP address"
  exit 5
fi

BASTION_IP=$1
TARGET_IP=$2
shift 2
CMD="$@"

echo "🔐 Using key: $KEY_PATH"

if [ -z "$TARGET_IP" ]; then
  echo "📡 Connecting to bastion at: $BASTION_IP"
  ssh -i "$KEY_PATH" ec2-user@"$BASTION_IP"
else
  echo "📡 Connecting to target instance at: $TARGET_IP"
  # Use the correct key for polybot here
  ssh -i ~/Downloads/eman-key.pem \
    -o ProxyCommand="ssh -i $KEY_PATH -W %h:%p ec2-user@$BASTION_IP" \
    ec2-user@"$TARGET_IP" "$CMD"
fi
