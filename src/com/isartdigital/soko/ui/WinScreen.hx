package com.isartdigital.soko.ui;

import com.isartdigital.soko.game.LevelManager;
import com.isartdigital.soko.game.data.SaveManager;
import com.isartdigital.utils.sound.SoundFX;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.UIPositionable;
import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import com.isartdigital.soko.ui.WinLevel;
import com.isartdigital.soko.ui.HighScores;
import openfl.text.TextField;
import openfl.geom.Point;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;
	
/**
 * ...
 * @author Jordan Sallot
 */
class WinScreen extends ResizableScreen {
	
	/**
	 * instance unique de la classe WinScreen
	 */
	private static var instance: WinScreen;
	
	private static var particleSystem :ParticleSystem;
	
	private var btnHighscores: SimpleButton;
	private var btnMenu: SimpleButton;
	
	public static var isComingWinScreen:Bool;
	public static var soundIntro : SoundFX;
	
	private static inline var DIVISION_TOTAL_DURATION : Float = 3.5;
	
	private static inline var SCORE_DEUX_ETOILES:UInt = 20;
	private static inline var SCORE_UNE_ETOILE:UInt = 40;
	
	private var counter: Int = 15;
	private var stopTime: Int = 0;
	
	private static inline var GLOBALTIME: Int = 120;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): WinScreen {
		if (instance == null) instance = new WinScreen();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() {
		super();
		isComingWinScreen = true;
		soundIntro = SoundManager.getSound("intro");
	}
	
	override function init(pEvent:Event):Void {
		super.init(pEvent);
		HighScores.scoreFinal = 0;
		
		var lParticleRenderer = DefaultParticleRenderer.createInstance();
		background.addChild(cast lParticleRenderer);
		
		particleSystem = ParticleLoader.load("assets/particles/winLevel/particle.plist");
		lParticleRenderer.addParticleSystem(particleSystem);
		
		
		for (i in 0...LevelSelection.allstars.length){
			HighScores.scoreFinal += LevelSelection.allstars[i];
		}
		
		btnHighscores = cast(content.getChildByName("btnHighScores"), SimpleButton);
		btnMenu = cast(content.getChildByName("btnMenu"), SimpleButton); 
		
		btnHighscores.addEventListener(MouseEvent.CLICK, onClickHighScores);
		btnMenu.addEventListener(MouseEvent.CLICK, onClickMenu);
		
		var lMcTitle : DisplayObject = content.getChildByName("mcTitle");
		var lMcMessage1 : DisplayObject = content.getChildByName("mcMessage1");
		var lMcMessage2 : DisplayObject = content.getChildByName("mcMessage2");
		var lMcScore : DisplayObject = content.getChildByName("mcScore");
		
		var lPositionnable : UIPositionable = { item: btnMenu, align : AlignType.BOTTOM, offsetY : 200};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: btnHighscores, align : AlignType.BOTTOM, offsetY : 500};
		positionables.push(lPositionnable); 
		
		lPositionnable = {item: lMcTitle, align : AlignType.TOP, offsetY : -50, offsetX : 100};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: lMcMessage1, align : AlignType.TOP, offsetY : 250 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: lMcMessage2, align : AlignType.LEFT, offsetX : 50 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: lMcScore, align : AlignType.TOP, offsetY : 500 };
		positionables.push(lPositionnable);
		
		onResize();
		
		addEventListener(Event.ENTER_FRAME, particleLoop);
		
		var lTotalDuration : Float = 0;
		var lDuration : Float;
		
		lMcTitle.alpha = 0;
		lMcMessage1.alpha = 0;
		lMcMessage2.alpha = 0;		
		btnHighscores.scaleX = 0;
		btnHighscores.scaleY = 0;
		btnMenu.scaleX = 0;
		btnMenu.scaleY = 0;
		lMcScore.alpha = 0;
		
		lDuration = 1;
		Actuate.tween(lMcTitle, lDuration, {alpha : 1});
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lMcMessage1, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lMcScore, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnHighscores, lDuration, {scaleX : 1, scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnMenu, lDuration, {scaleX : 1, scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lMcMessage2, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		
		SaveManager.initHighScore();
		SaveManager.saveAllPseudo();
		SaveManager.saveScoreFinal();
		SaveManager.setHighScore();
		
		LevelManager.quit();
		
		WinLevel.getInstance().nbEtoile(content.getChildByName("mcScore"));
	}
	
	private function particleLoop(pEvent:Event):Void {
		
		if (counter++ >= GLOBALTIME) {
			
			var lRandomPos: Point = new Point(Math.round(Math.random() * background.width), Math.round(Math.random() * background.height));
			
			particleSystem.emit(lRandomPos.x, lRandomPos.y);
			counter = 0;
		} 
		
		if (stopTime++ >= GLOBALTIME) {
			particleSystem.stop();
			stopTime = 0;
		}	
	}
	
	private function onClickMenu(pEvent:MouseEvent):Void {
		clickSound.start();
		soundIntro.fadeIn();
		UIManager.addScreen(LevelSelection.getInstance());
	}
	
	private function onClickHighScores(pEvent:MouseEvent):Void {
		clickSound.start();
		soundIntro.fadeIn();
		UIManager.addScreen(HighScores.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		btnHighscores.removeEventListener(MouseEvent.CLICK, onClickHighScores);
		btnMenu.removeEventListener(MouseEvent.CLICK, onClickHighScores);
		
		removeEventListener(Event.ENTER_FRAME, particleLoop);
		
		instance = null;
		
		super.destroy();
	}

}