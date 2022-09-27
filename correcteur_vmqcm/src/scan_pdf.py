from pyzbar.pyzbar import decode
from PIL import Image

import cv2
import numpy as np
import math


def recherche_ligne_separation(img, image):
    """
    Recherche de la ligne qui sépare les questions des réponses
    """

    def recherche_ligne(img, x, y, dx_max, dy_max):
        """ Recherche de la ligne de séparation """
        for dx in range(x, x+dx_max, int(dx_max/abs(dx_max))):
            for dy in range(y, y+dy_max, -1):
                if img[dy][dx] < 120:
                    return (dx, dy)
        return None

    debut, fin = recherche_ligne(img, 0, 4100, 300, -500), recherche_ligne(img, 3600-1, 4200, -300, -600)

    if debut is None or fin is None:
        if debut is None:
            print("debut")
        if fin is None:
            print("fin")
        print(image)
        cv2.imshow('matrice', img)
        cv2.waitKey(0)
        exit(1)

    return debut, fin


def scan_qrcode(img, image):
    decodeQR = decode(Image.fromarray(img))
    try :
        dataQR = decodeQR[0].data.decode('ascii')
    except IndexError:
        print(f"{image} - QRcode non détecté")
        return [None for i in range(20)]

    rect = decodeQR[0].rect

    questions, reponseQR = dataQR.split("Q")
    bonnes_reponses = [reponseQR[2*i+2] for i in range(int(questions))]
    points = [int(reponseQR[2*i+1]) for i in range(int(questions))]

    return bonnes_reponses, int(questions), rect, points


def detecter_reponse(img, question, x, y, taille, decal):
    # on détecte la réponse à une question
    x1, y1 = x + int(decal*(question-1)), y
    x2, y2 = x1+taille, y1+taille

    def ajouter_valeur(img, y, x, zone):
        valeur = img[y][x]
        if valeur < 150:
            zone[1] += 0
        else:
            zone[1] += valeur

    choix = ['A', 'B', 'C', 'D']
    zones = [[c, 0] for c in choix]

    for x in range(x1, x2):
        for (i, zone) in enumerate(zones):
            for y in range(int(y1+i*decal), int(y2+i*decal)):
                zone[1] += img[y][x]
                img[y][x] = 127
    
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

def decalage(img, xdecal, ydecal):
    # décale l'image pour qu'elles soient toutes alignées
    img = np.roll(img, -xdecal, axis=1)
    img = np.roll(img, -ydecal, axis=0)

    return img

def scan(image):
    """
    On garde uniquement la partie de la feuille qui contient les réponses.
    threshold : passage en noir et blanc pour mieux détecter les réponses
    rotation et translation  pour bien détecter les réponses et aligner les feuilles entre elles
    """

    # Lecture de l'image
    img = cv2.imread(image, cv2.IMREAD_GRAYSCALE)

    # On recherche la ligne de séparation
    debut, fin = recherche_ligne_separation(img, image)
    img3 = decalage(img, debut[0], debut[1])

    # On tourne l'image
    matrice_rotation = cv2.getRotationMatrix2D((0,0), 57*math.atan2(fin[1]-debut[1], fin[0]-debut[0]), 1)
    img4 = cv2.warpAffine(img3, matrice_rotation, (img3.shape[1], img3.shape[0]))

    # On découpe l'image et on applique une valeur seuil
    img5 = img4[0:1000, 0:3500]
    ret, img6 = cv2.threshold(img5, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

    # On scan le QRcode
    bonnes_reponses, nombre_de_questions, rect, points = scan_qrcode(img6, image)
    decalx = rect.left - 297
    decaly = rect.top - 118

    # On renvoie le résultat
    reponses = []
    for question in range(1, nombre_de_questions+1):
        reponses.append(detecter_reponse(img6, question, 1871 + decalx, 201 + decaly, 47, 68.5))

    niveau = detecter_donnee_eleve(img6, ['6ème', '5ème', '4ème', '3ème'], 1102 + decalx , 113 + decaly, 26, 68)
    classe = detecter_donnee_eleve(img6, ['A', 'B', 'C', 'D', 'E', 'F'], 1238 + decalx, 113 + decaly, 26, 68)
    dizaine = detecter_donnee_eleve(img6, list(range(10)), 1462 + decalx, 113 + decaly, 26, 68)
    unite = detecter_donnee_eleve(img6, list(range(10)), 1599 + decalx, 113 + decaly, 26, 68)

    #cv2.imshow('matrice', img6)
    #cv2.waitKey(0)

    return (bonnes_reponses, reponses, points, niveau, classe, dizaine*10+unite, reponses)

