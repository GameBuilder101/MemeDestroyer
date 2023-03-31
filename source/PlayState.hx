package;

import entity.Entity;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxSort;
import gbc.graphics.AssetSprite;
import level.Level;

class PlayState extends FlxState
{
	public var levelCamera(default, null):FlxCamera;
	public var uiCamera(default, null):FlxCamera;

	/** The currently-loaded level data. **/
	public var level(default, null):LevelData;

	/** The sprite for the level background. **/
	public var background(default, null):AssetSprite;

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

	public var deathOverlay(default, null):NotificationOverlay;

	override function create()
	{
		super.create();
		FlxG.worldBounds.set(0.0, 0.0, FlxG.width, FlxG.height);
		levelCamera = FlxG.camera;
		uiCamera = new FlxCamera();

		// background = new AssetSprite(0.0, 0.0);
		// add(background);

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

		// Add the death overlay
		deathOverlay = new NotificationOverlay(0.0, 0.0, "ui/hud/sprites/death_overlay", "ui/hud/sounds/death_overlay");
		deathOverlay.cameras = [uiCamera, levelCamera];
		deathOverlay.screenCenter();
		add(deathOverlay);

		// Add the player
		player = new Entity(0.0, 0.0, null, PLAYER_ENTITY_ID);
		player.screenCenter();
		addEntity(player);

		addEntity(new Entity(0.0, 0.0, null, "entities/maxwell"));
		addEntity(new Entity(100.0, 100.0, null, "items/nokia"));
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

	public function loadLevel(level:LevelData)
	{
		this.level = level;
		background.loadFromID(level.backgroundSpriteID);
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

	/** Displays the death overlay and re-loads the play state. **/
	public function deathTransition()
	{
		deathOverlay.display();
	}
}
