from pyzbar.pyzbar import decode
from PIL import Image
from math import atan2, pi
from sys import argv

import cv2
import numpy as np
import random
import csv


def scan_qrcode(img, image):
    decodeQR = decode(Image.fromarray(img))
    try :
        dataQR = decodeQR[0].data.decode('ascii')
    except IndexError:
        print(f"{image} - QRcode non détecté")
        return None

    # On récupère l'angle de rotation du QRCODE
    qrcode = decodeQR[0]
    poly = qrcode.polygon
    rect = qrcode.rect

    angle = atan2(poly[1].y - poly[0].y, poly[1].x - poly[0].x)*180/pi

    centre = ((poly[2].x + poly[0].x)/2, (poly[2].y + poly[0].y) / 2)

    nbr_questions, rep, pts = dataQR.split("-")
    questions = int(nbr_questions[:-1])
    bonnes_reponses = [rep[i+4] for i in range(questions)]
    points = [int(pts[i+4]) for i in range(questions)]

    return rect.left, rect.top, angle, centre, bonnes_reponses, questions, points


def position_qrcode(img, image):
    decodeQR = decode(Image.fromarray(img))
    try :
        dataQR = decodeQR[0].data.decode('ascii')
    except IndexError:
        print(f"{image} - QRcode non détecté")
        return None

    return decodeQR[0].rect

def detecter_reponse(img, question, x, y, taille, decal, bonne_reponse):
    # on détecte la réponse à une question
    x1, y1 = x + int(decal*(question-1)), y
    x2, y2 = x1+taille, y1+taille

    def ajouter_valeur(img, y, x, zone):
        valeur = img[y][x]
        if valeur < 150:
            zone[1] += 0
        else:
            zone[1] += valeur

    choix = ['A', 'B', 'C', 'D', 'E']
    zones = [[c, 0] for c in choix]

    for x in range(x1, x2):
        for (i, zone) in enumerate(zones):
            for y in range(int(y1+i*decal), int(y2+i*decal)):
                zone[1] += img[y][x]
                if zone[0] == bonne_reponse:
                    img[y][x] = 95 + random.randint(-15,15)
                else:
                    img[y][x] = 200
    
    possibilites = [(l, z/(taille*taille)) for (l,z) in zones]
    reponse = min(possibilites, key=lambda x: x[1])

    if reponse[1] < 237:
        return reponse[0]
    else:
        return None

def detecter_donnee_eleve(img, choix, x1, y1, taille, decal):
    zones = [[c, 0] for c in choix]
    x2, y2 = x1+taille, y1+taille
    
    for x in range(x1, x2):
        for (i, zone) in enumerate(zones):
            for y in range(y1+i*decal, y2+i*decal):
                zone[1] += img[y][x]
                img[y][x] = 127
    
    possibilites = [(c, z/(taille**2)) for (c, z) in zones]
    reponse = min(possibilites, key=lambda x: x[1])

    if reponse[1] < 237:
        return reponse[0]
    else:
        return 0

def scan(image):
    """
    On garde uniquement la partie de la feuille qui contient les réponses.
    threshold : passage en noir et blanc pour mieux détecter les réponses
    rotation et translation  pour bien détecter les réponses et aligner les feuilles entre elles
    """

    # Lecture de l'image + filtrage
    img = cv2.imread(image, cv2.IMREAD_GRAYSCALE)
    ret, img = cv2.threshold(img, 185, 255, cv2.THRESH_BINARY)

    #cv2.imwrite("tmp_qr.png", img)

    # On recherche le QRCODE
    position_x, position_y, angle, centre, bonnes_reponses, nombre_de_questions, points = scan_qrcode(img, image)
    print(angle)

    # On réduit l'image au QRCODE et aux réponses
    #img = img[position_y-500:position_y+200][:]

    # On tourne l'image
    #matrice_rotation = cv2.getRotationMatrix2D(centre, angle, 1)
    #img = cv2.warpAffine(img, matrice_rotation, (img.shape[1], img.shape[0]))
    #cv2.imwrite("tmp2.png", img)

    decalx = position_x
    decaly = position_y

    # On renvoie le résultat
    reponses = []
    for question, bonne_reponse in zip(range(1, nombre_de_questions+1), bonnes_reponses):
        reponses.append(detecter_reponse(img, question, 1047 + decalx, decaly + 5, 30, 45, bonne_reponse))

    niveau = detecter_donnee_eleve(img, ['6ème', '5ème', '4ème', '3ème'], 530 + decalx , decaly - 8, 18, 45)
    classe = detecter_donnee_eleve(img, ['A', 'B', 'C', 'D', 'E', 'F'], 621 + decalx, decaly - 8, 18, 45)
    dizaine = detecter_donnee_eleve(img, list(range(10)), 773 + decalx, decaly - 8, 18, 45)
    unite = detecter_donnee_eleve(img, list(range(10)), 864 + decalx, decaly - 8, 18, 45)

    cv2.imwrite(image + "_matrice.jpeg", img)

    #cv2.imshow("matrice", img)
    #cv2.waitKey(0)
    #exit(0)

    return (bonnes_reponses, reponses, points, niveau, classe, dizaine*10+unite)

def _csv(url):
    with open(url, 'r') as fichier_eleves:
        donnees_eleves = csv.reader(fichier_eleves)
        liste = []
        for eleve in donnees_eleves:
            liste.append(eleve)

    return liste


if __name__ == "__main__":
    url_image, url_csv = argv[1], argv[2]
    bonnes_reponses, reponses, points, niveau, classe, numero = scan(url_image)
    from traitement_donnees import trouver_eleve, calcul_note
    nom, prenom, niveau, classe = trouver_eleve(_csv(url_csv), niveau, classe, numero)
    note = calcul_note(bonnes_reponses, reponses, points)
    print(f'{note} -> {nom} {prenom} ---- {niveau}{classe} ---- file:{url_image}')

