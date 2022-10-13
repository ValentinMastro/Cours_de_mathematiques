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

local function num(n)
    -- afficher un nombre avec l'acriture SI
    return "\\num{" .. n .. "}"
end

local function frac(x, y)
    -- affiche une fraction
    return "$\\frac{\\mathstrut" .. num(x) .. "}{\\mathstrut" .. num(y) .. "}$"
end

local function tfrac(x, y)
    -- affiche une fraction
    return "$\\frac{" .. x .. "}{" .. y .. "}$"
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

    afficher_question(enonce, reponses, 2)
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

local function divpar5()
    local a = math.random(21, 85)

    local enonce = "Calculer en posant $" .. num(a) .. "\\div" .. num(5) .. "$"

    local r1 = string.format("%.2f", a/5)
    local r2 = string.format("%.2f", (a+1)/5)
    local r3 = string.format("%.2f", (a-1)/5)
    local r4 = string.format("%.2f", (a+2)/5)

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

local function angle_manquant()
    local a = math.random(10, 89)
    local b = math.random(10, 89)
    local rep = 180 - a - b

    local enonce = "\\begin{tikzpicture} \\draw (0,0) -- (2.8,0) -- (0.4, 0.7) -- cycle; \\draw[fill=black] (0.2,0) arc (0:55:0.2) -- (0,0) -- cycle; \\node at (0.4, 0.2) {\\scriptsize{\\ang{" .. a .. "}}}; \\draw[fill=black] (2.6,0) arc (180:168:0.2) -- (2.8,0) -- cycle; \\node at (2.8,0.15) {\\scriptsize{\\ang{" .. b .. "}}}; \\node at (0.43,0.55) {\\scriptsize{?}}; \\end{tikzpicture}"
    
    local reponses = {rep, rep+math.random(-19,-1), rep+math.random(1,8), rep+math.random(9,14), rep+math.random(15,20)}

    afficher_question(enonce, reponses, 1)
end

local function mediatrice()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local index1 = math.random(0, 25)
    local index2 = (index1 + math.random(1, 12)) % 26
    local index3 = (index2 + math.random(1, 12)) % 26

    local p1 = alphabet[index1 + 1]
    local p2 = alphabet[index2 + 1]
    local p3 = alphabet[index3 + 1]

    local points = {p1, p2, p3}
    melanger(points)

    local enonce = "\\begin{tikzpicture}[scale=0.5,baseline=(current bounding box.center)] \\coordinate (" .. p1 .. ") at (0,0); \\coordinate (" .. p2 .. ") at (2.8,0); \\coordinate (" .. p3 .. ") at (" .. math.random(12,24)/10 .. ",0.8); \\draw (" .. p1 ..") node[left]{" .. p1 .. "} -- (" .. p2 .. ") node[right]{" .. p2 .. "} -- (" .. p3 .. ") node[above left]{" .. p3 .. "} -- cycle; \\coordinate (mid) at ($(" .. points[1] .. ")!0.5!(" .. points[2] .. ")$); \\draw[densely dotted] ($(mid)!0.4cm!270:(" .. points[1] .. ")$) -- ($(mid)!0.4cm!90:(" .. points[1] .. ")$); \\end{tikzpicture}"

    local reponses = {"La médiatrice de $[" .. points[1] .. points[2] .. "]$","La médiatrice de $[" .. points[3] .. points[2] .. "]$", "La hauteur de $[" .. points[1] .. points[2] .. "]$", "La hauteur de $[" .. points[2] .. points[3] .. "]$"}
    afficher_question(enonce, reponses, 1)
end

local function hauteur()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local index1 = math.random(0, 25)
    local index2 = (index1 + math.random(1, 12)) % 26
    local index3 = (index2 + math.random(1, 12)) % 26

    local p1 = alphabet[index1 + 1]
    local p2 = alphabet[index2 + 1]
    local p3 = alphabet[index3 + 1]

    local points = {p1, p2, p3}
    melanger(points)

    local enonce = "\\begin{tikzpicture}[scale=0.5,baseline=(current bounding box.center)] \\coordinate (" .. p1 .. ") at (0,0); \\coordinate (" .. p2 .. ") at (2.8,0); \\coordinate (" .. p3 .. ") at (" .. math.random(12,24)/10 .. ",0.8); \\draw (" .. p1 ..") node[left]{" .. p1 .. "} -- (" .. p2 .. ") node[right]{" .. p2 .. "} -- (" .. p3 .. ") node[above left]{" .. p3 .. "} -- cycle; \\coordinate (H) at ($(" .. points[1] .. ")!(" .. points[3] .. ")!(" .. points[2] .. ")$); \\draw[densely dotted] ($(H)!-0.1!(" .. points[3] .. ")$) -- ($(H)!1.1!(" .. points[3] .. ")$); \\end{tikzpicture}"

    local reponses = {"La hauteur de $[" .. points[1] .. points[2] .. "]$","La médiatrice de $[" .. points[3] .. points[2] .. "]$", "La médiatrice de $[" .. points[1] .. points[2] .. "]$", "La hauteur de $[" .. points[2] .. points[3] .. "]$"}
    afficher_question(enonce, reponses, 1)
end


local function multiplication_avec_simplification()
    local premiers = {2, 3, 5, 6, 7, 10, 11}
    local a, b, c, d = table.unpack(objets_aleatoires_dans(premiers, 4))

    local enonce = frac(a, c*a) .. "$\\times$" ..  num(b*c) .. "$~=$"
    local reponses = { b, b*a, c*a, a, c }

    afficher_question(enonce, reponses, 1)
end

local function proportion_32_cartes()
    local possibilites = {"valets", "rois", "dames", "coeurs", "carreaux", "piques", "trèfles", "figures (valets, dames, rois)", "cartes numérotées (7, 8, 9, 10)"}
    local pos_reponses = {4, 4, 4, 8, 8, 8, 8, 12, 16}

    local choix = math.random(1, #possibilites)
    local rep = pos_reponses[choix]

    local enonce = "Combien y a-t-il de " .. possibilites[choix] .. " dans un jeu de 32 cartes ?"
    local reponses = {frac(rep, 32), frac(32, rep), frac(rep+2, 32), frac(32, rep+2)}

    afficher_question(enonce, reponses, 1)
end

local function cours_triangle_isocele()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local index1 = math.random(0, 25)
    local index2 = (index1 + math.random(1, 12)) % 26
    local index3 = (index2 + math.random(1, 12)) % 26

    local p1 = alphabet[index1 + 1]
    local p2 = alphabet[index2 + 1]
    local p3 = alphabet[index3 + 1]

    local points = {p1, p2, p3}
    melanger(points)
    local nom = table.concat(points)

    local enonce = "Si " .. nom .. " est un triangle isocèle en " .. p2 .. " alors..."
    local reponses = {"$\\widehat{" .. p2 .. p1 .. p3 .. "} = \\widehat{" .. p1 .. p3 .. p2 .. "}$", "$\\widehat{" .. p3 .. p2 .. p1 .. "} = \\widehat{" .. p1 .. p3 .. p2 .. "}$", "$\\widehat{" .. p2 .. p1 .. p3 .. "} = \\widehat{" .. p1 .. p2 .. p3 .. "}$", "$\\widehat{" .. p1 .. p2 .. p3 .. "} = \\widehat{" .. p1 .. p3 .. p2 .. "}$"}

    afficher_question(enonce, reponses, 1)
end

local function addition_fractions()
    local nombres = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
    local a, b, c, k = table.unpack(objets_aleatoires_dans(nombres, 4))

    local enonce = frac(a, b) .. "$~+~$" .. frac(c, k*b) .. "$~=$"
    local reponses = { frac(k*a + c, k*b) , frac(a + k*c, k*b) , frac(k*a + c, 2*k*b), frac(a + k*c, 2*k*b), frac(a+c, b + k*b) }

    afficher_question(enonce, reponses, 2)
end

local function egalite_fraction()
    local nombres = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
    local a, b, k = table.unpack(objets_aleatoires_dans(nombres, 3))

    local enonce = frac(a, b) .. "$~=~$" .. tfrac("?", k*b)
    local reponses = { k*a, (k-1)*a, k*b, k*k, (k-1)*b }

    afficher_question(enonce, reponses, 1)
end

return { qA = angle_manquant, qB = mediatrice, qC = proportion_32_cartes, qD = multiplication_aleatoire, qE = divpar11, qF = egalite_fraction, qG = triangle, qH = multiplication_avec_simplification, qI = addition_fractions}