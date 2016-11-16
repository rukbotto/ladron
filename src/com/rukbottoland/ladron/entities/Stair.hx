package com.rukbottoland.ladron.entities;

import flash.display.Sprite;
import flash.events.Event;

import openfl.Assets;

class Stair extends Sprite
{
    public static inline var WIDTH:Float = 15;
    public static inline var HEIGHT:Float = 60;

    private var up:Bool;

    public function new(x:Float, y:Float, up:Bool = true)
    {
        super();
        this.x = x;
        this.y = y;
        this.up = up;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        var bitmapData = null;
        if (up)
            bitmapData = Assets.getBitmapData("graphics/stairs_up.png");
        else
            bitmapData = Assets.getBitmapData("graphics/stairs_down.png");

        graphics.beginBitmapFill(bitmapData);
        graphics.drawRect(0, 0, Stair.WIDTH, Stair.HEIGHT);
        graphics.endFill();
    }
}
