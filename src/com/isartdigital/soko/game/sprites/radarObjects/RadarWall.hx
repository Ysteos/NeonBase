package com.isartdigital.soko.game.sprites.radarObjects;

import com.isartdigital.soko.game.sprites.isoObjects.IsoNotMovableObject;
import com.isartdigital.soko.game.sprites.isoObjects.IsoObjects;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObjectNotMovable;
import com.isartdigital.soko.game.sprites.isoObjects.IsoWall;

/**
 * ...
 * @author Clément MARTIN
 */
class RadarWall extends RadarObjectNotMovable
{
	
	public function new() 
	{
		blockType = Blocks.WALL;
		super();	
		isoObject = new IsoWall();
	}
}