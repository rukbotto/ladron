package worlds;

import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import utils.LevelGenerator;
import com.haxepunk.Entity;
import entities.Occupant;
import entities.Thief;


class Play extends World 
{   
    public static var entities:Array<Entity>;
    public static var chestWithLoot:Entity;

    private var difficulty:Int;

    public function new(difficulty:Int) 
    {
        super();

        entities = [];
        chestWithLoot = null;
        this.difficulty = difficulty;
    }

    public override function begin() 
    {
        addGraphic(new Backdrop("gfx/background.png", true));
        addGraphic(Image.createCircle(20, 0xFFFFFF), 0, 100, 100);

        var x:Int = Std.int(HXP.halfWidth);
        var y:Int = Std.int(HXP.height - 100);
        var lvlGenerator:LevelGenerator = new LevelGenerator(x, y, difficulty, difficulty + 1, this);

        var thief:Thief = new Thief(HXP.halfWidth - 70, HXP.height - 130);
        entities.push(thief);
        add(thief);
    }

}
