var interactor:Entity;

function onLoaded()
{
	this.tags.push("interactable");
}

function onUpdate(elapsed:Float)
{
	if (interactor == null)
	{
		// Idle animation
		if ((animation.name == "interactable" || animation.finished) && animation.exists("idle"))
			animation.play("idle");
	}
	else
	{
		// Interact animation
		if ((animation.name == "idle" || animation.finished) && animation.exists("interactable"))
			animation.play("interactable");
	}
}

function enterInteractRange(entity:Entity)
{
	interactor = entity;
}

function exitInteractRange(entity:Entity)
{
	if (entity == interactor)
		interactor = null;
}
