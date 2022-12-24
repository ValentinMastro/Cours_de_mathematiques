# On scanne la feuille (148x210 -> format A5)
EPOCH=`date +%s%N`
scanimage -d "brother5:bus2;dev2" --format=png --progress --resolution 400 -x 148 -y 210 > "eval9_5B/5B_$EPOCH.png"
python src/scan_pdf_2.py "eval9_5B/5B_$EPOCH.png" data.csv
