package com.rukbottoland.ladron.worlds;

import flash.display.Sprite;
import flash.events.Event;

import openfl.Assets;

class Play extends Sprite
{
    private var difficulty:Int;

    public function new(difficulty:Int)
    {
        super();
        this.difficulty = difficulty;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        var background = Assets.getBitmapData("graphics/background.png");
        graphics.beginBitmapFill(background, false);
        graphics.drawRect(0.0, 0.0, stage.stageWidth, stage.stageHeight-200);
        graphics.endFill();

        graphics.beginFill(0xFFFFFF);
        graphics.drawCircle(200, 200, 40);
        graphics.endFill();
    }
}
