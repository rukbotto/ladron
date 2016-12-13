package ladron.entities;

import ladron.worlds.Play;

import openfl.Assets;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Point;

class Occupant extends Sprite
{
    public static inline var WIDTH:Float = 10;
    public static inline var HEIGHT:Float = 30;

    private var _isAwake:Bool = false;
    public var isAwake(get,set):Bool;
    private function get_isAwake():Bool
    {
        return _isAwake;
    }
    private function set_isAwake(value:Bool):Bool
    {
        return _isAwake = value;
    }

    private var _isFacingLeft:Bool = false;
    public var isFacingLeft(get,never):Bool;
    private function get_isFacingLeft():Bool
    {
        return _isFacingLeft;
    }

    private var timer:Float = 0;
    private var lastTimer:Float = 0;
    private var elapsed:Float = 0;
    private var awakeCountDown:Float = 30000;

    private var bitmapData:BitmapData = null;

    private var localPos:Point;
    private var globalPos:Point;

    private var xInitial:Float;
    private var yInitial:Float;

    private var world:Play;
    private var currentBullet:Bullet = null;

    public function new(x:Float, y:Float)
    {
        super();

        this.x = x;
        this.y = y;
        xInitial = x;
        yInitial = y;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    private function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        world = cast(parent.parent, Play);
        localPos = new Point(x, y);
        globalPos = parent.localToGlobal(localPos);
    }

    private function onRemovedFromStage(event:Event)
    {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);

        world = null;
        localPos = null;
        globalPos = null;
        bitmapData = null;
        currentBullet = null;
    }

    private function onEnterFrame(event:Event)
    {
        timer = Lib.getTimer();
        elapsed = timer - lastTimer;
        if (_isAwake) awakeCountDown -= elapsed;

        localPos.x = x;
        localPos.y = y;
        globalPos = parent.localToGlobal(localPos);

        update();
        animate();

        if (awakeCountDown < 0) awakeCountDown = 30000;
        lastTimer = timer;
    }

    private function update()
    {
        for (object in world.childByType["thief"])
        {
            if (cast(object, Thief).globalPos.x < globalPos.x)
                _isFacingLeft = true;
            else
                _isFacingLeft = false;
            break;
        }

        if (awakeCountDown < 0) _isAwake = false;
    }

    private function animate()
    {
        if (_isAwake)
        {
            y = yInitial + Bed.HEIGHT + Occupant.WIDTH - Occupant.HEIGHT;

            bitmapData = Assets.getBitmapData("graphics/occupant_awake.png");
            graphics.clear();
            graphics.beginBitmapFill(bitmapData);
            graphics.drawRect(0, 0, Occupant.WIDTH, Occupant.HEIGHT);
            graphics.endFill();
        }
        else
        {
            y = yInitial;

            bitmapData = Assets.getBitmapData("graphics/occupant_sleeping.png");
            graphics.clear();
            graphics.beginBitmapFill(bitmapData);
            graphics.drawRect(0, 0, Occupant.HEIGHT, Occupant.WIDTH);
            graphics.endFill();
        }

        if (_isAwake && _isFacingLeft)
        {
            x = xInitial + Occupant.WIDTH;
            scaleX = -1;
        }
        else
        {
            x = xInitial;
            scaleX = 1;
        }
    }
}
