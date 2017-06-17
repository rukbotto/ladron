package ladron.utils;

import haxe.Timer;

import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class DebugInfo extends TextField
{
    private var timeSample:Array<Float>;
    private var now:Float = 0;
    private var mem:Float = 0;
    private var memPeak:Float = 0;

    public function new(x:Float = 10, y:Float = 10, color:Int = 0x00ff00)
    {
        super();

        this.x = x;
        this.y = y;
        timeSample = [];
        selectable = false;
        defaultTextFormat = new TextFormat("_sans", 12, color);
        text = "FPS: ";
        width = 150;
        height = 70;

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(event:Event)
    {
        now = Timer.stamp();
        timeSample.push(now);

        while (timeSample[0] < now - 1)
            timeSample.shift();

        mem = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;
        if (mem > memPeak) memPeak = mem;

        if (visible)
        {
            text = "FPS: " + timeSample.length + "\n" +
                "MEM: " + mem + " MB\n" +
                "MEM peak: " + memPeak + " MB\n";
        }
    }
}
