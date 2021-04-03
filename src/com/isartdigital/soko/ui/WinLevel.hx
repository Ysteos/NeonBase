package com.isartdigital.soko.ui;

import com.isartdigital.soko.game.GameManager;
import com.isartdigital.soko.game.LevelManager;
import com.isartdigital.soko.game.data.SaveManager;
import com.isartdigital.soko.ui.UIManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.UIPositionable;
import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.display.MovieClip;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import com.isartdigital.soko.ui.Hud;
import openfl.geom.Point;
import openfl.text.TextField;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;
	
/**
 * ...
 * @author Jordan Sallot
 */
class WinLevel extends ResizableScreen{
	
	/**
	 * instance unique de la classe WinLevel
	 */
	private static var instance: WinLevel;
	
	private static var particleSystem :ParticleSystem;
		
	private static inline var SCORE_DEUX_ETOILES:UInt = 20;
	private static inline var SCORE_UNE_ETOILE:UInt = 40;
		
	private var btnNext: SimpleButton;
	private var btnQuit: SimpleButton;
	
	private var txtPar : DisplayObject;
	
	public static var isWin : Bool;
	public static var isComingWinLevelScreen : Bool;
	
	private var counter: Int = 15;
	private var stopTime: Int = 0;
		
	private static inline var GLOBALTIME: Int = 120;
	
	private static inline var DIVISION_TOTAL_DURATION : Float = 3.5;
		
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): WinLevel {
		if (instance == null) instance = new WinLevel();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() {
		super();
	}
	
	override function init(pEvent:Event):Void {
		super.init(pEvent);
		// faire les resize pour le txtPar, le groupe stars win level et le txtSteps
		
		var lParticleRenderer = DefaultParticleRenderer.createInstance();
		background.addChild(cast lParticleRenderer);
		
		particleSystem = ParticleLoader.load("assets/particles/winLevel/particle.plist");
		lParticleRenderer.addParticleSystem(particleSystem);
		
		HighScores.scoreFinal = 0;
		for (i in 0...LevelSelection.allstars.length){
			HighScores.scoreFinal += LevelSelection.allstars[i];
		}
		
		btnNext = cast(content.getChildByName("btnNext"), SimpleButton);
		btnQuit = cast(content.getChildByName("btnQuit"), SimpleButton);
		
		txtPar  = content.getChildByName("txtPar");
		
		var ltxtSteps : DisplayObject  = content.getChildByName("txtSteps");
		
		var lMcTitle : DisplayObject = content.getChildByName("mcTitle");
		var lMcmessage : DisplayObject = content.getChildByName("mcMessage");
		var lMcScore : DisplayObject = content.getChildByName("mcScore");
		
		var lMcTrophy0: DisplayObject = content.getChildByName("mcTrophy0");
		var lMcTrophy1: DisplayObject = content.getChildByName("mcTrophy1");
		
		btnNext.addEventListener(MouseEvent.CLICK, onClickNext);
		btnQuit.addEventListener(MouseEvent.CLICK, onClickQuit);
		
		var lPositionnable : UIPositionable = { item: btnNext, align : AlignType.BOTTOM, offsetY : 290};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: btnQuit, align : AlignType.BOTTOM , offsetY : 100};
        positionables.push(lPositionnable);
		
		lPositionnable = { item: lMcTitle, align : AlignType.TOP , offsetY : 50};
        positionables.push(lPositionnable);
        
        lPositionnable = { item: lMcTrophy0, align : AlignType.LEFT , offsetX : 500};
        positionables.push(lPositionnable);
        
        lPositionnable = { item: lMcTrophy1, align : AlignType.RIGHT , offsetX : 500};
        positionables.push(lPositionnable);
        
        lPositionnable = { item: txtPar, align : AlignType.CENTER , offsetY : ltxtSteps.height + 100};
        positionables.push(lPositionnable);
        
        lPositionnable = { item: ltxtSteps, align : AlignType.CENTER , offsetY : 100};
        positionables.push(lPositionnable);
        
        lPositionnable = { item: lMcScore, align : AlignType.CENTER , offsetY : -200};
        positionables.push(lPositionnable);
		
		onResize();
		
		var lTotalDuration : Float = 0;
		var lDuration : Float;
		
		lMcTitle.alpha = 0;
		lMcmessage.alpha = 0;
		lMcScore.alpha = 0;
		btnNext.scaleX = 0;
		btnNext.scaleY = 0;
		btnQuit.scaleX = 0;
		btnQuit.scaleY = 0;
		txtPar.alpha = 0;
		ltxtSteps.alpha = 0;
		
		//mettre plus vite l'anim 
		lDuration = 1;
		Actuate.tween(lMcTitle, lDuration, {alpha : 1});
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lMcmessage, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lMcScore, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(txtPar, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(ltxtSteps, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnNext, lDuration, {scaleX : 1, scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnQuit, lDuration, {scaleX : 0.4, scaleY : 0.4}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		
		nbEtoile(content.getChildByName("mcScore"));
		
		cast (txtPar,TextField).text += "" + Hud.getInstance().numberPar(LevelManager.currentNumberLevelBeforeWin);
		cast (ltxtSteps, TextField).text += "" + LevelManager.movementIndex;
		
		addEventListener(Event.ENTER_FRAME, particleLoop);
		
	}
	
	private function onClickQuit(pEvent:MouseEvent):Void {
		HighScores.scoreFinal = 0;
		for (i in 0...LevelSelection.allstars.length){
			HighScores.scoreFinal += LevelSelection.allstars[i];
		}
		SaveManager.initHighScore();
		SaveManager.saveAllPseudo();
		SaveManager.saveScoreFinal();
		SaveManager.setHighScore();
		
		LevelSelection.isComingLevelSelection = false;
		
		UIManager.addScreen(LevelSelection.getInstance());
		
		SoundManager.getSound("click").start();
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
	
	public function nbEtoile(pScore:DisplayObject):Void{
		var lScore : TextField = cast(pScore, TextField);
		var lCurrentNumberLevelBeforeWin : Int = LevelManager.currentNumberLevelBeforeWin;
		var lMovementIndex : Int = LevelManager.movementIndex; 
		var lNumberPar : Float = Hud.getInstance().numberPar(lCurrentNumberLevelBeforeWin);
		var lNumberStars : Int = 0;
		
		if (lMovementIndex <= lNumberPar){
			lNumberStars = 30;
		}
		if (lMovementIndex >= lNumberPar + SCORE_UNE_ETOILE){
			lNumberStars = 10;
		}else if ((lMovementIndex > lNumberPar) && (lMovementIndex <= lNumberPar + SCORE_UNE_ETOILE)){
			lNumberStars = 20;
		}
		if (LevelSelection.allstars[lCurrentNumberLevelBeforeWin] < lNumberStars){
			LevelSelection.allstars[lCurrentNumberLevelBeforeWin] = lNumberStars;
		}
				
		lScore.text = "Score : " + lNumberStars + "/30";
		
		SaveManager.saveDataProperty("ActualLevel", LevelManager.currentNumberLevelBeforeWin);		
		SaveManager.saveDataProperty("NumberStars", LevelSelection.allstars);	
		SaveManager.initHighScore();
		SaveManager.saveAllPseudo();
		SaveManager.saveScoreFinal();
		SaveManager.setHighScore();
		SaveManager.saveDatatoFile();
		
	}
	
	
	private function onClickNext(pEvent:MouseEvent):Void {
		clickSound.start();
		isComingWinLevelScreen = true;
		LevelManager.retry();
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {	
		btnNext.removeEventListener(MouseEvent.CLICK, onClickNext);
		btnQuit.removeEventListener(MouseEvent.CLICK, onClickQuit);
		
		removeEventListener(Event.ENTER_FRAME, particleLoop);
		
		instance = null;
		
		super.destroy();
	}

}