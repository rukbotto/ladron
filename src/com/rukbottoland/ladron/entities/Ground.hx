package com.rukbottoland.ladron.entities;

import openfl.display.Sprite;
import openfl.events.Event;

class Ground extends Sprite
{
    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        x = -1000;
        y = stage.stageHeight - 200;

        graphics.beginFill(0x3d2920);
        graphics.drawRect(0, 0, stage.stageWidth * 10, 1000);
        graphics.endFill();
    }
}
