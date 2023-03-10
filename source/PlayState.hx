package;

import entity.Entity;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	var entities:FlxTypedGroup<Entity>;

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

		entities = new FlxTypedGroup<Entity>();
		add(entities);

		player = new Entity(0.0, 0.0, null, PLAYER_ENTITY_ID);
		addEntity(player);

		addEntity(new Entity(100.0, 100.0, null, "items/nokia")); // Test
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// Make further-down things appear on top (to immitate depth)
		entities.sort(function(order:Int, entity1:Entity, entity2:Entity):Int
		{
			if (entity1.mainSprite == null)
				return -1;
			else if (entity2.mainSprite == null)
				return 1;
			return FlxSort.byValues(order, entity1.y + entity1.mainSprite.height, entity2.y + entity2.mainSprite.height);
		});
	}

	/** Use this function to add any entities. **/
	public function addEntity(entity:Entity)
	{
		entities.add(entity);
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
		entities.remove(entity, true);
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

	/** Creates and adds an entity of the given ID. **/
	public function spawn(id:String, x:Float, y:Float)
	{
		addEntity(new Entity(x, y, null, id));
	}
}
