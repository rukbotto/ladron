package entities;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import entities.Character;
import entities.Bullet;
import utils.Constants;
import utils.Tools;
import worlds.Play;


class Occupant extends Character
{

    private static inline var xDrag:Float = 0.4;
    private var isAwake:Bool;
    private var clock:Float;
    private var shootToRight:Bool;
    private var etaAwake:Float;
    private var sprite:Spritemap;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        setHitbox(Constants.playerHeight, Constants.playerWidth);
        this.isAwake = false;
        type = "occupant";

        clock = 0;
        etaAwake = 0;
        shootToRight = true;

        graphic = new Image("graphics/occupant_sleeping.png");
    }

    public function awake()
    {
        if (!isAwake)
        {
            var auxWidth = this.width;
            this.width = this.height;
            this.height = auxWidth;
            sprite = new Spritemap("graphics/occupant_awake.png", 10, 30);
            sprite.add("awake", [0]);
            sprite.play("awake");
            graphic = sprite;
            setHitbox(width, height);
            this.y -= 13;
            this.isAwake = true;
            if (!shootToRight)
            {
                sprite.flipped = true;
            }
            else
            {
                sprite.flipped = false;
            }
        }
    }

    public function sleep() 
    {
        if (isAwake)
        {
            var auxWidth = this.width;
            this.width = this.height;
            this.height = auxWidth;
            graphic = new Image("graphics/occupant_sleeping.png");
            setHitbox(width, height);
            this.y += 13;
            this.isAwake = false;
            this.etaAwake = 0;
        }
    }

    public function goToBed() 
    {
        for (thief in Tools.filterEntities(["thief"], Play.entities))
        {
            if (distanceFrom(thief) > 60 && etaAwake > 30)
            {
                sleep();
            }
        }
    }

    public function shootDirection(shootToRight:Bool) 
    {
        this.shootToRight = shootToRight;
        if (!shootToRight && isAwake)
        {
            sprite.flipped = true;
        }
        else if (shootToRight && isAwake)
        {
            sprite.flipped = false;
        }
    }

    public override function update() 
    {
        clock += (1 / HXP.frameRate);

        if (clock >= 1 && isAwake)
        {
            world.add(new Bullet(x, y + 15, shootToRight));
            clock = 0;
        }
        if (isAwake)
        {
            etaAwake += (1 / HXP.frameRate);
            goToBed();
        }
    }

}
