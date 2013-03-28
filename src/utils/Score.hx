package utils;

import com.haxepunk.HXP;


class Score
{

    private static var points:Int = 0;

    public static function resetScore() 
    {
        points = 0;
    }

    public static function increasePoints(points:Int) 
    {
        Score.points += points;
    }

    public static function decreasePoints(points:Int) 
    {
        Score.points -= points;
    }

    public static function getPoints():Int
    {
        return points;
    }

}
