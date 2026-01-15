package ddt.view.tips
{
   import GodSyah.SyahManager;
   import GodSyah.SyahTip;
   import bagAndInfo.info.PlayerInfoViewControl;
   import beadSystem.model.BeadInfo;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import ddt.data.AddPublicInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.AddPublicTipManager;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.utils.StaticFormula;
   import ddt.view.SimpleItem;
   import enchant.EnchantManager;
   import enchant.data.EnchantInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import gemstone.GemstoneManager;
   import gemstone.items.GemstonTipItem;
   import itemActivityGift.ItemActivityGiftManager;
   import itemActivityGift.data.ItemEveryDayRecordData;
   import latentEnergy.LatentEnergyTipItem;
   import road7th.utils.DateUtils;
   import road7th.utils.StringHelper;
   import store.data.StoreEquipExperience;
   
   public class GoodTip extends BaseTip implements Disposeable, ITip
   {
      
      public static const BOUND:uint = 1;
      
      public static const UNBOUND:uint = 2;
      
      public static const ITEM_NORMAL_COLOR:uint = 16777215;
      
      public static const ITEM_NECKLACE_COLOR:uint = 16750899;
      
      public static const ITEM_PROPERTIES_COLOR:uint = 16750899;
      
      public static const ITEM_HOLES_COLOR:uint = 16777215;
      
      public static const ITEM_HOLE_RESERVE_COLOR:uint = 16776960;
      
      public static const ITEM_HOLE_GREY_COLOR:uint = 6710886;
      
      public static const ITEM_FIGHT_PROP_CONSUME_COLOR:uint = 14520832;
      
      public static const ITEM_NEED_LEVEL_COLOR:uint = 13421772;
      
      public static const ITEM_NEED_LEVEL_FAILED_COLOR:uint = 16711680;
      
      public static const ITEM_UPGRADE_TYPE_COLOR:uint = 10092339;
      
      public static const ITEM_NEED_SEX_COLOR:uint = 10092339;
      
      public static const ITEM_NEED_SEX_FAILED_COLOR:uint = 16711680;
      
      public static const ITEM_ETERNAL_COLOR:uint = 16776960;
      
      public static const ITEM_PAST_DUE_COLOR:uint = 16711680;
      
      public static const ITEM_MAGIC_STONE_COLOR:uint = 2467327;
      
      public static const ITEM_ENCHANT_COLOR:uint = 13971455;
      
      public static const ITEM_ENCHANT_ENABLE_COLOR:uint = 11842740;
      
      public static const enchantLevelTxtArr:Array = LanguageMgr.GetTranslation("enchant.levelTxt").split(",");
      
      private static const PET_SPECIAL_FOOD:int = 334100;
      
      private var _strengthenLevelImage:MovieImage;
      
      private var _fusionLevelImage:MovieImage;
      
      private var _boundImage:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _qualityItem:SimpleItem;
      
      private var _typeItem:SimpleItem;
      
      private var _expItem:SimpleItem;
      
      private var _mainPropertyItem:SimpleItem;
      
      private var _armAngleItem:SimpleItem;
      
      private var _otherHp:SimpleItem;
      
      private var _necklaceItem:FilterFrameText;
      
      private var _attackTxt:FilterFrameText;
      
      private var _defenseTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _magicAttackTxt:FilterFrameText;
      
      private var _magicDefenceTxt:FilterFrameText;
      
      private var _mgStoneName:FilterFrameText;
      
      private var _attackTxt2:FilterFrameText;
      
      private var _defenseTxt2:FilterFrameText;
      
      private var _agilityTxt2:FilterFrameText;
      
      private var _luckTxt2:FilterFrameText;
      
      private var _magicAttackTxt2:FilterFrameText;
      
      private var _magicDefenceTxt2:FilterFrameText;
      
      private var _magicStoneIcon:Bitmap;
      
      private var _enchantLevelTxt:FilterFrameText;
      
      private var _enchantAttackTxt:FilterFrameText;
      
      private var _enchantDefenceTxt:FilterFrameText;
      
      private var _gp:FilterFrameText;
      
      private var _maxGP:FilterFrameText;
      
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
      
      private var _minWidth:int = 240;
      
      private var _isArmed:Boolean;
      
      private var _displayList:Vector.<DisplayObject>;
      
      private var _displayIdx:int;
      
      private var _lines:Vector.<Image>;
      
      private var _lineIdx:int;
      
      private var _isReAdd:Boolean;
      
      private var _remainTimeBg:Bitmap;
      
      private var _levelTxt:FilterFrameText;
      
      protected var _laterEquipmentGoodView:LaterEquipmentGoodView;
      
      protected var syahTip:SyahTip;
      
      private var _thingsFromTxt:FilterFrameText;
      
      private var _openCountTxt:FilterFrameText;
      
      private var _addPublicTip:FilterFrameText;
      
      private var _exp:int;
      
      private var _UpExp:int;
      
      private var _figSpirit1:FilterFrameText;
      
      private var _figSpirit2:FilterFrameText;
      
      private var _figSpirit3:FilterFrameText;
      
      public function GoodTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._lines = new Vector.<Image>();
         this._displayList = new Vector.<DisplayObject>();
         _tipbackgound = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._strengthenLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameMc");
         this._fusionLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTrinketLevelMc");
         this._boundImage = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.BoundImage");
         this._bindImageOriginalPos = new Point(this._boundImage.x,this._boundImage.y);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         this._thingsFromTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipThingsFromTxt");
         this._qualityItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.QualityItem");
         this._typeItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.TypeItem");
         this._expItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.EXPItem");
         this._mainPropertyItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.MainPropertyItem");
         this._armAngleItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.armAngleItem");
         this._otherHp = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.otherHp");
         this._necklaceItem = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._defenseTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._magicAttackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._magicDefenceTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._mgStoneName = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._attackTxt2 = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._defenseTxt2 = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._agilityTxt2 = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._luckTxt2 = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._magicAttackTxt2 = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._magicDefenceTxt2 = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._enchantLevelTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._enchantAttackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._enchantDefenceTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.LimitGradeTxt");
         this._gp = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._maxGP = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._gp = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._maxGP = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._holes = new Vector.<FilterFrameText>();
         for(var i:int = 0; i < 6; i++)
         {
            this._holes.push(ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt"));
         }
         this._needLevelTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._needSexTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._upgradeType = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._openCountTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsOpenCountTxt");
         this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.DescriptionTxt");
         this._bindTypeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._remainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemDateTxt");
         this._goldRemainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipGoldItemDateTxt");
         this._remainTimeBg = ComponentFactory.Instance.creatBitmap("asset.core.tip.restTime");
         this._fightPropConsumeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._boxTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._limitGradeTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.LimitGradeTxt");
         this._laterEquipmentGoodView = new LaterEquipmentGoodView();
         this._laterEquipmentGoodView.visible = false;
         this._addPublicTip = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipTypeTxt2");
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
               if(EquipType.isBead(_tipData.itemInfo.Property1) || EquipType.isMagicStone(_tipData.itemInfo.CategoryID))
               {
                  this._exp = _tipData.exp;
                  this._UpExp = _tipData.upExp;
               }
               this.showTip(_tipData.itemInfo,_tipData.typeIsSecond);
               if(PathManager.suitEnable)
               {
                  this.showSuitTip(_tipData.itemInfo);
               }
               else
               {
                  this._laterEquipmentGoodView.visible = false;
               }
               if(SyahManager.Instance.isOpen)
               {
                  this.showSyahTip();
               }
            }
            else if(data is ShopItemInfo)
            {
               _tipData = data as ShopItemInfo;
               this.showTip(_tipData.TemplateInfo);
               this._laterEquipmentGoodView.visible = false;
            }
            else
            {
               this._laterEquipmentGoodView.visible = false;
            }
            visible = true;
         }
         else
         {
            _tipData = null;
            visible = false;
            this._laterEquipmentGoodView.visible = false;
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
      
      public function showSuitTip(info:ItemTemplateInfo) : void
      {
         var point:Point = null;
         info = _tipData.itemInfo;
         if(info is ItemTemplateInfo)
         {
            if(info.SuitId != 0)
            {
               this._laterEquipmentGoodView.visible = true;
               point = localToGlobal(new Point(_tipbackgound.x,_tipbackgound.y));
               if(point.x + _tipbackgound.width + this._laterEquipmentGoodView.width < StageReferance.stageWidth)
               {
                  this._laterEquipmentGoodView.x = _width + 5;
               }
               else
               {
                  this._laterEquipmentGoodView.x = -250;
               }
               this.laterEquipment(info);
            }
            else
            {
               this._laterEquipmentGoodView.visible = false;
            }
         }
         else
         {
            this._laterEquipmentGoodView.visible = false;
         }
         this._laterEquipmentGoodView.y = _tipbackgound.height - this._laterEquipmentGoodView.height;
      }
      
      private function showSyahTip() : void
      {
         var point:Point = null;
         if(Boolean(SyahManager.Instance.getSyahModeByInfo(_tipData.itemInfo)))
         {
            this.syahTip = new SyahTip();
            this.syahTip.setTipInfo(_tipData.itemInfo);
            if(this._laterEquipmentGoodView.visible)
            {
               this.syahTip.setBGWidth(this._laterEquipmentGoodView.getBGWidth());
               this.syahTip.x = this._laterEquipmentGoodView.x;
               this.syahTip.y = this._laterEquipmentGoodView.y - this.syahTip.displayHeight;
               if(this.syahTip.y + this.y < 5)
               {
                  this.syahTip.y = 0;
                  this._laterEquipmentGoodView.y = this.syahTip.displayHeight;
               }
            }
            else
            {
               this.syahTip.setBGWidth(228);
               point = localToGlobal(new Point(_tipbackgound.x,_tipbackgound.y));
               if(point.x + _tipbackgound.width + this.syahTip.displayWidth < StageReferance.stageWidth)
               {
                  this.syahTip.x = _width + 5;
               }
               else
               {
                  this.syahTip.x = -250;
               }
               this.syahTip.y = _tipbackgound.height - this.syahTip.displayHeight;
            }
            addChild(this.syahTip);
         }
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
         this.careteEXP();
         this.createMainProperty();
         this.seperateLine();
         this.createNecklaceItem();
         this.createProperties();
         this.seperateLine();
         this.createEnchantProperties();
         this.seperateLine();
         this.createMagicStone();
         this.seperateLine();
         this.creatGemstone();
         this.seperateLine();
         this.creatLevel();
         this.seperateLine();
         this.createLatentEnergy();
         this.seperateLine();
         this.createOperationItem();
         this.createOpenCountTxt();
         this.seperateLine();
         this.createDescript();
         this.createBindType();
         this.createRemainTime();
         this.createGoldRemainTime();
         this.createFightPropConsume();
         this.createThingsFrame();
         this.createBoxTimeItem();
         this.addChildren();
         this.createStrenthLevel();
         if(PathManager.add_public_tip)
         {
            this.createAddPublicTip();
         }
      }
      
      private function createAddPublicTip() : void
      {
         if(AddPublicTipManager.Instance.type == 0)
         {
            return;
         }
         var tempInfo:AddPublicInfo = AddPublicTipManager.Instance.getAddPublicTipInfoByID(this._info.TemplateID,AddPublicTipManager.Instance.type);
         if(tempInfo == null)
         {
            return;
         }
         if(tempInfo.rate - 1 < 0)
         {
            return;
         }
         var qualityArr:Array = ["极低","低","普通","高","极高"];
         this._addPublicTip.text = "概率：" + qualityArr[tempInfo.rate - 1];
         PositionUtils.setPos(this._addPublicTip,"core.addPublicTipPos");
         addChild(this._addPublicTip);
      }
      
      private function laterEquipment(Info:ItemTemplateInfo) : void
      {
         if(!this._laterEquipmentGoodView)
         {
            this._laterEquipmentGoodView = new LaterEquipmentGoodView();
         }
         this._laterEquipmentGoodView.tipData = Info;
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
            if(Boolean(this._displayList[i] as DisplayObject))
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
         if(len > 0)
         {
            _width = _tipbackgound.width = this._maxWidth + 28;
            _height = _tipbackgound.height = item.y + item.height + 8;
         }
         if(Boolean(_tipbackgound))
         {
            addChildAt(_tipbackgound,0);
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.x = this._remainTimeTxt.x + 2;
            this._remainTimeBg.y = this._remainTimeTxt.y + 2;
            this._remainTimeBg.parent.addChildAt(this._remainTimeBg,1);
         }
         addChild(this._laterEquipmentGoodView);
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
				  this._displayList[this._displayIdx++] = tipItem;
				  //var _loc5_:* = this._displayIdx++;
                  //this._displayList[_loc5_] = tipItem;
               }
            }
         }
      }
      
      private function creatLevel() : void
      {
         if(this._info.CategoryID == 50 || this._info.CategoryID == 51 || this._info.CategoryID == 52)
         {
            this._levelTxt.text = LanguageMgr.GetTranslation("ddt.petEquipLevel",this._info.Property2);
			this._displayList[this._displayIdx++] = this._levelTxt;
            //var _loc1_:* = this._displayIdx++;
            //this._displayList[_loc1_] = this._levelTxt;
         }
      }
      
      private function creatGemstone() : void
      {
         var t:InventoryItemInfo = null;
         var i:int = 0;
         var stoenTxt1:FilterFrameText = null;
         var tipItem:GemstonTipItem = null;
         var level:int = 0;
         var stoneName:String = null;
         var stoneAct1:int = 0;
         var obj:Object = null;
         if(this._info is InventoryItemInfo)
         {
            t = this._info as InventoryItemInfo;
            if(Boolean(t.gemstoneList))
            {
               if(t.gemstoneList.length == 0)
               {
                  return;
               }
               for(i = 0; i < 3; i++)
               {
                  if(t.gemstoneList[i].level > 0)
                  {
                     stoenTxt1 = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxtString");
                     tipItem = new GemstonTipItem();
                     
					 this._displayList[this._displayIdx++] = tipItem;
					 //var _loc9_:* = this._displayIdx++;
                     //this._displayList[_loc9_] = tipItem;
                     level = t.gemstoneList[i].level;
                     if(t.gemstoneList[i].fightSpiritId == 100001)
                     {
                        stoneName = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstoneAtc",level,GemstoneManager.Instance.redInfoList[level].attack);
                        stoneAct1 = GemstoneManager.Instance.redInfoList[level].attack;
                     }
                     else if(t.gemstoneList[i].fightSpiritId == 100002)
                     {
                        stoneName = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstoneDef",level,GemstoneManager.Instance.bluInfoList[level].defence);
                        stoneAct1 = GemstoneManager.Instance.bluInfoList[level].defence;
                     }
                     else if(t.gemstoneList[i].fightSpiritId == 100003)
                     {
                        stoneName = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstoneAgi",level,GemstoneManager.Instance.greInfoList[level].agility);
                        stoneAct1 = GemstoneManager.Instance.greInfoList[level].agility;
                     }
                     else if(t.gemstoneList[i].fightSpiritId == 100004)
                     {
                        stoneName = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstoneLuk",level,GemstoneManager.Instance.yelInfoList[level].luck);
                        stoneAct1 = GemstoneManager.Instance.yelInfoList[level].luck;
                     }
                     else if(t.gemstoneList[i].fightSpiritId == 100005)
                     {
                        stoneName = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk",level,GemstoneManager.Instance.purpleInfoList[level].blood);
                        stoneAct1 = GemstoneManager.Instance.purpleInfoList[level].blood;
                     }
                     obj = new Object();
                     obj.id = t.gemstoneList[i].fightSpiritId;
                     obj.str = stoneName;
                     tipItem.setInfo(obj);
                  }
               }
            }
         }
      }
      
      private function createItemName() : void
      {
         var format:TextFormat = null;
         if(EquipType.isBead(int(this._info.Property1)) || EquipType.isMagicStone(this._info.CategoryID))
         {
            this._nameTxt.text = _tipData.beadName;
         }
         else
         {
            this._nameTxt.text = String(this._info.Name);
         }
         var tempInfo:InventoryItemInfo = this._info as InventoryItemInfo;
         if(tempInfo && tempInfo.StrengthenLevel > 0 && !EquipType.isMagicStone(tempInfo.CategoryID))
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
         if(Boolean(PlayerInfoViewControl.currentPlayer))
         {
            if(tempInfo && tempInfo.Place == 12 && tempInfo.UserID == PlayerInfoViewControl.currentPlayer.ID && PlayerInfoViewControl.currentPlayer.necklaceLevel > 0 && tempInfo.CategoryID == EquipType.NECKLACE)
            {
               this._nameTxt.text += LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.goodTip",PlayerInfoViewControl.currentPlayer.necklaceLevel);
            }
         }
         this._nameTxt.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
		 this._displayList[this._displayIdx++] = this._nameTxt;
         //var _loc4_:* = this._displayIdx++;
         //this._displayList[_loc4_] = this._nameTxt;
      }
      
      private function createQualityItem() : void
      {
         var fft:FilterFrameText = this._qualityItem.foreItems[0] as FilterFrameText;
         fft.text = QualityType.QUALITY_STRING[this._info.Quality];
         fft.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
         if(!EquipType.isBead(int(this._info.Property1)))
         {
			 this._displayList[this._displayIdx++] =this._qualityItem;
            //var _loc2_:* = this._displayIdx++;
            //this._displayList[_loc2_] = this._qualityItem;
         }
      }
      
      private function createCategoryItem() : void
      {
         var fft:FilterFrameText = this._typeItem.foreItems[0] as FilterFrameText;
         var arr:Array = EquipType.PARTNAME;
         if(this._info.CategoryID == EquipType.SPECIAL)
         {
            fft.text = LanguageMgr.GetTranslation("tank.data.EquipType.tempHelp");
         }
         else if(this._info.CategoryID == EquipType.EVERYDAYGIFTRECORD)
         {
            fft.text = LanguageMgr.GetTranslation("tank.data.EquipType.normal");
         }
         else if(this._info.CategoryID == EquipType.FUZHUDAOJU)
         {
            fft.text = LanguageMgr.GetTranslation("tank.data.EquipType.fuzhudaoju");
         }
         else if(this._info.Property1 == "31")
         {
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
         }
         else
         {
            fft.text = EquipType.PARTNAME[this._info.CategoryID] + "";
         }
         if(EquipType.isBead(int(this._info.Property1)))
         {
            fft.textColor = 65406;
         }
         if(this._info.TemplateID == 20150 || this._info.TemplateID == 201266)
         {
            fft.text = EquipType.PARTNAME[23];
         }
		 this._displayList[this._displayIdx++] = this._typeItem;
         //var _loc3_:* = this._displayIdx++;
         //this._displayList[_loc3_] = this._typeItem;
      }
      
      private function createThingsFrame() : void
      {
         if(_tipData == null)
         {
            return;
         }
         if(_tipData is ShopItemInfo)
         {
            return;
         }
         if(Boolean(_tipData.itemInfo))
         {
            if(Boolean(_tipData.itemInfo.ThingsFrom))
            {
               if(_tipData.itemInfo.ThingsFrom != "")
               {
                  this.seperateLine();
                  this._thingsFromTxt.text = _tipData.itemInfo.ThingsFrom;
				  this._displayList[this._displayIdx++] = this._thingsFromTxt;
				  //var _loc1_:* = this._displayIdx++;
                  //this._displayList[_loc1_] = this._thingsFromTxt;
               }
            }
         }
      }
      
      private function careteEXP() : void
      {
         var fft:FilterFrameText = this._expItem.foreItems[0] as FilterFrameText;
         if(EquipType.isBead(int(this._info.Property1)) || EquipType.isMagicStone(this._info.CategoryID))
         {
            fft.text = this._exp + "/" + this._UpExp;
			this._displayList[this._displayIdx++] = this._expItem;
			//var _loc2_:* = this._displayIdx++;
            //this._displayList[_loc2_] = this._expItem;
         }
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
            fft.text = "  " + this._info.Property7.toString() + strengthenedStr;
            FilterFrameText(this._armAngleItem.foreItems[0]).text = " " + this._info.Property5 + "°~" + this._info.Property6 + "°";
			this._displayList[this._displayIdx++] =this._mainPropertyItem;
			this._displayList[this._displayIdx++] =this._armAngleItem;
			//var _loc10_:* = this._displayIdx++;
            //this._displayList[_loc10_] = this._mainPropertyItem;
            //var _loc11_:* = this._displayIdx++;
            //this._displayList[_loc11_] = this._armAngleItem;
         }
         else if(EquipType.isHead(this._info) || EquipType.isCloth(this._info))
         {
            if(Boolean(ivenInfo) && ivenInfo.StrengthenLevel > 0)
            {
               strengthenLevel = ivenInfo.isGold ? ivenInfo.StrengthenLevel + 1 : ivenInfo.StrengthenLevel;
               strengthenedStr = "(+" + StaticFormula.getDefenseAddition(int(ivenInfo.Property7),strengthenLevel) + ")";
            }
            type.setFrame(2);
            fft.text = " " + this._info.Property7.toString() + strengthenedStr;
            //_loc10_ = this._displayIdx++;
            //this._displayList[_loc10_] = this._mainPropertyItem;
			this._displayList[this._displayIdx++] =this._mainPropertyItem;
			
            if(Boolean(ivenInfo) && ivenInfo.isGold)
            {
               FilterFrameText(this._otherHp.foreItems[0]).text = ivenInfo.Boold.toString();
			   this._displayList[this._displayIdx++] =this._otherHp;
			   //_loc11_ = this._displayIdx++;
               //this._displayList[_loc11_] = this._otherHp;
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
			this._displayList[this._displayIdx++] =this._mainPropertyItem;
			//_loc10_ = this._displayIdx++;
            //this._displayList[_loc10_] = this._mainPropertyItem;
         }
         if(Boolean(fft))
         {
            tf = ComponentFactory.Instance.model.getSet("ddt.store.view.exalt.LaterEquipmentViewTextTF");
            beginIndex = int(fft.text.indexOf("("));
            endIndex = fft.text.indexOf(")") + 1;
            if(beginIndex != -1 && endIndex != 0)
            {
               fft.setTextFormat(tf,beginIndex,endIndex);
            }
         }
      }
      
      private function createNecklaceItem() : void
      {
         var tempInfo:InventoryItemInfo = null;
         var necklaceStrengthPlus:int = 0;
         if(this._info.CategoryID == 14)
         {
            this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.advance") + this._info.Property1 + "%";
            tempInfo = this._info as InventoryItemInfo;
            if(tempInfo && tempInfo.Place == 12 && tempInfo.UserID == PlayerInfoViewControl.currentPlayer.ID && PlayerInfoViewControl.currentPlayer.necklaceLevel > 0)
            {
               necklaceStrengthPlus = StoreEquipExperience.getNecklaceStrengthPlus(PlayerInfoViewControl.currentPlayer.necklaceLevel);
               this._necklaceItem.text += LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.goodTipII",necklaceStrengthPlus);
            }
            this._necklaceItem.textColor = ITEM_NECKLACE_COLOR;
			this._displayList[this._displayIdx++] =this._necklaceItem;;
			//var _loc3_:* = this._displayIdx++;
            //this._displayList[_loc3_] = this._necklaceItem;
         }
         else if(this._info.CategoryID == EquipType.HEALSTONE)
         {
            this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.reply") + this._info.Property2;
            this._necklaceItem.textColor = ITEM_NECKLACE_COLOR;
			this._displayList[this._displayIdx++] =this._necklaceItem;
			//_loc3_ = this._displayIdx++;
            //this._displayList[_loc3_] = this._necklaceItem;
         }
      }
      
      private function createProperties() : void
      {
         var t:InventoryItemInfo = null;
         var mgStoneTxt:FilterFrameText = null;
         var tat:String = "";
         var tde:String = "";
         var tag:String = "";
         var tlu:String = "";
         if(this._info is InventoryItemInfo && !EquipType.isMagicStone(this._info.CategoryID))
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
            this._attackTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.fire") + ":" + String(this._info.Attack) + tat;
            this._attackTxt.textColor = ITEM_PROPERTIES_COLOR;
			this._displayList[this._displayIdx++] = this._attackTxt;
			//var _loc8_:* = this._displayIdx++;
            //this._displayList[_loc8_] = this._attackTxt;
         }
         if(this._info.Defence != 0)
         {
            this._defenseTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recovery") + ":" + String(this._info.Defence) + tde;
            this._defenseTxt.textColor = ITEM_PROPERTIES_COLOR;
			this._displayList[this._displayIdx++] = this._defenseTxt;
            //_loc8_ = this._displayIdx++;
            //this._displayList[_loc8_] = this._defenseTxt;
         }
         if(this._info.Agility != 0)
         {
            this._agilityTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.agility") + ":" + String(this._info.Agility) + tag;
            this._agilityTxt.textColor = ITEM_PROPERTIES_COLOR;
			this._displayList[this._displayIdx++] = this._agilityTxt;
            //_loc8_ = this._displayIdx++;
            //this._displayList[_loc8_] = this._agilityTxt;
         }
         if(this._info.Luck != 0)
         {
            this._luckTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.lucky") + ":" + String(this._info.Luck) + tlu;
            this._luckTxt.textColor = ITEM_PROPERTIES_COLOR;
			this._displayList[this._displayIdx++] = this._luckTxt;
            //_loc8_ = this._displayIdx++;
            //this._displayList[_loc8_] = this._luckTxt;
         }
         if(this._info.MagicAttack != 0)
         {
            this._magicAttackTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.magicAttack") + ":" + String(this._info.MagicAttack);
            this._magicAttackTxt.textColor = ITEM_PROPERTIES_COLOR;
			this._displayList[this._displayIdx++] = this._magicAttackTxt;
            //_loc8_ = this._displayIdx++;
            //this._displayList[_loc8_] = this._magicAttackTxt;
         }
         if(this._info.MagicDefence != 0)
         {
            this._magicDefenceTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.magicDefence") + ":" + String(this._info.MagicDefence);
            this._magicDefenceTxt.textColor = ITEM_PROPERTIES_COLOR;
			this._displayList[this._displayIdx++] = this._magicDefenceTxt;
            //_loc8_ = this._displayIdx++;
            //this._displayList[_loc8_] = this._magicDefenceTxt;
         }
         var item:InventoryItemInfo = this._info as InventoryItemInfo;
         if(!item && EquipType.isMagicStone(this._info.CategoryID))
         {
            mgStoneTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
            switch(int(this._info.Property3))
            {
               case 2:
                  mgStoneTxt.text = LanguageMgr.GetTranslation("magicStone.canGetTwoAbove");
				  this._displayList[this._displayIdx++] = mgStoneTxt;
                  //_loc8_ = this._displayIdx++;
                  //this._displayList[_loc8_] = mgStoneTxt;
                  break;
               case 3:
                  mgStoneTxt.text = LanguageMgr.GetTranslation("magicStone.canGetThreeAbove");
				  this._displayList[this._displayIdx++] = mgStoneTxt;
                  //var _loc9_:* = this._displayIdx++;
                  //this._displayList[_loc9_] = mgStoneTxt;
                  break;
               case 4:
                  mgStoneTxt.text = LanguageMgr.GetTranslation("magicStone.canGetFourAbove");
				  this._displayList[this._displayIdx++] = mgStoneTxt;
                  //var _loc10_:* = this._displayIdx++;
                  //this._displayList[_loc10_] = mgStoneTxt;
            }
            mgStoneTxt.textColor = ITEM_NORMAL_COLOR;
         }
         if(this._info.TemplateID == PET_SPECIAL_FOOD)
         {
            this._gp.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.gp") + ":" + InventoryItemInfo(this._info).DefendCompose;
            this._gp.textColor = ITEM_PROPERTIES_COLOR;
			this._displayList[this._displayIdx++] = this._gp;
			//_loc8_ = this._displayIdx++;
            //this._displayList[_loc8_] = this._gp;
            
			this._maxGP.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.maxGP") + ":" + InventoryItemInfo(this._info).AgilityCompose;
            this._maxGP.textColor = ITEM_PROPERTIES_COLOR;
			this._displayList[this._displayIdx++] = this._maxGP;
			//_loc9_ = this._displayIdx++;
            //this._displayList[_loc9_] = this._maxGP;
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
						this._displayList[this._displayIdx++] = simpleItem;
						//var _loc9_:* = this._displayIdx++;
                        //this._displayList[_loc9_] = simpleItem;
                     }
                  }
                  else if(inventoryInfo["Hole" + (i + 1) + "Level"] >= 1 || inventoryInfo["Hole" + (i + 1)] > 0)
                  {
                     simpleItem = this.createSingleHole(inventoryInfo,i,int.MAX_VALUE,tmpArr[1]);
					 this._displayList[this._displayIdx++] = simpleItem;
					 //_loc9_ = this._displayIdx++;
                     //this._displayList[_loc9_] = simpleItem;
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
               item.textColor = ITEM_HOLES_COLOR;
            }
            else
            {
               goodsTemplateInfos = ItemManager.Instance.getTemplateById(holeState);
               if(Boolean(goodsTemplateInfos))
               {
                  item.text = goodsTemplateInfos.Data;
                  item.textColor = ITEM_HOLE_RESERVE_COLOR;
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
                  item.textColor = ITEM_HOLE_RESERVE_COLOR;
               }
               else
               {
                  item.textColor = ITEM_HOLE_GREY_COLOR;
               }
            }
            else
            {
               item.text = this.getHoleType(holeType) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",inventoryInfo["Hole" + (index + 1) + "Level"]));
               item.textColor = ITEM_HOLES_COLOR;
            }
         }
         else if(holeState <= 0)
         {
            item.text = this.getHoleType(holeType) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),strengthLevel.toString());
            item.textColor = ITEM_HOLE_GREY_COLOR;
         }
         else
         {
            goodsTemplateInfos = ItemManager.Instance.getTemplateById(holeState);
            if(Boolean(goodsTemplateInfos))
            {
               item.text = goodsTemplateInfos.Data + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),strengthLevel.toString());
               item.textColor = ITEM_HOLE_GREY_COLOR;
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
         if(this._info.NeedLevel > 1 && this._info.TemplateID != 20150 && this._info.TemplateID != 201266)
         {
            if(PlayerManager.Instance.Self.Grade >= this._info.NeedLevel)
            {
               tc = ITEM_NEED_LEVEL_COLOR;
            }
            else
            {
               tc = ITEM_NEED_LEVEL_FAILED_COLOR;
            }
            this._needLevelTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.need") + ":" + String(this._info.NeedLevel);
            this._needLevelTxt.textColor = tc;
			this._displayList[this._displayIdx++] = this._needLevelTxt;
			//var _loc3_:* = this._displayIdx++;
            //this._displayList[_loc3_] = this._needLevelTxt;
         }
         if(this._info.NeedSex == 1)
         {
            this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.man");
            this._needSexTxt.textColor = PlayerManager.Instance.Self.Sex ? ITEM_NEED_SEX_COLOR : ITEM_NEED_SEX_FAILED_COLOR;
			this._displayList[this._displayIdx++] = this._needSexTxt;
			//_loc3_ = this._displayIdx++;
            //this._displayList[_loc3_] = this._needSexTxt;
         }
         else if(this._info.NeedSex == 2)
         {
            this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.woman");
            this._needSexTxt.textColor = PlayerManager.Instance.Self.Sex ? ITEM_NEED_SEX_FAILED_COLOR : ITEM_NEED_SEX_COLOR;
			this._displayList[this._displayIdx++] = this._needSexTxt;
            //_loc3_ = this._displayIdx++;
            //this._displayList[_loc3_] = this._needSexTxt;
         }
         var tipSmith:String = "";
         if(this._info.CanStrengthen && this._info.CanCompose && this._info.CategoryID != EquipType.TEMPWEAPON)
         {
            tipSmith = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.may");
            if(EquipType.isRongLing(this._info))
            {
               tipSmith += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = tipSmith;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
            
			this._displayList[this._displayIdx++] = this._upgradeType;
			//_loc3_ = this._displayIdx++;
            //this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CanCompose && !EquipType.isMagicStone(this._info.CategoryID) && this._info.CategoryID != EquipType.TEMPWEAPON)
         {
            tipSmith = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.compose");
            if(EquipType.isRongLing(this._info))
            {
               tipSmith += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = tipSmith;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
			this._displayList[this._displayIdx++] = this._upgradeType;
			//_loc3_ = this._displayIdx++;
            //this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CanStrengthen && this._info.CategoryID != EquipType.TEMPWEAPON)
         {
            tipSmith = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.strong");
            if(EquipType.isRongLing(this._info))
            {
               tipSmith += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = tipSmith;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
			this._displayList[this._displayIdx++] = this._upgradeType;
			//_loc3_ = this._displayIdx++;
            //this._displayList[_loc3_] = this._upgradeType;
         }
         else if(EquipType.isRongLing(this._info))
         {
            tipSmith += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.canmelting");
            this._upgradeType.text = tipSmith;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
			this._displayList[this._displayIdx++] = this._upgradeType;
			//_loc3_ = this._displayIdx++;
            //this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CategoryID == EquipType.TEMP_OFFHAND || this._info.CategoryID == EquipType.SPECIAL)
         {
            tipSmith += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.strong");
            this._upgradeType.text = "   ";
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
			this._displayList[this._displayIdx++] = this._upgradeType;
			//_loc3_ = this._displayIdx++;
            //this._displayList[_loc3_] = this._upgradeType;
         }
      }
      
      private function createOpenCountTxt() : void
      {
         var tempItemInfo:InventoryItemInfo = null;
         var itemEveryDayRecordData:ItemEveryDayRecordData = null;
         var tempIndex:int = 0;
         if(this._info.CategoryID == EquipType.EVERYDAYGIFTRECORD)
         {
            tempItemInfo = this._info as InventoryItemInfo;
            itemEveryDayRecordData = ItemActivityGiftManager.instance.model.itemEveryDayRecord[tempItemInfo.TemplateID + "," + tempItemInfo.ItemID];
            tempIndex = 0;
            if(Boolean(itemEveryDayRecordData))
            {
               tempIndex = itemEveryDayRecordData.OpenIndex;
            }
            else
            {
               tempIndex = 0;
            }
            this._openCountTxt.text = LanguageMgr.GetTranslation("goodTip.itemActivityGift.openCountTxt",tempIndex + 1);
            this._openCountTxt.textColor = ITEM_UPGRADE_TYPE_COLOR;
			this._displayList[this._displayIdx++] = this._openCountTxt;
			//var _loc4_:* = this._displayIdx++;
            //this._displayList[_loc4_] = this._openCountTxt;
         }
      }
      
      private function createDescript() : void
      {
         var tempItemInfo:InventoryItemInfo = null;
         var itemEveryDayRecordData:ItemEveryDayRecordData = null;
         var tempDesArr:Array = null;
         var infoItem:InventoryItemInfo = null;
         var beadInfo:BeadInfo = null;
         if(this._info.Description == "")
         {
            return;
         }
         if(this._info.CategoryID == 50 || this._info.CategoryID == 51 || this._info.CategoryID == 52)
         {
            return;
         }
         if(this._info.CategoryID == EquipType.EVERYDAYGIFTRECORD)
         {
            tempItemInfo = this._info as InventoryItemInfo;
            itemEveryDayRecordData = ItemActivityGiftManager.instance.model.itemEveryDayRecord[tempItemInfo.TemplateID + "," + tempItemInfo.ItemID];
            if(Boolean(itemEveryDayRecordData))
            {
               tempDesArr = this._info.Description.split("|");
               if(tempDesArr.length > 1)
               {
                  this._descriptionTxt.text = tempDesArr[itemEveryDayRecordData.OpenIndex] + "";
               }
               else
               {
                  this._descriptionTxt.text = tempDesArr[0] + "";
               }
            }
         }
         else if(this._info.Property1 != "31")
         {
            this._descriptionTxt.text = this._info.Description + "";
         }
         else
         {
            infoItem = this._info as InventoryItemInfo;
            beadInfo = BeadTemplateManager.Instance.GetBeadInfobyID(this._info.TemplateID);
            if(beadInfo == null)
            {
               return;
            }
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
         }
         this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
		 this._displayList[this._displayIdx++] = this._descriptionTxt;
		 //var _loc6_:* = this._displayIdx++;
         //this._displayList[_loc6_] = this._descriptionTxt;
      }
      
      private function ShowBound(info:InventoryItemInfo) : Boolean
      {
         return info.CategoryID != EquipType.SEED && info.CategoryID != EquipType.MANURE && info.CategoryID != EquipType.VEGETABLE;
      }
      
      private function createBindType() : void
      {
         var ttf:FilterFrameText = null;
         if(SyahManager.Instance.inView)
         {
            return;
         }
         var tempInfo:InventoryItemInfo = this._info as InventoryItemInfo;
         if(tempInfo && this.ShowBound(tempInfo) && tempInfo.isShowBind)
         {
            this._boundImage.setFrame(tempInfo.IsBinds ? int(BOUND) : int(UNBOUND));
            ttf = this._typeItem.foreItems[0] as FilterFrameText;
            this._bindImageOriginalPos.x = ttf.x + ttf.width;
            PositionUtils.setPos(this._boundImage,this._bindImageOriginalPos);
            this._minWidth = this._boundImage.x + this._boundImage.width > this._minWidth ? int(this._boundImage.x + this._boundImage.width) : this._minWidth;
            addChild(this._boundImage);
            if(!tempInfo.IsBinds)
            {
               if(tempInfo.BindType == 3)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.bangding");
                  this._bindTypeTxt.textColor = ITEM_NORMAL_COLOR;
				  this._displayList[this._displayIdx++] = this._bindTypeTxt;
				  //var _loc3_:* = this._displayIdx++;
                  //this._displayList[_loc3_] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 2)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.zhuangbei");
                  this._bindTypeTxt.textColor = ITEM_NORMAL_COLOR;
				  this._displayList[this._displayIdx++] = this._bindTypeTxt;
				  //_loc3_ = this._displayIdx++;
                  //this._displayList[_loc3_] = this._bindTypeTxt;
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
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
				  this._displayList[this._displayIdx++] = this._remainTimeTxt;
				  //var _loc10_:* = this._displayIdx++;
                  //this._displayList[_loc10_] = this._remainTimeTxt;
               }
               else
               {
                  hour = Math.floor(colorDate * 24);
                  if(hour < 1)
                  {
                     hour = 1;
                  }
                  this._remainTimeTxt.text = (tempInfo.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + hour + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
				  this._displayList[this._displayIdx++] = this._remainTimeTxt;
				  //_loc10_ = this._displayIdx++;
                  //this._displayList[_loc10_] = this._remainTimeTxt;
               }
            }
            if(remain == int.MAX_VALUE)
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
               this._remainTimeTxt.textColor = ITEM_ETERNAL_COLOR;
			   this._displayList[this._displayIdx++] = this._remainTimeTxt;
			   //_loc10_ = this._displayIdx++;
               //this._displayList[_loc10_] = this._remainTimeTxt;
            }
            else if(remain > 0)
            {
               if(remain >= 1)
               {
                  tempReman = Math.ceil(remain);
                  this._remainTimeTxt.text = (tempInfo.IsUsed ? str + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + tempReman + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
				  this._displayList[this._displayIdx++] = this._remainTimeTxt;
				  //_loc10_ = this._displayIdx++;
                  //this._displayList[_loc10_] = this._remainTimeTxt;
               }
               else if(remain * 24 >= 1)
               {
                  tempReman = Math.floor(remain * 24);
                  tempReman = tempReman < 1 ? 1 : tempReman;
                  this._remainTimeTxt.text = (tempInfo.IsUsed ? str + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + tempReman + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
                  
				  this._displayList[this._displayIdx++] = this._remainTimeTxt;
				  //_loc10_ = this._displayIdx++;
                  //this._displayList[_loc10_] = this._remainTimeTxt;
               }
               else if(remain * 24 * 60 >= 1)
               {
                  tempReman = Math.floor(remain * 24 * 60);
                  tempReman = tempReman < 1 ? 1 : tempReman;
                  this._remainTimeTxt.text = (tempInfo.IsUsed ? str + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + tempReman + LanguageMgr.GetTranslation("minute");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
				  
				  this._displayList[this._displayIdx++] = this._remainTimeTxt;
                  //_loc10_ = this._displayIdx++;
                  //this._displayList[_loc10_] = this._remainTimeTxt;
               }
               addChild(this._remainTimeBg);
            }
            else if(!isNaN(remain))
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
               this._remainTimeTxt.textColor = ITEM_PAST_DUE_COLOR;
               
			   this._displayList[this._displayIdx++] = this._remainTimeTxt;
			   //_loc10_ = this._displayIdx++;
               //this._displayList[_loc10_] = this._remainTimeTxt;
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
         if(SyahManager.Instance.inView)
         {
            return;
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
               this._goldRemainTimeTxt.textColor = ITEM_NORMAL_COLOR;
               
			   this._displayList[this._displayIdx++] = this._goldRemainTimeTxt;
			   //var _loc6_:* = this._displayIdx++;
               //this._displayList[_loc6_] = this._goldRemainTimeTxt;
            }
         }
      }
      
      private function createFightPropConsume() : void
      {
         if(this._info.CategoryID == EquipType.FRIGHTPROP)
         {
            this._fightPropConsumeTxt.text = " " + LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.consume") + this._info.Property4;
            this._fightPropConsumeTxt.textColor = ITEM_FIGHT_PROP_CONSUME_COLOR;
            
			this._displayList[this._displayIdx++] = this._fightPropConsumeTxt;
			//var _loc1_:* = this._displayIdx++;
            //this._displayList[_loc1_] = this._fightPropConsumeTxt;
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
               this._boxTimeTxt.textColor = ITEM_NORMAL_COLOR;
               
			   this._displayList[this._displayIdx++] = this._boxTimeTxt;
			   //var _loc5_:* = this._displayIdx++;
               //this._displayList[_loc5_] = this._boxTimeTxt;
            }
         }
      }
      
      private function createStrenthLevel() : void
      {
         var tempInfo:InventoryItemInfo = this._info as InventoryItemInfo;
         if(tempInfo && tempInfo.StrengthenLevel > 0 && !EquipType.isMagicStone(this._info.CategoryID))
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
               this._boundImage.x = this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth / 2 - this._boundImage.width / 2;
               this._boundImage.y = this._lines[0].y + 4;
            }
            this._maxWidth = Math.max(this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth,this._maxWidth);
            _width = _tipbackgound.width = this._maxWidth + 8;
         }
      }
      
      private function createMagicStone() : void
      {
         var container:Sprite = null;
         var bd:BitmapData = null;
         var bitmap:Bitmap = null;
         var info:InventoryItemInfo = this._info as InventoryItemInfo;
         if(!info || !info.magicStoneAttr)
         {
            return;
         }
         var tempMgStone:InventoryItemInfo = new InventoryItemInfo();
         tempMgStone.TemplateID = info.magicStoneAttr.templateId;
         ItemManager.fill(tempMgStone);
         tempMgStone.Level = info.magicStoneAttr.level;
         tempMgStone.Attack = info.magicStoneAttr.attack;
         tempMgStone.Defence = info.magicStoneAttr.defence;
         tempMgStone.Agility = info.magicStoneAttr.agility;
         tempMgStone.Luck = info.magicStoneAttr.luck;
         tempMgStone.MagicAttack = info.magicStoneAttr.magicAttack;
         tempMgStone.MagicDefence = info.magicStoneAttr.magicDefence;
         this._mgStoneName.text = tempMgStone.Name + "Lv." + tempMgStone.Level;
         this._mgStoneName.textColor = ITEM_MAGIC_STONE_COLOR;
         //var _loc6_:* = this._displayIdx++;
         //this._displayList[_loc6_] = this._mgStoneName;
		 this._displayList[this._displayIdx++] = this._mgStoneName;
		 switch(tempMgStone.Quality)
         {
            case 1:
               this._magicStoneIcon = ComponentFactory.Instance.creat("magicStone.smallIcon.white");
               break;
            case 2:
               this._magicStoneIcon = ComponentFactory.Instance.creat("magicStone.smallIcon.green");
               break;
            case 3:
               this._magicStoneIcon = ComponentFactory.Instance.creat("magicStone.smallIcon.blue");
               break;
            case 4:
               this._magicStoneIcon = ComponentFactory.Instance.creat("magicStone.smallIcon.purple");
               break;
            case 5:
               this._magicStoneIcon = ComponentFactory.Instance.creat("magicStone.smallIcon.yellow");
               break;
            case 6:
               this._magicStoneIcon = ComponentFactory.Instance.creat("magicStone.smallIcon.red");
         }
         if(tempMgStone.Attack != 0)
         {
            container = new Sprite();
            bd = this._magicStoneIcon.bitmapData.clone();
            bitmap = new Bitmap(bd);
            container.addChild(bitmap);
            this._attackTxt2.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.fire") + "+" + String(tempMgStone.Attack);
            this._attackTxt2.textColor = ITEM_MAGIC_STONE_COLOR;
            this._attackTxt2.x = 20;
            this._attackTxt2.y = 3;
            container.addChild(this._attackTxt2);
            
			this._displayList[this._displayIdx++] = container;
			//var _loc7_:* = this._displayIdx++;
            //this._displayList[_loc7_] = container;
         }
         if(tempMgStone.Defence != 0)
         {
            container = new Sprite();
            bd = this._magicStoneIcon.bitmapData.clone();
            bitmap = new Bitmap(bd);
            container.addChild(bitmap);
            this._defenseTxt2.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recovery") + "+" + String(tempMgStone.Defence);
            this._defenseTxt2.textColor = ITEM_MAGIC_STONE_COLOR;
            this._defenseTxt2.x = 20;
            this._defenseTxt2.y = 3;
            container.addChild(this._defenseTxt2);
			this._displayList[this._displayIdx++] = container;
			//_loc7_ = this._displayIdx++;
            //this._displayList[_loc7_] = container;
         }
         if(tempMgStone.Agility != 0)
         {
            container = new Sprite();
            bd = this._magicStoneIcon.bitmapData.clone();
            bitmap = new Bitmap(bd);
            container.addChild(bitmap);
            this._agilityTxt2.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.agility") + "+" + String(tempMgStone.Agility);
            this._agilityTxt2.textColor = ITEM_MAGIC_STONE_COLOR;
            this._agilityTxt2.x = 20;
            this._agilityTxt2.y = 3;
            container.addChild(this._agilityTxt2);
			this._displayList[this._displayIdx++] = container;
			//_loc7_ = this._displayIdx++;
            //this._displayList[_loc7_] = container;
         }
         if(tempMgStone.Luck != 0)
         {
            container = new Sprite();
            bd = this._magicStoneIcon.bitmapData.clone();
            bitmap = new Bitmap(bd);
            container.addChild(bitmap);
            this._luckTxt2.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.lucky") + "+" + String(tempMgStone.Luck);
            this._luckTxt2.textColor = ITEM_MAGIC_STONE_COLOR;
            this._luckTxt2.x = 20;
            this._luckTxt2.y = 3;
            container.addChild(this._luckTxt2);
			this._displayList[this._displayIdx++] = container;
			//_loc7_ = this._displayIdx++;
            //this._displayList[_loc7_] = container;
         }
         if(tempMgStone.MagicAttack != 0)
         {
            container = new Sprite();
            bd = this._magicStoneIcon.bitmapData.clone();
            bitmap = new Bitmap(bd);
            container.addChild(bitmap);
            this._magicAttackTxt2.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.magicAttack") + "+" + String(tempMgStone.MagicAttack);
            this._magicAttackTxt2.textColor = ITEM_MAGIC_STONE_COLOR;
            this._magicAttackTxt2.x = 20;
            this._magicAttackTxt2.y = 3;
            container.addChild(this._magicAttackTxt2);
			this._displayList[this._displayIdx++] = container;
			//_loc7_ = this._displayIdx++;
            //this._displayList[_loc7_] = container;
         }
         if(tempMgStone.MagicDefence != 0)
         {
            container = new Sprite();
            bd = this._magicStoneIcon.bitmapData.clone();
            bitmap = new Bitmap(bd);
            container.addChild(bitmap);
            this._magicDefenceTxt2.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.magicDefence") + "+" + String(tempMgStone.MagicDefence);
            this._magicDefenceTxt2.textColor = ITEM_MAGIC_STONE_COLOR;
            this._magicDefenceTxt2.x = 20;
            this._magicDefenceTxt2.y = 3;
            container.addChild(this._magicDefenceTxt2);
			this._displayList[this._displayIdx++] = container;
			//_loc7_ = this._displayIdx++;
            //this._displayList[_loc7_] = container;
         }
      }
      
      private function createEnchantProperties() : void
      {
         var info:InventoryItemInfo = this._info as InventoryItemInfo;
         if(!info || info.MagicLevel <= 0 || !info.isCanEnchant())
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
         this._enchantLevelTxt.textColor = this._enchantAttackTxt.textColor = this._enchantDefenceTxt.textColor = int(info.Property1) < 5 ? ITEM_ENCHANT_ENABLE_COLOR : ITEM_ENCHANT_COLOR;
         
		 this._displayList[this._displayIdx++] = _enchantLevelTxt;
		 this._displayList[this._displayIdx++] = _enchantAttackTxt;
		 this._displayList[this._displayIdx++] = _enchantDefenceTxt;
		 //var _loc3_:* = this._displayIdx++;
         //this._displayList[_loc3_] = this._enchantLevelTxt;
         //var _loc4_:* = this._displayIdx++;
         //this._displayList[_loc4_] = this._enchantAttackTxt;
         //var _loc5_:* = this._displayIdx++;
         //this._displayList[_loc5_] = this._enchantDefenceTxt;
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
		 this._displayList[this._displayIdx++] = this._lines[this._lineIdx - 1];
         //var _loc2_:* = this._displayIdx++;
         //this._displayList[_loc2_] = this._lines[this._lineIdx - 1];
      }
   }
}

