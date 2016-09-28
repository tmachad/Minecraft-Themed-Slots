View.Set ("graphics:max;max,offscreenonly")
const height : int := maxy div 3 * 2
const width : int := height div 2 * 3
const gap : int := height div 15
const window_width : int := (width - gap * 4) div 3
const window_height : int := (height - gap * 2) div 2
const x : int := maxx div 2 - width div 2
const y : int := 0

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
Pics (5) := Pic.FileNew ("diamond.gif")
Pics (4) := Pic.FileNew ("iron.gif")
Pics (3) := Pic.FileNew ("porkchop.gif")
Pics (2) := Pic.FileNew ("coal.gif")
Pics (1) := Pic.FileNew ("creeper.gif")
var explosion : array 1 .. 16 of int
for i : 1 .. 16
    explosion (i) := Pic.FileNew ("explosion_" + intstr (i) + ".gif")
    explosion (i) := Pic.Scale (explosion (i), width div 3, width div 3)
end for
var winscreen := Pic.FileNew ("winscreen.gif")
winscreen := Pic.Scale (winscreen, maxx, maxy)
var background := Pic.FileNew ("background.gif")
background := Pic.Scale (background, maxx, maxy)
var lever : array 1 .. 2 of int
lever (1) := Pic.FileNew ("leverup.gif")
lever (2) := Pic.FileNew ("leverdown.gif")
var lightSign : array 1 .. 2 of int
lightSign (1) := Pic.FileNew ("sign_1.gif")
lightSign (2) := Pic.FileNew ("sign_2.gif")
var betAll : array 1 .. 2 of int
betAll (1) := Pic.FileNew ("allcoins.gif")
betAll (2) := Pic.FileNew ("allcoinsdown.gif")
var addBet : array 1 .. 2 of int
addBet (1) := Pic.FileNew ("addcoins.gif")
addBet (2) := Pic.FileNew ("addcoinsdown.gif")
var reduceBet : array 1 .. 2 of int
reduceBet (1) := Pic.FileNew ("subtractcoins.gif")
reduceBet (2) := Pic.FileNew ("subtractcoinsdown.gif")
var machineFace, slotBacking : int
machineFace := Pic.FileNew ("machineface.gif")
machineFace := Pic.Scale (machineFace, width, height)
slotBacking := Pic.FileNew ("slotbacking.jpg")
slotBacking := Pic.Scale (slotBacking, window_width, window_height)
var coin : array 1 .. 3 of int
coin (1) := Pic.FileNew ("silvercoin.gif")
coin (2) := Pic.FileNew ("goldcoin.gif")
coin (3) := Pic.FileNew ("diamondcoin.gif")

for i : 1 .. 5
    Pics (i) := Pic.Scale (Pics (i), window_width, window_height)
    if i <= 2 then
	addBet (i) := Pic.Scale (addBet (i), gap, gap)
	reduceBet (i) := Pic.Scale (reduceBet (i), gap, gap)
	betAll (i) := Pic.Scale (betAll (i), gap * 3, gap)
	lightSign (i) := Pic.Scale (lightSign (i), width, maxy div 3)
	lever (i) := Pic.Scale (lever (i), width div 5, height div 3 * 2)
    end if
    if i <= 3 then
	coin (i) := Pic.Scale (coin (i), gap * 4, gap * 3)
    end if
end for

for i : 1 .. 3
    crntPic (i).x := x + gap
    crntPic (i).y := y + height div 2
    nxtPic (i).x := x + gap
    nxtPic (i).y := y + height div 2 + window_height

    nxtPic (i).pic := Pics (Rand.Int (1, 5))
    crntPic (i).pic := Pics (Rand.Int (1, 5))
    Pic.Draw (crntPic (i).pic, crntPic (i).x, crntPic (i).y, picCopy)
end for

var stopWheel : array 1 .. 3 of int
for i : 1 .. 3
    stopWheel (i) := 0
end for

procedure wingame
    var font := Font.New ("sans serif:" + intstr (maxy div 22))
    cls
    Draw.FillBox (0, 0, maxx, maxy, brightgreen)
    Pic.Draw (winscreen, 0, 0, picMerge)
    Font.Draw ("You Win!", maxx div 5 * 2, maxy div 5 * 2, font, white)
    View.Update
end wingame

procedure losegame
    var font := Font.New ("sans serif:" + intstr (maxy div 22))
    Music.PlayFile ("creeperhit.WAV")
    Music.PlayFile ("fuse.WAV")
    Music.PlayFileReturn ("explode.WAV")
    for i : 1 .. 20
	cls
	Pic.Draw (background, 0, 0, picCopy)
	for j : 1 .. 3
	    Pic.Draw (slotBacking, x + gap * j + window_width * j - window_width, y + height div 2, picCopy)
	    Pic.Draw (crntPic (j).pic, crntPic (j).x + gap * j - gap + window_width * j - window_width, crntPic (j).y, picMerge)
	end for
	Pic.Draw (lightSign (1), x, y + height, picMerge)
	Pic.Draw (machineFace, x, y, picMerge)
	Pic.Draw (lever (1), x + width, y + height div 2, picMerge)
	Pic.Draw (addBet (1), x - gap * 2, y + gap div 2 + gap, picCopy)
	Pic.Draw (reduceBet (1), x - gap * 4, y + gap div 2 + gap, picCopy)
	Pic.Draw (betAll (1), x - gap * 4, y, picCopy)
	if i <= 16 then
	    Pic.Draw (explosion (i), maxx div 2 - width div 6, maxy div 2 - width div 6, picMerge)
	end if
	if i > 1 and i <= 17 then
	    Pic.Draw (explosion (i - 1), x - gap * 4, y, picMerge)
	end if
	if i > 2 and i <= 18 then
	    Pic.Draw (explosion (i - 2), x + width div 3 * 2, y + height, picMerge)
	end if
	if i > 3 and i <= 19 then
	    Pic.Draw (explosion (i - 3), x + width div 20 * 18, y, picMerge)
	end if
	if i > 4 and i <= 20 then
	    Pic.Draw (explosion (i - 4), x - gap * 2, y + height div 5 * 4, picMerge)
	end if
	View.Update
    end for
    Draw.FillBox (0, 0, maxx, maxy, brightred)
    Font.Draw ("Game Over", maxx div 5 * 2, maxy div 2, font, white)
    View.Update
end losegame

function rewards (slot1 : int, slot2 : int, slot3 : int, bet : int, coins : int) : int
    if slot1 = slot2 and slot1 = slot3 then
	case slot1 of
	    label 1 :
		result 0
	    label 2 :
		result coins + bet * 4
	    label 3 :
		result coins + bet * 6
	    label 4 :
		result coins + bet * 8
	    label 5 :
		if bet > 200 then
		    result 100000
		else
		    result coins + bet ** 3
		end if
	    label :

	end case
    elsif slot1 = slot2 or slot1 = slot3 then
	case slot1 of
	    label 1 :
		result floor (coins / 2)
	    label 2 :
		result coins + bet * 2
	    label 3 :
		result coins + bet * 3
	    label 4 :
		result coins + bet * 4
	    label 5 :
		if bet > 46340 then
		    result 100000
		else
		    result coins + bet ** 2
		end if
	    label :

	end case
    elsif slot2 = slot3 then
	case slot2 of
	    label 1 :
		result floor (coins / 2)
	    label 2 :
		result coins + bet * 2
	    label 3 :
		result coins + bet * 3
	    label 4 :
		result coins + bet * 4
	    label 5 :
		if bet > 46340 then
		    result 100000
		else
		    result coins + bet ** 2
		end if
	    label :

	end case
    else
	result coins
    end if
end rewards

function getSpin (pic : int) : int
    var slot : int
    for i : 1 .. 5
	if pic = Pics (i) then
	    slot := i
	    result slot
	end if
    end for
end getSpin

var spinDelay : int := 1500
var slot1, slot2, slot3 : int
procedure spinWheels (speed : int)
    for i : 1 .. 3
	if stopWheel (1) not= i and stopWheel (2) not= i and stopWheel (3) not= i then
	    crntPic (i).y := crntPic (i).y - speed
	    nxtPic (i).y := nxtPic (i).y - speed
	    if nxtPic (i).y <= y + height div 2 then
		crntPic (i).pic := nxtPic (i).pic
		crntPic (i).y := y + height div 2
		nxtPic (i).y := y + height div 2 + window_height
		nxtPic (i).pic := Pics (Rand.Int (1, 5))
		if spinDelay <= 1000 then
		    slot1 := getSpin (crntPic (1).pic)
		    stopWheel (1) := 1
		end if
		if spinDelay <= 500 then
		    slot2 := getSpin (crntPic (2).pic)
		    stopWheel (2) := 2
		end if
		if spinDelay <= 0 then
		    slot3 := getSpin (crntPic (3).pic)
		    stopWheel (3) := 3
		end if
	    end if
	end if
    end for
    spinDelay := spinDelay - 10
end spinWheels

var alternate : int := 0
procedure drawSlots (coins, bet : int, startWheels : boolean)
    var coinFont := Font.New ("sans serif:" + intstr (maxy div 45))
    var coinValue : array 1 .. 3 of int
    coinValue (1) := 10
    coinValue (2) := 250
    coinValue (3) := 5000
    alternate := alternate + 1
    if alternate > 2 then
	alternate := 1
    end if

    Pic.Draw (background, 0, 0, picCopy)
    for i : 1 .. 3
	Pic.Draw (slotBacking, x + gap * i + window_width * i - window_width, y + height div 2, picCopy)
	Pic.Draw (nxtPic (i).pic, nxtPic (i).x + gap * i - gap + window_width * i - window_width, nxtPic (i).y, picMerge)
	Pic.Draw (crntPic (i).pic, crntPic (i).x + gap * i - gap + window_width * i - window_width, crntPic (i).y, picMerge)
    end for
    Pic.Draw (background, 0, maxy div 3 * 2, picCopy)
    if startWheels = false then
	if coins < coinValue (2) then
	    for i : 1 .. coins by coinValue (1)
		Pic.Draw (coin (1), x - gap * 4 - gap div 2, y + gap * 2 + (gap div 4 * 3) * (i div coinValue (1)), picMerge)
	    end for
	elsif coins >= coinValue (2) and coins < coinValue (3) then
	    for i : 1 .. coins by coinValue (2)
		Pic.Draw (coin (2), x - gap * 4 - gap div 2, y + gap * 2 + (gap div 4 * 3) * (i div coinValue (2)), picMerge)
	    end for
	elsif coins >= coinValue (3) then
	    for i : 1 .. coins by coinValue (3)
		Pic.Draw (coin (3), x - gap * 4 - gap div 2, y + gap * 2 + (gap div 4 * 3) * (i div coinValue (3)), picMerge)
	    end for
	end if
	if coins < 10 then
	    Font.Draw (intstr (coins), x - gap * 3 + gap div 3, y + gap * 2 + (gap div 4 * 3), coinFont, yellow)
	elsif coins < 100 and coins >= 10 then
	    Font.Draw (intstr (coins), x - gap * 3, y + gap * 2 + (gap div 4 * 3), coinFont, yellow)
	elsif coins >= 100 and coins < 1000 then
	    Font.Draw (intstr (coins), x - gap * 3 - gap div 6, y + gap * 2 + (gap div 4 * 3), coinFont, yellow)
	elsif coins >= 1000 and coins < 10000 then
	    Font.Draw (intstr (coins), x - gap * 3 - gap div 3, y + gap * 2 + (gap div 4 * 3), coinFont, yellow)
	elsif coins >= 10000 and coins < 100000 then
	    Font.Draw (intstr (coins), x - gap * 3 - gap div 2, y + gap * 2 + (gap div 4 * 3), coinFont, yellow)
	end if
	if bet < 10 then
	    Font.Draw (intstr (bet), x - gap * 3 + gap div 3, y + gap * 2 + (gap div 4 * 3) * 2, coinFont, brightred)
	elsif bet < 100 and bet >= 10 then
	    Font.Draw (intstr (bet), x - gap * 3, y + gap * 2 + (gap div 4 * 3) * 2, coinFont, brightred)
	elsif bet >= 100 and bet < 1000 then
	    Font.Draw (intstr (bet), x - gap * 3 - gap div 6, y + gap * 2 + (gap div 4 * 3) * 2, coinFont, brightred)
	elsif bet >= 1000 and bet < 10000 then
	    Font.Draw (intstr (bet), x - gap * 3 - gap div 3, y + gap * 2 + (gap div 4 * 3) * 2, coinFont, brightred)
	elsif bet >= 10000 and bet < 100000 then
	    Font.Draw (intstr (bet), x - gap * 3 - gap div 2, y + gap * 2 + (gap div 4 * 3) * 2, coinFont, brightred)
	end if
    end if
    %Draw.FillBox (x, maxy, x + width, y + height div 2 + window_height + 1, white)
    Pic.Draw (machineFace, x, y, picMerge)
    Pic.Draw (lightSign (alternate), x, y + height, picMerge)
    Pic.Draw (addBet (1), x - gap * 2, y + gap div 2 + gap, picCopy)
    Pic.Draw (reduceBet (1), x - gap * 4, y + gap div 2 + gap, picCopy)
    Pic.Draw (betAll (1), x - gap * 4, y, picCopy)
end drawSlots

Mouse.ButtonChoose ("multibutton")
var startWheels : boolean := false
var mx, my, mbtn, bet, betDelay, coins : int
betDelay := 50
bet := 0
coins := 25

procedure buttons
    Mouse.Where (mx, my, mbtn)
    if betDelay <= 0 then
	if mx > x - gap * 2 and mx < x - gap and my > y + gap div 2 + gap and my < y + gap div 2 + gap * 2 and mbtn = 1 and bet < coins then
	    Pic.Draw (addBet (2), x - gap * 2, y + gap div 2 + gap, picCopy)
	    bet := bet + 1
	    betDelay := 50
	elsif mx > x - gap * 2 and mx < x - gap and my > y + gap div 2 + gap and my < y + gap div 2 + gap * 2 and mbtn = 10 and bet <= coins - 10 then
	    Pic.Draw (addBet (2), x - gap * 2, y + gap div 2 + gap, picCopy)
	    bet := bet + 10
	    betDelay := 50
	elsif mx > x - gap * 2 and mx < x - gap and my > y + gap div 2 + gap and my < y + gap div 2 + gap * 2 and mbtn = 100 and bet <= coins - 100 then
	    Pic.Draw (addBet (2), x - gap * 2, y + gap div 2 + gap, picCopy)
	    bet := bet + 100
	    betDelay := 50
	elsif mx > x - gap * 4 and mx < x - gap * 3 and my > y + gap div 2 + gap and my < y + gap div 2 + gap * 2 and mbtn = 1 and bet > 0 then
	    Pic.Draw (reduceBet (2), x - gap * 4, y + gap div 2 + gap, picCopy)
	    bet := bet - 1
	    betDelay := 50
	elsif mx > x - gap * 4 and mx < x - gap * 3 and my > y + gap div 2 + gap and my < y + gap div 2 + gap * 2 and mbtn = 10 and bet >= 10 then
	    Pic.Draw (reduceBet (2), x - gap * 4, y + gap div 2 + gap, picCopy)
	    bet := bet - 10
	    betDelay := 50
	elsif mx > x - gap * 4 and mx < x - gap * 3 and my > y + gap div 2 + gap and my < y + gap div 2 + gap * 2 and mbtn = 100 and bet >= 100 then
	    Pic.Draw (reduceBet (2), x - gap * 4, y + gap div 2 + gap, picCopy)
	    bet := bet - 100
	    betDelay := 50
	elsif mx > x - gap * 4 and mx < x - gap and my > y and my < y + gap and mbtn = 1 and bet not= coins then
	    Pic.Draw (betAll (2), x - gap * 4, y, picCopy)
	    bet := coins
	    betDelay := 50
	elsif mx > x - gap * 4 and mx < x - gap and my > y and my < y + gap and mbtn = 100 and bet <= coins div 2 then
	    Pic.Draw (betAll (2), x - gap * 4, y, picCopy)
	    bet := bet + coins div 2
	    betDelay := 50
	end if
    else
	betDelay := betDelay - 10
    end if
    if mx > x + width + gap and mx < x + width + gap * 4 and my > y + height div 2 and my < y + height + height div 4 and mbtn = 1 and bet > 0 then
	Pic.Draw (lever (2), x + width, y, picMerge)
	startWheels := true
	coins := coins - bet
    else
	Pic.Draw (lever (1), x + width, y + height div 2, picMerge)
    end if
end buttons

%=====================================main loop=======================================%
loop
    cls
    if stopWheel (3) = 3 then
	coins := rewards (slot1, slot2, slot3, bet, coins)
	startWheels := false
	if coins = 0 then
	    losegame
	    exit
	end if
	if coins >= 100000 then
	    wingame
	    exit
	end if
	for i : 1 .. 3
	    stopWheel (i) := 0
	end for
	spinDelay := 1500
	bet := 0
    end if
    if startWheels then
	spinWheels (100)
    end if
    drawSlots (coins, bet, startWheels)
    if startWheels = false then
	buttons
    end if
    if startWheels then
	for i : 1 .. 3
	    View.UpdateArea (x + gap * i + window_width * i - window_width, y + height div 2, x + gap * i + window_width * i, y + height - gap)
	end for
	View.UpdateArea (x, y + height, x + width, maxy)
    else
	View.Update
    end if
    delay (10)
end loop
