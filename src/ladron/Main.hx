package ladron;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

import ladron.utils.DebugInfo;
import ladron.utils.InputManager;
import ladron.worlds.Intro;

class Main extends Sprite
{
    public static var level = 1;

    private var inputManager:InputManager;

    public function new()
    {
        super();
        inputManager = new InputManager();
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        stage.addEventListener(KeyboardEvent.KEY_DOWN, inputManager.onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, inputManager.onKeyUp);

        stage.addChild(new Intro(inputManager));
#if debug
        trace("Renderer: " + stage.window.renderer.type);
        stage.addChild(new DebugInfo());
#end
    }

    public static function main()
    {
        Lib.current.addChild(new Main());
    }

    public static function resetLevel()
    {
        level = 1;
    }

    public static function increaseLevel()
    {
        level++;
    }
}
