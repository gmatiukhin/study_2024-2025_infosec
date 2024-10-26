#!/bin/fish

echo -n "Goodbye, TEMPLATE" > template.txt
sed 's/TEMPLATE/world/' template.txt > clear1.txt

echo -n "super secret message" > clear2.txt

set -l len (string length (bat clear1.txt))
set -l len1 (string length (bat clear2.txt))
set -l len2 (string length (bat template.txt))

if test $len1 -ge $len
  set len $len1
end

if test $len2 -ge $len
  set len $len2
end

string pad -r -c '=' -w $len (bat template.txt) | tr -d '\n' > template.pad.txt
string pad -r -c '=' -w $len (bat clear1.txt) | tr -d '\n' > clear1.pad.txt
string pad -r -c '=' -w $len (bat clear2.txt) | tr -d '\n' > clear2.pad.txt

openssl rand -base64 $len | head -c $len > key.txt

python main.py -a clear1.pad.txt -b key.txt -O cipher1.txt
printf '\n'
python main.py -a clear2.pad.txt -b key.txt -O cipher2.txt
