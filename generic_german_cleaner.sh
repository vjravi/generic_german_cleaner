#!/bin/bash
# Desc: Generic cleaner for text corpora. 
#       Keeps all punctuations and all acceptable german letters and special characters

# Usage: ./generic_german_cleaner.sh -i <input_file> -o <output_file>

# Regex rules in place
# 1. Remove all characters except [^A-Za-z0-9äöüÄÖÜßé\’\„\“\«\»\“\”\'\´\"\.\?\!\:\;\,\ \t\n\@\%\&\!\$\€\£\§\°\#\|\>\<\\\/\^\~\(\)\{\}\+\*\=(&amp)\_\–\—\-\—\–\-]
# 2. Remove \- \— \– when not sandwiched between words such as Text-to-Speech or when before a number such as -10. 
#    This is done using regex "-(?=[\s\-—–])|(?<=[\s\-—–])-(?=[^0-9])|—(?=[\s\-—–])|(?<=[\s\-—–])—(?=[^0-9])|–(?=[\s\-—–])|(?<=[\s\-—–])–(?=[^0-9])". 
#    Sadly, lookahead andlookbehind are not supported by sed, so we have to use perl.
# 3. Replace &amp by & -------------> Found a lot in HTML pages
# 4. Remove all empty lines


while getopts ":i:o:" option; do
    case "${option}" in
        i)
            input_file=${OPTARG}
            ;;
        o)
            output_file=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

echo "Input file: ${input_file}"
echo "Output file: ${output_file}"


cat $input_file | sed -r "s/[^]A-Za-z0-9äöüÄÖÜßé\’\„\“\«\»\“\”\'\´\"\.\?\!\:\;\,\ \t\n\@\%\&\!\$\€\£\§\°\#\|\>\<\\\/\^\~\(\)\{\}\+\*\=(&amp)\_\–\—\-\—\–\-\[]//g" | sed 's/\&amp/\&/g'  | perl -C -pe "s/[-—–](?=[\s\-—–])|(?<=[\s\-—–])[-—–](?=[^0-9])//g" | sed '/^\s*$/d' >  $output_file
