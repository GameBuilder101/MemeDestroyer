// Requires variables levels:Array<Dynamic>
var player:Entity;
var spots:Array;

function onLoaded()
{
	player = state.spawn("entities/map_player");

	spots = new Array();
	var spot:Entity;
	for (level in levels)
	{
		spot = state.spawn("entities/level_spot", level.position[0], level.position[1]);
		spot.getComponent("spot").set("level", LevelRegistry.getAsset(level.id));
		spots.push(spot);
	}

	player.setPosition(spots[0].x, spots[0].y);
}

function onLevelUpdate(elapsed:Float)
{
	// Make the camera follow the player
	FlxG.camera.y = -player.y + FlxG.camera.height / 2.0;
	// Stop the camera from going past the map
	if (FlxG.camera.y < -(state.background.height - FlxG.camera.height))
		FlxG.camera.y = -(state.background.height - FlxG.camera.height);
	else if (FlxG.camera.y > 0.0)
		FlxG.camera.y = 0.0;
}
