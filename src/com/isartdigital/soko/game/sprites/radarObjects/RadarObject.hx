package com.isartdigital.soko.game.sprites.radarObjects;

import com.isartdigital.soko.game.sprites.isoObjects.IsoObjects;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderType;
import openfl.geom.Point;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */
class RadarObject extends StateMovieClip 
{
	public var blockType: Blocks;
	public var isoObject: IsoObjects;
	
	public function new()
	{trace("GENERATE: RADAR " + blockType);
		super();
		
	}
	
	public function getTablePosition():Point {
		return null;
	}
	
	override function get_colliderType():ColliderType 
	{
		return ColliderType.NONE;
	}
}