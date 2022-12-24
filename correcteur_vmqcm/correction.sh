DOSSIER="$1"

for eval in "$DOSSIER"/*.png
do
    python src/scan_pdf_2.py "$eval" data.csv
done
