"""
    L'objectif de ce programme est de corriger les interrogations générés avec la classe LaTeX "vmqcm.cls".
    
    AVANT D'UTILISER LE PROGRAMME
    -> Scanner toutes les copies des élèves (dans le même sens) et les réunir en un fichier pdf, 
        où chaque page correspond à la copie d'un élève.
    -> Préparer un fichier eleves.csv contenant, pour chaque élève, les informations suivantes :
        nom, prénom, niveau (6ème, 5ème, etc.), classe (A, B, C), numéro élève
    
    DÉROULÉ DU PROGRAMME 
    (pour chaque copie d'élève)
        -> Scanner le QR Code, contenant le nombre de questions, les réponses aux questions, et le nombre de points par question
        -> Scanner les informations élèves
        -> Scanner les réponses de l'élève
        -> Calculer la note de l'élève
    -> Générer un fichier csv avec les informations élèves et leur note
"""


from pyzbar.pyzbar import decode
from PIL import Image
from sys import argv
from tqdm import tqdm

from src.traitement_donnees import traitement_fichiers, trouver_eleve, calcul_note
from src.scan_pdf import scan_qr_code, scan_reponse_eleve


"""
    Utilisation : 
        python correction.py   FICHIER_PDF   FICHIER_ELEVES
"""
def main():
    images_pdf, donnees_eleves = traitement_fichiers(argv)
    input()

    evaluation = []
    for image in tqdm(images_pdf):
        bonnes_reponses = scan_qr_code(image)
        niveau, classe, numero, reponses = scan_reponse_eleve(image)
        eleve = trouver_eleve(donnees_eleves, niveau, classe, numero)
        note = calcul_note(bonnes_reponses, reponses)
        evaluation.append((*eleve, note, numero, image))

    evaluation.sort(key=lambda x: x[0])
    for e in evaluation:
        print(e)

if __name__ == "__main__":
    main()