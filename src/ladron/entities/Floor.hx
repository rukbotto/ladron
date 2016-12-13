package ladron.entities;

import openfl.display.Sprite;
import openfl.events.Event;

class Floor extends Sprite
{
    public static inline var HEIGHT:Float = 5;

    private var _width:Float;

    public function new(x:Float, y:Float, width:Float)
    {
        super();

        this.x = x;
        this.y = y;
        _width = width;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        graphics.beginFill(0x000000);
        graphics.drawRect(0, 0, _width, Floor.HEIGHT);
        graphics.endFill();
    }
}
