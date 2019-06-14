require 'nokogiri'
require 'httparty'
require 'byebug'
require 'csv'

def scraper
	url = "https://www.doctolib.fr/dermatologue/ile-de-france?page=1"
	unparsed_page = HTTParty.get(url)
	parsed_page = Nokogiri::HTML(unparsed_page)
	doctors = Array.new
	doctel = Array.new
	doctor_listings = parsed_page.css('div.dl-search-result-presentation')#10 Doctor
	page = 1
	per_page = doctor_listings.count #Count number of docotor per page 10
	total = 380
	last_page = 3
	while page <= last_page
		pagination_url = "https://www.doctolib.fr/dermatologue/ile-de-france?page=#{page}"
		puts pagination_url
		puts "Page: #{page}"
		puts ""
		pagination_unparsed_page = HTTParty.get(pagination_url)
		pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
		pagination_doctor_listings = pagination_parsed_page.css('div.dl-search-result-presentation')#10 Doctor
		pagination_doctor_listings.each do | doctor_listing|
			doctor = doctor_listing.css('a.dl-search-result-name').text
			doctors << doctor
			puts ""
		end
		page +=1
	end
	doctors.each do |name|
		url2 = "https://www.google.com/search?num=1&q=#{name}"
		nnunparsed_page = HTTParty.get(url2)
		uuparsed_page = Nokogiri::HTML(nnunparsed_page)
		telfind = uuparsed_page.css('a.r-i1FkVObCYskY').text
		doctel << telfind
		CSV.open("gastro.csv", "a+") do |csv|
			csv << ["#{telfind}"]
		end
	end
	byebug
end

scraper

