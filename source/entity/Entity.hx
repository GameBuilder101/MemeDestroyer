package entity;

import flixel.group.FlxSpriteGroup;
import gbc.graphics.AssetSprite;
import gbc.scripting.ComponentSystem;
import gbc.scripting.Script;

typedef EntityData =
{
	name:String,
	components:Array<String>,
	variables:Array<Dynamic>,
	spriteID:String
}

class Entity extends FlxSpriteGroup
{
	/** The entity display name. **/
	public var name(default, null):String;

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
}
