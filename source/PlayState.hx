package;

import entity.Entity;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.util.FlxSort;
import gbc.graphics.AssetSprite;
import gbc.scripting.ComponentSystem;
import gbc.scripting.Script;
import level.Level;
import level.LevelRegistry;
import ui.pause_menu.PauseMenuState;

/** The play state can load a level and contains entities. **/
class PlayState extends FlxTransitionableState
{
	var initialLevelID:String;

	/** The ID the current level was loaded with. Null if created dynamically. **/
	public var levelID(default, null):String;

	/** The currently-loaded level data. **/
	public var level(default, null):LevelData;

	/** The components for the currently-loaded level. **/
	public var components(default, null):ComponentSystem;

	/** The sprite for the level background. **/
	public var background(default, null):AssetSprite;

	var entities:FlxTypedGroup<Entity>;

	/** A map of tags which lists what entities are associated with each
		tag. Mainly used to increase performance of collision-checking. Note:
		once a key/array pair is created, it never gets removed.
	**/
	var entitiesByTag:Map<String, Array<Entity>> = [];

	/** For miscellaneous effect sprites. **/
	var effects:FlxGroup;

	/** Set false to disable the pause menu. **/
	public var allowPausing(default, null):Bool = true;

	/** Used to prevent the pause menu from opening right after closing. **/
	var pauseCooldown:Float;

	public function new(levelID:String)
	{
		super();
		initialLevelID = levelID;
	}

	override function create()
	{
		super.create();
		components = new ComponentSystem();

		background = new AssetSprite(0.0, 0.0);
		add(background);

		entities = new FlxTypedGroup<Entity>();
		add(entities);

		effects = new FlxGroup();
		add(effects);

		loadLevel(null, initialLevelID);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		components.callAll("onUpdate", [elapsed]);

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

		if (pauseCooldown > 0.0)
		{
			pauseCooldown -= elapsed;
			if (pauseCooldown < 0.0)
				pauseCooldown = 0.0;
		}
		else if (allowPausing && Controls.pause.check()) // Open the pause menu when the input is triggered
		{
			openSubState(new PauseMenuState());
			pauseCooldown = 0.1;
		}
	}

	override function destroy()
	{
		for (entity in entities)
			entity.onRemovedFromPlay();
		super.destroy();
	}

	public function loadLevel(data:LevelData = null, id:String = null)
	{
		components.callAll("onUnloaded");

		// Find the level
		levelID = null;
		if (data == null && id != null)
		{
			levelID = id;
			data = LevelRegistry.getAsset(id);
		}
		if (data == null)
			return;
		this.level = data;

		// Load all level scripts
		components = new ComponentSystem();
		for (path in cast(data.components, Array<Dynamic>))
		{
			components.addNewComponent(path, GameScript, function(path:String):Script
			{
				return GameScriptRegistry.getAsset(path);
			});
		}

		// Load the background sprite
		if (level.backgroundSpriteID != null)
			background.loadFromID(level.backgroundSpriteID);
		FlxG.worldBounds.set(background.x, background.y, background.width, background.height);

		// Remove existing entities
		for (entity in entities.members)
			removeEntity(entity);

		// Create initial spawns, but don't yet add them (since onAddedToPlay should only get called after the level is created)
		var initialEntities:Array<Entity> = [];
		for (spawn in level.initialSpawns)
			initialEntities.push(levelSpawnCreate(spawn));

		components.setAll("this", this);
		components.setAll("state", this);

		if (data.variables != null)
		{
			// The variables array is used to set variables in components
			for (variable in data.variables)
				components.setAll(variable.name, variable.value);
		}

		components.startAll();
		components.callAll("onLoaded");

		// Add the previously-created entities
		for (entity in initialEntities)
			addEntity(entity);
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

		entity.onAddedToPlay();
	}

	/** Use this function before destroying an entity to remove it. **/
	public function removeEntity(entity:Entity, kill:Bool = true, destroy:Bool = false)
	{
		entities.remove(entity, true);
		for (tag in entity.tags)
			entitiesByTag[tag].remove(entity);

		if (kill)
			entity.kill();
		if (destroy)
			entity.destroy();
		entity.onRemovedFromPlay();
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

	/** Only creates an entity based on the data from a level spawn. **/
	function levelSpawnCreate(spawn:LevelSpawn):Entity
	{
		var x:Float = spawn.position[0];
		if (spawn.randomizeX)
			x = Math.random() * FlxG.width;
		var y:Float = spawn.position[1];
		if (spawn.randomizeY)
			y = Math.random() * FlxG.height;
		return new Entity(x, y, null, spawn.id);
	}

	/** Creates and adds an entity based on the data from a level spawn. **/
	public function levelSpawn(spawn:LevelSpawn):Entity
	{
		var entity:Entity = levelSpawnCreate(spawn);
		addEntity(entity);
		return entity;
	}
}
