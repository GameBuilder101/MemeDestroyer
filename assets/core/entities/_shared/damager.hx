// Requires variables contactDamage:Float, team:String
function onLoaded()
{
	this.tags.push("damager");
}

function getContactDamage():Float
{
	return contactDamage;
}
