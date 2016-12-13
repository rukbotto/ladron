package com.rukbottoland.ladron.entities;

import openfl.Lib;
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

    private var timer:Float = 0;
    private var lastTimer:Float = 0;
    private var elapsed:Float = 0;
    private var fireCountDown:Float = 1000;

    private var currentOccupant:Occupant = null;
    private var currentBullet:Bullet = null;

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
            "bed" => [],
            "occupant" => [],
            "bullet" => [],
        ];
        this.x = x;
        this.y = y;
        stairUp = false;
        stairDown = false;
        stairFront = false;
        stairBack = false;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
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

    private function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        graphics.beginFill(0x3d3d3d);
        graphics.drawRect(0, 0, Room.WIDTH, Room.HEIGHT);
        graphics.endFill();

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
        var bed = new Bed(bedX, bedY);
        addChild(bed);
        _childByType["bed"].push(bed);

        var occupantX = bedX + 5;
        var occupantY = bedY - Occupant.WIDTH;
        var occupant = new Occupant(occupantX, occupantY);
        addChild(occupant);
        _childByType["occupant"].push(occupant);
    }

    private function onRemovedFromStage(event:Event)
    {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);

        for (object in _childByType["closet"])
        {
            removeChild(object);
            object = null;
        }

        for (object in _childByType["stair"])
        {
            removeChild(object);
            object = null;
        }

        for (object in _childByType["bed"])
        {
            removeChild(object);
            object = null;
        }

        for (object in _childByType["occupant"])
        {
            removeChild(object);
            object = null;
        }

        for (object in _childByType["bullet"])
        {
            removeChild(object);
            object = null;
        }

        _childByType = null;
        currentOccupant = null;
        currentBullet = null;
    }

    private function onEnterFrame(event:Event)
    {
        timer = Lib.getTimer();
        elapsed = timer - lastTimer;
        fireCountDown -= elapsed;

        for (object in _childByType["occupant"])
        {
            if (cast(object, Occupant).isAwake && fireCountDown < 0)
            {
                var bulletX = object.x;
                var bulletY = object.y + Occupant.HEIGHT / 2;
                currentBullet = new Bullet(bulletX, bulletY);
                if (cast(object, Occupant).isFacingLeft)
                    currentBullet.isGoingLeft = true;
                addChild(currentBullet);
                _childByType["bullet"].push(currentBullet);
            }

            if (!cast(object, Occupant).isAwake &&
                    _childByType["bullet"].length > 0)
            {
                for (object in _childByType["bullet"])
                {
                    _childByType["bullet"].remove(object);
                    removeChild(object);
                    object = null;
                }

                currentBullet = null;
            }
        }

        for (object in _childByType["bullet"])
        {
            if (cast(object, Bullet).forDeletion)
            {
                _childByType["bullet"].remove(object);
                removeChild(object);
                object = null;
            }
        }

        if (fireCountDown < 0) fireCountDown = 1000;
        lastTimer = timer;
    }
}
