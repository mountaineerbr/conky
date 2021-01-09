#!/usr/bin/python
# argument is given in conky to this script
# in conky : ${execi 10 ~/.conky/Aurora/scripts/rss/rss_python.py http://feeds.gawker.com/lifehacker/full}
import feedparser, sys

rss_url = sys.argv[1]
feed = feedparser.parse( rss_url )
count =  len(feed['entries'])
for i in range(0, count):
	if (i>=10):break
	print '{1}'.format(' ', feed.entries[i].title[0:100].encode('utf8'))
