package;

import entity.Entity;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	var entities:Array<Entity> = [];

	/** A map of tags which lists what entities are associated with each
		tag. Mainly used to increase performance of collision-checking. Note:
		once a key/array pair is created, it never gets removed.
	**/
	var entitiesByTag:Map<String, Array<Entity>> = [];

	public static inline final PLAYER_ENTITY_ID = "entities/player";

	public var player(default, null):Entity;

	override function create()
	{
		super.create();
		FlxG.worldBounds.set(0.0, 0.0, FlxG.width, FlxG.height);

		player = new Entity(0.0, 0.0, null, PLAYER_ENTITY_ID);
		addEntity(player);

		addEntity(new Entity(100.0, 100.0, null, "items/nokia")); // Test
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// Make further-down things appear on top (to immitate depth)
		sort(function(order:Int, value1:FlxBasic, value2:FlxBasic):Int
		{
			return FlxSort.byY(order, cast value1, cast value2);
		}, FlxSort.ASCENDING);
	}

	/** Use this function to add any entities. **/
	public function addEntity(entity:Entity)
	{
		add(entity);
		entities.push(entity);
		for (tag in entity.tags)
		{
			if (!entitiesByTag.exists(tag)) // Add the key/array pair if it doesn't already exist
				entitiesByTag.set(tag, new Array<Entity>());
			entitiesByTag[tag].push(entity);
		}
	}

	/** Use this function before destroying an entity to remove it. **/
	public function removeEntity(entity:Entity)
	{
		if (!entities.contains(entity)) // If the entity was never added to the list
			return;
		remove(entity);
		entities.remove(entity);
		for (tag in entity.tags)
			entitiesByTag[tag].remove(entity);
	}

	/** Returns the first-added entity with tag. **/
	public function getEntity(tag:String):Entity
	{
		if (!entitiesByTag.exists(tag) || entitiesByTag[tag].length <= 0)
			return null;
		return entitiesByTag[tag][0];
	}

	/** Returns all entities with tag. **/
	public function getEntities(tag:String):Array<Entity>
	{
		if (!entitiesByTag.exists(tag))
			return [];
		return entitiesByTag[tag];
	}
}
