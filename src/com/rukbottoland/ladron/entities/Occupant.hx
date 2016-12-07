package com.rukbottoland.ladron.entities;

import openfl.Assets;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;

class Occupant extends Sprite
{
    public static inline var WIDTH:Float = 10;
    public static inline var HEIGHT:Float = 30;

    public var childByType(get,never):Map<String,Array<DisplayObject>>;
    private var _childByType:Map<String,Array<DisplayObject>>;
    private function get_childByType():Map<String,Array<DisplayObject>>
    {
        return _childByType;
    }

    private var _isAwake:Bool = false;
    public var isAwake(get,set):Bool;
    private function get_isAwake():Bool
    {
        return _isAwake;
    }
    private function set_isAwake(value:Bool):Bool
    {
        return _isAwake = value;
    }

    private var timer:Float = 0;
    private var lastTimer:Float = 0;
    private var elapsed:Float = 0;
    private var awakeCountDown:Float = 30000;
    private var fireCountDown:Float = 1000;

    private var bitmapData:BitmapData = null;

    private var yInitial:Float;

    private var currentBullet:Bullet = null;

    public function new(x:Float, y:Float)
    {
        super();

        _childByType = [
            "bullet" => [],
        ];
        this.x = x;
        this.y = y;
        yInitial = y;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function destroy()
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);

        for (object in _childByType["bullet"])
        {
            removeChild(object);
            cast(object, Bullet).destroy();
            object = null;
        }

        _childByType = null;
        bitmapData = null;
        currentBullet = null;
    }

    private function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(event:Event)
    {
        timer = Lib.getTimer();
        elapsed = timer - lastTimer;
        awakeCountDown -= elapsed;
        fireCountDown -= elapsed;

        update();
        animate();

        if (awakeCountDown < 0) awakeCountDown = 30000;
        if (fireCountDown < 0) fireCountDown = 1000;
        lastTimer = timer;
    }

    private function update()
    {
        if (awakeCountDown < 0) _isAwake = false;

        if (_isAwake && fireCountDown < 0)
        {
            var bulletX = Occupant.WIDTH / 2;
            var bulletY = Occupant.HEIGHT / 2;
            currentBullet = new Bullet(bulletX, bulletY);
            addChild(currentBullet);
            _childByType["bullet"].push(currentBullet);
        }

        if (!_isAwake && _childByType["bullet"].length > 0)
        {
            for (object in _childByType["bullet"])
            {
                removeChild(object);
                cast(object, Bullet).destroy();
                object = null;
            }

            _childByType["bullet"] = [];
            currentBullet = null;
        }
    }

    private function animate()
    {
        if (_isAwake)
        {
            y = yInitial + Bed.HEIGHT + Occupant.WIDTH - Occupant.HEIGHT;

            bitmapData = Assets.getBitmapData("graphics/occupant_awake.png");
            graphics.clear();
            graphics.beginBitmapFill(bitmapData);
            graphics.drawRect(0, 0, Occupant.WIDTH, Occupant.HEIGHT);
            graphics.endFill();
        }
        else
        {
            y = yInitial;

            bitmapData = Assets.getBitmapData("graphics/occupant_sleeping.png");
            graphics.clear();
            graphics.beginBitmapFill(bitmapData);
            graphics.drawRect(0, 0, Occupant.HEIGHT, Occupant.WIDTH);
            graphics.endFill();
        }
    }
}
