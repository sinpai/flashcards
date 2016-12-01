# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('http://www.languagedaily.com/learn-german/vocabulary/common-german-words'))
@words, @translations = [], []

doc.xpath('//td[@class="bigLetter"]').each {|el| @words << el.text}
doc.xpath('//td[preceding-sibling::td[@class="bigLetter"]][1]').each {|el| @translations << el.text}
@words.length.times do |i|
  Card.new(original_text: @words[i], translated_text: @translations[i]).save(validate: false)
  print '.' if (i % 25).zero?
end
links = doc.xpath("//ul[preceding-sibling::h3[contains(.,'Index of most common German words')]]/li/a")
links.each do |link|
  @words2, @translations2 = [], []
  doc2 = Nokogiri::HTML(open('http://www.languagedaily.com' + link['href']))
  doc2.xpath('//td[@class="bigLetter"]').each {|el| @words2 << el.text}
  doc2.xpath('//td[preceding-sibling::td[@class="bigLetter"]][1]').each {|el| @translations2 << el.text}
  @words2.length.times do |i|
    Card.new(original_text: @words2[i], translated_text: @translations2[i]).save(validate: false)
    print '.' if (i % 25).zero?
  end
end
