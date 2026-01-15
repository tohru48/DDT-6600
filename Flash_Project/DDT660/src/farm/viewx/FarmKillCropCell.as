package farm.viewx
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class FarmKillCropCell extends BaseCell
   {
      
      private var _bgbmp:BaseButton = ComponentFactory.Instance.creatComponentByStylename("farm.doKillBtn");
      
      private var _invInfo:InventoryItemInfo;
      
      private var _killCropIcon:Bitmap = ComponentFactory.Instance.creatBitmap("assets.farm.killCropImg");
      
      public function FarmKillCropCell()
      {
         buttonMode = true;
         super(this._bgbmp);
         addEventListener(MouseEvent.MOUSE_OVER,this.__overFilter);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outFilter);
         addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      public function setBtnVis(value:Boolean) : void
      {
         this._bgbmp.enable = value;
         if(value == false)
         {
            removeEventListener(MouseEvent.MOUSE_OVER,this.__overFilter);
            removeEventListener(MouseEvent.MOUSE_OUT,this.__outFilter);
            removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         else
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.__overFilter);
            addEventListener(MouseEvent.MOUSE_OUT,this.__outFilter);
            addEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dragStart();
      }
      
      protected function __outFilter(event:MouseEvent) : void
      {
         filters = null;
         this._bgbmp.x += 15;
      }
      
      protected function __overFilter(event:MouseEvent) : void
      {
         filters = ComponentFactory.Instance.creatFilters("lightFilter");
         this._bgbmp.x -= 15;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         return this._invInfo;
      }
      
      public function set itemInfo(value:InventoryItemInfo) : void
      {
         super.info = value;
         this._invInfo = value;
      }
      
      private function get killCropIcon() : DisplayObject
      {
         return new Bitmap(this._killCropIcon.bitmapData.clone(),"auto",true);
      }
      
      override public function dragStart() : void
      {
         if(Boolean(stage) && _allowDrag)
         {
            if(DragManager.startDrag(this,this._invInfo,this.killCropIcon,stage.mouseX,stage.mouseY,DragEffect.MOVE,false,false,false,false,false,null,0,true))
            {
               locked = true;
            }
         }
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         if(effect.target is FarmFieldBlock)
         {
            this.dragStart();
         }
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         if(Boolean(sp))
         {
            sp.width = _contentWidth - 20;
            sp.height = _contentHeight - 20;
            if(_picPos != null)
            {
               sp.x = _picPos.x;
            }
            else
            {
               sp.x = Math.abs(sp.width - _contentWidth) / 2;
            }
            if(_picPos != null)
            {
               sp.y = _picPos.y;
            }
            else
            {
               sp.y = Math.abs(sp.height - _contentHeight) / 2;
            }
         }
      }
      
      override protected function updateSizeII(sp:Sprite) : void
      {
         sp.x = 13;
         sp.y = 10;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(MouseEvent.MOUSE_OVER,this.__overFilter);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__outFilter);
         removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         if(Boolean(this._bgbmp))
         {
            ObjectUtils.disposeObject(this._bgbmp);
         }
         this._bgbmp = null;
         if(Boolean(this._killCropIcon))
         {
            ObjectUtils.disposeObject(this._killCropIcon);
         }
         this._killCropIcon = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

