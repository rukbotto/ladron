package com.rukbottoland.ladron.entities;

import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;

import com.rukbottoland.ladron.Main;
import com.rukbottoland.ladron.entities.Closet;
import com.rukbottoland.ladron.entities.Lobby;
import com.rukbottoland.ladron.entities.Room;
import com.rukbottoland.ladron.entities.Wall;
import com.rukbottoland.ladron.utils.Score;
import com.rukbottoland.ladron.utils.Tools;
import com.rukbottoland.ladron.worlds.Play;

import spritesheet.AnimatedSprite;
import spritesheet.data.BehaviorData;
import spritesheet.importers.BitmapImporter;

class Thief extends Sprite
{
    public static inline var WIDTH:Float = 10;
    public static inline var HEIGHT:Float = 30;

    public var health(get,never):Int;
    private var _health:Int = 8;
    private function get_health():Int { return _health; }

    public var time(get,never):Int;
    private var _time:Int = 0;
    private function get_time():Int { return _time; }

    public var hasFoundLoot(get,never):Bool;
    private var _hasFoundLoot:Bool = false;
    private function get_hasFoundLoot():Bool { return _hasFoundLoot; }

    private var world:Play;
    private var inputs:Dynamic;
    private var score:Score;

    private var timer:Int = 0;
    private var elapsed:Int = 0;
    private var lastTimer:Int = 0;
    private var tickDown:Int = 1000;

    private var behaviors:Map<String,BehaviorData>;
    private var animation:AnimatedSprite;

    private var xInitial:Float;
    private var yInitial:Float;

    private var xAccel:Float = 0;
    private var xSpeed:Float = 0;
    private var xMaxSpeed:Float = 6;
    private var xDrag:Float = 2;
    private var yAccel:Float = 0;
    private var ySpeed:Float = 0;

    private var collideGround:Ground = null;
    private var collideFloor:Floor = null;
    private var collideLobby:Lobby = null;
    private var collideWall:Wall = null;
    private var collideRoom:Room = null;
    private var collideCloset:Closet = null;
    private var collideStair:Stair = null;

    private var isGoingLeft:Bool = false;
    private var isGoingRight:Bool = false;
    private var isSneaking:Bool = false;
    private var isSearching:Bool = false;
    private var isJumping:Bool = false;
    private var isCrouching:Bool = false;
    private var isAirborne:Bool = false;
    private var isMakingNoise:Bool = false;
    private var isBlockedLeft:Bool = false;
    private var isBlockedRight:Bool = false;

    public function new(x:Float, y:Float, world:Play)
    {
        super();

        this.world = world;
        inputs = world.inputManager.inputs;
        score = world.score;
        this.x = x;
        this.y = y;
        xInitial = x;
        yInitial = y;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function destroy()
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);

        removeChild(animation);

        world = null;
        inputs = null;
        score = null;
        behaviors = null;
        animation = null;

        collideGround = null;
        collideFloor = null;
        collideLobby = null;
        collideWall = null;
        collideRoom = null;
        collideCloset = null;
        collideStair = null;
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
    }

    private function onEnterFrame(event:Event)
    {
        timer = Lib.getTimer();
        elapsed = timer - lastTimer;
        tickDown -= elapsed;

        input();
        collide();
        update();
        animate();

        if (tickDown < 0) { tickDown = 1000; }
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

        if (inputs.sneak) isSneaking = true;
        else isSneaking = false;

        if (inputs.search) isSearching = true;
        else isSearching = false;

        if (inputs.up && !isAirborne)
        {
            isJumping = true;
            isAirborne = true;
        }

        if (inputs.down && !isCrouching) isCrouching = true;
    }

    private function collide()
    {
        for (object in world.childByType["ground"])
        {
            collideGround = cast(object, Ground);
            if (hitTestObject(collideGround)) break;
            collideGround = null;
        }

        for (object in world.childByType["floor"])
        {
            collideFloor = cast(object, Floor);
            if (hitTestObject(object)) break;
            collideFloor = null;
        }

        for (object in world.childByType["lobby"])
        {
            collideLobby = cast(object, Lobby);
            if (hitTestObject(collideLobby)) break;
            collideLobby = null;
        }

        for (object in world.childByType["wall"])
        {
            collideWall = cast(object, Wall);
            if (hitTestObject(collideWall) && !collideWall.passThrough) break;
            collideWall = null;
        }

        for (object in world.childByType["room"])
        {
            collideRoom = cast(object, Room);
            if (hitTestObject(collideRoom)) break;
            collideRoom = null;
        }

        if (collideRoom != null)
        {
            for (object in collideRoom.childByType["closet"])
            {
                collideCloset = cast(object, Closet);
                if (hitTestObject(collideCloset)) break;
                collideCloset = null;
            }

            for (object in collideRoom.childByType["stair"])
            {
                collideStair = cast(object, Stair);
                if (hitTestObject(collideStair)) break;
                collideStair = null;
            }
        }
    }

    private function update()
    {
        if (tickDown < 0)
        {
            _time += 1;
            if (score.points > 0) score.points -= 1;
        }

        if (collideGround != null || collideFloor != null) isAirborne = false;

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
            if (collideCloset != null && collideCloset.hasLoot && !_hasFoundLoot)
            {
                score.points += 1000;
                _hasFoundLoot = true;
            }

            if (collideLobby != null)
            {
                if (_hasFoundLoot)
                {
                    world.loadNextLevel();
                    return;
                }
                else score.points -= 100;
            }
        }
        else
            isMakingNoise = false;

        if (collideWall != null && !collideWall.passThrough)
        {
            if (isBlockedRight && isGoingLeft)
            {
                isBlockedRight = false;
                x = collideWall.x - Thief.WIDTH - 1;
            }
            else if (isBlockedLeft && isGoingRight)
            {
                isBlockedLeft = false;
                x = collideWall.x + Wall.WIDTH + 1;
            }

            if (xSpeed < 0)
            {
                isBlockedLeft = true;
                isBlockedRight = false;
                x = collideWall.x + Wall.WIDTH - 1;
            }
            else if (xSpeed > 0)
            {
                isBlockedLeft = false;
                isBlockedRight = true;
                x = collideWall.x - Thief.WIDTH + 1;
            }

            xAccel = 0;
            world.x = -x + xInitial;
        }

        if (!isAirborne)
        {
            y = yInitial;
            yAccel = 0;
            ySpeed = 0;
        }

        if (isJumping)
        {
            if (collideStair != null && collideStair.up)
            {
                y -= (collideRoom.height + Floor.HEIGHT);
                yInitial = y;
                isMakingNoise = false;
            }
            else
            {
                y = yInitial - 1;
                ySpeed = -3.8;
                isMakingNoise = true;
            }

            isJumping = false;
        }
        else if (isCrouching)
        {
            if (collideStair != null && !collideStair.up)
            {
                y += (collideRoom.height + Floor.HEIGHT);
                yInitial = y;
                isMakingNoise = false;
            }

            isCrouching = false;
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

    private function animate()
    {
        if (inputs == null || behaviors == null || animation == null) return;

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
}
