#madlib documentation  

####OBJECT  HANDLING  

	object\createEnt(ent)
Will add an instance of an entity to the ents table

	object\createGUI(ent)
Will add an instance of an entity to the gui table

	object\removeEnt(ent)
Removes an entity from the ent table

####SPRITES AND ANIMATION
	sprite\img(path)
Will return an image with the desired file name in the image path

	sprite\gImg(path, grid_width, grid_height)
Will return a grid and an image with the desired frame width, height, and image name

	sprite\grid (image, grid_width, grid_height)
Will return a grid made out of the desired image

	sprite\anim (grid, frames, row, speed)
Will return an animation selected from the desired grid, frames, row, and speed

####INPUT
	input\key(keycode)
Will check if a certain key on the keyboard is being pressed

	input\joyButton(controller, button)
Will check if a certain button on the desired controller is being pressed

	input\joyAxis(controller, axis)
Will return the value of the requested axis of a controller

	input\joyConnected(controller)
Will check if a controller is connected in the joysticks table

	input\getControllers()
Will get all connected controllers and put them in a table

####ROOMS
	room\switchRoom(new_room)
Will switch the room to the desired room, running that room's creation code and deleting non-persistent entities

####AUDIO
	audio\playSound(sound, tags, velocity, pitch)
Will play a sound. Velocity and pitch are optional.

	audio\loopSound(sound, tags, loops, velocity, pitch)
Will loop a sound a desired number of times. Velocity and pitch are optional.

####CAMERA
	cam\look(camera, x, y)
Will automatically position the camera to camera coordinates x and y

####MATH
	math\clamp(value, low, high)
Will clamp a variable between a minimum and maximum

	math\lerp(old, new, time)
Will interpolate a variable between two values at a certain speed

####COLLISION
	col\colList(self, x, y, collision_group)
Will return a table with all entities colliding with an entity under the proper collision_group

	col\checkCol(self, x, y, collision_group)
Will return the length of a colList()

	setCollisionGroup(object, collision_group)
Will assign a collision group to an entity. Used for checking collision in a colList()

##LIST
    object\createEnt(ent)
	object\createGUI(ent)
	object\removeEnt(ent)  

	sprite\img(path)
	sprite\gImg(path, grid_width, grid_height)
	sprite\grid (image, grid_width, grid_height)
	sprite\anim (grid, frames, row, speed)

	input\key(keycode)
	input\joyButton(controller, button)
	input\joyAxis(controller, axis)
	input\joyConnected(controller)
	input\getControllers()

	room\switchRoom(new_room)
	
	audio\playSound(sound, tags, velocity, pitch)
	audio\loopSound(sound, tags, loops, velocity, pitch)

	cam\look(camera, x, y)

	math\clamp(value, low, high)
	math\lerp(old, new, time)

	col\colList(self, x, y, collision_group)
	col\checkCol(self, x, y, collision_group)
	setCollisionGroup(object, collision_group)
