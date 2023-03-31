var spawnSound:AssetSound;

function onLoaded()
{
	spawnSound = AssetSoundRegistry.getAsset("entities/death_explosion/sounds/spawn");
	if (spawnSound != null)
		spawnSound.play();
}

function onUpdate(elapsed:Float)
{
	if (animation.finished)
		state.removeEntity(this);
}
