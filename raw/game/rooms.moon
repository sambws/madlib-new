require.tree "game.ent"

export room_reg = {

	--end results screen for the dungeon
	debug_room: {
		name: "debug_room"
		event: =>
			mad.object\create(TextThing(128, 128))
	}

}