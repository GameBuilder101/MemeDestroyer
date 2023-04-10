// Requires variables mainThemeID:String

var bosses:Array<Dynamic>;
var currentRound:Int = -1;

// The main theme music for the level
var mainTheme:AssetMusic;

function onLoaded()
{
	mainTheme = AssetMusicRegistry.getAsset(mainThemeID);
}

// Start the rounds
function start(bossList:Array<Dynamic>)
{
	if (getIsPlaying()) // If already playing
		end();
	bosses = bossList;
	nextRound(); // Start the first round

	mainTheme.play();
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
