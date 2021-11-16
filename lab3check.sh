#!/bin/bash

#display help information
help()
{
echo
echo "This script should be in the same directory as your students' namemessage.mac files. In the parent directory there should be a directory called lab1docs which contains your students' namesymkey.bin and namemessage.txt files (submitted to you by students after Crypto Lab 1, and the txt file was decrypted). This script takes one argument which should be a text file that contains the names of your students (the name they are using for naming their files) one per line. The script will iterate through the student names in the file generating an hmac code for each message.txt file and then compare the hmac to what the student submitted. If the hmac files match the script will display name: OK; otherwise it will display name: Not OK."
echo
echo "Syntax: lab2check.sh [-h] namefile"
echo
echo "options:"
echo
echo "h      Print this help"
echo
}

#Get options
while getopts ":h" option; do
   case $option in
      h) #Display help
         help
         exit;;
     \?) #incorrect option
         echo "Error: Invalid option"
	 exit;;
   esac
done

if [[ $# -eq 0 ]]
then
   echo "You must provide a file with a list of student names. See -h for more information."
   exit 1
fi

filename=$1
while read line; do
fileone="${line}symkey.bin"
filetwo="${line}message.mac"
filethree="${line}message.txt"
cp ../lab1docs/$filethree ./
openssl dgst -sha256 -mac hmac -macopt hexkey:$(cat ../lab1docs/$fileone) -out checkmessage.mac $filethree
var1=`cmp $filetwo checkmessage.mac`
if [[ -z "$var1" ]]
then
   echo "${line}: OK" >> classLab3Results.txt
else
   echo "${line}: Not OK" >> classLab3Results.txt
fi
rm checkmessage.mac
rm $filethree
done < $filename
