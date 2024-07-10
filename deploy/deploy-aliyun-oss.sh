#!/bin/bash

# 检查是否提供了阿里云OSS地址
if [ -z "$1" ]; then
  echo "Usage: $0 <aliyun-oss-url>"
  exit 1
fi

ALIYUN_OSS_URL=$1/SCHEMA
SRC_DIR="src"
DIST_DIR="dist/aliyun-oss/SCHEMA"

# 创建dist目录，如果存在则删除原有文件
if [ -d "$DIST_DIR" ]; then
  echo "Cleaning up existing directory: $DIST_DIR"
  rm -rf "$DIST_DIR"
fi
mkdir -p "$DIST_DIR"

# 复制src目录下所有内容到dist目录
echo "Copying files from $SRC_DIR to $DIST_DIR"
cp -r "$SRC_DIR"/* "$DIST_DIR"

# 查找并替换xsd文件中的schemaLocation
echo "Updating schemaLocation in xsd files"
find "$DIST_DIR" -name "*.xsd" | while read -r xsd_file; do
  echo "Processing $xsd_file"
  tmp_file="${xsd_file}.tmp"
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ $line =~ schemaLocation=\"([^\"]*)\" ]]; then
      original_location="${BASH_REMATCH[1]}"
      # 确保所有相对路径都转换为OSS URL
      if [[ "$original_location" == ../../* ]]; then
        relative_path="${original_location#../../}"
      else
        relative_path="$original_location"
      fi
      new_location="$ALIYUN_OSS_URL/$relative_path"
      line="${line/$original_location/$new_location}"
    fi
    echo "$line" >> "$tmp_file"
  done < "$xsd_file"
  mv "$tmp_file" "$xsd_file"
done

echo "Script completed successfully."
