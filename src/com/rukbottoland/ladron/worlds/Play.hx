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
import com.rukbottoland.ladron.utils.InputManager;

class Play extends Sprite
{
    public var inputManager(get,never):InputManager;
    private var _inputManager:InputManager;
    private function get_inputManager() : InputManager { return _inputManager; }

    public var childIdx(get,never):Map<String,Array<Int>>;
    private var _childIdx:Map<String,Array<Int>>;
    private function get_childIdx():Map<String,Array<Int>> { return _childIdx; }

    private var difficulty:Int;
    private var isActive:Bool = false;

    public function new(difficulty:Int, inputManager:InputManager)
    {
        super();

        _inputManager = inputManager;
        _childIdx = [
            "room" => [],
            "ground" => [],
            "lobby" => [],
        ];
        this.difficulty = difficulty;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        var background = Assets.getBitmapData("graphics/background.png");
        graphics.beginBitmapFill(background, true);
        graphics.drawRect(-1000, -200, stage.stageWidth * 10, stage.stageHeight);
        graphics.endFill();

        graphics.beginFill(0xffffff);
        graphics.drawCircle(200, 200, 40);
        graphics.endFill();

        var ground = new Ground();
        addChild(ground);
        _childIdx["ground"].push(getChildIndex(ground));

        var lobby = new Lobby();
        addChild(lobby);
        _childIdx["lobby"].push(getChildIndex(lobby));

        generateBuilding();
        placeLoot();

        var thiefX = stage.stageWidth / 2 - 140;
        var thiefY = ground.y - Thief.HEIGHT;
        addChild(new Thief(thiefX, thiefY, this));

        isActive = true;
    }

    public function loadNextLevel()
    {
        if (isActive)
        {
            Main.increaseLevel();
            stage.addChildAt(new Play(Main.level, _inputManager), 1);
            stage.removeChildAt(2);
            isActive = false;
        }
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
                _childIdx["room"].push(getChildIndex(room));

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
        var totalRooms = _childIdx["room"].length;
        var random = Math.round(Math.random() * (totalRooms - 1.0));
        var room = cast(getChildAt(_childIdx["room"][random]), Room);
        for (i in room.childIdx["closet"])
            cast(room.getChildAt(i), Closet).hasLoot = true;
    }
}
