package gbc.scripting;

/** A basic component system for scripts. **/
class ComponentSystem
{
	public var components:Map<String, Script> = new Map<String, Script>();

	public function new() {}

	function addComponent(id:String, component:Script)
	{
		component.set("getComponent", getComponent);
		component.set("setAll", setAll);
		component.set("callAll", callAll);
		components.set(id, component);
	}

	/**
		@param cl The type of script.
		@param getAsset The function used to retrieve the scripts from a path.
	**/
	public function addNewComponent(path:String, cl:Class<Dynamic>, getAsset:String->Script)
	{
		var id:String = path.substring(path.lastIndexOf("/") + 1, path.length);
		id = id.substring(path.lastIndexOf("\\") + 1, path.length);
		// Create a new, duplicate script from the registry one
		var asset:Script = getAsset(path);
		addComponent(id, Type.createInstance(cl, [asset.script, asset.name]));
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

	/** Calls all functions of the given name and returns the value output
		by the final script (but only if it isn't null).
	**/
	public function callAll(name:String, args:Array<Dynamic> = null):Dynamic
	{
		var result:Dynamic = null;
		var finalResult:Dynamic = null;
		for (component in components)
		{
			result = component.call(name, args);
			if (result != null)
				finalResult = result;
		}
		return finalResult;
	}
}
