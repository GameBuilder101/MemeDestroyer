package shaders;

import flixel.system.FlxAssets.FlxShader;

/** A shader for use in filling bars/meters. **/
class FillShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform int direction;
		const int DIRECTION_UP = 0;
		const int DIRECTION_DOWN = 1;
		const int DIRECTION_LEFT = 2;
        const int DIRECTION_RIGHT = 3;

        uniform float progress;
		
		void main()
		{
			vec4 base = flixel_texture2D(bitmap, openfl_TextureCoordv);
			if (direction == DIRECTION_UP && openfl_TextureCoordv.y < progress)
				base.xyzw = 0.0;
			else if (direction == DIRECTION_DOWN && openfl_TextureCoordv.y > progress)
				base.xyzw = 0.0;
			else if (direction == DIRECTION_LEFT && openfl_TextureCoordv.x < progress)
				base.xyzw = 0.0;
			else if (direction == DIRECTION_RIGHT && openfl_TextureCoordv.x > progress)
				base.xyzw = 0.0;
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
