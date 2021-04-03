package com.isartdigital.soko.game.sprites.isoObjects;
import com.isartdigital.soko.game.sprites.Direction;
import com.isartdigital.soko.game.sprites.Player;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObjectNotMovable;
import com.isartdigital.soko.game.sprites.radarObjects.RadarPlayer;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObjectMovable;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObject;
import com.isartdigital.utils.Timer;
import com.isartdigital.soko.ui.Hud;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sound.SoundManager;
import motion.Actuate;
import motion.easing.Linear;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;
import org.zamedev.particles.ParticleSystem;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */
class IsoPlayer extends IsoMovableObject 
{
	private static var instance: IsoPlayer;
	private static var staggerTimer:Timer = new Timer();
	public static var isJumping:Bool = false;
	public static var jumpDirection:Direction = null;
	private static var tempScale:Point;
	
	private var nStaggerEffect:Int = 6;
	private var nStagger:Int = 0;
	private static var particleSystem :ParticleSystem;
	
	public static function getInstance (): IsoPlayer {
		if (instance == null) instance = new IsoPlayer();
		return instance;
	}
	
	private function new() 
	{
		blockType = Blocks.PLAYER;
		super();
		
		mcEffect = renderer.getChildByName("mcEffect");
        mcEffect.visible = false;
		LevelManager.isoContainer.addEventListener(MouseEvent.CLICK, onClick);	
		
		addEventListener(Event.ADDED_TO_STAGE, addParticle);
	}
	
	public function addParticle(pEvent : Event):Void{
		var lBody: MovieClip = cast(renderer.getChildByName("mcBody"), MovieClip);
		
		var lParticleRenderer = DefaultParticleRenderer.createInstance();
		lBody.addChildAt(cast lParticleRenderer, 0);
		
		particleSystem = ParticleLoader.load("assets/particles/isoPlayer/particle.plist");
		lParticleRenderer.addParticleSystem(particleSystem);
		particleSystem.emit(63, -5);		
		
		removeEventListener(Event.ADDED_TO_STAGE, addParticle);
	}
	
	public function onClick(pEvent:MouseEvent):Void {
		var lCase:RadarObjectNotMovable = LevelManager.getIsoCase(GameStage.getInstance().stage.mouseX, GameStage.getInstance().stage.mouseY);
		
		if (lCase == null) return;
		
		var lX:Int = Std.int(RadarPlayer.getInstance().getTablePosition().x);
		var lY:Int = Std.int(RadarPlayer.getInstance().getTablePosition().y);
		var lMap:Array<Array<RadarObjectNotMovable>> = LevelManager.notMovableObjectMap;
		var lDirection:Direction = null;
		
		if (lX > 0 && lMap[lY][lX - 1] == lCase) lDirection = Direction.LEFT;
		else if (lX < lMap[lY].length - 1 && lMap[lY][lX + 1] == lCase) lDirection = Direction.RIGHT;
		else if (lY > 0 && lMap[lY - 1][lX] == lCase) lDirection = Direction.UP;
		else if (lY < lMap.length - 1 && lMap[lY + 1][lX] == lCase) lDirection = Direction.DOWN;
		
		if (lDirection != null) RadarPlayer.getInstance().move(lDirection);
	}
	
	override public function move(pDirection:Direction):Void 
	{
		jumpDirection = pDirection;
		super.move(pDirection);
	}
	
	override function doActionNormal():Void 
	{
		super.doActionNormal();
		if (!isMoving && isJumping) {
			//var totalDuration:Float = 0;
			SoundManager.getSound("jumpTrampoline").start();
			LevelManager.isAnimate = true;
			tempScale = new Point(scaleX, scaleY);
			setState("jump");
			Actuate.tween(this, 0.5, {scaleX : 0}, false).onComplete(jump);		
		}
	}
	
	public function jump():Void {
		switch jumpDirection {
			case Direction.LEFT: 
				x -= 2 * LevelManager.isoSizeX/2;
				y -= 2 * LevelManager.isoSizeY/2;
			case Direction.RIGHT: 
				x += 2 * LevelManager.isoSizeX/2;
				y += 2 * LevelManager.isoSizeY/2;
			case Direction.UP: 
				x += 2 * LevelManager.isoSizeX/2;
				y -= 2 * LevelManager.isoSizeY/2;
			case Direction.DOWN: 
				x -= 2 * LevelManager.isoSizeX/2;
				y += 2 * LevelManager.isoSizeY/2;
		}
		LevelManager.generateIsoLevel();
		//SoundManager.getSound("jumpTrampoline").start();
		setState("");
		scaleX = 0;
		isJumping = false;
		IsoMovableObject.clearAllMovableObjects();
		Actuate.tween(this, 0.5, {scaleX : tempScale.x}, false).onComplete(LevelManager.endAnimation);
	}
	
	/*public function setModeJump():Void {
		doAction = doActionJump;
	}*/
	
	public function setModeStagger():Void {
		doAction = doActionStagger;
		staggerTimer.resume();
		mcEffect.visible = true;
		IsoMovableObject.allMovableObject.push(this);
	}

	public function doActionStagger():Void {
		staggerTimer.update();
		if (staggerTimer.elapsedTime >= 0.5 / nStaggerEffect) {
			mcEffect.visible = !mcEffect.visible;
			nStagger++;
			staggerTimer.reset();
			staggerTimer.resume();
		}
		
		if (nStagger >= nStaggerEffect) {
			setModeVoid();
			moveTimer.stop();
			moveTimer.reset();
			IsoMovableObject.allMovableObject.remove(this);
			mcEffect.visible = false;
			Hud.getInstance().openBtnListeners();
			nStagger = 0;
		}
	}
	
	override public function destroy(): Void {
		super.destroy();
		instance = null;
		LevelManager.isoContainer.removeEventListener(MouseEvent.CLICK, onClick);
	}
}