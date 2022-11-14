local function objet_aleatoire_dans(liste)
    local index = math.random(1,#liste)
    return liste[index]
end

local function map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
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


local function volume_boule()
    local rayon = math.random(11,99) / 10
    local enonce = "Calculer le volume d'une boule de rayon " .. qty(rayon,"\\metre")

    local a = (4/3) * math.pi * math.pow(rayon,3)
    local b = (4) * math.pi * math.pow(rayon,3)
    local c = (4/3) * math.pi * math.pow(rayon,2)
    local d = (4) * math.pi * math.pow(rayon,2)
    local e = 4 * math.pi * rayon

    local reponses = map(math.floor, {a, b, c, d, e}) 

    afficher_question(enonce, reponses, 1)
end

local function volume_cone()
    local rayon = math.random(11,55) / 10
    local hauteur = math.random(56,99) / 10
    local enonce = "Calculer le volume d'un cône de rayon " .. qty(rayon,"\\metre") .. " et de hauteur " .. qty(hauteur, "\\metre")

    local a = (1/3) * math.pi * math.pow(rayon,2) * hauteur
    local b = (4/3) * math.pi * math.pow(rayon,2) * hauteur
    local c = (4/3) * math.pi * math.pow(rayon,3)
    local d = (4) * math.pi * math.pow(rayon,2)
    local e = 4 * math.pi * rayon

    local reponses = map(math.floor, {a, b, c, d, e}) 

    afficher_question(enonce, reponses, 1)
end


return { qA = volume_boule, qB = volume_cone }