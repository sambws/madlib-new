export class TextThing extends Entity
	new: (@x, @y) =>
		super self, 0, 0, "text_thing"

	update: (dt) =>
		super self

	draw: =>
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("MADLIB!", @x, @y)
		super self