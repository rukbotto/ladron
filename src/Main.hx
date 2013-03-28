import com.haxepunk.Engine;
import com.haxepunk.HXP;
import worlds.Intro;


class Main extends Engine
{

	public static inline var kScreenWidth:Int = 640;
	public static inline var kScreenHeight:Int = 480;
	public static inline var kFrameRate:Int = 30;
	public static inline var kClearColor:Int = 0x3a5c94;
	public static inline var kProjectName:String = "ludumdare25";

    public static var level = 1;

	public function new()
	{
		super(kScreenWidth, kScreenHeight, kFrameRate, false);
	}

	override public function init()
	{
#if debug
	#if flash
		if (flash.system.Capabilities.isDebugger)
	#end
		{
			HXP.console.enable();
		}
#end
		HXP.screen.color = kClearColor;
		HXP.world = new Intro();
	}

	public static function main()
	{
		new Main();
	}

    public static function resetLevel() 
    {
        level = 1;
    }

    public static function increaseLevel() 
    {
        level++;
    }

}
