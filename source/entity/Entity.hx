package entity;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import gbc.graphics.AssetSprite;
import gbc.scripting.ComponentSystem;
import gbc.scripting.Script;

typedef EntityData =
{
	name:String,
	tags:Array<String>,
	components:Array<String>,
	variables:Array<Dynamic>,
	spriteID:String,
	hitboxSize:Array<Float>,
	sortingPriority:Int
}

class Entity extends FlxSpriteGroup
{
	/** The ID this entity was created with. Null if created dynamically. **/
	public var id(default, null):String;

	/** The entity display name. **/
	public var name(default, null):String;

	/** Used for collision detection. **/
	public var tags(default, null):Array<String> = [];

	public var components(default, null):ComponentSystem;

	public var mainSprite(default, null):AssetSprite;

	public var sortingPriority:Int;

	public function new(x:Float = 0.0, y:Float = 0.0, data:EntityData = null, id:String = null)
	{
		super(x, y);
		if (data != null)
			load(data);
		else if (id != null)
			loadFromID(id);
	}

	/** Loads all values from the given data. **/
	public function load(data:EntityData)
	{
		name = data.name;
		tags = data.tags;
		components = new ComponentSystem();
		for (path in cast(data.components, Array<Dynamic>))
		{
			components.addNewComponent(path, GameScript, function(path:String):Script
			{
				return GameScriptRegistry.getAsset(path);
			});
		}

		if (mainSprite != null) // In case loading data on an already-loaded entity
		{
			remove(mainSprite);
			mainSprite = null;
		}
		if (data.spriteID != null)
		{
			mainSprite = new AssetSprite(0.0, 0.0, null, data.spriteID);
			add(mainSprite);
		}

		if (data.hitboxSize != null)
		{
			mainSprite.width = data.hitboxSize[0];
			mainSprite.height = data.hitboxSize[1];
		}

		sortingPriority = data.sortingPriority;

		setAll("this", this);
		setAll("state", cast(FlxG.state, PlayState));
		setAll("overlap", overlap);
		if (mainSprite != null)
			setAll("animation", mainSprite.animation);
		else
			setAll("animation", null);

		if (data.variables != null)
		{
			// The variables array is used to set variables in components
			for (variable in data.variables)
				setAll(variable.name, variable.value);
		}

		components.startAll();
		callAll("onLoaded");
	}

	public function loadFromID(id:String)
	{
		this.id = id;
		load(EntityRegistry.getAsset(id));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		callAll("onUpdate", [elapsed]);
	}

	public function getComponent(id:String):Script
	{
		return components.getComponent(id);
	}

	public function setAll(name:String, value:Dynamic)
	{
		components.setAll(name, value);
	}

	public function callAll(name:String, args:Array<Dynamic> = null):Dynamic
	{
		return components.callAll(name, args);
	}

	/** Called when added to PlayState. **/
	public function onAddedToPlay()
	{
		callAll("onAddedToPlay");
	}

	/** Called when removed from PlayState. **/
	public function onRemovedFromPlay()
	{
		callAll("onRemovedFromPlay");
	}

	/** Check for an overlap of this entity with any entities of the given tag. **/
	public function overlap(tag:String)
	{
		if (mainSprite == null)
			return;
		var entities:Array<Entity> = cast(FlxG.state, PlayState).getEntities(tag);
		for (entity in entities)
		{
			if (entity.mainSprite == null) // If the given entity has no main sprite to overlap
				continue;
			FlxG.overlap(mainSprite, entity.mainSprite, function(objectOrGroup1:Dynamic, objectOrGroup2:Dynamic)
			{
				callAll("onOverlap", [tag, entity]);
			});
		}
	}
}
