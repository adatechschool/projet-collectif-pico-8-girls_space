pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--jeu d'aventure

function _init()
	create_player()
	init_msg()
	init_camera()
end

function _update()
	if not messages[1] then
	player_move()
	end
	update_camera()
	update_msg()
end

function _draw()
	cls()
	draw_map()
	draw_player()
	draw_ui()
	draw_msg()
end
-->8
--map

function draw_map()
	map(0,0,0,0,128,64)
end

function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end

function old_camera()
	camx=mid(0,p.x-7.5,125-15)
	camy=mid(0,p.y-7.5,64-15)
	camera(camx*8,camy*8)
end

function init_camera()
	camx,camy=0,0
end

function update_camera()
	sectionx=flr(p.x/16)*16
	sectiony=flr(p.y/16)*16
	
	destx=sectionx*8
	desty=sectiony*8
	
	diffx=destx-camx
	diffy=desty-camy
	
	diffx/=4
	diffy/=4
	
	camx+=diffx
	camy+=diffy
	
	camera(camx,camy)
end

function next_tile(x,y)
	sprite=mget(x,y)
	mset(x,y,sprite+1)
end

function pick_up_key(x,y)
	next_tile(x,y)
	p.keys+=1
	sfx(0)
end

function open_door(x,y)
	next_tile(x,y)
	p.keys-=1
	sfx(1)	
end
-->8
--player
function create_player()
	p={x=6,y=4,
			ox=0,oy=0,
			start_ox=0,start_oy=0,
			anim_t=0,
				sprite=24,
				keys=0
				}
end

--mouvement du personnage 
function player_move()
	newx=p.x
	newy=p.y
	
	if p.anim_t==0 then
		newox,newoy=0,0
			if btn(➡️) then
			 newx+=1
			 newox=-8
			 p.flip=false
			elseif btn(⬅️) then
			 newx-=1
			 newox=8
			 p.flip=true
			elseif btn(⬇️) then
			 newy+=1
			 newoy=-8
			elseif btn(⬆️) then
			 newy-=1
			 newoy=8	
	end
end
	
	

	interact(newx,newy)
	
	if not check_flag(0,newx,newy)
	and (p.x!=newx or p.y!=newy) then
	 p.x=mid(0,newx,127)
	 p.y=mid(0,newy,63)
	 p.start_ox=newox
	 p.start_oy=newoy
	 p.anim_t=1	 	
	end


--animation
p.anim_t=max(p.anim_t-0.125,0)
p.ox=p.start_ox*p.anim_t
p.oy=p.start_oy*p.anim_t

	if p.anim_t>=0.5 then
		p.sprite=25
	else
		p.sprite=24
	end	
end

function interact(x,y)
	if check_flag(1,x,y) then
	pick_up_key(x,y)
	elseif check_flag(2,x,y)
	and p.keys>0 then
	open_door(x,y)
	end
	if x==8 and y==3 then
			create_msg("panneau",
			"je suis le panneau\nd'introduction!")
	end
	if x==3 and y==13 then
			create_msg("erika","bonjour")
	end
	if	y==18 and x>=2 and x<=7
	and not visited_dungeon then
		create_msg("maitre du donjon",
	"tu n'aurais jamais du mettre\nles pieds ici!")
	visited_dungeon=true
	
	end
end

function draw_player()
	spr(p.sprite,
	p.x*8+p.ox,p.y*8+p.oy,
	1,1,p.flip)

	
end
-->8
--user_interface

function draw_ui()
	camera(0,0)
	palt(0,false)
	palt(12,true)
	spr(11,2,2)
	palt()
	print_outline("X"..p.keys,10,2,7)
end

function print_outline(text,x,y)
	print(text,x-1,y,0)
	print(text,x+1,y,0)
	print(text,x,y-1,0)
	print(text,x,y+1,0)
	print(text,x,y,7)
end
-->8
--messages

function init_msg()
	messages={}
end

function create_msg(name,...)
	msg_title=name
	messages={...}
end

function update_msg()
	if (btn(❎)) then
		deli(messages,1)
	end
end

function draw_msg()
	if messages[1] then
		local y=100
		if p.y%16>9 then
		 y=10
		end
		rectfill(2,y,
		6+#msg_title*4,y+6,2)
		print(msg_title,7,y+1,7)
		rectfill(2,y+7,125,y+21,2)
		rectfill(3,y+7,126,y+23,4)
		print(messages[1],3,y+10,7)
	end
end
__gfx__
00000000333333333333333333bbbb331111111144444444111111113333333300000000dddddddd111111d1cc0ccccc00000000000000000000000000000000
000000003333333333a333333bbaabb31111111144444444111111113333373300000000dddddddd1d111111c0a0000c00000000000000000000000000000000
00700700333333333a9a33333bbbab1311111111cccccccc1111111133337a7300000000dddddddd1111d1110a0aaaa000000000000000000000000000000000
000770003333333333a333333bbbb3131111111111111111111111113333373300000000ddddddddd1111111c0a000a000000000000000000000000000000000
000770003333333333333a33313b33131111111111111111111111113373333300000000dddddddd111d111dcc0ccc0c00000000000000000000000000000000
00700700333333333333a9a3331111331111111111111111cccccccc37a7333300000000dddddddd11111111cccccccc00000000000000000000000000000000
000000003333333333333a33333443331111111111111111444444443373333300000000dddddddd1d1111d1cccccccc00000000000000000000000000000000
000000003333333333333333331994331111111111111111444444443333333300000000dddddddd111d1111cccccccc00000000000000000000000000000000
00000000333333334ffffff444444444dddddddddddddddd33333333344444330eeeee000eeeee00000000000000000000000000000000000000000000000000
0000000033333333444444444f4f4f4fdddddddddddddddd3999999344ffff43eeeefe00eeeefe00000000000000000000000000000000000000000000000000
00000000333333334ffffff44fff4f4fdddddadddddddddd3444444344f1f143ef1ff1e0ef1ff1e0000000000000000000000000000000000000000000000000
00000000333333b34f444f444f4f4f4fdaaaadaddddddddd3422424344ffff43eeffffe0eeffffe0000000000000000000000000000000000000000000000000
0000000033333b334ffffff44f4fff4f4a444a44444444443444444333cccc33ee8888e0ee8888e0000000000000000000000000000000000000000000000000
000000003bb33b334444f4444f4f4f4f444444444444444433233233335575330866660008666600000000000000000000000000000000000000000000000000
0000000033bb33334ffffff44f4fff4fd222222dd222222d334334333cccccc308aaaa0080aaaa00000000000000000000000000000000000000000000000000
00000000333b33334444444444444444dddddddddddddddd33333333336336330860060080065000000000000000000000000000000000000000000000000000
00000000000000000000000000000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000033333a333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003aaaa3a33333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000003a333a333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000144444411442000100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000440505044432000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000940505049332000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000944444449342000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000444444144442000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000944444749442000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000942444449420000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000422424244200000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
00001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
00001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
00001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
__gff__
0000000101010100000001000000000000000000020101010000000000000000000000000200000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
03030303030303030303030303030303030505050501010101010101010101010a0a0a0a040a0a0a01010104040401010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
03030303010101010101010107010101050404040405050505050501010101010a0909091409090a01010104040401010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
03030101010101070101010101050505040404060606060606040401010101010a0909090909090a01010104040401010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
03030101020101011601010105040404040406010301010101040401010101010a0909090909090a01010101040401010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
03030101010101010101010104040404040601010301010101040401010101010a0a0a09090a0a0a01010101040401010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0303010701010201050505050404040606010101010301010104040101010101010101010101010101010101040401010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0301010105120505040404040406060101010101010101010113130101010101010101010101010101010101040401010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0301020504120404040404060602010101010101010301010101040404040101010101010101010101010104040101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0301010404120406060606010101010701010101010101010101040404040404040101010101010101010104040101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0305050406120601010101010101010101010101010101010101010101010101040404040401010101010404010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0504060301010102010101110101110101010101010101010101010101010101010104040404040404040404010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0606030301010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0303030101020101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0303011701010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0303010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
030a0a0a340a0a0a0a010a0a0a0a0a0a0a010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
030a0a0a090a0a0a0a010a0a0a0a0a0a0a010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
030a0909090909090a240a090909090a0a010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
030a0909090909090a010a090909140a0a010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
030a0909090909090a0a0a0a090a0a0a01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
030a09090909090a0a0a09090909093401010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
030a090909090909090909090909090a01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
030a09090909090a0a0a0a0909090a0a01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
030a0a0a0a0a0a0a0a0a0a0a0a0a010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0301010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0301010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0301010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0301010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0301010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
__sfx__
000500002305023050230500000030050320503305000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000176602b65000600074000b3000d6001c3000d3001360013400186000f30018400236001b4002260015300246002930028600366001b300294002b6003340033600213003a40029600366002730037600
