package com.rukbottoland.ladron.entities;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;

class Occupant extends Sprite
{
    public static inline var WIDTH:Float = 30;
    public static inline var HEIGHT:Float = 10;

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

        var bitmapData = Assets.getBitmapData("graphics/occupant_sleeping.png");
        graphics.beginBitmapFill(bitmapData);
        graphics.drawRect(0, 0, Occupant.WIDTH, Occupant.HEIGHT);
        graphics.endFill();
    }
}
