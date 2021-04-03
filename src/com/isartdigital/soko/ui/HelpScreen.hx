package com.isartdigital.soko.ui;

import com.isartdigital.soko.game.GameManager;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.soko.ui.TitleCard;
import com.isartdigital.utils.ui.UIPositionable;
import openfl.display.DisplayObject;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;

	
/**
 * ...
 * @author Jordan Sallot
 */
class HelpScreen extends ResizableScreen {
	
	/**
	 * instance unique de la classe HelpScreen
	 */
	private static var instance: HelpScreen;
	
	public static var isComingFromMenu: Bool = true;
	
	private var btnNext: SimpleButton;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): HelpScreen {
		if (instance == null) instance = new HelpScreen();
		return instance;
		
	}
	
	override function onResize(pEvent:Event = null):Void {
		super.onResize(pEvent);
		
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new() {
		super();
		if (!LevelSelection.isComingLevelSelection){
			isComingFromMenu = true;
		}
	}
	
	override function init(pEvent:Event):Void {
		super.init(pEvent);
		
		btnNext = cast(content.getChildByName("btnNext"), SimpleButton);
		btnNext.addEventListener(MouseEvent.CLICK, onClickNext);
		
		getResize();
	}
	
	private function getResize():Void {
		var lTitle: DisplayObject = content.getChildByName("mcTitle");
		var helpTxt1: DisplayObject = content.getChildByName("helpTxt1");
		var helpTxt2: DisplayObject = content.getChildByName("helpTxt2");
		var helpTxt3: DisplayObject = content.getChildByName("helpTxt3");
		var helpTxt4: DisplayObject = content.getChildByName("helpTxt4");
		
		var help1: DisplayObject = content.getChildByName("help1");
		var help2: DisplayObject = content.getChildByName("help2");
		var help3: DisplayObject = content.getChildByName("help3");
		var help4: DisplayObject = content.getChildByName("help4");
		var help5: DisplayObject = content.getChildByName("help5");
		
		var controls: DisplayObject = content.getChildByName("controls");
		var arrows: DisplayObject = content.getChildByName("arrows");
		var mouse: DisplayObject = content.getChildByName("mouse");
		
		var lPositionnable : UIPositionable = { item: btnNext, align : AlignType.BOTTOM, offsetY : 100};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: lTitle, align : AlignType.TOP, offsetY : 10};
		positionables.push(lPositionnable);
		
		// Text 
		lPositionnable = { item: helpTxt1, align : AlignType.LEFT, offsetX : 650};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: helpTxt2, align : AlignType.BOTTOM, offsetY : 250};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: helpTxt3, align : AlignType.RIGHT, offsetX: 1000 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: helpTxt4, align : AlignType.RIGHT, offsetX: 780 };
		positionables.push(lPositionnable);
		
		// Symbole Help
		lPositionnable = { item: help1, align : AlignType.LEFT, offsetX: 600 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: help2, align : AlignType.LEFT, offsetX: 1200 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: help3, align : AlignType.LEFT, offsetX: 350 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: help4, align : AlignType.LEFT, offsetX: 900 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: help5, align : AlignType.LEFT, offsetX: 1450 };
		positionables.push(lPositionnable);
		
		// Controls
		
		lPositionnable = { item: controls, align : AlignType.RIGHT, offsetX: 400 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: arrows, align : AlignType.RIGHT, offsetX: 400 };
		positionables.push(lPositionnable);
		
		lPositionnable = { item: mouse, align : AlignType.RIGHT, offsetX: 900 };
		positionables.push(lPositionnable);
		
		
		
		onResize();
		
		
		
	}
	
	private function onClickNext(pEvent:MouseEvent):Void {
		// Implementer une condition qui : si le joueur vient du menu (à appuyer sur le bouton help) il retourne au menu, sinon il vient de l'écran
		// de selction des niveaux et que le niveau est le niveau tuto alors on affiche l'aide et quand le joueur appuie sur next il atterit sur l'écran du niveau tuto
		
		clickSound.start();
		
		if (isComingFromMenu) {
			UIManager.addScreen(TitleCard.getInstance());
		} else {
			SoundManager.getSound("intro").stop();
			GameManager.start(0);
		}
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		btnNext.removeEventListener(MouseEvent.CLICK, onClickNext);
		
		instance = null;
		
		super.destroy();
	}

}