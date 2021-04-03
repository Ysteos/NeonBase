package  {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	// Reference de format de Level Design Sokoban:
	// http://sokobano.de/wiki/index.php?title=Level_format
	// Le format du JSON est librement inspiré de cette référence
	
	public class LevelEditor extends MovieClip {
		
		private var content:Object={};
		
		private var file: FileReference;
		
		public function LevelEditor() {
			file = new FileReference();
			stop();
			addEventListener (Event.ENTER_FRAME,doAction);
		}
				
		private function doAction (pEvent:Event): void {
			
			var i:uint;
			var ldID:uint;

			if (currentFrame>1) {
				if (content.levelDesign==null) content.levelDesign=[];
				ldID=content.levelDesign.push({})-1;
			}
			
			// stockage des données texte
			for (i=0;i<numChildren;i++) {
				if (getChildAt(i) is TextField) {
					var lDatas:Array=TextField(getChildAt(i)).text.split("\r");
					for (var j:uint=0;j<lDatas.length;j++) {
						if (lDatas[j].indexOf(":")==-1) continue;
						if (currentFrame==1) content[getName(lDatas[j])]=getValue(lDatas[j]);
						else content.levelDesign[ldID][getName(lDatas[j])]=getValue(lDatas[j]);
					}
				}
			}
			
			if (currentFrame==1) {
				nextFrame();
				return;
			}
				
			content.levelDesign[ldID].map=[
											[0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0],
											[0,0,0,0,0,0,0,0,0]
										];
			
			// stockage de la map
			for (i=0;i<numChildren;i++) {
				var lPos:Point=getCell(getChildAt(i));
				
				if (getChildAt(i) is Wall) content.levelDesign[ldID].map[lPos.y][lPos.x]+=1;
				else if (getChildAt(i) is Goal) content.levelDesign[ldID].map[lPos.y][lPos.x]+=2;
				else if (getChildAt(i) is Player) content.levelDesign[ldID].map[lPos.y][lPos.x]+=10;
				else if (getChildAt(i) is Box) content.levelDesign[ldID].map[lPos.y][lPos.x] += 20;
				else if (getChildAt(i) is Trampoline) content.levelDesign[ldID].map[lPos.y][lPos.x]+=25;
				
			}
			
			convertMap(content.levelDesign[ldID].map);
			
			if (currentFrame==totalFrames) {
				removeEventListener (Event.ENTER_FRAME,doAction);
				var lData:ByteArray = new ByteArray();
				lData.writeMultiByte(JSON.stringify(content,null,"\t"), "utf-8" );
				file.save(lData, "leveldesign.json" );
				
			} else nextFrame();	
			
		}
		
		private function getCell (pItem:DisplayObject) : Point {
			return new Point (Math.round(pItem.x/100),Math.round(pItem.y/100));
		}
		
		// supprime les espaces devant et derrière
		private function trim (pValue:String): String {
			return pValue.replace(/^[ ]+|[ ]+$/,"");
		}
		
		private function getName (pValue:String):String {
			return trim(pValue.split(":")[0]);
		}
		
		// supprime les espaces devant et derrière le nom de la variable
		private function getValue (pValue:String):* {
			var lValue:String=trim(pValue.split(":")[1]);
			if (lValue=="true") return true;
			else if (lValue=="false") return false;
			else if (!isNaN(parseFloat (lValue))) return parseFloat (lValue);
			return lValue;
		}
		
		// conversion des valeurs numériques de la map en string
		private function convertMap (pMap:Array):void {
			for (var i:int=0;i<9;i++) {
				for (var j:int=0;j<9;j++) {
					if (pMap[i][j]==0) pMap[i][j]=" ";
					else if (pMap[i][j]==1) pMap[i][j]="#";
					else if (pMap[i][j]==2) pMap[i][j]=".";
					else if (pMap[i][j]==10) pMap[i][j]="@";
					else if (pMap[i][j]==20) pMap[i][j]="$";
					else if (pMap[i][j]==12) pMap[i][j]="+";
					else if (pMap[i][j] == 22) pMap[i][j] = "*";
					else if (pMap[i][j]==25) pMap[i][j]="-";
				}
				pMap[i]=pMap[i].join("");
			}
		}
		
	}
	
}
