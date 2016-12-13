package ladron.worlds;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

import ladron.utils.InputManager;

class GameOver extends Sprite
{
    private var inputManager:InputManager;

    private var messageField1:TextField;
    private var messageField2:TextField;
    private var messageField3:TextField;

    private var points:Int;

    private var isActive:Bool = false;

    public function new(inputManager:InputManager, points:Int)
    {
        super();
        this.inputManager = inputManager;
        this.points = points;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    private function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        var font = Assets.getFont("font/04B_03__.ttf");
        var textFormat = new TextFormat(font.fontName, 32, 0xffffff);
        textFormat.align = TextFormatAlign.CENTER;

        messageField1 = new TextField();
        messageField1.y = stage.stageHeight / 5 * 2;
        messageField1.text = "Game Over";
        messageField1.width = stage.stageWidth;
        messageField1.height = 48;
        messageField1.defaultTextFormat = textFormat;
        addChild(messageField1);

        messageField2 = new TextField();
        messageField2.y = messageField1.y + messageField1.height;
        messageField2.text = "Your score was: " + points;
        messageField2.width = stage.stageWidth;
        messageField2.height = 48;
        messageField2.defaultTextFormat = textFormat;
        addChild(messageField2);

        messageField3 = new TextField();
        messageField3.y = messageField2.y + messageField2.height;
        messageField3.text = "Press space bar to restart the game";
        messageField3.width = stage.stageWidth;
        messageField3.height = 48;
        messageField3.defaultTextFormat = textFormat;
        addChild(messageField3);

        isActive = true;
    }

    private function onRemovedFromStage(event:Event)
    {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);

        removeChild(messageField1);
        removeChild(messageField2);
        removeChild(messageField3);

        inputManager = null;
        messageField1 = null;
        messageField2 = null;
        messageField3 = null;
    }

    private function onEnterFrame(event:Event)
    {
        if (inputManager.inputs.space && isActive)
        {
            Main.resetLevel();
            stage.addChildAt(new Play(Main.level, 0, inputManager), 1);
            stage.removeChild(this);
            isActive = false;
        }
    }
}
