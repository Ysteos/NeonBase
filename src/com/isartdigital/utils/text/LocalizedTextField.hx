package com.isartdigital.utils.text;

import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.display.SimpleButton;
import openfl.display.Sprite;
import openfl.text.TextField;

/**
 * ...
 * @author Jordan Sallot
 */
class LocalizedTextField extends Sprite {
	static inline var NUMBER_OF_STATE:Int = 4;

	public static var actualLanguage: String = "en";
	
	/**
	 * Récupération des TextField dans un écran
	 * @param	pScreen MovieClip qui contient les symboles
	 */
	public static function getTextField(pScreen:MovieClip): Array<TextField> {
		
		var lList: Array<TextField> = new Array<TextField>();
		
		var lButtonClass: SimpleButton;
		var lTextFieldContainer: DisplayObjectContainer;
		var lTextfield: TextField;
		
		for (position in 0...pScreen.numChildren) {
			
			if (Std.isOfType(pScreen.getChildAt(position), TextField)) {
				
				lTextfield = cast(pScreen.getChildAt(position), TextField);
				
				lList.push(lTextfield);
				
			} 
			else if (Std.isOfType(pScreen.getChildAt(position), SimpleButton)) {
				
				lButtonClass = cast(pScreen.getChildAt(position), SimpleButton);
				
				for (i in 0...NUMBER_OF_STATE) 
				{
					switch i 
					{
						case 0:
							
							lTextFieldContainer = cast(lButtonClass.upState, DisplayObjectContainer);
							lTextfield = cast(lTextFieldContainer.getChildAt(1), TextField);
							lList.push(lTextfield);
							
						case 1:
							
							lTextFieldContainer = cast(lButtonClass.downState, DisplayObjectContainer);
							lTextfield = cast(lTextFieldContainer.getChildAt(1), TextField);
							lList.push(lTextfield);
							
						case 2:
							
							lTextFieldContainer = cast(lButtonClass.overState, DisplayObjectContainer);
							lTextfield = cast(lTextFieldContainer.getChildAt(1), TextField);
							lList.push(lTextfield);
					}
				}
			}
		}
		
		return lList;
	}
	
	/**
	 * traite la traduction si l'actualLanguage est set à fr alors le texte sera écrit avec la 
	 * ligne fr du localization.json autrement le texte sera écrit avec la ligne en.
	 * @param 
	 */
	public static function translate(pTextField: Array<TextField>) {
		
		var lTranslationData: String = GameLoader.getText("assets/localization.json");
		
		var lTranslationObject: Dynamic = Json.parse(lTranslationData);
		
		var lTranslation: Translation;
		
		var lTextOfTextField: String;
		var lArrayOfTextField: Array<String>;
		var lText: String = "";
		
		for (position in 0...pTextField.length) {
			
			
			lTextOfTextField = pTextField[position].text;
			
			lArrayOfTextField = lTextOfTextField.split("");
			
			lArrayOfTextField.pop();
			
			for (char in 0...lArrayOfTextField.length) 
			{
				lText += lArrayOfTextField[char];
			}
			
			if (lText != "" && Reflect.hasField(lTranslationObject, lText)) {
				
				lTranslation = Reflect.field(lTranslationObject, lText);
				
				if (actualLanguage == "fr") {
					
					pTextField[position].text = lTranslation.fr;
					lText = "";
					
				} 
				else {
					
					pTextField[position].text = lTranslation.en;
					lText = "";
					
				}
			} else {
				trace("Il n'y a pas de texte Localisé pour " + lText);
				lText = "";
			}
		}
	}
	
}