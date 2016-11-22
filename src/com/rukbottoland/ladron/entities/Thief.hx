package com.rukbottoland.ladron.entities;

import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

import com.rukbottoland.ladron.Main;
import com.rukbottoland.ladron.entities.Closet;
import com.rukbottoland.ladron.entities.Lobby;
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

    public var score(get,never):Int;
    private var _score:Int = 60;
    private function get_score():Int { return _score; }

    private var world:Play;
    private var inputs:Dynamic;

    private var timer:Int = 0;
    private var tickBySec:Int = 1000;
    private var elapsed:Int = 0;
    private var lastTimer:Int = 0;

    private var behaviors:Map<String,BehaviorData>;
    private var animation:AnimatedSprite;

    private var lootLabel:TextField;

    private var yInitial:Float;

    private var xAccel:Float = 0;
    private var xSpeed:Float = 0;
    private var xMaxSpeed:Float = 6;
    private var xDrag:Float = 2;
    private var yAccel:Float = 0;
    private var ySpeed:Float = 0;

    private var isGoingLeft:Bool = false;
    private var isGoingRight:Bool = false;
    private var isSneaking:Bool = false;
    private var isSearching:Bool = false;
    private var isJumping:Bool = false;
    private var isAirborne:Bool = false;
    private var isMakingNoise:Bool = false;
    private var hasFoundLoot:Bool = false;

    private var lobby:Lobby = null;
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

    private function onAddedToStage(event:Event)
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

    private function onEnterFrame(event:Event)
    {
        timer = Lib.getTimer();
        elapsed = timer - lastTimer;
        tickBySec -= elapsed;

        input();
        collide();
        animate();
        update();

        if (tickBySec < 0) { tickBySec = 1000; }
        lastTimer = timer;
    }

    private function input()
    {
        if (inputs.left)
        {
            isGoingLeft = true;
            isGoingRight = false;
        }
        else if (inputs.right)
        {
            isGoingLeft = false;
            isGoingRight = true;
        }
        else
        {
            isGoingLeft = false;
            isGoingRight = false;
        }

        if (inputs.sneak) { isSneaking = true; }
        else { isSneaking = false; }

        if (inputs.search) { isSearching = true; }
        else { isSearching = false; }

        if (inputs.up && !isAirborne)
        {
            isJumping = true;
            isAirborne = true;
        }
    }

    private function collide()
    {
        for (i in world.childIdx["ground"])
        {
            if (hitTestObject(world.getChildAt(i)))
                isAirborne = false;
        }

        for (i in world.childIdx["lobby"])
        {
            lobby = cast(world.getChildAt(i), Lobby);
            if (hitTestObject(lobby)) break;
            lobby = null;
        }

        for (i in world.childIdx["room"])
        {
            currentRoom = cast(world.getChildAt(i), Room);
            if (hitTestObject(currentRoom)) break;
            currentRoom = null;
        }

        if (currentRoom != null)
        {
            for (i in currentRoom.childIdx["closet"])
            {
                currentCloset = cast(currentRoom.getChildAt(i), Closet);
                if (hitTestObject(currentCloset)) break;
                currentCloset = null;
            }
        }
    }

    private function animate()
    {
        if (isGoingLeft)
        {
            animation.x = Thief.WIDTH;
            animation.scaleX = -1;
        }
        else if (isGoingRight)
        {
            animation.x = 0;
            animation.scaleX = 1;
        }

        if (isSneaking && isGoingLeft || isSneaking && isGoingRight)
        {
            if (animation.currentBehavior != behaviors["sneak"])
                animation.showBehavior("sneak");
        }
        else if (!isSneaking && isGoingLeft || !isSneaking && isGoingRight)
        {
            if (animation.currentBehavior != behaviors["run"])
                animation.showBehavior("run");
        }
        else if (inputs.search)
            animation.showBehavior("search");
        else
            animation.showBehavior("stand");

        if (isAirborne)
        {
            if (animation.currentBehavior != behaviors["jump"])
                animation.showBehavior("jump");
        }

        animation.update(elapsed);
    }

    private function update()
    {
        if (tickBySec < 0 && _score > 0) { _score -= 1; }

        xAccel = 0;
        yAccel = 15;

        if (isGoingLeft)
            xAccel = -1;
        else if (isGoingRight)
            xAccel = 1;

        if (isSneaking && isGoingLeft || isSneaking && isGoingRight)
        {
            xMaxSpeed = 3;
            isMakingNoise = false;

            if (Math.random() * 100 >= 21 && Math.random() * 100 <= 22)
                isMakingNoise = true;
        }
        else if (!isSneaking && isGoingLeft || !isSneaking && isGoingRight)
        {
            xMaxSpeed = 5;
            isMakingNoise = true;
        }
        else if (isSearching)
        {
            if (currentCloset != null && currentCloset.hasLoot)
            {
                lootLabel.visible = true;
                lootLabel.x = -35;
                lootLabel.y = -20;
                lootLabel.width = 100;
                lootLabel.height = 20;

                hasFoundLoot = true;
            }

            if (lobby != null && hasFoundLoot)
                world.loadNextLevel();
        }
        else
            isMakingNoise = false;

        if (!isAirborne)
        {
            y = yInitial;
            yAccel = 0;
            ySpeed = 0;
        }

        if (isJumping)
        {
            y = yInitial - 1;
            ySpeed = -3.8;
            isMakingNoise = true;
            isJumping = false;
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
    }
}
