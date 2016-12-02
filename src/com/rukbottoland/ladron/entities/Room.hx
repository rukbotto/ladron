package com.rukbottoland.ladron.entities;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;

import com.rukbottoland.ladron.worlds.Play;

class Room extends Sprite
{
    public static inline var WIDTH:Float = 200;
    public static inline var HEIGHT:Float = 60;

    public var childByType(get,never):Map<String,Array<DisplayObject>>;
    private var _childByType:Map<String,Array<DisplayObject>>;
    private function get_childByType():Map<String,Array<DisplayObject>>
    {
        return _childByType;
    }

    private var stairUp:Bool;
    private var stairDown:Bool;
    private var stairFront:Bool;
    private var stairBack:Bool;

    public function new(x:Float, y:Float)
    {
        super();

        _childByType = [
            "closet" => [],
            "stair" => [],
        ];
        this.x = x;
        this.y = y;
        stairUp = false;
        stairDown = false;
        stairFront = false;
        stairBack = false;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        graphics.beginFill(0x3d3d3d);
        graphics.drawRect(0, 0, Room.WIDTH, Room.HEIGHT);
        graphics.endFill();

        setup();
    }

    private function setup()
    {
        var stair = null;
        if (stairUp && stairBack)
        {
            stair = new Stair(Room.WIDTH - Stair.WIDTH, 0);
            addChild(stair);
            _childByType["stair"].push(stair);
        }

        if (stairUp && stairFront)
        {
            stair = new Stair(0, 0);
            addChild(stair);
            _childByType["stair"].push(stair);
        }

        if (stairDown && stairBack)
        {
            stair = new Stair(Room.WIDTH - Stair.WIDTH, 0, false);
            addChild(stair);
            _childByType["stair"].push(stair);
        }

        if (stairDown && stairFront)
        {
            stair = new Stair(0, 0, false);
            addChild(stair);
            _childByType["stair"].push(stair);
        }

        var closetX = Math.random() * (Room.WIDTH - Closet.WIDTH);
        var closetY = Room.HEIGHT - Closet.HEIGHT;
        var closet = new Closet(closetX, closetY);
        addChild(closet);
        _childByType["closet"].push(closet);

        var bedX = Math.random() * (Room.WIDTH - Bed.WIDTH);
        var bedY = Room.HEIGHT - Bed.HEIGHT;
        addChild(new Bed(bedX, bedY));
    }

    public function setStairUpFront()
    {
        stairUp = true;
        stairDown = false;
        stairFront = true;
        stairBack = false;
    }

    public function setStairDownFront()
    {
        stairUp = false;
        stairDown = true;
        stairFront = true;
        stairBack = false;
    }

    public function setStairUpBack()
    {
        stairUp = true;
        stairDown = false;
        stairFront = false;
        stairBack = true;
    }

    public function setStairDownBack()
    {
        stairUp = false;
        stairDown = true;
        stairFront = false;
        stairBack = true;
    }
}
