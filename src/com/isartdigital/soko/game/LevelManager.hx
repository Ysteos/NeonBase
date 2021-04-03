package com.isartdigital.soko.game;
import animateAtlasPlayer.core.JsonTextureAtlas.Sprites;
import com.isartdigital.soko.game.data.SaveManager;
import com.isartdigital.soko.game.sprites.Player;
import com.isartdigital.soko.game.sprites.isoObjects.IsoMovableObject;
import com.isartdigital.soko.game.sprites.isoObjects.IsoNotMovableObject;
import com.isartdigital.soko.game.sprites.isoObjects.IsoPlayer;
import com.isartdigital.soko.game.sprites.isoObjects.IsoTrampoline;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObject;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObjectMovable;
import com.isartdigital.soko.game.sprites.radarObjects.RadarObjectNotMovable;
import com.isartdigital.soko.game.sprites.isoObjects.IsoBox;
import com.isartdigital.soko.game.sprites.isoObjects.IsoGround;
import com.isartdigital.soko.game.sprites.isoObjects.IsoObjects;
import com.isartdigital.soko.game.sprites.isoObjects.IsoTarget;
import com.isartdigital.soko.game.sprites.isoObjects.IsoWall;
import com.isartdigital.soko.ui.UIManager;
import com.isartdigital.utils.Timer;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.grids.CellDef;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sound.SoundFX;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.Screen;
import haxe.Json;
import js.html.svg.Number;
import motion.Actuate;
import openfl.display.Sprite;
import openfl.geom.Point;
import com.isartdigital.soko.game.sprites.radarObjects.RadarGround;
import com.isartdigital.soko.game.sprites.radarObjects.RadarWall;
import com.isartdigital.soko.game.sprites.radarObjects.RadarTarget;
import com.isartdigital.soko.game.sprites.radarObjects.RadarBox;
import com.isartdigital.soko.game.sprites.radarObjects.RadarTrampoline;
import com.isartdigital.soko.ui.WinLevel;
import com.isartdigital.soko.ui.LevelSelection;
import com.isartdigital.soko.ui.Hud;
import com.isartdigital.soko.game.sprites.radarObjects.RadarPlayer;
import com.isartdigital.soko.ui.WinScreen;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Léandre DAHO-KABLAN
 */

class LevelManager
{
	public static var isoContainer:Sprite = new Sprite();
	
	private static var levelPosition:Point = new Point(-150, 30);
	private static var levelSize:Float = 0.6;
	public static var cellSize:Float = 100 * levelSize;

	private static var isoLevelPosition:Point = new Point(1500, 350);
	private static var isoLevelSize:Float = 1.8;
	public static var isoSizeX:Float = 128 * isoLevelSize;
	public static var isoSizeY:Float = 66 * isoLevelSize;

	public static var movementsTable:Array<Array<Array<RadarObject>>>;
	public static var movementIndex:Int = 0;

	public static var notMovableObjectMap:Array<Array<RadarObjectNotMovable>> = new Array<Array<RadarObjectNotMovable>>();
	public static var movableObjectMap:Array<Array<RadarObjectMovable>> = new Array<Array<RadarObjectMovable>>();
	public static var notMovableObjectRect:Array<Array<Rectangle>> = new Array<Array<Rectangle>>();
	public static var currentLevel:Array<Array<Array<Blocks>>>;
	
	public static var depthTable:Array<IsoObjects>;

	public static var hasUndo:Bool = false;

	public static var currentNumberLevel: Int = 0;
	public static var currentNumberLevelBeforeWin:Int = 0;
	
	private static var soundLevel0:SoundFX;
	private static var isRetry:Bool = false;
	public static var isAnimate:Bool = false;
	private static var isWinning:Bool = false;

	private function new() {}

	public static function radarToViewPosition(pPosition:Point):Point
	{
		return new Point(isoLevelPosition.x + (pPosition.x - pPosition.y) * isoSizeX / 2, isoLevelPosition.y + (pPosition.x + pPosition.y) * isoSizeY / 2);
	}

	public static function generateIsoLevel():Void
	{
		var lRectangle : Rectangle = DeviceCapabilities.getScreenRect(GameStage.getInstance());
		var lBlock:IsoObjects = null;
		var lTempBlock:IsoObjects = null;
		var lYTempBlock:IsoObjects = null;
		var lX:Int = 0;
		var lY:Int = 0;
		
		GameStage.getInstance().getGameContainer().addChild(isoContainer);
		isoContainer.x = lRectangle.left + isoLevelPosition.x;
        isoContainer.y = lRectangle.top + isoLevelPosition.y;
		
		for (i in 0...notMovableObjectMap.length)
		{
			for (j in 0...notMovableObjectMap[i].length)
			{
				lBlock = notMovableObjectMap[i][j].isoObject;
				if (Std.isOfType(lBlock, IsoWall)){
					lX++;
					continue;
				}
				
				lBlock.x = (lX - lY) * isoSizeX / 2;
				lBlock.y = (lX + lY) * isoSizeY / 2;
				
				lTempBlock = lBlock;

				isoContainer.addChild(lBlock);
				lBlock.scaleX = isoLevelSize;
				lBlock.scaleY = isoLevelSize;
			
				lX++;
			}
			lY++;
			lX = 0;
			lTempBlock = null;
		}
		lX = 0;
		lY = 0;
		
		for (i in 0...movableObjectMap.length) {
			for (j in 0...movableObjectMap[i].length) {
				if (Std.isOfType(notMovableObjectMap[i][j].isoObject, IsoWall)) {
					notMovableObjectMap[i][j].isoObject.x = (lX - lY) * isoSizeX / 2;
					notMovableObjectMap[i][j].isoObject.y = (lX + lY) * isoSizeY / 2;
					isoContainer.addChild(notMovableObjectMap[i][j].isoObject);
					notMovableObjectMap[i][j].isoObject.scaleX = isoLevelSize;
					notMovableObjectMap[i][j].isoObject.scaleY = isoLevelSize;
				}
				
				if (movableObjectMap[i][j] != null)
				{
					var check:Bool = false;
					for (movable in IsoMovableObject.allMovableObject)
						if (movable == movableObjectMap[i][j].isoObject) check = true;
						
						if (!check) {
							movableObjectMap[i][j].isoObject.x = (lX - lY) * isoSizeX / 2;
							movableObjectMap[i][j].isoObject.y = (lX + lY) * isoSizeY / 2;
						}
					isoContainer.addChild(movableObjectMap[i][j].isoObject);
					movableObjectMap[i][j].isoObject.scaleX = isoLevelSize;
					movableObjectMap[i][j].isoObject.scaleY = isoLevelSize;
				}
				lX++;
			}
			lX = 0;
			lY++;
		}
	}

	public static function generateLevel():Void
	{
		var lBlock:RadarObject;
		var lTempBlock:RadarObject = null;
		var lXTable:Int = 0;
		var lYTable:Int = 0;
		var onGround:Bool = false;

		for (line in currentLevel)
		{
			movableObjectMap.push(new Array<RadarObjectMovable>());
			notMovableObjectMap.push(new Array<RadarObjectNotMovable>());

			for (column in line)
			{
				for (block in column)
				{
					switch block
				{
					case Blocks.GROUND: lBlock = new RadarGround();
						case Blocks.WALL: lBlock = new RadarWall();
						case Blocks.PLAYER: lBlock = RadarPlayer.getInstance();
						case Blocks.TARGET: lBlock = new RadarTarget();
						case Blocks.BOX: lBlock = new RadarBox();
						case Blocks.TRAMPOLINE: lBlock = new RadarTrampoline();
					}

					if (!onGround)
					{
						GameStage.getInstance().getGameContainer().addChild(lBlock);
						lBlock.x = levelPosition.x + cellSize * lXTable;
						lBlock.y = levelPosition.y + cellSize * lYTable;
						lBlock.scaleX *= levelSize;
						lBlock.scaleY *= levelSize;
						lTempBlock = lBlock;
						notMovableObjectMap[lYTable].push(cast(lBlock, RadarObjectNotMovable));
						movableObjectMap[lYTable].push(null);
					}
					else
					{
						lTempBlock.addChild(lBlock);
						if (!Std.isOfType(lBlock, RadarTarget))
							movableObjectMap[lYTable][movableObjectMap[lYTable].length - 1] = cast(lBlock,RadarObjectMovable);
						else
							notMovableObjectMap[lYTable][movableObjectMap[lYTable].length - 1] = cast(lBlock,RadarObjectNotMovable);
					}

					onGround = true;
				}

				onGround = false;
				lXTable ++;
			}

			lYTable++;
			lXTable = 0;
		}
	}

	public static function loadLevel(pIndexLevel:Int):Void
	{
		var levelData:String = GameLoader.getText("assets/levels/leveldesign.json");
		var levelObject:Dynamic = Json.parse(levelData);
		var levelDesign:Array<Level> = Reflect.field(levelObject, "levelDesign");
		var lIndex:Int = 0;
		
		currentLevel = new Array<Array<Array<Blocks>>>();

		for (level in levelDesign)
		{
			if (lIndex != pIndexLevel)
			{
				lIndex++;
				continue;
			}

			for (row in level.map)
			{
				currentLevel.push(new Array<Array<Blocks>>());

				for (char in row.split(""))
				{
					switch char
				{
					case " ": currentLevel[currentLevel.length - 1].push([Blocks.GROUND]);
						case "#": currentLevel[currentLevel.length - 1].push([Blocks.WALL]);
						case ".": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TARGET]);
						case "$": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.BOX]);
						case "@": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.PLAYER]);
						case "-": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TRAMPOLINE]);
					}
				}
			}

			return;
		}

		trace("ERROR: NO LEVEL LOADED");
		return;
	}
	
	private static function initRectMap():Void {
		for (i in 0...notMovableObjectMap.length) {
			notMovableObjectRect.push(new Array<Rectangle>());
			for (j in 0...notMovableObjectMap[i].length) {
				notMovableObjectRect[i].push(notMovableObjectMap[i][j].isoObject.getRect(GameStage.getInstance().stage));
				notMovableObjectRect[i][j].top += notMovableObjectMap[i][j].height / 4;
				notMovableObjectRect[i][j].bottom -= notMovableObjectMap[i][j].height / 4;
				notMovableObjectRect[i][j].left += notMovableObjectMap[i][j].width / 4;
				notMovableObjectRect[i][j].right -= notMovableObjectMap[i][j].width / 4;
			}
		}
	}

	public static function getIsoCase(pX, pY):RadarObjectNotMovable {
		for (i in 0...notMovableObjectRect.length) {
			for (j in 0...notMovableObjectRect[i].length) {
				if (pX >= notMovableObjectRect[i][j].left && pX <= notMovableObjectRect[i][j].right && pY >= notMovableObjectRect[i][j].top && pY <= notMovableObjectRect[i][j].bottom) {
					trace(notMovableObjectMap[i][j].getTablePosition());
					return (notMovableObjectMap[i][j]);
				}
			}
		}
		trace("NOT FOUND");
		return null;
	}

	private static function spawnLevel():Void {
		var animTime:Float = 2.5;
		var startY:Int;
		
		isAnimate = true;
		
		for (line in movableObjectMap) {
			for (object in line) {
				if (object != null) {
					startY = 1080 + Math.round(Math.random() * 1080);
					object.isoObject.y += startY;
					Actuate.tween(object.isoObject, animTime, {y : object.isoObject.y - startY}).onComplete(endAnimation);
				}
			}
		}
		
		for (line in notMovableObjectMap) {
			for (object in line) {
				startY = 1080 + Math.round(Math.random() * 1080);
				object.isoObject.y += startY;
				Actuate.tween(object.isoObject, animTime, {y : object.isoObject.y - startY}).onComplete(endAnimation);
			}
		}
	}
	
	public static function endAnimation():Void {
		isAnimate = false;
	}
	
	public static function init(pIndex:Int)
	{
		GameStage.getInstance().stage.focus = GameStage.getInstance().stage;
		isWinning = false;
		if (movementsTable != null) movementsTable = null;
		movementsTable = new Array<Array<Array<RadarObject>>>();
		movementIndex = 0;

		Hud.getInstance().stepsIndication();
		Hud.getInstance().numberPar(pIndex);
		loadLevel(pIndex);
		generateLevel();
		generateIsoLevel();
		initRectMap();
		spawnLevel();
		currentNumberLevel = pIndex;
		
		
		var lPos:Point = RadarPlayer.getInstance().getTablePosition();
		notMovableObjectMap[Std.int(lPos.y)][Std.int(lPos.x)].isoObject.mcEffect.visible = true;
		
		for (box in RadarBox.allBoxes) {
			lPos = box.getTablePosition();
			notMovableObjectMap[Std.int(lPos.y)][Std.int(lPos.x)].isoObject.mcEffect.visible = true;
		}
		
		if (!isRetry){
			SoundManager.getSound("level0").fadeIn();
		}
		
		isRetry = false;
		IsoMovableObject.clearAllMovableObjects();

		//affichage du parsing et des maps
		/*for (t in currentLevel)
			trace(t);*/

		/*trace("Not Movable Table :");
		for (notMovable in notMovableObjectMap)
			trace(notMovable);*/

		/*trace("Movable Table :");
		for (movable in movableObjectMap)
			trace(movable);*/
	}

	public static function saveMovement(pMovableObject:RadarObjectMovable):Void
	{
		if (movementsTable[movementIndex] == null) movementsTable[movementIndex] = new Array<Array<RadarObject>>();

		for (i in 0...movableObjectMap.length)
		{
			for (j in 0...movableObjectMap[i].length)
			{
				if (movableObjectMap[i][j] == pMovableObject)
					movementsTable[movementIndex].push([cast(movableObjectMap[i][j], RadarObject), cast(movableObjectMap[i][j].parent, RadarObject)]);
			}
		}
	}

	public static function updateMovementsTable():Void
	{
		while (movementsTable.length - 1 > movementIndex)
			movementsTable.pop();
		movementsTable[movementIndex] = new Array<Array<RadarObject>>();
		hasUndo =  false;
	}

	public static function undo():Void
	{
		if (movementIndex < 1) return;

		if (!hasUndo) hasUndo = true;

		movementsTable[movementIndex] = null;

		var lMovement:Array<Array<RadarObject>> = movementsTable[movementIndex - 1];
		var i:Int = lMovement.length;

		for (object in lMovement)
			saveMovement(cast(object[0], RadarObjectMovable));
		while (--i >= 0)
		{
			var lX:Int = cast(lMovement[i][0].getTablePosition().x, Int);
			var lY:Int = cast(lMovement[i][0].getTablePosition().y, Int);
			var lXPrevious:Int = cast(lMovement[i][1].getTablePosition().x, Int);
			var lYPrevious:Int = cast(lMovement[i][1].getTablePosition().y, Int);
			lMovement[i][1].addChild(lMovement[i][0]);
			movableObjectMap[lYPrevious][lXPrevious] = cast(lMovement[i][0], RadarObjectMovable);
			movableObjectMap[lYPrevious][lXPrevious].isoObject.x = radarToViewPosition(new Point(lXPrevious, lYPrevious)).x;
			movableObjectMap[lYPrevious][lXPrevious].isoObject.y = radarToViewPosition(new Point(lXPrevious, lYPrevious)).y;
			notMovableObjectMap[lY][lX].isoObject.mcEffect.visible = false;
			if (!Std.isOfType(notMovableObjectMap[lYPrevious][lXPrevious], RadarTarget) || !Std.isOfType(movableObjectMap[lYPrevious][lXPrevious], RadarPlayer))
				notMovableObjectMap[lYPrevious][lXPrevious].isoObject.mcEffect.visible = true;

			if (lX != lXPrevious || lY != lYPrevious)
				movableObjectMap[lY][lX] = null;
		}

		LevelManager.generateIsoLevel();
		movementIndex--;
	}

	public static function redo():Void
	{
		if (!hasUndo || movementIndex == movementsTable.length - 1) return;

		movementsTable[movementIndex] = null;

		var lMovement:Array<Array<RadarObject>> = movementsTable[movementIndex + 1];

		for (i in 0...lMovement.length)
		{
			saveMovement(cast(lMovement[i][0], RadarObjectMovable));
			var lX:Int = cast(lMovement[i][0].getTablePosition().x, Int);
			var lY:Int = cast(lMovement[i][0].getTablePosition().y, Int);
			var lXNext:Int = cast(lMovement[i][1].getTablePosition().x, Int);
			var lYNext:Int = cast(lMovement[i][1].getTablePosition().y, Int);
			lMovement[i][1].addChild(lMovement[i][0]);
			movableObjectMap[lYNext][lXNext] = cast(lMovement[i][0], RadarObjectMovable);
			movableObjectMap[lYNext][lXNext].isoObject.x = radarToViewPosition(new Point(lXNext, lYNext)).x;
			movableObjectMap[lYNext][lXNext].isoObject.y = radarToViewPosition(new Point(lXNext, lYNext)).y;
			notMovableObjectMap[lY][lX].isoObject.mcEffect.visible = false;
			if (!Std.isOfType(notMovableObjectMap[lYNext][lXNext], RadarTarget) || !Std.isOfType(movableObjectMap[lYNext][lXNext], RadarPlayer))
				notMovableObjectMap[lYNext][lXNext].isoObject.mcEffect.visible = true;

			if (lX != lXNext || lY != lYNext)
				movableObjectMap[lY][lX] = null;
		}
		
		generateIsoLevel();
		movementIndex++;
	}

	public static function retry():Void
	{
		isRetry = true;
		
		if (WinLevel.isComingWinLevelScreen){
			SoundManager.getSound("level0").fadeIn();
		}
		
		WinLevel.isComingWinLevelScreen = false;
		GameManager.pauseGame();
		GameManager.destroy();
		
		for (line in movableObjectMap)
		{
			for (column in line)
			{
				if (column != null)
				{
					column.isoObject.destroy();
					column.destroy();
				}
			}
		}
		
		for (i in notMovableObjectMap)
		{
			for (j in i)
			{
				j.isoObject.destroy();
				j.destroy();
			}
		}
		
		movableObjectMap = new Array<Array<RadarObjectMovable>>();
		notMovableObjectMap = new Array<Array<RadarObjectNotMovable>>();
		currentLevel = new Array<Array<Array<Blocks>>>();

		GameManager.start(currentNumberLevel);
		GameManager.resumeGame();
	}

	public static function quit():Void
	{
		SoundManager.getSound("level0").fadeOut();
		SaveManager.saveDataProperty("ActualLevel", currentNumberLevel);
		SaveManager.saveDatatoFile();

		GameManager.destroy();
		GameManager.pauseGame();

		for (line in movableObjectMap)
		{
			for (column in line)
			{
				if (column != null)
				{
					column.isoObject.destroy();
					column.destroy();
				}
			}
		}
		
		for (i in notMovableObjectMap)
		{
			for (j in i)
			{
				j.isoObject.destroy();
				j.destroy();
			}
		}
		
		movableObjectMap = new Array<Array<RadarObjectMovable>>();
		notMovableObjectMap = new Array<Array<RadarObjectNotMovable>>();
		currentLevel = new Array<Array<Array<Blocks>>>();
		
		if (!WinScreen.isComingWinScreen){
			Hud.getInstance().destroy();
		}
	}
	
	public static function win():Void
    {
		if (isWinning) return;
		
		isWinning = true;
		quit();
		SoundManager.getSound("level0").fadeOut();
        currentNumberLevelBeforeWin = currentNumberLevel;

        if (currentNumberLevel <= 7)
        {
            UIManager.addScreen(WinLevel.getInstance());
            if (currentNumberLevel == LevelSelection.numberLevelUnlock){
				if (LevelSelection.numberLevelUnlock <= 7){
					LevelSelection.numberLevelUnlock += 1;
				}
            }
        }
        else if (currentNumberLevel >= 8)
        {
            UIManager.addScreen(WinScreen.getInstance());
        }

		SaveManager.saveDataProperty("NumberLevelUnlock", LevelSelection.numberLevelUnlock);
        SaveManager.saveDatatoFile();
			
        currentNumberLevel += 1;

        //Hud.getInstance().destroy();
		SoundManager.getSound("missionComplete").start();
		SoundManager.getSound("victory").start();
    
    }
}