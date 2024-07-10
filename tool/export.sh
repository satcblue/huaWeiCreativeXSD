#!/bin/bash

# 指定起始查找目录
ROOT_DIR="src"
PROCESS_DIR="src/element"
# 指定targetNamespace
TARGET_NAMESPACE="https://www.satcblue.cn/XMLSchema/HuaWeiCreative"

# 创建一个函数来处理每个目录
process_directory() {
    local dir="$1"
    local export_file="${dir}/export.xsd"
    local xsd_files=($(find "$dir" -maxdepth 1 -name '*.xsd' ! -name 'export.xsd'))

    if [ ${#xsd_files[@]} -eq 0 ]; then
        return
    fi

    # 创建或重建 export.xsd 文件
    {
        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
        echo "<xs:schema xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" targetNamespace=\"$TARGET_NAMESPACE\" xmlns=\"$TARGET_NAMESPACE\" elementFormDefault=\"qualified\">"
        for xsd_file in "${xsd_files[@]}"; do
            # 计算相对路径
            relative_path=$(python3 -c "import os.path; print(os.path.relpath('$xsd_file', start='$ROOT_DIR'))")
            echo "  <xs:include schemaLocation=\"../../$relative_path\"/>"
        done
        echo "</xs:schema>"
    } > "$export_file"
}

export -f process_directory
export TARGET_NAMESPACE
export ROOT_DIR

# 查找所有包含xsd文件的目录并处理它们
find "$PROCESS_DIR" -type d | while read -r dir; do
    process_directory "$dir"
done
