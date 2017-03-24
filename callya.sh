#/bin/bash
#var
callya_file=/tmp/callya_usage;
timenow=$(date "+%s");

function check_callya
{
	if [ ! -f $callya_file ];
	then wget -q --output-document=$callya_file wap.meincallya.de/dr/s/ch;
	fi
	
	
	callya_timestamp=$(stat -c %Z $callya_file);
	age_callya_stat=$((timenow - callya_timestamp));
	if  [[ $age_callya_stat -gt 14400 ]];
	then wget -q --output-document=$callya_file wap.meincallya.de/dr/s/ch;
	fi;
}

#cmd
case "$1" in
  "balance")
	check_callya
	sed -n -e 's/^.*Guthaben:.*> \([[:digit:]]*\),\([[:digit:]]*\).*$/\1.\2/p' $callya_file
	;;
  "number")
	check_callya
	sed -n -e 's/^.*Meine Rufnummer: \([[:digit:]]*\).*$/\1/p' $callya_file
	;;
  "mb1")
	check_callya
	sed -n  -e 's/^.*Highspeed-MB.*> \([[:digit:]]*,*[[:digit:]]*\).*$/\1/p' $callya_file | sed -e 's/,/./g'
	;;
  "mb2")
	gbtotal=$(sed -n  -e 's/^.*B von \([[:digit:]]*.*[[:digit:]]*,*[[:digit:]] *\).*$/\1/p' $callya_file | sed -e 's/\.//g');let "mbtotal = gbtotal  * 1024"; echo $mbtotal
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