\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{vmqcm}[2022/07/06 Valentin Mastro QCM class]
\RequirePackage{luacode}

% Le but de cette classe est de créer un QCM qui :
%   - peut afficher juste les questions, ou les questions et les réponses
%   - permet de compter le total des points du QCM
%   - affiche une grille permettant de répondre aux questions, scannable
%   - affiche un QR code donnant les réponses
%   - gère la génération de nombres aléatoires



% Base du document
\LoadClass[10pt]{article}

% Gestion des marges
\RequirePackage[a5paper,margin=1cm]{geometry}
\pagestyle{empty}

% Titre
\newcommand{\VMQCMTitre}[1]{\centerline{\large{#1}} \vspace{3ex}}

% Compteurs
\newcounter{VMQCMNumeroQuestion}
\newcounter{VMQCMTotalPoints}
\newcounter{VMQCMPointsQuestion}
\directlua{solutions = {}}

\newcommand{\VMQCMAjouterSolution}[1]{%
    \directlua{solutions[\theVMQCMNumeroQuestion] = "\theVMQCMPointsQuestion" .. "#1"}%
}

% Ajouter une question au QCM
%           \VMQCMAjouterQuestion{énoncé}{A}{B}{C}{D}{bonne réponse}{point(s)}
\newcommand{\VMQCMAjouterQuestion}[7]{%
    \stepcounter{VMQCMNumeroQuestion}%  
    \setcounter{VMQCMPointsQuestion}{#7}%
    \VMQCMAjouterSolution{#6}%
    \addtocounter{VMQCMTotalPoints}{#7}%
    \scriptsize{\theVMQCMNumeroQuestion} & \scriptsize{#1} & \scriptsize{#2} & \scriptsize{#3} & \scriptsize{#4} & \scriptsize{#5} & \scriptsize{#7~pts} \\\hline
}

% Formatage des questions et des réponses
\RequirePackage{tabularx}
\setlength{\parindent}{0pt}

\newenvironment{VMQCM}{\tabularx{\textwidth}{@{}l|X|p{0.1\textwidth}|p{0.1\textwidth}|p{0.1\textwidth}|p{0.1\textwidth}|r @{}} & \centering Question & \centering A & \centering B & \centering C & \centering D & ~ \\\hline}{\endtabularx}

\newcommand{\VMQCMDebut}{}
     
\newcommand{\VMQCMFin}{\endtabularx}


\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage{qrcode}
% À la fin du document, on affiche la grille de réponse (incluant le niveau [6ème, 5ème, ...], la classe [A, B, C, ...], et le numéro d'élève, ainsi que les réponses aux questions) et le QR code de réponse
\AtEndDocument{
    \vfill
    \directlua{dofile("vmqcm.lua")}
    \makebox[\linewidth]{\rule{\paperwidth}{0.4pt}}
    \begin{tikzpicture}
        % Données élèves
        % NIVEAU (6ème, 5ème, etc.)
        \node[anchor=east] at (0,0) {\footnotesize{\textit{Niveau}}};
        \node[anchor=east] at (0,-0.3) {\tiny{6ème}};
        \node[anchor=east] at (0,-0.6) {\tiny{5ème}};
        \node[anchor=east] at (0,-0.9) {\tiny{4ème}};
        \node[anchor=east] at (0,-1.2) {\tiny{3ème}};
        \directlua{niveau()}
        % CLASSE (A, B, C, etc.)
        \node[anchor=east] at (1.3,0) {\footnotesize{\textit{Classe}}};
        \node[anchor=east] at (1.3,-0.3) {\tiny{A}};
        \node[anchor=east] at (1.3,-0.6) {\tiny{B}};
        \node[anchor=east] at (1.3,-0.9) {\tiny{C}};
        \node[anchor=east] at (1.3,-1.2) {\tiny{D}};
        \node[anchor=east] at (1.3,-1.5) {\tiny{E}};
        \node[anchor=east] at (1.3,-1.8) {\tiny{F}};
        \directlua{classe()}
        % NUMÉRO de l'élève
        \node[anchor=east] at (2.9,0) {\footnotesize{\textit{Numéro}}};
        \directlua{numeroEleve()}
        % Grille de réponse
        \node[anchor=east] at (5,0) {\footnotesize{\textit{Réponses}}};
        \directlua{grille_reponses(\theVMQCMNumeroQuestion)}
        % Encadré pour la note
        \draw (-1.1,-2.7) rectangle (1.1,-3.2);
        \node at (0,-3) {Note : ~~~~/\theVMQCMTotalPoints};
        
        % QR Code
        \node at (-0.35,-2) {\qrcode[height=1.1cm]{\directlua{tex.print("\theVMQCMNumeroQuestion" .. "Q" .. table.concat(solutions))}}};
    \end{tikzpicture}
}