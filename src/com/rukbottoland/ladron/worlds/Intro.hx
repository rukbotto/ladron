package com.rukbottoland.ladron.worlds;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;

import com.rukbottoland.ladron.utils.InputManager;
import com.rukbottoland.ladron.worlds.Play;

class Intro extends Sprite
{
    private var inputManager:InputManager;
    private var isAdded:Bool;

    public function new(inputManager:InputManager)
    {
        super();
        this.inputManager = inputManager;
        isAdded = false;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(KeyboardEvent.KEY_DOWN, inputManager.onKeyDown);
        addEventListener(KeyboardEvent.KEY_UP, inputManager.onKeyUp);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

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
        messageField.width = stage.stageWidth;
        messageField.height = stage.stageHeight;
        messageField.wordWrap = true;
        messageField.defaultTextFormat = textFormat;

        addChild(messageField);
        isAdded = true;
    }

    public function onEnterFrame(event:Event)
    {
        if (inputManager.inputs.space)
        {
            if (isAdded)
            {
                stage.addChild(new Play(1));
                stage.removeChildAt(1);
                isAdded = false;
            }
        }
    }
}
