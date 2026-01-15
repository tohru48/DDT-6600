package texpSystem.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import texpSystem.data.TexpInfo;
   
   public class TexpCell extends BagCell
   {
      
      private var _texpInfo:TexpInfo;
      
      private var _shiner:ShineObject;
      
      private var _texpCountSelectFrame:TexpCountSelectFrame;
      
      public function TexpCell()
      {
         var s:Sprite = new Sprite();
         var bg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.texpSystem.itemBg1");
         s.addChild(bg);
         super(0,null,true,s);
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.texpSystem.cellShine"));
         addChild(this._shiner);
         this._shiner.mouseEnabled = false;
         this._shiner.mouseChildren = false;
         var rect:Rectangle = ComponentFactory.Instance.creatCustomObject("texpSystem.texpCell.content");
         setContentSize(rect.width,rect.height);
         PicPos = new Point(rect.x,rect.y);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
      }
      
      private function getNeedCount(sigExp:int) : int
      {
         var count:int = (this._texpInfo.upExp - this._texpInfo.currExp) / sigExp;
         if((this._texpInfo.upExp - this._texpInfo.currExp) % sigExp > 0)
         {
            count = int(count) + 1;
         }
         return count;
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var info:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(Boolean(info) && effect.action != DragEffect.SPLIT)
         {
            if(info.CategoryID != EquipType.TEXP)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("texpSystem.view.TexpCell.typeError"));
               return;
            }
            this._texpCountSelectFrame = new TexpCountSelectFrame();
            this._texpCountSelectFrame = ComponentFactory.Instance.creatComponentByStylename("texpSystem.TexpCountSelectFrame");
            this._texpCountSelectFrame.addEventListener(FrameEvent.RESPONSE,this.__ontexpCountResponse);
            this._texpCountSelectFrame.texpInfo = info;
            this._texpCountSelectFrame.show(this.getNeedCount(int(info.Property2)),info.Count);
            effect.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
      }
      
      private function __ontexpCountResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var texpInfo:InventoryItemInfo = this._texpCountSelectFrame.texpInfo;
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this._texpCountSelectFrame.dispose();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(Boolean(info))
               {
                  SocketManager.Instance.out.sendClearStoreBag();
               }
               SocketManager.Instance.out.sendMoveGoods(texpInfo.BagType,texpInfo.Place,BagInfo.STOREBAG,0,this._texpCountSelectFrame.count,true);
               this._texpCountSelectFrame.dispose();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(Boolean(_tbxCount))
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("texpSystem.txtCount");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
      }
      
      override protected function onMouseOut(evt:MouseEvent) : void
      {
      }
      
      public function startShine() : void
      {
         this._shiner.shine();
      }
      
      public function stopShine() : void
      {
         this._shiner.stopShine();
      }
      
      private function __clickHandler(evt:InteractiveEvent) : void
      {
         if(_info && !locked && stage && allowDrag)
         {
            SoundManager.instance.playButtonSound();
         }
         dragStart();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._shiner))
         {
            ObjectUtils.disposeObject(this._shiner);
            this._shiner = null;
         }
         if(Boolean(this._texpCountSelectFrame))
         {
            ObjectUtils.disposeObject(this._texpCountSelectFrame);
            this._texpCountSelectFrame = null;
         }
         super.dispose();
      }
      
      public function get texpInfo() : TexpInfo
      {
         return this._texpInfo;
      }
      
      public function set texpInfo(value:TexpInfo) : void
      {
         this._texpInfo = value;
      }
   }
}

