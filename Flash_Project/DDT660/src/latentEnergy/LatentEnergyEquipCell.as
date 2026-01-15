package latentEnergy
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.DisplayObject;
   
   public class LatentEnergyEquipCell extends BagCell
   {
      
      private var _latentEnergyItemId:int;
      
      public function LatentEnergyEquipCell(index:int, info:ItemTemplateInfo = null, showLoading:Boolean = true, bg:DisplayObject = null, mouseOverEffBoolean:Boolean = true)
      {
         super(index,info,showLoading,bg,mouseOverEffBoolean);
      }
      
      public function set latentEnergyItemId(value:int) : void
      {
         this._latentEnergyItemId = value;
         if(Boolean(_tipData) && _tipData is GoodTipInfo)
         {
            (_tipData as GoodTipInfo).latentEnergyItemId = this._latentEnergyItemId;
         }
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         super.info = value;
         if(Boolean(_tipData) && _tipData is GoodTipInfo)
         {
            (_tipData as GoodTipInfo).latentEnergyItemId = this._latentEnergyItemId;
         }
      }
      
      override public function get tipStyle() : String
      {
         return "latentEnergy.LatentEnergyPreTip";
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
         LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
      }
      
      private function equipMoveHandler(event:LatentEnergyEvent) : void
      {
         var event2:LatentEnergyEvent = null;
         if(info == event.info)
         {
            return;
         }
         if(Boolean(info))
         {
            event2 = new LatentEnergyEvent(LatentEnergyManager.EQUIP_MOVE2);
            event2.info = info as InventoryItemInfo;
            event2.moveType = 3;
            LatentEnergyManager.instance.dispatchEvent(event2);
         }
         this.info = event.info;
      }
      
      private function equipMoveHandler2(event:LatentEnergyEvent) : void
      {
         if(info != event.info || event.moveType != 2)
         {
            return;
         }
         this.info = null;
      }
      
      protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         if(!info)
         {
            return;
         }
         SoundManager.instance.play("008");
         var event:LatentEnergyEvent = new LatentEnergyEvent(LatentEnergyManager.EQUIP_MOVE2);
         event.info = info as InventoryItemInfo;
         event.moveType = 2;
         LatentEnergyManager.instance.dispatchEvent(event);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
      }
      
      protected function __clickHandler(evt:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         dragStart();
      }
      
      public function clearInfo() : void
      {
         var event:LatentEnergyEvent = null;
         if(Boolean(info))
         {
            event = new LatentEnergyEvent(LatentEnergyManager.EQUIP_MOVE2);
            event.info = info as InventoryItemInfo;
            event.moveType = 2;
            LatentEnergyManager.instance.dispatchEvent(event);
         }
      }
   }
}

