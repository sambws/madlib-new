export class Cool extends Entity
	new: (@x, @y) =>
		super self, 32, 32, "cool"

	update: (dt) =>
		super self

	draw: =>
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", @x, @y, @w, @h)