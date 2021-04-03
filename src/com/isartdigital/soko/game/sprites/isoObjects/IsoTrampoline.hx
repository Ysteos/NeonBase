package com.isartdigital.soko.game.sprites.isoObjects;
import openfl.display.MovieClip;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */
class IsoTrampoline extends IsoMovableObject 
{
	private static var particleSystem :ParticleSystem;
	
	public static var tutoEnd: Bool;
	
	public function new() 
	{
		blockType = Blocks.TRAMPOLINE;
		super();
		
		var lBase: MovieClip = cast(renderer.getChildByName("mcBase"), MovieClip);
		
		mcEffect = renderer.getChildByName("mcEffect");
        mcEffect.visible = false;
		
		var lParticleRenderer = DefaultParticleRenderer.createInstance();
		lBase.addChild(cast lParticleRenderer);
		
		particleSystem = ParticleLoader.load("assets/particles/isoTrampo/particle.plist");
		lParticleRenderer.addParticleSystem(particleSystem);
		particleSystem.particleScaleY = -1;
		particleSystem.emit(34.65, -19.80);
	}
	
	public function removeArrows(): Void {
		
	}
	
}