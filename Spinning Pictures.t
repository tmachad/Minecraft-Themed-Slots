View.Set ("graphics:max;max,offscreenonly")

type nextPic :
    record
	x : int
	y : int
	pic : int
    end record

type currentPic :
    record
	x : int
	y : int
	pic : int
    end record

var nxtPic : array 1 .. 3 of nextPic
var crntPic : array 1 .. 3 of currentPic
var Pics : array 1 .. 5 of int
Pics (5) := Pic.FileNew ("diamond.jpg")
Pics (4) := Pic.FileNew ("iron.jpg")
Pics (3) := Pic.FileNew ("porkchop.jpg")
Pics (2) := Pic.FileNew ("coal.jpg")
Pics (1) := Pic.FileNew ("creeper.jpg")

for i : 1 .. 5
    Pics (i) := Pic.Scale (Pics (i), 100, 100)
end for

for i : 1 .. 3
    crntPic (i).x := maxx div 2
    crntPic (i).y := maxy div 2
    nxtPic (i).x := maxx div 2
    nxtPic (i).y := maxy div 2 + 100

    nxtPic (i).pic := Pics (Rand.Int (1, 5))
    crntPic (i).pic := Pics (Rand.Int (1, 5))
    Pic.Draw (crntPic (i).pic, crntPic (i).x, crntPic (i).y, picCopy)
end for

const speed : int := 10
var stopWheel : boolean := false
loop
    cls
    for i : 1 .. 3
	if stopWheel not= true then
	    crntPic (i).y := crntPic (i).y - speed
	    nxtPic (i).y := nxtPic (i).y - speed
	    if nxtPic (i).y <= maxy div 2 then
		crntPic (i).pic := nxtPic (i).pic
		crntPic (i).y := maxy div 2
		nxtPic (i).y := maxy div 2 + 100
		nxtPic (i).pic := Pics (Rand.Int (1, 5))
	    end if
	end if
	Pic.Draw (nxtPic (i).pic, nxtPic (i).x + 100 * i - 100, nxtPic (i).y, picCopy)
	Pic.Draw (crntPic (i).pic, crntPic (i).x + 100 * i - 100, crntPic (i).y, picCopy)
	Draw.FillBox (0, 0, maxx, maxy div 2 - 1, white)
	Draw.FillBox (0, maxy, maxx, maxy div 2 + 101, white)
	Draw.Box (maxx div 2 + 100 * i - 100, maxy div 2, maxx div 2 + 100 + 100 * i - 100, maxy div 2 + 100, black)
    end for
    View.Update
    delay (10)
end loop
