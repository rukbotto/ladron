package com.rukbottoland.ladron.entities;

import flash.display.Sprite;
import flash.events.Event;

import openfl.Assets;

class Closet extends Sprite
{
    public static inline var WIDTH:Float = 20;
    public static inline var HEIGHT:Float = 40;

    public var hasLoot(get,set):Bool;
    private var _hasLoot:Bool;
    private function get_hasLoot():Bool { return _hasLoot; }
    private function set_hasLoot(value:Bool):Bool { return _hasLoot = value; }

    public function new(x:Float, y:Float)
    {
        super();

        _hasLoot = false;
        this.x = x;
        this.y = y;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        graphics.beginBitmapFill(Assets.getBitmapData("graphics/chest.png"));
        graphics.drawRect(0, 0, Closet.WIDTH, Closet.HEIGHT);
        graphics.endFill();
    }

    public function onEnterFrame(event:Event)
    {
        if (_hasLoot)
        {
            graphics.beginFill(0xff0000);
            graphics.drawRect(0, 0, 5, 5);
            graphics.endFill();
        }
    }
}
