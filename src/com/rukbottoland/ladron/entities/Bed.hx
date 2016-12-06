package com.rukbottoland.ladron.entities;

import openfl.Assets;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;

class Bed extends Sprite
{
    public static inline var WIDTH:Float = 40;
    public static inline var HEIGHT:Float = 7;

    private var _childByType:Map<String,Array<DisplayObject>>;
    public var childByType(get,never):Map<String,Array<DisplayObject>>;
    private function get_childByType():Map<String,Array<DisplayObject>>
    {
        return _childByType;
    }

    public function new(x:Float, y:Float)
    {
        super();

        _childByType = [
            "occupant" => [],
        ];
        this.x = x;
        this.y = y;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function destroy()
    {
        for (object in _childByType["occupant"])
        {
            removeChild(object);
            cast(object, Occupant).destroy();
            object = null;
        }

        _childByType = null;
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        graphics.beginBitmapFill(Assets.getBitmapData("graphics/bed.png"));
        graphics.drawRect(0, 0, Bed.WIDTH, Bed.HEIGHT);
        graphics.endFill();

        var occupant = new Occupant();
        addChild(occupant);
        _childByType["occupant"].push(occupant);
    }
}
