package com.rukbottoland.ladron.entities;

import flash.display.Sprite;
import flash.events.Event;

import openfl.Assets;

class Lobby extends Sprite
{
    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        x = 120.0;
        y = stage.stageHeight - 260.0;

        var lobby = Assets.getBitmapData("graphics/lobby.png");
        graphics.beginBitmapFill(lobby, false);
        graphics.drawRect(0.0, 0.0, 60, 60);
        graphics.endFill();
    }
}
