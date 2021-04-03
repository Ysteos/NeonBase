package com.isartdigital.soko.ui;

import com.isartdigital.soko.game.GameManager;
import com.isartdigital.soko.game.LevelManager;
import com.isartdigital.soko.game.data.SaveManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sound.SoundFX;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.text.LocalizedTextField;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.UIPositionable;
import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.display.SimpleButton;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.display.MovieClip;
import com.isartdigital.soko.ui.HelpScreen;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import com.isartdigital.soko.ui.HighScores;
import com.isartdigital.soko.ui.LevelSelection;

/**
 * ...
 * @author Chadi Husser
 */
class TitleCard extends ResizableScreen 
{
	private static var instance : TitleCard;
	
	private static var isSoundOff: Bool;
	
	private var textNickname: TextField;
	
	private var btnPlay: SimpleButton;
	private var btnHelp: SimpleButton;
	private var btnHighscores: SimpleButton;
	private var btnSound: SimpleButton;
	private var btnLanguage: SimpleButton;
	
	private var btnSoundChildren: Array<MovieClip>;
	
	public static var soundIntroTitleCard : SoundFX; 
	
	private function new() 
	{
		super();
	}
	
	override function init(pEvent:Event):Void {
		super.init(pEvent);
					
		var lFlagFR : MovieClip = cast(content.getChildByName("flagFR"), MovieClip);
		var lFlagEN : MovieClip = cast(content.getChildByName("flagEN"), MovieClip);
		var nicknameText : DisplayObject = content.getChildByName("nicknameText");
		
		var lLogo: MovieClip = cast(content.getChildByName("Logo"));
		
		btnSoundChildren = new Array<MovieClip>();
		
		textNickname = cast(content.getChildByName("nicknameText"), TextField);
		
		btnPlay = cast(content.getChildByName("btnPlay"), SimpleButton);
		btnHelp = cast(content.getChildByName("btnHelp"), SimpleButton);
		btnHighscores = cast(content.getChildByName("btnHighscores"), SimpleButton);
		btnSound = cast(content.getChildByName("btnSound"), SimpleButton);
		btnLanguage = cast(content.getChildByName("btnLanguage"), SimpleButton);
		
		var lSafeZone : Rectangle = GameStage.getInstance().safeZone;
		var lGameContainer : Sprite = GameStage.getInstance().getGameContainer();

		var lPositionnable : UIPositionable = { item: btnHighscores, align : AlignType.TOP,offsetY: lLogo.height + btnPlay.height + nicknameText.height + 350 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: btnHelp, align: AlignType.TOP, offsetY: lLogo.height + btnPlay.height + btnHelp.height + nicknameText.height + 450 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: btnSound, align: AlignType.BOTTOM_RIGHT, offsetX: 250, offsetY: 200 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: btnLanguage, align: AlignType.BOTTOM_LEFT, offsetX: 250, offsetY: 200 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: btnPlay, align: AlignType.TOP, offsetY: lLogo.height + nicknameText.height + 300};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: lLogo, align: AlignType.TOP, offsetY : -30};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: lFlagEN, align: AlignType.BOTTOM_LEFT, offsetX: 250, offsetY: 200};
		positionables.push(lPositionnable); 
		
		lPositionnable = { item: lFlagFR, align: AlignType.BOTTOM_LEFT, offsetX: 250, offsetY: 200};
		positionables.push(lPositionnable);
		
		lPositionnable = { item:nicknameText, align: AlignType.TOP, offsetY: lLogo.height + 150};
		positionables.push(lPositionnable);
		
		onResize();
		
		btnPlay.scaleX = 0;
		btnPlay.scaleY = 0;
		btnHighscores.scaleX = 0;
		btnHighscores.scaleY = 0;
		btnHelp.scaleX = 0;
		btnHelp.scaleY = 0;
		btnSound.scaleX = 0;
		btnSound.scaleY = 0;
		btnLanguage.scaleX = 0;
		btnLanguage.scaleY = 0;
		lFlagEN.scaleX = 0;
		lFlagEN.scaleY = 0;
		lFlagFR.scaleX = 0;
		lFlagFR.scaleY = 0;
		lLogo.alpha = 0;
		nicknameText.alpha = 0;
		
		var lTotalDuration : Float = 0;
		var lDuration : Float;
		//mettre plus vite l'anim
		lDuration = 0.75;
		Actuate.tween(lLogo, lDuration, {alpha : 1});
		lTotalDuration += lDuration / 3;
		Actuate.tween(nicknameText, lDuration, {alpha : 1}, false).delay(lTotalDuration);
		lTotalDuration += lDuration / 6;
		Actuate.tween(btnPlay, lDuration, {scaleX : 1,scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / 3;
		Actuate.tween(btnHighscores, lDuration, {scaleX : 1,scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / 3;
		Actuate.tween(btnHelp, lDuration, {scaleX : 1 , scaleY : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration/3;
		Actuate.tween(btnLanguage, lDuration, {scaleX : 0.5, scaleY : 0.5}).delay(lTotalDuration);
		Actuate.tween(lFlagEN, lDuration, {scaleX : 0.9, scaleY : 0.9}).delay(lTotalDuration);
		Actuate.tween(lFlagFR, lDuration, {scaleX : 0.5, scaleY : 0.5}).delay(lTotalDuration);
		Actuate.tween(btnSound, lDuration, {scaleX :0.5, scaleY : 0.5}).delay(lTotalDuration).onComplete(onTweenCompleted);
		lTotalDuration += lDuration / 3;
			
		if (LocalizedTextField.actualLanguage == "en"){
			lFlagEN.visible = false;
			lFlagFR.visible = true;
		}else if (LocalizedTextField.actualLanguage == "fr"){
			lFlagEN.visible = true;
			lFlagFR.visible = false;
		}
		
		updateWelcomeText(textNickname, SaveManager.getNickame());
		getChildrenOfButton(content.getChildByName("btnSound"));
		
		if (!LoginScreen.isComingLoginScreen && !HelpScreen.isComingFromMenu && !HighScores.isComingHighScore && !LevelSelection.isComingLevelSelection){
			SoundManager.getSound("intro").fadeIn();
		}
		
		LoginScreen.isComingLoginScreen = false;
		LevelSelection.isComingLevelSelection = false;
			
		btnPlay.addEventListener(MouseEvent.CLICK, onClickPlay);
		btnHelp.addEventListener(MouseEvent.CLICK, onClickHelp);
		btnHighscores.addEventListener(MouseEvent.CLICK, onClickHighscores);
		btnSound.addEventListener(MouseEvent.CLICK, onClickSound);
		btnLanguage.addEventListener(MouseEvent.CLICK, onClickLanguage);
		
	}
	
	private function onTweenCompleted():Void {
		
		btnPlay.mouseEnabled = true;
		btnHighscores.mouseEnabled = true;
		btnHelp.mouseEnabled = true;
		btnSound.mouseEnabled = true;
		btnLanguage.mouseEnabled = true;
			
		btnPlay.enabled = true;
		btnPlay.enabled = true;
		btnHighscores.enabled = true;
		btnHelp.enabled = true;
		btnSound.enabled = true;
		btnLanguage.enabled = true;		
	}
	
	private function getChildrenOfButton(pSimpleButton: DisplayObject): Void {
		var lButtonClass: SimpleButton = cast(pSimpleButton, SimpleButton);
		var lContainer: DisplayObjectContainer;
		var lChild: MovieClip;
		
		var lState:Int = 3;
		
		for (i in 0...lState) 
		{
			switch i 
			{
				case 0:
					
					lContainer = cast(lButtonClass.upState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnSoundChildren.push(lChild);
					
				case 1:
					
					lContainer = cast(lButtonClass.downState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnSoundChildren.push(lChild);
					
				case 2:
					
					lContainer = cast(lButtonClass.overState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnSoundChildren.push(lChild);
			}
		}
		
	}
	
	private function updateWelcomeText(pTextField:TextField, pNickname:String):Void {
		pTextField.text += pNickname;
	}
	
	private function onClickLanguage(pEvent:MouseEvent):Void {
		if (LocalizedTextField.actualLanguage == "en"){
			LocalizedTextField.actualLanguage = "fr";
			destroy();
			UIManager.addScreen(getInstance());	
		}else 
		{
			LocalizedTextField.actualLanguage = "en";
			destroy();
			UIManager.addScreen(getInstance());
		}
		
		SoundManager.getSound("click").start();
	}
	
	private function onClickSound(pEvent:MouseEvent):Void {
        isSoundOff = !isSoundOff;
        
        if (isSoundOff){
            SoundManager.getSound("intro").pause();
            for (i in 0...btnSoundChildren.length) {
                btnSoundChildren[i].gotoAndStop(2);
            }
            
        }else {
            SoundManager.getSound("intro").resume();
            for (i in 0...btnSoundChildren.length) {
                btnSoundChildren[i].gotoAndStop(1);
            }
        }
    }
	
	
	private function onClickHighscores(pevent:MouseEvent):Void {
		UIManager.addScreen(HighScores.getInstance());
		SoundManager.getSound("click").start();
	}
	
	private function onClickHelp(pEvent:MouseEvent):Void {
		LevelSelection.isComingLevelSelection = false;
		UIManager.addScreen(HelpScreen.getInstance());
		SoundManager.getSound("click").start();
	}
	
	private function onClickPlay(pEvent:MouseEvent) : Void {
		UIManager.addScreen(LevelSelection.getInstance());
		SoundManager.getSound("click").start();
	}
	
	public static function getInstance() : TitleCard {
		if (instance == null) instance = new TitleCard(); 
		return instance;
	}
	
	override public function destroy():Void {
		btnPlay.removeEventListener(MouseEvent.CLICK, onClickPlay);
		btnHelp.removeEventListener(MouseEvent.CLICK, onClickHelp);
		btnHighscores.removeEventListener(MouseEvent.CLICK, onClickHighscores);
		btnSound.removeEventListener(MouseEvent.CLICK, onClickSound);
		btnLanguage.removeEventListener(MouseEvent.CLICK, onClickLanguage);
		
		instance = null;
		
		super.destroy();
	}
}