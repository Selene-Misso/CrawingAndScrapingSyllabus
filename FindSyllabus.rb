require 'nokogiri'
require 'anemone'

opts = {
	depth_limit: 1
}

url = "http://syllabus.jimu.kumamoto-u.ac.jp/kusy_result.php?nendo=2014&scd=05&limit=100&offset=1"


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
			print node.xpath(".//td[@class='no2']/text()").to_s + "\t"
			print node.xpath(".//td[@class='kamoku2']/a/text()").to_s + "\t"
			print node.xpath(".//td[@class='kamoku2']/a/@href").to_s + "\t"
			print node.xpath(".//td[@class='kaiko_nenji2']/text()").to_s + "\t"
			print node.xpath(".//td[@class='gakki2']/text()").to_s + "\t"
			print node.xpath(".//td[@class='tanisu2']/text()").to_s + "\t"
			print node.xpath(".//td[@class='kyoinmei2']/text()").to_s + "\t"
			print "\n"
		end
	end
end