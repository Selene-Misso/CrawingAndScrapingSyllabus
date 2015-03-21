# CrawingAndScrapingSyllabus

これは大学のシラバスをWebクローリングし，スクレイピングするプロジェクトです．
シラバスの各ページの情報を抽出・出力します．

## 何が出来る？

指定した学部のシラバス情報を取得し，画面に表示します．

## 必要なもの

- インターネット環境
- Ruby
開発環境は ruby 2.1.5p273．version 2.0.0 以上を推奨．
- Rubyライブラリ nokogiri
HTMLをパースし，値を取り出すために使用する．
- Rubyライブラリ anemone
Webページを操作し，ページを移動する際に使用する．

## 使い方

1. Ruby をインストールする
  (省略)

2. Rubyライブラリをインストールする
  (詳細は省略)

  ```
  $ gem install anemone
  $ gem install nokogiri
  ```

3. 年度，学部の指定
  FindSyllabus.rb をテキストエディタで開き，
  年度と学部を指定する．

  ```
  # 年度
  year = "2014"
  
  # 学部コード
  #   シラバスの学部コード
  #     教養教育: 58, 文学部: 05,教育学部: 07,法学部: 15,
  #     理学部: 22,医学部: 42,薬学部: 44,工学部: 25
  scd = "25"
  ```

4. 実行

  コマンドラインを開き，以下を実行する．

  ```
  $ ruby FindSyllabus.rb
  ```
  
  出力結果をファイルに保存したい場合は，以下のように > を用いてリダイレクトする．
  作成されたファイルの文字コードはUTF-8になる．なお， filename.csv は
  自由に変更してよい．

  ```
  $ ruby FindSyllabus.rb > filename.csv
  ```

## 処理の概要

シラバスを学部と年度で検索すると，検索結果には全てのシラバスの一覧が
表示される．この中から時間割コードを取り出し，配列に保存する．

保存した全ての時間割コードからシラバスを開き，HTMLに記載されている情報を
抽出し，表示する．
