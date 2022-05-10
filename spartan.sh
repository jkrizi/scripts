#!/bin/bash
echo What is the eventId?
read eventId
echo What is the title?
read title
echo How many pages would you like to scrap?
read maxPage

function call_and_output {
	request='https://spartanrace.onlinesystem.cz/Events/StartList?eventid='"$eventId"'&title='"$title"'&page='"$1"
	echo $request
	curl -o page.txt $request
}

echo '<table>' > table.html

call_and_output 1
awk '/<table[a-z ="-]*>/{flag=1; next} /<\/tbody>/{flag=0} flag' page.txt >> table.html

for i in $(seq 2 $maxPage)
do
	call_and_output $i
	awk '/<\/thead>/{flag=1; next} /<\/tbody>/{flag=0} flag' page.txt >> table.html
done

echo '</tbody>' >> table.html
echo '</table>' >> table.html
rm page.txt
