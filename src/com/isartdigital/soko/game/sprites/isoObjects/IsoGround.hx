package com.isartdigital.soko.game.sprites.isoObjects;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */

class IsoGround extends IsoNotMovableObject 
{
	public function new() 
	{
		blockType = Blocks.GROUND;
		super();
		
		mcEffect = renderer.getChildByName("mcEffect");
        mcEffect.visible = false;
	}
	
}