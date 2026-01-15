package boguAdventure.view
{
   import boguAdventure.BoguAdventureControl;
   import boguAdventure.cell.BoguAdventureCell;
   import boguAdventure.model.BoguAdventureActionType;
   import boguAdventure.model.BoguAdventureCellInfo;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.PerspectiveProjection;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BoguAdventureMap extends Sprite implements Disposeable
   {
      
      private static const MAP_WIDTH:int = 10;
      
      private static const MAP_HEIGHT:int = 7;
      
      private var _mapBg:Bitmap;
      
      private var _cellList:Vector.<BoguAdventureCell>;
      
      private var _control:BoguAdventureControl;
      
      public function BoguAdventureMap(control:BoguAdventureControl)
      {
         super();
         this._control = control;
         this.init();
      }
      
      private function init() : void
      {
         this.transform.perspectiveProjection = new PerspectiveProjection();
         this.transform.perspectiveProjection.projectionCenter = new Point(500,300);
         this.rotationX = -38;
         this._mapBg = UICreatShortcut.creatAndAdd("boguAdventure.gameView.Bg",this);
         this.createMapCell();
      }
      
      public function getCellPosIndex(index:int, focusPos:Point) : Point
      {
         if(index == 0)
         {
            return new Point(100,100);
         }
         var cell:BoguAdventureCell = this.getCellByIndex(index);
         var rect:Rectangle = cell.getRect(stage);
         var realPos:Point = this.localToGlobal(new Point(cell.x,cell.y));
         var endX:Number = realPos.x + int(rect.width * 0.5) - focusPos.x;
         var endY:Number = realPos.y + int(rect.height * 0.5) - focusPos.y;
         var str:String = index < 10 ? index.toString() : index.toString().charAt(1);
         endX = endX - 6;
         endX = str == "1" ? endX - 10 : (str == "2" ? endX - 8 : (str == "3" ? (endX) : endX));
         return new Point(endX,endY);
      }
      
      public function getCellByIndex(index:int) : BoguAdventureCell
      {
         return this._cellList[index - 1];
      }
      
      public function playFineMineAction(index:int) : void
      {
         var cell:BoguAdventureCell = this.getCellByIndex(index);
         cell.playShineAction();
      }
      
      public function mouseClickClose() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function mouseClickOpen() : void
      {
         this.mouseEnabled = true;
         this.mouseChildren = true;
      }
      
      private function createMapCell() : void
      {
         var cell:BoguAdventureCell = null;
         var i:int = 0;
         var j:int = 0;
         this._cellList = new Vector.<BoguAdventureCell>();
         for(i = 0; i < MAP_HEIGHT; i++)
         {
            for(j = 0; j < MAP_WIDTH; j++)
            {
               cell = new BoguAdventureCell();
               cell.addEventListener(MouseEvent.CLICK,this.__onClickCell);
               cell.addEventListener(BoguAdventureCell.PLAY_COMPLETE,this.__onPlayComplete);
               cell.x = 20 + j * cell.width;
               cell.y = 19 + i * cell.height;
               addChild(cell);
               this._cellList.push(cell);
            }
         }
      }
      
      private function __onClickCell(e:MouseEvent) : void
      {
         if(!(e.target is BoguAdventureCell))
         {
            return;
         }
         var cell:BoguAdventureCell = e.target as BoguAdventureCell;
         if(this._control.changeMouse)
         {
            return;
         }
         if(this._control.checkGameOver())
         {
            return;
         }
         if(this._control.currentIndex == cell.info.index)
         {
            return;
         }
         if(cell.info.state == BoguAdventureCellInfo.OPEN)
         {
            if(cell.info.result == BoguAdventureCellInfo.MINE)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.walkTip"));
               return;
            }
         }
         if(cell.info.state == BoguAdventureCellInfo.SIGN)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.isSign"));
            return;
         }
         this.mouseClickClose();
         this.boguWalk(cell.info.index);
      }
      
      private function boguWalk(index:int) : void
      {
         var hIndex:int = 0;
         var path:Array = new Array();
         var currentIndex:int = this._control.currentIndex - 1 < 0 ? 0 : this._control.currentIndex - 1;
         var oldIndex:uint = index - 1 < 0 ? 0 : uint(index - 1);
         var old:String = currentIndex < 10 ? "0" + currentIndex : currentIndex.toString();
         var current:String = oldIndex < 10 ? "0" + oldIndex : oldIndex.toString();
         if(this._control.currentIndex == 0)
         {
            path.push(this.getCellPosIndex(1,this._control.bogu.focusPos));
         }
         if(old.charAt(1) != current.charAt(1))
         {
            if(old.charAt(1) < current.charAt(1))
            {
               this._control.bogu.dir = SceneCharacterDirection.RB;
            }
            else
            {
               this._control.bogu.dir = SceneCharacterDirection.LB;
            }
            hIndex = int(current.charAt(0) + old.charAt(1)) + 1;
            path.push(this.getCellPosIndex(hIndex,this._control.bogu.focusPos));
         }
         path.push(this.getCellPosIndex(index,this._control.bogu.focusPos));
         this._control.currentIndex = index;
         this._control.walk(path);
      }
      
      private function __onPlayComplete(e:Event) : void
      {
         var cell:BoguAdventureCell = e.currentTarget as BoguAdventureCell;
         this._control.playActionComplete({
            "type":BoguAdventureActionType.ACTION_FINT_MINE,
            "index":cell.info.index
         });
      }
      
      public function dispose() : void
      {
         var cell:BoguAdventureCell = null;
         while(Boolean(this._cellList.length))
         {
            cell = this._cellList.pop();
            cell.removeEventListener(MouseEvent.CLICK,this.__onClickCell);
            cell.removeEventListener(BoguAdventureCell.PLAY_COMPLETE,this.__onPlayComplete);
            ObjectUtils.disposeObject(cell);
            cell = null;
         }
         this._cellList = null;
         ObjectUtils.disposeObject(this._mapBg);
         this._mapBg = null;
         this._control = null;
      }
   }
}

