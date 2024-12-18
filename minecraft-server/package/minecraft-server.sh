#!/bin/bash

# 引数チェック
if [ "$#" -lt 4 ]; then
    echo "Uses: $0 download -jar <Version> -dir <Directory>"
    exit 1
fi

# バージョンと出力ディレクトリをデフォルトで空に設定
version=""
output_dir=""

# 引数を解析
while [ "$#" -gt 0 ]; do
    case "$1" in
        -jar)
            version="$2"
            shift 2
            ;;
        -dir)
            output_dir="$2"
            shift 2
            ;;
        *)
            shift 1
            ;;
    esac
done

# バージョンと出力ディレクトリが指定されているか確認
if [ -z "$version" ] || [ -z "$output_dir" ]; then
    echo "No version or directory specified."
    exit 1
fi

# .listファイルのパス
list_file="minecraft-server/minecraft_server.list"

# サーバーURLを抽出する関数
extract_server_url() {
    while IFS= read -r line; do
        # バージョンを抽出
        version_in_line=$(echo "$line" | grep -oP "'Minecraft Version':\s*'\K[^']+")
        
        # バージョンが一致する場合
        if [ "$version_in_line" == "$version" ]; then
            # サーバーURLを抽出
            server_url=$(echo "$line" | grep -oP "'Server Jar Download URL':\s*'\K[^']+")
            echo "$server_url"
            return
        fi
    done < "$list_file"
    
    # バージョンが見つからない場合
    echo "The specified version '$version' was not found." >&2
    exit 1
}

# 出力ディレクトリが存在しない場合は作成
mkdir -p "$output_dir"

# サーバーURLを取得
server_url=$(extract_server_url "$version")

# サーバーJarファイルをダウンロード
echo "Downloading...: $server_url"
wget -O "$output_dir/server-$version.jar" "$server_url"

echo "Done: $output_dir/server-$version.jar"

