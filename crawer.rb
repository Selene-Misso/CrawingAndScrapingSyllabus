require 'nokogiri'
require 'anemone'
require 'csv'

opts = {
	depth_limit: 0
}

url = "http://syllabus.jimu.kumamoto-u.ac.jp/kusy_detail.php?nendo=2014&scd=58&jcd=07092"

attributes = ["授業科目名(日本語)","授業科目名(英語)","時間割コード","開講年次", 
              "学期","曜日・時限","科目コード","科目分類", "選択／必修", "単位数",
              "講義題目","担当教員","教科書","担当教員氏名","担当教員所属"]
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
		page.doc.xpath("/html/body//table[@class='detail']//td[@class='kyoin1']").each do |node|
			values.push(node.xpath("./text()").to_s)
		end
		# 担当教員所属
		page.doc.xpath("/html/body//table[@class='detail']//td[@class='kyoin2']").each do |node|
			values.push(node.xpath("./text()").to_s)
		end
	end
end

# 表示
i = 0
values.each do |val|
	puts attributes[i] + "\t: " + val
	i += 1
end

# CSV出力
rows = [attributes, values]
CSV.open("output.csv", "wb") do |csv|
	rows.each do |line|
		csv << line
	end
end