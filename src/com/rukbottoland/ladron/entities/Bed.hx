package com.rukbottoland.ladron.entities;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;

class Bed extends Sprite
{
    public static inline var WIDTH:Float = 40;
    public static inline var HEIGHT:Float = 7;

    private var occupant:Occupant;

    public function new(x:Float, y:Float)
    {
        super();
        this.x = x;
        this.y = y;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function destroy()
    {
        removeChild(occupant);
        occupant = null;
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        graphics.beginBitmapFill(Assets.getBitmapData("graphics/bed.png"));
        graphics.drawRect(0, 0, Bed.WIDTH, Bed.HEIGHT);
        graphics.endFill();

        occupant = new Occupant(5, -Bed.HEIGHT);
        addChild(occupant);
    }
}
