package ui;

/** Interface for things such as title overlays. **/
interface IOverlay
{
	public function display(args:Dynamic, onComplete:Void->Void):Void;
}
