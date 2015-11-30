package worlds;

import com.haxepunk.Scene;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Text.TextOptions;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import utils.Score;


class Intro extends Scene
{
    public function new()
    {
        super();

        var textOptions:TextOptions = {};
        // textOptions.align = "center";
        textOptions.wordWrap = true;
        textOptions.color = 0xFFFFFF;

        var message:String =
            "LADRON!\n\n" +
            "Your goal is to steal the loot!\n\n" +
            "Beware of the sleeping occupants, they will shot you if they hear you!\n\n" +
            "Keys:\n\n" +
            "<S> for sneaking, <X> to search the loot inside the closets, " +
            "<UP> to go upstairs or jump, <DOWN> to go downstairs, " +
            "<LEFT/RIGHT> to run.\n\n" +
            "If you found the loot, go to the pagoda and press <X> to advance the next level.\n\n" +
            "Press space bar to start the game!";

        var messageText = addGraphic(new Text(message, 0, 0, 640, 500, textOptions));
        cast(messageText.graphic, Text).size = 24;
        messageText.x = 0;
        messageText.y = 10;
    }

    public override function update()
    {
        if (Input.check(Key.SPACE)) {
            HXP.world = new Play(1);
        }
    }
}
