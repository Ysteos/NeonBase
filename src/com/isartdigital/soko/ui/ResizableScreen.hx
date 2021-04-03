package com.isartdigital.soko.ui;

import com.isartdigital.utils.sound.SoundFX;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.text.LocalizedTextField;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Screen;
import com.isartdigital.utils.ui.UIPositionable;
import openfl.display.DisplayObject;
import openfl.display.MovieClip;
import openfl.events.Event;

/**
 * ...
 * @author 
 */
class ResizableScreen extends Screen 
{
	private var clickSound: SoundFX;
	
	private var background: MovieClip;

	public function new() 
	{
		super();
		
	}
	
	override function init(pEvent:Event):Void 
	{
		super.init(pEvent);
		
		LocalizedTextField.translate(LocalizedTextField.getTextField(content));
		
		clickSound = SoundManager.getSound("click");
		background = cast(content.getChildByName("background"), MovieClip);
		
		var lPositionnable : UIPositionable = { item:background, align:AlignType.FIT_SCREEN };
		positionables.push(lPositionnable);
	}
	
}