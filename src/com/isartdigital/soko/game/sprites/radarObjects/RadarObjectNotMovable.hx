package com.isartdigital.soko.game.sprites.radarObjects;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObject;
import openfl.geom.Point;

/**
 * ...
 * @author Clément MARTIN
 */
class RadarObjectNotMovable extends RadarObject 
{

	public function new() 
	{
		super();	
	}
	
	override public function getTablePosition():Point {
		for (lY in 0...LevelManager.movableObjectMap.length) {
			for (lX in 0...LevelManager.movableObjectMap[lY].length) {
				if (LevelManager.notMovableObjectMap[lY][lX] == this)
					return (new Point(lX, lY));
			}
		}
		
		throw("ERROR: CANNOT FIND " + blockType + " POSITION ON NOT MOVABLE OBJECT MAP");
		return null;
	}
}