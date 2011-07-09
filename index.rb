#!/usr/bin/ruby

require 'rubygems'
require 'indextank'
require 'json'
require 'yaml'

def index(props,description)
  #rel = props['relationships'].length
  #products = props['products'].length
  overview = Math.log(1 + (props['overview'] or '').length)
  url = props['crunchbase_url']
  t = props['image']
  if t
    thumbnail = 'http://www.crunchbase.com/' + props['image']['available_sizes'][0][-1]
  else
    thumbnail = 'http://www.gravatar.com/avatar/00000000000000000000000000000000?default=mm'
  end
  docs << { :docid => url, :fields => {:name => name, :thumbnail => thumbnail, :url => url, :description => description} , :variables => {0 => 0, 1 => 0, 2 => overview}}
  @count +=1
  if @count == 3000 or i == (things.length  - 1)
    response = index.batch_insert(docs)
    batches += 1
    puts "batches: ", batches, docs.length
    docs = []
    @count = 0
  end
end


config = YAML::load(File.open('config.yaml'))
api = IndexTank::Client.new config['api_url']
index = api.indexes "crunchbase"
batches = 0

things = JSON.parse(File.read('data/products.js'))
@count = 0
docs = []
things.each_with_index do |x, i| 
  name = x['name']
  f = 'data/products/' + x['permalink'] + '.js'
  begin
    props = JSON.parse(File.read(f))
  rescue => e
    next
  end
  index(props, 'product')


end
