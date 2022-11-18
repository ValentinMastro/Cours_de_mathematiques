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

local function small(texte)
    return "\\small{" .. texte .. "}"
end

local function scriptsize(texte)
    return "\\scriptsize{" .. texte .. "}"
end

local function footnotesize(texte)
    return "\\footnotesize{" .. texte .. "}"
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

    afficher_question(scriptsize(enonce), reponses, 1)
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

    afficher_question(scriptsize(enonce), reponses, 1)
end

local function volume_cylindre()
    local rayon = math.random(11,55) / 10
    local hauteur = math.random(56,99) / 10
    local enonce = "Calculer le volume d'un cylindre de rayon " .. qty(rayon,"\\metre") .. " et de hauteur " .. qty(hauteur, "\\metre")

    local a = math.pi * math.pow(rayon,2) * hauteur
    local b = (1/3) * math.pi * math.pow(rayon,2) * hauteur
    local c = (4/3) * math.pi * math.pow(rayon,3)
    local d = (4) * math.pi * math.pow(rayon,2)
    local e = 4 * math.pi * rayon

    local reponses = map(math.floor, {a, b, c, d, e}) 

    afficher_question(scriptsize(enonce), reponses, 1)
end

local function aire_sphere()
    local rayon = math.random(11,99) / 10
    local enonce = "Calculer l'aire d'une sphère de rayon " .. qty(rayon,"\\metre")

    local a = (4/3) * math.pi * math.pow(rayon,3)
    local b = (4) * math.pi * math.pow(rayon,3)
    local c = (4/3) * math.pi * math.pow(rayon,2)
    local d = (4) * math.pi * math.pow(rayon,2)
    local e = 4 * math.pi * rayon

    local reponses = map(math.floor, {d, b, c, a, e}) 

    afficher_question(scriptsize(enonce), reponses, 1)
end

local function arrondi2(n)
    return math.floor(n*100) / 100
end

local function evaluer_expression_a()
    local m = math.random(101,499) / 100
    local v = math.random(500,999) / 100

    local enonce = "\\makecell{\\small{$m=" .. num(m) .. "$ et $v=" .. num(v) .. "$} \\\\ \\small{$\\frac{1}{2}mv^2 = $}}"

    local reponses = map(num, map(arrondi2, {0.5*m*math.pow(v,2),0.5*m*v,0.5*math.pow(m,2)*v,0.5*math.pow(m,2)*math.pow(v,2),0.5}))

    afficher_question(enonce, reponses, 1)
end

local function evaluer_expression_b()
    local x = math.random(3,15)
    local a = math.random(2,9)
    local b = math.random(2,9)
    local c = math.random(2,9)

    local enonce = "\\makecell{\\small{$x=" .. x .. "$} \\\\ \\small{$" .. a .. "x^2+" .. b .. "x+" .. c .. "=$}}"
    local reponses = {a*x*x+b*x+c, a*x+b*x+c, a*x*x+b*x, a*x+b*x, (a*x)*(a*x) + b*x+c}

    afficher_question(enonce, reponses, 1)
end

local function somme_ou_produit()
    local a = math.random(2,9)
    local b = math.random(2,9)
    local c = math.random(2,9)
    local sommes = {"x+"..a.."y", "x(y+"..a..")+"..b, "(x+"..a..")(y-"..b..")", "(x+"..a..")^2+"..c}
    local produits = {"(2x+5)^2", "(x+7)(2x-5)", a.."x", b.."("..a.."+"..c.."x)"}

    if math.random(1,2) == 1 
    then
        afficher_question("$" .. objet_aleatoire_dans(sommes) .. "$", {"somme", "produit", "\\cellcolor{black}", "\\cellcolor{black}", "\\cellcolor{black}"}, 1 )
    else
        afficher_question("$" .. objet_aleatoire_dans(produits) .. "$", {"produit", "somme", "\\cellcolor{black}", "\\cellcolor{black}", "\\cellcolor{black}"}, 1 )
    end
end


return { qA = volume_boule, qB = volume_cone, qC = aire_sphere, qD = evaluer_expression_a, qE = evaluer_expression_b, qF = somme_ou_produit, qG = volume_cylindre }