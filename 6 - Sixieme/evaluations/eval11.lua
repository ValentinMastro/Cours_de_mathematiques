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

local function small(texte)
    return "\\small{" .. texte .. "}"
end

local function scriptsize(texte)
    return "\\scriptsize{" .. texte .. "}"
end

local function footnotesize(texte)
    return "\\footnotesize{" .. texte .. "}"
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
    if math.abs(n) < 1e-4
    then
        return "\\num[round-pad = false]{" .. string.format("%0.8f", n) .. "}"
    end
    if isint(n) then
        return "\\num{" .. math.floor(n) .. "}"
    else
        return "\\num[scientific-notation=false]{" .. n .. "}"
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

local function dessiner_angle(angle, texte)
    local dessin = "\\begin{tikzpicture}[baseline=(current bounding box.center),scale=1.5] \\coordinate (A) at ({cos(" .. angle .. ")}, {sin(" .. angle .. ")}); \\draw (1,0) -- (0,0) -- (A); \\draw[fill=black] (0.2,0) arc (0:" .. angle .. ":0.2) -- (0,0) -- cycle; \\node[anchor=south west] at (0.4,-0.05) {" .. texte .. "}; \\end{tikzpicture}"
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

local function multiplier_diviser_puiss_10()
    local nombre = math.random(101,999) / math.pow(10, math.random(-1,1))
    local facteur = math.pow(10, math.random(1,3))

    if math.random(1,2) == 1
    then
        local enonce = scriptsize("$" .. num(nombre) .. " \\times " .. num(facteur) .. " = $")
        local reponses = map(scriptsize, {num(nombre*facteur), num(nombre*facteur*10), num(nombre*facteur*100), num(nombre*facteur/10), num(nombre*facteur/100)})
        afficher_question(enonce, reponses, 1)
    else
        local enonce = scriptsize("$" .. num(nombre) .. " \\div " .. num(facteur) .. " = $")
        local reponses = map(scriptsize, {num(nombre/facteur), num(nombre/facteur*10), num(nombre/facteur*100), num(nombre/facteur/10), num(nombre/facteur/100)})
        afficher_question(enonce, reponses, 1)
    end
end

local function poser_multiplication()
    local a = math.random(100,999) / math.pow(10, math.random(-1,3))
    local b = math.random(100,999) / math.pow(10, math.random(-1,3))
    local enonce = scriptsize("$" .. num(a) .. " \\times " .. num(b) .. " =$")

    local reponses = map(scriptsize,{num(a*b), num(a*2*b), num(a*b/2), num(a*b*10), num(a*b*2/10)})

    afficher_question(enonce, reponses, 2)
end

local function gerer_index(i)
    return ((i + 6) % 13) - 6
end

local function convertion()
    local unites = {"\\metre", "\\gram", "\\second", "\\candela", "\\kelvin", "\\ampere", "\\mole"}
    local prefixes = {"\\kilo", "\\hecto", "\\deca", "", "\\deci", "\\centi", "\\milli"}

    melanger(unites)
    melanger(prefixes)
    local nombre = math.random(100,999) / math.pow(10, math.random(-1,2))

    local index1 = trouver_element_dans_liste(prefixes[1], {"\\kilo", "\\hecto", "\\deca", "", "\\deci", "\\centi", "\\milli"} )
    local index2 = trouver_element_dans_liste(prefixes[2], {"\\kilo", "\\hecto", "\\deca", "", "\\deci", "\\centi", "\\milli"} )
    local indexes = map(gerer_index, {index2-index1, index2-index1+1, index2-index1+2, index2-index1+3, index2-index1+4})

    local reponses = map(scriptsize, map(num, {nombre * math.pow(10, indexes[1]), nombre * math.pow(10, indexes[2]), nombre * math.pow(10, indexes[3]), nombre * math.pow(10, indexes[4]), nombre * math.pow(10, indexes[5])}))

    if nombre==math.floor(nombre) then nombre = math.floor(nombre) end
    local enonce = scriptsize("$\\qty{" .. nombre .. "}{" .. prefixes[1] .. unites[1] .. "} = ~~~\\unit{" .. prefixes[2] .. unites[1] .. "}$")

    afficher_question(enonce, reponses, 1)
end

local function plus_petit_que_nombres_decimaux()
    local decal = math.pow(10,math.random(-3,-1))
    local a = math.random(1000, 1000000) * decal

    local enonce = scriptsize("Lequel de ces nombres est $\\infeg$ à " .. num(a))
    local reponses = map(scriptsize, {num(a - 3* decal), num(a + 2 * decal), num(a + 50*decal), num(a + 700*decal), num(a + decal)})

    afficher_question(enonce, reponses, 1)
end

local function plus_grand_que_nombres_decimaux()
    local decal = math.pow(10,math.random(-3,-1))
    local a = math.random(1000, 1000000) * decal

    local enonce = scriptsize("Lequel de ces nombres est $\\supeg$ que " .. num(a))
    local reponses = map(scriptsize, {num(a + 3* decal), num(a - 2 * decal), num(a - 50*decal), num(a - 700*decal), num(a - decal)})

    afficher_question(enonce, reponses, 1)
end

local function probleme_division_euclidienne()
    local a = math.random(101,999)
    local b = math.random(4,9)

    local choix = math.random(1,2)

    if choix == 1 then 
        local enonce = scriptsize(objet_aleatoire_dans(
            {a .. " élèves mangnent à la cantine à des tables de " .. b .. ". Combien faut-il de tables ?",
            "Une étagère peut contenir " .. b .. " livres. Combien en faut-il pour ranger " .. a .. " livres ?"}))
        local reponses = map(small, {math.floor(a/b) + 1, math.floor(a/b), math.floor(a/b)+2, math.floor(a/b) - 1, math.floor(a/b) - 2})
        afficher_question(enonce, reponses, 1)
    end
    if choix == 2 then
        local enonce = scriptsize(objet_aleatoire_dans(
            {"Il faut " .. b .. " ampoules pour faire une guirlande électrique. Combien de guirlandes peut-on faire avec " .. a .. " ampoules ?",
            "Une fermière vend des boites de " .. b .. " oeufs. Combien vendra-t-elle de boites si elle ramasse " .. a .. " oeufs aujourd'hui ?"}))
        local reponses = map(small, {math.floor(a/b), math.floor(a/b) + 1, math.floor(a/b)+2, math.floor(a/b) - 1, math.floor(a/b) - 2})
        afficher_question(enonce, reponses, 1)
    end
end

local function somme_diff_prod_quotient()
    local a = math.random(2, 7)
    local b = math.random(2, 4)*a

    local choix = math.random(1,4)
    local enonce = ""
    local reponses = {}

    if choix == 1 then
      enonce = "Somme de " .. a .. " et de " .. b
      reponses = {a+b, b-a, a*b, b/a, 1}
    end
    if choix == 2 then
      enonce = "Différence entre " .. b .. " et " .. a
      reponses = {b-a, a+b, a*b, b/a, 1}
    end
    if choix == 3 then
      enonce = "Produit de " .. a .. " par " .. b
      reponses = {a*b, b-a, a+b, b/a, 1}
    end
    if choix == 4 then
      enonce = "Quotient de " .. b .. " par " .. a
      reponses = {b/a, b-a, a*b, a+b, 1}
    end

    afficher_question(scriptsize(enonce), map(scriptsize, map(num, reponses)), 1)
end

local function decalage_vertical()
    return "\\vphantom{$\\frac{2^{2^{2}}}{2^{2^2}}$}"
end

local function addition_fraction()
    local a = math.random(1, 20)
    local b = math.random(1, 20)
    local c = math.random(1, 20)

    local enonce = frac(a, c) .. " + " .. frac(b, c) .. " $=$" .. decalage_vertical()
    local reponses = {frac(a+b, c), frac(a+b, c+c), frac(a+b+1, c), frac(a+b+1, c+c), frac(a+b-1, c)}

    afficher_question(enonce, reponses, 1)
end

local function fractions_egales()
    local nombres = {2, 3, 4, 5, 6, 7, 8, 9, 10}
    local a, b, c = table.unpack(objets_aleatoires_dans(nombres, 3))

    local enonce = frac(a, b) .. " = $\\frac{" .. a*c .. "}{?}$" .. decalage_vertical()
    local reponses = {num(b*c), num(a*b), num(c*a), num(a*b*c), num(b*b)}

    afficher_question(enonce, reponses, 1)
end

return { qA = multiplier_diviser_puiss_10, qB = somme_diff_prod_quotient, qC = convertion, qD = mesurer_angle, qE = probleme_division_euclidienne, qF = addition_fraction, qG = fractions_egales }