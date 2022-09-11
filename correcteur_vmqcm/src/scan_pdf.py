from pyzbar.pyzbar import decode
from PIL import Image

import cv2
import numpy as np
import math


def scan_qr_code(image):
    """
    image : nom du fichier
    """
    decodeQR = decode(Image.open(image))
    dataQR = decodeQR[0].data.decode('ascii')

    questions, reponseQR = dataQR.split("Q")
    bonnes_reponses = [reponseQR[2*i+1] for i in range(int(questions))]

    return bonnes_reponses

def scan_reponse_eleve(image):
    """
    image : nom du fichier
    """

    img = cv2.imread(image, cv2.IMREAD_GRAYSCALE)
    #img2 = cv2.resize(img, (2480,3507), interpolation = cv2.INTER_AREA)

    def recherche_debut_ligne(img):
        # recherche de la ligne de séparation
        x, y = 50, 5470
        debut = None
        for dx in range(150):
            for dy in range(150):
                if img[y-dy][x+dx] < 200:
                    return (x+dx, y-dy)
                    
    def recherche_fin_ligne(img):
        # recherche de la ligne de séparation
        x, y = 4900, 5470
        debut = None
        for dx in range(150):
            for dy in range(150):
                if img[y-dy][x-dx] < 200:
                    return (x-dx, y-dy)

    def decalage(img, xdecal, ydecal):
        # décale l'image pour qu'elles soient toutes alignées
        img = np.roll(img, -xdecal, axis=1)
        img = np.roll(img, -ydecal, axis=0)

        return img

    debut, fin = recherche_debut_ligne(img), recherche_fin_ligne(img)

    if debut is None or fin is None:
        print(image)
        exit(1)
    
    img3 = decalage(img, debut[0], debut[1])
    matrice_rotation = cv2.getRotationMatrix2D((0,0), 50*math.atan2(fin[1]-debut[1], fin[0]-debut[0]), 1)
    img4 = cv2.warpAffine(img3, matrice_rotation, (img3.shape[1], img3.shape[0]))


    def detecter_reponse(img, question):
        # on détecte la réponse à une question
        # 2325, 281
        x1, y1 = 2325 + 96*(question-1), 281
        x2, y2 = x1+80, y1+80

        # moyennes
        zoneA, zoneB, zoneC, zoneD = ['A', 0], ['B', 0], ['C', 0], ['D', 0]
        decal = 95
        for x in range(x1, x2):
            for y in range(y1, y2):
                zoneA[1] += img[y][x]
            for y in range(y1+1*decal, y2+1*decal):
                zoneB[1] += img[y][x]
            for y in range(y1+2*decal, y2+2*decal):
                zoneC[1] += img[y][x]
            for y in range(y1+3*decal, y2+3*decal):
                zoneD[1] += img[y][x]
        
        # minimum
        possibilites = [(l, z/6400) for (l,z) in (zoneA, zoneB, zoneC, zoneD)]
        #print(possibilites)
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
        
        possibilites = [(c, z/(taille**2)) for (c, z) in zones]
        reponse = min(possibilites, key=lambda x: x[1])

        if reponse[1] < 237:
            return reponse[0]
        else:
            return 0


    reponses = []
    for question in range(1, 20+1):
        reponses.append(detecter_reponse(img3, question))

    niveau = detecter_donnee_eleve(img3, ['6ème', '5ème', '4ème', '3ème'], 690, 158, 40, 97)
    classe = detecter_donnee_eleve(img3, ['A', 'B', 'C', 'D', 'E', 'F'], 1108, 158, 40, 97)
    dizaine = detecter_donnee_eleve(img3, list(range(10)), 1432, 158, 40, 97)
    unite = detecter_donnee_eleve(img3, list(range(10)), 1692, 158, 40, 97)

    return (niveau, classe, dizaine*10+unite, reponses)