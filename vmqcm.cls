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
\RequirePackage[a5paper,margin=0.8cm]{geometry}
\RequirePackage{tabularx}
\RequirePackage{makecell}
\RequirePackage{qrcode}
\RequirePackage{tikz}
\RequirePackage{pgf}
\RequirePackage{fontspec}
\RequirePackage{luacode}
\RequirePackage{luatexbase}
\RequirePackage{colortbl}

\RequirePackage{eurosym}
\RequirePackage[locale=FR, group-digits=all, group-separator=\ , group-minimum-digits=4]{siunitx}
\DeclareSIUnit{\cube}{\cubed}
\DeclareSIUnit{\carre}{\squared}
\DeclareSIUnit{\litre}{\ell}
\DeclareSIUnit{\EURO}{\text{\euro}}

\RequirePackage{amsmath, amssymb}
\RequirePackage{frenchmath}
\RequirePackage{libertine}
\usetikzlibrary{calc,math}

\RequirePackage[tracking=true]{microtype}


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

% Affichage calculatrice
\newcommand{\VMQCMCalculatrice}{Calculatrice interdite}

% Compteurs
\newcounter{VMQCMNumeroQuestion}
\newcounter{VMQCMTotalPoints}
\newcounter{VMQCMPointsQuestion}
\newcounter{VMQCMNumeroEvaluation}
\setcounter{VMQCMNumeroEvaluation}{0}
\directlua{solutions = {}}
\directlua{points = {}}


% Gérer l'espacement du texte
\newcommand\spacedstyle[1]{\SetTracking{encoding=*}{#1}\lsstyle}
\newcommand\normalstyle{\SetTracking{encoding=*}{0}\lsstyle}

\newcommand{\VMQCMAjouterSolution}[1]{%
    \directlua{solutions[\theVMQCMNumeroQuestion] = "#1"}%
    \directlua{points[\theVMQCMNumeroQuestion] = "\theVMQCMPointsQuestion"}%
}

% Afficher un nombre blanc sur fond noir entouré
% https://tex.stackexchange.com/a/91070
\newcommand{\libcircblk}[1]{\pgfmathparse{Hex(10101+#1)}\libertineGlyph{uni\pgfmathresult}}

% Ajouter une question au QCM
%           \VMQCMAjouterQuestion{énoncé}{A}{B}{C}{D}{bonne réponse}{point(s)}
\newcommand{\VMQCMAjouterQuestion}[8]{%
    \stepcounter{VMQCMNumeroQuestion}%  
    \setcounter{VMQCMPointsQuestion}{#8}%
    \VMQCMAjouterSolution{#7}%
    \addtocounter{VMQCMTotalPoints}{#8}%
    \scriptsize{\theVMQCMNumeroQuestion} & #1 & #2 & #3 & #4 & #5 & #6 & \large{\libcircblk{#8}} \\\hline
}

% Formatage des questions et des réponses
\setlength{\parindent}{0pt}
\setlength\tabcolsep{3pt} % marge des cellules du tableau (par défaut : 6pt)
\newcolumntype{C}{>{\centering\arraybackslash}X}


\newlength{\VMQCMLargeurEnonce}
\setlength{\VMQCMLargeurEnonce}{0.3\textwidth}

\newenvironment{VMQCM}[1]{%
\begin{flushright}
\vspace{-0.1mm}%
\scriptsize{\fbox{\VMQCMCalculatrice{}}}%
\vspace{-0.8cm}%
\end{flushright}%
\begin{flushleft}
Nom : \\
Prénom:
\vspace{-1cm}%
\end{flushleft}
\centerline{\large{#1}} \vspace{2ex}%
\setcounter{VMQCMNumeroQuestion}{0}%
\setcounter{VMQCMTotalPoints}{0}%
\setcounter{VMQCMPointsQuestion}{0}%
\directlua{solutions = {}}%
\tabularx{\textwidth}{@{}p{0.013\textwidth}|p{\VMQCMLargeurEnonce}|C|C|C|C|C|p{0.02\textwidth} @{}} & \centering Question & \centering A & \centering B & \centering C & \centering D & \centering E & ~ \\\hline}{\endtabularx%
    \vfill
    % À la fin du document, on affiche la grille de réponse (incluant le niveau [6ème, 5ème, ...], la classe [A, B, C, ...], et le numéro d'élève, ainsi que les réponses aux questions) et le QR code de réponse
    \makebox[\linewidth]{\rule{\paperwidth}{1pt}}
    \begin{tikzpicture}
        % Données élèves
        % NIVEAU (6ème, 5ème, etc.)
        % CLASSE (A, B, C, etc.)
        \node[anchor=east] at (3,0) {\footnotesize{\textit{Classe}}};
        \tikzmath{
            int \lettre;
            coordinate \p;
            coordinate \q;
            for \y in {1,2,...,6}{
                \p1 = (2.3,-0.3*\y+0.1);
                \p2 = (\p1)+(0.2,-0.2);
                \p3 = (\p1)-(0,0.1);
                \q1 = (\p1)+(0.6,0);
                \q2 = (\q1)+(0.2,-0.2);
                \q3 = (\q1)-(0,0.1);
                \lettre = 65-1+\y;
                {\node[anchor=east] at (\q3) {\tiny{\char\lettre}};};
                {\draw (\q1) rectangle (\q2);};
                if \y<5 then {
                    {\node[anchor=east] at (\p3) {\tiny{\directlua{tex.print(math.floor(7.5-\y))}ème}};};
                    {\draw (\p1) rectangle (\p2);}; 
                };
            };
        }
        % NUMÉRO de l'élève
        \node[anchor=east] at (4.75,0) {\footnotesize{\textit{Numéro}}};
        \tikzmath{
            coordinate \p;
            coordinate \q;
            int \y;
            for \y in {0,1,...,9}{
                \p1 = (3.9,{-0.3*(\y+1)+0.1});
                \p2 = (\p1)+(0.2,-0.2);
                \p3 = (\p1)+(0,-0.1);
                \q1 = (\p1)+(0.6,0);
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
            \O1 = (5.1,-0.3);
            \O2 = ({5.1+0.3*\theVMQCMNumeroQuestion},-1.801);
            {\draw (\O1) grid[shift={(0.6,0)},step=0.3] (\O2);};
            coordinate \p;
            coordinate \l;
            for \n in {1,2,...,\theVMQCMNumeroQuestion}{
                \p1 = (5.6+0.3*\n-0.075, {-0.35-1.75*mod(\n+1,2)});
                {\node[anchor=south] at (\p1) {\tiny{\n}};};
                if \n<6 then {
                    \l1 = (5.7,{-0.3*(\n+1)+0.15});
                    \lettre = 65-1+\n;
                    {\node[anchor=east] at (\l1) {\tiny{\char\lettre}};};
                };
            };
        }
        % Encadré pour la note
        \tikzmath{
            coordinate \p;
            \p1 = (7.6,-2.3);
            \p2 = (\p1)+(2.2,-0.5);
            \p3 = (\p1)+(1.1,-0.26);
            {\draw (\p1) rectangle (\p2);};
            {\node at (\p3) {Note sur \theVMQCMTotalPoints};};
        }
        % QR Code
        \node[anchor=south west] at (-1.3,-2.9) {\qrcode[height=2.5cm]{\directlua{tex.print("\theVMQCMNumeroQuestion" .. "Q-" .. "REP:" .. table.concat(solutions) .. "-PTS:" .. table.concat(points)) }}};
    \end{tikzpicture}
    \clearpage
}