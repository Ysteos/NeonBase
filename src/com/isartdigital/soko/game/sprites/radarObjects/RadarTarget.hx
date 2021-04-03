package com.isartdigital.soko.game.sprites.radarObjects;

import com.isartdigital.soko.game.sprites.isoObjects.IsoObjects;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObjectNotMovable;
import com.isartdigital.soko.game.sprites.isoObjects.IsoTarget;

/**
 * ...
 * @author 
 */
class RadarTarget extends RadarObjectNotMovable
{

	public function new() 
	{
		blockType = Blocks.TARGET;
		super();
		isoObject = cast(new IsoTarget(), IsoObjects);
	}
	
}