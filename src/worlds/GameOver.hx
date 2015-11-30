package worlds;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import utils.Score;
import worlds.Play;


class GameOver extends Scene
{
    public function new()
    {
        super();

        var text = addGraphic(new Text("Game Over", 0, 0,200,32));
        cast(text.graphic, Text).size = 32;
        text.x = HXP.halfWidth - 200/2;
        text.y = HXP.halfHeight - 20;

        var messageText = addGraphic(new Text("Your score was "+ Score.getPoints(), 0, 0,300,24));
        cast(messageText.graphic, Text).size = 24;
        messageText.x = HXP.halfWidth - 250/2;
        messageText.y = HXP.halfHeight + 32;

        var messageText = addGraphic(new Text("Press Space Bar to restart the game", 0, 0,500,24));
        cast(messageText.graphic, Text).size = 24;
        messageText.x = HXP.halfWidth - 500/2;
        messageText.y = HXP.halfHeight + 65;
    }

    public override function update()
    {
        if (Input.check(Key.SPACE)) {
            Main.resetLevel();
            Score.resetScore();
            HXP.world = new Play(1);
        }
    }

}
