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

local function forcer_signe(n)
    if n > 0 then
        return "+" .. n
    else
        return n
    end
end

local function qty(n, unite)
    -- affiche une quantité avec son unité
    return "\\qty{" .. n .. "}{" .. unite .. "}"
end

local function frac(x, y)
    -- affiche une fraction
    return "\\dfrac{" .. x .. "}{" .. y .. "}"
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

local function tiny(texte)
    return "\\tiny{" .. texte .. "}"
end

local function decalage_vertical()
    return "\\vphantom{$\\dfrac{2^{2^{2}}}{2^{2^2}}$}"
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

local function evaluer_expression_c()
    local m = math.random(101,499) / 100
    local v = math.random(500,999) / 100
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

    local enonce = "\\begin{tikzpicture}[baseline=(current bounding box.center)] \\draw (0,0) -- (0.8,0) -- (0.8,0.8) -- cycle; \\draw[fill=black] (0.8,0) rectangle (0.7,0.1); \\node[above left] at (0,0) {\\scriptsize{$" .. p1 .. "$}}; \\node[above right] at (0.8,0) {\\scriptsize{$" .. p2 .. "$}}; \\node[right] at (0.8,0.8) {\\scriptsize{$" .. p3 .. "$}}; \\node[anchor=west] at (1.4,0.7) {\\scriptsize{$" .. p1 .. p2 .. "=" .. arrondi(a,1) .. "$}}; \\node[anchor=west] at (1.4,0.4) {\\scriptsize{$" .. p2 .. p3 .. "=" .. arrondi(b,1) .. "$}}; \\node[anchor=west] at (1.4,0.1) {\\scriptsize{$" .. p1 .. p3 .. "=~?" .. "$}}; \\end{tikzpicture}"

    local reponses = {arrondi(c, 2), arrondi(math.sqrt(math.abs(a*a-b*b)), 2), arrondi(c + 0.5 + math.random()*3, 2), arrondi(c + 0.5 + math.random()*3, 2), arrondi(c + 0.5 + math.random()*3, 2) }

    afficher_question(enonce, reponses, 1)
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

    local enonce = "\\begin{tikzpicture}[baseline=(current bounding box.center)] \\draw (0,0) -- (0.8,0) -- (0.8,0.8) -- cycle; \\draw[fill=black] (0.8,0) rectangle (0.7,0.1); \\node[above left] at (0,0) {\\scriptsize{$" .. p1 .. "$}}; \\node[above right] at (0.8,0) {\\scriptsize{$" .. p2 .. "$}}; \\node[right] at (0.8,0.8) {\\scriptsize{$" .. p3 .. "$}}; \\node[anchor=west] at (1.4,0.7) {\\scriptsize{$" .. p3 .. p1 .. "=" .. arrondi(a,1) .. "$}}; \\node[anchor=west] at (1.4,0.4) {\\scriptsize{$" .. p1 .. p2 .. "=" .. arrondi(b,1) .. "$}}; \\node[anchor=west] at (1.4,0.1) {\\scriptsize{$" .. p2 .. p3 .. "=~?" .. "$}}; \\end{tikzpicture}"

    local reponses = {arrondi(c, 2), arrondi(math.sqrt(a*a+b*b), 2), arrondi(c + 0.5 + math.random(), 2), arrondi(c - 0.5 - math.random(), 2), arrondi(c - 0.5 - math.random(), 2) }

    afficher_question(enonce, reponses, 1)
end

local function polyn(x, y, z)
    return "$" .. x .. "x^2" .. forcer_signe(y) .. "x" .. forcer_signe(z) .. "$"
end

local function double_developpement()
    local nombres = {2,3,4,5,6,7,8,9,10,11,12}
    local a, b, c, d = table.unpack(objets_aleatoires_dans(nombres, 4))
    local enonce = footnotesize("$(" .. a .. "x+" .. b .. ")(" .. c .. "x+" .. d .. ")=$")

    local reponses = map(footnotesize,{polyn(a*c, a*d+b*c, b*d), polyn(a+c, a+d+b+c, b+d), polyn(a*c, a*d+b*c-1, b*d), polyn(a*b, a*d+b*c-1, b*c), polyn(a+c, a+d+b+c+1, b+d)})

    afficher_question(enonce, reponses, 2)
end

local function double_developpement_signes()
    local nombres = {2,3,4,5,6,7,8,9,10,11,12, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12}
    local a, b, c, d = table.unpack(objets_aleatoires_dans(nombres, 4))
    local enonce = footnotesize("$(" .. a .. "x" .. forcer_signe(b) .. ")(" .. c .. "x" .. forcer_signe(d) .. ") = $")

    local i = a*c
    local j = a*d+b*c
    local k = b*d

    local reponses = map(footnotesize,{polyn(i, j, k), polyn(i, -j, k), polyn(i, j, -k), polyn(-i, j, k), polyn(-i, j, -k)})

    afficher_question(enonce, reponses, 2)
end

local function dollar(t)
    return "$" .. t .. "$"
end

local function factoriser()
    local facteurs = {1,2,5,10}
    local f = objet_aleatoire_dans(facteurs)
    local nombres = {7,8,9,11}
    local a, b = table.unpack(objets_aleatoires_dans(nombres, 2))

    local enonce = footnotesize("Factoriser $" .. a*f .. "x^2+" .. b*f .. "x =$")
    local rep1 = f .. "x(" .. a .. "x+" .. b .. ")"
    local rep2 = "x(" .. a .. "x+" .. b .. ")"
    local rep3 = f .. "x(" .. b .. "x+" .. a .. ")"
    local rep4 = "x(" .. b .. "x+" .. a .. ")"
    local rep5 = f .. "(" .. a .. "x+" .. b .. ")"
    local reponses = map(scriptsize, map(dollar, {rep1, rep2, rep3, rep4, rep5}))

    afficher_question(enonce, reponses, 1)
end

local function factoriser2()
    local facteurs = {2,3,5,10}
    local f = objet_aleatoire_dans(facteurs)
    local nombres = {7,8,9,11}
    local a, b = table.unpack(objets_aleatoires_dans(nombres, 2))

    local enonce = footnotesize("Factoriser $" .. a*f .. "x+" .. b*f .. " =$")
    local rep1 = f .. "(" .. a .. "x+" .. b .. ")"
    local rep2 = "x(" .. a .. "x+" .. b .. ")"
    local rep3 = f .. "x(" .. b .. "x+" .. a .. ")"
    local rep4 = "x(" .. b .. "x+" .. a .. ")"
    local rep5 = f .. "x(" .. a .. "x+" .. b .. ")"
    local reponses = map(scriptsize, map(dollar, {rep1, rep2, rep3, rep4, rep5}))

    afficher_question(enonce, reponses, 1)
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

local function rapports(a, b, c, d, e, f, g, h, i, j, k, l)
    return "$" .. frac(a .. b, c .. d) .. "{=}" .. frac(e .. f, g .. h) .. "{=}" .. frac(i .. j, k .. l) .. "$"
end

local function rapport_thales_classique()
    local alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    local p1, p2, p3, p4, p5 = table.unpack(objets_aleatoires_dans(alphabet,5))

    local enonce = scriptsize(
        "\\begin{tikzpicture}[scale=0.45,baseline=(current bounding box.center)]" .. 
            "\\draw (0,0) node[left]{" .. p1 .. "} -- " ..
                   "(1,0.5) node[above]{" .. p2 .. "} -- " ..
                   "(2,1) node[right]{" .. p3 .. "} -- " ..
                   "(2,-1) node[right]{" .. p5 .. "} --" ..
                   "(1,-0.5) node[below]{" .. p4 .. "} -- cycle;" ..
            "\\draw (1,0.5) -- (1,-0.5);" ..
            "\\node[anchor=west] at (2.4,0) {$(" .. p2 .. p4 .. "){\\paral}(" .. p3 .. p5 .. ")$};" ..
        "\\end{tikzpicture}")

    local reponses = map(tiny,{
                      rapports(p1,p3,p1,p2,p1,p5,p1,p4,p3,p5,p2,p4),
                      rapports(p1,p2,p3,p4,p1,p3,p1,p5,p2,p1,p3,p5),
                      rapports(p3,p2,p1,p4,p1,p3,p2,p5,p2,p4,p3,p5),
                      rapports(p1,p2,p1,p4,p1,p5,p1,p3,p2,p4,p3,p5),
                      rapports(p1,p2,p1,p4,p1,p3,p1,p5,p3,p4,p1,p5)})

    afficher_question(enonce, reponses, 1)
end

local function si(radical, exposant)
    return "$" .. num(radical) .. "\\times 10^{" .. exposant .. "}$"
end

local function ecriture_scientifique()
    local a = math.random(101,999)/100
    local b = a * math.pow(10, math.random(-3,3))

    local enonce = scriptsize("Donner l'écriture scientifique de " .. num(b))
    local decal = math.floor(math.log(b, 10))
    local radical = b / math.pow(10,decal)

    local reponses = map(scriptsize, {si(radical, decal), 
                      si(10*radical, decal-1),
                      si(0.1*radical, decal+1),
                      si(0.1*radical, -decal),
                      si(radical, decal+1)})

    afficher_question(enonce, reponses, 1)
end

local function calcul_thales()
    local ab = math.random(2,7)
    local ad = math.random(2,7)
    local bd = ab + ad - 1
    local k = math.random(2,7)
    local ac, ae, ce = ab*k, ad*k, bd*k

    local donnees = {"$AB=" .. ab .. "$",
                     "$AD=" .. ad .. "$",
                     "$BD=" .. bd .. "$",
                     "$AC=" .. ac .. "$",
                     "$AE=" .. ae .. "$",
                     "$CE=" .. ce .. "$"}

    local d1, d2, d3, d4, d5, r1 = table.unpack(objets_aleatoires_dans(donnees,6))

    local enonce = scriptsize(
    "\\begin{tikzpicture}[scale=0.4,baseline=(current bounding box.center)]" .. 
        "\\draw (0,0) node[left]{A} -- " ..
               "(1,0.5) node[above]{B} -- " ..
               "(2,1) node[right]{C} -- " ..
               "(2,-1) node[right]{E} --" ..
               "(1,-0.5) node[below]{D} -- cycle;" ..
        "\\draw (1,0.5) -- (1,-0.5);" ..
        "\\node[anchor=west] at (3,1) {" .. d1 .. "};" ..
        "\\node[anchor=west] at (3,0.4) {" .. d2 .. "};" ..
        "\\node[anchor=west] at (3,-0.2) {" .. d3 .. "};" ..
        "\\node[anchor=west] at (3,-0.8) {" .. d4 .. "};" ..
        "\\node[anchor=west] at (3,-1.4) {" .. d5 .. "};" ..
    "\\end{tikzpicture}")

    local i = string.find(r1, "=")
    local cote = string.sub(r1, 2, i-1)
    local res = string.sub(r1, i+1, #r1 - 1)

    local x2, x3, x4, x5 = table.unpack(objets_aleatoires_dans({2, 3, 4, 5, 6, 7, -1, -2, -3, -4, -5}))
    local r2, r3, r4, r5 =  "$" .. cote .. " = " .. num(res + x2) .. "$",
                            "$" .. cote .. " = " .. num(res + x3) .. "$",
                            "$" .. cote .. " = " .. num(res + x4) .. "$",
                            "$" .. cote .. " = " .. num(res + x5) .. "$"

    local reponses = {r1, r2, r3, r4, r5}
    afficher_question(enonce, reponses, 2)
end

local function puissances_addition(n)
    local a = math.random(1,10)*objet_aleatoire_dans({1,-1})
    local b = math.random(1,10)*objet_aleatoire_dans({1,-1})
    local enonce = scriptsize("$" .. n .. "^{" .. a .. "} \\times " .. n .. "^{" .. b .. "} = $")

    local reponses = map(scriptsize, {"$" .. n .. "^{" .. a+b .. "}$",
                      "$" .. n .. "^{" .. a+b+1 .. "}$",
                      "$" .. n .. "^{" .. a+b+2 .. "}$",
                      "$" .. n .. "^{" .. a+b-1 .. "}$",
                      "$" .. n .. "^{" .. a+b-2 .. "}$"})

    afficher_question(enonce, reponses, 1)
end

local function puissances_soustraction(n)
    local a = math.random(1,10)*objet_aleatoire_dans({1,-1})
    local b = math.random(1,10)*objet_aleatoire_dans({1,-1})
    local enonce = scriptsize("$\\dfrac{" .. n .. "^{" .. a .. "}}{" .. n .. "^{" .. b .. "}} = $" .. decalage_vertical())

    local reponses = map(scriptsize, {"$" .. n .. "^{" .. a-b .. "}$",
                      "$" .. n .. "^{" .. a-b+1 .. "}$",
                      "$" .. n .. "^{" .. a-b+2 .. "}$",
                      "$" .. n .. "^{" .. a-b-1 .. "}$",
                      "$" .. n .. "^{" .. a-b-2 .. "}$"})

    afficher_question(enonce, reponses, 1)
end

local function puissances_multiplication(n)
    local a = math.random(1,10)*objet_aleatoire_dans({1,-1})
    local b = math.random(1,10)*objet_aleatoire_dans({1,-1})
    local enonce = scriptsize("$(" .. n .. "^{" .. a .. "})^{" .. b .. "} = $")

    local reponses = map(scriptsize, {"$" .. n .. "^{" .. a*b .. "}$",
                      "$" .. n .. "^{" .. a*b+1 .. "}$",
                      "$" .. n .. "^{" .. a*b+2 .. "}$",
                      "$" .. n .. "^{" .. a*b-1 .. "}$",
                      "$" .. n .. "^{" .. a*b-2 .. "}$"})

    afficher_question(enonce, reponses, 1)
end

local function puissances(n)
    local n = objet_aleatoire_dans({10, 2, 3, 4, 5, 6, 7, 8, 9})
    local i = objet_aleatoire_dans({1,2,3})
    if i == 1 then puissances_addition(n) end
    if i == 2 then puissances_soustraction(n) end
    if i == 3 then puissances_multiplication(n) end
end

local function signe_puissances()
    local a = -1*math.random(2,9)
    local b = math.random(3,99)

    local enonce = small("Signe de $(" .. a .. ")^{" .. b .. "}$" .. decalage_vertical())
    if math.mod(b,2) == 0 then
        local reponses = map(small,{"positif", "négatif", "\\cellcolor{black}", "\\cellcolor{black}", "\\cellcolor{black}"})
        afficher_question(enonce, reponses, 1)
    end
    if math.mod(b,2) == 1 then
        local reponses = map(small,{"négatif", "positif", "\\cellcolor{black}", "\\cellcolor{black}", "\\cellcolor{black}"})
        afficher_question(enonce, reponses, 1)
    end
end

return { qA = puissances, qB = ecriture_scientifique, qC = calcul_thales, qD = rapport_thales_classique, qE = double_developpement, qF = factoriser2, qG = signe_puissances }