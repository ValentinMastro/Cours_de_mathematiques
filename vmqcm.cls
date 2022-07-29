\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{vmqcm}[2022/07/06 Valentin Mastro QCM class]
% Le but de cette classe est de créer un QCM qui :
%   - peut afficher juste les questions, ou les questions et les réponses
%   - permet de compter le total des points du QCM
%   - affiche une grille permettant de répondre aux questions, scannable
%   - affiche un QR code donnant les réponses
%   - gère la génération de nombres aléatoires


% Base du document
\LoadClass[10pt]{article}
\RequirePackage[a5paper,margin=1cm]{geometry}
\RequirePackage{tabularx}
\RequirePackage{qrcode}
\RequirePackage{tikz}
\usetikzlibrary{calc,math}


% Graine (nombre qui rend l'aléatoire déterministe)
\newcommand{\VMQCMgraine}[1]{
    \pgfmathsetseed{#1}
    \directlua{
        local graine = #1;
        math.randomseed(graine)
    }
}

% Gestion des marges
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
\setlength{\parindent}{0pt}

\newenvironment{VMQCM}{\tabularx{\textwidth}{@{}l|X|p{0.1\textwidth}|p{0.1\textwidth}|p{0.1\textwidth}|p{0.1\textwidth}|r @{}} & \centering Question & \centering A & \centering B & \centering C & \centering D & ~ \\\hline}{\endtabularx}


% À la fin du document, on affiche la grille de réponse (incluant le niveau [6ème, 5ème, ...], la classe [A, B, C, ...], et le numéro d'élève, ainsi que les réponses aux questions) et le QR code de réponse
\AtEndDocument{
    \vfill
    \makebox[\linewidth]{\rule{\paperwidth}{0.4pt}}
    \begin{tikzpicture}
        % Données élèves
        % NIVEAU (6ème, 5ème, etc.)
        \node[anchor=east] at (0,0) {\footnotesize{\textit{Niveau}}};
        \tikzmath{
            coordinate \p;
            for \y in {1,2,...,4}{
                \p1 = (0,-0.3*\y+0.1);
                \p2 = (0.2,-0.3*\y-0.1);
                \p3 = (\p1)-(0,0.1);
                {\node[anchor=east] at (\p3) {\tiny{\directlua{tex.print(math.floor(7.5-\y))}ème}};};
                {\draw (\p1) rectangle (\p2);};
            };
        }
        % CLASSE (A, B, C, etc.)
        \node[anchor=east] at (1.3,0) {\footnotesize{\textit{Classe}}};
        \tikzmath{
            int \lettre;
            coordinate \p;
            for \y in {1,2,...,6}{
                \p1 = (1.3,-0.3*\y+0.1);
                \p2 = (1.5,-0.3*\y-0.1);
                \p3 = (\p1)-(0,0.1);
                \lettre = 65-1+\y;
                {\node[anchor=east] at (\p3) {\tiny{\char\lettre}};};
                {\draw (\p1) rectangle (\p2);};
            };
        }
        % NUMÉRO de l'élève
        \node[anchor=east] at (2.9,0) {\footnotesize{\textit{Numéro}}};
        \tikzmath{
            coordinate \p;
            coordinate \q;
            int \y;
            for \y in {0,1,...,9}{
                \p1 = (2.3,{-0.3*(\y+1)+0.1});
                \p2 = (\p1)+(0.2,-0.2);
                \p3 = (\p1)+(0,-0.1);
                \q1 = (\p1)+(0.8,0);
                \q2 = (\q1)+(0.2,-0.2);
                \q3 = (\q1)+(0,-0.1);
                {\draw (\p1) rectangle (\p2);};
                {\draw (\q1) rectangle (\q2);};
                {\node[anchor=east] at (\p3) {\tiny{\y}};};
                {\node[anchor=east] at (\q3) {\tiny{\y}};};
            };
        }
        % Grille de réponse
        \tikzmath{
            int \lettre;
            coordinate \O;
            int \n;
            \O1 = (5.1,-0.6);
            \O2 = ({5.1+0.3*\theVMQCMNumeroQuestion},-1.801);
            {\draw (\O1) grid[shift={(0,0)},step=0.3] (\O2);};
            coordinate \p;
            coordinate \l;
            for \n in {1,2,...,\theVMQCMNumeroQuestion}{
                \p1 = (5+0.3*\n-0.075, {-0.65-1.5*mod(\n+1,2)});
                {\node[anchor=south] at (\p1) {\tiny{\n}};};
                if \n<5 then {
                    \l1 = (5.1,{-0.3*(\n+2)+0.15});
                    \lettre = 65-1+\n;
                    {\node[anchor=east] at (\l1) {\tiny{\char\lettre}};};
                };
            };
        }
        % Encadré pour la note
        \draw (-1.1,-2.7) rectangle (1.1,-3.2);
        \node at (0,-3) {Note : ~~~~/\theVMQCMTotalPoints};
        % QR Code
        \node at (-0.35,-2) {\qrcode[height=1.1cm]{\directlua{tex.print("\theVMQCMNumeroQuestion" .. "Q" .. table.concat(solutions))}}};
    \end{tikzpicture}
}