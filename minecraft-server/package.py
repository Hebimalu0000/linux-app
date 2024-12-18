import pandas as pd

def markdown_table_to_list(md_table):
    # MarkdownテーブルをDataFrameに変換
    df = pd.read_csv(pd.compat.StringIO(md_table), sep="|", engine="python", skipinitialspace=True)
    
    # 不要なカラム（空白など）を削除
    df = df.drop(columns=[col for col in df.columns if col.strip() == ""])
    
    # 列名の空白や不要な文字を整形
    df.columns = [col.strip() for col in df.columns]
    
    # DataFrameをリスト形式に変換
    list_output = df.to_dict(orient="records")
    return list_output

def read_markdown_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        md_content = file.read()
    return md_content

# Markdownファイルから読み込み
file_path = 'minecraft-server-jar-downloads.md'  # ここにMarkdownファイルのパスを指定
md_content = read_markdown_file(file_path)

# 実行
list_output = markdown_table_to_list(md_content)

# .listファイルに保存
output_file = "package/minecraft_server.list"
with open(output_file, "w", encoding="utf-8") as file:
    for item in list_output:
        file.write(str(item) + "\n")

print(f".listデータを '{output_file}' に保存しました。")
