package beadSystem.views
{
   import beadSystem.model.BeadInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import ddt.view.SimpleItem;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import road7th.utils.StringHelper;
   
   public class BeadUpgradeTipView extends Component
   {
      
      private var _strengthenLevelImage:MovieImage;
      
      private var _fusionLevelImage:MovieImage;
      
      private var _boundImage:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _qualityItem:SimpleItem;
      
      private var _typeItem:SimpleItem;
      
      private var _expItem:SimpleItem;
      
      private var _descriptionTxt:FilterFrameText;
      
      private var _bindTypeTxt:FilterFrameText;
      
      private var _remainTimeTxt:FilterFrameText;
      
      private var _info:ItemTemplateInfo;
      
      private var _bindImageOriginalPos:Point;
      
      private var _maxWidth:int;
      
      private var _minWidth:int = 240;
      
      private var _displayList:Vector.<DisplayObject>;
      
      private var _displayIdx:int;
      
      private var _lines:Vector.<Image>;
      
      private var _lineIdx:int;
      
      private var _isReAdd:Boolean;
      
      private var _remainTimeBg:Bitmap;
      
      private var _tipbackgound:MutipleImage;
      
      private var _rightArrows:Bitmap;
      
      private var _exp:int;
      
      private var _UpExp:int;
      
      public function BeadUpgradeTipView()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._lines = new Vector.<Image>();
         this._displayList = new Vector.<DisplayObject>();
         this._rightArrows = ComponentFactory.Instance.creatBitmap("asset.ddtstore.rightArrows");
         this._tipbackgound = ComponentFactory.Instance.creat("ddtstore.strengthTips.strengthenImageBG");
         this._strengthenLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameMc");
         this._fusionLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTrinketLevelMc");
         this._boundImage = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.BoundImage");
         this._bindImageOriginalPos = new Point(this._boundImage.x,this._boundImage.y);
         this._expItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.EXPItem");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         this._qualityItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.QualityItem");
         this._typeItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.TypeItem");
         this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.DescriptionTxt");
         this._bindTypeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._remainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemDateTxt");
         this._remainTimeBg = ComponentFactory.Instance.creatBitmap("asset.core.tip.restTime");
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(data:Object) : void
      {
         if(Boolean(data))
         {
            if(data is GoodTipInfo)
            {
               _tipData = data as GoodTipInfo;
               this.showTip(_tipData.itemInfo,_tipData.typeIsSecond);
            }
            visible = true;
         }
         else
         {
            _tipData = null;
            visible = false;
         }
      }
      
      public function showTip(info:ItemTemplateInfo, typeIsSecond:Boolean = false) : void
      {
         this._displayIdx = 0;
         this._displayList = new Vector.<DisplayObject>();
         this._lineIdx = 0;
         this._isReAdd = false;
         this._maxWidth = 0;
         this._info = info;
         this.updateView();
      }
      
      private function updateView() : void
      {
         if(this._info == null)
         {
            return;
         }
         this.clear();
         this.createItemName();
         this.createCategoryItem();
         this.careteEXP();
         this.seperateLine();
         this.createDescript();
         this.createBindType();
         this.createRemainTime();
         this.addChildren();
      }
      
      private function clear() : void
      {
         var display:DisplayObject = null;
         while(numChildren > 0)
         {
            display = getChildAt(0) as DisplayObject;
            if(Boolean(display.parent))
            {
               display.parent.removeChild(display);
            }
         }
      }
      
      override protected function addChildren() : void
      {
         var item:DisplayObject = null;
         var len:int = int(this._displayList.length);
         var pos:Point = new Point(4,4);
         var tempMaxWidth:int = this._maxWidth;
         for(var i:int = 0; i < len; i++)
         {
            item = this._displayList[i] as DisplayObject;
            if(this._lines.indexOf(item as Image) < 0 && item != this._descriptionTxt)
            {
               tempMaxWidth = Math.max(item.width,tempMaxWidth);
            }
            PositionUtils.setPos(item,pos);
            addChild(item);
            pos.y = item.y + item.height + 6;
         }
         this._maxWidth = Math.max(this._minWidth,tempMaxWidth);
         this._maxWidth -= 20;
         if(this._descriptionTxt.width != this._maxWidth)
         {
            this._descriptionTxt.width = this._maxWidth;
            this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
            this.addChildren();
            return;
         }
         if(!this._isReAdd)
         {
            for(i = 0; i < this._lines.length; i++)
            {
               this._lines[i].width = this._maxWidth;
               if(i + 1 < this._lines.length && this._lines[i + 1].parent != null && Math.abs(this._lines[i + 1].y - this._lines[i].y) <= 10)
               {
                  this._displayList.splice(this._displayList.indexOf(this._lines[i + 1]),1);
                  this._lines[i + 1].parent.removeChild(this._lines[i + 1]);
                  this._isReAdd = true;
               }
            }
            if(this._isReAdd)
            {
               this.addChildren();
               return;
            }
         }
         if(Boolean(this._rightArrows))
         {
            addChildAt(this._rightArrows,0);
         }
         if(len > 0)
         {
            this._tipbackgound.y = -5;
            _width = this._tipbackgound.width = this._maxWidth + 15;
            _height = this._tipbackgound.height = item.y + item.height + 18;
         }
         if(Boolean(this._tipbackgound))
         {
            addChildAt(this._tipbackgound,0);
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.x = this._remainTimeTxt.x + 2;
            this._remainTimeBg.y = this._remainTimeTxt.y + 2;
            this._remainTimeBg.parent.addChildAt(this._remainTimeBg,1);
         }
         this._rightArrows.x = 5 - this._rightArrows.width;
         this._rightArrows.y = (this.height - this._rightArrows.height) / 2;
      }
      
      private function createItemName() : void
      {
         this._nameTxt.text = _tipData.beadName;
         this._nameTxt.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
         var _loc1_:* = this._displayIdx++;
         this._displayList[_loc1_] = this._nameTxt;
      }
      
      private function careteEXP() : void
      {
         var fft:FilterFrameText = this._expItem.foreItems[0] as FilterFrameText;
         if(EquipType.isBead(int(this._info.Property1)))
         {
            this._exp = ServerConfigManager.instance.getBeadUpgradeExp()[(this._info as InventoryItemInfo).Hole1];
            this._UpExp = ServerConfigManager.instance.getBeadUpgradeExp()[(this._info as InventoryItemInfo).Hole1 + 1];
            fft.text = this._exp + "/" + this._UpExp;
            var _loc2_:* = this._displayIdx++;
            this._displayList[_loc2_] = this._expItem;
         }
      }
      
      private function createCategoryItem() : void
      {
         var fft:FilterFrameText = this._typeItem.foreItems[0] as FilterFrameText;
         switch(this._info.Property2)
         {
            case "1":
               fft.text = LanguageMgr.GetTranslation("tank.data.EquipType.atacckt");
               break;
            case "2":
               fft.text = LanguageMgr.GetTranslation("tank.data.EquipType.defent");
               break;
            case "3":
               fft.text = LanguageMgr.GetTranslation("tank.data.EquipType.attribute");
         }
         fft.textColor = 65406;
         var _loc2_:* = this._displayIdx++;
         this._displayList[_loc2_] = this._typeItem;
      }
      
      private function setPurpleHtmlTxt(title:String, value:int, add:String) : String
      {
         return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.setPurpleHtmlTxt",title,value,add);
      }
      
      private function createDescript() : void
      {
         var infoTemplate:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._info.TemplateID);
         if(this._info.Description == "")
         {
            return;
         }
         this._info.Description = infoTemplate.Description;
         var infoItem:InventoryItemInfo = this._info as InventoryItemInfo;
         var beadInfo:BeadInfo = BeadTemplateManager.Instance.GetBeadInfobyID(this._info.TemplateID);
         if(beadInfo.Attribute1 == "0" && beadInfo.Attribute2 == "0")
         {
            this._descriptionTxt.text = StringHelper.format(this._info.Description);
         }
         else if(beadInfo.Attribute1 == "0" && beadInfo.Attribute2 != "0")
         {
            if(beadInfo.Att2.length > 1)
            {
               if(Boolean(infoItem) && infoItem.Hole1 > beadInfo.BaseLevel)
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Att2[1]);
               }
               else
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Att2[0]);
               }
            }
            else
            {
               this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Attribute2);
            }
         }
         else if(beadInfo.Attribute1 != "0" && beadInfo.Attribute2 == "0")
         {
            if(beadInfo.Att1.length > 1)
            {
               if(Boolean(infoItem) && infoItem.Hole1 > beadInfo.BaseLevel)
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Att1[1]);
               }
               else
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Att1[0]);
               }
            }
            else
            {
               this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Attribute1);
            }
         }
         else if(beadInfo.Attribute1 != "0" && beadInfo.Attribute2 != "0")
         {
            if(beadInfo.Att1.length > 1 && beadInfo.Att2.length == 1)
            {
               if(Boolean(infoItem) && infoItem.Hole1 > beadInfo.BaseLevel)
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Att1[1],beadInfo.Attribute2);
               }
               else
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Att1[0],beadInfo.Attribute2);
               }
            }
            else if(beadInfo.Att1.length == 1 && beadInfo.Att2.length > 1)
            {
               if(Boolean(infoItem) && infoItem.Hole1 > beadInfo.BaseLevel)
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Attribute1,beadInfo.Att2[1]);
               }
               else
               {
                  this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Attribute1,beadInfo.Att2[0]);
               }
            }
            else if(Boolean(infoItem) && infoItem.Hole1 > beadInfo.BaseLevel)
            {
               this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Att1[1],beadInfo.Att2[1]);
            }
            else
            {
               this._descriptionTxt.text = StringHelper.format(this._info.Description,beadInfo.Att1[0],beadInfo.Att2[0]);
            }
         }
         this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
         var _loc4_:* = this._displayIdx++;
         this._displayList[_loc4_] = this._descriptionTxt;
      }
      
      private function ShowBound(info:InventoryItemInfo) : Boolean
      {
         return info.CategoryID != EquipType.SEED && info.CategoryID != EquipType.MANURE && info.CategoryID != EquipType.VEGETABLE;
      }
      
      private function createBindType() : void
      {
         var tempInfo:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(tempInfo) && this.ShowBound(tempInfo))
         {
            this._boundImage.setFrame(tempInfo.IsBinds ? int(GoodTip.BOUND) : int(GoodTip.UNBOUND));
            PositionUtils.setPos(this._boundImage,this._bindImageOriginalPos);
            addChild(this._boundImage);
            if(!tempInfo.IsBinds)
            {
               if(tempInfo.BindType == 3)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.bangding");
                  this._bindTypeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  var _loc2_:* = this._displayIdx++;
                  this._displayList[_loc2_] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 2)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.zhuangbei");
                  this._bindTypeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  _loc2_ = this._displayIdx++;
                  this._displayList[_loc2_] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 4)
               {
                  if(Boolean(this._boundImage.parent))
                  {
                     this._boundImage.parent.removeChild(this._boundImage);
                  }
               }
            }
         }
         else if(Boolean(this._boundImage.parent))
         {
            this._boundImage.parent.removeChild(this._boundImage);
         }
      }
      
      private function createRemainTime() : void
      {
         var tempReman:Number = NaN;
         var tempInfo:InventoryItemInfo = null;
         var remain:Number = NaN;
         var colorDate:Number = NaN;
         var str:String = null;
         var hour:Number = NaN;
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.parent.removeChild(this._remainTimeBg);
         }
         if(this._info is InventoryItemInfo)
         {
            tempInfo = this._info as InventoryItemInfo;
            remain = tempInfo.getRemainDate();
            colorDate = tempInfo.getColorValidDate();
            str = tempInfo.CategoryID == EquipType.ARM ? LanguageMgr.GetTranslation("bag.changeColor.tips.armName") : "";
            if(colorDate > 0 && colorDate != int.MAX_VALUE)
            {
               if(colorDate >= 1)
               {
                  this._remainTimeTxt.text = (tempInfo.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + Math.ceil(colorDate) + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  var _loc7_:* = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
               else
               {
                  hour = Math.floor(colorDate * 24);
                  if(hour < 1)
                  {
                     hour = 1;
                  }
                  this._remainTimeTxt.text = (tempInfo.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + hour + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  _loc7_ = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
            }
            if(remain == int.MAX_VALUE)
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
               this._remainTimeTxt.textColor = GoodTip.ITEM_ETERNAL_COLOR;
               _loc7_ = this._displayIdx++;
               this._displayList[_loc7_] = this._remainTimeTxt;
            }
            else if(remain > 0)
            {
               if(remain >= 1)
               {
                  tempReman = Math.ceil(remain);
                  this._remainTimeTxt.text = (tempInfo.IsUsed ? str + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + tempReman + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  _loc7_ = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
               else
               {
                  tempReman = Math.floor(remain * 24);
                  tempReman = tempReman < 1 ? 1 : tempReman;
                  this._remainTimeTxt.text = (tempInfo.IsUsed ? str + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + tempReman + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  _loc7_ = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
               addChild(this._remainTimeBg);
            }
            else if(!isNaN(remain))
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
               this._remainTimeTxt.textColor = GoodTip.ITEM_PAST_DUE_COLOR;
               _loc7_ = this._displayIdx++;
               this._displayList[_loc7_] = this._remainTimeTxt;
            }
         }
      }
      
      private function seperateLine() : void
      {
         var prop:Image = null;
         ++this._lineIdx;
         if(this._lines.length < this._lineIdx)
         {
            prop = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._lines.push(prop);
         }
         var _loc2_:* = this._displayIdx++;
         this._displayList[_loc2_] = this._lines[this._lineIdx - 1];
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._rightArrows))
         {
            ObjectUtils.disposeObject(this._rightArrows);
         }
         this._rightArrows = null;
         if(Boolean(this._tipbackgound))
         {
            ObjectUtils.disposeObject(this._tipbackgound);
         }
         this._tipbackgound = null;
         if(Boolean(this._strengthenLevelImage))
         {
            ObjectUtils.disposeObject(this._strengthenLevelImage);
         }
         this._strengthenLevelImage = null;
         if(Boolean(this._fusionLevelImage))
         {
            ObjectUtils.disposeObject(this._fusionLevelImage);
         }
         this._fusionLevelImage = null;
         if(Boolean(this._boundImage))
         {
            ObjectUtils.disposeObject(this._boundImage);
         }
         this._boundImage = null;
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(Boolean(this._qualityItem))
         {
            ObjectUtils.disposeObject(this._qualityItem);
         }
         this._qualityItem = null;
         if(Boolean(this._typeItem))
         {
            ObjectUtils.disposeObject(this._typeItem);
         }
         this._typeItem = null;
         if(Boolean(this._descriptionTxt))
         {
            ObjectUtils.disposeObject(this._descriptionTxt);
         }
         this._descriptionTxt = null;
         if(Boolean(this._bindTypeTxt))
         {
            ObjectUtils.disposeObject(this._bindTypeTxt);
         }
         this._bindTypeTxt = null;
         if(Boolean(this._remainTimeTxt))
         {
            ObjectUtils.disposeObject(this._remainTimeTxt);
         }
         this._remainTimeTxt = null;
         if(Boolean(this._remainTimeBg))
         {
            ObjectUtils.disposeObject(this._remainTimeBg);
         }
         this._remainTimeBg = null;
         if(Boolean(this._tipbackgound))
         {
            ObjectUtils.disposeObject(this._tipbackgound);
         }
         this._tipbackgound = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

