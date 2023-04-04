function onLoaded(data:Dynamic)
{
	var player:Entity = state.spawn("entities/player");
	player.screenCenter();
	state.player = player;
}
