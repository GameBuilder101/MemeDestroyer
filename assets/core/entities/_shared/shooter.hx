// Requires variables team:String
// Projectiles shot by this shooter will be cached and re-used when possible
var projectiles;

function onLoaded()
{
	projectiles = new Map<String, Array<Entity>>();
}

// Fires a projectile by creating or re-using an entity with the given ID
function fire(id:String, angle:Float, velocity:Float = 1.0)
{
	if (!projectiles.exists(id)) // Add a list for the projectile of type ID
		projectiles.set(id, []);

	var target:Entity = null;
	for (projectile in projectiles[id])
	{
		if (!projectile.alive) // If the projectile is dead, it can be re-used
		{
			target = projectile;
			break;
		}
	}
	// If no re-usable target exists, create a new target projectile
	if (target == null)
	{
		target = new Entity(0.0, 0.0, EntityRegistry.getAsset(id));
		projectiles[id].push(target);
	}

	// If the entity were removed at some point, this makes sure it gets added back
	state.addEntity(target);

	target.callAll("fire", [team, this.x, this.y, angle, velocity]);
}
