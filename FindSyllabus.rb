require 'nokogiri'
require 'anemone'
require 'uri'


# 年度
year = "2014"

# 学部コード
#   シラバスの学部コード
#     教養教育: 58, 文学部: 05,教育学部: 07,法学部: 15,
#     理学部: 22,医学部: 42,薬学部: 44,工学部: 25
scd = "25"

# 検索ページをクロールし，学部の検索結果を全て取得する
opts = {
	depth_limit: 1
}
url = "http://syllabus.jimu.kumamoto-u.ac.jp/kusy_result.php?nendo="+ year +"&scd=" + scd +"&limit=100&offset=1"
jcd_list = []

Anemone.crawl(url, opts) do |anemone|
	
	anemone.focus_crawl do |page|
		page.links.keep_if { |link|
			# 検索ページのみにジャンプする
			link.to_s.match(/kusy_result/)
		} 
	end
	
	anemone.on_every_page do |page|

		# リスト取得
		page.doc.xpath("/html/body//table[@class='kekkameisai']//tr").each do |node|
			#print node.xpath(".//td[@class='no2']/text()").to_s + "\t"
			#print node.xpath(".//td[@class='kamoku2']/a/text()").to_s + "\t"
			href = node.xpath(".//td[@class='kamoku2']/a/@href").to_s
			
			# URLから時間割コードを取得し，保存
			hrefAry = URI.decode_www_form(href)
			jcd_list.push(hrefAry.assoc('jcd').last)
			#print hrefAry.assoc('scd').last + "\t" + hrefAry.assoc('jcd').last + "\t"
			#print node.xpath(".//td[@class='kamoku2']/a/@href").to_s + "\t"
			#print node.xpath(".//td[@class='kaiko_nenji2']/text()").to_s + "\t"
			#print node.xpath(".//td[@class='gakki2']/text()").to_s + "\t"
			#print node.xpath(".//td[@class='tanisu2']/text()").to_s + "\t"
			#print node.xpath(".//td[@class='kyoinmei2']/text()").to_s + "\t"
			#print "\n"
		end
	end
end


# 各シラバスをクローリング

opts = {
	depth_limit: 0
}

base_url = "http://syllabus.jimu.kumamoto-u.ac.jp/kusy_detail.php?nendo="+year+"&scd="+scd+"&jcd="
attributes = ["授業科目名(日本語)","授業科目名(英語)","時間割コード","開講年次", 
              "学期","曜日・時限","科目コード","科目分類", "選択／必修", "単位数",
              "講義題目","担当教員","教科書","担当教員氏名","担当教員所属"]

# タイトル表示
attributes.each do |title|
	print title + "\t"
end
print "\n"

cnt = 1

jcd_list.each do |jcd|
	url = base_url + jcd
	values     = []

	Anemone.crawl(url, opts) do |anemone|
		anemone.on_every_page do |page|

			# 授業科目名
			page.doc.xpath("/html/body//table[@class='detail']//td[@class='kamokumei']").each do |node|
				values.push(node.xpath("./text()").to_s)
			end		
			
			# 時間割コード, 開講年次, 学期, 曜日・時限, 科目コード, 
			# 科目分類,選択／必修, 単位数
			page.doc.xpath("/html/body//table[@class='detail']//td[@class='basic1']").each do |node|
				values.push(node.xpath("./text()").to_s)
			end

			# 講義題目, 担当教員
			page.doc.xpath("/html/body//table[@class='detail']//td[@class='basic2']").each do |node|
				values.push(node.xpath("./text()").to_s)
			end
			
			# 教科書
			page.doc.xpath("/html/body//table[@class='detail']//text").each do |node|
				values.push(node.xpath("./text()").to_s)
			end
			
			# 担当教員氏名
			#page.doc.xpath("/html/body//table[@class='detail']//td[@class='kyoin1']").each do |node|
			#	values.push(node.xpath("./text()").to_s)
			#end
			# 担当教員所属
			#page.doc.xpath("/html/body//table[@class='detail']//td[@class='kyoin2']").each do |node|
			#	values.push(node.xpath("./text()").to_s)
			#end
		end
	end

	# 表示
	i = 0
	values.each do |val|
		# 改行空白を除去して表示
		print val.to_s.gsub(/(\s)/," ") + "\t"
		#puts attributes[i].to_s + "\t: " + val.to_s
		#i += 1
	end
	puts "\n"
	#puts "---------------------------------\n"
	warn cnt.to_s + "/" + jcd_list.length.to_s + "\r"
	cnt += 1
end
