--game conf
love.conf = (t) ->
	t.window.width = 448
	t.window.height = 736
	t.window.title = "madlib"
	t.window.borderless = true
	t.console = true

	settings.borderless = t.window.borderless

--settings to check
export settings = {
	borderless: true --controls whether u can drag the window in borderless mode
}

--keys
export keys = {
}

--collision groups
export col = {
}