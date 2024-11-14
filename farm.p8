pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
--super simple farming game--

-- goals

function _init()
	iplr()
	icrops()
	iinv()
end

function _update()
	uplr()
	ucrops()
	uinv()
end

function _draw()
	cls(11)
	map()
	
	dplr()
	dcrops()
	dinv()
end

-->8
--player--

function iplr()
	plr = {
		x = 63,
		y = 63,
		sp = 12
	}
end

function uplr()

	--save player locn
	local lx = plr.x
	local ly = plr.y
	
	--movement
	if btn(➡️) then
		plr.x += 1
		plr.sp = 14
	elseif btn(⬅️) then
		plr.x -= 1
		plr.sp = 13
	elseif btn(⬆️) then
		plr.y -= 1
		plr.sp = 15
	elseif btn(⬇️) then
		plr.y += 1
		plr.sp = 12
	end --endif
	
	--chk if player collides
	if collide() then
		plr.x = lx
		plr.y = ly
	end
	
	--plant seeds
	local ptx = (plr.x+4)/8
	local pty	= (plr.y+8)/8
	
	if btnp(❎) then
	
		if fget(mget(ptx, pty), 6) then 
			--plant seeds on blank tiles
			--if seeds > 0 then
			if inv[sel].name == "seeds" then
				if inv[sel].amt > 0 then
					--seeds -= 1
					inv[sel].amt -= 1
					
					mset(ptx, pty, 3)
					add(patches, {
							sx = flr(ptx),
							sy = flr(pty),
							watered = false,
							tig = 0 --time in ground
					})
				end
			end
		elseif mget(ptx, pty) ==  3 then
			--water seeds
			mset(ptx, pty, 5)
			for p in all(patches) do
				if p.sx == flr(ptx) and p.sy == flr(pty) then
					p.watered = true
				end --endif
			end --endfor
		elseif fget(mget(ptx, pty), 1) then
			--collect a carrot
			mset(ptx, pty, 0)
			harvest()
			for p in all(patches) do
				if p.sx == flr(ptx) and p.sy == flr(pty) then
					del(patches, p)
				end --end-if
			end --end-for
		elseif fget(mget(ptx, pty), 2) then
		--spend gold
			if coins > 0 then
				seeds += 1
				coins -= 1
			end --endif-coins
		end --endif-fget
	end --end-btnp
	
--	--sell carrots
--	if btnp(🅾️) then
--		if carrots > 0 then
--			carrots -= 1
--			coins += 2
--		end
--	end
end

function dplr()
	spr(plr.sp, plr.x, plr.y)
end 


--check collision - flag 0
function collide()
	local ptx1 = (plr.x+3)/8
	local ptx2 = (plr.x+4)/8
	local pty	= (plr.y+7)/8 
	
	if fget(mget(ptx1, pty), 0) or fget(mget(ptx2, pty), 0) then 
		return true
	else
		return false
	end 
end
-->8
--nature's way--

function icrops()
	patches = {}
end

function ucrops()	
	for p in all(patches) do
		if p.watered then
			p.tig += 1
		end
		if p.tig > 300 then
			mset(p.sx, p.sy, 4) --grow carrot
		end
	end
	
end

function dcrops()

end

function growcrops()
	--loop through all tiles on map
	--change tiles 3 -> 4 
	for x=0,15 do
		for y =0, 15 do
			if mget(x, y) == 3 then
				mset(x, y, 4) --grow carrot
			end
		end
	end
end
-->8
--inventory--

function iinv()
	sel = 1
	inv = {}
	add(inv, {
		name = "gold",
		amt = 10,
		sp = 17
	})
	
	add(inv, {
		name = "carrots",
		amt = 0,
		sp = 18
	})
	
	add(inv, {
		name = "seeds",
		amt = 4,
		sp = 19
	})
	
end

function uinv()
	--move selection box
	if btnp(🅾️) then
		if sel < #inv then
			sel += 1
		else
			sel = 1
		end
	end --end-btnp
end

function dinv()
	rectfill(30, 116, 99, 125, 4)
	
	--go thro inventory
	for i=1, #inv do
		spr(inv[i].sp, 22+9*i, 117)
	end
	
	rect(21+sel*9, 116, 30+sel*9, 125, 7)

	print(inv[sel].name, 63, 73, 7)
	print(inv[sel].amt, 63, 83, 7)
end

function harvest()
	--carrots += 1
	--seeds += flr(rnd(4))
	for i in all(inv) do
		if i.name == "carrots" then
			i.amt += 1
		end
	end
end
__gfx__
000000000000000004444440044444400444444004444440000000000000000000000000000000000000000000000000000d600000066000000660000006d000
00000000000000004424444444244444444b4b44442ddd4400000000000000000000000000000000000000000000000000cd6c0000c6600000066c0000c6dc00
0070070000000030444442444444a2444444b4444ddda2d40000000000000000000000000000000000000000000000000007700000076000000670000006d000
00077000000003004442444444a24444444999444da2ddd40000000000000000000000000000000000000000000000000ddd66d0006d60000006d6000d66ddd0
00077000030003004444444444444444442999244dddddd4000000000000000000000000000000000000000000000000d0dcc60d00cdc000000cdc00d06eed0d
0070070000300000424442444424a244444222444d2da2d4000000000000000000000000000000000000000000000000d0dd660d006d60000006d600d066dd0d
000000000030000044444444444444444444444444dddd44000000000000000000000000000000000000000000000000009d6a000096a000000a690000a6d900
0000000000000000044444400444444004444440044444400000000000000000000000000000000000000000000000000009a000000a00000000a000000a9000
00000000000111000101000000111000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111110
000000000019aa101b1b1000016565100000000000000000000000000000000000000000000000000000000000000000000ff000005d55001546464646464651
00000000019aaaa101bb100001ffaaa1000000000000000000000000000000000000000000000000000000000000000000ffff00056555501464646464646461
00000000019aa9a11bb9910001faaba10000000000000000000000000000000000000000000000000000000000000000004ff4000555d5601444444444444441
00000000019a9aa10114991001aa9aa1000000000000000000000000000000000000000000000000000000000000000000444400055655501555555555555551
00000000019aaaa100014991017977f100000000000000000000000000000000000000000000000000000000000000000004400005d55d501111111111111111
000000000019aa100000119101777ff1000000000000000000000000000000000000000000000000000000000000000000344300005565001410ee0000000141
00000000000111000000001000111110000000000000000000000000000000000000000000000000000000000000000000033000000000001411ff1000000121
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001211991000000121
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001219119111111141
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000141f1ff1c7cc7141
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001411c71c7c77c141
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001411111111111141
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001444242444424241
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001424244424464241
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001555555555555551
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065665656656600
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000065665556656600
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666666666666660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060660606606600
__gff__
4040000002000000000000000000000000000000000000000000000001000101000000000000000000000000000001010000000000000000000000000000040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1c1c1c1c00000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001e1f1c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002e2f1c00000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
013e3f0000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1d0001000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1c1c1c0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001c0000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00011c0000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001c0001000000010000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
