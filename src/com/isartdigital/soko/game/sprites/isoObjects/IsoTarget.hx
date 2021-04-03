package com.isartdigital.soko.game.sprites.isoObjects;
import openfl.display.MovieClip;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;
import org.zamedev.particles.util.ParticleColor;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */
class IsoTarget extends IsoNotMovableObject 
{
	private var particleSystem :ParticleSystem;
	
	public var colorChanged:Bool; 

	public function new() 
	{
		blockType = Blocks.TARGET;
		super();
		
		var lBase: MovieClip = cast(renderer.getChildByName("mcBase"), MovieClip);
		
		mcEffect = renderer.getChildByName("mcEffect");
        mcEffect.visible = false;
		
		var lParticleRenderer = DefaultParticleRenderer.createInstance();
		lBase.addChild(cast lParticleRenderer);
		
		particleSystem = ParticleLoader.load("assets/particles/isoTarget/particle.plist");
		lParticleRenderer.addParticleSystem(particleSystem);
		particleSystem.emit(38.5, -18.9);
	}
	
	public function changeParticlesColor(): Void {
		if (!colorChanged) {
			//vert
			particleSystem.startColor = new ParticleColor(0, 1, 0, 0.6);
			particleSystem.finishColor = new ParticleColor(0, 1, 0, 0.2);
		} else {
			particleSystem.startColor = new ParticleColor(1, 0, 0, 0.6);
			particleSystem.finishColor = new ParticleColor(1, 0, 0, 0.2);
		}
		colorChanged = !colorChanged;
	}
	
}