package com.isartdigital.soko.game;

import com.isartdigital.soko.game.sprites.isoObjects.IsoMovableObject;
import com.isartdigital.soko.game.sprites.radarObjects.RadarPlayer;
import com.isartdigital.soko.ui.GameStageBackground;
import com.isartdigital.soko.ui.UIManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.soko.ui.Hud;
import com.isartdigital.utils.system.Monitor;
import com.isartdigital.utils.system.MonitorField;
import haxe.Json;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import com.isartdigital.soko.ui.HighScores;
import com.isartdigital.soko.ui.HelpScreen;
import com.isartdigital.soko.ui.TitleCard;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;

/**
 * ...
 * @author Chadi Husser
 */
class GameManager 
{
	//public static var controller:KeyboardController;
	
	public static function start(pIndex:Int) : Void{
		
		var lJson:Dynamic = Json.parse(GameLoader.getText("assets/settings/player.json"));
        Monitor.setSettings(lJson, RadarPlayer.getInstance());
        
        var fields : Array<MonitorField> = [{name:"smoothing", onChange:onChange}, {name:"x", step:1}, {name:"y", step:100}];
        Monitor.start(RadarPlayer.getInstance(), fields, lJson);
		
		UIManager.closeScreens();
		
		GameStage.getInstance().getGameContainer().addChild(GameStageBackground.getInstance());
		
		//LevelManager.isoContainer.addEventListener(MouseEvent.CLICK, onClick);
		
		resumeGame();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, gameLoop);
			
		//UIManager.openHud();
		UIManager.addScreen(Hud.getInstance());

		//----------------------------------------------------------------------------------------------------------
		HelpScreen.isComingFromMenu = false;
		HighScores.isComingHighScore = false;
		LevelManager.init(pIndex);		
		
		GameStage.getInstance().stage.addEventListener(MouseEvent.CLICK, onClick);
	}
	
	public static function doAction():Void {
		
	}
	
	public static function resumeGame() : Void {
	}
	
	private static function onClick(pEvent:MouseEvent) : Void {
		// To implement
	}
	
	private static function onChange(pValue:Bool) : Void {
		trace(pValue);
	}
	
	public static function pauseGame() : Void {
	}
	
	private static function gameLoop(pEvent:Event) : Void {
		if (LevelManager.isAnimate) return;
		
		if (IsoMovableObject.allMovableObject.length == 0)
			RadarPlayer.getInstance().doAction();
			
		Hud.getInstance().stepsIndication();
		
		for (movable in IsoMovableObject.allMovableObject)
			movable.doAction();			
	}
	
	public static function destroy():Void{
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, gameLoop);
		GameStage.getInstance().stage.removeEventListener(MouseEvent.CLICK, onClick);
	}
}