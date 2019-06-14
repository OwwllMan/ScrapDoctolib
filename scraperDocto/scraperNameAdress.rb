require 'nokogiri'
require 'httparty'
require 'byebug'
require 'csv'

def scraper
	url = "https://www.doctolib.fr/dermatologue/ile-de-france?page=1"
	unparsed_page = HTTParty.get(url)
	parsed_page = Nokogiri::HTML(unparsed_page)
	doctors = Array.new
	doctor_listings = parsed_page.css('div.dl-search-result-presentation')#10 Doctor
	page = 1
	per_page = doctor_listings.count #Count number of docotor per page 10
	total = 380
	last_page = 43
	while page <= last_page
		pagination_url = "https://www.doctolib.fr/dermatologue/ile-de-france?page=#{page}"
		puts pagination_url
		puts "Page: #{page}"
		puts ""
		pagination_unparsed_page = HTTParty.get(pagination_url)
		pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
		pagination_doctor_listings = pagination_parsed_page.css('div.dl-search-result-presentation')#10 Doctor
		pagination_doctor_listings.each do | doctor_listing|
			doctor = {
				name: doctor_listing.css('a.dl-search-result-name').text,
				adress: doctor_listing.css('div.dl-search-result-content').text
			}
			doctors << doctor
			CSV.open("gastro.csv", "a+") do |csv|
				csv << ["#{doctor[:adress]}"]
			end
			puts "Added #{doctor[:name]}"
			puts ""
		end
		page +=1
	end
	byebug
end

scraper

