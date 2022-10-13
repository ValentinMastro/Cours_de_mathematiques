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

local function objets_aleatoires_dans(liste, n)
    local copie = {}
    for cle, valeur in pairs(liste) do
        copie[cle] = valeur
    end

    melanger(copie)
    return copie
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
    
    local vmqcm = "\\VMQCMAjouterQuestion{" .. enonce .. "}{" .. reponses[1] .. "}{" .. reponses[2] .. "}{" .. reponses[3] .. "}{" .. reponses[4] .. "}{" .. reponses[5] .. "}{" .. lettre_bonne_reponse .. "}{" .. points .. "}"

    tex.print(vmqcm)
end

local function isint(n)
    return n==math.floor(n)
end


local function num(n)
    -- afficher un nombre avec l'écriture SI
    if isint(n) then
        return "\\num{" .. math.floor(n) .. "}"
    else
        return "\\num{" .. n .. "}"
    end
end

local function qty(n, unite)
    -- affiche une quantité avec son unité
    return "\\qty{" .. n .. "}{" .. unite .. "}"
end

local function frac(x, y)
    -- affiche une fraction
    return "$\\dfrac{" .. num(x) .. "}{" .. num(y) .. "}$"
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

    local enonce = "\\begin{tikzpicture}[baseline=(current bounding box.center)] \\draw (0,0) -- (0.8,0) -- (0.8,0.8) -- cycle; \\draw[fill=black] (0.8,0) rectangle (0.7,0.1); \\node[above left] at (0,0) {\\scriptsize{$" .. p1 .. "$}}; \\node[above right] at (0.8,0) {\\scriptsize{$" .. p2 .. "$}}; \\node[right] at (0.8,0.8) {\\scriptsize{$" .. p3 .. "$}}; \\node[anchor=west] at (1.8,0.7) {\\scriptsize{$" .. p1 .. p2 .. "=" .. arrondi(a,1) .. "$}}; \\node[anchor=west] at (1.8,0.4) {\\scriptsize{$" .. p2 .. p3 .. "=" .. arrondi(b,1) .. "$}}; \\node[anchor=west] at (1.8,0.1) {\\scriptsize{$" .. p1 .. p3 .. "=~?" .. "$}}; \\end{tikzpicture}"

    local reponses = {arrondi(c, 2), arrondi(math.sqrt(math.abs(a*a-b*b)), 2), arrondi(c + 0.5 + math.random()*3, 2), arrondi(c + 0.5 + math.random()*3, 2), arrondi(c + 0.5 + math.random()*3, 2) }

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

    local enonce = "\\begin{tikzpicture}[baseline=(current bounding box.center)] \\draw (0,0) -- (0.8,0) -- (0.8,0.8) -- cycle; \\draw[fill=black] (0.8,0) rectangle (0.7,0.1); \\node[above left] at (0,0) {\\scriptsize{$" .. p1 .. "$}}; \\node[above right] at (0.8,0) {\\scriptsize{$" .. p2 .. "$}}; \\node[right] at (0.8,0.8) {\\scriptsize{$" .. p3 .. "$}}; \\node[anchor=west] at (1.8,0.7) {\\scriptsize{$" .. p3 .. p1 .. "=" .. arrondi(a,1) .. "$}}; \\node[anchor=west] at (1.8,0.4) {\\scriptsize{$" .. p1 .. p2 .. "=" .. arrondi(b,1) .. "$}}; \\node[anchor=west] at (1.8,0.1) {\\scriptsize{$" .. p2 .. p3 .. "=~?" .. "$}}; \\end{tikzpicture}"

    local reponses = {arrondi(c, 2), arrondi(math.sqrt(a*a+b*b), 2), arrondi(c + 0.5 + math.random(), 2), arrondi(c - 0.5 - math.random(), 2), arrondi(c - 0.5 - math.random(), 2) }

    afficher_question(enonce, reponses, 2)
end

local function augmentation_pourcentage()
    local a = math.random(10,49)
    local b = math.random(500,999) / 10

    local enonce = "\\scriptsize{Un article est vendu " .. qty(a, "\\EURO") .. " puis son prix augmente de " .. qty(b, "\\percent") .. ". Son nouveau prix est :}" 

    local reponses = {num(a*(100+b)/100), num(a*(100-b)/100), num(b*(100+a)/100), num(b*(100-a)/100), num(a*b/100)}

    afficher_question(enonce, reponses, 1)
end

local function diminution_pourcentage()
    local a = math.random(10,49)
    local b = math.random(500,999) / 10

    local enonce = "\\scriptsize{Un article est vendu " .. qty(a, "\\EURO") .. " puis son prix diminue de " .. qty(b, "\\percent") .. ". Son nouveau prix est :}" 

    local reponses = {num(a*(100-b)/100), num(a*(100+b)/100), num(b*(100+a)/100), num(b*(100-a)/100), num(a*b/100)}

    afficher_question(enonce, reponses, 1)
end

local function ecart_pourcentage()
    local a = math.random(3000, 9999)
    local b = a + math.random(-3000, 3000)

    local enonce = "\\scriptsize{La population d'une ville passe en un an de " .. qty(a, "habitants") .. " à " .. qty(b, "habitants") .. ". Calculer le pourcentage d'évolution.}"

    local reponses = { arrondi( ((b-a)/a)*100  ,2) .. "~\\%", arrondi( ((a-b)/a)*100  ,2) .. "~\\%", arrondi( ((b-a)/b)*100  ,2) .. "~\\%", arrondi( ((a-b)/b)*100  ,2) .. "~\\%", arrondi(b/a * 100 ,2) .. "~\\%" }

    afficher_question(enonce, reponses, 2)
end

local function augmentation_pourcentage_inverse()
    local a = math.random(50,99)
    local b = math.random(100,490) / 10

    local enonce = "\\scriptsize{Après une augmentation de " .. qty(b, "\\percent") .. ", un article est vendu " .. qty(a, "\\EURO") .. ". Quel était son prix de base ?}"

    local reponses = { arrondi(a*100/(100+b), 2), arrondi(a*100/(100-b), 2), arrondi(b*100/(100+a), 2), arrondi(b*100/(100-a), 2), arrondi(a*(100+b)/100, 2) }

    afficher_question(enonce, reponses, 2)
end

local function diminution_pourcentage_inverse()
    local a = math.random(50,99)
    local b = math.random(100,490) / 10

    local enonce = "\\scriptsize{Après une diminution de " .. qty(b, "\\percent") .. ", un article est vendu " .. qty(a, "\\EURO") .. ". Quel était son prix de base ?}"

    local reponses = { arrondi(a*100/(100-b), 2), arrondi(a*100/(100+b), 2), arrondi(b*100/(100-a), 2), arrondi(b*100/(100+a), 2), arrondi(a*(100-b)/100, 2) }

    afficher_question(enonce, reponses, 2)
end

local function carre_echelle()
    local a = math.random(2, 10) / 10
    local b = math.random(11, 50) / 10

    local enonce = "\\begin{tikzpicture}[baseline=(current bounding box.center)] \\draw (-0.5,0) rectangle +(0.5,0.5); \\draw (1.5,-0.25) rectangle +(1,1); \\draw[white] (-1,-0.3) -- (-1,0.8); \\draw[-latex] (0.2,0.25) -- +(1.1,0); \\end{tikzpicture}"

    local reponses = {"a", "a", "a", "a", "a"}

    afficher_question(enonce, reponses, 2)
end


return { qA = calcul_hypotenuse, qB = calcul_cote_angle_droit, qC = augmentation_pourcentage, qD = diminution_pourcentage, qE = ecart_pourcentage, qF = augmentation_pourcentage_inverse, qG = diminution_pourcentage_inverse }