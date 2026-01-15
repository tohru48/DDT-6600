package game.view
{
   import bagAndInfo.bag.ItemCellView;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.PropInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.ItemEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.model.LocalPlayer;
   import game.view.propContainer.BaseGamePropBarView;
   import game.view.propContainer.PropShortCutView;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   
   public class SelfPropContainBar extends BaseGamePropBarView
   {
      
      public static var USE_THREE_SKILL:String = "useThreeSkill";
      
      public static var USE_PLANE:String = "usePlane";
      
      private var _back:Bitmap;
      
      private var _info:SelfInfo;
      
      private var _shortCut:PropShortCutView;
      
      private var _myitems:Array;
      
      public function SelfPropContainBar(self:LocalPlayer)
      {
         var itemPos:Point = null;
         super(self,3,3,false,false,false,ItemCellView.PROP_SHORT);
         this._back = ComponentFactory.Instance.creatBitmap("asset.game.propBackAsset");
         addChild(this._back);
         itemPos = ComponentFactory.Instance.creatCustomObject("asset.game.itemContainerPos");
         _itemContainer.x = itemPos.x;
         _itemContainer.y = itemPos.y;
         addChild(_itemContainer);
         this._shortCut = new PropShortCutView();
         this._shortCut.setPropCloseEnabled(0,false);
         this._shortCut.setPropCloseEnabled(1,false);
         this._shortCut.setPropCloseEnabled(2,false);
         addChild(this._shortCut);
         this.setLocalPlayer(self.playerInfo as SelfInfo);
         this.initData();
      }
      
      private function initData() : void
      {
         var info:InventoryItemInfo = null;
         var propInfo:PropInfo = null;
         var bag:BagInfo = this._info.FightBag;
         for each(info in bag.items)
         {
            propInfo = new PropInfo(info);
            propInfo.Place = info.Place;
            this.addProp(propInfo);
         }
      }
      
      private function __keyDown(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case KeyStroke.VK_Z.getCode():
               _itemContainer.mouseClickAt(0);
               break;
            case KeyStroke.VK_X.getCode():
               _itemContainer.mouseClickAt(1);
               break;
            case KeyStroke.VK_C.getCode():
               _itemContainer.mouseClickAt(2);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._shortCut))
         {
            this._shortCut.dispose();
         }
         this._shortCut = null;
         removeChild(this._back);
         this._info = null;
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      public function setLocalPlayer(value:SelfInfo) : void
      {
         if(this._info != value)
         {
            if(Boolean(this._info))
            {
               this._info.FightBag.removeEventListener(BagEvent.UPDATE,this.__updateProp);
               _itemContainer.clear();
            }
            this._info = value;
            if(Boolean(this._info))
            {
               this._info.FightBag.addEventListener(BagEvent.UPDATE,this.__updateProp);
            }
         }
      }
      
      private function __removeProp(event:BagEvent) : void
      {
         var propInfo:PropInfo = new PropInfo(event.changedSlots as InventoryItemInfo);
         propInfo.Place = event.changedSlots.Place;
         this.removeProp(propInfo as PropInfo);
      }
      
      private function __updateProp(event:BagEvent) : void
      {
         var i:InventoryItemInfo = null;
         var c:InventoryItemInfo = null;
         var propInfo:PropInfo = null;
         var propInfo1:PropInfo = null;
         var changes:Dictionary = event.changedSlots;
         for each(i in changes)
         {
            c = this._info.FightBag.getItemAt(i.Place);
            if(Boolean(c))
            {
               propInfo = new PropInfo(c);
               propInfo.Place = c.Place;
               this.addProp(propInfo);
            }
            else
            {
               propInfo1 = new PropInfo(i);
               propInfo1.Place = i.Place;
               this.removeProp(propInfo1);
            }
         }
      }
      
      override public function setClickEnabled(clickAble:Boolean, isGray:Boolean) : void
      {
         super.setClickEnabled(clickAble,isGray);
      }
      
      override protected function __click(event:ItemEvent) : void
      {
         var info:PropInfo = null;
         if(event.item == null)
         {
            return;
         }
         if(self.LockState)
         {
            if(self.LockType == 0)
            {
               return;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.effect.seal"));
         }
         else
         {
            if(self.isLiving && !self.isAttacking)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.ArrowViewIII.fall"));
               return;
            }
            if(self.energy >= Number(PropItemView(event.item).info.Template.Property4))
            {
               info = PropItemView(event.item).info;
               self.useItem(info.Template);
               GameInSocketOut.sendUseProp(2,info.Place,info.Template.TemplateID);
               if(info.Template.TemplateID == 10003)
               {
                  dispatchEvent(new Event(USE_THREE_SKILL));
               }
               if(info.Template.TemplateID == 10016)
               {
                  dispatchEvent(new Event(USE_PLANE));
               }
               _itemContainer.setItemClickAt(info.Place,false,true);
               this._shortCut.setPropCloseVisible(info.Place,false);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.actions.SelfPlayerWalkAction"));
            }
         }
      }
      
      override protected function __over(event:ItemEvent) : void
      {
         super.__over(event);
         this._shortCut.setPropCloseVisible(event.index,true);
      }
      
      override protected function __out(event:ItemEvent) : void
      {
         super.__out(event);
         this._shortCut.setPropCloseVisible(event.index,false);
      }
      
      public function addProp(info:PropInfo) : void
      {
         this._shortCut.setPropCloseEnabled(info.Place,true);
         _itemContainer.appendItemAt(new PropItemView(info,true,false),info.Place);
      }
      
      public function removeProp(info:PropInfo) : void
      {
         this._shortCut.setPropCloseEnabled(info.Place,false);
         this._shortCut.setPropCloseVisible(info.Place,false);
         _itemContainer.removeItemAt(info.Place);
      }
   }
}

