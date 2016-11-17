package com.rukbottoland.ladron.entities;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;

import spritesheet.AnimatedSprite;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;

class Thief extends Sprite
{
    public static inline var WIDTH:Float = 10;
    public static inline var HEIGHT:Float = 30;

    private var animation:AnimatedSprite;
    private var lastTime:Int = 0;

    public function new(x:Float, y:Float)
    {
        super();
        this.x = x;
        this.y = y;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        var run = new BehaviorData("run", [0, 1, 0], false, 15);
        var sneak = new BehaviorData("sneak", [0, 2, 0], false, 15);
        var stand = new BehaviorData("stand", [0], false, 0);
        var jump = new BehaviorData("jump", [3, 0], false, 15);
        var search = new BehaviorData("search", [4], false, 0);

        var bitmapData = Assets.getBitmapData("graphics/thief.png");
        var spritesheet = BitmapImporter.create(bitmapData, 5, 1,
            Std.int(Thief.WIDTH), Std.int(Thief.HEIGHT));
        spritesheet.addBehavior(run);
        spritesheet.addBehavior(sneak);
        spritesheet.addBehavior(stand);
        spritesheet.addBehavior(jump);
        spritesheet.addBehavior(search);

        animation = new AnimatedSprite(spritesheet, true);
        animation.showBehavior("stand");

        addChild(animation);
    }

    public function onEnterFrame(event:Event)
    {
        var time = Lib.getTimer();
        var delta = time - lastTime;
        animation.update(delta);
        lastTime = time;
    }
}
