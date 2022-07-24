function niveau()
    tex.print(test)
    for y = 1,4
    do
        x1, y1, x2, y2 = 0, -0.3*y+0.1, 0.2, -0.3*y-0.1
        tex.sprint("\\draw (", x1, ",", y1, ") rectangle (", x2, ",", y2,  ");")
    end
end

function classe()
    for y = 1,6
    do
        x1, y1, x2, y2 = 1.3, -0.3*y+0.1, 1.5, -0.3*y-0.1
        tex.print("\\draw ("..x1..","..y1..") rectangle ("..x2..","..y2.. ");")
    end
end

function numeroEleve()
    for y = 0,9
    do
        x1, y1, x2, y2 = 2.3, -0.3*(y+1)+0.1, 2.5, -0.3*(y+1)-0.1
        tex.print("\\draw ("..x1..","..y1..") rectangle ("..x2..","..y2.. ");")
        x1, x2 = 3.1, 3.3
        tex.print("\\draw ("..x1..","..y1..") rectangle ("..x2..","..y2.. ");")
        tex.sprint("\\node[anchor=east] at (", 2.3, ",", -0.3*(y+1), ") {\\tiny{", y, "}};")
        tex.sprint("\\node[anchor=east] at (", 3.1, ",", -0.3*(y+1), ") {\\tiny{", y, "}};")
    end
end

--        \foreach \x/\rep in {0/~,1/A,2/B,3/C,4/D} {
--            \node[anchor=east] at (5,{((\x+2)*(-0.3)+0.15}) {\tiny{\rep}};
--            \draw (5,{((\x+2)*(-0.3)}) -- ({5+0.3*\theVMQCMNumeroQuestion},{((\x+2)*(-0.3)});
--        }
--        \foreach \y/\numq in {0/~,1/1,...,\theVMQCMNumeroQuestion/\theVMQCMNumeroQuestion} {
--            \node[anchor=south] at ({5+0.3*\y-0.15},-0.6) {\tiny{\numq}};
--            \draw ({5+0.3*\y},-0.6) -- ({5+0.3*\y},-1.8);
--        }

function grille_reponses(n)
    for x = 0,4
    do
        x1, x2, y1, y2 = 5, 5+0.3*n, -0.3*(x+2)+0.15, -0.3*(x+2)
        if x ~= 0 then
            tex.sprint("\\node[anchor=east] at (", 5, ",", y1, ") {\\tiny{", string.char(65-1+x), "}};") -- 65 : A
        end
        tex.sprint("\\draw (", x1, ",", y2, ") -- (", x2, ",", y2, ");")
    end
    for y = 0,n
    do
        x1, x2, y1, y2 = 5+0.3*y-0.15, 5+0.3*y, -0.6, -1.8
        if y ~= 0 then
            tex.sprint("\\node[anchor=south] at (", x1, ",", y1, ") {\\tiny{", y, "}};")
        end
        tex.sprint("\\draw (", x2, ",", y1, ") -- (", x2, ",", y2, ");")
    end
end