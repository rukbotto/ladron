package ladron.utils;

class Score
{
    public var points(get,set):Int;
    private var _points:Int = 0;
    private function get_points():Int { return _points; }
    private function set_points(value:Int):Int { return _points = value; }

    public function new(points:Int)
    {
        _points = points;
    }
}
