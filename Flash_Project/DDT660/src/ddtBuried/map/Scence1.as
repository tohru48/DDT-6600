package ddtBuried.map
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddtBuried.BuriedManager;
   import ddtBuried.data.MapItemData;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class Scence1 extends MovieClip implements Disposeable
   {
      
      private var _content:Sprite;
      
      private var _mapArray:Array = [];
      
      private var _map:Maps;
      
      private var standArray:Array;
      
      public function Scence1(str:String, row:int, col:int)
      {
         super();
         this.initView(str,row,col);
      }
      
      private function initView(str:String, row:int, col:int) : void
      {
         this._mapArray = BuriedManager.Instance.oneDegreeToTwoDegree(str,row,col);
         this._map = new Maps(this._mapArray,row,col);
         addChild(this._map);
         this.initMapItem();
      }
      
      private function initMapItem() : void
      {
         var xIndex:int = 0;
         var yIndex:int = 0;
         var bitmap:Bitmap = null;
         var spStart:Sprite = null;
         var spEnd:Sprite = null;
         var mc:MovieClip = null;
         var data:MapItemData = null;
         var spItem:Sprite = null;
         if(BuriedManager.Instance.mapID == BuriedManager.MAP1)
         {
            this.standArray = BuriedManager.Instance.mapArrays.standArray1;
         }
         else if(BuriedManager.Instance.mapID == BuriedManager.MAP2)
         {
            this.standArray = BuriedManager.Instance.mapArrays.standArray2;
         }
         else
         {
            this.standArray = BuriedManager.Instance.mapArrays.standArray3;
         }
         var list:Vector.<MapItemData> = BuriedManager.Instance.mapdataList;
         var len:int = int(list.length);
         xIndex = int(this.standArray[0].x);
         yIndex = int(this.standArray[0].y);
         spStart = new Sprite();
         bitmap = ComponentFactory.Instance.creat("buried.shaizi.startPoint");
         bitmap.scaleX = bitmap.scaleY = 0.8;
         spStart.addChild(bitmap);
         if(this._map.getMapArray()[yIndex][xIndex].numChildren > 0)
         {
            this._map.getMapArray()[yIndex][xIndex].removeChildAt(0);
         }
         this._map.getMapArray()[yIndex][xIndex].addChild(spStart);
         spEnd = this.creatIcon(BuriedManager.Instance.getUpdateData(false).DestinationReward);
         xIndex = int(this.standArray[35].x);
         yIndex = int(this.standArray[35].y);
         mc = ComponentFactory.Instance.creat("buried.over.light");
         mc.scaleX = mc.scaleY = 0.7;
         mc.x = 347.15;
         mc.y = 201.85;
         this._map.getMapArray()[yIndex][xIndex].addChild(mc);
         this._map.getMapArray()[yIndex][xIndex].addChild(spEnd);
         for(var i:int = 0; i < len; i++)
         {
            data = list[i];
            xIndex = int(this.standArray[data.type].x);
            yIndex = int(this.standArray[data.type].y);
            spItem = this.creatIcon(data.tempID);
            this._map.getMapArray()[yIndex][xIndex].addChild(spItem);
         }
         var manX:int = int(this.standArray[BuriedManager.Instance.nowPosition].x);
         var manY:int = int(this.standArray[BuriedManager.Instance.nowPosition].y);
         this._map.setRoadMan(manX,manY);
      }
      
      public function getRoadPoint() : Point
      {
         var p:Point = new Point();
         var manX:int = int(this.standArray[0].x);
         var manY:int = int(this.standArray[0].y);
         p.x = this._map.getMapArray()[manY][manX].x;
         p.y = this._map.getMapArray()[manY][manX].y;
         return p;
      }
      
      public function updateRoadPoint(pos:int = 0) : void
      {
         var xIndex:int = 0;
         var yIndex:int = 0;
         var bitMap:Bitmap = ComponentFactory.Instance.creat("buried.shaizi.nothing");
         if(pos == 0)
         {
            xIndex = int(this.standArray[BuriedManager.Instance.nowPosition].x);
            yIndex = int(this.standArray[BuriedManager.Instance.nowPosition].y);
         }
         else
         {
            xIndex = int(this.standArray[pos].x);
            yIndex = int(this.standArray[pos].y);
         }
         this._map.getMapArray()[yIndex][xIndex].addChild(bitMap);
      }
      
      private function creatIcon(id:int) : Sprite
      {
         var bitMap:Bitmap = null;
         var cmp1:Component = null;
         var cmp2:Component = null;
         var info:ItemTemplateInfo = null;
         var cell:BagCell = null;
         var sp:Sprite = new Sprite();
         switch(id)
         {
            case 0:
               bitMap = ComponentFactory.Instance.creat("buried.shaizi.nothing");
               break;
            case -1:
               bitMap = ComponentFactory.Instance.creat("buried.shaizi.returnO");
               break;
            case -2:
               bitMap = ComponentFactory.Instance.creat("buried.shaizi.backStep");
               break;
            case -3:
               bitMap = ComponentFactory.Instance.creat("buried.shaizi.comStep");
               break;
            case -4:
               bitMap = ComponentFactory.Instance.creat("buried.shaizi.toOver");
               break;
            case -5:
               bitMap = ComponentFactory.Instance.creat("buried.shaizi.stonePic");
               cmp1 = ComponentFactory.Instance.creat("buried.cellTipComponent");
               cmp1.tipData = LanguageMgr.GetTranslation("buried.shaizi.stonePic.tipText");
               sp = cmp1;
               break;
            case -6:
               bitMap = ComponentFactory.Instance.creat("buried.shaizi.renwu");
               cmp2 = ComponentFactory.Instance.creat("buried.cellTipComponent");
               cmp2.tipData = LanguageMgr.GetTranslation("buried.shaizi.renwu.tipText");
               sp = cmp2;
               break;
            case -7:
               bitMap = ComponentFactory.Instance.creat("buried.shaizi.openQue");
               break;
            default:
               info = ItemManager.Instance.getTemplateById(id);
               cell = new BagCell(0,info);
               cell.setBgVisible(false);
               cell.width = 55;
               cell.height = 55;
               sp = cell;
         }
         if(Boolean(bitMap))
         {
            bitMap.smoothing = true;
            bitMap.width = 50;
            bitMap.height = 50;
            sp.addChild(bitMap);
         }
         sp.x = 3;
         sp.y = 1;
         return sp;
      }
      
      public function selfFindPath(xpos:int, ypos:int) : void
      {
         this._map.startMove(xpos,ypos);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._map))
         {
            this._map.dispose();
         }
         ObjectUtils.disposeObject(this._map);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._map = null;
         this.standArray = null;
      }
   }
}

