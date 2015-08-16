--[madlib]--
--requires everything in the lib folder, is required by main.moon
--WORKING
	--debug menu (could use expanding)
	--room system/persistence
	--entities
	--keyboard input
	--game controller input
	--zording
	--basic collision functions
	--really basic entity mapper
	--camera (gamera by kikito)
	--sound (TEsound)
	--animation (anim8)
--TODO
	--mouse input
	--update mad.draw to only check the ents table like the rest
	--work on the entity editor



-----RESERVED MADLIB VARIABLES------
--room
--ent_amt
--ents
--joy_table
--joystick
--path
--debug
--mad (and it's functions)
--entity
--settings
--keys
--col

----RESERVED MADLIB FUNCTIONS-----
--to be written


----------------------------------------------------
----PART 1: REQUIRING THE SHIT WE NEED----
----------------------------------------------------

require "lib.mad.require" --we need this for entity requiring
require "lib.mad.TEsound" --sound stuff (may remove this)
bump = require "lib.mad.bump" --collision!
gamera = require "lib.mad.gamera" --camera
anim8 = require "lib.mad.anim8" --animation/sprites
draggable = require "lib.mad.draggable" --window draggin'

math.randomseed(os.time()) --random random numbers :o

----------------------------------------------------
----PART 2: SETTING UP THE VARS WE NEED---
----------------------------------------------------

--current room!
export room = "" --IMPORTANT

--entity system
export ent_amt = 0 --how many ents are there?
export ents = {} --this is the thing that renders/updates every entity. it is my lifeblood.

--controller variables!
export joy_table = love.joystick.getJoysticks() --gets list of joysticks
export joystick = joy_table[1] --sets up a joystick 4 fun u know?



--resource paths. we use this to find stuff!
export path = {
	img: "game/res/img/"
	snd: "game/res/snd/"
	dat: "game/res/dat/"
	--add any other external resource paths here!
}

--debug stuff. idk if we even use certain things in here anymore?
export debug = {
	debugMode: true
	debugShow: true
	drawHbox: false
	ctrlMod: false
}

----------------------------------------------
----PART 3: THE ACTUAL FUNCTIONS-----
----------------------------------------------

export mad = {

	--------------------------------------------------
	-----PART 3.1: CORE LOVE2D FUNCTIONS-----
	--------------------------------------------------

	--this thing sets up a camera and positions it
	init: =>
		export camera = gamera.new(-5, -5, love.graphics.getWidth()+5, love.graphics.getHeight()+5) --setup camera with padding for screen shake
		camera\setPosition(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)			

	--this function updates all the entities in the ents table
	update: (dt) =>
		for k, v in pairs ents
			if v.update ~= nil then v\update(dt)

		if not debug.debugMode then
			debug.debugShow = false

		if @input\key("lctrl") then
			debug.ctrlMod = true
		else
			debug.ctrlMod = false

	--this draws the entities to a camera
	draw: (cam) =>
		table.sort(ents, @drawSort)

		for k, v in pairs ents
			cam\draw(-> if v.draw ~= nil then v\draw!)

		if debug.debugMode and debug.debugShow then
			love.graphics.setColor(63, 72, 204)
			love.graphics.print("FPS: " .. love.timer.getFPS(), 16, 16)
			love.graphics.print("Number of entities: " .. ent_amt, 16, 32)
			love.graphics.print("Current room: " .. room, 16, 48)

	--check when the user presses a key. also checks entities for keypressed functions!
	keypressed: (key) =>

		--activate debug mode
		d = debug
		if key == "`" then
			if d.debugMode then
				d.debugShow = not d.debugShow
				if d.debugShow == true
					print("Debug menu enabled.")
				else
					print("Debug menu disabled.")

		--activate hitbox mode
		if key == "f1" then
			if d.debugMode then
				if d.debugShow then
					d.drawHbox = not d.drawHbox
					if d.drawHbox == true
						print("Hitboxes drawn.")
					else
						print("Hitboxes hidden.")

		--just incase entities use it?
		for k,v in pairs(ents)
			if v.keypressed != nil then v\keypressed(key)

	--all this stuff drags the window
	mousepressed: (x, y) =>
		if settings.borderless
			draggable.start!
	mousereleased: =>
		if settings.borderless
			draggable.stop!
	mousemoved: (x, y, dx, dy) =>
		if settings.borderless
			draggable.move(dx, dy)

	--checks the entities table to see if they have any textinput functions. gets keyboard strings!
	textinput: (t) =>
		for i = ent_amt, 1, -1 do
			v = ents[i]
			if v.textinput then
				v\textinput(t)

	------------------------------
	----PART 3.2: SYSTEMS-----
	------------------------------

	--entity functions. used for finding, creating, and removing entities!
	object:

		create: (ent) => --inserts new instance
			table.insert(ents, ent)
			if ent.new ~= nil then ent\new()
			ent_amt += 1

			if debug.debugMode then print("Created ent -> " .. ent.name, ent)

		remove: (ent) => --removes an entity from the table (find it first)
			for i = ent_amt, 1, -1 do
				v = ents[i]
				if v == ent
					if v.destroy
						v\destroy!
					table.remove(ents, i)
					ent_amt -= 1
					if debug.debugMode
						print("Removed ent -> " .. ent.name, v)

		findCol: (s, other) => --weird. checks to find colliding entities!
			l = mad.col\colList(s, s.x, s.y, other) --get list of things colliding with s(elf)
			for k,v in pairs(l)
				if mad.col\checkCol(v, v.x, v.y, s.col) > 0 then --check if the things are colliding with 
					return v

		--returns ent based on name
		findUnique: (name) =>
			for k, v in pairs ents
				if v.name == name then
					return v
	--ROOM SYSTEM. changing and running 'em!
	room:
		--set room
		change: (new_room) =>

			if debug.debugMode then print("Switched room to [" .. new_room .. "].")

			--delete everything non-persistent
			for i = #ents, 1, -1
				v = ents[i]
				if not v.persistent
					mad.object\remove(v)
				else
					if debug.debugMode then print("persistent entity: " .. v.name, v)

    		--set room; run event code
			room = new_room
			for k,v in pairs(room_reg)
				if v.name == room then
					@runRoom(v.name, v.event)

		--run room creation func
		runRoom: (new_room, func) =>
			if room == new_room then
				func!
			if debug.debugMode then print("Finished creating objects for room [" .. room .. "].")

	-------------------------------------------
	----PART 3.3: ACTUAL GAME STUFF-----
	-------------------------------------------

	--USER INPUT. keyboards and controllers! mice soon!
	input:
		--basic keyboard keys
		key: (key_code) =>
			if love.keyboard.isDown(key_code) then
				return true
			else
				return false

		--get gamepad button down
		joyButton: (controller, button) =>
			if controller\isGamepadDown(button) then
				return true
			else
				return false

		--get axis of gamepad
		joyAxis: (controller, axis) =>
			return controller\getAxis(axis)

		--check if there's a certain controller connected
		joyConnected: (controller) =>
			if joysticks[controller] ~= nil
				return true
			else
				return false

		--get controller list
		getControllers: =>
			return love.joystick.getJoysticks()

	--drawing and animating
	sprite:
		--returns a basic image from a path
		img: (img_name) =>
			return love.graphics.newImage(path.img .. img_name)

		--sets up a grid for an image
		grid: (image, frame_width, frame_height) =>
			return anim8.newGrid(frame_width, frame_height, image\getWidth(), image\getHeight())

		--sets up an image with a grid for animation
		gImg: (image_name, frame_width, frame_height) =>
			i = love.graphics.newImage(path.img .. image_name)
			g = anim8.newGrid(frame_width, frame_height, i\getWidth(), i\getHeight())
			return i, g

		--defines an animation
		anim: (grid, frames, row, speed) =>
			return anim8.newAnimation(grid(frames, row), speed)

		--zord ents (called in base)
		zord: (s, mod) =>
			mod = mod or 0
			s.z = -s.y - (s.h) + mod

	--sound functionality
	audio:
		--plays a sound
		playSound: (sound, tags, velocity, pitch) =>
			velocity = velocity or 1
			pitch = pitch or 1
			TEsound.play(path.snd .. sound, tags, velocity, pitch)

		--loop sound
		loopSound: (sound, tags, loops, velocity, pitch) =>
			velocity = velocity or 1
			pitch = pitch or 1
			loops = loops or 1
			TEsound.playLooping(path.snd .. sound, tags, loops, velocity, pitch)

	-------------------------
	----PART 3.4: MISC----
	-------------------------

	--math stuff
	math:
		clamp: (low, n, high) ->
			return math.min(math.max(low, n), high)
			
		lerp: (a,b,t) ->
			return (1-t)*a + t*b

	col:
		--will return how many objects of a given tag are within an object's boundingbox
		colList: (s, x, y, collision_group) =>
			list = {}
			for k, v in pairs ents
				if v.col == collision_group and v ~= s then
					if @boundingBox(x, y, s, v) then
						table.insert(list, v)
			return list

		--will automatically return the size of a colList
		checkCol: (s, x, y, collision_group) =>
			return #@colList(s, x, y, collision_group)

		--check if object is overlapping other object
		boundingBox: (x, y, o, o2) =>
			return x < o2.x+o2.w and o2.x < x+o.w and y < o2.y+o2.h and o2.y < y+o.h

		--set col group for ent
		setCollisionGroup: (o, g) =>
			o.col = g

	--makes collision happen
	bumpWorld: bump.newWorld!

	--reorganizes the table based off of the ents' z value (BAD BAD BAD)
	drawSort: (a, b) ->
		if a and b then
			return a.z > b.z

	--kinda useless; polls object to see if it can access this lib			
	test: =>
		print("madlib is working for the polled object")

}

---[entity class]---
--functions (every entity can call these!)
	--new: (self, width, height, name)
		--this is called via super when the entity needs to be set up! every entity calls this upon creation
	--update: (dt)
		--called every frame. duh.
		--when supered, the child entity is zorded
	--draw!
		--draws em. duh.
		--when supered, the child entitiy's hitbox is rendered when that's on
	--destroy!
		--this is called when entities are thrown away and deleted :^(
	--keypress: (key)
		--u can use this to simulate keypresses!
--vars (every entity will have these!)
	--x, y, z (ints)
		--position variables
	--w, h (ints)
		--hitbox scale values
	--name (string)
		--name. some **unique** entities can use this to be referenced
	--xscale, yscale, angle (ints)
		--transformation vars
	--persistent (bool)
		--persistence upon room change

export class Entity
	
	new: (@obj, @w=32, @h=32, @name="entity", @col) => --base variables
		@z = -@obj.y
		@xscale = 1
		@yscale = 1
		@angle = 0

	update: (dt) =>
		mad.sprite\zord(self) --zordin'

	draw: =>
		if debug.debugMode and debug.debugShow and debug.drawHbox then --draws hitbox when in debug mode
			love.graphics.setColor(255, 0, 0, 150)
			love.graphics.rectangle("fill", @x, @y, @w, @h)