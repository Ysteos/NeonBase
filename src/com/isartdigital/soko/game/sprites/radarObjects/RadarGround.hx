package com.isartdigital.soko.game.sprites.radarObjects;

import com.isartdigital.soko.game.sprites.isoObjects.IsoNotMovableObject;
import com.isartdigital.soko.game.sprites.isoObjects.IsoObjects;
import com.isartdigital.soko.game.sprites.isoObjects.IsoGround;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderType;

/**
 * ...
 * @author 
 */
class RadarGround extends RadarObjectNotMovable 
{
	public function new() 
	{
		blockType = Blocks.GROUND;
		super();
		isoObject = new IsoGround();
	}
	
}