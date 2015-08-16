require("lib.mad.madlib")
require("game.rooms")
love.load = function()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  mad:init()
  return mad.room:change("debug_room")
end
love.update = function(dt)
  return mad:update(dt)
end
love.draw = function()
  return mad:draw(camera)
end
love.keypressed = function(key)
  return mad:keypressed(key)
end
love.mousepressed = function(x, y)
  return mad:mousepressed(x, y)
end
love.mousereleased = function()
  return mad:mousereleased()
end
love.mousemoved = function(x, y, dx, dy)
  return mad:mousemoved(x, y, dx, dy)
end
love.textinput = function(t)
  return mad:textinput(t)
end
love.timer.sleep = function() end
