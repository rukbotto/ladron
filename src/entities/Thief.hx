package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import entities.Character;
import entities.Occupant;
import utils.Constants;
import utils.Score;
import utils.Tools;
import worlds.Play;
import Main;


class Thief extends Character 
{

    private static inline var xDrag:Float = 2;

    private var isMakingNoise:Bool;
    private var lootFound = false;
    private var text:Entity;
    private var lifeText:Entity;
    private var timeText:Entity;
    private var pointsText:Entity;
    private var lifes:Float;
    private var timer:Float;
    private var sprite:Spritemap;

    public function new(x:Float, y:Float) 
    {
        super(x, y);
        setHitbox(Constants.playerWidth, Constants.playerHeight);
        type = "thief";

        canJump = true;
        isMakingNoise = false;
        xSpeed = 0;
        xMaxSpeed = 6;
        yAccel = 15;
        ySpeed = 1;
        text = null;
        lifes = 8;
        lifeText = null;
        timeText = null;
        pointsText = null;
        timer = 0;

        sprite = new Spritemap("gfx/thief.png", 10, 30);
        sprite.add("run", [0, 1, 0], 15);
        sprite.add("sneak", [0, 2, 0], 15);
        sprite.add("stand", [0]);
        sprite.add("jump", [3, 0], HXP.elapsed);
        sprite.add("search", [4]);
        sprite.play("stand");

        graphic = sprite;

        Input.define("up", [Key.UP]);
        Input.define("left", [Key.LEFT]);
        Input.define("right", [Key.RIGHT]);
        Input.define("down", [Key.DOWN]);
        Input.define("sneak", [Key.S]);
        Input.define("action", [Key.X]);
    }

    private function makeNoise() 
    {
        awakeClosestOccupant();
        isMakingNoise = true;
    }

    private function beQuiet() 
    {
        isMakingNoise = false;
    }

    private override function moveX() 
    {
        xAccel = 0;

        sneak();
        stand();
        run();

        if (Input.check("left"))
        {
            xAccel = -1;
            sprite.flipped = true;
        }

        if (Input.check("right"))
        {
            xAccel = 1;
            sprite.flipped = false;
        }

        xSpeed += xAccel * 3;

        if (Math.abs(xSpeed) > xMaxSpeed)
        {
            xSpeed = xMaxSpeed * HXP.sign(xSpeed);
        }

        if (xSpeed < 0)
        {
            xSpeed = Math.min(xSpeed + xDrag, 0);
        }

        if (xSpeed > 0)
        {
            xSpeed = Math.max(xSpeed - xDrag, 0);
        }

        moveBy(xSpeed, 0, ["wall", "floor", "boundary"]);
        HXP.setCamera(xSpeed + HXP.camera.x, 0);
    }

    private override function moveY() 
    {
        ySpeed = ySpeed - (yAccel * HXP.elapsed);

        jump();
        goUpStairs();
        goDownStairs();

        moveBy(0, -ySpeed, ["ground", "floor"]);
    }

    private override function goUpStairs() 
    {
        var collideEntity: Entity;

        if ((collideEntity = collide("stairUp", x, y)) != null)
        {
            beQuiet();
            if (Input.check("up"))
            {
                this.y = collideEntity.y - Constants.playerHeight - Constants.floorHeight;
            }
        }
    }

    private override function goDownStairs() 
    {
        var collideEntity: Entity;

        if ((collideEntity = collide("stairDown", x, y)) != null)
        {
            beQuiet();
            if (Input.check("down"))
            {
                this.y = collideEntity.y + Constants.roomHeight + 
                        Constants.floorHeight + 
                        (Constants.roomHeight - Constants.playerHeight);
            }
        }
    }

    private override function sneak() 
    {
        if (Input.check("sneak") && !Input.check("up") && !Input.check("down") && 
                (Input.check("left") || Input.check("right")))
        {
            sprite.play("sneak");
            xMaxSpeed = 3;
            beQuiet();
            generateRandomNoise();
        }

        if (Input.check("sneak") && !Input.check("up") && !Input.check("down") && 
                !Input.check("left") && !Input.check("right"))
        {
            sprite.play("stand");
        }
    }

    private override function jump() 
    {
        if (Input.check("up") && canJump)
        {
            sprite.play("jump");
            ySpeed = 4.8;
            makeNoise();
            canJump = false;
        }
    }

    private override function stand() 
    {
        if (!Input.check("sneak") && !Input.check("up") && 
                !Input.check("down") && !Input.check("left") && 
                !Input.check("right"))
        {
            sprite.play("stand");
            beQuiet();
        }
    }

    private override function run() 
    {
        if (!Input.check("sneak") && 
                (Input.check("left") || Input.check("right")))
        {
            sprite.play("run");
            xMaxSpeed = 5;
            makeNoise();
        }
        if (Input.check("up"))
        {
            sprite.play("jump");
        }
    }

    private function awakeClosestOccupant() 
    {
        var auxDistance:Float = 0;
        var distance:Float = Math.random()*30+60;
        var closestOccupant:Occupant = null;
        for (occupant in Tools.filterEntities(["occupant"], Play.entities)) {
            auxDistance = distanceFrom(occupant);
            if (auxDistance < distance) {
                distance = auxDistance;
                closestOccupant = cast(occupant, Occupant);
            }
        }
        if (closestOccupant != null) {
            if (closestOccupant.x - x > 0){
                closestOccupant.shootDirection(false);
            } else {
                closestOccupant.shootDirection(true);
            }
            closestOccupant.awake();
        }
    }

    private function generateRandomNoise() 
    {
        var chosen:Float = 21;
        var random:Float = Math.random() * 100;
        if (random >= chosen && random <= chosen + 1)
        {
            makeNoise();
        }
    }

    private function lookForLoot() 
    {
        var collideEntity:Entity;

        if (Input.check("action") && (collideEntity = collide("chest", x, y)) != null)
        {
            sprite.play("search");
            if (collideEntity == Play.chestWithLoot && !lootFound)
            {
                lootFound = true;
                Score.increasePoints(Constants.lootFoundPoints);
                text = world.addGraphic(new Text("Loot Found", -50, -15, 100, 20));
            }
        }
        if (text != null) {
            text.x = x;
            text.y = y;
        }
    }

    public function hurt() 
    {
        if (lifes > 0) {
            lifes -= 1;
            cast(lifeText.graphic, Text).text = "Lifes: " + lifes;
        } 
    }

    public function isDead(): Bool 
    {
        return lifes == 0 ? true : false;
    }

    private function inLobby() 
    {
        var collideEntity:Entity;
        if ((collideEntity = collide("lobby", x, y)) != null && Input.check("action"))
        {
            if (lootFound) {
                Main.increaseLevel();
            }else{
                if (Score.getPoints() > 0) {
                    Score.decreasePoints(100);
                }
            }
            HXP.world = new Play(Main.level);
        }
    }

    public override function moveCollideY(e:Entity) 
    {
        super.moveCollideY(e);

        canJump = true;
        ySpeed = 0;
    }

    public override function moveCollideX(e:Entity) 
    {
        super.moveCollideX(e);

        HXP.setCamera(e.x - HXP.halfWidth, 0);
    }

    public override function update() 
    {
        super.update();

        timer += (1 / HXP.frameRate);

        if (Math.floor(timer) > 0 && Math.floor(timer) % 10 == 0 && Score.getPoints() > 0)
        {
            Score.decreasePoints(1);
        }

        moveX();
        moveY();
        lookForLoot();
        inLobby();
        //
        if (lifeText == null)
        {
            lifeText = world.addGraphic(new Text("Lifes: " + lifes, 0, 0, 80, 16));
            cast(lifeText.graphic, Text).size = 16;
        }
        lifeText.x = HXP.camera.x + 100;
        lifeText.y = HXP.camera.y + 30;
        //
        if (timeText == null)
        {
            timeText = world.addGraphic(new Text("Time: " + Math.floor(timer), 0, 0, 80, 16));
            cast(timeText.graphic, Text).size = 16;
        }
        cast(timeText.graphic, Text).text = "Time: " + Math.floor(timer);
        timeText.x = HXP.camera.x + 300;
        timeText.y = HXP.camera.y + 30;
        //
        if (pointsText == null)
        {
            pointsText = world.addGraphic(new Text("Points: " + Score.getPoints(), 0, 0, 150, 16));
            cast(pointsText.graphic, Text).size = 16;
        }
        cast(pointsText.graphic, Text).text = "Points: " + Score.getPoints();
        pointsText.x = HXP.camera.x + 500;
        pointsText.y = HXP.camera.y + 30;
    }

}
