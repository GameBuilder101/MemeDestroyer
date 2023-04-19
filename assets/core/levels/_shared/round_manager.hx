// Requires variables bosses:Array<Dynamic>, mainThemeID:String

var currentRound:Int = -1;

// The main theme music for the level
var mainTheme:AssetMusic;

// True when the player has died and the level is ending
var deathTransitioning:Bool = false;

function onLoaded()
{
	mainTheme = AssetMusicRegistry.getAsset(mainThemeID);
}

function onLevelUpdate(elapsed:Float)
{
	if (getIsPlaying() && state.player == null && !deathTransitioning)
	{
		deathTransitioning = true;

		MusicManager.fadeOut(1.0);
		state.deathOverlay.display(null, function()
		{
			FlxG.switchState(new PlayState());
		});
	}
}

// Start the rounds
function start()
{
	if (getIsPlaying()) // If already playing
		end();
	nextRound(); // Start the first round

	MusicManager.transition(mainTheme, 0.0);
}

// End the rounds
function end()
{
	currentRound = -1;
}

function getIsPlaying()
{
	return currentRound >= 0;
}

// Starts the next round
function nextRound()
{
	currentRound++;
	if (currentRound == bosses.length)
	{
		end();
		return;
	}

	state.boss = state.levelSpawn(bosses[currentRound]);
	state.titleOverlay.display({
		title: state.boss.name,
		subtitle: "Round " + (currentRound + 1),
		color: colorString(state.boss.getComponent("health").get("healthColor")),
		style: "fast"
	}, null);
}

function onUpdate(elapsed:Float)
{
	if (getIsPlaying() && state.boss == null)
		nextRound();
}
