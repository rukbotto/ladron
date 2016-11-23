package com.rukbottoland.ladron.worlds;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

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
    private function get_inputManager():InputManager { return _inputManager; }

    public var childIdx(get,never):Map<String,Array<Int>>;
    private var _childIdx:Map<String,Array<Int>>;
    private function get_childIdx():Map<String,Array<Int>> { return _childIdx; }

    private var scoreLabel:TextField;
    private var healthLabel:TextField;
    private var timeLabel:TextField;
    private var lootLabel:TextField;

    private var difficulty:Int;
    private var isActive:Bool = false;

    private var thief:Thief;

    public function new(difficulty:Int, inputManager:InputManager)
    {
        super();

        _inputManager = inputManager;
        _childIdx = [
            "room" => [],
            "floor" => [],
            "ground" => [],
            "lobby" => [],
        ];
        this.difficulty = difficulty;

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);

        var font = Assets.getFont("font/04B_03__.ttf");
        var textFormat = new TextFormat(font.fontName, 21, 0xffffff);
        textFormat.align = TextFormatAlign.CENTER;

        scoreLabel = new TextField();
        scoreLabel.width = 150;
        scoreLabel.height = 21;
        scoreLabel.defaultTextFormat = textFormat;
        stage.addChild(scoreLabel);

        healthLabel = new TextField();
        healthLabel.width = 150;
        healthLabel.height = 21;
        healthLabel.defaultTextFormat = textFormat;
        stage.addChild(healthLabel);

        timeLabel = new TextField();
        timeLabel.width = 150;
        timeLabel.height = 21;
        timeLabel.defaultTextFormat = textFormat;
        stage.addChild(timeLabel);

        textFormat.size = 14;
        lootLabel = new TextField();
        lootLabel.visible = false;
        lootLabel.text = "Loot Found!";
        lootLabel.width = 150;
        lootLabel.height = 14;
        lootLabel.defaultTextFormat = textFormat;
        stage.addChild(lootLabel);

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
        thief = new Thief(thiefX, thiefY, this);
        addChild(thief);

        lootLabel.x = thiefX - lootLabel.width / 2;

        isActive = true;
    }

    public function loadNextLevel()
    {
        if (isActive)
        {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);

            stage.removeChild(scoreLabel);
            stage.removeChild(healthLabel);
            stage.removeChild(timeLabel);
            stage.removeChild(lootLabel);

            Main.increaseLevel();
            stage.addChildAt(new Play(Main.level, _inputManager), 1);
            stage.removeChild(this);

            isActive = false;
        }
    }

    private function onEnterFrame(event:Event)
    {
        scoreLabel.text = "Score: " + thief.score;
        scoreLabel.x = stage.stageWidth / 10 * 8 - scoreLabel.width / 2;
        scoreLabel.y = stage.stageHeight / 20;

        healthLabel.text = "Lifes: " + thief.health;
        healthLabel.x = stage.stageWidth / 10 * 2 - healthLabel.width / 2;
        healthLabel.y = stage.stageHeight / 20;

        timeLabel.text = "Time: " + thief.time;
        timeLabel.x = stage.stageWidth / 10 * 5 - timeLabel.width / 2;
        timeLabel.y = stage.stageHeight / 20;

        lootLabel.y = thief.y - 20;

        if (thief.hasFoundLoot) lootLabel.visible = true;
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
        var floorWidth = 0.0;

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
            }

            floorX = x;
            floorY = y - (i + 1) * Room.HEIGHT - (i + 1) * Floor.HEIGHT;
            floorWidth = Room.WIDTH * rooms + Wall.WIDTH * (rooms + 1);
            var floor = new Floor(floorX, floorY, floorWidth);
            addChild(floor);
            _childIdx["floor"].push(getChildIndex(floor));
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
