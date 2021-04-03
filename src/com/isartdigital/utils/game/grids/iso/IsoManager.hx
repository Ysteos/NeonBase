package com.isartdigital.utils.game.grids.iso;
import com.isartdigital.game.sprites.tiles.TileObject;
import com.isartdigital.utils.game.grids.CellDef;
import openfl.display.DisplayObject;
import openfl.geom.Point;

/**
 * Manager Iso
 * @author Mathieu Anthoine
 * @author Chadi Husser
 * @version 0.4.0
 */
class IsoManager
{

	private static var halfWidth:Float;
	private static var halfHeight:Float;

	/**
	 * Initialisation du Manager Iso
	 * @param	pTileWidth largeur des tuiles
	 * @param	pTileHeight hauteur des tuiles
	 */
	public static function init (pTileWidth:UInt, pTileHeight:UInt): Void
	{
		halfWidth = pTileWidth / 2;
		halfHeight = pTileHeight / 2;
	}

	/**
	 * Conversion du modèle à la vue Isométrique
	 * @param	pPoint colonne et ligne dans le modèle
	 * @return point en x, y dans la vue
	 */
	public static function modelToIsoView(pPoint:Point):Point
	{
		return new Point (
			(pPoint.x - pPoint.y)*halfWidth,
			(pPoint.x + pPoint.y)*halfHeight
		);
	}
	/**
	 * Conversion de la vue Isométrique au modèle
	 * @param	pPoint coordonnées dans la vue
	 * @return colonne et ligne dans le modèle (valeurs non arrondies)
	 */
	public static function isoViewToModel(pPoint:Point):Point
	{
		return new Point (
			Math.round((pPoint.y/halfHeight+pPoint.x/halfWidth)/2),
			Math.round((pPoint.y/halfHeight-pPoint.x/halfWidth)/2)
		);
	}
	
	/**
	 * Tri de la liste des objets du modèle
	 * @param	pArray la liste d'objet a trier
	 */
	public static function zSort<T:CellDef>(pArray:Array<T>) : Void {
		pArray.sort(sortDepth);
	}
	
	private static function sortDepth<T:CellDef>(pA:T, pB:T) : Int {
		return getDepth(pA) - getDepth(pB);
	}
	
	private static function getDepth<T:CellDef>(pA:T) : Int {
		return Std.int(pA.gridX + pA.gridY);
	}

}