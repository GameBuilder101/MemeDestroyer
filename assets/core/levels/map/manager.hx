// Requires variables levels:Array<Dynamic>
var player:Entity;

// The index of the current level
var currentLevel:Int = 0;
var spots:Array;

function onLoaded()
{
	player = state.spawn("entities/map_player");

	spots = new Array();
	var spot:Entity;
	for (level in levels)
	{
		spot = state.spawn("entities/level_spot", level.position[0], level.position[1]);
		spots.push(spot);
	}

	player.setPosition(spots[0].x, spots[0].y);
}

function onLevelUpdate(elapsed:Float)
{
	var prevLevel:Int = currentLevel;
	if (Controls.moveUp.check() && levels[currentLevel].connections[0] >= 0)
		currentLevel = levels[currentLevel].connections[0];
	if (Controls.moveDown.check() && levels[currentLevel].connections[1] >= 0)
		currentLevel = levels[currentLevel].connections[1];
	if (Controls.moveLeft.check() && levels[currentLevel].connections[2] >= 0)
		currentLevel = levels[currentLevel].connections[2];
	if (Controls.moveRight.check() && levels[currentLevel].connections[3] >= 0)
		currentLevel = levels[currentLevel].connections[3];

	if (currentLevel != prevLevel)
	{
		spots[prevLevel].mainSprite.animation.play("locked");
		spots[currentLevel].mainSprite.animation.play("interactable");
		player.getComponent("controller").call("moveTo", [new Point(spots[currentLevel].x, spots[currentLevel].y)]);
	}

	// Make the camera follow the player
	FlxG.camera.scroll.y = player.y - FlxG.camera.height / 2.0;

	// Stop the camera from going past the map
	if (FlxG.camera.scroll.y < 0.0)
		FlxG.camera.scroll.y = 0.0;
	else if (FlxG.camera.scroll.y > state.background.height - FlxG.camera.height)
		FlxG.camera.scroll.y = state.background.height - FlxG.camera.height;
}
