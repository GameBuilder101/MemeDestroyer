package ui;

/** A slider that actively modifies the global volume setting. **/
class GlobalVolumeSlider extends StandardSlider
{
	public function new(x:Float = 0.0, y:Float = 0.0)
	{
		super(x, y, "ui/_shared/sprites/volume_icon");
		value = Settings.instance.getGlobalVolume();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (usingHandle)
			Settings.instance.setGlobalVolume(value);
	}

	override function onHandleUp()
	{
		super.onHandleUp();
		Settings.instance.save();
	}
}
