# A shell script used to prepare the corpus files for indexing.
# Generates word lists, annotates them, runs a convertor and puts
# the resulting JSON files to the appropriate folder.
START_TIME="$(date -u +%s)"
cd src_convertors/corpus/txt
python3 concordancer.py
echo "Word list generated."
cd ..

rm -rf uniparser-grammar-ossetic
git clone https://github.com/timarkh/uniparser-grammar-ossetic.git
cd uniparser-grammar-ossetic
echo "Grammar repository cloned."
mv ../txt/wordlist.csv wordlist.csv
cp ../analyze_ossetic_wordlist.py .
echo "Source files moved."
python3 analyze_ossetic_wordlist.py
mv analyzed.txt ../oss_wordlist.csv-parsed.txt
mv unanalyzed.txt ../oss_wordlist.csv-unparsed.txt
echo "Ossetic word list analyzed."
cd ../..

# Conversion to Tsakorpus JSON
python3 txt2json.py
echo "Source conversion ready."
rm corpus/oss_wordlist.csv-parsed.txt
rm -rf ../corpus/ossetic_iron_main
mkdir -p ../corpus/ossetic_iron_main
mv corpus/json ../corpus/ossetic_iron_main
END_TIME="$(date -u +%s)"
ELAPSED_TIME="$(($END_TIME-$START_TIME))"
echo "Corpus files prepared in $ELAPSED_TIME seconds, finishing now."