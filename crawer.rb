require 'nokogiri'
require 'anemone'

opts = {
	depth_limit: 0
}

url = "http://syllabus.jimu.kumamoto-u.ac.jp/kusy_detail.php?nendo=2014&scd=58&jcd=07092"

Anemone.crawl(url, opts) do |anemone|
	anemone.on_every_page do |page|
		# 授業科目名
		puts "-----\n"
		attrib = ["授業科目名(日本語)","授業科目名(英語)"]
		i = 0
		page.doc.xpath("/html/body//table[@class='detail']//td[@class='kamokumei']").each do |node|
			title = node.xpath("./text()").to_s
			puts attrib[i].to_s + "\t: " + title
			i += 1
		end		
		
		# 時間割コード, 開講年次, 学期, 曜日・時限, 科目コード, 
		# 科目分類,選択／必修, 単位数
		puts "-----\n"
		attrib = ["時間割コード", "開講年次", "学期", "曜日・時限", 
				"科目コード","科目分類", "選択／必修", "単位数"]
		i = 0
		page.doc.xpath("/html/body//table[@class='detail']//td[@class='basic1']").each do |node|
			title = node.xpath("./text()").to_s
			puts attrib[i].to_s + "\t: " + title
			i += 1
		end
		
		# 講義題目, 担当教員
		puts "-----\n"
		attrib = ["講義題目", "担当教員"]
		i = 0
		page.doc.xpath("/html/body//table[@class='detail']//td[@class='basic2']").each do |node|
			title = node.xpath("./text()").to_s
			puts attrib[i].to_s + "\t: " + title
			i += 1
		end
		
		# テキスト
		puts "-----\n"
		page.doc.xpath("/html/body//table[@class='detail']//text").each do |node|
			title = node.xpath("./text()").to_s
			puts "教科書\t: " + title
		end
		
		# 担当教員, 所属
		puts "-----\n"
		page.doc.xpath("/html/body//table[@class='detail']//td[@class='kyoin1']").each do |node|
			title = node.xpath("./text()").to_s
			puts "担当教員\t: " + title
		end
		page.doc.xpath("/html/body//table[@class='detail']//td[@class='kyoin2']").each do |node|
			title = node.xpath("./text()").to_s
			puts "所属\t: " + title
		end
	end
end
