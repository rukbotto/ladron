package utils;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;
import com.haxepunk.masks.Hitbox;
import utils.Tools;
import utils.Constants;
import entities.Occupant;
import worlds.Play;


class LevelGenerator 
{

    private var world:World;

    public function new(x:Int, y:Int, floors:Int, rooms:Int, world:World) 
    {
        this.world = world;


        world.addMask(new Hitbox(10, 100),"boundary", 0, y - 100);

        var groundWidth:Int = HXP.width * 10;
        var groundHeight:Int = 1000;
        placeEntity(-1000, y, groundWidth, groundHeight, "ground", 0x3d2920);

        var lobbyWidth:Int = 60;
        var lobbyHeight:Int = 60;
        placeEntity(60, y - lobbyHeight, lobbyWidth, lobbyHeight, "lobby", "gfx/lobby.png");

        for (i in 0...floors)
        {
            var wallX:Int = x;
            var wallY:Int = y - 
                    (((i + 1) * Constants.wallHeight) + (i * Constants.floorHeight));
            var wallType:String = "door";
            if (i > 0)
            {
                wallType = "wall";
            }
            placeEntity(wallX, wallY, Constants.wallWidth, Constants.wallHeight, 
                    wallType, 0x8F8F8F);

            for (j in 0...rooms)
            {
                var roomX:Int = x + ((j + 1) * Constants.wallWidth) + 
                        (j * Constants.roomWidth);
                var roomY:Int = y - (((i + 1) * Constants.roomHeight) + 
                        (i * Constants.floorHeight));
                placeEntity(roomX, roomY, Constants.roomWidth, 
                        Constants.roomHeight, "room", 0x3d3d3d);

                if (j == rooms - 1 && i % 2 == 0 && i < floors - 1)
                {
                    placeEntity(roomX + (Constants.roomWidth - 15), roomY, 15, 
                            Constants.roomHeight, "stairUp", "gfx/stairs_up.png");
                } else if (j == 0 && i % 2 != 0 && i < floors - 2)
                {
                    placeEntity(roomX ,roomY, 15, Constants.roomHeight, 
                            "stairUp", "gfx/stairs_up.png");
                } else if (j == rooms -1 && i % 2 != 0)
                {
                    placeEntity(roomX + (Constants.roomWidth-15),roomY, 15, 
                            Constants.roomHeight, "stairDown", "gfx/stairs_down.png");
                } else if (j == 0 && i % 2 == 0 && i > 0)
                {
                    placeEntity(roomX ,roomY, 15, Constants.roomHeight, 
                            "stairDown", "gfx/stairs_down.png");
                }

                var chestWidth:Int = 20;
                var chestHeight = 40;
                var chestX:Int = roomX;
                var chestY:Int = roomY + (Constants.roomHeight - chestHeight);
                placeRandomEntity(chestX, Constants.roomWidth, chestY, 
                        chestWidth, chestHeight, "chest", "gfx/chest.png");

                var bedWidth:Int = 40;
                var bedHeight:Int = 7;
                var bedX = roomX;
                var bedY:Int = roomY + (Constants.roomHeight - bedHeight);
                placeRandomEntity(bedX, Constants.roomWidth, bedY, 40, 7, "bed", 
                        "gfx/bed.png");

                wallX = x + ((j + 1) * Constants.wallWidth) + 
                        ((j + 1) * Constants.roomWidth);
                wallY = y - 
                        (((i + 1) * Constants.roomHeight) + (i * Constants.floorHeight));
                wallType = "door";
                if (j == rooms - 1)
                {
                    wallType = "wall";
                }
                placeEntity(wallX, wallY, Constants.wallWidth, 
                        Constants.wallHeight, wallType, 0x8F8F8F);
            }

            var floorWidth:Int = (Constants.roomWidth * rooms) + 
                    (Constants.wallWidth * (rooms + 1));
            var floorX:Int = x;
            var floorY:Int = y - 
                    (((i + 1) * Constants.wallHeight) + ((i + 1) * Constants.floorHeight));
            placeEntity(floorX, floorY, floorWidth, Constants.floorHeight, 
                    "floor", 0x000000);
        }
        placeOccupants();
        placeLoot();

    }

    private function placeEntity(x:Int, y:Int, width:Int, height:Int,
            type:String, ?image:String, ?color:Int) 
    {
        var entity:Entity = createEntity(x, y, width, height, type, image, color);
        addEntity(entity);
    }

    private function placeRandomEntity(x:Int, xMax:Int, y:Int, width:Int, 
            height:Int, type:String, image:String)
    {
        var checkPassed:Bool = false;
        var types:Array<String> = ["bed", "chest", "stairUp", "stairDown"];

        while (!checkPassed) 
        {
            var randomPos:Int = Std.int(Math.random() * xMax);
            if (randomPos > width)
            {
                randomPos -= width;
            }
            var itemX:Int = x + randomPos;
            var entity:Entity = createEntity(itemX, y, width, height, type, image);
            checkPassed = Tools.checkOverlap(entity, Play.entities, types);
            if (checkPassed)
            {
                addEntity(entity);
            }
        }
    }

    private function createEntity(x:Int, y:Int, width:Int, height:Int, 
            type:String, ?image:String, ?color:Int):Entity
    {
        var graphic:Image = null;
        if (color != null)
        {
            graphic = Image.createRect(width, height, color);
        }
        else if (image != null)
        {
            graphic = new Image(image);
        }
        else
        {
            graphic = Image.createRect(width, height, 0xFFFFFF);
        }
        var hitbox:Hitbox = new Hitbox(width, height);
        var entity:Entity = new Entity(x, y, graphic, hitbox);
        entity.type = type;

        return entity;
    }

    private function addEntity(entity:Entity)
    {
        world.add(entity);
        Play.entities.push(entity);
    }

    private function placeOccupants() 
    {
        var occupant:Occupant;

        for (bed in Tools.filterEntities(["bed"], Play.entities))
        {
            world.add(occupant = new Occupant(bed.x + 10, bed.y - 10));
            Play.entities.push(occupant);
        }
    }

    private function placeLoot() 
    {
        var chests:Array<Entity> = Tools.filterEntities(["chest"], Play.entities);
        var random:Int = Math.round(Math.random() * (chests.length - 1));
        Play.chestWithLoot = chests[random];
    }

}
