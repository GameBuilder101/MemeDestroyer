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
	spriteID:String
}

class Entity extends FlxSpriteGroup
{
	/** The entity display name. **/
	public var name(default, null):String;

	/** Used for collision detection. **/
	public var tags(default, null):Array<String> = [];

	public var components(default, null):ComponentSystem;

	public var mainSprite(default, null):AssetSprite;

	public function new(x:Float = 0.0, y:Float = 0.0, data:EntityData = null, id:String = null)
	{
		super(x, y);
		if (data != null)
			load(data);
		else if (id != null)
			load(EntityRegistry.getAsset(id));
	}

	/** Loads all values from the given data. **/
	public function load(data:EntityData)
	{
		name = data.name;
		tags = data.tags;
		components = new ComponentSystem();
		components.loadFrom(data.components, function(path:String):Script
		{
			return GameScriptRegistry.getAsset(path);
		});

		if (mainSprite != null) // In case loading data on an already-loaded entity
		{
			remove(mainSprite);
			mainSprite = null;
		}
		if (data.spriteID != null)
		{
			mainSprite = new AssetSprite(x, y, null, data.spriteID);
			add(mainSprite);
		}

		components.startAll();

		components.setAll("this", this);
		components.setAll("state", cast(FlxG.state, PlayState));
		components.setAll("overlap", overlap);
		if (mainSprite != null)
			components.setAll("animation", mainSprite.animation);
		else
			components.setAll("animation", null);

		if (data.variables != null)
		{
			// The variables array is used to set variables in components
			for (variable in data.variables)
				components.setAll(variable.name, variable.value);
		}
		components.callAll("onLoaded");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		components.callAll("onUpdate", [elapsed]);
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
			FlxG.overlap(mainSprite, entity.mainSprite, function(obj1:Dynamic, obj2:Dynamic)
			{
				components.callAll("onOverlap", [tag, obj2]);
			});
		}
	}
}
