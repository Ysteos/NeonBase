 package com.isartdigital.soko.ui;

import com.isartdigital.soko.game.data.SaveManager;
import com.isartdigital.soko.game.data.AllPseudo;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sound.SoundFX;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.text.LocalizedTextField;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPositionable;
import js.html.svg.Number;
import motion.Actuate;
import motion.easing.Back;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.ui.Keyboard;

	
/**
 * ...
 * @author 
 */
class LoginScreen extends ResizableScreen 
{
	
	/**
	 * instance unique de la classe EcranDeLogin
	 */
	private static var instance: LoginScreen;
		
	private var txtLogin : DisplayObject;
	private var btnOk : DisplayObject;	
	
	static public var soundIntro : SoundFX ;
	static public var isComingLoginScreen:Bool = true;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LoginScreen {
		if (instance == null) instance = new LoginScreen();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() 
	{
		super();
		soundIntro = SoundManager.getSound("intro");
		soundIntro.fadeIn();
	}
	
	override function init(pEvent:Event):Void {
		super.init(pEvent);
		var lLoginTitle : DisplayObject = content.getChildByName("login_title");
		var lBackground_login_txt : DisplayObject = content.getChildByName("background_login_txt");
		
		var lScreenContainer : Sprite = GameStage.getInstance().getScreensSprite();
		var lSafeZone : Rectangle = GameStage.getInstance().safeZone;
		
		btnOk = content.getChildByName("btnOk");
		txtLogin = content.getChildByName("txtLogin");

		txtLogin.addEventListener(MouseEvent.CLICK, suprressionTxtStart);
	
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
		btnOk.addEventListener(MouseEvent.CLICK, onClick);
		
		var lPositionnable : UIPositionable = {item:btnOk , align : AlignType.BOTTOM, offsetY : 135};
		positionables.push(lPositionnable);
		
		lPositionnable = {item: txtLogin, align : AlignType.CENTER};
		positionables.push(lPositionnable);
		
		lPositionnable = {item: lLoginTitle , align : AlignType.TOP, offsetY : 267};
		positionables.push(lPositionnable);
		
		lPositionnable = {item: lBackground_login_txt , align : AlignType.CENTER};
		positionables.push(lPositionnable);
		
		onResize();
		
		lLoginTitle.scaleX = 0;
		lLoginTitle.scaleY = 0;
		txtLogin.alpha = 0;
		lBackground_login_txt.scaleX = 0;
		lBackground_login_txt.scaleY = 0;
		btnOk.scaleX = 0;
		btnOk.scaleY = 0;
		
		var lTotalDuration : Float = 0;
		var lDuration : Float;
		
		lDuration = 1;
        Actuate.tween(lLoginTitle, lDuration, {scaleX : 1,scaleY : 1});
		lTotalDuration += lDuration/2;
        Actuate.tween(txtLogin, lDuration, {alpha : 1}, false).delay(lTotalDuration);
        Actuate.tween(lBackground_login_txt, lDuration, {scaleX : 1,scaleY : 1}, false).delay(lTotalDuration);
		lTotalDuration += lDuration/2;
        Actuate.tween(btnOk, lDuration, {scaleX : 1,scaleY : 1}, false).delay(lTotalDuration);
		
	}
	
	private function suprressionTxtStart(pEvent:MouseEvent):Void 
	{
		cast(txtLogin, TextField).text = "";
	}
	
	private function onTitleCard():Void {
		var lNickName:String;
		SoundManager.getSound("click").start();
		if (cast(txtLogin, TextField).text == "" || cast(txtLogin, TextField).text == "Enter your username here"){
			lNickName = "Guest";
		}else{
			lNickName = cast(txtLogin, TextField).text;
		}
		
		var r = ~/[^a-zA-Z0-9]+/g;
		lNickName = r.replace(lNickName, "");
		
		SaveManager.initSave(lNickName);
		SaveManager.initHighScore();
		SaveManager.saveDataProperty("Nickname", lNickName);
		UIManager.addScreen(TitleCard.getInstance());
		SaveManager.saveDatatoFile();
		SaveManager.loadData();
	}
	
	private function onClick(pEvent:MouseEvent):Void 
	{
		onTitleCard();
	}
	
	private function onEnter(pEvent:KeyboardEvent):Void 
	{
		if (pEvent.keyCode == Keyboard.ENTER){
			onTitleCard();
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onEnter);
		txtLogin.removeEventListener(MouseEvent.CLICK, suprressionTxtStart);
		btnOk.removeEventListener(MouseEvent.CLICK, onClick);

		instance = null;
		
		super.destroy();
	}
}