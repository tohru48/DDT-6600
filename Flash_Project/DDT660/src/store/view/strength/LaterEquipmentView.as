package store.view.strength
{
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
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.utils.StaticFormula;
   import ddt.view.SimpleItem;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   import enchant.EnchantManager;
   import enchant.data.EnchantInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import latentEnergy.LatentEnergyTipItem;
   import road7th.utils.DateUtils;
   import road7th.utils.StringHelper;
   
   public class LaterEquipmentView extends Component
   {
      
      public static const enchantLevelTxtArr:Array = LanguageMgr.GetTranslation("enchant.levelTxt").split(",");
      
      public static const ITEM_ENCHANT_COLOR:uint = 13971455;
      
      private var _strengthenLevelImage:MovieImage;
      
      private var _fusionLevelImage:MovieImage;
      
      private var _boundImage:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _qualityItem:SimpleItem;
      
      private var _typeItem:SimpleItem;
      
      private var _mainPropertyItem:SimpleItem;
      
      private var _armAngleItem:SimpleItem;
      
      private var _otherHp:SimpleItem;
      
      private var _necklaceItem:FilterFrameText;
      
      private var _attackTxt:FilterFrameText;
      
      private var _defenseTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _enchantLevelTxt:FilterFrameText;
      
      private var _enchantAttackTxt:FilterFrameText;
      
      private var _enchantDefenceTxt:FilterFrameText;
      
      private var _needLevelTxt:FilterFrameText;
      
      private var _needSexTxt:FilterFrameText;
      
      private var _holes:Vector.<FilterFrameText> = new Vector.<FilterFrameText>();
      
      private var _upgradeType:FilterFrameText;
      
      private var _descriptionTxt:FilterFrameText;
      
      private var _bindTypeTxt:FilterFrameText;
      
      private var _remainTimeTxt:FilterFrameText;
      
      private var _goldRemainTimeTxt:FilterFrameText;
      
      private var _fightPropConsumeTxt:FilterFrameText;
      
      private var _boxTimeTxt:FilterFrameText;
      
      private var _limitGradeTxt:FilterFrameText;
      
      private var _info:ItemTemplateInfo;
      
      private var _bindImageOriginalPos:Point;
      
      private var _maxWidth:int;
      
      private var _minWidth:int = 220;
      
      private var _isArmed:Boolean;
      
      private var _displayList:Vector.<DisplayObject>;
      
      private var _displayIdx:int;
      
      private var _lines:Vector.<Image>;
      
      private var _lineIdx:int;
      
      private var _isReAdd:Boolean;
      
      private var _remainTimeBg:Bitmap;
      
      private var _tipbackgound:MutipleImage;
      
      private var _rightArrows:Bitmap;
      
      public function LaterEquipmentView()
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
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         this._qualityItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.QualityItem");
         this._typeItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.TypeItem");
         this._mainPropertyItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.MainPropertyItem");
         this._armAngleItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.armAngleItem");
         this._otherHp = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.otherHp");
         this._necklaceItem = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._defenseTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._enchantLevelTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._enchantAttackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._enchantDefenceTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._holes = new Vector.<FilterFrameText>();
         for(var i:int = 0; i < 6; i++)
         {
            this._holes.push(ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt"));
         }
         this._needLevelTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._needSexTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._upgradeType = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.DescriptionTxt");
         this._bindTypeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._remainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemDateTxt");
         this._goldRemainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipGoldItemDateTxt");
         this._remainTimeBg = ComponentFactory.Instance.creatBitmap("asset.core.tip.restTime");
         this._fightPropConsumeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._boxTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._limitGradeTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.LimitGradeTxt");
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
            else if(data is ShopItemInfo)
            {
               _tipData = data as ShopItemInfo;
               this.showTip(_tipData.TemplateInfo);
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
         this._isArmed = false;
         this.createItemName();
         this.createQualityItem();
         this.createCategoryItem();
         this.createMainProperty();
         this.seperateLine();
         this.createNecklaceItem();
         this.createProperties();
         this.seperateLine();
         this.createEnchantProperties();
         this.seperateLine();
         this.createLatentEnergy();
         this.seperateLine();
         this.createOperationItem();
         this.seperateLine();
         this.createDescript();
         this.createBindType();
         this.createRemainTime();
         this.createGoldRemainTime();
         this.createFightPropConsume();
         this.createBoxTimeItem();
         this.createShopItemLimitGrade(_tipData as ShopItemInfo);
         this.addChildren();
         this.createStrenthLevel();
      }
      
      private function createEnchantProperties() : void
      {
         var info:InventoryItemInfo = this._info as InventoryItemInfo;
         if(!info || info.MagicLevel <= 0)
         {
            return;
         }
         var enchantInfo:EnchantInfo = EnchantManager.instance.getEnchantInfoByLevel(info.MagicLevel);
         if(!enchantInfo)
         {
            return;
         }
         this._enchantLevelTxt.text = LanguageMgr.GetTranslation("enchant.levelTxt",int(enchantInfo.Lv / 10) + 1,enchantInfo.Lv % 10);
         this._enchantAttackTxt.text = LanguageMgr.GetTranslation("enchant.addMagicAttackTxt") + enchantInfo.MagicAttack;
         this._enchantDefenceTxt.text = LanguageMgr.GetTranslation("enchant.addMagicDenfenceTxt") + enchantInfo.MagicDefence;
         this._enchantLevelTxt.textColor = ITEM_ENCHANT_COLOR;
         this._enchantAttackTxt.textColor = ITEM_ENCHANT_COLOR;
         this._enchantDefenceTxt.textColor = ITEM_ENCHANT_COLOR;
         var tf:TextFormat = ComponentFactory.Instance.model.getSet("ddt.store.view.exalt.LaterEquipmentViewTextTF");
         this._enchantAttackTxt.setTextFormat(tf,3,this._enchantAttackTxt.text.length);
         this._enchantDefenceTxt.setTextFormat(tf,3,this._enchantDefenceTxt.text.length);
         var _loc4_:* = this._displayIdx++;
         this._displayList[_loc4_] = this._enchantLevelTxt;
         var _loc5_:* = this._displayIdx++;
         this._displayList[_loc5_] = this._enchantAttackTxt;
         var _loc6_:* = this._displayIdx++;
         this._displayList[_loc6_] = this._enchantDefenceTxt;
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
            _width = this._tipbackgound.width = this._maxWidth + 8;
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
         if(Boolean(this._remainTimeBg.parent))
         {
            this._goldRemainTimeTxt.x = this._remainTimeTxt.x + 2;
            this._goldRemainTimeTxt.y = this._remainTimeTxt.y + 22;
            this._remainTimeBg.parent.addChildAt(this._goldRemainTimeTxt,1);
         }
         this._rightArrows.x = 5 - this._rightArrows.width;
         this._rightArrows.y = (this.height - this._rightArrows.height) / 2;
      }
      
      private function createLatentEnergy() : void
      {
         var tmpItemInfo:InventoryItemInfo = null;
         var valueArray:Array = null;
         var i:int = 0;
         var tipItem:LatentEnergyTipItem = null;
         if(this._info is InventoryItemInfo)
         {
            tmpItemInfo = this._info as InventoryItemInfo;
            if(tmpItemInfo.isHasLatentEnergy)
            {
               valueArray = tmpItemInfo.latentEnergyCurList;
               for(i = 0; i < 4; i++)
               {
                  tipItem = new LatentEnergyTipItem();
                  tipItem.setView(i,valueArray[i]);
                  var _loc5_:* = this._displayIdx++;
                  this._displayList[_loc5_] = tipItem;
               }
            }
         }
      }
      
      private function createItemName() : void
      {
         var format:TextFormat = null;
         this._nameTxt.text = String(this._info.Name);
         var tempInfo:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(tempInfo) && tempInfo.StrengthenLevel > 0)
         {
            if(tempInfo.isGold)
            {
               if(tempInfo.StrengthenLevel > PathManager.solveStrengthMax())
               {
                  this._nameTxt.text += LanguageMgr.GetTranslation("store.view.exalt.goodTips",tempInfo.StrengthenLevel - 12);
               }
               else
               {
                  this._nameTxt.text += LanguageMgr.GetTranslation("wishBead.StrengthenLevel");
               }
            }
            else if(tempInfo.StrengthenLevel <= PathManager.solveStrengthMax())
            {
               this._nameTxt.text += "(+" + (this._info as InventoryItemInfo).StrengthenLevel + ")";
            }
            else if(tempInfo.StrengthenLevel > PathManager.solveStrengthMax())
            {
               this._nameTxt.text += LanguageMgr.GetTranslation("store.view.exalt.goodTips",tempInfo.StrengthenLevel - 12);
            }
         }
         var len:int = int(this._nameTxt.text.indexOf("+"));
         if(len > 0)
         {
            format = ComponentFactory.Instance.model.getSet("core.goodTip.ItemNameNumTxtFormat");
            this._nameTxt.setTextFormat(format,len,len + 1);
         }
         this._nameTxt.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
         var _loc4_:* = this._displayIdx++;
         this._displayList[_loc4_] = this._nameTxt;
      }
      
      private function createQualityItem() : void
      {
         var fft:FilterFrameText = this._qualityItem.foreItems[0] as FilterFrameText;
         fft.text = QualityType.QUALITY_STRING[this._info.Quality];
         fft.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
         var _loc2_:* = this._displayIdx++;
         this._displayList[_loc2_] = this._qualityItem;
         this._fusionLevelImage.x = fft.x + fft.width;
      }
      
      private function createCategoryItem() : void
      {
         var fft:FilterFrameText = this._typeItem.foreItems[0] as FilterFrameText;
         var arr:Array = EquipType.PARTNAME;
         fft.text = !EquipType.PARTNAME[this._info.CategoryID] ? "" : EquipType.PARTNAME[this._info.CategoryID];
         var _loc3_:* = this._displayIdx++;
         this._displayList[_loc3_] = this._typeItem;
      }
      
      private function createMainProperty() : void
      {
         var space:String = null;
         var tf:TextFormat = null;
         var beginIndex:int = 0;
         var endIndex:int = 0;
         var strengthenedStr:String = "";
         var strengthenLevel:int = 0;
         var fft:FilterFrameText = this._mainPropertyItem.foreItems[0] as FilterFrameText;
         var type:ScaleFrameImage = this._mainPropertyItem.backItem as ScaleFrameImage;
         var ivenInfo:InventoryItemInfo = this._info as InventoryItemInfo;
         if(EquipType.isArm(this._info))
         {
            if(Boolean(ivenInfo) && ivenInfo.StrengthenLevel > 0)
            {
               strengthenLevel = ivenInfo.isGold ? ivenInfo.StrengthenLevel + 1 : ivenInfo.StrengthenLevel;
               strengthenedStr = "(+" + StaticFormula.getHertAddition(int(ivenInfo.Property7),strengthenLevel) + ")";
            }
            type.setFrame(1);
            fft.text = " " + this._info.Property7.toString() + strengthenedStr;
            FilterFrameText(this._armAngleItem.foreItems[0]).text = "   " + this._info.Property5 + "°~" + this._info.Property6 + "°";
            var _loc10_:* = this._displayIdx++;
            this._displayList[_loc10_] = this._mainPropertyItem;
            var _loc11_:* = this._displayIdx++;
            this._displayList[_loc11_] = this._armAngleItem;
         }
         else if(EquipType.isHead(this._info) || EquipType.isCloth(this._info))
         {
            if(Boolean(ivenInfo) && ivenInfo.StrengthenLevel > 0)
            {
               strengthenLevel = ivenInfo.isGold ? ivenInfo.StrengthenLevel + 1 : ivenInfo.StrengthenLevel;
               strengthenedStr = "(+" + StaticFormula.getDefenseAddition(int(ivenInfo.Property7),strengthenLevel) + ")";
            }
            type.setFrame(2);
            fft.text = "   " + this._info.Property7.toString() + strengthenedStr;
            _loc10_ = this._displayIdx++;
            this._displayList[_loc10_] = this._mainPropertyItem;
            if(Boolean(ivenInfo) && ivenInfo.isGold)
            {
               FilterFrameText(this._otherHp.foreItems[0]).text = ivenInfo.Boold.toString();
               _loc11_ = this._displayIdx++;
               this._displayList[_loc11_] = this._otherHp;
            }
         }
         else if(StaticFormula.isDeputyWeapon(this._info) || this._info.CategoryID == EquipType.SPECIAL)
         {
            space = " ";
            if(this._info.Property3 == "32")
            {
               if(Boolean(ivenInfo) && ivenInfo.StrengthenLevel > 0)
               {
                  strengthenLevel = ivenInfo.isGold ? ivenInfo.StrengthenLevel + 1 : ivenInfo.StrengthenLevel;
                  strengthenedStr = "(+" + StaticFormula.getRecoverHPAddition(int(ivenInfo.Property7),strengthenLevel) + ")";
               }
               type.setFrame(3);
               space = "   ";
            }
            else
            {
               if(Boolean(ivenInfo) && ivenInfo.StrengthenLevel > 0)
               {
                  strengthenLevel = ivenInfo.isGold ? ivenInfo.StrengthenLevel + 1 : ivenInfo.StrengthenLevel;
                  strengthenedStr = "(+" + StaticFormula.getDefenseAddition(int(ivenInfo.Property7),strengthenLevel) + ")";
               }
               type.setFrame(4);
               space = "            ";
            }
            fft.text = space + this._info.Property7.toString() + strengthenedStr;
            _loc10_ = this._displayIdx++;
            this._displayList[_loc10_] = this._mainPropertyItem;
         }
         if(Boolean(fft) && fft.text != "")
         {
            tf = ComponentFactory.Instance.model.getSet("ddt.store.view.exalt.LaterEquipmentViewTextTF");
            beginIndex = int(fft.text.indexOf("("));
            endIndex = fft.text.indexOf(")") + 1;
            fft.setTextFormat(tf,beginIndex,endIndex);
         }
      }
      
      private function createNecklaceItem() : void
      {
         if(this._info.CategoryID == 14)
         {
            this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.advance") + this._info.Property1 + "%";
            this._necklaceItem.textColor = GoodTip.ITEM_NECKLACE_COLOR;
            var _loc1_:* = this._displayIdx++;
            this._displayList[_loc1_] = this._necklaceItem;
         }
         else if(this._info.CategoryID == EquipType.HEALSTONE)
         {
            this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.reply") + this._info.Property2;
            this._necklaceItem.textColor = GoodTip.ITEM_NECKLACE_COLOR;
            _loc1_ = this._displayIdx++;
            this._displayList[_loc1_] = this._necklaceItem;
         }
      }
      
      private function setPurpleHtmlTxt(title:String, value:int, add:String) : String
      {
         return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.setPurpleHtmlTxt",title,value,add);
      }
      
      private function createProperties() : void
      {
         var t:InventoryItemInfo = null;
         var tat:String = "";
         var tde:String = "";
         var tag:String = "";
         var tlu:String = "";
         if(this._info is InventoryItemInfo)
         {
            t = this._info as InventoryItemInfo;
            if(t.AttackCompose > 0)
            {
               tat = "(+" + String(t.AttackCompose) + ")";
            }
            if(t.DefendCompose > 0)
            {
               tde = "(+" + String(t.DefendCompose) + ")";
            }
            if(t.AgilityCompose > 0)
            {
               tag = "(+" + String(t.AgilityCompose) + ")";
            }
            if(t.LuckCompose > 0)
            {
               tlu = "(+" + String(t.LuckCompose) + ")";
            }
         }
         if(this._info.Attack != 0)
         {
            this._attackTxt.htmlText = this.setPurpleHtmlTxt(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.fire") + ":",this._info.Attack,tat);
            var _loc6_:* = this._displayIdx++;
            this._displayList[_loc6_] = this._attackTxt;
         }
         if(this._info.Defence != 0)
         {
            this._defenseTxt.htmlText = this.setPurpleHtmlTxt(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recovery") + ":",this._info.Defence,tde);
            _loc6_ = this._displayIdx++;
            this._displayList[_loc6_] = this._defenseTxt;
         }
         if(this._info.Agility != 0)
         {
            this._agilityTxt.htmlText = this.setPurpleHtmlTxt(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.agility") + ":",this._info.Agility,tag);
            _loc6_ = this._displayIdx++;
            this._displayList[_loc6_] = this._agilityTxt;
         }
         if(this._info.Luck != 0)
         {
            this._luckTxt.htmlText = this.setPurpleHtmlTxt(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.lucky") + ":",this._info.Luck,tlu);
            _loc6_ = this._displayIdx++;
            this._displayList[_loc6_] = this._luckTxt;
         }
      }
      
      private function createHoleItem() : void
      {
         var holeList:Array = null;
         var strHoleList:Array = null;
         var inventoryInfo:InventoryItemInfo = null;
         var i:int = 0;
         var str:String = null;
         var tmpArr:Array = null;
         var simpleItem:FilterFrameText = null;
         var requireStrengthenLevel:int = 0;
         if(!StringHelper.isNullOrEmpty(this._info.Hole))
         {
            holeList = [];
            strHoleList = this._info.Hole.split("|");
            inventoryInfo = this._info as InventoryItemInfo;
            if(strHoleList.length > 0 && String(strHoleList[0]) != "" && inventoryInfo != null)
            {
               i = 0;
               while(i < strHoleList.length)
               {
                  str = String(strHoleList[i]);
                  tmpArr = str.split(",");
                  if(i < 4)
                  {
                     if(int(tmpArr[0]) > 0 && int(tmpArr[0]) - inventoryInfo.StrengthenLevel <= 3 || this.getHole(inventoryInfo,i + 1) >= 0)
                     {
                        requireStrengthenLevel = int(tmpArr[0]);
                        simpleItem = this.createSingleHole(inventoryInfo,i,requireStrengthenLevel,tmpArr[1]);
                        var _loc9_:* = this._displayIdx++;
                        this._displayList[_loc9_] = simpleItem;
                     }
                  }
                  else if(inventoryInfo["Hole" + (i + 1) + "Level"] >= 1 || inventoryInfo["Hole" + (i + 1)] > 0)
                  {
                     simpleItem = this.createSingleHole(inventoryInfo,i,int.MAX_VALUE,tmpArr[1]);
                     _loc9_ = this._displayIdx++;
                     this._displayList[_loc9_] = simpleItem;
                  }
                  i++;
               }
            }
         }
      }
      
      private function createSingleHole(inventoryInfo:InventoryItemInfo, index:int, strengthLevel:int, holeType:int) : FilterFrameText
      {
         var goodsTemplateInfos:ItemTemplateInfo = null;
         var holeLv:int = 0;
         var item:FilterFrameText = this._holes[index];
         var holeState:int = this.getHole(inventoryInfo,index + 1);
         if(inventoryInfo.StrengthenLevel >= strengthLevel)
         {
            if(holeState <= 0)
            {
               item.text = this.getHoleType(holeType) + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeenable");
               item.textColor = GoodTip.ITEM_HOLES_COLOR;
            }
            else
            {
               goodsTemplateInfos = ItemManager.Instance.getTemplateById(holeState);
               if(Boolean(goodsTemplateInfos))
               {
                  item.text = goodsTemplateInfos.Data;
                  item.textColor = GoodTip.ITEM_HOLE_RESERVE_COLOR;
               }
            }
         }
         else if(index >= 4)
         {
            holeLv = int(inventoryInfo["Hole" + (index + 1) + "Level"]);
            if(holeState > 0)
            {
               goodsTemplateInfos = ItemManager.Instance.getTemplateById(holeState);
               item.text = goodsTemplateInfos.Data + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",inventoryInfo["Hole" + (index + 1) + "Level"]);
               if(Math.floor(goodsTemplateInfos.Level + 1 >> 1) <= holeLv)
               {
                  item.textColor = GoodTip.ITEM_HOLE_RESERVE_COLOR;
               }
               else
               {
                  item.textColor = GoodTip.ITEM_HOLE_GREY_COLOR;
               }
            }
            else
            {
               item.text = this.getHoleType(holeType) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",inventoryInfo["Hole" + (index + 1) + "Level"]));
               item.textColor = GoodTip.ITEM_HOLES_COLOR;
            }
         }
         else if(holeState <= 0)
         {
            item.text = this.getHoleType(holeType) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),strengthLevel.toString());
            item.textColor = GoodTip.ITEM_HOLE_GREY_COLOR;
         }
         else
         {
            goodsTemplateInfos = ItemManager.Instance.getTemplateById(holeState);
            if(Boolean(goodsTemplateInfos))
            {
               item.text = goodsTemplateInfos.Data + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),strengthLevel.toString());
               item.textColor = GoodTip.ITEM_HOLE_GREY_COLOR;
            }
         }
         return item;
      }
      
      public function getHole(inventoryInfo:InventoryItemInfo, index:int) : int
      {
         return int(inventoryInfo["Hole" + index.toString()]);
      }
      
      private function getHoleType(type:int) : String
      {
         switch(type)
         {
            case 1:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.trianglehole");
            case 2:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recthole");
            case 3:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.ciclehole");
            default:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.unknowhole");
         }
      }
      
      private function createOperationItem() : void
      {
         var tc:uint = 0;
         if(this._info.NeedLevel > 1)
         {
            if(PlayerManager.Instance.Self.Grade >= this._info.NeedLevel)
            {
               tc = GoodTip.ITEM_NEED_LEVEL_COLOR;
            }
            else
            {
               tc = GoodTip.ITEM_NEED_LEVEL_FAILED_COLOR;
            }
            this._needLevelTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.need") + ":" + String(this._info.NeedLevel);
            this._needLevelTxt.textColor = tc;
            var _loc3_:* = this._displayIdx++;
            this._displayList[_loc3_] = this._needLevelTxt;
         }
         if(this._info.NeedSex == 1)
         {
            this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.man");
            this._needSexTxt.textColor = PlayerManager.Instance.Self.Sex ? GoodTip.ITEM_NEED_SEX_COLOR : GoodTip.ITEM_NEED_SEX_FAILED_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._needSexTxt;
         }
         else if(this._info.NeedSex == 2)
         {
            this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.woman");
            this._needSexTxt.textColor = PlayerManager.Instance.Self.Sex ? GoodTip.ITEM_NEED_SEX_FAILED_COLOR : GoodTip.ITEM_NEED_SEX_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._needSexTxt;
         }
         var tipSmith:String = "";
         if(this._info.CanStrengthen && this._info.CanCompose)
         {
            tipSmith = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.may");
            if(EquipType.isRongLing(this._info))
            {
               tipSmith += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = tipSmith;
            this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CanCompose)
         {
            tipSmith = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.compose");
            if(EquipType.isRongLing(this._info))
            {
               tipSmith += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = tipSmith;
            this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CanStrengthen)
         {
            tipSmith = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.strong");
            if(EquipType.isRongLing(this._info))
            {
               tipSmith += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = tipSmith;
            this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(EquipType.isRongLing(this._info))
         {
            tipSmith += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.canmelting");
            this._upgradeType.text = tipSmith;
            this._upgradeType.textColor = GoodTip.ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
      }
      
      private function createDescript() : void
      {
         if(this._info.Description == "")
         {
            return;
         }
         this._descriptionTxt.text = this._info.Description;
         this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
         var _loc1_:* = this._displayIdx++;
         this._displayList[_loc1_] = this._descriptionTxt;
      }
      
      private function createShopItemLimitGrade(itemInfo:ShopItemInfo) : void
      {
         if(Boolean(itemInfo) && itemInfo.LimitGrade > PlayerManager.Instance.Self.Grade)
         {
            this._limitGradeTxt.text = LanguageMgr.GetTranslation("ddt.shop.LimitGradeBuy",itemInfo.LimitGrade);
            var _loc2_:* = this._displayIdx++;
            this._displayList[_loc2_] = this._limitGradeTxt;
         }
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
         var latentEnergyRemainStr:String = null;
         var tmpStr:String = null;
         var tmpTxtColor:uint = 0;
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
                  var _loc10_:* = this._displayIdx++;
                  this._displayList[_loc10_] = this._remainTimeTxt;
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
                  _loc10_ = this._displayIdx++;
                  this._displayList[_loc10_] = this._remainTimeTxt;
               }
            }
            if(remain == int.MAX_VALUE)
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
               this._remainTimeTxt.textColor = GoodTip.ITEM_ETERNAL_COLOR;
               _loc10_ = this._displayIdx++;
               this._displayList[_loc10_] = this._remainTimeTxt;
            }
            else if(remain > 0)
            {
               if(remain >= 1)
               {
                  tempReman = Math.ceil(remain);
                  this._remainTimeTxt.text = (tempInfo.IsUsed ? str + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + tempReman + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  _loc10_ = this._displayIdx++;
                  this._displayList[_loc10_] = this._remainTimeTxt;
               }
               else
               {
                  tempReman = Math.floor(remain * 24);
                  tempReman = tempReman < 1 ? 1 : tempReman;
                  this._remainTimeTxt.text = (tempInfo.IsUsed ? str + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + tempReman + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
                  _loc10_ = this._displayIdx++;
                  this._displayList[_loc10_] = this._remainTimeTxt;
               }
               addChild(this._remainTimeBg);
            }
            else if(!isNaN(remain))
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
               this._remainTimeTxt.textColor = GoodTip.ITEM_PAST_DUE_COLOR;
               _loc10_ = this._displayIdx++;
               this._displayList[_loc10_] = this._remainTimeTxt;
            }
            if(tempInfo.isHasLatentEnergy)
            {
               latentEnergyRemainStr = TimeManager.Instance.getMaxRemainDateStr(tempInfo.latentEnergyEndTime,2);
               tmpStr = this._remainTimeTxt.text;
               tmpStr += LanguageMgr.GetTranslation("ddt.latentEnergy.tipRemainDateTxt",latentEnergyRemainStr);
               tmpTxtColor = this._remainTimeTxt.textColor;
               this._remainTimeTxt.text = tmpStr;
               this._remainTimeTxt.textColor = tmpTxtColor;
            }
         }
      }
      
      private function createGoldRemainTime() : void
      {
         var goldTempReman:Number = NaN;
         var tempInfo:InventoryItemInfo = null;
         var goldRemain:Number = NaN;
         var goldValidDate:Number = NaN;
         var goldBeginTime:String = null;
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.parent.removeChild(this._remainTimeBg);
         }
         if(this._info is InventoryItemInfo)
         {
            tempInfo = this._info as InventoryItemInfo;
            goldRemain = tempInfo.getGoldRemainDate();
            goldValidDate = tempInfo.goldValidDate;
            goldBeginTime = tempInfo.goldBeginTime;
            if((this._info as InventoryItemInfo).isGold)
            {
               if(goldRemain >= 1)
               {
                  goldTempReman = Math.ceil(goldRemain);
                  this._goldRemainTimeTxt.text = LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt1") + goldTempReman + LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt2");
               }
               else
               {
                  goldTempReman = Math.floor(goldRemain * 24);
                  goldTempReman = goldTempReman < 1 ? 1 : goldTempReman;
                  this._goldRemainTimeTxt.text = LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt1") + goldTempReman + LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt3");
               }
               addChild(this._remainTimeBg);
               this._goldRemainTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
               var _loc6_:* = this._displayIdx++;
               this._displayList[_loc6_] = this._goldRemainTimeTxt;
            }
         }
      }
      
      private function createFightPropConsume() : void
      {
         if(this._info.CategoryID == EquipType.FRIGHTPROP)
         {
            this._fightPropConsumeTxt.text = " " + LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.consume") + this._info.Property4;
            this._fightPropConsumeTxt.textColor = GoodTip.ITEM_FIGHT_PROP_CONSUME_COLOR;
            var _loc1_:* = this._displayIdx++;
            this._displayList[_loc1_] = this._fightPropConsumeTxt;
         }
      }
      
      private function createBoxTimeItem() : void
      {
         var bg:Date = null;
         var leftTime:int = 0;
         var h:int = 0;
         var m:int = 0;
         if(EquipType.isTimeBox(this._info))
         {
            bg = DateUtils.getDateByStr((this._info as InventoryItemInfo).BeginDate);
            leftTime = int(this._info.Property3) * 60 - (TimeManager.Instance.Now().getTime() - bg.getTime()) / 1000;
            if(leftTime > 0)
            {
               h = leftTime / 3600;
               m = leftTime % 3600 / 60;
               m = m > 0 ? m : 1;
               this._boxTimeTxt.text = LanguageMgr.GetTranslation("ddt.userGuild.boxTip",h,m);
               this._boxTimeTxt.textColor = GoodTip.ITEM_NORMAL_COLOR;
               var _loc5_:* = this._displayIdx++;
               this._displayList[_loc5_] = this._boxTimeTxt;
            }
         }
      }
      
      private function createStrenthLevel() : void
      {
         var tempInfo:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(tempInfo) && tempInfo.StrengthenLevel > 0)
         {
            if(tempInfo.isGold)
            {
               this._strengthenLevelImage.setFrame(16);
            }
            else
            {
               this._strengthenLevelImage.setFrame(tempInfo.StrengthenLevel);
            }
            addChild(this._strengthenLevelImage);
            if(Boolean(this._boundImage.parent))
            {
               this._boundImage.x = this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth / 2 - this._boundImage.width / 2 - 8;
               this._boundImage.y = this._lines[0].y + 4;
            }
            this._maxWidth = Math.max(this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth,this._maxWidth);
            _width = this._tipbackgound.width = this._maxWidth + 8;
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
         if(Boolean(this._mainPropertyItem))
         {
            ObjectUtils.disposeObject(this._mainPropertyItem);
         }
         this._mainPropertyItem = null;
         if(Boolean(this._armAngleItem))
         {
            ObjectUtils.disposeObject(this._armAngleItem);
         }
         this._armAngleItem = null;
         if(Boolean(this._otherHp))
         {
            ObjectUtils.disposeObject(this._otherHp);
         }
         this._otherHp = null;
         if(Boolean(this._necklaceItem))
         {
            ObjectUtils.disposeObject(this._necklaceItem);
         }
         this._necklaceItem = null;
         if(Boolean(this._attackTxt))
         {
            ObjectUtils.disposeObject(this._attackTxt);
         }
         this._attackTxt = null;
         if(Boolean(this._defenseTxt))
         {
            ObjectUtils.disposeObject(this._defenseTxt);
         }
         this._defenseTxt = null;
         if(Boolean(this._agilityTxt))
         {
            ObjectUtils.disposeObject(this._agilityTxt);
         }
         this._agilityTxt = null;
         if(Boolean(this._luckTxt))
         {
            ObjectUtils.disposeObject(this._luckTxt);
         }
         this._luckTxt = null;
         ObjectUtils.disposeObject(this._enchantLevelTxt);
         this._enchantLevelTxt = null;
         ObjectUtils.disposeObject(this._enchantAttackTxt);
         this._enchantAttackTxt = null;
         ObjectUtils.disposeObject(this._enchantDefenceTxt);
         this._enchantDefenceTxt = null;
         if(Boolean(this._needLevelTxt))
         {
            ObjectUtils.disposeObject(this._needLevelTxt);
         }
         this._needLevelTxt = null;
         if(Boolean(this._needSexTxt))
         {
            ObjectUtils.disposeObject(this._needSexTxt);
         }
         this._needSexTxt = null;
         if(Boolean(this._upgradeType))
         {
            ObjectUtils.disposeObject(this._upgradeType);
         }
         this._upgradeType = null;
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
         if(Boolean(this._goldRemainTimeTxt))
         {
            ObjectUtils.disposeObject(this._goldRemainTimeTxt);
         }
         this._goldRemainTimeTxt = null;
         if(Boolean(this._fightPropConsumeTxt))
         {
            ObjectUtils.disposeObject(this._fightPropConsumeTxt);
         }
         this._fightPropConsumeTxt = null;
         if(Boolean(this._boxTimeTxt))
         {
            ObjectUtils.disposeObject(this._boxTimeTxt);
         }
         this._boxTimeTxt = null;
         if(Boolean(this._limitGradeTxt))
         {
            ObjectUtils.disposeObject(this._limitGradeTxt);
         }
         this._limitGradeTxt = null;
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

