package com.isartdigital.soko.ui;

import animateAtlasPlayer.core.MovieBehavior;
import com.isartdigital.soko.game.GameManager;
import com.isartdigital.soko.game.Level;
import com.isartdigital.soko.game.LevelManager;
import com.isartdigital.soko.game.data.SaveManager;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sound.SoundFX;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import haxe.Json;
import js.html.svg.Number;
import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import com.isartdigital.utils.ui.UIPositionable;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;

	
/**
 * ...
 * @author Jordan Sallot
 */
class LevelSelection extends ResizableScreen {
	
	/**
	 * instance unique de la classe LevelSelection
	 */
	private static var instance: LevelSelection;
	private static inline var DIVISION_TOTAL_DURATION : Float = 8;
	
	public static var numberLevelUnlock : Int = 0;
	public static var allstars : Array<Int> = new Array<Int>();
			
	// Boutons de l'UI
	private var btnUnlock: SimpleButton;
	private var btnBack:SimpleButton;
	
	private static inline var NB_OF_STATE:Int = 3;
	        
	// Boutons des niveaux
	private var btnLevel0 : SimpleButton;
	private var	btnLevel1 : SimpleButton;
	private var	btnLevel2 : SimpleButton;
	private var	btnLevel3 : SimpleButton;
	private var	btnLevel4 : SimpleButton;
	private var	btnLevel5 : SimpleButton;
	private var	btnLevel6 : SimpleButton;
	private var	btnLevel8 : SimpleButton;
	private var	btnLevel7 : SimpleButton;
		
	public static var introSounWinScreen : SoundFX;
	public static var isComingLevelSelection : Bool;
	
	private var btnChildren: Array<MovieClip>;
	
	private var score0 : DisplayObject;
	private var score1 : DisplayObject;
	private var score2 : DisplayObject;
	private var score3 : DisplayObject;
	private var score4 : DisplayObject;
	private var score5 : DisplayObject;
	private var score6 : DisplayObject;
	private var score7 : DisplayObject;
	private var score8 : DisplayObject;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LevelSelection {
		if (instance == null) instance = new LevelSelection();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() {
		super();
		for (i in 0...9){
			if (!SaveManager.get_saveData().data.NumberStars){
				allstars.push(0);
			}else{
				SaveManager.loadData;
			}
		}
		isComingLevelSelection = true;
	}
	
	override function init(pEvent:Event):Void {
		super.init(pEvent);
		
		btnChildren = new Array<MovieClip>();
		
		score0 = cast(content.getChildByName("mcScore0"),MovieClip);
		score1 = cast(content.getChildByName("mcScore1"),MovieClip);
		score2 = cast(content.getChildByName("mcScore2"),MovieClip);
		score3 = cast(content.getChildByName("mcScore3"),MovieClip);
		score4 = cast(content.getChildByName("mcScore4"),MovieClip);
		score5 = cast(content.getChildByName("mcScore5"),MovieClip);
		score6 = cast(content.getChildByName("mcScore6"),MovieClip);
		score7 = cast(content.getChildByName("mcScore7"),MovieClip);
		score8 = cast(content.getChildByName("mcScore8"), MovieClip);
				
		score0.scaleX = 0;
		score0.scaleY = 0;
		score1.scaleX = 0;
		score1.scaleY = 0;
		score2.scaleX = 0;
		score2.scaleY = 0;
		score3.scaleX = 0;
		score3.scaleY = 0;
		score4.scaleX = 0;
		score4.scaleY = 0;
		score5.scaleX = 0;
		score5.scaleY = 0;
		score6.scaleX = 0;
		score6.scaleY = 0;
		score7.scaleX = 0;
		score7.scaleY = 0;
		score8.scaleX = 0;
		score8.scaleY = 0;
		
		btnUnlock = cast(content.getChildByName("btnUnlock"), SimpleButton);
		btnBack = cast(content.getChildByName("btnBack"), SimpleButton);
		
		btnLevel0 = cast(content.getChildByName("btnLevel0"), SimpleButton);
		btnLevel1 = cast(content.getChildByName("btnLevel1"), SimpleButton);
		btnLevel2 = cast(content.getChildByName("btnLevel2"), SimpleButton);
		btnLevel3 = cast(content.getChildByName("btnLevel3"), SimpleButton);
		btnLevel4 = cast(content.getChildByName("btnLevel4"), SimpleButton);
		btnLevel5 = cast(content.getChildByName("btnLevel5"), SimpleButton);
		btnLevel6 = cast(content.getChildByName("btnLevel6"), SimpleButton);
		btnLevel8 = cast(content.getChildByName("btnLevel8"), SimpleButton);
		btnLevel7 = cast(content.getChildByName("btnLevel7"), SimpleButton);
		
		btnUnlock.addEventListener(MouseEvent.CLICK, onClickUnlock);
		btnBack.addEventListener(MouseEvent.CLICK, onClickBack);
		
		btnLevel0.addEventListener(MouseEvent.CLICK, onClickTuto);
		btnLevel1.addEventListener(MouseEvent.CLICK, onClickLevel1);
		btnLevel2.addEventListener(MouseEvent.CLICK, onClickLevel2);
		btnLevel3.addEventListener(MouseEvent.CLICK, onClickLevel3);
		btnLevel4.addEventListener(MouseEvent.CLICK, onClickLevel4);
		btnLevel5.addEventListener(MouseEvent.CLICK, onClickLevel5);
		btnLevel6.addEventListener(MouseEvent.CLICK, onClickLevel6);
		btnLevel8.addEventListener(MouseEvent.CLICK, onClickLevel8);
		btnLevel7.addEventListener(MouseEvent.CLICK, onClickLevel7);
		
		var lPositionnable : UIPositionable = { item: btnUnlock, align : AlignType.TOP_RIGHT, offsetX : 200, offsetY : 100};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: btnBack, align : AlignType.BOTTOM_LEFT, offsetX : 200, offsetY : 100};
		positionables.push(lPositionnable);
		
		btnLevel0.scaleX = 0;
		btnLevel0.scaleY = 0;
		btnLevel1.scaleX = 0;
		btnLevel1.scaleY = 0;
		btnLevel2.scaleX = 0;
		btnLevel2.scaleY = 0;
		btnLevel3.scaleX = 0;
		btnLevel3.scaleY = 0;
		btnLevel4.scaleX = 0;
		btnLevel4.scaleY = 0;
		btnLevel5.scaleX = 0;
		btnLevel5.scaleY = 0;
		btnLevel6.scaleX = 0;
		btnLevel6.scaleY = 0;
		btnLevel8.scaleX = 0;
		btnLevel8.scaleY = 0;
		btnLevel7.scaleX = 0;
		btnLevel7.scaleY = 0;
		
		btnBack.scaleX = 0;
		btnBack.scaleY = 0;
		btnUnlock.scaleX = 0;
		btnUnlock.scaleY = 0;
		
		var lTotalDuration : Float = 0;
		var lDuration : Float;
		
		var lScaleButton :Float = 0.85;
		
		//mettre plus vite l'anim 
		onResize();
		
		//mettre plus vite l'anim 
		lDuration = 1;
		Actuate.tween(btnLevel0, lDuration, {scaleX:lScaleButton,scaleY:lScaleButton});
		Actuate.tween(score0, lDuration, {scaleX : 1, scaleY : 1});
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnLevel1, lDuration, {scaleX:lScaleButton, scaleY:lScaleButton}).delay(lTotalDuration);
		Actuate.tween(score1, lDuration, {scaleX : 1, scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnLevel2, lDuration, {scaleX:lScaleButton, scaleY:lScaleButton}).delay(lTotalDuration);
		Actuate.tween(score2, lDuration, {scaleX : 1,scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnLevel3, lDuration, {scaleX:lScaleButton, scaleY:lScaleButton}).delay(lTotalDuration);
		Actuate.tween(score3, lDuration, {scaleX : 1,scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnLevel4, lDuration, {scaleX:lScaleButton, scaleY:lScaleButton}).delay(lTotalDuration);
		Actuate.tween(score4, lDuration, {scaleX : 1, scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnLevel5, lDuration, {scaleX:lScaleButton, scaleY:lScaleButton}).delay(lTotalDuration);
		Actuate.tween(score5, lDuration, {scaleX : 1, scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnLevel6, lDuration, {scaleX:lScaleButton, scaleY:lScaleButton}).delay(lTotalDuration);
		Actuate.tween(score6, lDuration, {scaleX : 1, scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnLevel7, lDuration, {scaleX:lScaleButton, scaleY:lScaleButton}).delay(lTotalDuration);
		Actuate.tween(score7, lDuration, {scaleX : 1, scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(btnLevel8, lDuration, {scaleX:lScaleButton, scaleY:lScaleButton}).delay(lTotalDuration);
		Actuate.tween(score8, lDuration, {scaleX : 1, scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION * 2;
		Actuate.tween(btnBack, lDuration, {scaleX : 0.5,scaleY : 0.5}).delay(lTotalDuration);
		Actuate.tween(btnUnlock, lDuration, {scaleX : 0.5,scaleY : 0.5}).delay(lTotalDuration);
		
		nbEtoile();
		
		for (i in 1...9) {
			getChildrenOfButton(content.getChildByName("btnLevel" + i));
			cast (cast (content.getChildByName("mcScore" + i), MovieClip).getChildByName("mcText"), TextField).mouseEnabled = false;
		}
		
		cast(cast (score0,MovieClip).getChildByName("mcText"),TextField).mouseEnabled= false;
		cast(cast (score1,MovieClip).getChildByName("mcText"),TextField).mouseEnabled= false;
		cast(cast (score2,MovieClip).getChildByName("mcText"),TextField).mouseEnabled= false;
		cast(cast (score3,MovieClip).getChildByName("mcText"),TextField).mouseEnabled= false;
		cast(cast (score4,MovieClip).getChildByName("mcText"),TextField).mouseEnabled= false;
		cast(cast (score5,MovieClip).getChildByName("mcText"),TextField).mouseEnabled= false;
		cast(cast (score6,MovieClip).getChildByName("mcText"),TextField).mouseEnabled= false;
		cast(cast (score7,MovieClip).getChildByName("mcText"),TextField).mouseEnabled= false;
		cast(cast (score8, MovieClip).getChildByName("mcText"), TextField).mouseEnabled = false;
		
		applyState();
		
		SaveManager.saveDataProperty("ActualLevel", LevelManager.currentNumberLevelBeforeWin);	
		SaveManager.saveDatatoFile();
	}
	
	private function applyState():Void {
		var lNumber:Int = NB_OF_STATE * numberLevelUnlock;
		
		for (i in 0...lNumber) {
			btnChildren[i].gotoAndStop(2);
		}
	}
	
	public function nbEtoile():Void{
		for (i in 0...allstars.length){
			var lAllScore : MovieClip = cast (content.getChildByName("mcScore" + i), MovieClip);
			cast (lAllScore.getChildByName("mcText"), TextField).text = "score : " + allstars[i] + "/30";
		}
	}
	
	private function getChildrenOfButton(pSimpleButton: DisplayObject): Void {
		var lButtonClass: SimpleButton = cast(pSimpleButton, SimpleButton);
		var lContainer: DisplayObjectContainer;
		var lChild: MovieClip;
		
		for (i in 0...NB_OF_STATE)
		{
			switch i 
			{
				case 0:
					
					lContainer = cast(lButtonClass.upState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnChildren.push(lChild);
					
				case 1:
					
					lContainer = cast(lButtonClass.downState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnChildren.push(lChild);
					
				case 2:
					
					lContainer = cast(lButtonClass.overState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnChildren.push(lChild);
			}
		}
	}
	
	private function onClickLevel8(pEvent:MouseEvent):Void {
		if (numberLevelUnlock >= 8) {
			SoundManager.getSound("intro").stop();
			GameManager.start(8);
		} else {
			SoundManager.getSound("lockedlevel").start();
		}
	}
	
	private function onClickLevel7(pEvent:MouseEvent):Void {
		if (numberLevelUnlock >= 7) {
			SoundManager.getSound("intro").stop();
			GameManager.start(7);
		} else {
			SoundManager.getSound("lockedlevel").start();
		}
	}
	
	private function onClickLevel6(pEvent:MouseEvent):Void {
		if (numberLevelUnlock >= 6) {
			SoundManager.getSound("intro").stop();
			GameManager.start(6);
		} else {
			SoundManager.getSound("lockedlevel").start();
		}
	}
	
	private function onClickLevel5(pEvent:MouseEvent):Void {
		if (numberLevelUnlock >= 5) {
			SoundManager.getSound("intro").stop();
			GameManager.start(5);
		} else {
			SoundManager.getSound("lockedlevel").start();
		}
	}
	
	private function onClickLevel4(pEvent:MouseEvent):Void {
		if (numberLevelUnlock >= 4){
			SoundManager.getSound("intro").stop();
			GameManager.start(4);
		} else {
			SoundManager.getSound("lockedlevel").start();
		}
	}
	
	private function onClickLevel3(pEvent:MouseEvent):Void {	
		if (numberLevelUnlock >= 3){
			SoundManager.getSound("intro").stop();
			GameManager.start(3);
		} else {
			SoundManager.getSound("lockedlevel").start();
		}
	}
	
	private function onClickLevel2(pEvent:MouseEvent):Void {
		if (numberLevelUnlock >= 2){
			SoundManager.getSound("intro").stop();
			GameManager.start(2);
		} else {
			SoundManager.getSound("lockedlevel").start();
		}
	}
	
	private function onClickLevel1(pEvent:MouseEvent):Void {
		if (numberLevelUnlock >= 1) {
			SoundManager.getSound("intro").stop();
			GameManager.start(1);
		} else {
			SoundManager.getSound("lockedlevel").start();
		}
	}
	
	private function onClickTuto(pEvent:MouseEvent):Void {
		HelpScreen.isComingFromMenu = false;
		UIManager.addScreen(HelpScreen.getInstance());
	}
	
	private function onClickBack(pEvent:MouseEvent):Void {
		SoundManager.getSound("click").start();
		UIManager.addScreen(TitleCard.getInstance());
	}
	
	private function onClickUnlock(pEvent:MouseEvent):Void {
		SoundManager.getSound("click").start();
		
		if (SaveManager.get_saveData().data.ActualLevel == 0){
			numberLevelUnlock = 8;
		}else{
			numberLevelUnlock += 8 - cast (SaveManager.get_saveData().data.ActualLevel, Int) -1;
		}
									
		applyState();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		btnUnlock.removeEventListener(MouseEvent.CLICK, onClickUnlock);
		btnBack.removeEventListener(MouseEvent.CLICK, onClickBack);
		
		btnLevel0.removeEventListener(MouseEvent.CLICK, onClickTuto);
		btnLevel1.removeEventListener(MouseEvent.CLICK, onClickLevel1);
		btnLevel2.removeEventListener(MouseEvent.CLICK, onClickLevel2);
		btnLevel3.removeEventListener(MouseEvent.CLICK, onClickLevel3);
		btnLevel4.removeEventListener(MouseEvent.CLICK, onClickLevel4);
		btnLevel5.removeEventListener(MouseEvent.CLICK, onClickLevel5);
		btnLevel6.removeEventListener(MouseEvent.CLICK, onClickLevel6);
		btnLevel8.removeEventListener(MouseEvent.CLICK, onClickLevel7);
		btnLevel7.removeEventListener(MouseEvent.CLICK, onClickLevel8);
		
		instance = null;
		
		super.destroy();
	}
}