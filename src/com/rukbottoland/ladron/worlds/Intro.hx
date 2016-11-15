package com.rukbottoland.ladron.worlds;

import flash.display.Sprite;
import flash.events.Event;

import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Intro extends Sprite
{
    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        var message:String =
            "LADRON!\n\n" +
            "Your goal is to steal the loot!\n\n" +
            "Beware of the sleeping occupants, they will shot you if they hear you!\n\n" +
            "Keys:\n\n" +
            "<S> for sneaking, <X> to search the loot inside the closets, " +
            "<UP> to go upstairs or jump, <DOWN> to go downstairs, " +
            "<LEFT/RIGHT> to run.\n\n" +
            "If you found the loot, go to the pagoda and press <X> to advance the next level.\n\n" +
            "Press space bar to start the game!";

        var textFormat = new TextFormat("Arial", 24, 0xFFFFFF);

        var messageField = new TextField();
        messageField.text = message;
        messageField.width = 640;
        messageField.height = 500;
        messageField.wordWrap = true;
        messageField.defaultTextFormat = textFormat;

        addChild(messageField);
    }
}
