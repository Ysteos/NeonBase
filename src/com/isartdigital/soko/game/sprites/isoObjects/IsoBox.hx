package com.isartdigital.soko.game.sprites.isoObjects;
import openfl.display.DisplayObject;
import openfl.display.MovieClip;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */
class IsoBox extends IsoMovableObject
{
	
	private static var particleSystem :ParticleSystem;
	
	public function new() 
	{
		blockType = Blocks.BOX;
		super();
		
		var lBody: MovieClip = cast(renderer.getChildByName("mcBody"), MovieClip);
		
		mcEffect = renderer.getChildByName("mcEffect");
        mcEffect.visible = false;
		
		var lParticleRenderer = DefaultParticleRenderer.createInstance();
		lBody.addChildAt(cast lParticleRenderer, 0);
		
		particleSystem = ParticleLoader.load("assets/particles/isoBox/particle.plist");
		lParticleRenderer.addParticleSystem(particleSystem);
		particleSystem.emit(44.8, 60);
	}
	
}