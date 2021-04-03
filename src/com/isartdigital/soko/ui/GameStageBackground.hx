package com.isartdigital.soko.ui;

import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPositionable;
import openfl.display.MovieClip;
import openfl.events.Event;

/**
 * ...
 * @author Jordan Sallot
 */
class GameStageBackground extends Screen {
	
	/**
	 * instance unique de la classe HelpScreen
	 */
	private static var instance: GameStageBackground;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): GameStageBackground {
		if (instance == null) instance = new GameStageBackground();
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
		
		var lPositionable : UIPositionable;
		lPositionable = { item : content.getChildAt(0), align: AlignType.FIT_SCREEN };
		positionables.push(lPositionable);
		
		onResize();
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		
		instance = null;
	}
}