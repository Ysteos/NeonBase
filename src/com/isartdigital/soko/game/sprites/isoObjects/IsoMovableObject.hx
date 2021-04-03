package com.isartdigital.soko.game.sprites.isoObjects;

import com.isartdigital.soko.game.sprites.Direction;
import com.isartdigital.soko.game.sprites.radarObjects.RadarBox;
import com.isartdigital.soko.ui.Hud;
import com.isartdigital.utils.Timer;
import motion.Actuate;
import openfl.geom.Point;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */
class IsoMovableObject extends IsoObjects
{
	public static var allMovableObject:Array<IsoMovableObject> = new Array <IsoMovableObject>();
	private var lerpTime:Float = 0.25;
	private var movement:Point;
	private var moveTimer:Timer = new Timer();
	public var isMoving: Bool;

	public function new()
	{
		super();
	}

	public function move(pDirection:Direction):Void
	{
		movement = new Point(-x, -y);

		switch pDirection {
		case Direction.LEFT:
			movement.x += x - LevelManager.isoSizeX/2;
			movement.y += y - LevelManager.isoSizeY/2;
		case Direction.RIGHT:
			movement.x += x + LevelManager.isoSizeX/2;
			movement.y += y + LevelManager.isoSizeY/2;
		case Direction.UP:
			movement.x += x + LevelManager.isoSizeX/2;
			movement.y += y - LevelManager.isoSizeY/2;
		case Direction.DOWN:
			movement.x += x - LevelManager.isoSizeX/2;
			movement.y += y + LevelManager.isoSizeY/2;
	}

	setModeNormal();
		allMovableObject.push(this);
		isMoving = true;
		moveTimer.resume();
		LevelManager.generateIsoLevel();
		Hud.getInstance().shutBtnListeners();
	}

	override function doActionNormal():Void
	{
		moveTimer.update();
		x += moveTimer.deltaTimeInMilisecond * movement.x / (1000 * lerpTime);
		y += moveTimer.deltaTimeInMilisecond * movement.y / (1000 * lerpTime);

		if (moveTimer.elapsedTime >= lerpTime)
		{
			moveTimer.stop();
			moveTimer.reset();
			isMoving = false;
			allMovableObject.remove(this);
			setModeVoid();
			Hud.getInstance().openBtnListeners();
			mcEffect.visible = false;
			for (box in RadarBox.allBoxes)
				if (!box.onTarget) return;
			
			for (box in RadarBox.allBoxes) {
				LevelManager.isAnimate = true;
				Actuate.tween(box.isoObject, 1, {scaleX : 0}, false);
				Actuate.tween(box.isoObject, 1, {scaleY : 0}, false).onComplete(LevelManager.win);
			}
		}
	}
	
	public static function clearAllMovableObjects():Void {
		while (allMovableObject.length != 0)
			allMovableObject.pop();
	}
}