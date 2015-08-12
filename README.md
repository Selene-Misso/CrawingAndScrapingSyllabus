# CrawingAndScrapingSyllabus

これは大学のシラバスのWebAPIを利用して，
シラバスの各ページの情報を出力します．

## 何が出来る？

指定した年度，学部のシラバスを取得し，画面に表示します．

## 必要なもの

- インターネット環境
- Ruby

ruby 2.1.5p273 を開発に使用した．利用にはRuby Version 2.0.0 以上を推奨．

- Rubyライブラリ
  - Sanitize

文字列中のHTMLタグを除去する．

## 使い方

1. Ruby をインストールする

  (省略)

2. ライブラリ Sanitize をインストールする．

```
$ gem install sanitize
```

インストールにはDevKitが必要です．

3. 年度，所属コードの指定して実行する．

プログラム getSyllabus.rb の引数に，年度(-s 2015)と所属コード(-s 22)を指定して，
プログラムを実行する．

コマンドラインを開き，以下を実行する．実行中，画面には進捗状況が表示されます．


```
$ ruby getSyllabus.rb -y 2015 -s 22 > filename.csv
```

出力結果をファイルに保存したい場合は，上記のように > を用いてリダイレクトする．
作成されたファイルの文字コードはShift-JISになり，Excelでそのまま読み込める．
なお， filename.csv は自由に変更してよい．


## 処理の概要

シラバスを学部と年度で検索すると，検索結果には全てのシラバスの一覧が
表示される．この中から時間割コードを取り出し，配列に保存する．

保存した時間割コードから各シラバスをWebAPI経由でアクセスする．
WebAPIからはJSON形式のシラバス情報を取得できるので，それを加工して表示する．


## ヘルプ

コマンドに -h オプションをつけると，コマンドの使い方を表示します．

```
$ ruby getSyllabus.rb -h
Usage: getSyllabus [options]
    -y, --year VALUE                 取得するシラバスの年度を指定する。
                デフォルト値は2015。何も指定しない場合はデフォルト値を用いる。
    -s, --shozokucd VALUE            取得するシラバスの所属コードを指定する。
                デフォルト値は22。何も指定しない場合はデフォルト値を用いる。
                         58 教養教育     05 文学部
                         07 教育学部     15 法学部
                         22 理学部       42 医学部
                         44 薬学部       25 工学部
```


## 既知の問題

- "選択/必修"の情報が，一般向けに公開されているシラバスに掲載されてないため，取得できない．

