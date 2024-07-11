#!/bin/bash

# 输出使用帮助信息
usage() {
  echo "Usage: $0
  --source-dir <待上传的目录>
  --target-dir <目标目录>
  --bucket-domain <aliyun-oss-bucket-domain>
  [--access-key-id <access-key-id>]
  [--access-key-secret <access-key-secret>]
  [--security-token <security-token>]
  "
  exit 1
}

# 检查是否提供了必要的参数
if [ $# -lt 6 ]; then
  usage
fi

# 解析命名参数
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --source-dir) SOURCE_DIR="$2"; shift ;;
    --target-dir) TARGET_DIR="$2"; shift ;;
    --bucket-domain) BUCKET_DOMAIN="$2"; shift ;;
    --access-key-id) ACCESS_KEY_ID="$2"; shift ;;
    --access-key-secret) ACCESS_KEY_SECRET="$2"; shift ;;
    --security-token) SECURITY_TOKEN="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; usage ;;
  esac
  shift
done

if [ -z "$BUCKET_DOMAIN" ] || [ -z "$SOURCE_DIR" ] || [ -z "$TARGET_DIR" ]; then
  usage
fi

# 如果未提供endpoint，则从BUCKET_DOMAIN中提取，保留一级域名
if [ -z "$ENDPOINT" ]; then
  ENDPOINT=$(echo "$BUCKET_DOMAIN" | awk -F'.' '{print $(NF-2)"."$(NF-1)"."$NF}')
fi

# 从BUCKET_DOMAIN中提取BUCKET_NAME
BUCKET_NAME=$(echo "$BUCKET_DOMAIN" | awk -F'.' '{print $1}')
OSS_DIR="oss://$BUCKET_NAME/$TARGET_DIR"

# 获取当前脚本所在路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 确定操作系统类型并选择相应的ossutil路径
OS=$(uname -s)
ARCH=$(uname -m)
case "$OS" in
  Linux)
    if [ "$ARCH" == "x86_64" ]; then
      OSSUTIL="$SCRIPT_DIR/util/linux-x86/ossutil"
    elif [ "$ARCH" == "i686" ] || [ "$ARCH" == "i386" ]; then
      OSSUTIL="$SCRIPT_DIR/util/linux-x86/ossutil32"
    elif [ "$ARCH" == "aarch64" ]; then
      OSSUTIL="$SCRIPT_DIR/util/arm/ossutil64"
    elif [ "$ARCH" == "armv7l" ] || [ "$ARCH" == "armv6l" ]; then
      OSSUTIL="$SCRIPT_DIR/util/arm/ossutil32"
    else
      echo "Unsupported architecture: $ARCH"
      exit 1
    fi
    ;;
  Darwin)
    OSSUTIL="$SCRIPT_DIR/util/mac/ossutilmac64"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

# 设置鉴权信息
OSSUTIL_CMD="$OSSUTIL cp -r $SOURCE_DIR $OSS_DIR --force --endpoint $ENDPOINT"
if [ -n "$SECURITY_TOKEN" ]; then
  OSSUTIL_CMD="$OSSUTIL_CMD --sts-token $SECURITY_TOKEN"
else
  if [ -z "$ACCESS_KEY_ID" ] || [ -z "$ACCESS_KEY_SECRET" ] ; then
    usage
  fi
  OSSUTIL_CMD="$OSSUTIL_CMD --access-key-id $ACCESS_KEY_ID --access-key-secret $ACCESS_KEY_SECRET"
fi

# 上传到阿里云OSS
eval $OSSUTIL_CMD
UPLOAD_STATUS=$?

if [ $UPLOAD_STATUS -eq 0 ]; then
  echo "Upload completed successfully."
else
  echo "Upload failed"
  exit 1
fi
