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
    local triplets = {table.pack(20, 21, 29), table.pack(5, 12, 13), table.pack(12, 35, 37)}
    local t = objet_aleatoire_dans(triplets)
    local a, b, c = table.unpack(t)

    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local index1 = math.random(0, 25)
    local index2 = (index1 + math.random(1, 9)) % 26
    local index3 = (index2 + math.random(1, 9)) % 26

    local p1 = alphabet[index1 + 1]
    local p2 = alphabet[index2 + 1]
    local p3 = alphabet[index3 + 1]

    local enonce = "\\begin{tikzpicture}[baseline=(current bounding box.center)] \\draw (0,0) -- (0.8,0) -- (0.8,0.8) -- cycle; \\draw[fill=black] (0.8,0) rectangle (0.7,0.1); \\node[above left] at (0,0) {\\scriptsize{$" .. p1 .. "$}}; \\node[above right] at (0.8,0) {\\scriptsize{$" .. p2 .. "$}}; \\node[right] at (0.8,0.8) {\\scriptsize{$" .. p3 .. "$}}; \\node[anchor=west] at (1.8,0.7) {$" .. p1 .. p2 .. "=" .. num(a) .. "$}; \\node[anchor=west] at (1.8,0.4) {$" .. p2 .. p3 .. "=" .. num(b) .. "$}; \\node[anchor=west] at (1.8,0.1) {$" .. p1 .. p3 .. "=~?" .. "$}; \\end{tikzpicture}"

    local reponses = {num(c), num(c-2), num(c+1), num(c+3) }

    afficher_question(enonce, reponses, 2)
end

local function calcul_cote_angle_droit()
    local triplets = {table.pack(8, 15, 17), table.pack(9, 40, 41), table.pack(7, 24, 25)}
    local t = objet_aleatoire_dans(triplets)
    local a, b, c = table.unpack(t)

    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local index1 = math.random(0, 25)
    local index2 = (index1 + 9) % 26 +1 
    local index3 = (index2 + 9) % 26 +1

    local p1 = alphabet[index1 + 1]
    local p2 = alphabet[index2 + 1]
    local p3 = alphabet[index3 + 1]

    local enonce = "\\begin{tikzpicture}[baseline=(current bounding box.center)] \\draw (0,0) -- (0.8,0) -- (0.8,0.8) -- cycle; \\draw[fill=black] (0.8,0) rectangle (0.7,0.1); \\node[above left] at (0,0) {\\scriptsize{$" .. p1 .. "$}}; \\node[above right] at (0.8,0) {\\scriptsize{$" .. p2 .. "$}}; \\node[right] at (0.8,0.8) {\\scriptsize{$" .. p3 .. "$}}; \\node[anchor=west] at (1.8,0.7) {$" .. p3 .. p1 .. "=" .. num(c) .. "$}; \\node[anchor=west] at (1.8,0.4) {$" .. p1 .. p2 .. "=" .. num(a) .. "$}; \\node[anchor=west] at (1.8,0.1) {$" .. p2 .. p3 .. "=~?" .. "$}; \\end{tikzpicture}"

    local reponses = {num(b), num(b-2), num(b+1), num(b+3) }

    afficher_question(enonce, reponses, 2)
end

local function frac(x, y)
    return "$\\frac{" .. x .. "}{" .. y .. "}$"
end

local function addition_fractions()
    local a, b, c, d = math.random(3,20), math.random(3,20), math.random(3,20), math.random(3,20)

    local enonce = frac(a, b) .. "$+$" .. frac(c, d) .. "= "
    local reponses = {frac(a*d+c*b, b*d), frac(a+c, c+d), frac(a*b, c*d), frac(a*d+b*c+2, b*d)}

    afficher_question(enonce, reponses, 1)
end

local function fractions_egales()
    local a, b, c = math.random(3, 20), math.random(3,20), math.random(3,11)

    local enonce = frac(a, b) .. "$ = $" .. frac(a*c, "?")
    local reponses = {b*c, b*c-c, b*c+c, b*c+2*c}

    afficher_question(enonce, reponses, 1)
end

return { qC = hypotenuse, qH = egalite_pythagore, qA = calcul_hypotenuse, qB = calcul_cote_angle_droit, qD = addition_fractions, qE = fractions_egales}