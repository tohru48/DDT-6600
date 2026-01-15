package farm.viewx.helper
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.modelx.FieldVO;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class HelperItem extends Sprite
   {
      
      private var _itemBG:ScaleFrameImage;
      
      private var _fieldVO:FieldVO;
      
      private var _fieldIndex:FilterFrameText;
      
      private var _SeedTxt:FilterFrameText;
      
      private var _SeedNumTxt:FilterFrameText;
      
      private var _FertilizerTxt:FilterFrameText;
      
      private var _FertilizerNumTxt:FilterFrameText;
      
      private var _cbxSeed:ComboBox;
      
      private var _cbxFertilizer:ComboBox;
      
      private var _btnIsAuto:BaseButton;
      
      private var _light:Scale9CornerImage;
      
      private var _seedInfos:Dictionary;
      
      private var _fertilizerInfos:Dictionary;
      
      private var _txtIsAutoArray:Array;
      
      private var _selectTipMsg:String;
      
      public var _isAutoFunction:Function;
      
      private var _btnState:Boolean;
      
      private var _currentFrame:int;
      
      private var _index:int;
      
      private var _isSelected:Boolean;
      
      private var _state:int;
      
      private var _findNumState:Function;
      
      private var _helperSetView:HelperSetView;
      
      public function HelperItem()
      {
         super();
      }
      
      public function initView(state:int = 0) : void
      {
         buttonMode = true;
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("helperItem.BG");
         addChild(this._itemBG);
         this._fieldIndex = ComponentFactory.Instance.creatComponentByStylename("helperItem.fieldIndex");
         addChild(this._fieldIndex);
         this._state = state;
         if(state != 0)
         {
            this._cbxSeed = ComponentFactory.Instance.creat("asset.ddtfarm.helper.seedDropListCombo");
            this._cbxFertilizer = ComponentFactory.Instance.creat("asset.ddtfarm.helper.filterFrameDropListCombo");
            this._SeedTxt = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SeedTxt");
            addChild(this._SeedTxt);
            this._SeedTxt.text = LanguageMgr.GetTranslation("ddt.fram.helperItem.Text");
            this._SeedNumTxt = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SeedNumTxt");
            addChild(this._SeedNumTxt);
            this._FertilizerTxt = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SeedTxt");
            addChild(this._FertilizerTxt);
            this._FertilizerTxt.text = LanguageMgr.GetTranslation("ddt.fram.helperItem.Text");
            PositionUtils.setPos(this._FertilizerTxt,"farm.helper.SeedTxtPos");
            this._FertilizerNumTxt = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SeedNumTxt");
            addChild(this._FertilizerNumTxt);
            PositionUtils.setPos(this._FertilizerNumTxt,"farm.helper.SeedTxtNumPos");
            this._btnIsAuto = ComponentFactory.Instance.creatComponentByStylename("helperItem.isAutoBtn");
            addChild(this._btnIsAuto);
            this._light = ComponentFactory.Instance.creatComponentByStylename("farm.helperListItem.light");
            addChild(this._light);
            this._light.mouseChildren = this._light.mouseEnabled = this._light.visible = false;
            this._txtIsAutoArray = [LanguageMgr.GetTranslation("ddt.farm.helperList.txtStart"),LanguageMgr.GetTranslation("ddt.farm.helperList.txtStop")];
            this._selectTipMsg = LanguageMgr.GetTranslation("ddt.fram.helperItem.Text");
            this.setSeedPanelData();
            this.setFertilizerPanelData();
            this.initEvent();
         }
      }
      
      public function set index(value:int) : void
      {
         this._index = value;
      }
      
      private function initEvent() : void
      {
         this._btnIsAuto.addEventListener(MouseEvent.CLICK,this.__isAutoClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function __cbxSeedChange(evt:ListItemEvent) : void
      {
         if(this._cbxSeed.textField.text == this._selectTipMsg)
         {
            return;
         }
         if(!this.__seedItemClickCheck())
         {
            this._cbxSeed.textField.text = this._selectTipMsg;
         }
      }
      
      private function __fertilizerChange(evt:ListItemEvent) : void
      {
         if(this._cbxFertilizer.textField.text == this._selectTipMsg)
         {
            return;
         }
         if(!this.__fertilizerItemClickCheck())
         {
            this._cbxFertilizer.textField.text = this._selectTipMsg;
         }
      }
      
      private function __mouseOverHandler(evt:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function __mouseOutHandler(evt:MouseEvent) : void
      {
         this._light.visible = this._isSelected;
      }
      
      public function isSelelct(b:Boolean) : void
      {
         if(Boolean(this._light))
         {
            this._light.visible = this._isSelected = b;
         }
      }
      
      public function getCellValue() : *
      {
         return this._fieldVO;
      }
      
      public function set btnState(value:Boolean) : void
      {
         this._btnState = value;
      }
      
      public function get btnState() : Boolean
      {
         return this._btnState;
      }
      
      public function get currentFertilizer() : String
      {
         return this._FertilizerTxt.text;
      }
      
      public function get currentFertilizerNum() : int
      {
         return int(this._FertilizerNumTxt.text);
      }
      
      public function get currentSeed() : String
      {
         return this._SeedTxt.text;
      }
      
      public function get currentSeedNum() : int
      {
         return int(this._SeedNumTxt.text);
      }
      
      public function get currentfindIndex() : int
      {
         return int(this._fieldIndex.text) - 1;
      }
      
      public function get currentFieldID() : int
      {
         return this._fieldVO.fieldID;
      }
      
      public function setCellValue(value:*) : void
      {
         if(value)
         {
            this._fieldVO = value;
            this._fieldIndex.text = String(this._fieldVO.fieldID + 1);
            if(Boolean(this._SeedTxt) && Boolean(this._FertilizerTxt))
            {
               if(this._fieldVO.autoSeedID == 0)
               {
                  this._SeedTxt.text = this._selectTipMsg;
                  this._SeedNumTxt.text = this._fieldVO.autoSeedIDCount.toString();
               }
               else
               {
                  this._SeedTxt.text = ItemManager.Instance.getTemplateById(this._fieldVO.autoSeedID).Name;
                  this._SeedNumTxt.text = this._fieldVO.autoSeedIDCount.toString();
               }
               if(this._fieldVO.autoFertilizerID == 0)
               {
                  this._FertilizerTxt.text = this._selectTipMsg;
                  this._FertilizerNumTxt.text = this._fieldVO.autoFertilizerCount.toString();
               }
               else
               {
                  this._FertilizerTxt.text = ItemManager.Instance.getTemplateById(this._fieldVO.autoFertilizerID).Name;
                  this._FertilizerNumTxt.text = this._fieldVO.autoFertilizerCount.toString();
               }
               this.btnState = !this._fieldVO.isAutomatic;
               if(this._fieldVO.isAutomatic)
               {
                  this._currentFrame = 2;
                  this._btnIsAuto.enable = false;
                  this._itemBG.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                  this._itemBG.setFrame(1);
               }
               else
               {
                  this._currentFrame = 1;
                  this._btnIsAuto.enable = true;
                  this._itemBG.filters = ComponentFactory.Instance.creatFilters("lightFilter");
                  this._itemBG.setFrame(1);
               }
            }
         }
      }
      
      private function setDropListClickable(pIsClickable:Boolean) : void
      {
         this._cbxSeed.enable = pIsClickable;
         this._cbxFertilizer.enable = pIsClickable;
      }
      
      private function setSeedPanelData() : void
      {
         var itemInfo:ShopItemInfo = null;
         this._seedInfos = new Dictionary();
         this._cbxSeed.beginChanges();
         var listModel:VectorListModel = this._cbxSeed.listPanel.vectorListModel;
         listModel.clear();
         listModel.append(this._selectTipMsg);
         var arr:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         for(var i:int = 0; i < arr.length; i++)
         {
            itemInfo = arr[i];
            this._seedInfos[itemInfo.TemplateInfo.Name] = itemInfo.TemplateInfo.TemplateID;
            listModel.append(itemInfo.TemplateInfo.Name);
         }
         this._cbxSeed.commitChanges();
      }
      
      private function setFertilizerPanelData() : void
      {
         var itemInfo:ShopItemInfo = null;
         this._fertilizerInfos = new Dictionary();
         this._cbxFertilizer.beginChanges();
         var listModel:VectorListModel = this._cbxFertilizer.listPanel.vectorListModel;
         listModel.clear();
         listModel.append(this._selectTipMsg);
         var arr:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_MANURE_TYPE);
         for(var i:int = 0; i < arr.length; i++)
         {
            itemInfo = arr[i];
            this._fertilizerInfos[itemInfo.TemplateInfo.Name] = itemInfo.TemplateInfo.TemplateID;
            listModel.append(itemInfo.TemplateInfo.Name);
         }
         this._cbxFertilizer.commitChanges();
      }
      
      private function __seedCheck() : Boolean
      {
         var templateID:int = 0;
         var arr:Array = null;
         var item:InventoryItemInfo = null;
         var ret:Boolean = true;
         if(this._seedInfos.hasOwnProperty(this._SeedTxt.text))
         {
            templateID = int(this._seedInfos[this._SeedTxt.text]);
            arr = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.SEED);
            for each(item in arr)
            {
               if(item.TemplateID == templateID)
               {
                  if(item.Count > 0)
                  {
                     ret = true;
                  }
                  break;
               }
            }
         }
         return ret;
      }
      
      public function set findNumState(value:Function) : void
      {
         this._findNumState = value;
      }
      
      private function __seedItemClickCheck() : Boolean
      {
         var templateID:int = 0;
         var arr:Array = null;
         var item:InventoryItemInfo = null;
         var ret:Boolean = false;
         if(this._seedInfos.hasOwnProperty(this._SeedTxt.text))
         {
            templateID = int(this._seedInfos[this._SeedTxt.text]);
            arr = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.SEED);
            for each(item in arr)
            {
               if(item.TemplateID == templateID)
               {
                  if(item.Count > 0)
                  {
                     ret = true;
                  }
                  break;
               }
            }
            if(!ret)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.selectSeedFail"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.pleaseSelectSeed"));
         }
         return ret;
      }
      
      private function __fertilizerItemClickCheck() : Boolean
      {
         var templateID:int = 0;
         var arr:Array = null;
         var item:InventoryItemInfo = null;
         var ret:Boolean = false;
         if(this._fertilizerInfos.hasOwnProperty(this._cbxFertilizer.textField.text))
         {
            templateID = int(this._fertilizerInfos[this._cbxFertilizer.textField.text]);
            arr = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.MANURE);
            for each(item in arr)
            {
               if(item.TemplateID == templateID)
               {
                  if(item.Count > 0)
                  {
                     ret = true;
                  }
                  break;
               }
            }
            if(!ret)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.selectFertilizerFail"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.pleaseSelectSeedI"));
         }
         return ret;
      }
      
      private function __isAutoClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helperSetView = ComponentFactory.Instance.creatComponentByStylename("farm.helperSetView.helper");
         this._helperSetView.helperSetViewSelectResult = this.__helperSetViewSelect;
         this._helperSetView.update(this._SeedTxt,this._SeedNumTxt,this._FertilizerTxt,this._FertilizerNumTxt);
         this._helperSetView.findNumState = this._findNumState;
         this._helperSetView.show();
      }
      
      private function __helperSetViewSelect(info:Object) : void
      {
         var _seedId:int = 0;
         var _seedNum:int = 0;
         var setInfo:ItemTemplateInfo = null;
         var _manureId:int = 0;
         var _manureNum:int = 0;
         var ferInof:ItemTemplateInfo = null;
         if(Boolean(info.isSeed))
         {
            _seedId = int(info.seedId);
            _seedNum = int(info.seedNum);
            setInfo = ItemManager.Instance.getTemplateById(_seedId);
            this._SeedTxt.text = setInfo.Name;
            this._SeedNumTxt.text = _seedNum.toString();
         }
         else
         {
            this._SeedTxt.text = this._selectTipMsg;
            this._SeedNumTxt.text = "0";
         }
         if(Boolean(info.isManure))
         {
            _manureId = int(info.manureId);
            _manureNum = int(info.manureNum);
            ferInof = ItemManager.Instance.getTemplateById(_manureId);
            this._FertilizerTxt.text = ferInof.Name;
            this._FertilizerNumTxt.text = _manureNum.toString();
         }
         else
         {
            this._FertilizerTxt.text = this._selectTipMsg;
            this._FertilizerNumTxt.text = "0";
         }
      }
      
      public function get getSetViewItemData() : Object
      {
         var obj:Object = null;
         if(Boolean(this._helperSetView))
         {
            obj = {};
            obj.currentSeedText = this._helperSetView.getTxtId1;
            obj.currentSeedNum = this._helperSetView.getTxtNum1;
            obj.currentFertilizerText = this._helperSetView.getTxtId2;
            obj.currentFertilizerNum = this._helperSetView.getTxtNum2;
         }
         return obj;
      }
      
      public function get getItemData() : Object
      {
         var itemInfo:ShopItemInfo = null;
         var itemInfo1:ShopItemInfo = null;
         var arr:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         for(var i:int = 0; i < arr.length; i++)
         {
            itemInfo = arr[i];
            this._seedInfos[itemInfo.TemplateInfo.Name] = itemInfo.TemplateInfo.TemplateID;
         }
         var arr1:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_MANURE_TYPE);
         for(var k:int = 0; k < arr1.length; k++)
         {
            itemInfo1 = arr1[k];
            this._fertilizerInfos[itemInfo1.TemplateInfo.Name] = itemInfo1.TemplateInfo.TemplateID;
         }
         var obj:Object = {};
         obj.currentfindIndex = this.currentfindIndex;
         if(this.currentSeed == this._selectTipMsg)
         {
            obj.currentSeedText = 0;
         }
         else
         {
            obj.currentSeedText = this._seedInfos[this.currentSeed];
         }
         if(this.currentFertilizer == this._selectTipMsg)
         {
            obj.currentFertilizerText = 0;
         }
         else
         {
            obj.currentFertilizerText = this._fertilizerInfos[this.currentFertilizer];
         }
         obj.currentSeedNum = this.currentSeedNum;
         obj.autoFertilizerNum = this.currentFertilizerNum;
         return obj;
      }
      
      public function onKeyStart() : Boolean
      {
         if(!this._fieldVO.isDig)
         {
            return false;
         }
         if(this._state == 0 || !this.btnState || !this.__seedCheck())
         {
            return false;
         }
         var fieldIndex:int = int(this._fieldIndex.text) - 1;
         var autoSeedID:int = 0;
         if(this._SeedTxt.text != this._selectTipMsg && Boolean(this._seedInfos.hasOwnProperty(this._SeedTxt.text)))
         {
            autoSeedID = int(this._seedInfos[this._SeedTxt.text]);
         }
         var autoFertilizerID:int = 0;
         if(this._fertilizerInfos.hasOwnProperty(this._FertilizerTxt.text))
         {
            autoFertilizerID = int(this._fertilizerInfos[this._FertilizerTxt.text]);
         }
         if(autoSeedID > 0)
         {
            return true;
         }
         return true;
      }
      
      public function onKeyStop() : Boolean
      {
         if(!this._fieldVO.isDig)
         {
            return false;
         }
         if(this._state == 0 || this.btnState)
         {
            return false;
         }
         var fieldIndex:int = int(this._fieldIndex.text) - 1;
         var autoSeedID:int = 0;
         if(this._seedInfos.hasOwnProperty(this._SeedTxt.text))
         {
            autoSeedID = int(this._seedInfos[this._SeedTxt.text]);
         }
         var autoFertilizerID:int = 0;
         if(this._fertilizerInfos.hasOwnProperty(this._FertilizerTxt.text))
         {
            autoFertilizerID = int(this._fertilizerInfos[this._FertilizerTxt.text]);
         }
         return true;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btnIsAuto))
         {
            this._btnIsAuto.removeEventListener(MouseEvent.CLICK,this.__isAutoClick);
         }
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         if(Boolean(this._cbxSeed))
         {
            this._cbxSeed.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__cbxSeedChange);
         }
         if(Boolean(this._cbxFertilizer))
         {
            this._cbxFertilizer.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__fertilizerChange);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._itemBG))
         {
            ObjectUtils.disposeObject(this._itemBG);
         }
         this._itemBG = null;
         if(Boolean(this._fieldIndex))
         {
            ObjectUtils.disposeObject(this._fieldIndex);
         }
         this._fieldIndex = null;
         if(Boolean(this._cbxSeed))
         {
            this._cbxSeed.dispose();
         }
         this._cbxSeed = null;
         if(Boolean(this._cbxFertilizer))
         {
            this._cbxFertilizer.dispose();
         }
         this._cbxFertilizer = null;
         if(Boolean(this._btnIsAuto))
         {
            ObjectUtils.disposeObject(this._btnIsAuto);
         }
         this._btnIsAuto = null;
         ObjectUtils.disposeAllChildren(this);
         this._findNumState = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

