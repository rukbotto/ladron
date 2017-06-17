package ladron.entities;

import openfl.display.Sprite;
import openfl.events.Event;

import openfl.Assets;

class Lobby extends Sprite
{
    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        x = 260;
        y = stage.stageHeight - 260;

        var lobby = Assets.getBitmapData("graphics/lobby.png");
        graphics.beginBitmapFill(lobby, false);
        graphics.drawRect(0.0, 0.0, 60, 60);
        graphics.endFill();
    }
}
