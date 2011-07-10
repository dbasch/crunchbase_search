#!/usr/bin/ruby

require 'rubygems'
require 'indextank'
require 'json'
require 'yaml'

config = YAML::load(File.open('config.yaml'))
api = IndexTank::Client.new config['api_url']
categories = config['categories'].split('|').map{|x| x.split(",")}

idxname = config['index_name']
index = api.indexes idxname
if not index.exists?
  index.add({:public_search => true})
  while not index.running?
    sleep 0.5
    printf "waiting for index %s to be ready...\n", idxname
  end
end
printf "Ready.\n"


batches = 0
categories.each do |c|
  things = JSON.parse(File.read('data/' +c[1] + '.js'))
  count = 0
  docs = []
  things.each_with_index do |x, i| 
    description = c[0]
    f = 'data/' + c[1] + '/' + x['permalink'] + '.js'
    begin
      props = JSON.parse(File.read(f))
    rescue => e
      next
    end
    if description == "person"
      name = props['first_name'] + ' ' + props['last_name']
    else
      name = props['name']
    end
    rel = 0
    products = 0
    if description == 'company' #make companies more likely to be a top result
      rel = props['relationships'].length
      products = props['products'].length
    end
    overview = Math.log(1 + (props['overview'] or '').length)
    url = props['crunchbase_url']
    t = props['image']
    if t
      thumbnail = 'http://www.crunchbase.com/' + props['image']['available_sizes'][0][-1]
    else
      thumbnail = 'http://www.gravatar.com/avatar/00000000000000000000000000000000?default=mm'
    end
    docs << { :docid => url, 
      :fields => {:name => name, :thumbnail => thumbnail, :url => url, :description => description} , 
      :variables => {0 => rel, 1 => products, 2 => overview}}
      count +=1
      if count == 3000 or i == (things.length  - 1)
        response = index.batch_insert(docs)
        batches += 1
        puts "batches: ", batches, docs.length
        docs = []
        count = 0
      end
    end
  end
