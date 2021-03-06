package ladron.worlds;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

import ladron.utils.InputManager;
import ladron.worlds.Play;

class Intro extends Sprite
{
    private var inputManager:InputManager;
    private var messageField:TextField;
    private var isActive:Bool = false;

    public function new(inputManager:InputManager)
    {
        super();
        this.inputManager = inputManager;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    private function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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

        var font = Assets.getFont("font/04B_03__.ttf");
        var textFormat = new TextFormat(font.fontName, 32, 0xffffff);
        messageField = new TextField();
        messageField.text = message;
        messageField.width = stage.stageWidth;
        messageField.height = stage.stageHeight;
        messageField.wordWrap = true;
        messageField.defaultTextFormat = textFormat;
        addChild(messageField);

        isActive = true;
    }

    private function onRemovedFromStage(event:Event)
    {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);

        removeChild(messageField);

        inputManager = null;
        messageField = null;
    }

    private function onEnterFrame(event:Event)
    {
        if (inputManager.inputs.space)
        {
            if (isActive)
            {
                stage.addChildAt(new Play(1, 0, inputManager), 1);
                stage.removeChild(this);
                isActive = false;
            }
        }
    }
}
