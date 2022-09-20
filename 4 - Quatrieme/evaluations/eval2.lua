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


local function multiplication_aleatoire()
    local a = math.random(101,999) / math.pow(10, math.random(0,1))
    local b = math.random(101,999) / math.pow(10, math.random(0,1))
    local reponses = {num(a*b), num(a*b+10), num(a*b-10), num(a*b+100)}
    local enonce = "Calculer $" .. num(a) .. "\\times" .. num(b) .. "$"

    afficher_question(enonce, reponses, 1)
end

local function carre_aleatoire()
    local a = math.random(21,100) / math.pow(10, math.random(0,1))

    local reponses = {num(math.pow(a, 2)), num(a*2), num(math.pow(a, 2) + math.random(1, 10)), num(a*2 + math.random(1, 10))}
    local enonce = "Calculer $" .. num(a) .. "^2$"

    afficher_question(enonce, reponses, 1)
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

local function priorites()
    local a = math.random(3, 12)
    local b = math.random(3, 12)
    local c = math.random(3, 12)

    local enonce = "Calculer $" .. num(a) .. "+" .. num(b) .. "\\times" .. num(c) .. "$"
    local reponses = {num(a+(b*c)), num((a+b)*c), num(a+(b*c) + math.random(10, 99)), num(a+(b*c) + math.random(10, 99)) }

    afficher_question(enonce, reponses, 1)
end

local function priorites2()
    local a = math.random(3, 12)
    local b = math.random(3, 12)
    local c = math.random(3, 12)

    local enonce = "Calculer $(" .. num(a) .. "+" .. num(b) .. ")\\times" .. num(c) .. "$"
    local reponses = {num((a+b)*c), num(a+(b*c)), num((a+b)*c + math.random(10, 99)), num((a+b)*c + math.random(10, 99)) }

    afficher_question(enonce, reponses, 1)
end

local function priorites3()
    local a = math.random(3, 12)
    local b = math.random(3, 12)
    local c = math.random(3, 12)
    local d = math.random(3, 12)

    local enonce = "Calculer $(" .. num(a) .. "\\times" .. num(b) .. ")+(" .. num(c) .. "+" .. num(d) .. "\\times" .. num(a) .. ")$"
    local reponses = {num( (a*b) + (c+(d*a)) ), num( (a*b) + ((c+d)*a) ), num((a*b) + (c+(d*a)) + math.random(10, 99)), num((a*b) + (c+(d*a)) + math.random(10, 99)) }

    afficher_question(enonce, reponses, 1)
end

local function racine()
    local a = math.random(4, 12)

    local enonce = "Calculer $\\sqrt{" .. num(a*a) .. "}$"
    local reponses = {num(a), num(a+1), num(a-1), num(a+objet_aleatoire_dans({-2, 2}))}

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

    local enonce = "Dans le triangle $" .. p1 .. p2 .. p3 .. "$ rectangle en $" .. p3 .. "$, l'égalité de Pythagore est :"
    local hyp = p1 .. p2 .. "^2"
    local c1 = p1 .. p3 .. "^2"
    local c2 = p2 .. p3 .. "^2"

    local reponses = { "\\tiny{$" .. hyp .. "{=}" .. c1 .. "{+}" .. c2 .. "$}",     "\\tiny{$" .. c1 .. "{=}" .. hyp .. "{+}" .. c2 .. "$}",          "\\tiny{$" .. c2 .. "{=}" .. hyp .. "{+}" .. c2 .. "$}",       "\\tiny{$" .. c1 .. "{=}" .. c2 .. "{+}" .. hyp .. "$}" }

    afficher_question(enonce, reponses, 1)
end



return { qA = multiplication_aleatoire, qB = carre_aleatoire, qC = hypotenuse, qD = priorites, qE = priorites2, qF = racine, qG = priorites3, qH = egalite_pythagore}