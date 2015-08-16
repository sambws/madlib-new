require.tree("game.ent")
room_reg = {
  debug_room = {
    name = "debug_room",
    event = function(self)
      return mad.object:create(TextThing(128, 128))
    end
  }
}
