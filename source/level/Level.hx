package level;

typedef LevelData =
{
	name:String,
	components:Array<String>,
	variables:Array<Dynamic>,
	backgroundSpriteID:String,
	initialSpawns:Array<LevelSpawn>
}

typedef LevelSpawn =
{
	id:String,
	position:Array<Int>,
	randomizeX:Bool, // When true, the spawn location X gets randomized
	randomizeY:Bool // When true, the spawn location Y gets randomized
}
