package com.rukbottoland.ladron.entities;

import com.rukbottoland.ladron.worlds.Play;
import com.rukbottoland.ladron.utils.Tools;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;

class Bullet extends Sprite
{
    public static inline var WIDTH:Float = 5;
    public static inline var HEIGHT:Float = 2;

    private var _forDeletion:Bool = false;
    public var forDeletion(get,never):Bool;
    private function get_forDeletion():Bool
    {
        return _forDeletion;
    }

    private var world:Play;

    private var collideWall:Wall = null;
    private var sortedWalls:Array<DisplayObject>;

    private var xMaxSpeed:Float = 3;
    private var distanceA:Float = 0;
    private var distanceB:Float = 0;

    public function new(x:Float, y:Float)
    {
        super();
        this.x = x;
        this.y = y;
        sortedWalls = [];
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function destroy()
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        world = null;
        collideWall = null;
        sortedWalls = null;
    }

    private function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        graphics.beginFill(0xffffff);
        graphics.drawRect(0, 0, Bullet.WIDTH, Bullet.HEIGHT);
        graphics.endFill();

        world = cast(parent.parent.parent, Play);
    }

    private function onEnterFrame(event:Event)
    {
        collide();
        update();
    }

    private function collide()
    {
        sortedWalls = world.childByType["wall"].concat([]);
        sortedWalls.sort(sortWalls);
        for (object in sortedWalls)
        {
            collideWall = null;
            if (hitTestObject(object))
            {
                collideWall = cast(object, Wall);
                break;
            }
        }
    }

    private function sortWalls(a:DisplayObject, b:DisplayObject):Int
    {
        distanceA = Tools.distance(x, y, a.x, a.y);
        distanceB = Tools.distance(x, y, b.x, b.y);
        if (distanceA > distanceB) return 1;
        else if (distanceA < distanceB) return -1;
        else return 0;
    }

    private function update()
    {
        if (collideWall != null) _forDeletion = true;
        x += xMaxSpeed;
    }
}
