package gbc.scripting;

/** A basic component system for scripts. **/
class ComponentSystem
{
	public var components:Map<String, Script> = new Map<String, Script>();

	public function new(components:Map<String, Script> = null)
	{
		if (components != null)
		{
			for (element in components.keyValueIterator())
				addComponent(element.key, element.value);
		}
	}

	public function addComponent(id:String, component:Script)
	{
		component.set("comp", getComponent);
		component.set("setAll", setAll);
		component.set("callAll", callAll);
		components.set(id, component);
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

	/** Use to load from JSON data.
		@param getAsset The function used to retrieve the scripts from a path.
	**/
	public function loadFrom(data:Dynamic, getAsset:String->Script)
	{
		if (data == null)
			return;
		var path:String;
		var id:String;
		for (assetID in cast(data, Array<Dynamic>))
		{
			path = assetID;
			id = path.substring(path.lastIndexOf("/") + 1, path.length);
			id = id.substring(path.lastIndexOf("\\") + 1, path.length);
			// Create a new, duplicate script from the registry one
			addComponent(id, Reflect.copy(getAsset(path)));
		}
	}
}
