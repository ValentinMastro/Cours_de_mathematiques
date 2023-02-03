# On scanne la feuille (148x210 -> format A5)
EPOCH=`date +%s%N`
scanimage -d "brother5:bus2;dev2" --format=png --progress --resolution 400 -x 148 -y 210 > "eval12_4E/4E_$EPOCH.png"
