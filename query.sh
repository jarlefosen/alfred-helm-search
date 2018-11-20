#!/bin/bash

which /usr/local/bin/helm >> /dev/null
if [ $? -ne 0 ]; then 
	cat nohelm.json
	exit 1
fi

query="$1"

json_begin='{"items": ['

item_delim=""
json_items=$(/usr/local/bin/helm search "$query" | /usr/local/bin/gtail -n+2 | tr '\t' ' ' | tr -s ' ' | while read line;
	do
	chart=$(echo $line | cut -f 1 -d ' ' );
	chart_version=$(echo $line | cut -f 2 -d ' ');
	app_version=$(echo $line | cut -f 3 -d ' ');
	description=$(echo $line | cut -f 4- -d ' ');

	echo -n $item_delim '{ "arg":"'$chart'"'
	echo -n ',"uid":"'$chart'"'
	echo -n ',"title":"'$chart $chart_version'"'
	echo -n ',"subtitle":"'App version: $app_version - $description'"'
	echo -n '}'
	item_delim=","
	done;
);

json_end=']}'
echo $json_begin $json_items $json_end


