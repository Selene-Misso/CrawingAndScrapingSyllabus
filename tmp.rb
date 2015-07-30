require "open-uri"
require "json"

year = 2015


# シラバス詳細を取得
base_url = "http://syllabus.kumamoto-u.ac.jp/rest/auth/syllabusView.json?locale=ja&"
uri = base_url + "nendo=#{year}&jikanwari_shozokucd=05&jikanwaricd=10010"
res = open(uri).read
json_data = JSON.parse(res)
puts json_data[0]["textbook"]

#puts json_data[0].map{|s| "\"#{s}\""}.join(",")

# 基本情報
uri = "http://syllabus.kumamoto-u.ac.jp/rest/auth/courseInfoBasic.json?locale=ja&nendo=2015&jikanwari_shozokucd=25&jikanwaricd=61460"
res = open(uri).read
json_data = JSON.parse(res)
puts JSON.pretty_generate(json_data[0])
puts json_data[0]["nameJp"]
puts json_data[0]["semes"]

#{
#  "nameJp": "科目名(日本語)",
#  "nameEn": "科目名(英語)",
#  "profs": "担当教員",
#  "require": null,
#  "school": "時間割所属",
#  "code": "時間割コード",
#  "year": "年度",
#  "semes": "学期",
#  "unit": "単位数",
#  "grade": "開講年次",
#  "when": [
#    {
#      "yobi": "曜日(1:月曜)",
#      "jigen": "時限"
#    }
#  ],
#  "weeks": "授業回数",
#  "numbering": "",
#  "date": false,
#  "updateEnableFlg": false
#}

# 詳細情報から持ってくる項目
## 講義題目(テーマ) jugyo_theme
## 使用言語 shiyo_gengocd
## 授業の形態 jugyo_keitai
## テキスト textbook
## 授業の方法 jugyo_hoho
