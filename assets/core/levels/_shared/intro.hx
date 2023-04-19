// Requires variables title:String, subtitle:String, titleColor:String
function onLoaded()
{
	// Display the title
	state.titleOverlay.display({
		title: title,
		subtitle: subtitle,
		color: colorString(titleColor),
		style: "slow"
	}, function()
	{
		// Display the fight countdown after the title
		state.countdownOverlay.display(null, function()
		{
			getComponent("round_manager").call("start");
		});
	});

	AssetSoundRegistry.getAsset("levels/_shared/sounds/intro").play();
}
