require "open-uri"
require "json"

year = 2015
shozokucd = 25
jikanwaricd = 62370

module Jikanwari
  # yobiで取得する値を，日本語の曜日に変換する
  def getYoubi(num)
    week_hash = {
      1=> "月曜",
      2=> "火曜",
      3=> "水曜",
      4=> "木曜",
      5=> "金曜",
      6=> "土曜",
      7=> "日曜",
      9=> "その他"
    }
    return week_hash[num]
  end

  # semesで取得する値を，学期に変換する
  def getSemes(num)
    semes_hash = {
      1=> "前期",
      2=> "後期",
      3=> "通年",
      4=> "集中講義"
    }
    return semes_hash[num]
  end

  # requireで取得する値を，選択必修に変換する
  def getRequire(num)
    require_hash = {
      1=> "必修",
      2=> "選択必修",
      3=> "選択",
      4=> "便覧参照"
    }
    return require_hash[num]
  end

  # シラバスの一覧を取得
  def getList(year, shozokucd)
    base_url = "http://syllabus.kumamoto-u.ac.jp/rest/auth/syllabusList.json?"

    # 件数取得
    uri = base_url + "locale=ja&mode=count&nendo=#{year}" +
          "&jikanwari_shozokucd=#{shozokucd}"
    res = open(uri).read
    json_data = JSON.parse(res)
    count = json_data[1][0].to_i

    # シラバスの一覧を保存
    syllabus_list = []

    offset = 0
    limit  = 100
    while offset < count do
      uri = base_url + "locale=ja&jikanwari_shozokucd=#{shozokucd}&" +
          "offset=#{offset}&nendo=#{year}&limit=#{limit}"

      res = open(uri).read
      json_data = JSON.parse(res)
      i = 0
      json_data.each do |list|
        if(i == 0 && offset == 0) then
          # 初回のみタイトル行を格納
#          syllabus_list.push(list)
#          puts list.map{|s| "\"#{s}\""}.join(",")
        elsif (i == 0) then
          # なにもしない
        else
          # シラバス一覧を一時保存
          syllabus_list.push(list)
#          puts list.map{|s| "\"#{s}\""}.join(",")
        end
        i += 1
      end

      offset += limit
    end
    return syllabus_list
  end

  module_function :getYoubi
  module_function :getSemes
  module_function :getRequire
  module_function :getList
end

# 基本情報 取得
uri = "http://syllabus.kumamoto-u.ac.jp/rest/auth/courseInfoBasic.json?" +
      "locale=ja&nendo=#{year}&jikanwari_shozokucd=#{shozokucd}&" +
      "jikanwaricd=#{jikanwaricd}"
res = open(uri).read
json_data = JSON.parse(res)

# 詳細情報 取得
uri = "http://syllabus.kumamoto-u.ac.jp/rest/auth/syllabusView.json?" +
      "locale=ja&nendo=#{year}&jikanwari_shozokucd=#{shozokucd}&" +
      "jikanwaricd=#{jikanwaricd}"
res = open(uri).read
json_data_detail = JSON.parse(res)

# 詳細情報からテキストの情報をだけを取り出す
json_data[0]["textbook"] = json_data_detail[0]["textbook"]

# ハッシュと，CSVのヘッダーの対応付け
attribute = {
  "nameJp"=> "科目名(日本語)",
  "nameEn"=> "科目名(英語)",
  "profs"=> "担当教員",
  "require"=> "選択/必修",
  "school"=> "時間割所属",
  "code"=> "時間割コード",
  "year"=> "年度",
  "semes"=> "学期",
  "unit"=> "単位数",
  "grade"=> "開講年次",
  "when"=> [
    {
      "yobi"=> "曜日",
      "jigen"=> "時限"
    }
  ],
  "weeks"=> "授業回数",
  "numbering"=> "科目ナンバー",
  "textbook"=>"テキスト",
}

# 画面出力 1行目のタイトル
attribute.each do |att|
  if att[0].to_s == "when" then
    print "\"#{att[1][0]["yobi"]}\","
    print "\"#{att[1][0]["jigen"]}\","
  else
    print "\"#{att[1].to_s}\","
  end
end
print "\n"

# 画面出力 2行目以降のデータ
attribute.each do |att|
  if att[0].to_s == "when" then
    # 曜日・時限
    puts json_data[0][att[0].to_s].length
    print "\"#{Jikanwari.getYoubi(json_data[0][att[0].to_s][0]["yobi"].to_i)}\","
    print "\"#{json_data[0][att[0].to_s][0]["jigen"]}\","
  elsif att[0].to_s == "semes" then
    # 学期
    print "\"#{Jikanwari.getSemes(json_data[0][att[0].to_s].to_i)}\","
  elsif att[0].to_s == "require" then
    # 選択必修
    print "\"#{Jikanwari.getRequire(json_data[0][att[0].to_s].to_i)}\","
  else
    # その他
    print "\"#{json_data[0][att[0].to_s].to_s}\","
  end
end
print "\n"

puts Jikanwari.getList(2015, "07")
