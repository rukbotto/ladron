package com.rukbottoland.ladron.utils;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class InputManager
{
    public var inputs(get, never):Dynamic;
    private var _inputs:Dynamic;
    private function get_inputs():Dynamic { return _inputs; }

    public function new()
    {
        _inputs = {
            space: false,
            sneak: false,
            left: false,
            right: false,
            up: false,
        };
    }

    public function onKeyDown(event:KeyboardEvent)
    {
        if (event.keyCode == Keyboard.SPACE)
            _inputs.space = true;

        if (event.keyCode == Keyboard.S)
            _inputs.sneak = true;

        if (event.keyCode == Keyboard.LEFT)
            _inputs.left = true;

        if (event.keyCode == Keyboard.RIGHT)
            _inputs.right = true;

        if (event.keyCode == Keyboard.UP)
            _inputs.up = true;
    }

    public function onKeyUp(event:KeyboardEvent)
    {
        if (event.keyCode == Keyboard.SPACE)
            _inputs.space = false;

        if (event.keyCode == Keyboard.S)
            _inputs.sneak = false;

        if (event.keyCode == Keyboard.LEFT)
            _inputs.left = false;

        if (event.keyCode == Keyboard.RIGHT)
            _inputs.right = false;

        if (event.keyCode == Keyboard.UP)
            _inputs.up = false;
    }
}
