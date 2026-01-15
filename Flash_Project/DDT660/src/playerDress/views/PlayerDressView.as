package playerDress.views
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import magicStone.MagicStoneManager;
   import playerDress.PlayerDressManager;
   import playerDress.components.DressModel;
   import playerDress.components.DressUtils;
   import playerDress.data.DressVo;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   import store.HelpFrame;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class PlayerDressView extends Sprite implements Disposeable
   {
      
      public static const CELLS_LENGTH:uint = 8;
      
      public static const NEED_GOLD:int = 5000;
      
      private var _BG:Bitmap;
      
      private var _character:RoomCharacter;
      
      private var _hidePanel:MovieImage;
      
      private var _saveBtn:SimpleBitmapButton;
      
      private var _selectedBox:ComboBox;
      
      private var _okBtn:SimpleBitmapButton;
      
      private var _okBtnSprite:Sprite;
      
      private var _okBtnTip:OneLineTip;
      
      private var _descTxt:FilterFrameText;
      
      private var _hideHatBtn:SelectedCheckButton;
      
      private var _hideGlassBtn:SelectedCheckButton;
      
      private var _hideSuitBtn:SelectedCheckButton;
      
      private var _hideWingBtn:SelectedCheckButton;
      
      private var _dressCells:Vector.<BagCell>;
      
      private var _helpBtn:BaseButton;
      
      private var _currentModel:DressModel;
      
      private var _currentIndex:int;
      
      private var _comboBoxArr:Array = [];
      
      private var _self:PlayerInfo;
      
      private var _bodyThings:DictionaryData;
      
      private var saveBtnClick:Boolean = false;
      
      public function PlayerDressView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         PlayerDressManager.instance.dressView = this;
         this._currentIndex = PlayerDressManager.instance.currentIndex;
         this._currentModel = new DressModel();
         this._dressCells = new Vector.<BagCell>();
         this._comboBoxArr.push(LanguageMgr.GetTranslation("playerDress.model1"));
         this._comboBoxArr.push(LanguageMgr.GetTranslation("playerDress.model2"));
         this._comboBoxArr.push(LanguageMgr.GetTranslation("playerDress.model3"));
      }
      
      private function initView() : void
      {
         var cell:BagCell = null;
         this._BG = ComponentFactory.Instance.creat("playerDress.BG");
         addChild(this._BG);
         this._hidePanel = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.ddtbg");
         PositionUtils.setPos(this._hidePanel,"playerDress.hidePanelPos");
         addChild(this._hidePanel);
         this._saveBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.saveBtn");
         addChild(this._saveBtn);
         this._saveBtn.enable = false;
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.okBtn");
         addChild(this._okBtn);
         this.enableOKBtn(false);
         this._okBtn.tipData = LanguageMgr.GetTranslation("playerDress.okBtnTip");
         ComponentSetting.COMBOX_LIST_LAYER = LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER);
         this._selectedBox = ComponentFactory.Instance.creatComponentByStylename("playerDress.modelCombo");
         this._selectedBox.selctedPropName = "text";
         if(this._currentIndex == -1)
         {
            this._currentIndex = 0;
         }
         this._selectedBox.textField.text = this._comboBoxArr[this._currentIndex];
         addChild(this._selectedBox);
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("playerDress.decTxt");
         this._descTxt.text = LanguageMgr.GetTranslation("playerDress.descTxt");
         addChild(this._descTxt);
         this._hideHatBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.hideHatCheckBox");
         addChild(this._hideHatBtn);
         this._hideGlassBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.hideGlassCheckBox");
         addChild(this._hideGlassBtn);
         this._hideSuitBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.hideSuitCheckBox");
         addChild(this._hideSuitBtn);
         this._hideWingBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.hideWingCheckBox");
         addChild(this._hideWingBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("playerDress.helpBtn");
         addChild(this._helpBtn);
         for(var i:int = 0; i <= CELLS_LENGTH - 1; i++)
         {
            cell = CellFactory.instance.createPlayerDressItemCell() as BagCell;
            cell.doubleClickEnabled = true;
            cell.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
            PositionUtils.setPos(cell,"playerDress.cellPos" + i);
            this._dressCells.push(cell);
            addChild(cell);
         }
         this.updateComboBox(this._comboBoxArr[this._currentIndex]);
         this.updateModel();
      }
      
      public function updateModel() : void
      {
         var sItem:InventoryItemInfo = null;
         var tItem:InventoryItemInfo = null;
         var i:int = 0;
         var templateId:int = 0;
         var itemId:int = 0;
         var key:int = 0;
         this._self = PlayerManager.Instance.Self;
         if(this._self.Sex)
         {
            this._currentModel.model.updateStyle(this._self.Sex,this._self.Hide,DressModel.DEFAULT_MAN_STYLE,",,,,,,","");
         }
         else
         {
            this._currentModel.model.updateStyle(this._self.Sex,this._self.Hide,DressModel.DEFAULT_WOMAN_STYLE,",,,,,,","");
         }
         this._bodyThings = new DictionaryData();
         var dressArr:Array = PlayerDressManager.instance.modelArr[this._currentIndex];
         var reSave:Boolean = false;
         if(Boolean(dressArr))
         {
            for(i = 0; i <= dressArr.length - 1; i++)
            {
               templateId = (dressArr[i] as DressVo).templateId;
               itemId = (dressArr[i] as DressVo).itemId;
               tItem = new InventoryItemInfo();
               sItem = this._self.Bag.getItemByItemId(itemId);
               if(!sItem)
               {
                  sItem = this._self.Bag.getItemByTemplateId(templateId);
                  reSave = true;
               }
               if(Boolean(sItem))
               {
                  tItem.setIsUsed(sItem.IsUsed);
                  ObjectUtils.copyProperties(tItem,sItem);
                  key = DressUtils.findItemPlace(tItem);
                  this._bodyThings.add(key,tItem);
                  if(tItem.CategoryID == EquipType.FACE)
                  {
                     this._currentModel.model.Skin = tItem.Skin;
                  }
                  this._currentModel.model.setPartStyle(tItem.CategoryID,tItem.NeedSex,tItem.TemplateID,tItem.Color);
               }
            }
         }
         this._currentModel.model.Bag.items = this._bodyThings;
         if(reSave)
         {
            this.saveModel();
         }
         this.setBtnsStatus();
         this.updateCharacter();
         this.updateHideCheckBox();
      }
      
      public function putOnDress(item:InventoryItemInfo) : void
      {
         var tItem:InventoryItemInfo = new InventoryItemInfo();
         tItem.setIsUsed(item.IsUsed);
         ObjectUtils.copyProperties(tItem,item);
         var key:int = DressUtils.findItemPlace(tItem);
         this._currentModel.model.Bag.items.add(key,tItem);
         if(tItem.CategoryID == EquipType.FACE)
         {
            this._currentModel.model.Skin = tItem.Skin;
         }
         this._currentModel.model.setPartStyle(tItem.CategoryID,tItem.NeedSex,tItem.TemplateID,tItem.Color);
         this.updateCharacter();
         this.setBtnsStatus();
      }
      
      private function initEvent() : void
      {
         this._self.Bag.addEventListener(BagEvent.UPDATE,this.__updateGoods);
         this._hideHatBtn.addEventListener(Event.SELECT,this.__hideHatChange);
         this._hideGlassBtn.addEventListener(Event.SELECT,this.__hideGlassChange);
         this._hideSuitBtn.addEventListener(Event.SELECT,this.__hideSuitesChange);
         this._hideWingBtn.addEventListener(Event.SELECT,this.__hideWingClickHandler);
         this._selectedBox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         this._saveBtn.addEventListener(MouseEvent.CLICK,this.__saveBtnClick);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okBtnClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpBtnClick);
      }
      
      protected function __updateGoods(event:BagEvent) : void
      {
         var key:String = null;
         var item:InventoryItemInfo = null;
         var slot:String = null;
         var changeItem:InventoryItemInfo = null;
         var tItem:InventoryItemInfo = null;
         var index:int = 0;
         var changeSlots:Dictionary = event.changedSlots;
         for(key in this._currentModel.model.Bag.items)
         {
            item = this._currentModel.model.Bag.items[key];
            if(Boolean(item))
            {
               for(slot in changeSlots)
               {
                  changeItem = changeSlots[slot];
                  if(Boolean(this._self.Bag.items[slot]))
                  {
                     if(item.ItemID != 0 && item.ItemID == changeItem.ItemID || item.ItemID == 0 && item.TemplateID == changeItem.TemplateID)
                     {
                        tItem = new InventoryItemInfo();
                        tItem.setIsUsed(changeItem.IsUsed);
                        ObjectUtils.copyProperties(tItem,changeItem);
                        this._currentModel.model.Bag.items[key] = tItem;
                        index = DressUtils.getBagItems(int(key),true);
                        if(Boolean(this._dressCells[index]))
                        {
                           this._dressCells[index].info = tItem;
                        }
                     }
                  }
               }
            }
         }
         this.setBtnsStatus();
      }
      
      protected function __cellDoubleClick(event:CellEvent) : void
      {
         var index:int = 0;
         var item:InventoryItemInfo = null;
         var sex:int = 0;
         for(var i:int = 0; i <= CELLS_LENGTH - 1; i++)
         {
            if(this._dressCells[i] == event.target)
            {
               index = DressUtils.getBagItems(i);
               item = this._currentModel.model.Bag.items[index];
               sex = this._self.Sex ? 1 : 2;
               this._currentModel.model.setPartStyle(item.CategoryID,sex);
               if(item.CategoryID == EquipType.FACE)
               {
                  this._currentModel.model.Skin = "";
               }
               this._currentModel.model.Bag.items[index] = null;
               this._dressCells[i].info = null;
            }
         }
         this.setBtnsStatus();
      }
      
      protected function __okBtnClick(event:MouseEvent) : void
      {
         var cell:BagCell = null;
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this.enableOKBtn(false);
         this.saveBtnClick = false;
         for(var j:int = 0; j <= CELLS_LENGTH - 1; j++)
         {
            cell = this._dressCells[j] as BagCell;
            if(cell.info && (cell.info.BindType == 1 || cell.info.BindType == 2 || cell.info.BindType == 3) && cell.itemInfo.IsBinds == false)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               return;
            }
         }
         if(!this.checkNeedGold())
         {
            return;
         }
         this.save();
         this.exchangeProperty();
      }
      
      private function checkNeedGold() : Boolean
      {
         var index:int = 0;
         var sourceItem:InventoryItemInfo = null;
         var targetItem:InventoryItemInfo = null;
         var sourcePlace:int = 0;
         var targetPlace:int = 0;
         var alert:BaseAlerFrame = null;
         var alertFrame:BaseAlerFrame = null;
         var isBool:Boolean = true;
         var needArr:Array = new Array();
         for(var i:int = 0; i <= CELLS_LENGTH - 1; i++)
         {
            index = DressUtils.getBagItems(i);
            sourceItem = this._currentModel.model.Bag.items[index];
            targetItem = this._self.Bag.items[index];
            if(Boolean(sourceItem) && this.checkOverDue(sourceItem))
            {
               sourceItem = null;
            }
            if(Boolean(sourceItem) && Boolean(targetItem))
            {
               sourcePlace = sourceItem.Place;
               targetPlace = targetItem.Place;
               if(sourcePlace != targetPlace)
               {
                  if(!DressUtils.hasNoAddition(targetItem))
                  {
                     needArr.push({
                        "sourcePlace":sourcePlace,
                        "targetPlace":targetPlace
                     });
                  }
               }
            }
         }
         var needGold:int = int(ServerConfigManager.instance.TransferStrengthenEx) * needArr.length;
         if(PlayerManager.Instance.Self.Gold < needGold)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
            isBool = false;
         }
         else if(needGold > 0)
         {
            alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.playerDressView.sureUseGold",needGold),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alertFrame.addEventListener(FrameEvent.RESPONSE,this._responseII);
            isBool = false;
         }
         return isBool;
      }
      
      private function _responseI(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFastPurchaseGold();
         }
         this.enableOKBtn(true);
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = EquipType.GOLD_BOX;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function _responseII(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = BaseAlerFrame(e.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.save();
            this.exchangeProperty();
         }
         else
         {
            this.enableOKBtn(true);
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function exchangeProperty() : void
      {
         var index:int = 0;
         var sourceItem:InventoryItemInfo = null;
         var targetItem:InventoryItemInfo = null;
         var sourcePlace:int = 0;
         var targetPlace:int = 0;
         PlayerDressManager.instance.lockDressBag();
         var equipBag:BagInfo = PlayerManager.Instance.Self.Bag;
         var goldNotEnough:Boolean = false;
         for(var i:int = 0; i <= CELLS_LENGTH - 1; i++)
         {
            index = DressUtils.getBagItems(i);
            sourceItem = this._currentModel.model.Bag.items[index];
            targetItem = this._self.Bag.items[index];
            if(Boolean(sourceItem) && this.checkOverDue(sourceItem))
            {
               sourceItem = null;
            }
            if(Boolean(sourceItem) && Boolean(targetItem))
            {
               sourcePlace = sourceItem.Place;
               targetPlace = targetItem.Place;
               if(sourcePlace != targetPlace)
               {
                  if(DressUtils.hasNoAddition(targetItem))
                  {
                     SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,sourcePlace,BagInfo.EQUIPBAG,targetPlace,1,true);
                  }
                  else if(PlayerManager.Instance.Self.Gold < NEED_GOLD)
                  {
                     goldNotEnough = true;
                     SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,sourcePlace,BagInfo.EQUIPBAG,targetPlace,1,true);
                  }
                  else
                  {
                     SocketManager.Instance.out.sendItemTransfer(true,true,BagInfo.EQUIPBAG,sourcePlace,BagInfo.EQUIPBAG,targetPlace);
                     SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,sourcePlace,BagInfo.EQUIPBAG,targetPlace,1,true);
                  }
               }
            }
            else if(!sourceItem && Boolean(targetItem))
            {
               SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,targetItem.Place,BagInfo.EQUIPBAG,-1,1,true);
            }
            else if(Boolean(sourceItem) && !targetItem)
            {
               SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,sourceItem.Place,BagInfo.EQUIPBAG,index,1,true);
            }
         }
         SocketManager.Instance.out.setCurrentModel(this._currentIndex);
         SocketManager.Instance.out.lockDressBag();
         if(goldNotEnough)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.goldNotEnough"));
         }
         if(NewHandContainer.Instance.hasArrow(ArrowType.DRESS_PUT_ON))
         {
            SocketManager.Instance.out.syncWeakStep(Step.DRESS_OPEN);
            NewHandContainer.Instance.clearArrowByID(ArrowType.DRESS_PUT_ON);
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.changeDressSuccess"));
      }
      
      protected function __saveBtnClick(event:MouseEvent) : void
      {
         var cell:BagCell = null;
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this.saveBtnClick = true;
         for(var i:int = 0; i <= CELLS_LENGTH - 1; i++)
         {
            cell = this._dressCells[i] as BagCell;
            if(cell.info && (cell.info.BindType == 1 || cell.info.BindType == 2 || cell.info.BindType == 3) && cell.itemInfo.IsBinds == false)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               return;
            }
         }
         this.save();
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
         switch(evt.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.save();
               if(!this.saveBtnClick)
               {
                  this.exchangeProperty();
               }
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.enableOKBtn(true);
         }
      }
      
      private function save() : void
      {
         this.saveModel();
         this.setBtnsStatus();
         if(this.saveBtnClick)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.saveModelSuccess"));
         }
      }
      
      private function saveModel() : void
      {
         var index:int = 0;
         var item:InventoryItemInfo = null;
         var dressPlaceArr:Array = [];
         for(var i:int = 0; i <= DressModel.DRESS_LEN - 1; i++)
         {
            index = DressUtils.getBagItems(i);
            item = this._currentModel.model.Bag.items[index];
            if(Boolean(item))
            {
               dressPlaceArr.push(item.Place);
            }
         }
         SocketManager.Instance.out.saveDressModel(this._currentIndex,dressPlaceArr);
      }
      
      protected function __onListClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._currentIndex == this._comboBoxArr.indexOf(event.cellValue))
         {
            return;
         }
         this._currentIndex = this._comboBoxArr.indexOf(event.cellValue);
         PlayerDressManager.instance.currentIndex = this._currentIndex;
         this.updateModel();
         this.updateComboBox(event.cellValue);
      }
      
      private function updateComboBox(obj:*) : void
      {
         var comboxModel:VectorListModel = this._selectedBox.listPanel.vectorListModel;
         comboxModel.clear();
         comboxModel.appendAll(this._comboBoxArr);
         comboxModel.remove(obj);
      }
      
      private function updateHideCheckBox() : void
      {
         this._hideHatBtn.selected = this._currentModel.model.getHatHide();
         this._hideGlassBtn.selected = this._currentModel.model.getGlassHide();
         this._hideSuitBtn.selected = this._currentModel.model.getSuitesHide();
         this._hideWingBtn.selected = this._currentModel.model.wingHide;
      }
      
      private function updateCharacter() : void
      {
         var itemId:int = 0;
         if(Boolean(this._currentModel.model))
         {
            if(!this._character)
            {
               this._character = CharactoryFactory.createCharacter(this._currentModel.model,"room") as RoomCharacter;
               PositionUtils.setPos(this._character,"playerDress.characterPos");
               this._character.showGun = false;
               this._character.show(false,-1);
               addChild(this._character);
            }
         }
         for(var i:int = 0; i < this._dressCells.length; i++)
         {
            itemId = DressUtils.getBagItems(i);
            if(Boolean(this._currentModel.model.Bag.items[itemId]))
            {
               this._dressCells[i].info = this._currentModel.model.Bag.items[itemId];
            }
            else
            {
               this._dressCells[i].info = null;
            }
         }
         MagicStoneManager.instance.updataCharacter(this._currentModel.model);
      }
      
      public function setBtnsStatus() : void
      {
         if(Boolean(this._saveBtn))
         {
            this._saveBtn.enable = this.canSaveBtnClick();
         }
         var enable:Boolean = this.canOKBtnClick();
         if(Boolean(this._okBtn))
         {
            this.enableOKBtn(enable);
         }
      }
      
      private function canSaveBtnClick() : Boolean
      {
         var c:int = 0;
         var item:InventoryItemInfo = null;
         var flag:Boolean = false;
         var j:int = 0;
         var vo:DressVo = null;
         var dressArr:Array = PlayerDressManager.instance.modelArr[this._currentIndex];
         if(!dressArr)
         {
            if(this._currentModel.model.Bag.items.length == 0)
            {
               return false;
            }
            return true;
         }
         var arr:Array = dressArr.concat();
         var i:int = 0;
         while(true)
         {
            if(i > CELLS_LENGTH - 1)
            {
               if(arr.length == 0)
               {
                  return false;
               }
               return true;
            }
            c = DressUtils.getBagItems(i);
            item = this._currentModel.model.Bag.items[c];
            if(Boolean(item))
            {
               flag = true;
               for(j = 0; j <= arr.length - 1; j++)
               {
                  vo = arr[j];
                  if(item.ItemID == vo.itemId)
                  {
                     arr.splice(j,1);
                     flag = false;
                     break;
                  }
               }
               if(flag)
               {
                  break;
               }
            }
            i++;
         }
         return true;
      }
      
      private function canOKBtnClick() : Boolean
      {
         var index:int = 0;
         var modelItem:InventoryItemInfo = null;
         var bodyItem:InventoryItemInfo = null;
         for(var i:int = 0; i <= CELLS_LENGTH - 1; i++)
         {
            index = DressUtils.getBagItems(i);
            modelItem = this._currentModel.model.Bag.items[index];
            bodyItem = this._self.Bag.items[index];
            if(modelItem && !bodyItem && !this.checkOverDue(modelItem) || !modelItem && bodyItem || modelItem && bodyItem && modelItem.ItemID != bodyItem.ItemID)
            {
               if(PlayerManager.Instance.Self.Grade >= 3 && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DRESS_OPEN))
               {
                  NewHandContainer.Instance.showArrow(ArrowType.DRESS_PUT_ON,180,"playerDress.dressTipPos","","",this,0,true);
               }
               return true;
            }
         }
         return false;
      }
      
      private function checkOverDue(item:InventoryItemInfo) : Boolean
      {
         var d:uint = 0;
         var nowDate:Date = TimeManager.Instance.Now();
         var begin:Date = DateUtils.getDateByStr(item.BeginDate);
         var diff:Number = Math.round((nowDate.getTime() - begin.getTime()) / 1000);
         if(diff >= 0)
         {
            d = Math.floor(diff / 60 / 60 / 24);
         }
         if(diff < 0 || item.IsUsed == true && item.ValidDate > 0 && d >= item.ValidDate)
         {
            return true;
         }
         return false;
      }
      
      private function __hideWingClickHandler(event:Event) : void
      {
         this._currentModel.model.wingHide = this._hideWingBtn.selected;
      }
      
      private function __hideSuitesChange(event:Event) : void
      {
         this._currentModel.model.setSuiteHide(this._hideSuitBtn.selected);
      }
      
      private function __hideGlassChange(event:Event) : void
      {
         this._currentModel.model.setGlassHide(this._hideGlassBtn.selected);
      }
      
      private function __hideHatChange(event:Event) : void
      {
         this._currentModel.model.setHatHide(this._hideHatBtn.selected);
      }
      
      protected function __helpBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("playerDress.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("playerDress.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("playerDress.dressReadMe");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function enableOKBtn(enable:Boolean) : void
      {
         this._okBtn.enable = enable;
         if(enable)
         {
            if(Boolean(this._okBtnSprite))
            {
               this._okBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__okBtnOverHandler);
               this._okBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__okBtnOutHandler);
               ObjectUtils.disposeObject(this._okBtnSprite);
               this._okBtnSprite = null;
            }
         }
         else if(!this._okBtnSprite)
         {
            this._okBtnSprite = new Sprite();
            this._okBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__okBtnOverHandler);
            this._okBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__okBtnOutHandler);
            this._okBtnSprite.graphics.beginFill(0,0);
            this._okBtnSprite.graphics.drawRect(0,0,this._okBtn.displayWidth,this._okBtn.displayHeight);
            this._okBtnSprite.graphics.endFill();
            this._okBtnSprite.x = this._okBtn.x - 1;
            this._okBtnSprite.y = this._okBtn.y + 3;
            addChild(this._okBtnSprite);
            this._okBtnTip = new OneLineTip();
            this._okBtnTip.tipData = LanguageMgr.GetTranslation("playerDress.okBtnTip");
            this._okBtnTip.visible = false;
         }
      }
      
      protected function __okBtnOverHandler(event:MouseEvent) : void
      {
         this._okBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._okBtnTip,LayerManager.GAME_TOP_LAYER);
         var pos:Point = this._okBtn.localToGlobal(new Point(0,0));
         this._okBtnTip.x = pos.x - 64;
         this._okBtnTip.y = pos.y + this._okBtn.height;
      }
      
      protected function __okBtnOutHandler(event:MouseEvent) : void
      {
         this._okBtnTip.visible = false;
      }
      
      private function removeEvent() : void
      {
         this._self.Bag.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         this._hideHatBtn.removeEventListener(Event.SELECT,this.__hideHatChange);
         this._hideGlassBtn.removeEventListener(Event.SELECT,this.__hideGlassChange);
         this._hideSuitBtn.removeEventListener(Event.SELECT,this.__hideSuitesChange);
         this._hideWingBtn.removeEventListener(Event.SELECT,this.__hideWingClickHandler);
         this._selectedBox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         this._saveBtn.removeEventListener(MouseEvent.CLICK,this.__saveBtnClick);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okBtnClick);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpBtnClick);
         if(Boolean(this._okBtnSprite))
         {
            this._okBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__okBtnOverHandler);
            this._okBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__okBtnOutHandler);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ComponentSetting.COMBOX_LIST_LAYER = LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER);
         NewHandContainer.Instance.clearArrowByID(ArrowType.DRESS_PUT_ON);
         ObjectUtils.disposeObject(this._BG);
         this._BG = null;
         ObjectUtils.disposeObject(this._hidePanel);
         this._hidePanel = null;
         ObjectUtils.disposeObject(this._saveBtn);
         this._saveBtn = null;
         ObjectUtils.disposeObject(this._okBtn);
         this._okBtn = null;
         ObjectUtils.disposeObject(this._okBtnSprite);
         this._okBtnSprite = null;
         ObjectUtils.disposeObject(this._okBtnTip);
         this._okBtnTip = null;
         ObjectUtils.disposeObject(this._selectedBox);
         this._selectedBox = null;
         ObjectUtils.disposeObject(this._descTxt);
         this._descTxt = null;
         ObjectUtils.disposeObject(this._hideGlassBtn);
         this._hideGlassBtn = null;
         ObjectUtils.disposeObject(this._hideHatBtn);
         this._hideHatBtn = null;
         ObjectUtils.disposeObject(this._hideSuitBtn);
         this._hideSuitBtn = null;
         ObjectUtils.disposeObject(this._hideWingBtn);
         this._hideWingBtn = null;
         ObjectUtils.disposeObject(this._character);
         this._character = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         for(var i:int = 0; i <= CELLS_LENGTH - 1; i++)
         {
            this._dressCells[i].removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
            ObjectUtils.disposeObject(this._dressCells[i]);
            this._dressCells[i] = null;
         }
      }
      
      public function get currentModel() : DressModel
      {
         return this._currentModel;
      }
   }
}

