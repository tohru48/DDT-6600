package shop.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.ColorEditor;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import shop.ShopController;
   import shop.ShopEvent;
   import shop.ShopModel;
   
   public class ShopLeftView extends Sprite implements Disposeable
   {
      
      public static const SHOW_CART:uint = 1;
      
      public static const SHOW_COLOR:uint = 1;
      
      public static const SHOW_DRESS:uint = 0;
      
      public static const SHOW_WEALTH:uint = 0;
      
      public static const COLOR:uint = 1;
      
      public static const SKIN:uint = 2;
      
      private static const MALE:uint = 1;
      
      private static const FEMALE:uint = 2;
      
      private var _controller:ShopController;
      
      private var _model:ShopModel;
      
      private var prop:ShopLeftViewPropCollection;
      
      private var _isUsed:Boolean = false;
      
      private var latestRandom:int = 0;
      
      private var _isVisible:Boolean = false;
      
      public function ShopLeftView()
      {
         super();
         this.prop = new ShopLeftViewPropCollection();
         this.prop.setup();
         this.prop.addChildrenTo(this);
      }
      
      public function adjustBottomView(idx:uint) : void
      {
         var temp:ShopPlayerCell = null;
         this.prop.middlePanelBg.setFrame(idx + 1);
         this.prop.panelBtnGroup.selectIndex = idx;
         if(idx == SHOW_WEALTH)
         {
            this._isVisible = false;
            this.prop.purchaseView.visible = true;
            this.prop.colorEditor.visible = false;
            for each(temp in this.prop.playerCells)
            {
               temp.hideLight();
            }
         }
         if(idx == SHOW_COLOR)
         {
            this._isVisible = true;
            this.prop.purchaseView.visible = false;
            this.prop.colorEditor.visible = true;
            this.__updateColorEditor();
            this.showShine();
         }
      }
      
      public function getColorEditorVisble() : Boolean
      {
         return this.prop.colorEditor.visible;
      }
      
      public function adjustUpperView(idx:uint) : void
      {
         if(idx == SHOW_DRESS)
         {
            if(this.prop.middlePanelBg.getFrame == SHOW_WEALTH + 1)
            {
               this.prop.purchaseView.visible = true;
            }
            this.prop.dressView.visible = true;
            this.prop.cartScroll.visible = false;
         }
         if(idx == SHOW_CART)
         {
            ObjectUtils.modifyVisibility(true,this.prop.cartScroll);
            ObjectUtils.modifyVisibility(false,this.prop.dressView);
            this.adjustBottomView(SHOW_WEALTH);
         }
      }
      
      public function refreshCharater() : void
      {
         if(!this.prop.maleCharacter)
         {
            this.prop.maleCharacter = CharactoryFactory.createCharacter(this._model.manModelInfo,"room") as RoomCharacter;
            this.prop.maleCharacter.show(false,-1);
            this.prop.maleCharacter.showGun = false;
            PositionUtils.setPos(this.prop.maleCharacter,"ddtshop.PlayerCharacterPos");
            this.prop.dressView.addChild(this.prop.maleCharacter);
         }
         if(!this.prop.femaleCharacter)
         {
            this.prop.femaleCharacter = CharactoryFactory.createCharacter(this._model.womanModelInfo,"room") as RoomCharacter;
            this.prop.femaleCharacter.show(false,-1);
            this.prop.femaleCharacter.showGun = false;
            PositionUtils.setPos(this.prop.femaleCharacter,"ddtshop.PlayerCharacterPos");
            this.prop.dressView.addChild(this.prop.femaleCharacter);
         }
         this.__fittingSexChanged();
      }
      
      public function setup(controller:ShopController, model:ShopModel) : void
      {
         this._controller = controller;
         this._model = model;
         this.initEvent();
         this.refreshCharater();
      }
      
      private function __addCarEquip(evt:ShopEvent) : void
      {
         this.addCarEquip(evt.param as ShopCarItemInfo);
      }
      
      private function __clearClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.revertToDefault();
      }
      
      private function __clearLastClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.removeLatestItem();
         this.clearHighLight();
         this.__fittingSexChanged();
      }
      
      private function clearHighLight() : void
      {
         var temp:ShopPlayerCell = null;
         for each(temp in this.prop.playerCells)
         {
            temp.hideLight();
         }
      }
      
      private function __conditionChange(evt:Event) : void
      {
         this._controller.updateCost();
      }
      
      private function __deleteItem(evt:Event) : void
      {
         var item:ShopCartItem = evt.currentTarget as ShopCartItem;
         this._controller.removeFromCar(item.shopItemInfo as ShopCarItemInfo);
         if(this.prop.cartList.contains(item))
         {
            this.prop.cartList.removeChild(item);
         }
      }
      
      private function __addTempEquip(evt:ShopEvent) : void
      {
         var place:int = 0;
         var itemId:int = 0;
         var info:ShopCarItemInfo = evt.param as ShopCarItemInfo;
         if(EquipType.isProp(info.TemplateInfo))
         {
            return;
         }
         if(EquipType.dressAble(info.TemplateInfo) && info.CategoryID != EquipType.CHATBALL)
         {
            place = int(EquipType.CategeryIdToPlace(info.CategoryID)[0]);
            itemId = this._model.getBagItems(place,true);
            this.prop.playerCells[itemId].shopItemInfo = info;
            info.place = place;
            this._model.currentModel.setPartStyle(info.CategoryID,info.TemplateInfo.NeedSex,info.TemplateID,info.Color);
         }
         this.__updateCar(evt);
         this.updateButtons();
         this.prop.lastItem.shopItemInfo = info;
         this.__updateColorEditor();
         if(this.prop.panelBtnGroup.selectIndex != 1)
         {
            if(info.TemplateInfo.NeedSex == MALE)
            {
               ++this.prop.addedManNewEquip;
            }
            else if(info.TemplateInfo.NeedSex == FEMALE)
            {
               ++this.prop.addedWomanNewEquip;
            }
         }
      }
      
      private function __fittingSexChanged(event:ShopEvent = null) : void
      {
         var item:ShopCarItemInfo = null;
         var list:Array = null;
         var itemId:int = 0;
         var evt:ShopEvent = null;
         this.prop.femaleCharacter.visible = this._model.fittingSex ? false : true;
         this.prop.maleCharacter.visible = this._model.fittingSex ? true : false;
         this.prop.muteLock = true;
         this.prop.cbHideGlasses.selected = this._model.currentModel.getGlassHide();
         this.prop.cbHideHat.selected = this._model.currentModel.getHatHide();
         this.prop.cbHideSuit.selected = this._model.currentModel.getSuitesHide();
         this.prop.cbHideWings.selected = this._model.currentModel.wingHide;
         this.prop.muteLock = false;
         for(var i:int = 0; i < this.prop.playerCells.length; i++)
         {
            itemId = this._model.getBagItems(i);
            if(Boolean(this._model.currentModel.Bag.items[itemId]))
            {
               this.prop.playerCells[i].info = this._model.currentModel.Bag.items[itemId];
               this.prop.playerCells[i].locked = true;
            }
            else
            {
               this.prop.playerCells[i].shopItemInfo = null;
            }
         }
         for each(item in this._model.currentTempList)
         {
            evt = new ShopEvent("shop",item);
            this.__addTempEquip(evt);
         }
         this.updateButtons();
         list = this._model.currentTempList;
         if(list.length > 0)
         {
            this.prop.lastItem.shopItemInfo = list[list.length - 1];
         }
         else
         {
            this.prop.lastItem.shopItemInfo = null;
         }
      }
      
      private function __hideGlassChange(evt:Event) : void
      {
         this._model.currentModel.setGlassHide(this.prop.cbHideGlasses.selected);
      }
      
      private function __hideHatChange(evt:Event) : void
      {
         this._model.currentModel.setHatHide(this.prop.cbHideHat.selected);
      }
      
      private function __hideSuitesChange(evt:Event) : void
      {
         this._model.currentModel.setSuiteHide(this.prop.cbHideSuit.selected);
      }
      
      private function __hideWingClickHandler(event:Event) : void
      {
         this._model.currentModel.wingHide = this.prop.cbHideWings.selected;
      }
      
      private function __originClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.restoreAllItemsOnBody();
      }
      
      private function __panelBtnClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.adjustBottomView(this.prop.panelBtnGroup.selectIndex);
         this.__update(null);
      }
      
      private function __propertyChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties[PlayerInfo.MONEY]) || Boolean(evt.changedProperties[PlayerInfo.DDT_MONEY]) || Boolean(evt.changedProperties[PlayerInfo.BandMONEY]))
         {
            this.prop.playerMoneyTxt.text = String(this._model.Self.Money);
            this.prop.playerGiftTxt.text = String(this._model.Self.BandMoney);
         }
      }
      
      private function __removeCarEquip(evt:ShopEvent) : void
      {
         var si:ShopCartItem = null;
         var item:ShopCarItemInfo = evt.param as ShopCarItemInfo;
         var i:uint = 0;
         while(this.prop.cartList.numChildren > 0)
         {
            si = this.prop.cartList.getChildAt(i) as ShopCartItem;
            if(si.shopItemInfo == item)
            {
               break;
            }
            i++;
         }
         if(Boolean(si))
         {
            si.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
            this.prop.cartList.removeChild(si);
         }
         this.prop.cartScroll.invalidateViewport();
      }
      
      private function __selectedColorChanged(event:*) : void
      {
         var obj:Object = new Object();
         if(this.prop.colorEditor.selectedType == COLOR)
         {
            this.setColorLayer(this.prop.colorEditor.selectedColor);
            obj.color = this.prop.colorEditor.selectedColor;
         }
         else
         {
            this.setSkinColor(String(this.prop.colorEditor.selectedSkin));
            obj.color = this.prop.colorEditor.selectedSkin;
         }
         obj.item = this.prop.lastItem.shopItemInfo;
         obj.type = this.prop.colorEditor.selectedType;
         dispatchEvent(new ShopEvent(ShopEvent.COLOR_SELECTED,obj));
      }
      
      private function __topBtnClick(event:MouseEvent = null) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __update(evt:ShopEvent) : void
      {
         this.prop.leftMoneyPanelBuyBtn.enable = this._model.allItemsCount > 0;
         this.prop.purchaseBtn.enable = this._model.allItemsCount > 0;
         if(this.prop.purchaseBtn.enable)
         {
            this.prop.purchaseEffet.play();
         }
         else
         {
            this.prop.purchaseEffet.stop();
         }
         if(!this._model.checkPoint())
         {
            this.prop.presentBtn.enable = this.prop.askBtn.enable = this._model.allItemsCount > 0;
            if(this.prop.presentBtn.enable)
            {
               this.prop.presentEffet.play();
            }
            else
            {
               this.prop.presentEffet.stop();
            }
            if(this.prop.askBtn.enable)
            {
               this.prop.askBtnEffet.play();
            }
            else
            {
               this.prop.askBtnEffet.stop();
            }
         }
         if(this.prop.presentBtn.enable)
         {
            if(this._model.checkPoint())
            {
               this.prop.presentBtn.enable = false;
               this.prop.askBtn.enable = false;
               this.prop.presentEffet.stop();
               this.prop.askBtnEffet.stop();
            }
         }
      }
      
      private function __updateColorEditor(e:ShopEvent = null) : void
      {
         this.prop.colorEditor.skinEditable = false;
         if(this._model.canChangSkin())
         {
            this.prop.colorEditor.selectedType = SKIN;
            if(Boolean(this.prop.lastItem.shopItemInfo) && this.prop.lastItem.shopItemInfo.CategoryID == EquipType.FACE)
            {
               this.prop.colorEditor.skinEditable = true;
            }
            this.setSkinColor(this._model.currentSkin);
            this.prop.colorEditor.editSkin(this.prop.colorEditor.selectedSkin);
         }
         else
         {
            this.prop.colorEditor.skinEditable = false;
            this.prop.colorEditor.resetSkin();
         }
         if(Boolean(this.prop.lastItem.shopItemInfo) && EquipType.isEditable(this.prop.lastItem.shopItemInfo.TemplateInfo))
         {
            this.prop.colorEditor.selectedType = COLOR;
            this.prop.colorEditor.colorEditable = true;
            this.prop.colorEditor.editColor(int(this.prop.lastItem.shopItemInfo.colorValue));
         }
         else
         {
            this.prop.colorEditor.colorEditable = false;
         }
      }
      
      private function addCarEquip(info:ShopCarItemInfo) : void
      {
         var item:ShopCartItem = new ShopCartItem();
         item.setShopItemInfo(info);
         this.prop.addItemToList(item);
         item.addEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
         item.addEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
         this.prop.cartScroll.invalidateViewport(true);
      }
      
      private function checkShiner(e:Event = null) : void
      {
         if((this.prop.colorEditor.colorEditable || this.prop.colorEditor.skinEditable) && this.prop.lastItem.info != null)
         {
            this.prop.panelColorBtn.enable = true;
            this._isUsed = true;
            if(this.prop.panelBtnGroup.selectIndex == SHOW_WEALTH && this.prop.canShine)
            {
               this.prop.canShine = false;
            }
         }
         else
         {
            this.prop.panelColorBtn.enable = false;
            this._isUsed = false;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ENTER_FRAME,this.checkShiner);
         this._controller.rightView.addEventListener(ShopRightView.SHOW_LIGHT,this._showLight);
         this.prop.colorEditor.addEventListener(Event.CHANGE,this.__selectedColorChanged);
         this.prop.colorEditor.addEventListener(ColorEditor.REDUCTIVE_COLOR,this.__reductiveColor);
         this.prop.colorEditor.addEventListener(ColorEditor.CHANGE_COLOR,this._changeColor);
         this.prop.lastItem.addEventListener(ShopEvent.ITEMINFO_CHANGE,this.__updateColorEditor);
         this.prop.btnClearLastEquip.addEventListener(MouseEvent.CLICK,this.__clearLastClick);
         this.prop.cbHideHat.addEventListener(Event.SELECT,this.__hideHatChange);
         this.prop.cbHideGlasses.addEventListener(Event.SELECT,this.__hideGlassChange);
         this.prop.cbHideSuit.addEventListener(Event.SELECT,this.__hideSuitesChange);
         this.prop.cbHideWings.addEventListener(Event.SELECT,this.__hideWingClickHandler);
         this._model.addEventListener(ShopEvent.ADD_TEMP_EQUIP,this.__addTempEquip);
         this._model.addEventListener(ShopEvent.COST_UPDATE,this.__update);
         this._model.addEventListener(ShopEvent.ADD_CAR_EQUIP,this.__addCarEquip);
         this._model.addEventListener(ShopEvent.FITTINGMODEL_CHANGE,this.__fittingSexChanged);
         this._model.addEventListener(ShopEvent.REMOVE_CAR_EQUIP,this.__removeCarEquip);
         this._model.addEventListener(ShopEvent.SELECTEDEQUIP_CHANGE,this.__selectedEquipChange);
         this._model.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._model.addEventListener(ShopEvent.REMOVE_TEMP_EQUIP,this.__removeTempEquip);
         this.prop.lastItem.addEventListener(ShopEvent.ITEMINFO_CHANGE,this.__itemInfoChange);
         this.prop.panelCartBtn.addEventListener(MouseEvent.CLICK,this.__panelBtnClickHandler);
         this.prop.panelColorBtn.addEventListener(MouseEvent.CLICK,this.__panelBtnClickHandler);
         this.prop.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentClick);
         this.prop.purchaseBtn.addEventListener(MouseEvent.CLICK,this.__purchaseClick);
         this.prop.askBtn.addEventListener(MouseEvent.CLICK,this.askHander);
         this.prop.leftMoneyPanelBuyBtn.addEventListener(MouseEvent.CLICK,this.__purchaseClick);
         this.prop.randomBtn.addEventListener(MouseEvent.CLICK,this.__random);
         this.prop.saveFigureBtn.addEventListener(MouseEvent.CLICK,this.__saveFigureClick);
         this._model.addEventListener(ShopEvent.UPDATE_CAR,this.__updateCar);
         for(var i:int = 0; i < this.prop.playerCells.length; i++)
         {
            this.prop.playerCells[i].addEventListener(MouseEvent.CLICK,this.__cellClick);
         }
      }
      
      private function __cellClick(evt:MouseEvent) : void
      {
         var item:ShopCarItemInfo = null;
         var temp:ShopPlayerCell = null;
         SoundManager.instance.play("047");
         var cell:ShopPlayerCell = evt.currentTarget as ShopPlayerCell;
         if(cell.locked)
         {
            return;
         }
         if(cell.shopItemInfo != null)
         {
            if(cell.shopItemInfo.CategoryID == EquipType.HEAD || cell.shopItemInfo.CategoryID == EquipType.GLASS || cell.shopItemInfo.CategoryID == EquipType.HAIR || cell.shopItemInfo.CategoryID == EquipType.EFF || cell.shopItemInfo.CategoryID == EquipType.CLOTH || cell.shopItemInfo.CategoryID == EquipType.FACE)
            {
               item = cell.shopItemInfo;
               for each(temp in this.prop.playerCells)
               {
                  if(temp.shopItemInfo == item)
                  {
                     temp.showLight();
                  }
                  else
                  {
                     temp.hideLight();
                  }
               }
            }
         }
         this._controller.setSelectedEquip(cell.shopItemInfo);
         this.prop.lastItem.shopItemInfo = cell.shopItemInfo;
      }
      
      private function __updateCar(e:ShopEvent) : void
      {
         var item:ShopCartItem = null;
         var t:uint = 0;
         var info:ShopCarItemInfo = e.param as ShopCarItemInfo;
         var list:Array = this._model.allItems;
         var listOrigin:Array = new Array();
         for(var i:int = 0; i < this.prop.cartList.numChildren; i++)
         {
            item = this.prop.cartList.getChildAt(i) as ShopCartItem;
            listOrigin.push(item.shopItemInfo);
         }
         if(listOrigin.length < list.length)
         {
            this.addCarEquip(info);
         }
         else if(listOrigin.length == list.length)
         {
            t = 0;
            while(true)
            {
               if(t < listOrigin.length)
               {
                  if(list.indexOf(listOrigin[t]) >= 0)
                  {
                     continue;
                  }
                  (this.prop.cartList.getChildAt(t) as ShopCartItem).setShopItemInfo(info);
               }
               t++;
            }
         }
         else if(listOrigin.length > list.length)
         {
            for(t = 0; t < listOrigin.length; t++)
            {
               if(list.indexOf(listOrigin[t]) < 0)
               {
                  for(i = 0; i < this.prop.cartList.numChildren; i++)
                  {
                     item = this.prop.cartList.getChildAt(i) as ShopCartItem;
                     if(item.shopItemInfo == listOrigin[t])
                     {
                        item.removeEventListener(ShopCartItem.DELETE_ITEM,this.__deleteItem);
                        item.removeEventListener(ShopCartItem.CONDITION_CHANGE,this.__conditionChange);
                        item.dispose();
                        break;
                     }
                  }
               }
            }
         }
         this.prop.cartScroll.invalidateViewport();
      }
      
      private function removeEvents() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.checkShiner);
         this._controller.rightView.removeEventListener(ShopRightView.SHOW_LIGHT,this._showLight);
         this.prop.colorEditor.removeEventListener(Event.CHANGE,this.__selectedColorChanged);
         this.prop.colorEditor.removeEventListener(ColorEditor.REDUCTIVE_COLOR,this.__reductiveColor);
         this.prop.colorEditor.removeEventListener(ColorEditor.CHANGE_COLOR,this._changeColor);
         this.prop.lastItem.removeEventListener(ShopEvent.ITEMINFO_CHANGE,this.__updateColorEditor);
         this.prop.btnClearLastEquip.removeEventListener(MouseEvent.CLICK,this.__clearLastClick);
         this.prop.cbHideHat.removeEventListener(Event.SELECT,this.__hideHatChange);
         this.prop.cbHideGlasses.removeEventListener(Event.SELECT,this.__hideGlassChange);
         this.prop.cbHideSuit.removeEventListener(Event.SELECT,this.__hideSuitesChange);
         this.prop.cbHideWings.removeEventListener(Event.SELECT,this.__hideWingClickHandler);
         this._model.removeEventListener(ShopEvent.ADD_TEMP_EQUIP,this.__addTempEquip);
         this._model.removeEventListener(ShopEvent.COST_UPDATE,this.__update);
         this._model.removeEventListener(ShopEvent.ADD_CAR_EQUIP,this.__addCarEquip);
         this._model.removeEventListener(ShopEvent.FITTINGMODEL_CHANGE,this.__fittingSexChanged);
         this._model.removeEventListener(ShopEvent.REMOVE_CAR_EQUIP,this.__removeCarEquip);
         this._model.removeEventListener(ShopEvent.SELECTEDEQUIP_CHANGE,this.__selectedEquipChange);
         this._model.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._model.removeEventListener(ShopEvent.REMOVE_TEMP_EQUIP,this.__removeTempEquip);
         this.prop.lastItem.removeEventListener(ShopEvent.ITEMINFO_CHANGE,this.__itemInfoChange);
         this.prop.panelCartBtn.removeEventListener(MouseEvent.CLICK,this.__panelBtnClickHandler);
         this.prop.panelColorBtn.removeEventListener(MouseEvent.CLICK,this.__panelBtnClickHandler);
         this.prop.presentBtn.removeEventListener(MouseEvent.CLICK,this.__presentClick);
         this.prop.purchaseBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseClick);
         this.prop.leftMoneyPanelBuyBtn.removeEventListener(MouseEvent.CLICK,this.__purchaseClick);
         this.prop.saveFigureBtn.removeEventListener(MouseEvent.CLICK,this.__saveFigureClick);
         this._model.removeEventListener(ShopEvent.UPDATE_CAR,this.__updateCar);
         this.prop.randomBtn.removeEventListener(MouseEvent.CLICK,this.__random);
         this.prop.askBtn.removeEventListener(MouseEvent.CLICK,this.askHander);
      }
      
      private function __purchaseClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if((this._model.totalMoney > 0 || this._model.totalGift > 0 || this._model.totalMedal > 0) && PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this.clearHighLight();
         this.prop.checkOutPanel.setup(this._controller,this._model,this._model.allItems,ShopCheckOutView.PURCHASE);
         LayerManager.Instance.addToLayer(this.prop.checkOutPanel,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function askHander(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if((this._model.totalMoney > 0 || this._model.totalGift > 0 || this._model.totalMedal > 0) && PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this.clearHighLight();
         this.prop.checkOutPanel.setup(this._controller,this._model,this._model.allItems,ShopCheckOutView.ASKTYPE);
         LayerManager.Instance.addToLayer(this.prop.checkOutPanel,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __random(event:MouseEvent) : void
      {
         var temp:ShopPlayerCell = null;
         SoundManager.instance.play("008");
         if(getTimer() - this.latestRandom < 1500)
         {
            return;
         }
         this.latestRandom = getTimer();
         for each(temp in this.prop.playerCells)
         {
            temp.hideLight();
         }
         this.prop.cbHideGlasses.selected = false;
         this.prop.cbHideHat.selected = false;
         this.prop.cbHideWings.selected = false;
         this.prop.cbHideSuit.selected = true;
         this._controller.model.random();
      }
      
      private function __saveFigureClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.clearHighLight();
         this.prop.checkOutPanel.setup(this._controller,this._model,this._model.currentTempList,ShopCheckOutView.SAVE);
         LayerManager.Instance.addToLayer(this.prop.checkOutPanel,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __presentClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var giveList:Array = ShopManager.Instance.moneyGoods(this._model.allItems,this._model.Self);
         if(giveList.length > 0)
         {
            this.prop.checkOutPanel.setup(this._controller,this._model,giveList,ShopCheckOutView.PRESENT);
            LayerManager.Instance.addToLayer(this.prop.checkOutPanel,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.cantPresent"));
         }
      }
      
      private function __itemInfoChange(evt:Event) : void
      {
         this.prop.canShine = true;
         this.__updateColorEditor();
      }
      
      private function __removeTempEquip(evt:ShopEvent) : void
      {
         var place:int = 0;
         var itemId:int = 0;
         var orientItem:InventoryItemInfo = null;
         var item:ShopCarItemInfo = evt.param as ShopCarItemInfo;
         if(this.prop.lastItem.shopItemInfo == item)
         {
            this.prop.lastItem.shopItemInfo = null;
         }
         this.__updateColorEditor();
         if(item.TemplateInfo.NeedSex == MALE)
         {
            if(this.prop.addedManNewEquip > 0)
            {
               --this.prop.addedManNewEquip;
            }
            else
            {
               this.prop.addedManNewEquip = 0;
            }
         }
         else if(item.TemplateInfo.NeedSex == FEMALE)
         {
            if(this.prop.addedWomanNewEquip > 0)
            {
               --this.prop.addedWomanNewEquip;
            }
            else
            {
               this.prop.addedWomanNewEquip = 0;
            }
         }
         if(evt.model == this._model.currentModel)
         {
            place = item.place;
            itemId = this._model.getBagItems(place,true);
            orientItem = this._model.currentModel.Bag.items[place];
            if(Boolean(orientItem))
            {
               this.prop.playerCells[itemId].info = orientItem;
               this.prop.playerCells[itemId].locked = true;
            }
            else
            {
               this.prop.playerCells[itemId].info = null;
            }
            this.updateButtons();
         }
         this.__updateCar(evt);
      }
      
      private function __selectedEquipChange(evt:ShopEvent) : void
      {
         this.prop.lastItem.shopItemInfo = evt.param as ShopCarItemInfo;
         this.updateButtons();
         this.__updateColorEditor();
      }
      
      private function setColorLayer(color:int) : void
      {
         var editlayer:int = 0;
         var place:int = 0;
         var temp:Array = null;
         var item:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
         if(item && EquipType.isEditable(item.TemplateInfo) && int(item.colorValue) != color)
         {
            editlayer = this.prop.lastItem.editLayer - 1;
            place = int(EquipType.CategeryIdToPlace(item.CategoryID)[0]);
            temp = item.Color.split("|");
            temp[editlayer] = String(color);
            item.Color = temp.join("|");
            this.prop.lastItem.setColor(item.Color);
            this._model.currentModel.setPartColor(item.CategoryID,item.Color);
         }
      }
      
      private function setSkinColor(color:String) : void
      {
         var item:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
         if(Boolean(item) && item.CategoryID == EquipType.FACE)
         {
            item.skin = color;
         }
         this.prop.lastItem.setSkinColor(color);
         this._model.currentModel.Skin = color;
      }
      
      protected function __reductiveColor(event:Event) : void
      {
         var item:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
         if(this.prop.colorEditor.selectedType == COLOR)
         {
            if(Boolean(item) && EquipType.isEditable(item.TemplateInfo))
            {
               item.Color = "";
               this._model.currentModel.setPartColor(item.CategoryID,null);
            }
         }
         else
         {
            item.skin = "";
            this._model.currentModel.setSkinColor("");
         }
      }
      
      private function _changeColor(event:Event) : void
      {
         this.showShine();
      }
      
      private function _showLight(event:Event) : void
      {
         if(this._isVisible)
         {
            this.showShine();
         }
      }
      
      private function showShine() : void
      {
         var temp:ShopPlayerCell = null;
         var item:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
         for each(temp in this.prop.playerCells)
         {
            if(temp.shopItemInfo == item)
            {
               temp.showLight();
            }
            else
            {
               temp.hideLight();
            }
         }
      }
      
      public function hideLight() : void
      {
         var temp:ShopPlayerCell = null;
         var item:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
         for each(temp in this.prop.playerCells)
         {
            temp.hideLight();
         }
      }
      
      private function updateButtons() : void
      {
         this.prop.saveFigureBtn.enable = this._model.isSelfModel && this._model.currentTempList.length != 0;
         if(this.prop.saveFigureBtn.enable)
         {
            this.prop.saveFigureEffet.play();
         }
         else
         {
            this.prop.saveFigureEffet.stop();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this.prop.disposeAllChildrenFrom(this);
         this.prop = null;
         this._controller = null;
         this._model = null;
      }
   }
}

