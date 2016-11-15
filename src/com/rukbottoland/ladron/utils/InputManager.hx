package com.rukbottoland.ladron.utils;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class InputManager {

    public var inputs(get, never):Dynamic;
    private var _inputs:Dynamic;

    private function get_inputs():Dynamic
    {
        return _inputs;
    }

    public function new() {
        _inputs = {
            space: false
        };
    }

    public function onKeyDown(event:KeyboardEvent)
    {
        if (event.keyCode == Keyboard.SPACE)
            _inputs.space = true;
    }

    public function onKeyUp(event:KeyboardEvent)
    {
        if (event.keyCode == Keyboard.SPACE)
            _inputs.space = false;
    }
}
