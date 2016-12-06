package com.rukbottoland.ladron.entities;

import openfl.Assets;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;

class Occupant extends Sprite
{
    public static inline var WIDTH:Float = 10;
    public static inline var HEIGHT:Float = 30;

    private var bitmapData:BitmapData;

    private var timer:Float = 0;
    private var lastTimer:Float = 0;
    private var elapsed:Float = 0;
    private var tickDown:Float = 30000;

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

    public function new()
    {
        super();
        this.x = 5;
        this.y = -Occupant.WIDTH;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function destroy()
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        bitmapData = null;
    }

    private function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(event:Event)
    {
        timer = Lib.getTimer();
        elapsed = timer - lastTimer;
        tickDown -= elapsed;

        update();
        animate();

        if (tickDown < 0) tickDown = 30000;
        lastTimer = timer;
    }

    private function update()
    {
        if (tickDown < 0) _isAwake = false;
    }

    private function animate()
    {
        if (_isAwake)
        {
            y = Bed.HEIGHT - Occupant.HEIGHT;

            bitmapData = Assets.getBitmapData("graphics/occupant_awake.png");
            graphics.clear();
            graphics.beginBitmapFill(bitmapData);
            graphics.drawRect(0, 0, Occupant.WIDTH, Occupant.HEIGHT);
            graphics.endFill();
        }
        else
        {
            y = -Occupant.WIDTH;

            bitmapData = Assets.getBitmapData("graphics/occupant_sleeping.png");
            graphics.clear();
            graphics.beginBitmapFill(bitmapData);
            graphics.drawRect(0, 0, Occupant.HEIGHT, Occupant.WIDTH);
            graphics.endFill();
        }
    }
}
