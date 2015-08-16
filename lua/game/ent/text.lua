do
  local _parent_0 = Entity
  local _base_0 = {
    update = function(self, dt)
      return _parent_0.update(self, self)
    end,
    draw = function(self)
      love.graphics.setColor(255, 255, 255)
      love.graphics.print("MADLIB!", self.x, self.y)
      return _parent_0.draw(self, self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      self.x, self.y = x, y
      _parent_0.__init(self, self, 0, 0, "text_thing")
      return print(Cool.var)
    end,
    __base = _base_0,
    __name = "TextThing",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  TextThing = _class_0
end
