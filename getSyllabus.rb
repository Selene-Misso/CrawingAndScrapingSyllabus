require "open-uri"
require "json"

year = 2015

base_url = "http://syllabus.kumamoto-u.ac.jp/rest/auth/syllabusList.json?jikanwari_shozokucd=07&"

# 件数取得
uri = base_url + "locale=ja&mode=count&nendo=#{year}"
res = open(uri).read
json_data = JSON.parse(res)
count = json_data[1][0].to_i
p count


# シラバスの一覧を全件一時保存
syllabus_list = []

offset = 0
limit  = 100
while offset < count do
  uri = base_url + "locale=ja&" +
      "offset=#{offset}&nendo=#{year}&limit=#{limit}"

  res = open(uri).read
  json_data = JSON.parse(res)

  i = 0

  p json_data[3]
  json_data.each do |list|
    if(i == 0 && offset == 0) then
      puts "aaa"
    end
    syllabus_list.push(list)
    puts list.map{|s| "\"#{s}\""}.join(",")
    i += 1
  end

  offset = offset + limit
end




#p uri
#uri = "http://syllabus.kumamoto-u.ac.jp/rest/auth/syllabusView.json?locale=ja&nendo=2015&jikanwari_shozokucd=05&jikanwaricd=10010"


#puts json_data
#json_data.each do |list|
#  print list[""]
#code, message = res.status # res.status => ["200", "OK"]

#if code == '200'
#  result = ActiveSupport::JSON.decode res.read
  # resultを使ってなんやかんや処理をする
#else
#  puts "OMG!! #{code} #{message}"
#end
