function onInteract(entity:Entity)
{
	if (equipper != null)
		return;
	entity.components.callAll("equip", [this]);
}
