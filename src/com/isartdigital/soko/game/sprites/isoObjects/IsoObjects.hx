package com.isartdigital.soko.game.sprites.isoObjects;

import com.isartdigital.soko.game.Blocks;
import com.isartdigital.utils.game.stateObjects.StateAtlas;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import js.html.svg.Point;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */
class IsoObjects extends StateMovieClip
{
	public var blockType:Blocks;
	public var mcEffect:DisplayObject = new DisplayObject();
	
	public function new() 
	{
		super();
		trace("GENERATE: ISO " + blockType);
	}
}