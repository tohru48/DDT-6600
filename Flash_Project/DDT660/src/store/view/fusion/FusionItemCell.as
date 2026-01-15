package store.view.fusion
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   import store.StoreCell;
   import store.StrengthDataManager;
   import store.view.StoneCellFrame;
   
   public class FusionItemCell extends StoreCell
   {
      
      public static const SHINE_XY:int = 8;
      
      public static const SHINE_SIZE:int = 76;
      
      private var bg:Sprite = new Sprite();
      
      private var canMouseEvt:Boolean = true;
      
      private var _cellBg:StoneCellFrame = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIFusionBG.Material");
      
      private var _autoSplit:Boolean;
      
      public function FusionItemCell($index:int)
      {
         this._cellBg.label = LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.MaterialCellText");
         this.bg.addChild(this._cellBg);
         super(this.bg,$index);
         PicPos = new Point(10,10);
      }
      
      public function set bgVisible(boo:Boolean) : void
      {
         this.bg.alpha = int(boo);
      }
      
      override public function startShine() : void
      {
         _shiner.x = SHINE_XY;
         _shiner.y = SHINE_XY;
         _shiner.width = _shiner.height = SHINE_SIZE;
         super.startShine();
      }
      
      public function set mouseEvt(boo:Boolean) : void
      {
         this.canMouseEvt = boo;
      }
      
      override protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         if(!this.canMouseEvt)
         {
            return;
         }
         if(!DoubleClickEnabled)
         {
            return;
         }
         if(info == null)
         {
            return;
         }
         if((evt.currentTarget as BagCell).info != null)
         {
            if((evt.currentTarget as BagCell).info != null)
            {
               if(StrengthDataManager.instance.autoFusion)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.fusion.donMoveGoods"));
               }
               else
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,index,itemBagType,-1);
               }
               if(!mouseSilenced)
               {
                  SoundManager.instance.play("008");
               }
            }
         }
      }
      
      override protected function __clickHandler(evt:InteractiveEvent) : void
      {
         if(!this.canMouseEvt)
         {
            return;
         }
         if(_info && !locked && stage && allowDrag)
         {
            SoundManager.instance.play("008");
         }
         this.dragStart();
      }
      
      override public function dragStart() : void
      {
         super.dragStart();
         StoreIIFusionBG.lastIndexFusion = index;
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         super.dragStop(effect);
         StoreIIFusionBG.lastIndexFusion = -1;
      }
      
      override protected function updateSize(sp:Sprite) : void
      {
         if(Boolean(sp))
         {
            sp.width = _contentWidth - 18;
            sp.height = _contentHeight - 18;
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
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(Boolean(_tbxCount))
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("ddtstore.StoreIIFusionBG.FunsionstoneCountTextII");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         var _aler:FusionSelectNumAlertFrame = null;
         if(!this.canMouseEvt)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var sourceInfo:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(sourceInfo.BagType == BagInfo.STOREBAG && this.info != null)
         {
            return;
         }
         if(Boolean(sourceInfo) && effect.action != DragEffect.SPLIT)
         {
            effect.action = DragEffect.NONE;
            if(sourceInfo.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.overdue"));
               return;
            }
            if(sourceInfo.Property1 == StoneType.FORMULA)
            {
               return;
            }
            if(sourceInfo.FusionType == 0 || sourceInfo.FusionRate == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.fusion"));
               return;
            }
            if(StrengthDataManager.instance.autoFusion)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.fusion.donMoveGoods"));
               effect.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
               return;
            }
            if(sourceInfo.Count > 1)
            {
               this._autoSplit = (this.parent as StoreIIFusionBG).isAutoSplit;
               if(this._autoSplit && StoreIIFusionBG.lastIndexFusion == -1)
               {
                  StoreIIFusionBG.autoSplitSend(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,StoreIIFusionBG.getRemainIndexByEmpty(sourceInfo.Count,this.parent as StoreIIFusionBG),sourceInfo.Count,true,this.parent as StoreIIFusionBG);
               }
               else
               {
                  _aler = ComponentFactory.Instance.creat("ddtstore.FusionSelectNumAlertFrame");
                  _aler.goodsinfo = sourceInfo;
                  _aler.index = index;
                  _aler.show(sourceInfo.Count);
                  _aler.addEventListener(FusionSelectEvent.SELL,this._alerSell);
                  _aler.addEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
               }
            }
            else
            {
               SocketManager.Instance.out.sendMoveGoods(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,index,sourceInfo.Count,true);
            }
            effect.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
      }
      
      private function _alerSell(e:FusionSelectEvent) : void
      {
         var _aler:FusionSelectNumAlertFrame = e.currentTarget as FusionSelectNumAlertFrame;
         SocketManager.Instance.out.sendMoveGoods(e.info.BagType,e.info.Place,BagInfo.STOREBAG,e.index,e.sellCount,true);
         _aler.removeEventListener(FusionSelectEvent.SELL,this._alerSell);
         _aler.removeEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
         _aler.dispose();
         if(Boolean(_aler) && Boolean(_aler.parent))
         {
            removeChild(_aler);
         }
         _aler = null;
      }
      
      private function _alerNotSell(e:FusionSelectEvent) : void
      {
         var _aler:FusionSelectNumAlertFrame = e.currentTarget as FusionSelectNumAlertFrame;
         _aler.removeEventListener(FusionSelectEvent.SELL,this._alerSell);
         _aler.removeEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
         _aler.dispose();
         if(Boolean(_aler) && Boolean(_aler.parent))
         {
            removeChild(_aler);
         }
         _aler = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._cellBg))
         {
            ObjectUtils.disposeObject(this._cellBg);
         }
         this._cellBg = null;
      }
   }
}

