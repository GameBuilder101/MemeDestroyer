package;

import flixel.FlxG;
import gbc.Saver;
import gbc.input.OverridableAction;

using StringTools;

/** Allows for an edit-able control scheme system. **/
class Controls extends Saver<Array<Dynamic>>
{
	static inline final DEFAULT_SAVE_PATH:String = "controls";

	public static var instance:Controls = new Controls();

	public static var moveUp(default, null):OverridableAction;
	public static var moveDown(default, null):OverridableAction;
	public static var moveLeft(default, null):OverridableAction;
	public static var moveRight(default, null):OverridableAction;

	public static var fire(default, null):OverridableAction;
	public static var dodge(default, null):OverridableAction;
	public static var interact(default, null):OverridableAction;
	public static var equip(default, null):OverridableAction;

	static var actions:Array<OverridableAction>;

	function new()
	{
		actions = [];

		moveUp = new OverridableAction("moveUp", "Move Up", PRESSED, 2, [UP, W], [LEFT_STICK_DIGITAL_UP, NONE]);
		actions.push(moveUp);
		moveDown = new OverridableAction("moveDown", "Move Down", PRESSED, 2, [DOWN, S], [LEFT_STICK_DIGITAL_DOWN, NONE]);
		actions.push(moveDown);
		moveLeft = new OverridableAction("moveLeft", "Move Left", PRESSED, 2, [LEFT, A], [LEFT_STICK_DIGITAL_LEFT, NONE]);
		actions.push(moveLeft);
		moveRight = new OverridableAction("moveRight", "Move Right", PRESSED, 2, [RIGHT, D], [LEFT_STICK_DIGITAL_RIGHT, NONE]);
		actions.push(moveRight);

		fire = new OverridableAction("fire", "Fire", PRESSED, 1, [R], [RIGHT_TRIGGER]);
		actions.push(fire);
		dodge = new OverridableAction("dodge", "Dodge", JUST_PRESSED, 1, [SPACE], [A]);
		actions.push(dodge);
		interact = new OverridableAction("interact", "Interact", JUST_PRESSED, 1, [E], [B]);
		actions.push(interact);
		equip = new OverridableAction("equip", "Equip", JUST_PRESSED, 1, [F], [DPAD_RIGHT]);
		actions.push(equip);

		super();
	}

	function getSaverMethod():SaverMethod
	{
		return JSON;
	}

	function getDefaultData():Array<Dynamic>
	{
		var data:Array<Dynamic> = [];
		for (action in actions)
			data.push(null);
		return data;
	}

	override function save(path:String = null)
	{
		if (path == null || path == "")
			path = DEFAULT_SAVE_PATH;

		for (i in 0...actions.length)
			data[i] = actions[i].toSave();
		super.save(path);
	}

	override function load(path:String = null)
	{
		if (path == null || path == "")
			path = DEFAULT_SAVE_PATH;

		super.load(path);
		for (i in 0...actions.length)
			actions[i].loadSave(data[i]);
	}

	/** Also checks for mouse input. **/
	public static function checkFire():Bool
	{
		return fire.check() || FlxG.mouse.pressed;
	}
}
