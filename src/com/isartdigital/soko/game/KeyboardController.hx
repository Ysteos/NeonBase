package src.com.isartdigital.soko.game;
import com.isartdigital.utils.game.GameStage;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

/**
 * ...
 * @author Jeffrey SEYMOUR
 */
class KeyboardController 
{
	private var myStage:Stage;
	private static var allKeysJustDown:Array<Bool> = [];
    private static var allKeysDown:Array<Bool> = [];
	public var left(get, null):Bool;
	public var up(get, null):Bool;
	public var down(get, null):Bool;
	public var right(get, null):Bool;
	
	public function new(pStage:Stage) 
	{
		myStage = pStage;
		
		//allKeysDown = [];
        myStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
        myStage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
	}
	
	public function doAction():Void 
    {
        for (i in 0...allKeysJustDown.length)
			allKeysJustDown[i] = false;
    }
	
	public function get_left():Bool {
        return (allKeysJustDown[Keyboard.LEFT] || allKeysJustDown[Keyboard.Q]);
    }
    
    public function get_right():Bool {
        return (allKeysJustDown[Keyboard.RIGHT] || allKeysJustDown[Keyboard.D]);
    }
    
    public function get_up():Bool {
        return (allKeysJustDown[Keyboard.UP] || allKeysJustDown[Keyboard.Z]);
    }
    
    public function get_down():Bool {
        return (allKeysJustDown[Keyboard.DOWN] || allKeysJustDown[Keyboard.S]);
    }
	
	private function onKeyboardUp(pEvent:KeyboardEvent):Void 
	{
		allKeysDown[pEvent.keyCode] = false;
		if (!allKeysDown[pEvent.keyCode])
			doAction();
	}
	
	private function onKeyboardDown(pEvent:KeyboardEvent):Void 
	{
		allKeysJustDown[pEvent.keyCode] = true;
	}
}