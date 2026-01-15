package store.view.exalt
{
   import bagAndInfo.cell.CellContentCreator;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.tips.GoodTipInfo;
   import flash.events.Event;
   import store.view.strength.StreangthItemCell;
   
   public class ExaltItemCell extends StreangthItemCell
   {
      
      public function ExaltItemCell($index:int)
      {
         super($index);
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
               SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,index,1);
               _actionState = true;
               effect.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
               reset();
            }
         }
      }
      
      override protected function isAdaptToStone(info:InventoryItemInfo) : Boolean
      {
         if(info.StrengthenLevel >= 15)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.exalt.warningI"));
            return false;
         }
         if(_stoneType == "")
         {
            return true;
         }
         if(_stoneType == StoneType.STRENGTH && info.RefineryLevel <= 0)
         {
            return true;
         }
         if(_stoneType == StoneType.STRENGTH_1 && info.RefineryLevel > 0)
         {
            return true;
         }
         return false;
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
               tipStyle = "ddtstore.ExaltTips";
               _tipData = new GoodTipInfo();
               GoodTipInfo(_tipData).itemInfo = info;
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}

