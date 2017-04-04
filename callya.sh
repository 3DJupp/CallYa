#/bin/bash
prepaid_file=/tmp/prepaid_usage;
timenow=$(date "+%s");

function check_callya
{
	if [ ! -f $prepaid_file ];
	then wget -q --output-document=$prepaid_file wap.meincallya.de/dr/s/ch;
	fi
	
	
	callya_timestamp=$(stat -c %Z $prepaid_file);
	age_callya_stat=$((timenow - callya_timestamp));
	if  [[ $age_callya_stat -gt 14400 ]];
	then wget -q --output-document=$prepaid_file wap.meincallya.de/dr/s/ch;
	fi;
}

#cmd
case "$1" in
  "vfbalance")
	check_callya
	sed -n -e 's/^.*Guthaben:.*> \([[:digit:]]*\),\([[:digit:]]*\).*$/\1.\2/p' $prepaid_file
	;;
  "vfnumber")
	check_callya
	sed -n -e 's/^.*Meine Rufnummer: \([[:digit:]]*\).*$/\1/p' $prepaid_file
	;;
  "vfmb1")
	check_callya
	sed -n -e 's/^.*Highspeed-MB.*> \([[:digit:]]*.*[[:digit:]]*\)MB.*$/\1/p' $prepaid_file | sed -e 's/\.//g' | sed -e 's/,/./g'
	;;
  "vfmb2")
	check_callya
	gbtotal=$(sed -n  -e 's/^.*B von \([[:digit:]]*.*[[:digit:]]*,*[[:digit:]] *\).*$/\1/p' $prepaid_file | sed -e 's/\.//g');let "mbtotal = gbtotal  * 1024"; echo $mbtotal
	;;
  "ip_WAN")
	curl -s wgetip.com;echo
	;;
  "ip_LOC")
	ip route get 1 | awk '{print $NF;exit}'
	;;
  *)
    echo "Wrong parameter"
    exit 1
    ;;
esac
