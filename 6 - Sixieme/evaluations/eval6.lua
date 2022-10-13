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

local function objets_aleatoires_dans(liste, n)
    local copie = {}
    for cle, valeur in pairs(liste) do
        copie[cle] = valeur
    end

    melanger(copie)
    return copie
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

local function deg(n)
    -- afficher la mesure d'un angle en degrés
    return "\\ang{" .. n .. "}"
end

local function frac(x, y)
    -- affiche une fraction
    return "$\\frac{" .. num(x) .. "}{" .. num(y) .. "}$"
end

local function addition_aleatoire(n)
    local a = math.random(math.pow(10,n),math.pow(10,n+1)-1)
    local b = math.random(math.pow(10,n),math.pow(10,n+1)-1)
    local reponses = {num(a+b), num(a+b+10), num(a+b-10), num(a+b+100), num(a+b-100)}
    local enonce = "\\scriptsize{$" .. num(a) .. "+" .. num(b) .. "~=$}"

    afficher_question(enonce, reponses, 1)
end


local function soustraction_aleatoire(n)
    local a = math.random(math.pow(10,n),math.pow(10,n+1)-1)
    local b = math.random(math.pow(10,n),math.pow(10,n+1)-1)

    -- a doit être plus grand que b
    if a < b then
        a, b = b, a
    end

    local reponses = {num(a-b), num(a-b-10), num(a-b+10), num(a-b+math.pow(10,n-1)), num(a-b-math.pow(10-1,n))}
    local enonce = "\\scriptsize{$" .. num(a) .. "-" .. num(b) .. "~=$}"

    afficher_question(enonce, reponses, 2)
end

local function chiffres()
    local a = math.random(1,9)
    local b = (a + 1) % 10
    local c = (a + 3) % 10
    local d = (a + 7) % 10

    local decal = math.random(-1,3)
    local nombre = a * math.pow(10,decal+1) + b * math.pow(10,decal) + c * math.pow(10,decal-1) + d * math.pow(10,decal-2)

    local rangs = {"millièmes", "centièmes", "dixièmes", "unités", "dizaines", "centaines", "milliers", "dizaines de milliers", "centaine de milliers"}
    
    local enonce = "Dans le nombre $" .. num(nombre) .. "$"
    local reponses = {a .. " est le chiffre des " .. rangs[decal+5], b .. " est le chiffre des " .. rangs[decal+3], c .. " est le chiffre des " .. rangs[decal+4], d .. " est le chiffre des " .. rangs[decal+3]}

    afficher_question(enonce, reponses, 1)
end

local function plus_petit_que_nombres_decimaux()
    local decal = math.pow(10,math.random(-3,-1))
    local a = math.random(1000, 1000000) * decal

    local enonce = "Lequel de ces nombres est plus petit que " .. num(a)
    local reponses = {num(a - 3* decal), num(a + 2 * decal), num(a + 50*decal), num(a + 700*decal)}

    afficher_question(enonce, reponses, 1)
end

local function plus_grand_que_nombres_decimaux()
    local decal = math.pow(10,math.random(-3,-1))
    local a = math.random(1000, 1000000) * decal

    local enonce = "Lequel de ces nombres est plus grand que " .. num(a)
    local reponses = {num(a + 3* decal), num(a - 2 * decal), num(a - 50*decal), num(a - 700*decal)}

    afficher_question(enonce, reponses, 1)
end

local function segment()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local p1 = alphabet[math.random(1, 12)]
    local p2 = alphabet[math.random(14,25)]
    local enonce = "Le segment d'extrémités $" .. p1 .. "$ et $" .. p2 .. "$ est "

    local reponses = {"$[" .. p1 .. p2 .. "]$", "$[" .. p1 .. p2 .. ")$", "$(" .. p1 .. p2 .. "]$", "$(" .. p1 .. p2 .. ")$"}
    afficher_question(enonce, reponses, 1)
end

local function droite()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local p1 = alphabet[math.random(1, 12)]
    local p2 = alphabet[math.random(14,25)]
    local enonce = "La droite passant par $" .. p1 .. "$ et $" .. p2 .. "$ est "

    local reponses = {"$(" .. p1 .. p2 .. ")$", "$[" .. p1 .. p2 .. ")$", "$(" .. p1 .. p2 .. "]$", "$[" .. p1 .. p2 .. "]$"}
    afficher_question(enonce, reponses, 1)
end

local function demi_droite()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local p1 = alphabet[math.random(1, 12)]
    local p2 = alphabet[math.random(14,25)]
    local enonce = "La demi-droite d'origine $" .. p1 .. "$ et passant par $" .. p2 .. "$ est "

    local reponses = {"$(" .. p2 .. p1 .. "]$", "$[" .. p2 .. p1 .. "]$", "$[" .. p2 .. p1 .. ")$", "$(" .. p2 .. p1 .. ")$"}
    afficher_question(enonce, reponses, 1)
end

local function appartient()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local p1 = alphabet[math.random(1, 6)]
    local p2 = alphabet[math.random(7,13)]
    local p3 = alphabet[math.random(14,20)]
    local p4 = alphabet[math.random(21,26)]

    local x3 = math.random(3, 17)/10
    local x4 = math.random(22, 27)/10
    -- p1 ; p3 ; p2 ; p4

    local enonce = "\\begin{tikzpicture}[scale=0.8,baseline=(current bounding box.center)]  \\draw (-0.2,0) -- (2.8,0); \\draw (0,-0.1) -- (0,0.1); \\draw (2,-0.1) -- (2,0.1);  \\node[below] at (0,-0.1) {\\scriptsize{$" .. p1 .. "$}}; \\node[below] at (2,-0.1) {\\scriptsize{$" .. p2 .. "$}}; \\node[above] at (" .. x3 .. ",0.1) {\\scriptsize{$" .. p3 .. "$}}; \\node[above] at (" .. x4 .. ", 0.1) {\\scriptsize{$" .. p4 .. "$}}; \\draw (" .. x3 .. ",-0.1) -- (" .. x3 .. ",0.1); \\draw (" .. x4 .. ",-0.1) -- (" .. x4 .. ",0.1); \\end{tikzpicture}"

    local reponses = {objet_aleatoire_dans({"$" .. p3 .. "\\in [" .. p1 .. p2 .. "]$", "$" .. p4 .. "\\in [" .. p1 .. p2 .. ")$"}), "$" .. p1 .. "\\in [" .. p2 .. p3 .. "]$", "$" .. p4 .. "\\in [" .. p3 .. p2 .. "]$", "$" .. p4 .. "\\in [" .. p2 .. p1 .. ")$", "$" .. p3 .. "\\in [" .. p2 .. p4 .. ")$"}
    afficher_question(enonce, reponses, 1)
end

local function divisibilite(n)
    local enonce = "Lequel de ces nombres est divisible par " .. n .. " ?"
    local premiers = {11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199}

    local reponses = {objet_aleatoire_dans(premiers)*n, objet_aleatoire_dans(premiers)*(n-1), objet_aleatoire_dans(premiers)*(n-1), objet_aleatoire_dans(premiers)*(n-1)}

    afficher_question(enonce, reponses, 1)
end

local function frac(x, y)
    return "\\frac{" .. x .. "}{" .. y .. "}"
end

local function addition_fraction()
    local a = math.random(1, 20)
    local b = math.random(1, 20)
    local c = math.random(1, 20)

    local enonce = "$" .. frac(a, c) .. "+" .. frac(b, c) .. "=$"
    local reponses = {"$" .. frac(a+b, c) .. "$", "$" .. frac(a+b, c+c) .. "$", "$" .. frac(a+b+1, c) .. "$", "$" .. frac(a+b+1, c+c) .. "$", "$" .. frac(a+b-1, c) .. "$"}

    afficher_question(enonce, reponses, 1)
end

local function fractions_egales()
    local nombres = {2, 3, 4, 5, 6, 7, 8, 9, 10}
    local a, b, c = table.unpack(objets_aleatoires_dans(nombres, 3))

    local enonce = "$" .. frac(a, b) .. " = " .. frac(a*c, "?") .. "$"
    local reponses = {num(b*c), num(a*b), num(c*a), num(a*b*c), num(b*b)}

    afficher_question(enonce, reponses, 1)
end

local function decompose()
    local a = math.random(1,9)
    local b = (a+1) % 9 + 1
    local c = (a+3) % 9 + 1
    local d = (a+7) % 9 + 1

    local elements = {num(a), frac(b, 10), frac(c, 100), frac(d, 1000)}
    melanger(elements)

    local enonce = "$"
    for i = 1, #elements do
        enonce = enonce .. elements[i]
        if i ~= #elements then
            enonce = enonce .. "+"
        end
    end
    enonce = enonce .. "$"

    local reponses = {num(a+b/10+c/100+d/1000), num(a+b/100+c/10+d/1000), num(a+b/1000+c/10+d/100), num(a+b/10+c/1000+d/100)}
    afficher_question(enonce, reponses, 1)
end

local function dessiner_angle(angle, texte)
    local dessin = "\\begin{tikzpicture}[baseline=(current bounding box.center)] \\coordinate (A) at ({cos(" .. angle .. ")}, {sin(" .. angle .. ")}); \\draw (1,0) -- (0,0) -- (A); \\draw[fill=black] (0.2,0) arc (0:" .. angle .. ":0.2) -- (0,0) -- cycle; \\node[anchor=south west] at (0.4,-0.05) {" .. texte .. "}; \\end{tikzpicture}"
    return dessin
end

local function mesurer_angle()
    local angle = math.random(2,16)*10
    
    local enonce = dessiner_angle(angle, "?")
    local reponses = {deg(angle), deg(angle+10), deg(angle-10), deg(angle+20), deg(angle-20)}

    afficher_question(enonce, reponses, 1)
end

local function mesurer_angle2()
    local angle = math.random(4,32)*5

    local enonce = "Lequel de ces angles mesure " .. deg(angle) .. " ?"

    local reponses = {dessiner_angle(angle, ""), dessiner_angle(angle+5, ""), dessiner_angle(angle-10, ""), dessiner_angle(angle+10, "")}

    afficher_question(enonce, reponses, 1)
end


return { qA = addition_aleatoire, qB = soustraction_aleatoire, qC = divisibilite, qD = addition_fraction, qE = fractions_egales, qF = appartient, qG = mesurer_angle, qH = mesurer_angle2 }