package;

import entity.Entity;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import gbc.graphics.AssetSprite;
import gbc.scripting.ComponentSystem;
import gbc.scripting.Script;
import level.Level;
import level.LevelRegistry;
import ui.hud.CountdownOverlay;
import ui.hud.HealthBar;
import ui.hud.HealthNotches;
import ui.hud.NotificationOverlay;
import ui.hud.TitleOverlay;

class PlayState extends FlxState
{
	public var levelCamera(default, null):FlxCamera;
	public var uiCamera(default, null):FlxCamera;

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

	public var player:Entity;
	public var boss:Entity;

	/** For miscellaneous effect sprites. **/
	var effects:FlxGroup;

	/** Health indicator for player. **/
	public var playerHealth(default, null):HealthNotches;

	/** Health indicator for bosses. **/
	public var bossHealth(default, null):HealthBar;

	public var titleOverlay(default, null):TitleOverlay;

	public var countdownOverlay(default, null):CountdownOverlay;

	public var deathOverlay(default, null):NotificationOverlay;

	override function create()
	{
		super.create();
		FlxG.worldBounds.set(0.0, 0.0, FlxG.width, FlxG.height);
		levelCamera = FlxG.camera;
		uiCamera = new FlxCamera();

		components = new ComponentSystem();

		background = new AssetSprite(0.0, 0.0);
		add(background);

		entities = new FlxTypedGroup<Entity>();
		add(entities);

		effects = new FlxGroup();
		add(effects);

		// Add the player health
		playerHealth = new HealthNotches();
		playerHealth.cameras = [uiCamera, levelCamera];
		playerHealth.setPosition(FlxG.width / 2.0, -20.0);
		add(playerHealth);

		// Add the boss health
		bossHealth = new HealthBar();
		bossHealth.cameras = [uiCamera, levelCamera];
		bossHealth.screenCenter();
		bossHealth.y = FlxG.height;
		bossHealth.visible = false; // The boss health starts hidden by default
		add(bossHealth);

		// Add the title overlay
		titleOverlay = new TitleOverlay(0.0, 0.0);
		titleOverlay.cameras = [uiCamera, levelCamera];
		titleOverlay.screenCenter();
		add(titleOverlay);

		// Add the countdown overlay
		countdownOverlay = new CountdownOverlay(0.0, 0.0, 0.4, [
			"ui/hud/sprites/countdown_overlay",
			"ui/hud/sprites/countdown_overlay",
			"ui/hud/sprites/countdown_overlay",
			"ui/hud/sprites/countdown_overlay"
		], ["three", "two", "one", "fight"], [
			"ui/hud/sounds/countdown_three",
			"ui/hud/sounds/countdown_two",
			"ui/hud/sounds/countdown_one",
			"ui/hud/sounds/countdown_fight"
		]);
		countdownOverlay.cameras = [uiCamera, levelCamera];
		countdownOverlay.screenCenter();
		add(countdownOverlay);

		// Add the death overlay
		deathOverlay = new NotificationOverlay(0.0, 0.0, "ui/hud/sprites/death_overlay", "ui/hud/sounds/death_overlay");
		deathOverlay.cameras = [uiCamera, levelCamera];
		deathOverlay.screenCenter();
		add(deathOverlay);

		loadLevel(null, "levels/overworld");
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
	}

	public function loadLevel(data:LevelData = null, id:String = null)
	{
		// Find the level
		if (data == null && id != null)
			data = LevelRegistry.getAsset(id);
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
		background.loadFromID(level.backgroundSpriteID);

		// Remove existing entities
		for (entity in entities.members)
			removeEntity(entity);

		// Add initial spawns
		for (spawn in level.initialSpawns)
			levelSpawn(spawn);

		components.setAll("state", this);

		if (data.variables != null)
		{
			// The variables array is used to set variables in components
			for (variable in data.variables)
				components.setAll(variable.name, variable.value);
		}

		components.startAll();
		components.callAll("onLoaded", [data]);
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
	public function removeEntity(entity:Entity, kill:Bool = true)
	{
		if (entity == player)
			player = null;
		if (entity == boss)
			boss = null;

		entities.remove(entity, true);
		for (tag in entity.tags)
			entitiesByTag[tag].remove(entity);

		if (kill)
			entity.kill();
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

	/** Creates and adds an entity based on the data from a level spawn. **/
	public function levelSpawn(spawn:LevelSpawn):Entity
	{
		var x:Float = spawn.position[0];
		if (spawn.randomizeX)
			x = Math.random() * FlxG.width;
		var y:Float = spawn.position[1];
		if (spawn.randomizeY)
			y = Math.random() * FlxG.height;
		return this.spawn(spawn.id, x, y);
	}

	/** Plays an animation to show the boss health bar. **/
	public function showBossHealth()
	{
		bossHealth.visible = true;
		FlxTween.cancelTweensOf(bossHealth);
		FlxTween.linearMotion(bossHealth, bossHealth.x, FlxG.height, bossHealth.x, FlxG.height - bossHealth.height);
	}

	/** Plays an animation to hide the boss health bar. **/
	public function hideBossHealth()
	{
		FlxTween.cancelTweensOf(bossHealth);
		FlxTween.linearMotion(bossHealth, bossHealth.x, FlxG.height - bossHealth.height, bossHealth.x, FlxG.height, 1.0, true, {
			onComplete: function(tween:FlxTween)
			{
				bossHealth.visible = false;
			}
		});
	}
}
