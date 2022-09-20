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

local function addition_aleatoire(n)
    local a = math.random(math.pow(10,n),math.pow(10,n+1)-1)
    local b = math.random(math.pow(10,n),math.pow(10,n+1)-1)
    local reponses = {a+b, a+b+10, a+b-10, a+b+100}
    local enonce = "Calculer $" .. a .. "+" .. b .. "$"

    afficher_question(enonce, reponses, 1)
end


local function soustraction_aleatoire(n)
    local a = math.random(math.pow(10,n),math.pow(10,n+1)-1)
    local b = math.random(math.pow(10,n),math.pow(10,n+1)-1)

    -- a doit être plus grand que b
    if a < b then
        a, b = b, a
    end

    local reponses = {a-b, a-b-10, a-b+110, a-b+100}
    local enonce = "Calculer $" .. a .. "-" .. b .. "$"

    afficher_question(enonce, reponses, 1)
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

local function multiplication_aleatoire(n)
    local a = math.random(math.pow(10,n),math.pow(10,n+1)-1)
    local b = math.random(math.pow(10,n),math.pow(10,n+1)-1)

    local enonce = "Calculer $" .. num(a) .. "\\times" .. num(b) .. "$"
    local reponses = {num(a*b), num(a*b+10), num(a*b-10), num(a*b+100)}

    afficher_question(enonce, reponses, 1)
end

local function divpar11()
    local a = math.random(21, 85)

    local enonce = "Calculer en posant $" .. num(a) .. "\\div" .. num(11) .. "$"

    local r1 = "$\\approx$" .. num(string.format("%.2f", a/11))
    local r2 = "$\\approx$" .. num(string.format("%.2f", (a+1)/11))
    local r3 = "$\\approx$" .. num(string.format("%.2f", (a-1)/11))
    local r4 = "$\\approx$" .. num(string.format("%.2f", (a+2)/11))

    local reponses = {r1, r2, r3, r4}

    afficher_question(enonce, reponses, 1)
end

local function divpar9()
    local a = math.random(21, 85)

    local enonce = "Calculer en posant $" .. num(a) .. "\\div" .. num(9) .. "$"

    local r1 = "$\\approx$" .. num(string.format("%.2f", a/9))
    local r2 = "$\\approx$" .. num(string.format("%.2f", (a+1)/9))
    local r3 = "$\\approx$" .. num(string.format("%.2f", (a-1)/9))
    local r4 = "$\\approx$" .. num(string.format("%.2f", (a+2)/9))

    local reponses = {r1, r2, r3, r4}

    afficher_question(enonce, reponses, 1)
end

local function divpar4()
    local a = math.random(21, 85)

    local enonce = "Calculer en posant $" .. num(a) .. "\\div" .. num(4) .. "$"

    local r1 = string.format("%.2f", a/4)
    local r2 = string.format("%.2f", (a+1)/4)
    local r3 = string.format("%.2f", (a-1)/4)
    local r4 = string.format("%.2f", (a+2)/4)

    local reponses = {num(r1), num(r2), num(r3), num(r4)}

    afficher_question(enonce, reponses, 1)
end

local function triangle()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local index1 = math.random(0, 25)
    local index2 = (index1 + math.random(1, 12)) % 26
    local index3 = (index2 + math.random(1, 12)) % 26

    local p1 = alphabet[index1 + 1]
    local p2 = alphabet[index2 + 1]
    local p3 = alphabet[index3 + 1]

    local c1 = "$" .. p1 .. p2 .. "$"
    local c2 = "$" .. p2 .. p3 .. "$"
    local c3 = "$" .. p3 .. p1 .. "$"

    local enonce = "Lequel de ces triangles " .. p1 .. p2 .. p3 .. " peut être construit ?"

    local a = math.random(2,7)
    local b = math.random(8,9)

    local r1 = c1 .. "$=" .. num(a) .. "$ et " .. c2 .. "$=" .. num(b) .. "$ et " .. c3 .. "$=" .. num(a+b-1) .. "$"
    local r2 = c1 .. "$=" .. num(a) .. "$ et " .. c2 .. "$=" .. num(b) .. "$ et " .. c3 .. "$=" .. num(a+b+1) .. "$"
    local r3 = c1 .. "$=" .. num(a+1) .. "$ et " .. c2 .. "$=" .. num(b+1) .. "$ et " .. c3 .. "$=" .. num(a+b+3) .. "$"
    local r4 = c1 .. "$=" .. num(a-1) .. "$ et " .. c2 .. "$=" .. num(b-1) .. "$ et " .. c3 .. "$=" .. num(a+b) .. "$"
    
    local reponses = {r1, r2, r3, r4}

    afficher_question(enonce, reponses, 1)
end


return { qA = addition_aleatoire, qB = soustraction_aleatoire, qC = chiffres, qD = multiplication_aleatoire, qE = divpar11, qF = divpar9, qG = triangle, qH = divpar4 }