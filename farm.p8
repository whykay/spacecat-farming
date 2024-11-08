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
	else
		
	end --endif
	
	
	--plant seeds
	local ptx = (plr.x+4)/8
	local pty	= (plr.y+8)/8
	
	if btnp(❎) then
	
		if fget(mget(ptx, pty), 1) then 
			--plant seeds on blank tiles
			if seeds > 0 then
				seeds -= 1
				mset(ptx, pty, 3)
				add(patches, {
						sx = flr(ptx),
						sy = flr(pty),
						watered = false,
						tig = 0 --time in ground
				})
				
			end
		elseif mget(ptx, pty) ==  3 then
			--water seeds
			mset(ptx, pty, 5)
			for p in all(patches) do
				if p.sx == flr(ptx) and p.sy == flr(pty) then
					p.watered = true
				end --endif
			end --endfor
		elseif fget(mget(ptx, pty), 2) then
			--collect a carrot
			mset(ptx, pty, 0)
			harvest()
			for p in all(patches) do
				if p.sx == flr(ptx) and p.sy == flr(pty) then
					del(patches, p)
				end --end-if
			end --end-for
		end --end-if
	end --end-btnp
end

function dplr()
	spr(plr.sp, plr.x, plr.y)
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
	inv = {}
	seeds = 9
	carrots = 0
end

function uinv()
	
end

function dinv()
	--seeds inventory
	spr(19, 84, 2)
	print(seeds, 94, 3, 1)
	
	--carrots
	spr(18, 104, 2)
	print(carrots, 114, 3, 1)
end

function harvest()
	carrots += 1
	seeds += flr(rnd(4))
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
00000000000000000101000000111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001b1b100001656510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000001bb100001ffaaa1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001bb9910001faaba1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000114991001aa9aa1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000014991017977f1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000119101777ff1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000001000111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000154646464646465100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000146464646464646100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000144444444444444100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000155555555555555100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000141000000000014100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000141000000000012100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000121000000000012100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000121111111111114100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001417ff7ff7ff714100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000141f77f77f77f14100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000141111111111114100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000144424244442424100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000142424442444424100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000155555555555555100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0202000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0021220100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0031320000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000010000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000001000000010000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
