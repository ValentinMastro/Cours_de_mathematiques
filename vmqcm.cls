\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{vmqcm}[2022/07/06 Valentin Mastro QCM class]
\RequirePackage{luacode}
\LuaCodeDebugOn

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
\directlua{solutions = ""}

\RequirePackage{etoolbox}
\newcommand{\VMQCMAjouterSolution}[1]{
    \ifstrequal{#1}{A}{\directlua{solutions = solutions .. "A"}}{%
        \ifstrequal{#1}{B}{\directlua{solutions = solutions .. "B"}}{%
            \ifstrequal{#1}{C}{\directlua{solutions = solutions .. "C"}}{%
                \ifstrequal{#1}{D}{\directlua{solutions = solutions .. "D"}}{}%
            }%
        }%
    }%
}%

% Ajouter une question au QCM
%           \VMQCMAjouterQuestion{énoncé}{A}{B}{C}{D}{bonne réponse}{point(s)}
\newcommand{\VMQCMAjouterQuestion}[7]{%
    \VMQCMAjouterSolution{#6}
    \stepcounter{VMQCMNumeroQuestion}
    \addtocounter{VMQCMTotalPoints}{#7}
    \theVMQCMNumeroQuestion & #1 & #2 & #3 & #4 & #5 & #7~pts \\\hline
}

% Formatage des questions et des réponses
\RequirePackage{tabularx}
\setlength{\parindent}{0pt}

\newenvironment{vmqcm}{
    \tabularx{\textwidth}{@{}l|X|p{0.1\textwidth}|p{0.1\textwidth}|p{0.1\textwidth}|p{0.1\textwidth}|r @{}}
     & Question & A & B & C & D & ~ \\\hline
}{
    \endtabularx
}


\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage{qrcode}
% À la fin du document, on affiche la grille de réponse (incluant le niveau [6ème, 5ème, ...], la classe [A, B, C, ...], et le numéro d'élève, ainsi que les réponses aux questions) et le QR code de réponse
\AtEndDocument{
    \vfill
    \makebox[\linewidth]{\rule{\paperwidth}{0.4pt}}
    \begin{tikzpicture}
        % Données élèves
        % NIVEAU (6ème, 5ème, etc.)
        \node[anchor=east] at (0,0) {\footnotesize{\textit{Niveau}}};
        \node[anchor=east] at (0,-0.3) {\tiny{6ème}};
        \node[anchor=east] at (0,-0.6) {\tiny{5ème}};
        \node[anchor=east] at (0,-0.9) {\tiny{4ème}};
        \node[anchor=east] at (0,-1.2) {\tiny{3ème}};
        \foreach \y in {-0.3,-0.6,-0.9,-1.2} {
            \draw (0,\y+0.1) rectangle (0.2,\y-0.1);
        }
        % CLASSE (A, B, C, etc.)
        \node[anchor=east] at (1.3,0) {\footnotesize{\textit{Classe}}};
        \node[anchor=east] at (1.3,-0.3) {\tiny{A}};
        \node[anchor=east] at (1.3,-0.6) {\tiny{B}};
        \node[anchor=east] at (1.3,-0.9) {\tiny{C}};
        \node[anchor=east] at (1.3,-1.2) {\tiny{D}};
        \node[anchor=east] at (1.3,-1.5) {\tiny{E}};
        \node[anchor=east] at (1.3,-1.8) {\tiny{F}};
        \foreach \y in {-0.3,-0.6,-0.9,-1.2,-1.5,-1.8} {
            \draw (1.3,\y+0.1) rectangle (1.5,\y-0.1);
        }
        % NUMÉRO de l'élève
        \node[anchor=east] at (2.9,0) {\footnotesize{\textit{Numéro}}};
        \foreach \y in {0,1,...,9} {
            \draw (2.3,{(\y+1)*(-0.3)+0.1}) rectangle (2.5,{(\y+1)*(-0.3)-0.1});
            \draw (3.1,{(\y+1)*(-0.3)+0.1}) rectangle (3.3,{(\y+1)*(-0.3)-0.1});
            \node[anchor=east] at (2.3,{(\y+1)*(-0.3)}) {\tiny{\y}};
            \node[anchor=east] at (3.1,{(\y+1)*(-0.3)}) {\tiny{\y}};
        }
        % Grille de réponse
        \node[anchor=east] at (5,0) {\footnotesize{\textit{Réponses}}};
        \foreach \x/\rep in {0/~,1/A,2/B,3/C,4/D} {
            \node[anchor=east] at (5,{((\x+2)*(-0.3)+0.15}) {\tiny{\rep}};
            \draw (5,{((\x+2)*(-0.3)}) -- ({5+0.3*\theVMQCMNumeroQuestion},{((\x+2)*(-0.3)});
        }
        \foreach \y/\numq in {0/~,1/1,...,\theVMQCMNumeroQuestion/\theVMQCMNumeroQuestion} {
            \node[anchor=south] at ({5+0.3*\y-0.15},-0.6) {\tiny{\numq}};
            \draw ({5+0.3*\y},-0.6) -- ({5+0.3*\y},-1.8);
        }
        % Encadré pour la note
        \draw (8.8,-2.5) rectangle (11.2,-3);
        \node at (10,-2.8) {Note : ~~~~/\theVMQCMTotalPoints};
        
        % QR Code
        \node at (6,-2.5) {\qrcode[height=1cm]{\directlua{tex.print("\theVMQCMNumeroQuestion" .. "*" .. solutions)}}};
        
    \end{tikzpicture}
}