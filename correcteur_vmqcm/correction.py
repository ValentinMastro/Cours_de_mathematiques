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

from os import cpu_count
from pyzbar.pyzbar import decode
from PIL import Image
from sys import argv
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm

from src.traitement_donnees import traitement_fichiers, trouver_eleve, calcul_note
from src.scan_pdf_2 import scan


def corriger_une_page(page, donnees_eleves):
    bonnes_reponses, reponses, points, niveau, classe, numero, eleve = scan(page)
    eleve = trouver_eleve(donnees_eleves, niveau, classe, numero)
    note = calcul_note(bonnes_reponses, reponses, points)

    return (*eleve, note, numero, page)


"""
    Utilisation : 
        python correction.py   FICHIER_PDF   FICHIER_ELEVES
"""
def main():
    pages, donnees_eleves = traitement_fichiers(argv)

    with ThreadPoolExecutor(max_workers = 1) as pool:
        corrections = [pool.submit(corriger_une_page, page, donnees_eleves) for page in pages]
        evaluations = [evaluation.result() for evaluation in as_completed(corrections)]

    evaluations.sort(key=lambda x: (str(x[2]), str(x[3]), x[0]))
    for e in evaluations:
        nom, prenom, niveau, classe, note, numero, image = e
        print(f"{note:2d} {nom} {prenom} {niveau}{classe} num:{numero} image:{image} matrice:{image}_matrice.jpeg")
        
        
if __name__ == "__main__":
    main()