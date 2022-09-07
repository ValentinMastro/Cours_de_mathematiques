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

local function num(n)
    -- afficher un nombre avec l'acriture SI
    return "\\num{" .. n .. "}"
end

local function frac(x, y)
    -- affiche une fraction
    return "$\\frac{" .. num(x) .. "}{" .. num(y) .. "}$"
end

local function addition_aleatoire()
    local a = math.random(1001,9999)
    local b = math.random(1001,9999)
    local reponses = {a+b, a+b+10, a+b-10, a+b+100}
    local enonce = "Calculer $" .. a .. "+" .. b .. "$"

    afficher_question(enonce, reponses, 1)
end


local function soustraction_aleatoire()
    local a = math.random(1001,9999)
    local b = math.random(1001,9999)

    -- a doit être plus grand que b
    if a < b then
        a, b = b, a
    end

    local reponses = {a-b, a-b-10, a-b+110, a-b+100}
    local enonce = "Calculer $" .. a .. "-" .. b .. "$"

    afficher_question(enonce, reponses, 1)
end

local function addition_relatifs(n)
    local a = math.random(-n,n)
    local b = math.random(-n,n)

    local reponses = {a+b, a-b, b-a, -a-b}
    local enonce = "Calculer $(" .. signe(a) .. ")+(" .. signe(b) .. ")$"

    afficher_question(enonce, reponses, 1)
end

local function nombre_entier()
    local a = math.random(2, 7)
    local b = math.random(2, 7) + 0.1*math.random(1,9)
    local c = math.random(2, 7) + 0.1*math.random(1,9)
    local d = math.random(2, 7) + 0.1*math.random(1,9)

    local reponses = {num(a), num(b), num(c), num(d)}
    local enonce = "Lequel de ces nombres est un entier naturel ?"

    afficher_question(enonce, reponses, 1)
end

local function entier_relatif()
    local a = math.random(2, 17)
    local b = math.random(2, 17) * (-1)
    local c = math.random(2, 17) + 0.1*math.random(1,9)
    local d = (math.random(2, 17) + 0.1*math.random(1,9)) * (-1)

    local reponses = {num(a), num(b), num(c), num(d)}
    local enonce = "Lequel de ces nombres est un entier relatif ?"

    afficher_question(enonce, reponses, 1)
end

local function est_une_fraction()
    local a = math.random(2, 25)
    local b = math.random(2, 25)
    local c = math.random(2, 25) + 0.1*math.random(1,9)
    local d = math.random(2, 25)
    local e = math.random(2, 25)
    local f = math.random(2, 25) + 0.1*math.random(1,9)
    local g = math.random(2, 25)

    local reponses = {frac(a,b), frac(c,d), frac(e,f), num(g)}
    local enonce = "Lequel de ces nombres est une fraction ?"

    afficher_question(enonce, reponses, 1)
end

local function est_une_fraction_decimale()
    local a = math.random(2, 25)
    local b = math.floor(math.pow(10, math.random(2,4)))
    local c = math.random(2, 999) 
    local d = math.floor(math.pow(3, math.random(4,7)))
    local e = math.random(2, 999) 
    local f = math.floor(math.pow(5, math.random(3,6)))
    local g = math.random(2, 999) 
    local h = math.floor(math.pow(7, math.random(2,5)))

    local reponses = {frac(a,b), frac(c,d), frac(e,f), frac(g,h)}
    local enonce = "Lequel de ces nombres est une fraction décimale ?"

    afficher_question(enonce, reponses, 1)
end

return { qA = addition_aleatoire, qB = soustraction_aleatoire, qC = addition_relatifs, qD = nombre_entier, qE = entier_relatif, qF = est_une_fraction, qG = est_une_fraction_decimale }