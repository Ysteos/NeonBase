package com.isartdigital.soko.game.sprites.radarObjects;
import com.isartdigital.soko.game.sprites.isoObjects.IsoMovableObject;
import com.isartdigital.soko.game.sprites.isoObjects.IsoPlayer;
import com.isartdigital.soko.game.sprites.isoObjects.IsoTarget;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObject;
import com.isartdigital.utils.sound.SoundManager;
import openfl.geom.Point;
import com.isartdigital.soko.game.sprites.radarObjects.RadarPlayer;
import com.isartdigital.soko.game.sprites.radarObjects.RadarBox;

/**
 * ...
 * @author Clément MARTIN
 */
class RadarObjectMovable extends RadarObject 
{

	public function new() 
	{
		super();
		
	}
	
	public function move(pDirection:Direction):Bool {
		var lX:Int = cast(getTablePosition().x, Int);
		var lY:Int = cast(getTablePosition().y, Int);
		var lXNext:Int = lX;
		var lYNext:Int = lY;
		
		if (pDirection == Direction.LEFT) lXNext -= 1;
		else if (pDirection == Direction.RIGHT) lXNext += 1;
		else if (pDirection == Direction.UP) lYNext -= 1;
		else if (pDirection == Direction.DOWN) lYNext += 1;
		else{
			throw("ERROR : NO DIRECTION");
			return false;
		}
				
		//check si le radarobject est un player et qu'il arrive à pousser le pushingobject
		if (Std.isOfType(this, RadarPlayer) && Std.isOfType(LevelManager.movableObjectMap[lYNext][lXNext], RadarPushingObject) 
		&& (!RadarPlayer.getInstance().push(cast(LevelManager.movableObjectMap[lYNext][lXNext], RadarPushingObject), pDirection))){
			return false;
		}
		
		//check si le radarobject est un pushing et qu'un autre pushingobject se trouve derrière
		if (Std.isOfType(this, RadarPushingObject) && Std.isOfType(LevelManager.movableObjectMap[lYNext][lXNext], RadarPushingObject)){
			if (Std.isOfType(this, RadarBox)){
				SoundManager.getSound("interdiction").start();
			}
			return false;
		}
		
		//check si un mur se trouve sur le chemin de l'objet
		if (Std.isOfType(LevelManager.notMovableObjectMap[lYNext][lXNext], RadarWall)){
			if(Std.isOfType(this,RadarBox) || Std.isOfType(this,RadarPlayer)){
				SoundManager.getSound("interdiction").start();
			}
			IsoPlayer.getInstance().setModeStagger();
			return false;
		}
		
		if (LevelManager.hasUndo) LevelManager.updateMovementsTable();
		
		LevelManager.saveMovement(this);
		LevelManager.notMovableObjectMap[lYNext][lXNext].addChild(this);
		LevelManager.movableObjectMap[lYNext][lXNext] = this;
		cast(isoObject, IsoMovableObject).move(pDirection);
		if (!Std.isOfType(LevelManager.notMovableObjectMap[lYNext][lXNext], RadarTarget) || !Std.isOfType(this, RadarPlayer)) {
			LevelManager.notMovableObjectMap[lYNext][lXNext].isoObject.mcEffect.visible = true;
			if (Std.isOfType(LevelManager.notMovableObjectMap[lYNext][lXNext].isoObject, IsoTarget)) {
				cast(LevelManager.notMovableObjectMap[lYNext][lXNext].isoObject, IsoTarget).changeParticlesColor();
			}
		}
		LevelManager.notMovableObjectMap[lY][lX].isoObject.mcEffect.visible = false;
		return true;
	}
		
	override public function getTablePosition():Point {
		for (lY in 0...LevelManager.movableObjectMap.length) {
			for (lX in 0...LevelManager.movableObjectMap[lY].length) {
				if (LevelManager.movableObjectMap[lY][lX] == this)
					return (new Point(lX, lY));
			}
		}
		
		throw("ERROR: CANNOT FIND " + blockType + " POSITION ON MOVABLE OBJECT MAP");
		return null;
	}
}