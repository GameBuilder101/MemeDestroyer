// Requires variables team:String
// Projectiles shot by this shooter will be cached and re-used when possible
var projectiles:Array<Entity>;

function onLoaded()
{
	projectiles = [];
}

// Fires a projectile by creating or re-using an entity with the given ID
function fire(id:String, angle:Float, velocity:Float = 1.0)
{
	var target:Entity = null;
	for (projectile in projectiles)
	{
		if (projectile.id == id && !projectile.alive) // If the projectile is dead, it can be re-used
		{
			target = projectile;
			break;
		}
	}
	// If no re-usable target exists, create a new target projectile
	if (target == null)
	{
		target = new Entity(0.0, 0.0, null, id);
		projectiles.push(target);
	}

	// If the entity were removed at some point, this makes sure it gets added back
	state.addEntity(target);

	target.callAll("fire", [team, this.x, this.y, angle, velocity]);
}
