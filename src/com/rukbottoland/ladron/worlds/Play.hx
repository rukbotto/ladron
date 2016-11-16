package com.rukbottoland.ladron.worlds;

import flash.display.Sprite;
import flash.events.Event;

import openfl.Assets;

import com.rukbottoland.ladron.entities.Floor;
import com.rukbottoland.ladron.entities.Ground;
import com.rukbottoland.ladron.entities.Lobby;
import com.rukbottoland.ladron.entities.Room;
import com.rukbottoland.ladron.entities.Wall;

class Play extends Sprite
{
    private var difficulty:Int;

    public function new(difficulty:Int)
    {
        super();
        this.difficulty = difficulty;
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

        generateLevel();
    }

    private function generateLevel()
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

        addChild(new Ground());
        addChild(new Lobby());

        for (i in 0...floors)
        {
            wallX = x;
            wallY = y - (i + 1) * Wall.HEIGHT - i * Floor.HEIGHT;
            addChild(new Wall(wallX, wallY));

            for (j in 0...rooms)
            {
                roomX = x + (j + 1) * Wall.WIDTH + j * Room.WIDTH;
                roomY = y - (i + 1) * Room.HEIGHT - i * Floor.HEIGHT;
                addChild(new Room(roomX, roomY));

                wallX = x + (j + 1) * Wall.WIDTH + (j + 1) * Room.WIDTH;
                wallY = y - (i + 1) * Room.HEIGHT - i * Floor.HEIGHT;
                addChild(new Wall(wallX, wallY));

                floorX = x + j * Wall.WIDTH + j * Room.WIDTH;
                floorY = y - (i + 1) * Room.HEIGHT - (i + 1) * Floor.HEIGHT;
                addChild(new Floor(floorX, floorY));
            }
        }
    }
}
