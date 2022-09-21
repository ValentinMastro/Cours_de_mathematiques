local function objet_aleatoire_dans(liste)
    local index = math.random(1,#liste)
    return liste[index]
end

local function melanger(liste)
    for i = #liste, 2, -1 do
        local j = math.random(i)
        liste[i], liste[j] = liste[j], liste[i]
    end
end

local function trouver_element_dans_liste(element, liste)
    for i = 1, #liste do
        if liste[i] == element then
            return i
        end
    end
end

local function decimal_aleatoire_virgule_fixe(inf, sup, precision)
    local nombre = math.random() * (sup-inf) + inf
    return string.format("%." .. precision .. "f", nombre)
end

local function arrondi(x, precision)
    return "\\num{" .. string.format("%." .. precision .. "f", x) .. "}"
end

local function signe(x)
    if x < 0 then
        return "" .. x
    else 
        return "+" .. x
    end
end

local function afficher_question(enonce, reponses, points)
    -- la première réponse est toujours la bonne
    
    local bonne_reponse = reponses[1]
    melanger(reponses)
    local index_bonne_reponse = trouver_element_dans_liste(bonne_reponse, reponses)
    local lettre_bonne_reponse = string.char(index_bonne_reponse + 65 - 1)
    
    local vmqcm = "\\VMQCMAjouterQuestion{" .. enonce .. "}{" .. reponses[1] .. "}{" .. reponses[2] .. "}{" .. reponses[3] .. "}{" .. reponses[4] .. "}{" .. lettre_bonne_reponse .. "}{" .. points .. "}"

    tex.print(vmqcm)
end

local function isint(n)
    return n==math.floor(n)
end


local function num(n)
    -- afficher un nombre avec l'acriture SI
    if isint(n) then
        return "\\num{" .. math.floor(n) .. "}"
    else
        return "\\num{" .. n .. "}"
    end
end

local function frac(x, y)
    -- affiche une fraction
    return "$\\frac{" .. num(x) .. "}{" .. num(y) .. "}$"
end



local function hypotenuse()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local index1 = math.random(0, 25)
    local index2 = (index1 + math.random(1, 12)) % 26
    local index3 = (index2 + math.random(1, 12)) % 26

    local p1 = alphabet[index1 + 1]
    local p2 = alphabet[index2 + 1]
    local p3 = alphabet[index3 + 1]

    local reponses = {"$[" .. p1 .. p3 .. "]$", "$[" .. p1 .. p2 .. "]$", "$[" .. p3 .. p2 .. "]$", "$[" .. p2 .. p3 .. "]$"}
    local enonce = "Dans le triangle $" .. p1 .. p2 .. p3 .. "$ rectangle en $" .. p2 .. "$, quel côté est l'hypoténuse ?"

    afficher_question(enonce, reponses, 1)
end


local function egalite_pythagore()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local index1 = math.random(0, 25)
    local index2 = (index1 + math.random(1, 12)) % 26
    local index3 = (index2 + math.random(1, 12)) % 26

    local p1 = alphabet[index1 + 1]
    local p2 = alphabet[index2 + 1]
    local p3 = alphabet[index3 + 1]

    local enonce = "Dans le triangle $" .. p1 .. p3 .. p2 .. "$ rectangle en $" .. p3 .. "$, l'égalité de Pythagore est :"
    local hyp = p1 .. p2 .. "^2"
    local c1 = p1 .. p3 .. "^2"
    local c2 = p2 .. p3 .. "^2"

    local reponses = { "\\tiny{$" .. hyp .. "{=}" .. c1 .. "{+}" .. c2 .. "$}",     "\\tiny{$" .. c1 .. "{=}" .. hyp .. "{+}" .. c2 .. "$}",          "\\tiny{$" .. c2 .. "{=}" .. hyp .. "{+}" .. c2 .. "$}",       "\\tiny{$" .. c1 .. "{=}" .. c2 .. "{+}" .. hyp .. "$}" }

    afficher_question(enonce, reponses, 1)
end

local function calcul_hypotenuse()
    local a = math.random(10,99) / 10
    local b = math.random(10,99) / 10
    local c = math.sqrt(a*a+b*b)

    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local index1 = math.random(0, 25)
    local index2 = (index1 + math.random(1, 12)) % 26
    local index3 = (index2 + math.random(1, 12)) % 26

    local p1 = alphabet[index1 + 1]
    local p2 = alphabet[index2 + 1]
    local p3 = alphabet[index3 + 1]

    local enonce = "\\begin{tikzpicture} \\draw (0,0) -- (0.8,0) -- (0.8,0.8) -- cycle; \\draw[fill=black] (0.8,0) rectangle (0.7,0.1); \\node[above left] at (0,0) {\\scriptsize{$" .. p1 .. "$}}; \\node[above right] at (0.8,0) {\\scriptsize{$" .. p2 .. "$}}; \\node[right] at (0.8,0.8) {\\scriptsize{$" .. p3 .. "$}}; \\node[anchor=west] at (1.8,0.7) {$" .. p1 .. p2 .. "=" .. arrondi(a,1) .. "$}; \\node[anchor=west] at (1.8,0.4) {$" .. p2 .. p3 .. "=" .. arrondi(b,1) .. "$}; \\node[anchor=west] at (1.8,0.1) {$" .. p1 .. p3 .. "=~?" .. "$}; \\end{tikzpicture}"

    local reponses = {arrondi(c, 2), arrondi(math.sqrt(math.abs(a*a-b*b)), 2), arrondi(c + 0.5 + math.random()*3, 2), arrondi(c + 0.5 + math.random()*3, 2) }

    afficher_question(enonce, reponses, 2)
end

local function calcul_cote_angle_droit()
    local a = math.random(10,99) / 10
    local b = math.random(10,99) / 10

    -- a est le plus grand
    if a < b then
        a, b = b, a
    end

    local c = math.sqrt(a*a-b*b)

    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local index1 = math.random(0, 25)
    local index2 = (index1 + math.random(1, 12)) % 26
    local index3 = (index2 + math.random(1, 12)) % 26

    local p1 = alphabet[index1 + 1]
    local p2 = alphabet[index3 + 1]
    local p3 = alphabet[index2 + 1]

    local enonce = "\\begin{tikzpicture} \\draw (0,0) -- (0.8,0) -- (0.8,0.8) -- cycle; \\draw[fill=black] (0.8,0) rectangle (0.7,0.1); \\node[above left] at (0,0) {\\scriptsize{$" .. p1 .. "$}}; \\node[above right] at (0.8,0) {\\scriptsize{$" .. p2 .. "$}}; \\node[right] at (0.8,0.8) {\\scriptsize{$" .. p3 .. "$}}; \\node[anchor=west] at (1.8,0.7) {$" .. p3 .. p1 .. "=" .. arrondi(a,1) .. "$}; \\node[anchor=west] at (1.8,0.4) {$" .. p1 .. p2 .. "=" .. arrondi(b,1) .. "$}; \\node[anchor=west] at (1.8,0.1) {$" .. p2 .. p3 .. "=~?" .. "$}; \\end{tikzpicture}"

    local reponses = {arrondi(c, 2), arrondi(math.sqrt(a*a+b*b), 2), arrondi(c + 0.5 + math.random()*3, 2), arrondi(c + 0.5 + math.random()*3, 2) }

    afficher_question(enonce, reponses, 2)
end

return { qC = hypotenuse, qH = egalite_pythagore, qA = calcul_hypotenuse, qB = calcul_cote_angle_droit}