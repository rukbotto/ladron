package com.rukbottoland.ladron.entities;

import openfl.display.Sprite;
import openfl.events.Event;

class Bullet extends Sprite
{
    public static inline var WIDTH:Float = 5;
    public static inline var HEIGHT:Float = 2;

    private var _isGoingLeft:Bool = false;
    public var isGoingLeft(get,set):Bool;
    private function get_isGoingLeft():Bool
    {
        return _isGoingLeft;
    }
    private function set_isGoingLeft(value:Bool):Bool
    {
        return _isGoingLeft = value;
    }

    private var xAccel:Float = 0;
    private var xMaxSpeed:Float = 3;

    public function new(x:Float, y:Float)
    {
        super();
        this.x = x;
        this.y = y;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function destroy()
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        graphics.beginFill(0xffffff);
        graphics.drawRect(0, 0, Bullet.WIDTH, Bullet.HEIGHT);
        graphics.endFill();
    }

    private function onEnterFrame(event:Event)
    {
        if (_isGoingLeft) xAccel = -1;
        else xAccel = 1;

        x += xMaxSpeed * xAccel;
    }
}
