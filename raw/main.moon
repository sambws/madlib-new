--stuff to require; madlib, data registry, entities, etc.
require "lib.mad.madlib"
require "game.rooms"

love.load = ->
	love.graphics.setDefaultFilter('nearest', 'nearest')
	mad\init! --init stuff
	mad.room\change("debug_room") --switch the room

love.update = (dt) ->
	mad\update(dt) --update all ents

love.draw = ->
	mad\draw(camera) --draw all ents

love.keypressed = (key) ->
	mad\keypressed(key) --used for debugging

love.mousepressed = (x, y) ->
	mad\mousepressed(x, y)

love.mousereleased = ->
	mad\mousereleased!

love.mousemoved = (x, y, dx, dy) ->
	mad\mousemoved(x, y, dx, dy)

love.textinput = (t) ->
	mad\textinput(t)

love.timer.sleep = ->