package;

import entity.Entity;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import gbc.graphics.AssetSprite;

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
	public var boss(default, null):Entity;

	/** For miscellaneous effect sprites. **/
	var effects:FlxGroup;

	/** Used primarily for bosses. **/
	public var healthBar(default, null):FlxSpriteGroup;

	var healthBarBack:AssetSprite;
	var healthBarFill:AssetSprite;
	var healthBarLabel:FlxText;

	/** Used primarily for player health. **/
	public var healthNotches(default, null):FlxTypedSpriteGroup<AssetSprite>;

	override function create()
	{
		super.create();
		FlxG.worldBounds.set(0.0, 0.0, FlxG.width, FlxG.height);

		entities = new FlxTypedGroup<Entity>();
		add(entities);

		effects = new FlxGroup();
		add(effects);

		// Add the health bar sprites
		healthBar = new FlxSpriteGroup();
		add(healthBar);

		healthBarBack = new AssetSprite(0.0, 0.0, null, "ui/hud/health_bar_back");
		healthBar.add(healthBarBack);
		healthBar.screenCenter();
		healthBar.y = FlxG.height - healthBarBack.height;

		healthBarFill = new AssetSprite(0.0, 0.0, null, "ui/hud/health_bar_fill");
		add(healthBarFill);
		healthBar.add(healthBarFill);

		healthBarLabel = new FlxText(0.0, -healthBar.height + 16.0, healthBar.width, "Meme Name");
		healthBarLabel.setFormat("Edit Undo BRK", 20, FlxColor.WHITE, CENTER, SHADOW, FlxColor.BLACK);
		healthBar.add(healthBarLabel);

		// Add the health notches sprites
		healthNotches = new FlxTypedSpriteGroup<AssetSprite>();
		healthNotches.screenCenter();
		healthNotches.y = healthBarBack.height; // Assume the health notches have the same height
		add(healthNotches);

		// Add the player
		player = new Entity(0.0, 0.0, null, PLAYER_ENTITY_ID);
		addEntity(player);

		addEntity(new Entity(100.0, 100.0, null, "items/nokia")); // Test
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

		updateHealthNotches(3.0, 5.0);
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
	public function spawn(id:String, x:Float, y:Float)
	{
		addEntity(new Entity(x, y, null, id));
	}

	public function updateHealthNotches(health:Float, maxHealth:Float)
	{
		var healthInt:Int = Math.ceil(health);
		var maxHealthInt:Int = Math.ceil(maxHealth);

		// Make sure there are the correct number of health notches
		while (healthNotches.members.length < maxHealthInt) // Add new health notches to match
			healthNotches.add(new AssetSprite(0.0, 0.0, null, "ui/hud/health_notch"));
		while (healthNotches.members.length > maxHealthInt) // Remove health notches to match
			healthNotches.remove(healthNotches.members[0]);

		// Update the positions
		for (i in 0...healthNotches.length)
			healthNotches.members[i].setPosition((i - (healthNotches.length * 0.5)) * healthNotches.members[i].width, 0.0);

		// Update the graphics
		for (i in 0...healthNotches.length)
		{
			if (i > healthInt)
				healthNotches.members[i].animation.play("empty");
			else
				healthNotches.members[i].animation.play("filled");
		}
	}
}
