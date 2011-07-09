#!/usr/bin/ruby

require 'rubygems'
require 'indextank'
require 'json'
require 'open-uri'

def fetch(name, uri)
    f = File.open(name, 'w')
    f.write(open(uri).read)
    f.close
end


people = JSON.parse(File.read('data/people.js'))
people.each do |x| 
    begin
        toget = 'http://api.crunchbase.com/v/1/person/' + x['permalink'] + '.js'
        puts toget
        fetch('data/people/' + x['permalink'] +'.js', toget)
    rescue
        puts 'error'
    end
end

