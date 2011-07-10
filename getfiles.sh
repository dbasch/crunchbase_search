#!/bin/bash

mkdir -p data/companies
mkdir data/people
mkdir data/products
mkdir data/financial-organizations

cd data

wget http://api.crunchbase.com/v/1/companies.js
wget http://api.crunchbase.com/v/1/people.js
wget http://api.crunchbase.com/v/1/products.js
wget http://api.crunchbase.com/v/1/financial-organizations.js

cd ..

