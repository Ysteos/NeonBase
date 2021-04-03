package com.isartdigital.soko.ui;

import com.isartdigital.soko.game.data.SaveManager;
import com.isartdigital.soko.game.data.AllPseudo;
import com.isartdigital.soko.game.sprites.radarObjects.RadarPlayer;
import com.isartdigital.utils.sound.SoundFX;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPositionable;
import haxe.ds.ArraySort;
import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import com.isartdigital.soko.ui.LevelSelection;
	
/**
 * ...
 * @author Jordan Sallot
 */
class HighScores extends ResizableScreen {
	
	static public var highScores:Array<Int>;
	static public inline var TAB_SIZE_MAX:Int = 10;
	public static var scoreFinal : Int = 0;
	static private var actualScore:Int;
	
	private static var scoreIndicatorContainer: MovieClip;
	private static var scoreBoardIndicatorContainer: MovieClip;
	private static var scoreIndicator: TextField;
	private static var scoreBoardIndicator: TextField;	
	
	static public var isComingHighScore:Bool;
	static public var introSounWinScreen : SoundFX;
	
	private static inline var DIVISION_TOTAL_DURATION : Float = 8;

	/**
	 * instance unique de la classe HighScores
	 */
	private static var instance: HighScores;
	
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): HighScores {
		if (instance == null) instance = new HighScores();
		return instance;
	}
	
	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(){
		super();
		highScores = new Array<Int>();
		scoreFinal = 0;
		for (i in 0...LevelSelection.allstars.length){
			scoreFinal += LevelSelection.allstars[i];
		}
		isComingHighScore = true;
	}
	
	override function init(pEvent:Event):Void {
		super.init(pEvent);
		
		var lMcTitle : TextField = cast (content.getChildByName("mcTitle"), TextField);
		
		var lBtnNext : SimpleButton = cast (content.getChildByName("btnNext"), SimpleButton);
					
		var lMcRank : DisplayObjectContainer = cast(content.getChildByName("mcRank"), DisplayObjectContainer);
		var lMyRank : DisplayObject = content.getChildByName("myRank");
		
		content.getChildByName("btnNext").addEventListener(MouseEvent.CLICK, onClickNext);
		
		var lPositionnable : UIPositionable = { item: lBtnNext, align : AlignType.BOTTOM, offsetY : 100};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: content.getChildByName("mcTab"), align : AlignType.TOP, offsetY : lMcTitle.height + 370};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: lMcRank, align : AlignType.TOP, offsetY :lMcTitle.height - 100};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: lMyRank, align : AlignType.TOP, offsetY : 1100};
		positionables.push(lPositionnable);
		
		lPositionnable = { item: lMcTitle, align : AlignType.TOP, offsetY : -20};
		positionables.push(lPositionnable);
		
		onResize();
		
		SaveManager.initHighScore();
		SaveManager.saveAllPseudo();
		SaveManager.saveScoreFinal();
		SaveManager.setHighScore();
		
		var lHighScore : Array<String> = SaveManager.setHighScore();
		
		var lRank0 : TextField = cast(lMcRank.getChildByName("rank0"), TextField);
		var lRank1 : TextField = cast(lMcRank.getChildByName("rank1"), TextField);
		var lRank2 : TextField = cast(lMcRank.getChildByName("rank2"), TextField);
		var lRank3 : TextField = cast(lMcRank.getChildByName("rank3"), TextField);
		var lRank4 : TextField = cast(lMcRank.getChildByName("rank4"), TextField);
		var lRank5 : TextField = cast(lMcRank.getChildByName("rank5"), TextField);
		var lRank6 : TextField = cast(lMcRank.getChildByName("rank6"), TextField);
		var lRank7 : TextField = cast(lMcRank.getChildByName("rank7"), TextField);
		var lRank8 : TextField = cast(lMcRank.getChildByName("rank8"), TextField);
		var lRank9 : TextField = cast(lMcRank.getChildByName("rank9"), TextField);
		
		lRank0.alpha = 0;
		lRank1.alpha = 0;
		lRank2.alpha = 0;
		lRank3.alpha = 0;
		lRank4.alpha = 0;
		lRank5.alpha = 0;
		lRank6.alpha = 0;
		lRank7.alpha = 0;
		lRank8.alpha = 0;
		lRank9.alpha = 0;
		lMyRank.alpha = 0;
		
		lBtnNext.scaleX = 0;
		lBtnNext.scaleY = 0;
		
		lMcTitle.alpha = 0;
			
		var lTotalDuration : Float = 0;
		var lDuration : Float;
		
		lDuration = 1;
		Actuate.tween(lMcTitle, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lRank0, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lRank1, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lRank2, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lRank3, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lRank4, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lRank5, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lRank6, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lRank7, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lRank8, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lRank9, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lMyRank, lDuration, {alpha : 1}).delay(lTotalDuration);
		lTotalDuration += lDuration / DIVISION_TOTAL_DURATION;
		Actuate.tween(lBtnNext, lDuration, {scaleX : 1,scaleY : 1}).delay(lTotalDuration);
		
		lRank0.text = "1.";
		if (lHighScore[0]!= null)
			lRank0.text += lHighScore[0];
			
		lRank1.text = "2."; 
		if (lHighScore[1]!= null)
			lRank1.text += lHighScore[1];
			
		lRank2.text = "3.";	
		if (lHighScore[2]!= null)
			lRank2.text += lHighScore[2];
			
		lRank3.text = "4.";
		if (lHighScore[3]!= null)
			lRank3.text += lHighScore[3];
			
		lRank4.text = "5.";
		if (lHighScore[4]!= null)
			lRank4.text += lHighScore[4];
			
		lRank5.text = "6.";
		if (lHighScore[5]!= null)
			lRank5.text += lHighScore[5];
			
		lRank6.text = "7.";
		if (lHighScore[6]!= null)
			lRank6.text += lHighScore[6];
			
		lRank7.text = "8.";
		if (lHighScore[7]!= null)
			lRank7.text += lHighScore[7];
			
		lRank8.text = "9.";
		if (lHighScore[8]!= null)
			lRank8.text += lHighScore[8];
			
		lRank9.text = "10.";
		if (lHighScore[9]!= null)
			lRank9.text += lHighScore[9];
			
		//tester pour si y a pas de score si mon score fait zéro y vas pas être tracé en bas 
		var lMyRank : DisplayObjectContainer = cast(content.getChildByName("myRank"), DisplayObjectContainer);
		
		if (lHighScore.indexOf(SaveManager.getNickame() + " : " + SaveManager.get_saveData().data.scoreFinal) == -1){
			cast (lMyRank.getChildByName("txtNotInScore"), TextField).text = "Moi : " + SaveManager.getNickame() + " : " + SaveManager.get_saveData().data.scoreFinal;
		}		
		
		content.getChildByName("mcTab").scaleX = 0.8;
	}
	
	private function onClickNext(pEvent:MouseEvent):Void {
		SoundManager.getSound("click").start();
		UIManager.addScreen(TitleCard.getInstance());
	}
	
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void {
		content.getChildByName("btnNext").removeEventListener(MouseEvent.CLICK, onClickNext);
		
		instance = null;
		
		super.destroy();
	}
}