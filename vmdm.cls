\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{vmdm}[2022/07/06 Valentin Mastro DM class]

\LoadClass[12pt,addpoints]{exam}
\RequirePackage[a4paper,margin=1.5cm]{geometry}
\RequirePackage{tabularx}
\RequirePackage{qrcode}
\RequirePackage{tikz}
\RequirePackage{pgf}
\RequirePackage{fontspec}
\RequirePackage{luacode}
\RequirePackage{luatexbase}
\RequirePackage[locale=FR, group-digits=all, group-separator=\ , group-minimum-digits=4]{siunitx}
\RequirePackage{amsmath, amssymb, mdframed}
\RequirePackage{frenchmath}
\RequirePackage{libertine}
\usetikzlibrary{calc,math}


\pagestyle{empty}

\newcommand{\VMDMTitre}[1]{%
    \centerline{\Huge{DM - #1}}%
}

\newcommand{\VMDMRegles}{%
    \begin{mdframed}
        \underline{Règles :} 
        \vspace{-0.5em}\begin{itemize}\setlength{\itemsep}{-0.2em}
            \item Le sujet donne la réponse de certaines questions.
            \item L'élève est \emph{uniquement} noté sur la rédaction et les réponses non données.
            \item \textbf{Collez cette feuille} sur la première page de la copie double que vous allez rendre.
        \end{itemize}
    \end{mdframed}
}

\newcommand{\rep}[1]{\textbf{(Réponse : #1)}}