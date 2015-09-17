# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'nokogiri'
require 'open-uri'

PAGE_URL = "http://www.languagedaily.com/learn-german/vocabulary/common-german-words"

page = Nokogiri::HTML(open(PAGE_URL))

page.css("table tr").each do |tr|
  original_text = tr.css("td.bigLetter").text
  translated_text = tr.css("td.bigLetter + td").text
  Card.create(original_text: original_text, translated_text: translated_text)
end

