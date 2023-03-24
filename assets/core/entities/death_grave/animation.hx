// Requires variables fallSpeed:Float

function onLoaded()
{
	this.mainSprite.y = 0.0;
}

function onUpdate(elapsed:Float)
{
	if (animation.finished && animation.name == "land")
		animation.play("idle");

	if (this.mainSprite.y >= this.y)
		return;
	this.mainSprite.y += fallSpeed * elapsed;
	if (this.mainSprite.y >= this.y)
	{
		this.mainSprite.y = this.y;
		animation.play("land", true);
	}
}
