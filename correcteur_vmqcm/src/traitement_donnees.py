import csv
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
    for donnees in donnees_eleves:
        if niveau == donnees[0] and classe == donnees[1] and numero == int(donnees[4]):
            return (donnees[2], donnees[3], donnees[0], donnees[1])
        
    return ("INCONNU", "inconnu", niveau, classe)

def calcul_note(bonnes_reponses, reponses, points):
    note = 0
    vrai, faux = 0, 0
    for (reponse, correction, p) in zip(reponses, bonnes_reponses, points):
        if reponse is None:
            note += 0
        elif reponse == correction:
            vrai += p
        else:
            faux += p

    return vrai - faux / 3.0

def f(s):
    return [l if l in ['A', 'B', 'C', 'D'] else None for l in s]

if __name__ == "__main__":
    liste = []
    liste.append((calcul_note(f("BACBAABADCDBBACA"), f("ACBCADADABACDABD"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 53))
    liste.append((calcul_note(f("CCABBCBDACDCCDBB"), f("BCDBCABCABACBABA"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 39))
    liste.append((calcul_note(f("CDBABBACBDBCDDDB"), f("CDCDCBBABDBBDDBB"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 68))
    liste.append((calcul_note(f("BADBCBDABBCACCBC"), f("BABACBCABBCACCBC"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 44))
    liste.append((calcul_note(f("CABDBDDCBABABBDC"), f("CACBBDDCBABABBCD"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 98))
    liste.append((calcul_note(f("BADDBCCCDBCBCACB"), f("BCDD0C0D0CBCCDCA"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 63))
    liste.append((calcul_note(f("DACCDDBCCABBAABC"), f("DDCCDDBCCABBAABC"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 18))
    liste.append((calcul_note(f("DCBDDCACAACBBDCD"), f("DCBDDCACAACBBDCD"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 19))
    liste.append((calcul_note(f("CABAADDACACBDBAB"), f("CADDADDABACBDCCD"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 24))
    liste.append((calcul_note(f("BDBCBCACAACCDDDB"), f("0000BCACC0000000"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 13))
    liste.append((calcul_note(f("BBCBDCDBCABCCDAD"), f("BACCDCDBDA00AAAA"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 49))
    liste.append((calcul_note(f("ABBDBDBCDBBCDADB"), f("ABBDBDBC0A0CDACC"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 58))
    liste.append((calcul_note(f("DCACBDBCDCDCBDDB"), f("ACBACBCDBCBDBADC"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 29))
    liste.append((calcul_note(f("ABDDBDDCCDCABDCC"), f("ABCCDDDCBDCABDCC"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 23))
    liste.append((calcul_note(f("CADDBADBDCBBABBB"), f("CADDCBDCACBBBABD"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 83))
    liste.append((calcul_note(f("CBADADACCCDBDDCD"), f("CBADADACCCDBDDCD"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 28))
    liste.append((calcul_note(f("BADCBBACADDABCAC"), f("CABCABCBCABDBDCA"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 33))
    liste.append((calcul_note(f("BCADBCACCDCAADBC"), f("BCADDACCCDBDAABD"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 93))
    liste.append((calcul_note(f("DDABCCCBCDDDDBCD"), f("DDABCCCBCDDDDBCD"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 48))
    liste.append((calcul_note(f("AABBBBAADACDCACA"), f("DCCBBCCABCDCAADB"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 63))
    liste.append((calcul_note(f("BACBDBAACDBAAACA"), f("CACBCBABCBDBDCCB"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 78))
    liste.append((calcul_note(f("ADDDDBADCABADBAA"), f("ADBCDBADAABADBBA"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 43))
    liste.append((calcul_note(f("BDDBADBABBDABABC"), f("BDDAADBBBBDABABC"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 43))
    liste.append((calcul_note(f("DDDCDBAACAABBDAA"), f("ABCDDBCBDACDADBA"), [2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ]), 38))
    liste.sort(key=lambda x:x[1])
    for l in liste:
        print(l)