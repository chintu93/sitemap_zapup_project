#!/bin/bash
exec 1> sitemap.xml
echo "<?xml version="1.0" encoding="UTF-8"?>" >> sitemap.xml
echo "<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">" >> sitemap.xml
x=$(cat try.json)
for row in $(echo "${x}" | jq -r '.[] | @base64'); do
	_jq() {
		echo ${row} | base64 --decode | jq -r ${1}
	}
echo "<url>" >> sitemap.xml
echo "<loc>$(_jq '.url')</loc>" >> sitemap.xml
echo "<lastmod>$(_jq '.lastmod_date')</lastmod>" >> sitemap.xml
echo "<freq>weekly</freq>" >> sitemap.xml
echo "<priority>0.8</priority>" >> sitemap.xml
echo "</url>" >> sitemap.xml
done

