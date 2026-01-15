package treasure.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import treasure.controller.TreasureManager;
   import treasure.events.TreasureEvents;
   import treasure.model.TreasureModel;
   
   public class TreasureField extends Sprite implements Disposeable
   {
      
      private var X:Number = 236;
      
      private var Y:Number = 281;
      
      private var W:Number = 61;
      
      private var H:Number = 45;
      
      private var _fieldList:Vector.<TreasureCell>;
      
      private var cartoon:MovieClip;
      
      private var _fieldMc:MovieClip;
      
      private var _fieldMcList:Array;
      
      public function TreasureField(place:Sprite)
      {
         super();
         place.addChild(this);
         this.initListener();
      }
      
      private function initListener() : void
      {
         TreasureManager.instance.addEventListener(TreasureEvents.FIELD_CHANGE,this.__fieldChangeHandler);
      }
      
      public function setField(dis:Boolean) : void
      {
         var j:int = 0;
         var cell:TreasureCell = null;
         this.creatField();
         this._fieldList = new Vector.<TreasureCell>();
         var index:int = 0;
         for(var i:int = 0; i < 4; i++)
         {
            for(j = 0; j < 4; j++)
            {
               cell = new TreasureCell(index + 1,dis);
               cell.x = this.X + (cell.width + 2 - this.W) * i + this.W * j;
               cell.y = this.Y + (cell.height - 4 - this.H) * i - this.H * j;
               addChild(cell);
               cell.addEvent();
               this._fieldList.push(cell);
               index++;
            }
         }
      }
      
      private function creatField() : void
      {
         var index:int = 0;
         var i:int = 0;
         var j:int = 0;
         index = 0;
         this._fieldMcList = [];
         for(i = 0; i < 4; i++)
         {
            for(j = 0; j < 4; j++)
            {
               this._fieldMc = ComponentFactory.Instance.creat("asset.treasure.field");
               this._fieldMc.x = this.X + (this._fieldMc.width + 2 - this.W) * i + this.W * j;
               this._fieldMc.y = this.Y + (this._fieldMc.height - 4 - this.H) * i - this.H * j;
               if(TreasureModel.instance.itemList[index].pos > 0)
               {
                  this._fieldMc.gotoAndStop(2);
               }
               else
               {
                  this._fieldMc.gotoAndStop(1);
               }
               addChild(this._fieldMc);
               this._fieldMcList.push(this._fieldMc);
               index++;
            }
         }
      }
      
      private function __fieldChangeHandler(e:TreasureEvents) : void
      {
         this._fieldMcList[e.info.pos - 1].gotoAndStop(2);
      }
      
      public function endGameShow() : void
      {
         for(var i:int = 0; i < this._fieldList.length; i++)
         {
            if(TreasureModel.instance.itemList[this._fieldList[i]._fieldPos - 1].pos == 0)
            {
               this._fieldList[i].creatCartoon("end");
            }
         }
      }
      
      public function playStartCartoon() : void
      {
         var cell:TreasureFieldCell = null;
         for(var j:int = 0; j < this._fieldList.length; j++)
         {
            this._fieldList[j].cartoon.visible = false;
         }
         this.cartoon = ComponentFactory.Instance.creat("asset.treasure.cartoon2");
         var s:Sprite = new Sprite();
         s.graphics.beginFill(16777215,0);
         s.graphics.drawRect(0,0,43,43);
         s.graphics.endFill();
         for(var i:int = 1; i <= TreasureModel.instance.itemList.length; i++)
         {
            cell = new TreasureFieldCell(s,TreasureModel.instance.itemList[i - 1]);
            this.cartoon["mc" + i].addChild(cell);
         }
         addChild(this.cartoon);
         PositionUtils.setPos(this.cartoon,"cartoon2.pos");
         this.cartoon.addEventListener(Event.ENTER_FRAME,this.onCompleteHandeler);
      }
      
      public function digField(pos:int) : void
      {
         swapChildren(this._fieldList[pos - 1],this._fieldList[this._fieldList.length - 1]);
         this._fieldList[pos - 1].digBackHandler();
      }
      
      private function onCompleteHandeler(e:Event) : void
      {
         var j:int = 0;
         if(this.cartoon != null && this.cartoon.currentFrame == this.cartoon.totalFrames)
         {
            this.cartoon.removeEventListener(Event.ENTER_FRAME,this.onCompleteHandeler);
            if(Boolean(this.cartoon))
            {
               ObjectUtils.disposeObject(this.cartoon);
            }
            this.cartoon = null;
            for(j = 0; j < this._fieldList.length; j++)
            {
               this._fieldList[j].addEvent();
            }
         }
      }
      
      private function removeListener() : void
      {
         TreasureManager.instance.removeEventListener(TreasureEvents.FIELD_CHANGE,this.__fieldChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeListener();
         if(Boolean(this.cartoon))
         {
            ObjectUtils.disposeObject(this.cartoon);
         }
         this.cartoon = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

