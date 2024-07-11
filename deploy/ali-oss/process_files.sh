#!/bin/bash

# 输出使用帮助信息
usage() {
  echo "Usage: $0 --url <schema url> --src <处理的目录> --dist <生成的目录>"
  exit 1
}

# 检查是否提供了必要的参数
if [ $# -lt 2 ]; then
  usage
fi

# 解析命名参数
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --url) URL="$2"; shift ;;
    --src) SRC_DIR="$2"; shift ;;
    --dist) DIST_DIR="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; usage ;;
  esac
  shift
done

if [ -z "$URL" ] || [ -z "$SRC_DIR" ] || [ -z "$DIST_DIR" ] ; then
    usage
  fi

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
      # 确保所有相对路径都转换为HTTPS URL
      if [[ "$original_location" == ../../* ]]; then
        relative_path="${original_location#../../}"
      else
        relative_path="$original_location"
      fi
      new_location="$URL/$relative_path"
      line="${line/$original_location/$new_location}"
    fi
    echo "$line" >> "$tmp_file"
  done < "$xsd_file"
  mv "$tmp_file" "$xsd_file"
done

echo "Files processed successfully."
