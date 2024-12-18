import pandas as pd
import json

def markdown_table_to_json(md_table):
    # MarkdownテーブルをDataFrameに変換
    df = pd.read_csv(pd.compat.StringIO(md_table), sep="|", engine="python", skipinitialspace=True)
    
    # 不要なカラム（空白など）を削除
    df = df.drop(columns=[col for col in df.columns if col.strip() == ""])
    
    # 列名の空白や不要な文字を整形
    df.columns = [col.strip() for col in df.columns]
    
    # DataFrameをJSON形式に変換
    json_output = df.to_json(orient="records", force_ascii=False, indent=4)
    return json_output

def read_markdown_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        md_content = file.read()
    return md_content

# Markdownファイルから読み込み
file_path = 'example.md'  # ここにMarkdownファイルのパスを指定
md_content = read_markdown_file(file_path)

# MarkdownをJSONに変換
json_output = markdown_table_to_json(md_content)

# JSONをファイルに保存
output_file = "output.json"
with open(output_file, "w", encoding="utf-8") as file:
    file.write(json_output)

print(f"JSONデータを '{output_file}' に保存しました。")
