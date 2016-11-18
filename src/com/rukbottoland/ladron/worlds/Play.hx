package com.rukbottoland.ladron.worlds;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;

import com.rukbottoland.ladron.entities.Closet;
import com.rukbottoland.ladron.entities.Floor;
import com.rukbottoland.ladron.entities.Ground;
import com.rukbottoland.ladron.entities.Lobby;
import com.rukbottoland.ladron.entities.Room;
import com.rukbottoland.ladron.entities.Thief;
import com.rukbottoland.ladron.entities.Wall;

class Play extends Sprite
{
    private var difficulty:Int;
    private var childIdx:Map<String,Array<Int>>;

    public function new(difficulty:Int)
    {
        super();

        this.difficulty = difficulty;
        childIdx = [ "room" => [] ];

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        var background = Assets.getBitmapData("graphics/background.png");
        graphics.beginBitmapFill(background, false);
        graphics.drawRect(0, -200, stage.stageWidth, stage.stageHeight);
        graphics.endFill();

        graphics.beginFill(0xffffff);
        graphics.drawCircle(200, 200, 40);
        graphics.endFill();

        addChild(new Ground());
        addChild(new Lobby());

        generateBuilding();
        placeLoot();

        addChild(new Thief(stage.stageWidth/2-140, stage.stageHeight - 200 - Thief.HEIGHT));
    }

    private function generateBuilding()
    {
        var x = stage.stageWidth / 2;
        var y = stage.stageHeight - 200;
        var floors = difficulty;
        var rooms = difficulty + 1;

        var wallX = 0.0;
        var wallY = 0.0;
        var roomX = 0.0;
        var roomY = 0.0;
        var floorX = 0.0;
        var floorY = 0.0;

        for (i in 0...floors)
        {
            wallX = x;
            wallY = y - (i + 1) * Wall.HEIGHT - i * Floor.HEIGHT;
            addChild(new Wall(wallX, wallY));

            for (j in 0...rooms)
            {
                roomX = x + (j + 1) * Wall.WIDTH + j * Room.WIDTH;
                roomY = y - (i + 1) * Room.HEIGHT - i * Floor.HEIGHT;
                var room = new Room(roomX, roomY);
                if (j == rooms - 1 && i % 2 == 0 && i < floors - 1)
                    room.setStairUpBack();
                else if (j == 0 && i % 2 != 0 && i < floors - 1)
                    room.setStairUpFront();
                else if (j == rooms - 1 && i % 2 != 0)
                    room.setStairDownBack();
                else if (j == 0 && i % 2 == 0 && i > 0)
                    room.setStairDownFront();
                addChild(room);
                childIdx["room"].push(getChildIndex(room));

                wallX = x + (j + 1) * Wall.WIDTH + (j + 1) * Room.WIDTH;
                wallY = y - (i + 1) * Room.HEIGHT - i * Floor.HEIGHT;
                addChild(new Wall(wallX, wallY));

                floorX = x + j * Wall.WIDTH + j * Room.WIDTH;
                floorY = y - (i + 1) * Room.HEIGHT - (i + 1) * Floor.HEIGHT;
                addChild(new Floor(floorX, floorY));
            }
        }
    }

    private function placeLoot()
    {
        var totalRooms = childIdx["room"].length;
        var random = Math.round(Math.random() * (totalRooms - 1.0));
        var room = cast(getChildAt(childIdx["room"][random]), Room);
        for (i in room.childIdx["closet"])
            cast(room.getChildAt(i), Closet).hasLoot = true;
    }
}
