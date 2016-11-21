package com.rukbottoland.ladron.entities;

import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

import com.rukbottoland.ladron.entities.Closet;
import com.rukbottoland.ladron.entities.Room;
import com.rukbottoland.ladron.utils.Tools;
import com.rukbottoland.ladron.worlds.Play;

import spritesheet.AnimatedSprite;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;

class Thief extends Sprite
{
    public static inline var WIDTH:Float = 10;
    public static inline var HEIGHT:Float = 30;

    private var world:Play;
    private var inputs:Dynamic;

    private var behaviors:Map<String,BehaviorData>;
    private var animation:AnimatedSprite;
    private var timer:Int = 0;
    private var elapsed:Int = 0;
    private var lastTimer:Int = 0;

    private var lootLabel:TextField;

    private var yInitial:Float;

    private var xAccel:Float = 0;
    private var xSpeed:Float = 0;
    private var xMaxSpeed:Float = 6;
    private var xDrag:Float = 2;
    private var yAccel:Float = 0;
    private var ySpeed:Float = 0;

    private var isMakingNoise:Bool = false;
    private var isJumping:Bool = false;

    private var currentRoom:Room = null;
    private var currentCloset:Closet = null;

    public function new(x:Float, y:Float, world:Play)
    {
        super();

        this.world = world;
        inputs = world.inputManager.inputs;
        this.x = x;
        this.y = y;
        yInitial = y;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        behaviors = [
            "run" => new BehaviorData("run", [0, 1, 0], true, 15),
            "sneak" => new BehaviorData("sneak", [0, 2, 0], true, 15),
            "stand" => new BehaviorData("stand", [0], false, 0),
            "jump" => new BehaviorData("jump", [3, 0], true, 15),
            "search" => new BehaviorData("search", [4], false, 0),
        ];

        var bitmapData = Assets.getBitmapData("graphics/thief.png");
        var spritesheet = BitmapImporter.create(bitmapData, 5, 1,
            Std.int(Thief.WIDTH), Std.int(Thief.HEIGHT));
        spritesheet.addBehavior(behaviors["run"]);
        spritesheet.addBehavior(behaviors["sneak"]);
        spritesheet.addBehavior(behaviors["stand"]);
        spritesheet.addBehavior(behaviors["jump"]);
        spritesheet.addBehavior(behaviors["search"]);

        animation = new AnimatedSprite(spritesheet, true);
        animation.showBehavior("stand");

        addChild(animation);

        var font = Assets.getFont("font/04B_03__.ttf");
        var textFormat = new TextFormat(font.fontName, 14, 0xffffff);
        lootLabel = new TextField();
        lootLabel.visible = false;
        lootLabel.text = "Loot Found!";
        lootLabel.width = 0;
        lootLabel.height = 0;
        lootLabel.wordWrap = true;
        lootLabel.defaultTextFormat = textFormat;

        addChild(lootLabel);
    }

    public function onEnterFrame(event:Event)
    {
        timer = Lib.getTimer();
        elapsed = timer - lastTimer;

        xAccel = 0;
        yAccel = 15;

        if (inputs.left)
        {
            animation.x = Thief.WIDTH;
            animation.scaleX = -1;
            xAccel = -1;
        }
        else if (inputs.right)
        {
            animation.x = 0;
            animation.scaleX = 1;
            xAccel = 1;
        }

        if (inputs.sneak && inputs.left || inputs.sneak && inputs.right)
        {
            if (animation.currentBehavior != behaviors["sneak"])
                animation.showBehavior("sneak");

            xMaxSpeed = 3;
            isMakingNoise = false;

            if (Math.random() * 100 >= 21 && Math.random() * 100 <= 22)
                isMakingNoise = true;
        }
        else if (!inputs.sneak && inputs.left || !inputs.sneak && inputs.right)
        {
            if (animation.currentBehavior != behaviors["run"])
                animation.showBehavior("run");

            xMaxSpeed = 5;
            isMakingNoise = true;
        }
        else if (inputs.search)
        {
            animation.showBehavior("search");
            if (currentCloset != null && currentCloset.hasLoot)
            {
                lootLabel.visible = true;
                lootLabel.x = -35;
                lootLabel.y = -20;
                lootLabel.width = 100;
                lootLabel.height = 20;
            }
        }
        else
        {
            animation.showBehavior("stand");
            isMakingNoise = false;
        }

        if (inputs.up && !isJumping)
        {
            y = yInitial - 1;
            ySpeed = -3.8;
            isMakingNoise = true;
            isJumping = true;
        }

        if (isJumping)
        {
            if (animation.currentBehavior != behaviors["jump"])
                animation.showBehavior("jump");
        }

        // Collisions

        for (i in world.childIdx["ground"])
        {
            if (hitTestObject(world.getChildAt(i)))
            {
                y = yInitial;
                yAccel = 0;
                ySpeed = 0;
                isJumping = false;
            }
        }

        currentRoom = null;
        for (i in world.childIdx["room"])
        {
            if (hitTestObject(world.getChildAt(i)))
            {
                currentRoom = cast(world.getChildAt(i), Room);
                break;
            }
        }

        if (currentRoom != null)
        {
            currentCloset = null;
            for (i in currentRoom.childIdx["closet"])
            {
                if (hitTestObject(currentRoom.getChildAt(i)))
                {
                    currentCloset = cast(currentRoom.getChildAt(i), Closet);
                    break;
                }
            }
        }

        xSpeed += xAccel * 3;
        if (Math.abs(xSpeed) > xMaxSpeed)
            xSpeed = xMaxSpeed * Tools.sign(xSpeed);
        if (xSpeed < 0)
            xSpeed = Math.min(xSpeed + xDrag, 0);
        if (xSpeed > 0)
            xSpeed = Math.max(xSpeed - xDrag, 0);
        x += xSpeed;
        world.x -= xSpeed;

        ySpeed += yAccel * (elapsed / 1000);
        y += ySpeed;

        animation.update(elapsed);
        lastTimer = timer;
    }
}
