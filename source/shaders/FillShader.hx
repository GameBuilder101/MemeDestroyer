package shaders;

import flixel.system.FlxAssets.FlxShader;

/** A shader for use in filling bars/meters. **/
class FillShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform int direction;

        uniform float progress;
		
		void main()
		{
			vec4 base = flixel_texture2D(bitmap, openfl_TextureCoordv);
			if (direction == 0 && openfl_TextureCoordv.y < progress)
				base = vec4(0.0);
			else if (direction == 1 && openfl_TextureCoordv.y > progress)
				base = vec4(0.0);
			else if (direction == 2 && openfl_TextureCoordv.x < progress)
				base = vec4(0.0);
			else if (direction == 3 && openfl_TextureCoordv.x > progress)
				base = vec4(0.0);
			gl_FragColor = base;
		}')
	public function new(args:Dynamic)
	{
		super();
		direction.value = [args.direction];
		progress.value = [0.5];
	}

	public function setProgress(value:Float)
	{
		progress.value[0] = value;
	}
}
