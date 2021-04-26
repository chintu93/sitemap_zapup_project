#!/bin/bash
###################################
# 500apps-sites sitemap generator #
###################################

FREQUENCY="daily"

# date with time zone as ref 
# https://www.sitemaps.org/protocol.html
LASTMOD=$(date "+%Y-%m-%dT%H:%M:%S+00:00")

# The priority of this URL relative to other 
# URLs on your site. Valid values range from
# 0.0 to 1.0.
# marketing team needs 1 for all pages
PRIORITY=1.0

# loop over sites folders downloaded from S3
for sites in */ ; do
	
	# preparing env
    FOLDER_NAME=$(echo $sites | sed -e "s/\///g")
    SITE_NAME=$(echo $FOLDER_NAME | sed -e "s/-/\./g")
    SITEMAP_PATH=$FOLDER_NAME/sitemap.xml

    echo -e "creating sitemap for $SITE_NAME \n"

    # initialize sitemap header
    echo '<?xml version="1.0" encoding="UTF-8"?>' > $SITEMAP_PATH
	echo -e '\t<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' >> $SITEMAP_PATH

	# for index/home page
	echo -e "\t<url>" >> $SITEMAP_PATH
	echo -e "\t\t <loc>https://$SITE_NAME</loc>" >> $SITEMAP_PATH
	echo -e "\t\t <lastmod>$LASTMOD</lastmod>" >> $SITEMAP_PATH
	echo -e "\t\t <changefreq>$FREQUENCY</changefreq>" >> $SITEMAP_PATH
	echo -e "\t\t <priority>$PRIORITY</priority>" >> $SITEMAP_PATH
	echo -e "\t</url>" >> $SITEMAP_PATH


	# for other pages
    find $FOLDER_NAME -name "*.html" ! -name "index.html" -print0 | while read -d $'\0' PAGES
	do
		PAGE_NAME=$(echo $PAGES | sed -e "s/$FOLDER_NAME//g" | sed -e "s/\.html//g")
		echo -e "\t<url>" >> $SITEMAP_PATH
		echo -e "\t\t <loc>https://$SITE_NAME$PAGE_NAME</loc>" >> $SITEMAP_PATH
		echo -e "\t\t <lastmod>$LASTMOD</lastmod>" >> $SITEMAP_PATH
		echo -e "\t\t <changefreq>$FREQUENCY</changefreq>" >> $SITEMAP_PATH
		echo -e "\t\t <priority>$PRIORITY</priority>" >> $SITEMAP_PATH
		echo -e "\t</url>" >> $SITEMAP_PATH
	done

	# closing xml tag
	echo "</urlset>" >> $SITEMAP_PATH

	echo -e "created sitemap.xml for $SITE_NAME\n"
done
