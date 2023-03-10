package gbc.scripting;

/** A basic component system for scripts. **/
class ComponentSystem
{
	public var components:Map<String, Script> = new Map<String, Script>();

	public function new() {}

	function addComponent(id:String, component:Script)
	{
		component.set("comp", getComponent);
		component.set("setAll", setAll);
		component.set("callAll", callAll);
		components.set(id, component);
	}

	/**
		@param getAsset The function used to retrieve the scripts from a path.
	**/
	public function addNewComponent(path:String, getAsset:String->Script)
	{
		var id:String = path.substring(path.lastIndexOf("/") + 1, path.length);
		id = id.substring(path.lastIndexOf("\\") + 1, path.length);
		// Create a new, duplicate script from the registry one
		addComponent(id, Reflect.copy(getAsset(path)));
	}

	public function removeComponent(id:String)
	{
		components.remove(id);
	}

	public function getComponent(id:String)
	{
		return components[id];
	}

	public function startAll()
	{
		for (component in components)
			component.start();
	}

	public function setAll(name:String, value:Dynamic)
	{
		for (component in components)
			component.set(name, value);
	}

	public function callAll(name:String, args:Array<Dynamic> = null)
	{
		for (component in components)
			component.call(name, args);
	}
}
