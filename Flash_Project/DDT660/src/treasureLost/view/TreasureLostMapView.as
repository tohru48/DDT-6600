package treasureLost.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import treasureLost.events.TreasureLostEvents;
   
   public class TreasureLostMapView extends MovieClip implements Disposeable
   {
      
      private var _mapArrStr:String;
      
      public var mapArr:Array;
      
      public var mapPosArr:Array;
      
      public var mapItemArr:Array;
      
      private var mapId:int;
      
      private var selectDirectionMc1:MovieClip;
      
      private var selectDirectionMc2:MovieClip;
      
      public function TreasureLostMapView($mapStr:String, $mapPosStr:String, $mapId:int)
      {
         super();
         this.mapArrStr = $mapStr;
         this.mapPosArr = $mapPosStr.split("|");
         this.mapId = $mapId;
         this.mapItemArr = [];
         this.initMapItem();
         this.initMapSelectionMc();
         this.addEvent();
      }
      
      public function initMapSelectionMc() : void
      {
         this.selectDirectionMc1 = ComponentFactory.Instance.creat("treasureLost.map.selectDicrection");
         this.selectDirectionMc2 = ComponentFactory.Instance.creat("treasureLost.map.selectDicrection");
         addChild(this.selectDirectionMc1);
         addChild(this.selectDirectionMc2);
         if(this.mapId == 1)
         {
            this.selectDirectionMc1.rotation = 90;
            this.selectDirectionMc2.scaleX = -1;
            PositionUtils.setPos(this.selectDirectionMc1,"treasureLost.map.selectDicrectionMap1_1");
            PositionUtils.setPos(this.selectDirectionMc2,"treasureLost.map.selectDicrectionMap1_2");
         }
         else if(this.mapId == 2)
         {
            this.selectDirectionMc1.rotation = 90;
            PositionUtils.setPos(this.selectDirectionMc1,"treasureLost.map.selectDicrectionMap2_1");
            PositionUtils.setPos(this.selectDirectionMc2,"treasureLost.map.selectDicrectionMap2_2");
         }
         else if(this.mapId == 3)
         {
            this.selectDirectionMc1.rotation = 90;
            this.selectDirectionMc2.rotation = -90;
            PositionUtils.setPos(this.selectDirectionMc1,"treasureLost.map.selectDicrectionMap3_1");
            PositionUtils.setPos(this.selectDirectionMc2,"treasureLost.map.selectDicrectionMap3_2");
         }
         this.selectDirectionMc1.visible = false;
         this.selectDirectionMc2.visible = false;
      }
      
      private function addEvent() : void
      {
         this.selectDirectionMc1.addEventListener(MouseEvent.CLICK,this._selectDirectionMc1Click);
         this.selectDirectionMc2.addEventListener(MouseEvent.CLICK,this._selectDirectionMc2Click);
      }
      
      private function removeEvent() : void
      {
         this.selectDirectionMc1.removeEventListener(MouseEvent.CLICK,this._selectDirectionMc1Click);
         this.selectDirectionMc2.removeEventListener(MouseEvent.CLICK,this._selectDirectionMc2Click);
      }
      
      private function _selectDirectionMc1Click(e:MouseEvent) : void
      {
         dispatchEvent(new TreasureLostEvents(TreasureLostEvents.SELECTDIRECTION,2));
         this.selectDirecionMcVisible(false);
      }
      
      private function _selectDirectionMc2Click(e:MouseEvent) : void
      {
         dispatchEvent(new TreasureLostEvents(TreasureLostEvents.SELECTDIRECTION,1));
         this.selectDirecionMcVisible(false);
      }
      
      public function selectDirecionMcVisible(bool:Boolean) : void
      {
         if(bool)
         {
            this.selectDirectionMc1.visible = true;
            this.selectDirectionMc2.visible = true;
         }
         else
         {
            this.selectDirectionMc1.visible = false;
            this.selectDirectionMc2.visible = false;
         }
      }
      
      public function getTypeById($id:int) : int
      {
         var itemType:int = 0;
         var mapItem:TreasureLostMapItem = this.mapItemArr[$id];
         return mapItem.type;
      }
      
      public function set mapArrStr(str:String) : void
      {
         this._mapArrStr = str;
         this.mapArr = str.split(",");
      }
      
      public function get mapArrStr() : String
      {
         return this._mapArrStr;
      }
      
      public function initMapItem() : void
      {
         var id:int = 0;
         var posStr:String = null;
         var mapItem:TreasureLostMapItem = null;
         for(var i:int = 0; i < this.mapArr.length; i++)
         {
            id = int(this.mapArr[i]);
            posStr = this.mapPosArr[i];
            mapItem = new TreasureLostMapItem(i,id,posStr);
            addChild(mapItem);
            this.mapItemArr.push(mapItem);
         }
      }
      
      public function changeMapItemState(id:int, type:int) : void
      {
         var mapItem:TreasureLostMapItem = null;
         for(var i:int = 0; i < this.mapItemArr.length; i++)
         {
            mapItem = this.mapItemArr[i];
            if(mapItem.id == id)
            {
               mapItem.changeState(type);
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

