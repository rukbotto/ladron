package com.rukbottoland.ladron.entities;

import flash.display.Sprite;
import flash.events.Event;

class Room extends Sprite
{
    public static inline var WIDTH:Float = 200;
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

        graphics.beginFill(0x3d3d3d);
        graphics.drawRect(0, 0, Room.WIDTH, Room.HEIGHT);
        graphics.endFill();

        setup();
    }

    private function setup()
    {
        var closetX = Math.random() * (Room.WIDTH - Closet.WIDTH);
        var closetY = Room.HEIGHT - Closet.HEIGHT;
        addChild(new Closet(closetX, closetY));

        var bedX = Math.random() * (Room.WIDTH - Bed.WIDTH);
        var bedY = Room.HEIGHT - Bed.HEIGHT;
        addChild(new Bed(bedX, bedY));
    }
}
