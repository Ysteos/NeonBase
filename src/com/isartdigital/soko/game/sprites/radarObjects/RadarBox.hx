package com.isartdigital.soko.game.sprites.radarObjects;

import com.isartdigital.soko.game.sprites.Direction;
import com.isartdigital.soko.game.sprites.isoObjects.IsoMovableObject;
import com.isartdigital.soko.game.sprites.isoObjects.IsoObjects;
import com.isartdigital.soko.game.sprites.isoObjects.IsoBox;
import com.isartdigital.utils.sound.SoundManager;
import motion.Actuate;

/**
 * ...
 * @author 
 */

class RadarBox extends RadarPushingObject 
{
	static public var allBoxes : Array<RadarBox> = new Array<RadarBox>();
	public var onTarget : Bool = false;
	
	public function new() 
	{
		blockType = Blocks.BOX;
		super();
		isoObject = new IsoBox();
		allBoxes.push(this);
		onTarget = Std.isOfType(parent, RadarTarget);
	}
	
	override function move(pDirection:Direction):Bool 
	{
		if (super.move(pDirection)){
			onTarget = Std.isOfType(parent, RadarTarget);
			if (onTarget) {
				SoundManager.getSound("onTarget").start();
				isoObject.setState("onTarget");
				isoObject.mcEffect = isoObject.renderer.getChildByName("mcEffect");
				isoObject.mcEffect.visible = false;
			}
			else {
				if (isoObject.state != stateDefault) {
					isoObject.setState(stateDefault);
					isoObject.mcEffect = isoObject.renderer.getChildByName("mcEffect");
					isoObject.mcEffect.visible = false;
				}
			}
		}
		else{
			IsoMovableObject.clearAllMovableObjects();
			return false;
		}
		
		/*for (check in allBoxes){
			if (!check.onTarget) return true;
		}*/
		
		return true;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		allBoxes.shift();
	}
}