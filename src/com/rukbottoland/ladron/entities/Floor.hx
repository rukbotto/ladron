package com.rukbottoland.ladron.entities;

import openfl.display.Sprite;
import openfl.events.Event;

class Floor extends Sprite
{
    public static inline var WIDTH:Float = 210;
    public static inline var HEIGHT:Float = 5;

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

        graphics.beginFill(0x000000);
        graphics.drawRect(0, 0, Floor.WIDTH, Floor.HEIGHT);
        graphics.endFill();
    }
}
