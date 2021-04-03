package com.isartdigital.soko.game.sprites;

import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderType;

/**
 * ...
 * @author 
 */
class Trampoline extends StateMovieClip 
{

	public function new() 
	{
		super();	
	}
	
	override function get_colliderType():ColliderType 
	{
		return ColliderType.NONE;
	}
	
}