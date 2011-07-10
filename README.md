Instant Crunchbase Search
=========================

What it is: a tool to create your own private zero-click Crunchbase search

How to use it:

1) run ./getfiles.sh

This will download the listings for four categories of crunchbase entities:

* people
* companies
* products
* financial-institutions

2) run ./fetch_crunchbase.rb

This will download every single instance from the listings. It can take many hours, better to do it overnight.

3) Get an [IndexTank](http://indextank.com) account, edit config.yaml and replace your private api key

4) run ./index.rb, it will index the data repository in a few minutes

5) replace /your_public_part in web/index.html by the public prefix of your api url (e.g. w3ju4)

If all the above steps worked, you should have a better search UI than Crunchbase's! Point your browser to web/index.html and enjoy.
