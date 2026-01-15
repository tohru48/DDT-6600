package game.view.propContainer
{
   import bagAndInfo.bag.ItemCellView;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import ddt.data.PropInfo;
   import ddt.events.ItemEvent;
   import ddt.view.PropItemView;
   import flash.display.DisplayObject;
   
   [Event(name="itemMove",type="ddt.events.ItemEvent")]
   [Event(name="itemOut",type="ddt.events.ItemEvent")]
   [Event(name="itemOver",type="ddt.events.ItemEvent")]
   [Event(name="itemClick",type="ddt.events.ItemEvent")]
   public class ItemContainer extends SimpleTileList
   {
      
      public static var USE_THREE:String = "use_threeSkill";
      
      public static var PLANE:int = 1;
      
      public static var THREE_SKILL:int = 2;
      
      public static var BOTH:int = 3;
      
      private var list:Array;
      
      private var _ordinal:Boolean;
      
      private var _clickAble:Boolean;
      
      public function ItemContainer(count:Number, column:Number = 1, bgvisible:Boolean = true, ordinal:Boolean = false, clickable:Boolean = false, EffectType:String = "")
      {
         var item:ItemCellView = null;
         super(column);
         vSpace = 4;
         hSpace = 6;
         this.list = new Array();
         for(var i:int = 0; i < count; i++)
         {
            item = new ItemCellView(i,null,false,EffectType);
            item.addEventListener(ItemEvent.ITEM_CLICK,this.__itemClick);
            item.addEventListener(ItemEvent.ITEM_OVER,this.__itemOver);
            item.addEventListener(ItemEvent.ITEM_OUT,this.__itemOut);
            item.addEventListener(ItemEvent.ITEM_MOVE,this.__itemMove);
            addChild(item);
            this.list.push(item);
         }
         this._clickAble = clickable;
         this._ordinal = ordinal;
      }
      
      public function setState(clickable:Boolean, isGray:Boolean) : void
      {
         this._clickAble = clickable;
         this.setItemState(clickable,isGray);
      }
      
      public function get clickAble() : Boolean
      {
         return this._clickAble;
      }
      
      public function appendItem(item:DisplayObject) : void
      {
         var cell:ItemCellView = null;
         for each(cell in this.list)
         {
            if(cell.item == null)
            {
               cell.setItem(item,false);
               return;
            }
         }
      }
      
      public function get blankItems() : Array
      {
         var cell:ItemCellView = null;
         var ar:Array = [];
         var index:int = 0;
         for each(cell in this.list)
         {
            if(cell.item == null)
            {
               ar.push(index);
            }
            index++;
         }
         return ar;
      }
      
      public function mouseClickAt(index:int) : void
      {
         this.list[index].mouseClick();
      }
      
      private function __itemClick(event:ItemEvent) : void
      {
         this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK,event.item,event.index));
      }
      
      private function __itemOver(event:ItemEvent) : void
      {
         this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_OVER,event.item,event.index));
      }
      
      private function __itemOut(event:ItemEvent) : void
      {
         this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_OUT,event.item,event.index));
      }
      
      private function __itemMove(event:ItemEvent) : void
      {
         this.dispatchEvent(new ItemEvent(ItemEvent.ITEM_MOVE,event.item,event.index));
      }
      
      public function appendItemAt(item:DisplayObject, index:int) : void
      {
         var cell:ItemCellView = null;
         var i:int = 0;
         if(this._ordinal)
         {
            cell = this.list[this.list.length - 1] as ItemCellView;
            for(i = index; i < this.list.length - 1; i++)
            {
               this.list[i + 1] = this.list[i];
            }
            this.list[index] = cell;
            cell.setItem(item,false);
         }
         else
         {
            cell = this.list[index];
            cell.setItem(item,false);
         }
      }
      
      public function removeItem(item:DisplayObject) : void
      {
         var cell:ItemCellView = null;
         for(var i:int = 0; i < this.list.length; i++)
         {
            cell = this.list[i];
            if(cell.item == item)
            {
               removeChild(cell);
            }
         }
      }
      
      public function removeItemAt(index:int) : void
      {
         var cell:ItemCellView = this.list[index];
         cell.setItem(null,false);
         if(this._ordinal)
         {
            this.list.splice(index,1);
            removeChild(cell);
            this.list.push(cell);
         }
      }
      
      public function clear() : void
      {
         var cell:ItemCellView = null;
         for each(cell in this.list)
         {
            cell.setItem(null,false);
         }
      }
      
      public function setItemClickAt(index:int, isClick:Boolean, isGray:Boolean) : void
      {
         this.list[index].setClick(isClick,isGray,false);
      }
      
      public function disableCellIndex(index:int) : void
      {
         this.list[index].disable();
      }
      
      public function disableSelfProp(value:int) : void
      {
         var cell:ItemCellView = null;
         var info:PropInfo = null;
         for each(cell in this.list)
         {
            if(Boolean(cell.item))
            {
               info = PropItemView(cell.item).info;
               if(info.Template.TemplateID == 10016 && (value == 1 || value == 3))
               {
                  cell.disable();
               }
               else if(info.Template.TemplateID == 10003 && (value == 2 || value == 3))
               {
                  cell.disable();
               }
            }
         }
      }
      
      public function disableCellArr() : void
      {
         var cell:ItemCellView = null;
         for each(cell in this.list)
         {
            cell.disable();
         }
      }
      
      public function setNoClickAt(index:int) : void
      {
         this.list[index].setNoEnergyAsset();
      }
      
      private function setItemState(isClick:Boolean, isGray:Boolean) : void
      {
         var cell:ItemCellView = null;
         var isExist:Boolean = false;
         for each(cell in this.list)
         {
            isExist = false;
            if(PropItemView(cell.item) != null)
            {
               isExist = PropItemView(cell.item).isExist;
            }
            cell.setClick(isClick,isGray,isExist);
         }
      }
      
      public function setClickByEnergy(energy:int) : void
      {
         var cell:ItemCellView = null;
         var info:PropInfo = null;
         for each(cell in this.list)
         {
            if(Boolean(cell.item))
            {
               info = PropItemView(cell.item).info;
               if(Boolean(info))
               {
                  if(energy < info.needEnergy)
                  {
                     cell.setClick(true,true,PropItemView(cell.item).isExist);
                  }
               }
            }
         }
      }
      
      public function setVisible(index:int, v:Boolean) : void
      {
         this.list[index].visible = v;
      }
      
      override public function dispose() : void
      {
         var item:ItemCellView = null;
         super.dispose();
         while(this.list.length > 0)
         {
            item = this.list.shift() as ItemCellView;
            item.dispose();
         }
         this.list = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

