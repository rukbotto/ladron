package com.rukbottoland.ladron;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

import com.rukbottoland.ladron.worlds.Intro;

class Main extends Sprite
{
    public static var level = 1;

    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addChild(new Intro());
    }

    public static function main()
    {
        Lib.current.addChild(new Main());
    }

    public static function resetLevel()
    {
        level = 1;
    }

    public static function increaseLevel()
    {
        level++;
    }
}
