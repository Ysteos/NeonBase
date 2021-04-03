package com.isartdigital.soko.game.sprites;

import com.isartdigital.utils.game.stateObjects.StateAtlas;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderType;

	
/**
 * ...
 * @author 
 */
class Player extends StateAtlas 
{
	
	/**
	 * instance unique de la classe Player
	 */
	private static var instance: Player;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Player {
		if (instance == null) instance = new Player();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	public function new() 
	{
		super();
	}
	
	override function get_colliderType():ColliderType 
	{
		return ColliderType.NONE;
	}
	
	override function get_stateDefault():String 
	{
		return "IDLE_UP";
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		instance = null;
	}

}