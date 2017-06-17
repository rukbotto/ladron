package ladron.utils;

class Tools
{
    public static function sign(value:Float):Int
    {
        if (value > 0) { return 1; }
        else if (value < 0) { return -1; }
        else { return 0; }
    }

    public static function distance(x0:Float, y0:Float, x1:Float,
            y1:Float):Float
    {
        return Math.sqrt(Math.pow(x1 - x0, 2) + Math.pow(y1 - y0, 2));
    }
}
