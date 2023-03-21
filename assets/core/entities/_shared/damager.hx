// Requires variables contactDamage:Float
function onLoaded()
{
	this.tags.push("damager");
}

function getContactDamage():Float
{
	return contactDamage;
}
