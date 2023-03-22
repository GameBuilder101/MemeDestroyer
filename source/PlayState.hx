package;

import entity.Entity;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	public var worldCamera(default, null):FlxCamera;
	public var uiCamera(default, null):FlxCamera;

	var entities:FlxTypedGroup<Entity>;

	/** A map of tags which lists what entities are associated with each
		tag. Mainly used to increase performance of collision-checking. Note:
		once a key/array pair is created, it never gets removed.
	**/
	var entitiesByTag:Map<String, Array<Entity>> = [];

	public static inline final PLAYER_ENTITY_ID = "entities/player";

	public var player(default, null):Entity;
	public var boss(default, null):Entity;

	/** For miscellaneous effect sprites. **/
	var effects:FlxGroup;

	/** Health indicator for player. **/
	public var playerHealth(default, null):HealthNotches;

	/** Health indicator for bosses. **/
	public var bossHealth(default, null):HealthBar;

	override function create()
	{
		super.create();
		FlxG.worldBounds.set(0.0, 0.0, FlxG.width, FlxG.height);
		worldCamera = FlxG.camera;
		uiCamera = new FlxCamera();

		entities = new FlxTypedGroup<Entity>();
		add(entities);

		effects = new FlxGroup();
		add(effects);

		// Add the health notches
		playerHealth = new HealthNotches();
		playerHealth.camera = uiCamera;
		playerHealth.setPosition(FlxG.width / 2.0, -20.0);
		add(playerHealth);

		// Add the health bar
		bossHealth = new HealthBar();
		bossHealth.camera = uiCamera;
		bossHealth.screenCenter();
		bossHealth.y = FlxG.height - bossHealth.height;
		add(bossHealth);

		// Add the player
		player = new Entity(0.0, 0.0, null, PLAYER_ENTITY_ID);
		addEntity(player);

		addEntity(new Entity(100.0, 100.0, null, "items/nokia"));
		addEntity(new Entity(200.0, 200.0, null, "entities/test_meme"));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		entities.sort(function(order:Int, entity1:Entity, entity2:Entity):Int
		{
			// Higher sorting priorities go above
			if (entity1.sortingPriority != entity2.sortingPriority)
				return FlxSort.byValues(order, entity1.sortingPriority, entity2.sortingPriority);
			if (entity1.mainSprite == null)
				return -1;
			else if (entity2.mainSprite == null)
				return 1;
			// Make further-down things appear on top (to immitate depth)
			return FlxSort.byValues(order, entity1.y + entity1.mainSprite.height, entity2.y + entity2.mainSprite.height);
		});
	}

	/** Use this function to add any entities. **/
	public function addEntity(entity:Entity)
	{
		if (entities.members.contains(entity))
			return;
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
	public function spawn(id:String, x:Float, y:Float):Entity
	{
		var entity:Entity = new Entity(x, y, null, id);
		addEntity(entity);
		return entity;
	}
}
