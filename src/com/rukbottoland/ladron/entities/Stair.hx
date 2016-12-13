package com.rukbottoland.ladron.entities;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;

class Stair extends Sprite
{
    public static inline var WIDTH:Float = 15;
    public static inline var HEIGHT:Float = 60;

    public var up(get,never):Bool;
    private var _up:Bool;
    private function get_up():Bool
    {
        return _up;
    }

    public function new(x:Float, y:Float, up:Bool = true)
    {
        super();
        this.x = x;
        this.y = y;
        _up = up;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        var bitmapData = null;
        if (_up) bitmapData = Assets.getBitmapData("graphics/stairs_up.png");
        else bitmapData = Assets.getBitmapData("graphics/stairs_down.png");

        graphics.beginBitmapFill(bitmapData);
        graphics.drawRect(0, 0, Stair.WIDTH, Stair.HEIGHT);
        graphics.endFill();
    }
}
