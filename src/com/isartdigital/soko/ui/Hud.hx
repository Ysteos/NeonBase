package com.isartdigital.soko.ui;

import com.isartdigital.soko.game.Level;
import com.isartdigital.soko.game.LevelManager;
import com.isartdigital.soko.game.data.SaveManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.text.LocalizedTextField;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPositionable;
import haxe.Json;
import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;

/**
 * ...
 * @author Chadi Husser
 */
class Hud extends Screen 
{
	private static var instance : Hud;
	
	private static var btnRetry : DisplayObject;
	private static var btnRedo : DisplayObject;
	private static var btnUndo : DisplayObject;
	private static var btnQuit : DisplayObject;	
	
	private static var stepsIndicatorContainer: MovieClip;
	private static var parIndicatorContainer: MovieClip;
	
	private static var stepsIndicator: TextField;
	private static var parIndicator: TextField;
	
	private static inline var DIVISION_DURATION_TWEEN : Float = 3;
	
	private var mcLevel : DisplayObject;
	
	public static function getInstance() : Hud {
		if (instance == null) instance = new Hud();
		return instance;
	}
	
	public function new(){
		super();
	}
	
	public function openBtnListeners():Void {
		btnRetry.addEventListener(MouseEvent.CLICK, onClickRetry);
		btnRedo.addEventListener(MouseEvent.CLICK, onClickRedo);
		btnUndo.addEventListener(MouseEvent.CLICK, onClickUndo); 
		btnQuit.addEventListener(MouseEvent.CLICK, onClickQuit); 
	}
	
	public function shutBtnListeners():Void {
		btnRetry.removeEventListener(MouseEvent.CLICK, onClickRetry);
		btnRedo.removeEventListener(MouseEvent.CLICK, onClickRedo);
		btnUndo.removeEventListener(MouseEvent.CLICK, onClickUndo); 
		btnQuit.removeEventListener(MouseEvent.CLICK, onClickQuit); 
	}
	
	override function init(pEvent:Event):Void {
		super.init(pEvent);
		
		LocalizedTextField.translate(LocalizedTextField.getTextField(content));

		btnRetry = content.getChildByName("btnRetry"); 
		btnRedo = content.getChildByName("btnRedo"); 
		btnUndo = content.getChildByName("btnUndo"); 
		btnQuit = content.getChildByName("btnQuit");
		
		openBtnListeners();
		
		var lStep_txt : DisplayObject = content.getChildByName("step_txt");
		var lPar_txt : DisplayObject = content.getChildByName("par_txt");
		var lMcLabelLevel : DisplayObject = content.getChildByName("mcLabelLevel");
		
		mcLevel = content.getChildByName("mcLevel");
		stepsIndicatorContainer = cast(content.getChildByName("mcSteps"), MovieClip);
		parIndicatorContainer = cast(content.getChildByName("mcPar"), MovieClip);
		
		stepsIndicator = cast(stepsIndicatorContainer.getChildAt(0), TextField);
		parIndicator = cast(parIndicatorContainer.getChildAt(0), TextField);
		
		var lPositionnable:UIPositionable;
		
		lPositionnable  = { item:btnQuit , align : AlignType.TOP_RIGHT, offsetX: 200, offsetY:100}
		positionables.push(lPositionnable);
		
		lPositionnable = { item: btnRetry , align :AlignType.TOP_RIGHT, offsetX: 200, offsetY:300}
		positionables.push(lPositionnable);
		
		lPositionnable = { item: btnRedo, align : AlignType.BOTTOM_RIGHT,offsetX: 900 , offsetY:100}
		positionables.push(lPositionnable);
		
		lPositionnable = { item: btnUndo, align : AlignType.BOTTOM_RIGHT,offsetX: 300, offsetY:100}
		positionables.push(lPositionnable);
		
		if (LocalizedTextField.actualLanguage == "en"){
			lPositionnable = { item: lStep_txt, align : AlignType.BOTTOM_LEFT,offsetX : 250, offsetY : 400}
			positionables.push(lPositionnable);
			
			lPositionnable = { item: stepsIndicatorContainer, align : AlignType.BOTTOM_LEFT, offsetX : 615, offsetY : 345}
			positionables.push(lPositionnable);
			
			lPositionnable = { item: lPar_txt, align : AlignType.BOTTOM_LEFT,offsetX: 250, offsetY : 300}
			positionables.push(lPositionnable);
			
			lPositionnable = { item: parIndicatorContainer, align : AlignType.BOTTOM_LEFT,offsetX: 540, offsetY : 248}
			positionables.push(lPositionnable);
			
			lPositionnable = { item: mcLevel, align : AlignType.BOTTOM_LEFT,offsetX: 480, offsetY : 190}
			positionables.push(lPositionnable);
			
			lPositionnable = { item: content.getChildByName("mcPannel"), align : AlignType.BOTTOM_LEFT,offsetX: 400, offsetY : 320}
			positionables.push(lPositionnable);
			
		}else if (LocalizedTextField.actualLanguage == "fr"){
			lPositionnable = { item: lStep_txt, align : AlignType.BOTTOM_LEFT,offsetX : 250, offsetY : 400}
			positionables.push(lPositionnable);
			
			lPositionnable = { item: stepsIndicatorContainer, align : AlignType.BOTTOM_LEFT, offsetX : 570, offsetY : 345}
			positionables.push(lPositionnable);
			
			lPositionnable = { item: lPar_txt, align : AlignType.BOTTOM_LEFT,offsetX: 250, offsetY : 300}
			positionables.push(lPositionnable);
			
			lPositionnable = { item: parIndicatorContainer, align : AlignType.BOTTOM_LEFT,offsetX: 540, offsetY : 248}
			positionables.push(lPositionnable);
			
			lPositionnable = { item: mcLevel, align : AlignType.BOTTOM_LEFT,offsetX: 520, offsetY : 190}
			positionables.push(lPositionnable);
			
			lPositionnable = { item: content.getChildByName("mcPannel"), align : AlignType.BOTTOM_LEFT,offsetX: 400, offsetY : 320}
			positionables.push(lPositionnable);	
		}
		
		lPositionnable = { item: lMcLabelLevel, align : AlignType.BOTTOM_LEFT,offsetX: 250, offsetY : 190}
		positionables.push(lPositionnable);
		
		
		onResize();
		
		btnRetry.scaleX = 0;
		btnRetry.scaleY = 0;
		btnRedo.scaleX = 0;
		btnRedo.scaleY = 0;
		btnUndo.scaleX = 0;
		btnUndo.scaleY = 0;
		btnQuit.scaleX = 0;
		btnQuit.scaleY = 0;
		lStep_txt.alpha = 0;
		lPar_txt.alpha = 0;
		mcLevel.alpha = 0;
		stepsIndicatorContainer.alpha = 0;
		parIndicatorContainer.alpha = 0;
		content.getChildByName("mcPannel").alpha = 0;
		lMcLabelLevel.alpha = 0;
		
		content.getChildByName("mcPannel").scaleX = 0.8;
		content.getChildByName("mcPannel").scaleY = 0.8;
		
		var lTotalDuration : Float = 0;
		var lDuration : Float;
		
		var lScaleButton : Float = 0.5;
		
		lDuration = 1;
		Actuate.tween(btnRetry, lDuration, {scaleX : lScaleButton, scaleY : lScaleButton}, false);
		lTotalDuration += lDuration / DIVISION_DURATION_TWEEN;
		Actuate.tween(btnUndo, lDuration, {scaleX : 0.9, scaleY : 0.8},false).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_DURATION_TWEEN;
		Actuate.tween(btnRedo, lDuration, {scaleX : 0.9, scaleY : 0.8}, false).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_DURATION_TWEEN;
		Actuate.tween(btnQuit, lDuration, {scaleX : lScaleButton, scaleY : lScaleButton}, false).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_DURATION_TWEEN;
		Actuate.tween(content.getChildByName("mcPannel"), lDuration, {alpha : 1},false).delay(lTotalDuration);
		Actuate.tween(lStep_txt, lDuration, {alpha : 1},false).delay(lTotalDuration);
		Actuate.tween(lPar_txt, lDuration, {alpha : 1}, false).delay(lTotalDuration);
		Actuate.tween(stepsIndicatorContainer, lDuration, {alpha : 1}, false).delay(lTotalDuration);
		Actuate.tween(parIndicatorContainer, lDuration, {alpha : 1},false).delay(lTotalDuration);
		Actuate.tween(mcLevel, lDuration, {alpha : 1}, false).delay(lTotalDuration);
		Actuate.tween(lMcLabelLevel, lDuration, {alpha : 1}, false).delay(lTotalDuration);
		
		cast (mcLevel, TextField).text = "" + LevelManager.currentNumberLevel;
	}
	
	public function stepsIndication():Void{
		stepsIndicator.text = "" + LevelManager.movementIndex;
	}
	
	public function numberPar(pLevel:UInt) :Float{
		var lParData: String = GameLoader.getText("assets/levels/leveldesign.json");
		var lJsonLevelDesign: Dynamic = Json.parse(lParData);
		var LtypePar : Array<Level>;
		
		LtypePar = Reflect.field(lJsonLevelDesign, "levelDesign");
		
		parIndicator.text = "" + LtypePar[pLevel].par;
		
		return LtypePar[pLevel].par;
	}
	
	private function onClickQuit(pEvent:MouseEvent):Void{
		LevelManager.quit();
		HighScores.scoreFinal = 0;
		for (i in 0...LevelSelection.allstars.length){
			HighScores.scoreFinal += LevelSelection.allstars[i];
		}
		SaveManager.initHighScore();
		SaveManager.saveAllPseudo();
		SaveManager.saveScoreFinal();
		SaveManager.setHighScore();
		
		LevelSelection.isComingLevelSelection = false;

		UIManager.addScreen(TitleCard.getInstance());
		
		SoundManager.getSound("click").start();	
	}
	
	private function onClickUndo(pEvent:MouseEvent):Void {
		// Implement UNDO
		SoundManager.getSound("click").start();
		LevelManager.undo();
	}
	
	private function onClickRetry(pEvent:MouseEvent):Void {
		// Implement RETRY
		SoundManager.getSound("click").start();
		LevelManager.retry();		
	}
	
	private function onClickRedo(pEvent:MouseEvent):Void {
		// Implement REDO
		SoundManager.getSound("click").start();
		LevelManager.redo();
	}
	
	override public function destroy():Void {
		content.getChildByName("btnRetry").removeEventListener(MouseEvent.CLICK, onClickRetry);
		content.getChildByName("btnRedo").removeEventListener(MouseEvent.CLICK, onClickRedo);
		content.getChildByName("btnUndo").removeEventListener(MouseEvent.CLICK, onClickUndo);
		content.getChildByName("btnQuit").removeEventListener(MouseEvent.CLICK, onClickQuit);
		
		super.destroy();

		instance = null;		
	}
}