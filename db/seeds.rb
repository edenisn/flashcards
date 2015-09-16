# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'nokogiri'
require 'open-uri'

arr_original = [] # array for text (original_text[text])
arr_translated = [] # array for text (translated_text[text])

PAGE_URL = "http://www.languagedaily.com/learn-german/vocabulary/common-german-words"

page = Nokogiri::HTML(open(PAGE_URL))

cards_original_text = page.css("table tr td.bigLetter")
cards_original_text.each { |t| arr_original << t.text }

cards_translated_text = page.css("table tr td.bigLetter + td")
cards_translated_text.each { |t| arr_translated << t.text }

cards_list = arr_original.zip(arr_translated) # cards_list = [ arr_original, arr_translated ]

cards_list.each do |original, translate|
  Card.create(original_text: original, translated_text: translate, review_date: DateTime.now)
end

