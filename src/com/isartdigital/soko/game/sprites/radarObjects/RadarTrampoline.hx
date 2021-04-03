package com.isartdigital.soko.game.sprites.radarObjects;

import com.isartdigital.soko.game.sprites.Direction;
import com.isartdigital.soko.game.sprites.isoObjects.IsoMovableObject;
import com.isartdigital.soko.game.sprites.isoObjects.IsoObjects;
import com.isartdigital.soko.game.sprites.isoObjects.IsoPlayer;
import com.isartdigital.soko.game.sprites.isoObjects.IsoTrampoline;
import com.isartdigital.soko.game.sprites.radarObjects.RadarPlayer;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObject;
import com.isartdigital.soko.game.sprites.radarObjects.RadarPushingObject;
import com.isartdigital.utils.sound.SoundManager;

	
/**
 * ...
 * @author 
 */
class RadarTrampoline extends RadarPushingObject 
{
	public function new() 
	{
		blockType = Blocks.TRAMPOLINE;
		super();
		isoObject = new IsoTrampoline();
	}
	
	override public function destroy (): Void {
		super.destroy();
	}
	
	public function jump(pDirection:Direction):Void{
		var lXPlayer:Int = cast(RadarPlayer.getInstance().getTablePosition().x, Int);
		var lYPlayer:Int = cast(RadarPlayer.getInstance().getTablePosition().y, Int);
		var lXNext:Int = lXPlayer;
		var lYNext:Int = lYPlayer;
		
		if (pDirection == Direction.LEFT && lXPlayer > 2) lXNext -= 3;
		else if (pDirection == Direction.RIGHT && lXPlayer < LevelManager.movableObjectMap[lYPlayer].length - 3) lXNext += 3;
		else if (pDirection == Direction.UP && lYPlayer > 2) lYNext -= 3;
		else if (pDirection == Direction.DOWN && lYPlayer < LevelManager.movableObjectMap.length - 3) lYNext += 3;
		else return;
		
		if (LevelManager.movableObjectMap[lYNext][lXNext] != null || Std.isOfType(LevelManager.notMovableObjectMap[lYNext][lXNext], RadarWall)){
			SoundManager.getSound("interdiction").start();
			return;
		}
		
		if (LevelManager.hasUndo) LevelManager.updateMovementsTable();
		
		LevelManager.saveMovement(RadarPlayer.getInstance());
		LevelManager.movementIndex++;
		LevelManager.movementsTable.push(new Array<Array<RadarObject>>());
		LevelManager.notMovableObjectMap[lYNext][lXNext].addChild(RadarPlayer.getInstance());
		LevelManager.movableObjectMap[lYNext][lXNext] = RadarPlayer.getInstance();
		LevelManager.movableObjectMap[lYPlayer][lXPlayer] = null;
		IsoPlayer.getInstance().move(pDirection);
		IsoPlayer.isJumping = true;
		LevelManager.notMovableObjectMap[lYPlayer][lXPlayer].isoObject.mcEffect.visible = false;
		LevelManager.notMovableObjectMap[lYNext][lXNext].isoObject.mcEffect.visible = true;
	}

}