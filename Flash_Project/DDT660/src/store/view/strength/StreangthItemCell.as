package store.view.strength
{
   import bagAndInfo.cell.CellContentCreator;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import store.StoreCell;
   
   public class StreangthItemCell extends StoreCell
   {
      
      protected var _stoneType:String = "";
      
      protected var _actionState:Boolean;
      
      public function StreangthItemCell($index:int)
      {
         var bg:Sprite = new Sprite();
         var bgBit:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
         bg.addChild(bgBit);
         super(bg,$index);
         setContentSize(68,68);
         this.PicPos = new Point(-3,-3);
      }
      
      public function set stoneType(value:String) : void
      {
         this._stoneType = value;
      }
      
      public function set actionState(value:Boolean) : void
      {
         this._actionState = value;
      }
      
      public function get actionState() : Boolean
      {
         return this._actionState;
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
            effect.action = DragEffect.NONE;
            if(info.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
            }
            else if(info.CanStrengthen && this.isAdaptToStone(info))
            {
               if(info.StrengthenLevel >= PathManager.solveStrengthMax())
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
                  return;
               }
               SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,index,1);
               this._actionState = true;
               effect.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
               this.reset();
            }
            else if(this.isAdaptToStone(info))
            {
            }
         }
      }
      
      protected function isAdaptToStone(info:InventoryItemInfo) : Boolean
      {
         if(this._stoneType == "")
         {
            return true;
         }
         if(this._stoneType == StoneType.STRENGTH && info.RefineryLevel <= 0)
         {
            return true;
         }
         if(this._stoneType == StoneType.STRENGTH_1 && info.RefineryLevel > 0)
         {
            return true;
         }
         return false;
      }
      
      protected function reset() : void
      {
         this._stoneType = "";
      }
      
      override public function set info(value:ItemTemplateInfo) : void
      {
         if(_info == value && !_info)
         {
            return;
         }
         if(Boolean(_info))
         {
            clearCreatingContent();
            ObjectUtils.disposeObject(_pic);
            _pic = null;
            clearLoading();
            _tipData = null;
            locked = false;
         }
         _info = value;
         if(Boolean(_info))
         {
            if(_showLoading)
            {
               createLoading();
            }
            _pic = new CellContentCreator();
            _pic.info = _info;
            _pic.loadSync(createContentComplete);
            addChild(_pic);
            if(_info.CategoryID != EquipType.CARDEQUIP)
            {
               tipStyle = "ddtstore.StrengthTips";
               _tipData = new GoodTipInfo();
               GoodTipInfo(_tipData).itemInfo = info;
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

