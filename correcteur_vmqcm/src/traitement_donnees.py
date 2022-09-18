import csv
import fitz
import io
import os
import sys
import time

import fitz
from PIL import Image


def traitement_fichiers(argv):
    if (len(argv) != 3):
        print("Usage : python correction.py FICHIER_PDF FICHIER_ELEVES")
        exit(1)

    url_fichier_pdf = argv[1]
    url_fichier_eleves = argv[2]


    with open(url_fichier_eleves, 'r') as fichier_eleves:
        donnees_eleves = csv.reader(fichier_eleves)
        liste = []
        
        for eleve in donnees_eleves:
            liste.append(eleve)

    return extraire_images(url_fichier_pdf), liste


def extraire_images(url_fichier_pdf):
    # Les images trouvées dans le pdf sont stockées dans ce dossier
    sous_dossier = "images"
    # S'il n'existe pas, on crée le sous-dossier
    if not os.path.exists(sous_dossier):
        os.mkdir(sous_dossier)


    def recoverpix(doc, item):
        """ 
        Cette fonction récupère les données et métadonnées d'une image du document pdf
        """
        xref = item[0]
        return doc.extract_image(xref)


    fname = url_fichier_pdf
    doc = fitz.open(fname)

    page_count = doc.page_count  # nombre de pages

    xreflist = []
    imglist = []
    for pno in range(page_count):
        il = doc.get_page_images(pno)
        for img in il:
            xref = img[0]
            if xref in xreflist:
                continue
            width = img[2]
            height = img[3]
            image = recoverpix(doc, img)
            n = image["colorspace"]
            imgdata = image["image"]

            imgfile = os.path.join(sous_dossier, "img%05i.%s" % (xref, image["ext"]))
            fout = open(imgfile, "wb")
            fout.write(imgdata)
            fout.close()

            imglist.append(imgfile)
            xreflist.append(xref)


    imglist = list(set(imglist))
    imglist.sort()
    return imglist


def trouver_eleve(donnees_eleves, niveau, classe, numero):
    print(niveau, classe, numero)
    for donnees in donnees_eleves:
        if niveau == donnees[0] and classe == donnees[1] and numero == int(donnees[4]):
            return (donnees[2], donnees[3], donnees[0], donnees[1])
        
    return ("INCONNU", "inconnu", niveau, classe)

def calcul_note(bonnes_reponses, reponses):
    print(bonnes_reponses, reponses)
    note = 0
    vrai, faux = 0, 0
    for (reponse, correction) in zip(reponses, bonnes_reponses):
        if reponse is None:
            note += 0
        elif reponse == correction:
            vrai += 1
        else:
            faux += 1

    return vrai - faux / 3.0

def f(s):
    return [l if l in ['A', 'B', 'C', 'D'] else None for l in s]

if __name__ == "__main__":
    a, b, c, d = 'A', 'B', 'C', 'D'
    note = calcul_note(f("CCBBBAABDCCDCCCBAADC"), f("CCB0BA0C0CCBC0AB0000"))
    print(note)