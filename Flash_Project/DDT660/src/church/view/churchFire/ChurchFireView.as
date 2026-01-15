package church.view.churchFire
{
   import church.controller.ChurchRoomController;
   import church.events.WeddingRoomEvent;
   import church.model.ChurchRoomModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ChurchFireView extends Sprite implements Disposeable
   {
      
      public static const FIRE_USE_GOLD:int = 200;
      
      private var _controller:ChurchRoomController;
      
      private var _model:ChurchRoomModel;
      
      private var _fireBg:Bitmap;
      
      private var _fireClose:BaseButton;
      
      private var _fireGlodLabel:FilterFrameText;
      
      private var _fireGlod:FilterFrameText;
      
      private var _fireGoldIcon:Bitmap;
      
      private var _fireIcon21002:Bitmap;
      
      private var _fireIcon21006:Bitmap;
      
      private var All_Fires:Array;
      
      private var All_FireIcons:Array;
      
      private var _fireListBox:HBox;
      
      private var _fireUseGold:int;
      
      private var _fireListFilter:Array;
      
      private var _alert:BaseAlerFrame;
      
      public function ChurchFireView(controller:ChurchRoomController, model:ChurchRoomModel)
      {
         super();
         this._controller = controller;
         this._model = model;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.setView();
         this.setEvent();
         this.getFireList();
      }
      
      private function setView() : void
      {
         this._fireBg = ComponentFactory.Instance.creatBitmap("asset.church.room.fireBgAsset");
         addChild(this._fireBg);
         this._fireClose = ComponentFactory.Instance.creat("church.room.fireCloseAsset");
         this._fireClose.buttonMode = true;
         addChild(this._fireClose);
         this._fireGlodLabel = ComponentFactory.Instance.creat("church.room.fireGlodLabelAsset");
         this._fireGlodLabel.text = LanguageMgr.GetTranslation("church.view.churchFire.ChurchFireView");
         addChild(this._fireGlodLabel);
         this._fireGlod = ComponentFactory.Instance.creat("church.room.fireGlodAsset");
         this._fireGlod.text = PlayerManager.Instance.Self.Gold.toString();
         addChild(this._fireGlod);
         this._fireGoldIcon = ComponentFactory.Instance.creatBitmap("asset.church.room.fireGoldIconAsset");
         addChild(this._fireGoldIcon);
         this._fireListBox = ComponentFactory.Instance.creat("church.room.fireListBoxAsset");
         addChild(this._fireListBox);
         this._fireUseGold = FIRE_USE_GOLD;
         this._fireIcon21002 = ComponentFactory.Instance.creatBitmap("asset.church.room.fireIcon21002");
         this._fireIcon21002.smoothing = true;
         this._fireIcon21006 = ComponentFactory.Instance.creatBitmap("asset.church.room.fireIcon21006");
         this._fireIcon21006.smoothing = true;
         this.All_Fires = this._model.fireTemplateIDList;
         this.All_FireIcons = [this._fireIcon21002,this._fireIcon21006];
      }
      
      private function removeView() : void
      {
         this.All_Fires = null;
         this.All_FireIcons = null;
         if(Boolean(this._fireBg))
         {
            if(Boolean(this._fireBg.parent))
            {
               this._fireBg.parent.removeChild(this._fireBg);
            }
            this._fireBg.bitmapData.dispose();
            this._fireBg.bitmapData = null;
         }
         this._fireBg = null;
         if(Boolean(this._fireClose))
         {
            if(Boolean(this._fireClose.parent))
            {
               this._fireClose.parent.removeChild(this._fireClose);
            }
            this._fireClose.dispose();
         }
         this._fireClose = null;
         if(Boolean(this._fireGlodLabel))
         {
            if(Boolean(this._fireGlodLabel.parent))
            {
               this._fireGlodLabel.parent.removeChild(this._fireGlodLabel);
            }
            this._fireGlodLabel.dispose();
         }
         this._fireGlodLabel = null;
         if(Boolean(this._fireGlod))
         {
            if(Boolean(this._fireGlod.parent))
            {
               this._fireGlod.parent.removeChild(this._fireGlod);
            }
            this._fireGlod.dispose();
         }
         this._fireGlod = null;
         if(Boolean(this._fireGoldIcon))
         {
            if(Boolean(this._fireGoldIcon.parent))
            {
               this._fireGoldIcon.parent.removeChild(this._fireGoldIcon);
            }
            this._fireGoldIcon.bitmapData.dispose();
            this._fireGoldIcon.bitmapData = null;
         }
         this._fireGoldIcon = null;
         ObjectUtils.disposeObject(this._fireIcon21002);
         this._fireIcon21002 = null;
         ObjectUtils.disposeObject(this._fireIcon21006);
         this._fireIcon21006 = null;
         if(Boolean(this._fireListBox))
         {
            if(Boolean(this._fireListBox.parent))
            {
               this._fireListBox.parent.removeChild(this._fireListBox);
            }
            this._fireListBox.dispose();
         }
         this._fireListBox = null;
         this._fireListFilter = null;
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function setEvent() : void
      {
         this._fireClose.addEventListener(MouseEvent.CLICK,this.onCloseClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.updateGold);
         this._model.addEventListener(WeddingRoomEvent.ROOM_FIRE_ENABLE_CHANGE,this.fireEnableChange);
      }
      
      private function removeEvent() : void
      {
         var i:int = 0;
         this._fireClose.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.updateGold);
         this._model.removeEventListener(WeddingRoomEvent.ROOM_FIRE_ENABLE_CHANGE,this.fireEnableChange);
         if(Boolean(this._fireListBox))
         {
            while(i < this._fireListBox.numChildren)
            {
               this._fireListBox.getChildAt(i).removeEventListener(MouseEvent.CLICK,this.itemClickHandler);
               i++;
            }
         }
      }
      
      private function getFireList() : void
      {
         var item:ChurchFireCell = null;
         for(var i:int = 0; i < this.All_Fires.length; i++)
         {
            item = new ChurchFireCell(this.All_FireIcons[i],ShopManager.Instance.getGoldShopItemByTemplateID(this.All_Fires[i]),this.All_Fires[i]);
            item.addEventListener(MouseEvent.CLICK,this.itemClickHandler);
            this._fireListBox.addChild(item);
         }
      }
      
      private function itemClickHandler(e:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.Gold < this._fireUseGold)
         {
            SoundManager.instance.play("008");
            if(!this._alert)
            {
               this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               this._alert.addEventListener(FrameEvent.RESPONSE,this._responseV);
               this._alert.moveEnable = false;
               return;
            }
         }
         var item:ChurchFireCell = e.currentTarget as ChurchFireCell;
         this._controller.useFire(PlayerManager.Instance.Self.ID,item.fireTemplateID);
         SocketManager.Instance.out.sendUseFire(PlayerManager.Instance.Self.ID,item.fireTemplateID);
      }
      
      private function _responseV(event:FrameEvent) : void
      {
         this._alert.removeEventListener(FrameEvent.RESPONSE,this._responseV);
         this._alert.dispose();
         this._alert = null;
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.okFastPurchaseGold();
         }
      }
      
      private function okFastPurchaseGold() : void
      {
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = EquipType.GOLD_BOX;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function updateGold(evt:PlayerPropertyEvent) : void
      {
         this._fireGlod.text = PlayerManager.Instance.Self.Gold.toString();
      }
      
      private function fireEnableChange(e:WeddingRoomEvent) : void
      {
         var i:int = 0;
         var j:int = 0;
         this.setButtnEnable(this._fireListBox,this._model.fireEnable);
         if(this._model.fireEnable)
         {
            while(i < this._fireListBox.numChildren)
            {
               this._fireListBox.getChildAt(i).removeEventListener(MouseEvent.CLICK,this.itemClickHandler);
               this._fireListBox.getChildAt(i).addEventListener(MouseEvent.CLICK,this.itemClickHandler);
               i++;
            }
         }
         else
         {
            while(j < this._fireListBox.numChildren)
            {
               this._fireListBox.getChildAt(j).removeEventListener(MouseEvent.CLICK,this.itemClickHandler);
               j++;
            }
         }
      }
      
      private function setButtnEnable(obj:Sprite, value:Boolean) : void
      {
         obj.mouseEnabled = value;
         this._fireListFilter = ComponentFactory.Instance.creatFilters("grayFilter");
         obj.filters = value ? [] : this._fireListFilter;
      }
      
      private function onCloseClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}

