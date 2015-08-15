require("lib.mad.require")
require("lib.mad.TEsound")
local bump = require("lib.mad.bump")
local gamera = require("lib.mad.gamera")
local anim8 = require("lib.mad.anim8")
local draggable = require("lib.mad.draggable")
math.randomseed(os.time())
room = ""
ent_amt = 0
ents = { }
joy_table = love.joystick.getJoysticks()
joystick = joy_table[1]
path = {
  img = "res/img/",
  snd = "res/snd/",
  dat = "res/dat/"
}
debug = {
  debugMode = true,
  debugShow = true,
  drawHbox = false,
  ctrlMod = false
}
mad = {
  init = function(self)
    camera = gamera.new(-5, -5, love.graphics.getWidth() + 5, love.graphics.getHeight() + 5)
    return camera:setPosition(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  end,
  update = function(self, dt)
    for k, v in pairs(ents) do
      if v.update ~= nil then
        v:update(dt)
      end
    end
    if not debug.debugMode then
      debug.debugShow = false
    end
    if self.input:key("lctrl") then
      debug.ctrlMod = true
    else
      debug.ctrlMod = false
    end
  end,
  draw = function(self, cam)
    table.sort(ents, self.drawSort)
    for k, v in pairs(ents) do
      cam:draw(function()
        if v.draw ~= nil then
          return v:draw()
        end
      end)
    end
    if debug.debugMode and debug.debugShow then
      love.graphics.setColor(63, 72, 204)
      love.graphics.print("FPS: " .. love.timer.getFPS(), 16, 16)
      love.graphics.print("Number of entities: " .. ent_amt, 16, 32)
      return love.graphics.print("Current room: " .. room, 16, 48)
    end
  end,
  keypressed = function(self, key)
    local d = debug
    if key == "`" then
      if d.debugMode then
        d.debugShow = not d.debugShow
        if d.debugShow == true then
          print("Debug menu enabled.")
        else
          print("Debug menu disabled.")
        end
      end
    end
    if key == "f1" then
      if d.debugMode then
        if d.debugShow then
          d.drawHbox = not d.drawHbox
          if d.drawHbox == true then
            print("Hitboxes drawn.")
          else
            print("Hitboxes hidden.")
          end
        end
      end
    end
    for k, v in pairs(ents) do
      if v.keypressed ~= nil then
        v:keypressed(key)
      end
    end
  end,
  mousepressed = function(self, x, y)
    if settings.borderless then
      return draggable.start()
    end
  end,
  mousereleased = function(self)
    if settings.borderless then
      return draggable.stop()
    end
  end,
  mousemoved = function(self, x, y, dx, dy)
    if settings.borderless then
      return draggable.move(dx, dy)
    end
  end,
  textinput = function(self, t)
    for i = ent_amt, 1, -1 do
      local v = ents[i]
      if v.textinput then
        v:textinput(t)
      end
    end
  end,
  object = {
    create = function(self, ent)
      table.insert(ents, ent)
      if ent.new ~= nil then
        ent:new()
      end
      ent_amt = ent_amt + 1
      if debug.debugMode then
        return print("Created ent -> " .. ent.name, ent)
      end
    end,
    remove = function(self, ent)
      for i = ent_amt, 1, -1 do
        local v = ents[i]
        if v == ent then
          if v.destroy then
            v:destroy()
          end
          table.remove(ents, i)
          ent_amt = ent_amt - 1
          if debug.debugMode then
            print("Removed ent -> " .. ent.name, v)
          end
        end
      end
    end,
    findCol = function(self, s, other)
      local l = mad.col:colList(s, s.x, s.y, other)
      for k, v in pairs(l) do
        if mad.col:checkCol(v, v.x, v.y, s.col) > 0 then
          return v
        end
      end
    end,
    findUnique = function(self, name)
      for k, v in pairs(ents) do
        if v.name == name then
          return v
        end
      end
    end
  },
  room = {
    change = function(self, new_room)
      if debug.debugMode then
        print("Switched room to [" .. new_room .. "].")
      end
      for i = #ents, 1, -1 do
        local v = ents[i]
        if not v.persistent then
          mad.object:remove(v)
        else
          if debug.debugMode then
            print("persistent entity: " .. v.name, v)
          end
        end
      end
      room = new_room
      for k, v in pairs(room_reg) do
        if v.name == room then
          self:runRoom(v.name, v.event)
        end
      end
    end,
    runRoom = function(self, new_room, func)
      if room == new_room then
        func()
      end
      if debug.debugMode then
        return print("Finished creating objects for room [" .. room .. "].")
      end
    end
  },
  input = {
    key = function(self, key_code)
      if love.keyboard.isDown(key_code) then
        return true
      else
        return false
      end
    end,
    joyButton = function(self, controller, button)
      if controller:isGamepadDown(button) then
        return true
      else
        return false
      end
    end,
    joyAxis = function(self, controller, axis)
      return controller:getAxis(axis)
    end,
    joyConnected = function(self, controller)
      if joysticks[controller] ~= nil then
        return true
      else
        return false
      end
    end,
    getControllers = function(self)
      return love.joystick.getJoysticks()
    end
  },
  sprite = {
    img = function(self, img_name)
      return love.graphics.newImage(path.img .. img_name)
    end,
    grid = function(self, image, frame_width, frame_height)
      return anim8.newGrid(frame_width, frame_height, image:getWidth(), image:getHeight())
    end,
    gImg = function(self, image_name, frame_width, frame_height)
      local i = love.graphics.newImage(path.img .. image_name)
      local g = anim8.newGrid(frame_width, frame_height, i:getWidth(), i:getHeight())
      return i, g
    end,
    anim = function(self, grid, frames, row, speed)
      return anim8.newAnimation(grid(frames, row), speed)
    end,
    zord = function(self, s, mod)
      mod = mod or 0
      s.z = -s.y - (s.h) + mod
    end
  },
  audio = {
    playSound = function(self, sound, tags, velocity, pitch)
      velocity = velocity or 1
      pitch = pitch or 1
      return TEsound.play(path.snd .. sound, tags, velocity, pitch)
    end,
    loopSound = function(self, sound, tags, loops, velocity, pitch)
      velocity = velocity or 1
      pitch = pitch or 1
      loops = loops or 1
      return TEsound.playLooping(path.snd .. sound, tags, loops, velocity, pitch)
    end
  },
  math = {
    clamp = function(low, n, high)
      return math.min(math.max(low, n), high)
    end,
    lerp = function(a, b, t)
      return (1 - t) * a + t * b
    end
  },
  col = {
    colList = function(self, s, x, y, collision_group)
      local list = { }
      for k, v in pairs(ents) do
        if v.col == collision_group and v ~= s then
          if self:boundingBox(x, y, s, v) then
            table.insert(list, v)
          end
        end
      end
      return list
    end,
    checkCol = function(self, s, x, y, collision_group)
      return #self:colList(s, x, y, collision_group)
    end,
    boundingBox = function(self, x, y, o, o2)
      return x < o2.x + o2.w and o2.x < x + o.w and y < o2.y + o2.h and o2.y < y + o.h
    end,
    setCollisionGroup = function(self, o, g)
      o.col = g
    end
  },
  bumpWorld = bump.newWorld(),
  drawSort = function(a, b)
    if a and b then
      return a.z > b.z
    end
  end,
  test = function(self)
    return print("madlib is working for the polled object")
  end
}
do
  local _base_0 = {
    update = function(self, dt)
      return mad.sprite:zord(self)
    end,
    draw = function(self)
      if debug.debugMode and debug.debugShow and debug.drawHbox then
        love.graphics.setColor(255, 0, 0, 150)
        return love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, obj, w, h, name, col)
      if w == nil then
        w = 32
      end
      if h == nil then
        h = 32
      end
      if name == nil then
        name = "entity"
      end
      self.obj, self.w, self.h, self.name, self.col = obj, w, h, name, col
      self.z = -self.obj.y
      self.xscale = 1
      self.yscale = 1
      self.angle = 0
    end,
    __base = _base_0,
    __name = "Entity"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Entity = _class_0
end
