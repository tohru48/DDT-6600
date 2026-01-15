package magicStone.components
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MgStoneCell extends BagCell
   {
      
      private var _lockIcon:Bitmap;
      
      protected var _nameTxt:FilterFrameText;
      
      public function MgStoneCell(index:int = 0, info:ItemTemplateInfo = null, showLoading:Boolean = true, bg:DisplayObject = null)
      {
         super(index,info,showLoading,bg);
         _picPos = new Point(2,0);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         addEventListener(InteractiveEvent.CLICK,this.onClick);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(InteractiveEvent.CLICK,this.onClick);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.onDoubleClick);
         DoubleClickManager.Instance.disableDoubleClick(this);
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
      }
      
      protected function onClick(evt:InteractiveEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this));
      }
      
      protected function onDoubleClick(evt:InteractiveEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(Boolean(info))
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,this));
         }
      }
      
      override public function dragStart() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(_info && !locked && stage && _allowDrag)
         {
            if(DragManager.startDrag(this,_info,createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
            {
               locked = true;
               this.dragHidePicTxt();
               if(Boolean(_info) && _pic.numChildren > 0)
               {
                  dispatchEvent(new CellEvent(CellEvent.DRAGSTART,this.info,true));
               }
            }
         }
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         var info:InventoryItemInfo = null;
         if(effect.data is InventoryItemInfo)
         {
            info = effect.data as InventoryItemInfo;
            if(effect.source is MgStoneCell)
            {
               SocketManager.Instance.out.moveMagicStone(info.Place,_place);
               DragManager.acceptDrag(this);
               return;
            }
         }
         else if(effect.source is MgStoneLockBtn)
         {
            DragManager.acceptDrag(this);
         }
         else if(effect.source is MgStoneFeedBtn)
         {
            DragManager.acceptDrag(this);
         }
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,null,true));
         if(effect.action == DragEffect.MOVE)
         {
            if(!effect.target)
            {
               effect.action = DragEffect.NONE;
               if(!(effect.target is MgStoneCell))
               {
                  if(!effect.target)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magicStone.CanntDestory"));
                  }
               }
            }
            else
            {
               locked = false;
            }
         }
         this.dragShowPicTxt();
         super.dragStop(effect);
      }
      
      private function dragHidePicTxt() : void
      {
         if(Boolean(this._lockIcon))
         {
            this._lockIcon.visible = false;
         }
      }
      
      private function dragShowPicTxt() : void
      {
         if(itemInfo.goodsLock && Boolean(this._lockIcon))
         {
            this._lockIcon.visible = true;
         }
      }
      
      public function lockMgStone() : void
      {
         if(!itemInfo.goodsLock)
         {
            if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = true;
            }
            else
            {
               this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon1");
               this._lockIcon.scaleY = 0.7;
               this._lockIcon.scaleX = 0.7;
               this.addChild(this._lockIcon);
            }
            setChildIndex(this._lockIcon,numChildren - 1);
            SocketManager.Instance.out.lockMagicStone(_place);
         }
         else
         {
            if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = false;
            }
            SocketManager.Instance.out.lockMagicStone(_place);
         }
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         if(Boolean(_info))
         {
            _tipData = null;
            locked = false;
            if(Boolean(this._nameTxt))
            {
               this._nameTxt.htmlText = "";
               this._nameTxt.visible = false;
            }
         }
         super.info = value;
         if(Boolean(value))
         {
            if(!this._nameTxt)
            {
               this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.mgStoneCell.name");
               this._nameTxt.mouseEnabled = false;
               addChild(this._nameTxt);
            }
            this._nameTxt.text = value.Name.substr(0,2);
            this._nameTxt.visible = true;
            setChildIndex(this._nameTxt,numChildren - 1);
            if(Boolean(itemInfo) && itemInfo.goodsLock)
            {
               if(Boolean(this._lockIcon))
               {
                  this._lockIcon.visible = true;
               }
               else
               {
                  this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon1");
                  this._lockIcon.scaleY = 0.7;
                  this._lockIcon.scaleX = 0.7;
                  this.addChild(this._lockIcon);
               }
               setChildIndex(this._lockIcon,numChildren - 1);
            }
            else if(Boolean(this._lockIcon))
            {
               this._lockIcon.visible = false;
            }
         }
         else if(Boolean(this._lockIcon))
         {
            this._lockIcon.visible = false;
         }
      }
      
      override protected function createLoading() : void
      {
         super.createLoading();
         PositionUtils.setPos(_loadingasset,"ddt.personalInfocell.loadingPos");
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._lockIcon);
         this._lockIcon = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         super.dispose();
      }
   }
}

