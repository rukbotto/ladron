package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import entities.Thief;
import com.haxepunk.HXP;
import worlds.GameOver;

class Bullet extends Entity
{

    private var toRight:Bool;

    public function new(x: Float, y: Float, toRight:Bool) 
    {
        super(x, y);
        graphic = Image.createRect(5, 2, 0xFFFFFF);
        setHitbox(5, 2);
        this.toRight = toRight;
        type = "bullet";
    }

    private function hitThief() 
    {
        var collideEntity:Entity;
        if ((collideEntity = collide("thief", x, y)) != null) {
            var thief:Thief = cast(collideEntity, Thief);
            thief.hurt();
            if (thief.isDead()) {
                world.remove(thief);
                HXP.world = new GameOver();
            }
            world.remove(this);
        }
    }

    public override function update() 
    {
        super.update();

        if (toRight)
        {
            moveBy(5, 0, ["wall","door"]);
        }
        else
        {
            moveBy(-5, 0, ["wall","door"]);
        }
        hitThief();
    }

    public override function moveCollideX(e: Entity) 
    {
        super.moveCollideX(e);

        world.remove(this);
    }
}
