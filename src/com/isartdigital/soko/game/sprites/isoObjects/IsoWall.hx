package com.isartdigital.soko.game.sprites.isoObjects;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */

class IsoWall extends IsoNotMovableObject 
{
	public function new() 
	{
		blockType = Blocks.WALL;
		super();
	}
}