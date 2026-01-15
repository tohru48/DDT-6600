package enchant.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class EnchantCell extends BagCell
   {
      
      private var _type:int;
      
      private var _itemBagType:int;
      
      public function EnchantCell(type:int, index:int, info:ItemTemplateInfo = null, showLoading:Boolean = true, bg:DisplayObject = null, mouseOverEffBoolean:Boolean = true)
      {
         this._type = type;
         if(this._type == 0)
         {
            this._itemBagType = 1;
         }
         else if(this._type == 1)
         {
            this._itemBagType = 0;
         }
         super(index,info,showLoading,bg,mouseOverEffBoolean);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         if(!info)
         {
            return;
         }
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,this._type,this._itemBagType,-1);
      }
      
      protected function __clickHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         dragStart();
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
      }
   }
}

