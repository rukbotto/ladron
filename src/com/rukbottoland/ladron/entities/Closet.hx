package com.rukbottoland.ladron.entities;

import flash.display.Sprite;
import flash.events.Event;

import openfl.Assets;

class Closet extends Sprite
{
    public static inline var WIDTH:Float = 20;
    public static inline var HEIGHT:Float = 40;

    public function new(x:Float, y:Float)
    {
        super();
        this.x = x;
        this.y = y;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        graphics.beginBitmapFill(Assets.getBitmapData("graphics/chest.png"));
        graphics.drawRect(0, 0, Closet.WIDTH, Closet.HEIGHT);
        graphics.endFill();
    }
}
