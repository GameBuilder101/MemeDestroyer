// Requires variables subtitle:String, titleColor:String
function onLoaded(data:Dynamic)
{
	// Display the title
	state.titleOverlay.display({title: data.name, subtitle: subtitle, color: colorString(titleColor)}, function()
	{
		// Display the fight countdown after the title
		state.countdownOverlay.display(null, function()
		{
			getComponent("round_manager").call("start", [data.bosses]);
		});
	});

	AssetSoundRegistry.getAsset("levels/_shared/sounds/intro").play();
}
