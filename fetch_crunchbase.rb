#!/usr/bin/ruby

#Fetch everything from the Crunchbase API
#warning: don't hammer the API. Set PAUSE to a reasonable value.

PAUSE=0.2

require 'rubygems'
require 'indextank'
require 'json'
require 'open-uri'

def fetch(name, uri)
  begin
    f = File.open(name, 'w')
    puts uri
    f.write(open(uri).read)
    f.close
    sleep PAUSE
  rescue
    puts 'error'
  end
end

categories = [ ['person', 'people'], 
  ['company', 'companies'], 
  ['product', 'products'], 
  ['financial-organization', 'financial-organizations']]

categories.each do |c|
  puts 'fetching ' + c[1]
  JSON.parse(File.read('data/' + c[1] + '.js')).each do |x| 
    toget = 'http://api.crunchbase.com/v/1/' + c[0] + '/' + x['permalink'] + '.js'
    fetch('data/' + c[1] + '/' + x['permalink'] +'.js', toget)
  end
end