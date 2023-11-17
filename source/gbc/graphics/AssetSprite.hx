package gbc.graphics;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.display.BlendMode;

typedef AssetSpriteData =
{
	graphic:FlxGraphic,
	animations:Array<AssetSpriteAnimation>,
	defaultAnim:String,
	flipX:Bool,
	flipY:Bool,
	antialiasing:Bool,
	color:FlxColor,
	alpha:Float,
	blend:BlendMode,
	shaderID:String,
	shaderArgs:Dynamic
}

typedef AssetSpriteAnimation =
{
	name:String,
	frames:Array<Array<Int>>,
	indices:Array<Int>,
	frameRate:Int,
	looped:Bool,
	offset:Array<Float>
}

/** An asset-sprite can have visual and animation properties defined
	in a JSON file and loaded at runtime. **/
class AssetSprite extends FlxSprite
{
	/** Used to apply offsets to animations. **/
	public var animOffsets:Map<String, Array<Float>> = new Map<String, Array<Float>>();

	public function new(x:Float = 0.0, y:Float = 0.0, data:AssetSpriteData = null, id:String = null)
	{
		super(x, y);
		if (data != null)
			load(data);
		else if (id != null)
			loadFromID(id);
	}

	/** Loads all values from the given data. **/
	public function load(data:AssetSpriteData)
	{
		// Load the graphic/spritesheet by the data provided in the animation frames
		if (data.animations.length > 0)
			frames = getFramesFromAnimations(data.graphic, data.animations);
		else
			loadGraphic(data.graphic);

		// Remove any existing animations
		for (anim in animation.getAnimationList())
			animation.remove(anim.name);
		animOffsets.clear();
		// Add the animations given the animation data
		for (anim in data.animations)
		{
			if (anim.indices != null && anim.indices.length > 0)
				animation.addByIndices(anim.name, anim.name, anim.indices, "", anim.frameRate, anim.looped);
			else
				animation.addByPrefix(anim.name, anim.name, anim.frameRate, anim.looped);

			if (anim.offset != null)
				animOffsets.set(anim.name, anim.offset);
		}

		// Play the default animation
		if (data.defaultAnim != null)
			animation.play(data.defaultAnim, true);

		flipX = data.flipX;
		flipY = data.flipY;
		antialiasing = data.antialiasing;
		color = data.color;
		alpha = data.alpha;
		blend = data.blend;

		// Set the shader if one was defined
		if (data.shaderID != null)
		{
			var type:ShaderType = ShaderTypeRegistry.getAsset(data.shaderID);
			if (type != null)
				shader = type.create(data.shaderArgs);
		}
	}

	public function loadFromID(id:String)
	{
		load(AssetSpriteRegistry.getAsset(id));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (shader is IUpdateableShader)
			cast(shader, IUpdateableShader).update(elapsed);
	}

	override function updateAnimation(elapsed:Float)
	{
		super.updateAnimation(elapsed);
		if (animation.name == null)
			return;
		if (animOffsets.exists(animation.name))
		{
			var offset:Array<Float> = animOffsets[animation.name];
			this.offset.set(offset[0], offset[1]);
		}
	}

	/** Creates an FlxAtlasFrames from the animations list of an asset sprite. **/
	private static function getFramesFromAnimations(source:FlxGraphicAsset, animations:Array<AssetSpriteAnimation>):FlxAtlasFrames
	{
		var graphic:FlxGraphic = FlxG.bitmap.add(source);
		if (graphic == null)
			return null;

		// No need to parse data again
		var frames = FlxAtlasFrames.findFrame(graphic);
		if (frames != null)
			return frames;
		frames = new FlxAtlasFrames(graphic);

		// Add the frames from the animations
		for (anim in animations)
		{
			for (i in 0...anim.frames.length)
			{
				var rect:FlxRect = FlxRect.get(anim.frames[i][0], anim.frames[i][1], anim.frames[i][2], anim.frames[i][3]);
				frames.addAtlasFrame(rect, new FlxPoint(rect.width, rect.height), new FlxPoint(), anim.name + i, 0);
			}
		}
		return frames;
	}
}
