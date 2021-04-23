#!/bin/bash
ALL_SITES=$(cat sites.json)
          for sites in $(echo "$ALL_SITES" | jq -r 'keys[] as $k | "\($k) \(.[$k])" | @base64'); do
            SITE_DATA=$(echo $sites | base64 --decode)
            site_folder=$(echo $SITE_DATA | awk '{ print $1 }' | sed "s/\./-/g")
            site_name=$(echo $SITE_DATA | awk '{ print $1 }')
            for f in $site_folder;
            do
                    mkdir -p /home/ubuntu/data/"$f"
                    #aws s3 cp s3://500apps-sites/"$f"/ /home/ubuntu/data/"$f" --recursive
                    mkdir -p /home/ubuntu/ftmp/"$f"
                    #find /home/ubuntu/data/"$f"/ -type f -name '*.html' -exec cp {} /home/ubuntu/ftmp/"$f"/ \;
                    mkdir -p /home/ubuntu/output/"$f"
                    rsync -av --exclude '*safari.html' /home/ubuntu/ftmp/"$f"/ /home/ubuntu/output/"$f"/ --no-i-r
                    find /home/ubuntu/output/"$f"/ -name 'index.html' | mv "/home/ubuntu/output/"$f"/index.html" "/home/ubuntu/output/"$f"/$site_name"
                    cp /home/ubuntu/mapgen* /home/ubuntu/output
                    /bin/bash /home/ubuntu/mapgen.sh;
            done;
    done

