package com.rukbottoland.ladron.entities;

import openfl.display.Sprite;
import openfl.events.Event;

class Wall extends Sprite
{
    public static inline var WIDTH:Float = 5;
    public static inline var HEIGHT:Float = 60;

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

        graphics.beginFill(0x8f8f8f);
        graphics.drawRect(0, 0, Wall.WIDTH, Wall.HEIGHT);
        graphics.endFill();
    }
}
