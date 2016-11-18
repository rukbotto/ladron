package com.rukbottoland.ladron.utils;

class Tools
{
    public static function sign(value:Float):Int
    {
        if (value > 0) { return 1; }
        else if (value < 0) { return -1; }
        else { return 0; }
    }
}
