package game.view.propContainer
{
   import bagAndInfo.bag.ItemCellView;
   import bombKing.BombKingManager;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import flash.events.KeyboardEvent;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   
   public class RightPropView extends BaseGamePropBarView
   {
      
      private static const PROP_ID:int = 10;
      
      public function RightPropView(self:LocalPlayer)
      {
         super(self,8,1,false,false,false,ItemCellView.RIGHT_PROP);
         this.initView();
         this.setItem();
      }
      
      private function initView() : void
      {
         _itemContainer.vSpace = 4;
      }
      
      private function __keyDown(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case KeyStroke.VK_1.getCode():
            case KeyStroke.VK_NUMPAD_1.getCode():
               _itemContainer.mouseClickAt(0);
               break;
            case KeyStroke.VK_2.getCode():
            case KeyStroke.VK_NUMPAD_2.getCode():
               _itemContainer.mouseClickAt(1);
               break;
            case KeyStroke.VK_3.getCode():
            case KeyStroke.VK_NUMPAD_3.getCode():
               _itemContainer.mouseClickAt(2);
               break;
            case KeyStroke.VK_4.getCode():
            case KeyStroke.VK_NUMPAD_4.getCode():
               _itemContainer.mouseClickAt(3);
               break;
            case KeyStroke.VK_5.getCode():
            case KeyStroke.VK_NUMPAD_5.getCode():
               _itemContainer.mouseClickAt(4);
               break;
            case KeyStroke.VK_6.getCode():
            case KeyStroke.VK_NUMPAD_6.getCode():
               _itemContainer.mouseClickAt(5);
               break;
            case KeyStroke.VK_7.getCode():
            case KeyStroke.VK_NUMPAD_7.getCode():
               _itemContainer.mouseClickAt(6);
               break;
            case KeyStroke.VK_8.getCode():
            case KeyStroke.VK_NUMPAD_8.getCode():
               _itemContainer.mouseClickAt(7);
         }
      }
      
      public function setItem() : void
      {
         var propId:String = null;
         var info:PropInfo = null;
         var items:Array = null;
         var i:InventoryItemInfo = null;
         _itemContainer.clear();
         var hasItem:Boolean = false;
         var propAllProp:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.T_ALL_PROP,true,true);
         var _sets:Object = SharedManager.Instance.GameKeySets;
         for(propId in _sets)
         {
            if(int(propId) == 9)
            {
               break;
            }
            info = new PropInfo(ItemManager.Instance.getTemplateById(_sets[propId]));
            if(Boolean(propAllProp) || PlayerManager.Instance.Self.hasBuff(BuffInfo.FREE))
            {
               if(Boolean(propAllProp))
               {
                  info.Place = propAllProp.Place;
               }
               else
               {
                  info.Place = -1;
               }
               info.Count = -1;
               _itemContainer.appendItemAt(new PropItemView(info,true,false,-1),int(propId) - 1);
               hasItem = true;
            }
            else
            {
               items = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(_sets[propId]);
               if(items.length > 0)
               {
                  info.Place = items[0].Place;
                  for each(i in items)
                  {
                     info.Count += i.Count;
                  }
                  _itemContainer.appendItemAt(new PropItemView(info,true,false),int(propId) - 1);
                  hasItem = true;
               }
               else
               {
                  _itemContainer.appendItemAt(new PropItemView(info,false,false),int(propId) - 1);
               }
            }
         }
         if(hasItem)
         {
            _itemContainer.setClickByEnergy(self.energy);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      override protected function __click(event:ItemEvent) : void
      {
         var itemView:PropItemView = event.item as PropItemView;
         var item:PropInfo = itemView.info;
         if(itemView.isExist)
         {
            if(self.isLiving == false)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.RightPropView.prop"));
               return;
            }
            if(!self.isAttacking || BombKingManager.instance.Recording)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
               return;
            }
            if(self.LockState)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.cantUseItem"));
               return;
            }
            if(self.energy < item.needEnergy)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.actions.SelfPlayerWalkAction"));
               return;
            }
            self.useItem(item.Template);
            GameInSocketOut.sendUseProp(1,item.Place,item.Template.TemplateID);
         }
         else
         {
            SoundManager.instance.play("008");
         }
      }
      
      private function confirm() : void
      {
         if(PlayerManager.Instance.Self.Money >= ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.FREE_PROP_CARD).getItemPrice(1).moneyValue)
         {
            SocketManager.Instance.out.sendUseCard(-1,-1,[EquipType.FREE_PROP_CARD],1,true);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIBtnPanel.stipple"));
         }
      }
   }
}

