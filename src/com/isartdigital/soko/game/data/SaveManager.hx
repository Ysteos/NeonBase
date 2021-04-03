package com.isartdigital.soko.game.data;
import openfl.net.SharedObject;
import com.isartdigital.soko.ui.LoginScreen;
import com.isartdigital.soko.ui.HighScores;
import com.isartdigital.soko.ui.WinLevel;
import com.isartdigital.soko.ui.LevelSelection;
/**
 * ...
 * @author Jeffrey SEYMOUR
 */
class SaveManager 
{
	
	static private var saveData(get, null):SharedObject;
	static private var saveHighScores(get, null):SharedObject;
	
	static public  var keyAllPseudo : String = "keyAllPseudo";
	static public  var keyScore : String ;
	 
	static public function initSave(pSaveName):Void 
	{
		saveData = SharedObject.getLocal(pSaveName, "GROUPE_CURCUMA_5");
	}
		
	static public function initHighScore():Void 
	{
		saveHighScores = SharedObject.getLocal("HighScores","GROUPE_CURCUMA_5");
	}
	
	static public function saveDatatoFile():Void{
		saveData.flush();
	}
	
	static public function saveHighScorestoFile():Void {
		saveHighScores.flush();
	}
	
	static public function getNickame():String {
		return saveData.data.Nickname;
	}
	
	static public function getNumberStars():String {
		return saveData.data.NumberStars;
	}
	
	static public function saveAllPseudo():Void{
		var lPseudo : AllPseudo = {key : keyAllPseudo};
		
		if (saveHighScores.data.keyAllPseudo == null)
			saveHighScores.setProperty("keyAllPseudo",lPseudo);	
		
		if (saveHighScores.data.keyAllPseudo._allPseudo == null)
			saveHighScores.data.keyAllPseudo._allPseudo = new Array<String>();
		
		if (saveHighScores.data.keyAllPseudo._allPseudo.indexOf(getNickame()) == -1)
			saveHighScores.data.keyAllPseudo._allPseudo.push(SaveManager.getNickame());
			
		saveHighScorestoFile();		
	}
	
	static public function saveScoreFinal():Void{
		saveData.setProperty("scoreFinal", HighScores.scoreFinal);
		saveDatatoFile();
	}
	
	static public function setHighScore():Array<String>{
		var lAllPseudo : Array<String> = saveHighScores.data.keyAllPseudo._allPseudo;
		var lScore : Array<Int> = [0];
		var lName : Array<String> = [];
				
		for (k in lAllPseudo){
			for (m in lScore){
				if (cast (SharedObject.getLocal(k,"GROUPE_CURCUMA_5").data.scoreFinal, Int) >= m || m == null){
					lScore.insert(lScore.indexOf(m), cast (SharedObject.getLocal(k,"GROUPE_CURCUMA_5").data.scoreFinal, Int));
					lName.insert(lScore.indexOf(cast (SharedObject.getLocal(k,"GROUPE_CURCUMA_5").data.scoreFinal, Int)), k);
					break;
				}
			}
		}
		
		var lString:String = "";
		var lIncrementation:Int = 0;
		var lStringList:Array<String> = new Array<String>();
		var lI : Int = 0;

		for (d in lScore){
			if (lI <= 9){
				lString = lName[lIncrementation] + " : " + d;
            
				if ((d == null) || (d == 0)){
					lString = "";
				}
            
				lStringList.push(lString);
            
				lIncrementation++;
				lI++;
			}
        }
        return lStringList;
	}

	/**
	 * get and save properties of actual player's data
	 * @param	pProperty = name of data, pData = value of data
	 */
	static public function saveDataProperty(pProperty:String, pData):Void {		
		saveData.setProperty(pProperty, pData);
	}
	
	static public function get_saveData():SharedObject 
	{
		return saveData;
	}
	
	static public function get_saveHighScores():SharedObject 
	{
		return saveHighScores;
	}
	
	static public function loadData():Void {
		if (saveData.data.ActualLevel) 
		{
			LevelManager.currentNumberLevel = saveData.data.ActualLevel;
		} 
		
		HighScores.highScores = saveData.data.PlayerScore;
		
		if (saveData.data.NumberStars){
			LevelSelection.allstars = saveData.data.NumberStars;
		}
		
		if (saveData.data.NumberLevelUnlock){
			LevelSelection.numberLevelUnlock = saveData.data.NumberLevelUnlock;
		}
	}
}