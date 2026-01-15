package farm.view.compose.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ComposeMoveScroll extends Sprite implements Disposeable
   {
      
      private const SHOW_HOUSEITEM_COUNT:int = 5;
      
      private var _currentShowIndex:int = 0;
      
      private var _petsImgVec:Vector.<FarmHouseItem>;
      
      private var _leftBtn:SimpleBitmapButton;
      
      private var _rightBtn:SimpleBitmapButton;
      
      private var _bag:BagInfo;
      
      private var _hBox:HBox;
      
      private var _start:int;
      
      public function ComposeMoveScroll()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var item:FarmHouseItem = null;
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("farmHouse.button.left");
         this._leftBtn.transparentEnable = true;
         addChild(this._leftBtn);
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("farmHouse.button.right");
         addChild(this._rightBtn);
         this._petsImgVec = new Vector.<FarmHouseItem>(this.SHOW_HOUSEITEM_COUNT);
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("farm.componsePnl.hbox");
         addChild(this._hBox);
         for(var i:int = 0; i < this.SHOW_HOUSEITEM_COUNT; i++)
         {
            item = new FarmHouseItem();
            this._petsImgVec[i] = item;
            this._hBox.addChild(item);
         }
         this._bag = PlayerManager.Instance.Self.getBag(BagInfo.VEGETABLE);
         this._start = 0;
         this.update();
      }
      
      private function initEvent() : void
      {
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__ClickHandler);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__ClickHandler);
         this._bag.addEventListener(BagEvent.UPDATE,this.__bagUpdate);
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.__ClickHandler);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.__ClickHandler);
         this._bag.removeEventListener(BagEvent.UPDATE,this.__bagUpdate);
      }
      
      private function __bagUpdate(event:BagEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var end:int = 0;
         var i:int = 0;
         this.clearItem();
         if(this._bag.items.length > 0)
         {
            end = this._bag.items.length > this._start + this.SHOW_HOUSEITEM_COUNT ? this._start + this.SHOW_HOUSEITEM_COUNT : this._bag.items.length;
            for(i = this._start; i < end; i++)
            {
               this._petsImgVec[i - this._start].info = this._bag.items.list[i];
            }
         }
      }
      
      private function clearItem() : void
      {
         for(var i:int = 0; i < this.SHOW_HOUSEITEM_COUNT; i++)
         {
            this._petsImgVec[i].info = null;
         }
      }
      
      private function __ClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.currentTarget)
         {
            case this._leftBtn:
               if(this._start - 1 >= 0)
               {
                  this._start -= 1;
               }
               break;
            case this._rightBtn:
               if(this._start + 1 <= this._bag.items.length - this.SHOW_HOUSEITEM_COUNT)
               {
                  this._start += 1;
               }
         }
         this.update();
      }
      
      public function dispose() : void
      {
         var item:FarmHouseItem = null;
         this.removeEvent();
         this._bag = null;
         this._start = 0;
         for each(item in this._petsImgVec)
         {
            if(Boolean(item))
            {
               item.dispose();
               item = null;
            }
         }
         this._petsImgVec.splice(0,this._petsImgVec.length);
         if(Boolean(this._hBox))
         {
            ObjectUtils.disposeObject(this._hBox);
            this._hBox = null;
         }
         if(Boolean(this._leftBtn))
         {
            ObjectUtils.disposeObject(this._leftBtn);
            this._leftBtn = null;
         }
         if(Boolean(this._rightBtn))
         {
            ObjectUtils.disposeObject(this._rightBtn);
            this._rightBtn = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

