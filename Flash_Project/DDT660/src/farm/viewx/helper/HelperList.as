package farm.viewx.helper
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class HelperList extends Sprite implements Disposeable
   {
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _helperListBG:MovieClip;
      
      private var _helperListVLine:MutipleImage;
      
      private var _fieldIndex:BaseButton;
      
      private var _seedID:BaseButton;
      
      private var _fertilizerID:BaseButton;
      
      private var _isAuto:BaseButton;
      
      private var _fieldIndexText:FilterFrameText;
      
      private var _seedIDText:FilterFrameText;
      
      private var _fertilizerIDText:FilterFrameText;
      
      private var _isAutoText:FilterFrameText;
      
      private var _seedInfos:Dictionary;
      
      private var _fertilizerInfos:Dictionary;
      
      private var _helperItemList:Array;
      
      private var _currentSelectHelperItem:HelperItem;
      
      public function HelperList()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._helperListBG = ClassUtils.CreatInstance("assets.farm.helperPanelBg");
         this._helperListVLine = ComponentFactory.Instance.creatComponentByStylename("farm.helperListVLine");
         this._fieldIndex = ComponentFactory.Instance.creatComponentByStylename("helperList.fieldIndex");
         this._seedID = ComponentFactory.Instance.creatComponentByStylename("helperList.seedID");
         this._fertilizerID = ComponentFactory.Instance.creatComponentByStylename("helperList.fertilizerID");
         this._isAuto = ComponentFactory.Instance.creatComponentByStylename("helperList.isAuto");
         this._fieldIndexText = ComponentFactory.Instance.creatComponentByStylename("helperList.fieldIndexText");
         this._seedIDText = ComponentFactory.Instance.creatComponentByStylename("helperList.seedIDText");
         this._fertilizerIDText = ComponentFactory.Instance.creatComponentByStylename("helperList.fertilizerIDText");
         this._isAutoText = ComponentFactory.Instance.creatComponentByStylename("helperList.isAutoText");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperList.listVbox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperList.listScrollPanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._helperListBG);
         addChild(this._helperListVLine);
         addChild(this._fieldIndex);
         addChild(this._seedID);
         addChild(this._fertilizerID);
         addChild(this._isAuto);
         addChild(this._fieldIndexText);
         addChild(this._seedIDText);
         addChild(this._fertilizerIDText);
         addChild(this._isAutoText);
         addChild(this._vbox);
         addChild(this._scrollPanel);
         this._fieldIndexText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.fieldIndexText");
         this._seedIDText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.seedIDText");
         this._fertilizerIDText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.fertilizerIDText");
         this._isAutoText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.isAutoText");
         this.setTip(this._fieldIndex,this._fieldIndexText.text);
         this.setTip(this._seedID,this._seedIDText.text);
         this.setTip(this._fertilizerID,this._fertilizerIDText.text);
         this.setTip(this._isAuto,this._isAutoText.text);
         this.setListData();
      }
      
      private function setTip(btn:BaseButton, value:String) : void
      {
         btn.tipStyle = "ddt.view.tips.OneLineTip";
         btn.tipDirctions = "0";
         btn.tipData = value;
      }
      
      public function get helperItemList() : Array
      {
         return this._helperItemList;
      }
      
      private function findNumState(seedId:int, fertilizerId:int) : int
      {
         var item:HelperItem = null;
         var seedinfo:InventoryItemInfo = null;
         var obj:Object = null;
         var id1:int = 0;
         var id2:int = 0;
         var state:int = 0;
         var count1:int = 0;
         var count2:int = 0;
         for each(item in this._helperItemList)
         {
            obj = item.getSetViewItemData;
            if(!obj)
            {
               obj = item.getItemData;
            }
            id1 = int(obj.currentSeedText);
            if(seedId > 0 && id1 == seedId)
            {
               count1 += int(obj.currentSeedNum);
            }
            id2 = int(obj.currentFertilizerText);
            if(fertilizerId > 0 && id2 == fertilizerId)
            {
               count2 += int(obj.currentFertilizerNum);
            }
         }
         seedinfo = FarmModelController.instance.model.findItemInfo(EquipType.SEED,seedId);
         if(Boolean(seedinfo) && count1 > seedinfo.Count)
         {
            state = 1;
         }
         var fertilireInfo:InventoryItemInfo = FarmModelController.instance.model.findItemInfo(EquipType.MANURE,fertilizerId);
         if(Boolean(fertilireInfo) && count2 > fertilireInfo.Count)
         {
            state = 2;
         }
         return state;
      }
      
      private function setListData() : void
      {
         var helperItem:HelperItem = null;
         var fieldVO:FieldVO = null;
         var itemInfo:ShopItemInfo = null;
         var itemInfo1:ShopItemInfo = null;
         this._vbox.disposeAllChildren();
         this._helperItemList = [];
         var fieldsInfo:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         var length:int = Boolean(fieldsInfo) ? int(fieldsInfo.length) : 0;
         for(var i:int = 0; i < length; i++)
         {
            helperItem = new HelperItem();
            helperItem.addEventListener(MouseEvent.CLICK,this.__onItemClickHandler);
            helperItem.findNumState = this.findNumState;
            helperItem.index = i;
            fieldVO = null;
            fieldVO = fieldsInfo[i];
            if(fieldVO.isDig)
            {
               helperItem.initView(1);
               helperItem.setCellValue(fieldVO);
               this._helperItemList.push(helperItem);
               this._vbox.addChild(helperItem);
            }
         }
         this._scrollPanel.invalidateViewport();
         this._seedInfos = new Dictionary();
         this._fertilizerInfos = new Dictionary();
         var arr:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         var autoFertilizer:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_MANURE_TYPE);
         for(var m:int = 0; m < arr.length; m++)
         {
            itemInfo = arr[m];
            this._seedInfos[itemInfo.TemplateInfo.Name] = itemInfo.TemplateInfo.TemplateID;
         }
         for(var k:int = 0; k < autoFertilizer.length; k++)
         {
            itemInfo1 = autoFertilizer[k];
            this._fertilizerInfos[itemInfo1.TemplateInfo.Name] = itemInfo1.TemplateInfo.TemplateID;
         }
      }
      
      public function onKeyStart() : void
      {
         var item:HelperItem = null;
         var temp:Array = new Array();
         for each(item in this._helperItemList)
         {
            if(item.onKeyStart())
            {
               temp.push(item.getItemData);
            }
         }
         if(temp.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.onKeyStartFail"));
         }
         else
         {
            FarmModelController.instance.farmHelperSetSwitch(temp,true);
         }
      }
      
      public function onKeyStop() : void
      {
         var item:HelperItem = null;
         var temp:Array = new Array();
         for each(item in this._helperItemList)
         {
            if(item.onKeyStop())
            {
               temp.push(item.getItemData);
            }
         }
         if(temp.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.onKeyStopFail"));
         }
         else
         {
            FarmModelController.instance.farmHelperSetSwitch(temp,false);
         }
      }
      
      private function __onItemClickHandler(event:MouseEvent) : void
      {
         var helperItem:HelperItem = HelperItem(event.currentTarget);
         helperItem.isSelelct(true);
         if(Boolean(this._currentSelectHelperItem) && this._currentSelectHelperItem != helperItem)
         {
            this._currentSelectHelperItem.isSelelct(false);
         }
         this._currentSelectHelperItem = helperItem;
      }
      
      private function initEvent() : void
      {
         FarmModelController.instance.addEventListener(FarmEvent.HELPER_SWITCH_FIELD,this.__helperSwitchHandler);
         FarmModelController.instance.addEventListener(FarmEvent.HELPER_KEY_FIELD,this.__helperKeyHandler);
      }
      
      private function __helperSwitchHandler(e:FarmEvent) : void
      {
         var field1:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.isAutoId);
         if(field1.isDig)
         {
            HelperItem(this.getHelperItem(field1.fieldID)).setCellValue(field1);
         }
         FarmModelController.instance.model.dispatchEvent(new FarmEvent(FarmEvent.UPDATE_HELPERISAUTO));
      }
      
      private function __helperKeyHandler(e:FarmEvent) : void
      {
         var field1:FieldVO = null;
         for(var i:int = 0; i < FarmModelController.instance.model.batchFieldIDArray.length; i++)
         {
            field1 = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.batchFieldIDArray[i]);
            if(field1.isDig)
            {
               HelperItem(this.getHelperItem(field1.fieldID)).setCellValue(field1);
            }
         }
         FarmModelController.instance.model.dispatchEvent(new FarmEvent(FarmEvent.UPDATE_HELPERISAUTO));
      }
      
      public function getHelperItem(pFieldID:int) : HelperItem
      {
         var helpItem:HelperItem = null;
         for each(helpItem in this._helperItemList)
         {
            if(helpItem.currentFieldID == pFieldID)
            {
               return helpItem;
            }
         }
         return null;
      }
      
      public function dispose() : void
      {
         var helperItem:HelperItem = null;
         FarmModelController.instance.removeEventListener(FarmEvent.HELPER_SWITCH_FIELD,this.__helperSwitchHandler);
         FarmModelController.instance.removeEventListener(FarmEvent.HELPER_KEY_FIELD,this.__helperKeyHandler);
         if(Boolean(this._helperItemList))
         {
            for each(helperItem in this._helperItemList)
            {
               helperItem.removeEventListener(MouseEvent.CLICK,this.__onItemClickHandler);
               helperItem.dispose();
            }
            this._helperItemList = null;
         }
         if(Boolean(this._vbox))
         {
            this._vbox.disposeAllChildren();
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._helperListBG))
         {
            ObjectUtils.disposeObject(this._helperListBG);
         }
         this._helperListBG = null;
         if(Boolean(this._scrollPanel))
         {
            ObjectUtils.disposeObject(this._scrollPanel);
         }
         this._scrollPanel = null;
         if(Boolean(this._fieldIndex))
         {
            ObjectUtils.disposeObject(this._fieldIndex);
         }
         this._fieldIndex = null;
         if(Boolean(this._seedID))
         {
            ObjectUtils.disposeObject(this._seedID);
         }
         this._seedID = null;
         if(Boolean(this._fertilizerID))
         {
            ObjectUtils.disposeObject(this._fertilizerID);
         }
         this._fertilizerID = null;
         if(Boolean(this._isAuto))
         {
            ObjectUtils.disposeObject(this._isAuto);
         }
         this._isAuto = null;
         if(Boolean(this._fieldIndexText))
         {
            ObjectUtils.disposeObject(this._fieldIndexText);
         }
         this._fieldIndexText = null;
         if(Boolean(this._seedIDText))
         {
            ObjectUtils.disposeObject(this._seedIDText);
         }
         this._seedIDText = null;
         if(Boolean(this._fertilizerIDText))
         {
            ObjectUtils.disposeObject(this._fertilizerIDText);
         }
         this._fertilizerIDText = null;
         if(Boolean(this._isAutoText))
         {
            ObjectUtils.disposeObject(this._isAutoText);
         }
         this._isAutoText = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

