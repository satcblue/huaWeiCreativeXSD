#!/bin/bash

# 输出使用帮助信息
usage() {
  echo "Usage: $0
  --bucket-domain <aliyun-oss-bucket-domain>
  [--access-key-id <access-key-id>]
  [--access-key-secret <access-key-secret>]
  [--security-token <security-token>]
  [--keep-output]
  "
  exit 1
}

KEEP_OUTPUT=false
# 解析命名参数
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --bucket-domain) BUCKET_DOMAIN="$2"; shift ;;
    --access-key-id) ACCESS_KEY_ID="$2"; shift ;;
    --access-key-secret) ACCESS_KEY_SECRET="$2"; shift ;;
    --security-token) SECURITY_TOKEN="$2"; shift ;;
    --keep-output) KEEP_OUTPUT=true ;;
    *) echo "Unknown parameter passed: $1"; usage ;;
  esac
  shift
done

if [ -z "$BUCKET_DOMAIN" ]; then
  usage
fi

# 执行文件处理脚本
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INPUT_DIR="$SCRIPT_DIR/../../src"
OUTPUT_DIR="$SCRIPT_DIR/../../dist/aliyun-oss/SCHEMA"
REMOVE_DIR="$SCRIPT_DIR/../../dist/aliyun-oss/"
OSS_DIR="SCHEMA"

eval "$SCRIPT_DIR/process_files.sh" --url "https://$BUCKET_DOMAIN/$OSS_DIR" --src "$INPUT_DIR" --dist "$OUTPUT_DIR"
PROCESS_STATUS=$?
if [ $PROCESS_STATUS -eq 0 ]; then
  echo "process files successfully. dist dir is $OUTPUT_DIR"
else
  echo "process files failed"
  exit 1
fi

echo "start upload files to oss"

# 执行上传脚本
if [ -n "$SECURITY_TOKEN" ]; then
  eval "$SCRIPT_DIR/upload-aliyun-oss.sh" --source-dir "$OUTPUT_DIR" --target-dir "$OSS_DIR" --bucket-domain "$BUCKET_DOMAIN" --security-token "$SECURITY_TOKEN"
else
  if [ -z "$ACCESS_KEY_ID" ] || [ -z "$ACCESS_KEY_SECRET" ] ; then
    usage
  fi
  eval "$SCRIPT_DIR/upload-aliyun-oss.sh" --source-dir "$OUTPUT_DIR" --target-dir "$OSS_DIR" --bucket-domain "$BUCKET_DOMAIN" --access-key-id "$ACCESS_KEY_ID" --access-key-secret "$ACCESS_KEY_SECRET"
fi


UPLOAD_STATUS=$?
if [ $UPLOAD_STATUS -eq 0 ]; then
  if [ "$KEEP_OUTPUT" = false ]; then
    echo "Deleting output directory $REMOVE_DIR"
    rm -rf "$REMOVE_DIR"
  fi
fi