package com.isartdigital.soko.game.sprites.radarObjects;

import com.isartdigital.soko.game.Blocks;
import com.isartdigital.soko.game.sprites.Direction;
import com.isartdigital.soko.game.sprites.isoObjects.IsoMovableObject;
import com.isartdigital.soko.game.sprites.isoObjects.IsoObjects;
import com.isartdigital.soko.game.sprites.isoObjects.IsoPlayer;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObject;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObjectMovable;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderType;
import com.isartdigital.utils.sound.SoundManager;
import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import src.com.isartdigital.soko.game.KeyboardController;

	
/**
 * ...
 * @author 
 */
class RadarPlayer extends RadarObjectMovable
{
	/**
	 * instance unique de la classe RadarPlayer
	 */
	private static var instance: RadarPlayer;
	public static var controller: KeyboardController;
	private var step:UInt;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): RadarPlayer {
		if (instance == null) instance = new RadarPlayer();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		blockType = Blocks.PLAYER;
		super();
		isoObject = IsoPlayer.getInstance();
		controller = new KeyboardController(Lib.current.stage);
		setModeNormal();
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		var lXPosition:Int = cast(getTablePosition().x, Int);
		var lYPosition:Int = cast(getTablePosition().y, Int);
		
		var lDirection:Direction = null;
		
		if (controller.get_left() && lXPosition > 0)
			lDirection = Direction.LEFT;
			
		else if (controller.get_right() && lXPosition < LevelManager.movableObjectMap[lYPosition].length - 1)
			lDirection = Direction.RIGHT;
			
		else if (controller.get_up() && lYPosition > 0)
			lDirection = Direction.UP;
			
		else if (controller.get_down() && lYPosition < LevelManager.movableObjectMap.length - 1)
			lDirection = Direction.DOWN;
			
		RadarPlayer.controller.doAction();
		
		if (lDirection != null)
			if (move(lDirection)) {
				LevelManager.movementsTable.push(new Array<Array<RadarObject>>());
				LevelManager.movementIndex++;
			}
	}
	
	public function push(pPushingObject:RadarPushingObject, pDirection:Direction):Bool {
		if (pPushingObject.move(pDirection)) {
			SoundManager.getSound("pushBox").start();
			pPushingObject.isoObject.mcEffect.visible = true;
			isoObject.mcEffect.visible = true;
			return true;
		}
		else if (Std.isOfType(pPushingObject, RadarTrampoline))
			cast(pPushingObject, RadarTrampoline).jump(pDirection);
		else IsoPlayer.getInstance().setModeStagger();
		
		return false;
	}
	
	override function move(pDirection:Direction):Bool 
	{
		var lX:Int = cast(getTablePosition().x, Int);
		var lY:Int = cast(getTablePosition().y, Int);
		
		if (!super.move(pDirection)) {
			return false;
		}
		
		LevelManager.movableObjectMap[lY][lX] = null;
		LevelManager.notMovableObjectMap[lY][lX].isoObject.mcEffect.visible = false;
		return true;
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy(): Void {
		super.destroy();
		instance = null;
		controller = null;
	}
}