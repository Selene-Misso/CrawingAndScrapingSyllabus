require 'net/http'
require 'uri'
require 'json'
require 'csv'

# 年度
year = "2015"

# 学部コード
#   シラバスの学部コード
#   05:文学部, 07:教育学部, 08:教育学研究科, 15:法学部, 22:理学部
#   25:工学部, 42:医学部, 44:薬学部, 45:保健学教育部, 
#   58:教養教育（一般教育）, 59:教養教育（大学院）, 61:自然科学研究科
#   66:社会文化科学研究科, 68:医学教育部, 69:薬学教育部, 70:法曹養成研究科
#   72:養護教諭特別別科, 73:特別支援教育特別専攻科
scd = "22"

## 一覧取得
base  = "http://syllabus.kumamoto-u.ac.jp/rest/auth/syllabusList.json?"
enum =	[
		["locale"		,"ja"],		# 表示言語
#		["mode"			,"count"],	# 件数取得モード切替
		["offset"		,"0"],		# 結果表示オフセット
		["nendo"		, year],	# 年度
		["jikanwari_shozokucd",scd],# 時間割所属
#		["kaikoKbn"		,""],		# 開講区分
#		["kamoku"		,""],		# 科目名
#		["jikanwaricd"	,""],		# 時間割コード
#		["tanto_kyoin"	,""],		# 担当教員
#		["keyword"		,""],		# キーワード
#		["limit"		,"100"]		# 表示件数
		]
path = base + URI.encode_www_form(enum)
uri = URI.parse(path)
json = Net::HTTP.get(uri)
result = JSON.parse(json)
puts result.length

CSV.open("#{year}#{result[1][2]}.csv","wb", :encoding => "SJIS") do |csv|
	result.each do |bo|
		csv << bo
	end
end
