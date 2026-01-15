package magicHouse.magicCollection
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.tips.CallPropTxtTipInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import magicHouse.MagicHouseManager;
   import newTitle.NewTitleManager;
   
   public class MagicHouseCollectionItemView extends Sprite implements Disposeable
   {
      
      private var _self:SelfInfo;
      
      private var _item1:MagicHouseItemCell;
      
      private var _item2:MagicHouseItemCell;
      
      private var _item3:MagicHouseItemCell;
      
      private var _type:int;
      
      private var _addAttributeTxt:FilterFrameText;
      
      private var _attribute1:FilterFrameText;
      
      private var _attribute2:FilterFrameText;
      
      private var _attributeValue1:FilterFrameText;
      
      private var _attributeValue2:FilterFrameText;
      
      private var _nextLevelPromote:FilterFrameText;
      
      private var _nextAttribute1:FilterFrameText;
      
      private var _nextAttribute2:FilterFrameText;
      
      private var _nextValue1:FilterFrameText;
      
      private var _nextValue2:FilterFrameText;
      
      private var _itemLvl:FilterFrameText;
      
      private var _upGradeCell:BagCell;
      
      private var _progress:MagicHouseUpgradeProgress;
      
      private var _collectionType:Bitmap;
      
      private var _collectionTypeCon:Component;
      
      private var _upGradeBtn:SimpleBitmapButton;
      
      private var _potionCountSelecterFrame:MagicHouseMagicPotionSelectFrame;
      
      private var _lastStrengthTime:int = 0;
      
      public function MagicHouseCollectionItemView(type:int)
      {
         super();
         this._type = type;
         this._self = PlayerManager.Instance.Self;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var titleID:int = 0;
         var titleInfo:CallPropTxtTipInfo = null;
         this._item1 = new MagicHouseItemCell();
         addChild(this._item1);
         PositionUtils.setPos(this._item1,"magicHouse.collection.itemcell1Pos");
         this._item2 = new MagicHouseItemCell();
         addChild(this._item2);
         PositionUtils.setPos(this._item2,"magicHouse.collection.itemcell2Pos");
         this._item3 = new MagicHouseItemCell();
         addChild(this._item3);
         PositionUtils.setPos(this._item3,"magicHouse.collection.itemcell3Pos");
         this._addAttributeTxt = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText1");
         addChild(this._addAttributeTxt);
         this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addAttribute" + this._type);
         PositionUtils.setPos(this._addAttributeTxt,"magicHouse.collection.itemAddAttributeTxtPos");
         this._attribute1 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText2");
         addChild(this._attribute1);
         PositionUtils.setPos(this._attribute1,"magicHouse.collection.itemAttributeTxtPos1");
         this._attribute2 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText2");
         addChild(this._attribute2);
         PositionUtils.setPos(this._attribute2,"magicHouse.collection.itemAttributeTxtPos2");
         this._attributeValue1 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText3");
         addChild(this._attributeValue1);
         PositionUtils.setPos(this._attributeValue1,"magicHouse.collection.itemAttributeValueTxtPos1");
         this._attributeValue2 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText3");
         addChild(this._attributeValue2);
         PositionUtils.setPos(this._attributeValue2,"magicHouse.collection.itemAttributeValueTxtPos2");
         this._nextLevelPromote = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText1");
         addChild(this._nextLevelPromote);
         PositionUtils.setPos(this._nextLevelPromote,"magicHouse.collection.itemNextLevelTxtPos");
         this._nextLevelPromote.text = LanguageMgr.GetTranslation("magichouse.collectionItem.nextLevelPromote");
         this._nextAttribute1 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText2");
         addChild(this._nextAttribute1);
         PositionUtils.setPos(this._nextAttribute1,"magicHouse.collection.itemNextLevelAttributeTxtPos1");
         this._nextAttribute2 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText2");
         addChild(this._nextAttribute2);
         PositionUtils.setPos(this._nextAttribute2,"magicHouse.collection.itemNextLevelAttributeTxtPos2");
         this._nextValue1 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText3");
         addChild(this._nextValue1);
         PositionUtils.setPos(this._nextValue1,"magicHouse.collection.itemNextLevelValueTxtPos1");
         this._nextValue2 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText3");
         addChild(this._nextValue2);
         PositionUtils.setPos(this._nextValue2,"magicHouse.collection.itemNextLevelValueTxtPos2");
         this._itemLvl = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.itemLvlText");
         addChild(this._itemLvl);
         var info:ItemTemplateInfo = ItemManager.Instance.getTemplateById(EquipType.MAGICHOUSE_MAGICPOTION);
         this._upGradeCell = new BagCell(0,info,true,ComponentFactory.Instance.creatBitmap("magichouse.collectionItem.potionCellBg"));
         addChild(this._upGradeCell);
         this._upGradeCell.height = 52;
         this._upGradeCell.width = 52;
         PositionUtils.setPos(this._upGradeCell,"magicHouse.collection.itemUpGradeCellPos");
         this._progress = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItem.upgrade.progress");
         this._progress.tipStyle = "ddt.view.tips.OneLineTip";
         this._progress.tipDirctions = "3,7,6";
         this._progress.tipGapV = 4;
         addChild(this._progress);
         this._collectionType = ComponentFactory.Instance.creatBitmap("magichouse.collection.item" + this._type);
         this._collectionTypeCon = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.titleTipContent");
         if(this._type == 1)
         {
            titleID = MagicHouseManager.instance.TITLE_JUNIOR_ID;
         }
         else if(this._type == 2)
         {
            titleID = MagicHouseManager.instance.TITLE_MID_ID;
         }
         else
         {
            titleID = MagicHouseManager.instance.TITLE_SENIOR_ID;
         }
         if(Boolean(NewTitleManager.instance.titleInfo) && Boolean(NewTitleManager.instance.titleInfo[titleID]))
         {
            titleInfo = new CallPropTxtTipInfo();
            titleInfo.Attack = NewTitleManager.instance.titleInfo[titleID].Att;
            titleInfo.Defend = NewTitleManager.instance.titleInfo[titleID].Def;
            titleInfo.Agility = NewTitleManager.instance.titleInfo[titleID].Agi;
            titleInfo.Lucky = NewTitleManager.instance.titleInfo[titleID].Luck;
            this._collectionTypeCon.tipData = titleInfo;
         }
         this._collectionTypeCon.addChild(this._collectionType);
         addChild(this._collectionTypeCon);
         this._upGradeBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.UpGradeBtn");
         addChild(this._upGradeBtn);
         this._setData();
         this._initProgress();
      }
      
      private function _initProgress() : void
      {
         if(this._type == 1)
         {
            this._progress.initProgress(MagicHouseManager.instance.magicJuniorLv,MagicHouseManager.instance.magicJuniorExp);
         }
         else if(this._type == 2)
         {
            this._progress.initProgress(MagicHouseManager.instance.magicMidLv,MagicHouseManager.instance.magicMidExp);
         }
         else
         {
            this._progress.initProgress(MagicHouseManager.instance.magicSeniorLv,MagicHouseManager.instance.magicSeniorExp);
         }
      }
      
      private function _updateProgress() : void
      {
         if(this._type == 1)
         {
            this._progress.setProgress(MagicHouseManager.instance.magicJuniorLv,MagicHouseManager.instance.magicJuniorExp);
         }
         else if(this._type == 2)
         {
            this._progress.setProgress(MagicHouseManager.instance.magicMidLv,MagicHouseManager.instance.magicMidExp);
         }
         else
         {
            this._progress.setProgress(MagicHouseManager.instance.magicSeniorLv,MagicHouseManager.instance.magicSeniorExp);
         }
      }
      
      private function _setCell() : void
      {
         if(this._type == 1)
         {
            this._item1.setTypeAndPos(this._type,0);
            if(MagicHouseManager.instance.activityWeapons[0] != 0)
            {
               this._item1.setOpened(true);
            }
            this._item1.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseManager.instance.juniorWeaponList[0].split(",")[0]);
            if(MagicHouseManager.instance.activityWeapons[0] == 0)
            {
               this._item1.setFilter();
            }
            this._item2.setTypeAndPos(this._type,1);
            if(MagicHouseManager.instance.activityWeapons[1] != 0)
            {
               this._item2.setOpened(true);
            }
            this._item2.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseManager.instance.juniorWeaponList[1].split(",")[0]);
            if(MagicHouseManager.instance.activityWeapons[1] == 0)
            {
               this._item2.setFilter();
            }
            this._item3.setTypeAndPos(this._type,2);
            if(MagicHouseManager.instance.activityWeapons[2] != 0)
            {
               this._item3.setOpened(true);
            }
            this._item3.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseManager.instance.juniorWeaponList[2].split(",")[0]);
            if(MagicHouseManager.instance.activityWeapons[2] == 0)
            {
               this._item3.setFilter();
            }
         }
         else if(this._type == 2)
         {
            this._item1.setTypeAndPos(this._type,0);
            if(MagicHouseManager.instance.activityWeapons[3] != 0)
            {
               this._item1.setOpened(true);
            }
            this._item1.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseManager.instance.midWeaponList[0].split(",")[0]);
            if(MagicHouseManager.instance.activityWeapons[3] == 0)
            {
               this._item1.setFilter();
            }
            this._item2.setTypeAndPos(this._type,1);
            if(MagicHouseManager.instance.activityWeapons[4] != 0)
            {
               this._item2.setOpened(true);
            }
            this._item2.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseManager.instance.midWeaponList[1].split(",")[0]);
            if(MagicHouseManager.instance.activityWeapons[4] == 0)
            {
               this._item2.setFilter();
            }
            this._item3.setTypeAndPos(this._type,2);
            if(MagicHouseManager.instance.activityWeapons[5] != 0)
            {
               this._item3.setOpened(true);
            }
            this._item3.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseManager.instance.midWeaponList[2].split(",")[0]);
            if(MagicHouseManager.instance.activityWeapons[5] == 0)
            {
               this._item3.setFilter();
            }
         }
         else
         {
            this._item1.setTypeAndPos(this._type,0);
            if(MagicHouseManager.instance.activityWeapons[6] != 0)
            {
               this._item1.setOpened(true);
            }
            this._item1.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseManager.instance.seniorWeapinList[0].split(",")[0]);
            if(MagicHouseManager.instance.activityWeapons[6] == 0)
            {
               this._item1.setFilter();
            }
            this._item2.setTypeAndPos(this._type,1);
            if(MagicHouseManager.instance.activityWeapons[7] != 0)
            {
               this._item2.setOpened(true);
            }
            this._item2.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseManager.instance.seniorWeapinList[1].split(",")[0]);
            if(MagicHouseManager.instance.activityWeapons[7] == 0)
            {
               this._item2.setFilter();
            }
            this._item3.setTypeAndPos(this._type,2);
            if(MagicHouseManager.instance.activityWeapons[8] != 0)
            {
               this._item3.setOpened(true);
            }
            this._item3.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseManager.instance.seniorWeapinList[2].split(",")[0]);
            if(MagicHouseManager.instance.activityWeapons[8] == 0)
            {
               this._item3.setFilter();
            }
         }
      }
      
      private function _setData() : void
      {
         var itemLvl:int = 0;
         var j:int = 0;
         var m:int = 0;
         var s:int = 0;
         this._setCell();
         this.upDatafitCount();
         var weapons:Array = MagicHouseManager.instance.activityWeapons;
         var juniorAttribute:Array = MagicHouseManager.instance.juniorAddAttribute;
         var juniorLv:int = MagicHouseManager.instance.magicJuniorLv;
         var minAttribute:Array = MagicHouseManager.instance.midAddAttribute;
         var midLv:int = MagicHouseManager.instance.magicMidLv;
         var seniorAttribute:Array = MagicHouseManager.instance.seniorAddAttribute;
         var seniorLv:int = MagicHouseManager.instance.magicSeniorLv;
         var attribute1:int = 0;
         var attribute2:int = 0;
         if(this._type == 1)
         {
            this._attribute1.text = this._nextAttribute1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addMagicDamage");
            this._attribute2.text = this._nextAttribute2.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addMagicDefense");
            itemLvl = MagicHouseManager.instance.magicJuniorLv;
            this._itemLvl.text = "Lv." + itemLvl;
            if(weapons[0] != 0 && weapons[1] != 0 && weapons[2] != 0)
            {
               this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addAttribute" + this._type);
               for(j = 0; j <= juniorLv; j++)
               {
                  attribute1 += int(juniorAttribute[j].split(",")[0]);
                  attribute2 += int(juniorAttribute[j].split(",")[1]);
               }
               if(juniorLv == juniorAttribute.length - 1)
               {
                  this._nextValue1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.maxLevel");
                  PositionUtils.setPos(this._nextValue1,"magicHouse.attributeTopTxtPos");
                  this._nextLevelPromote.visible = false;
                  this._nextAttribute1.visible = false;
                  this._nextAttribute2.visible = false;
                  this._nextValue2.visible = false;
               }
               else
               {
                  this._nextValue1.text = juniorAttribute[juniorLv + 1].split(",")[0] + "%";
                  this._nextValue2.text = juniorAttribute[juniorLv + 1].split(",")[1] + "%";
               }
            }
            else
            {
               this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.afterActivate");
               attribute1 = int(juniorAttribute[0].split(",")[0]);
               attribute2 = int(juniorAttribute[0].split(",")[1]);
               this._nextValue1.text = juniorAttribute[1].split(",")[0] + "%";
               this._nextValue2.text = juniorAttribute[1].split(",")[1] + "%";
            }
         }
         else if(this._type == 2)
         {
            this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addAttribute" + this._type);
            this._attribute1.text = this._nextAttribute1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addMagicDefense");
            this._attribute2.text = this._nextAttribute2.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addCritDamage");
            itemLvl = MagicHouseManager.instance.magicMidLv;
            this._itemLvl.text = "Lv." + itemLvl;
            if(weapons[3] != 0 && weapons[4] != 0 && weapons[5] != 0)
            {
               for(m = 0; m <= midLv; m++)
               {
                  attribute1 += int(minAttribute[m].split(",")[1]);
                  attribute2 += int(minAttribute[m].split(",")[2]);
               }
               if(midLv == minAttribute.length - 1)
               {
                  this._nextValue1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.maxLevel");
                  PositionUtils.setPos(this._nextValue1,"magicHouse.attributeTopTxtPos");
                  this._nextLevelPromote.visible = false;
                  this._nextAttribute1.visible = false;
                  this._nextAttribute2.visible = false;
                  this._nextValue2.visible = false;
               }
               else
               {
                  this._nextValue1.text = minAttribute[midLv + 1].split(",")[1] + "%";
                  this._nextValue2.text = minAttribute[midLv + 1].split(",")[2] + "%";
               }
            }
            else
            {
               this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.afterActivate");
               attribute1 = int(minAttribute[0].split(",")[1]);
               attribute2 = int(minAttribute[0].split(",")[2]);
               this._nextValue1.text = minAttribute[1].split(",")[1] + "%";
               this._nextValue2.text = minAttribute[1].split(",")[2] + "%";
            }
         }
         else
         {
            this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addAttribute" + this._type);
            this._attribute1.text = this._nextAttribute1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addMagicDamage");
            this._attribute2.text = this._nextAttribute2.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addCritDamage");
            itemLvl = MagicHouseManager.instance.magicSeniorLv;
            this._itemLvl.text = "Lv." + itemLvl;
            if(weapons[6] != 0 && weapons[7] != 0 && weapons[8] != 0)
            {
               for(s = 0; s <= seniorLv; s++)
               {
                  attribute1 += int(seniorAttribute[s].split(",")[0]);
                  attribute2 += int(seniorAttribute[s].split(",")[2]);
               }
               if(seniorLv == seniorAttribute.length - 1)
               {
                  this._nextValue1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.maxLevel");
                  PositionUtils.setPos(this._nextValue1,"magicHouse.attributeTopTxtPos");
                  this._nextLevelPromote.visible = false;
                  this._nextAttribute1.visible = false;
                  this._nextAttribute2.visible = false;
                  this._nextValue2.visible = false;
               }
               else
               {
                  this._nextValue1.text = seniorAttribute[seniorLv + 1].split(",")[0] + "%";
                  this._nextValue2.text = seniorAttribute[seniorLv + 1].split(",")[2] + "%";
               }
            }
            else
            {
               this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.afterActivate");
               attribute1 = int(seniorAttribute[0].split(",")[0]);
               attribute2 = int(seniorAttribute[0].split(",")[2]);
               this._nextValue1.text = seniorAttribute[1].split(",")[0] + "%";
               this._nextValue2.text = seniorAttribute[1].split(",")[2] + "%";
            }
         }
         this._attributeValue1.text = attribute1 + "%";
         this._attributeValue2.text = attribute2 + "%";
         this._upGradeBtn.enable = this._item1.isOpen && this._item2.isOpen && this._item3.isOpen && itemLvl < 5;
      }
      
      private function initEvent() : void
      {
         this._upGradeBtn.addEventListener(MouseEvent.CLICK,this.__upGrade);
         MagicHouseManager.instance.addEventListener("MAGICHOUSE_UPDATA",this.__messageUpdate);
      }
      
      private function removeEvent() : void
      {
         this._upGradeBtn.removeEventListener(MouseEvent.CLICK,this.__upGrade);
         MagicHouseManager.instance.removeEventListener("MAGICHOUSE_UPDATA",this.__messageUpdate);
      }
      
      private function __upGrade(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.MAGICHOUSE_MAGICPOTION) > 0)
         {
            this._potionCountSelecterFrame = ComponentFactory.Instance.creatComponentByStylename("magichouse.magicpotion.selecterFrame");
            this._potionCountSelecterFrame.type = this._type;
            LayerManager.Instance.addToLayer(this._potionCountSelecterFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionItem.magicPotionLess"));
         }
      }
      
      private function __messageUpdate(e:Event) : void
      {
         this._setData();
         this._updateProgress();
      }
      
      public function upDatafitCount() : void
      {
         if(!this._upGradeCell)
         {
            return;
         }
         var bagInfo:BagInfo = this._self.getBag(BagInfo.PROPBAG);
         var conut:int = bagInfo.getItemCountByTemplateId(EquipType.MAGICHOUSE_MAGICPOTION);
         this._upGradeCell.setCount(conut);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._item1))
         {
            this._item1.dispose();
         }
         this._item1 = null;
         if(Boolean(this._item2))
         {
            this._item2.dispose();
         }
         this._item2 = null;
         if(Boolean(this._item3))
         {
            this._item3.dispose();
         }
         this._item3 = null;
         if(Boolean(this._addAttributeTxt))
         {
            this._addAttributeTxt.dispose();
         }
         this._addAttributeTxt = null;
         if(Boolean(this._attribute1))
         {
            this._attribute1.dispose();
         }
         this._attribute1 = null;
         if(Boolean(this._attribute2))
         {
            this._attribute2.dispose();
         }
         this._attribute2 = null;
         if(Boolean(this._attributeValue1))
         {
            this._attributeValue1.dispose();
         }
         this._attributeValue1 = null;
         if(Boolean(this._attributeValue2))
         {
            this._attributeValue2.dispose();
         }
         this._attributeValue2 = null;
         if(Boolean(this._nextLevelPromote))
         {
            this._nextLevelPromote.dispose();
         }
         this._nextLevelPromote = null;
         if(Boolean(this._nextAttribute1))
         {
            this._nextAttribute1.dispose();
         }
         this._nextAttribute1 = null;
         if(Boolean(this._nextAttribute2))
         {
            this._nextAttribute2.dispose();
         }
         this._nextAttribute2 = null;
         if(Boolean(this._nextValue1))
         {
            this._nextValue1.dispose();
         }
         this._nextValue1 = null;
         if(Boolean(this._nextValue2))
         {
            this._nextValue2.dispose();
         }
         this._nextValue2 = null;
         if(Boolean(this._itemLvl))
         {
            this._itemLvl.dispose();
         }
         this._itemLvl = null;
         if(Boolean(this._upGradeCell))
         {
            this._upGradeCell.dispose();
         }
         this._upGradeCell = null;
         if(Boolean(this._progress))
         {
            this._progress.dispose();
         }
         this._progress = null;
         if(Boolean(this._collectionType))
         {
            ObjectUtils.disposeObject(this._collectionType);
         }
         this._collectionType = null;
         if(Boolean(this._collectionTypeCon))
         {
            ObjectUtils.disposeObject(this._collectionTypeCon);
         }
         this._collectionTypeCon = null;
         if(Boolean(this._upGradeBtn))
         {
            this._upGradeBtn.dispose();
         }
         this._upGradeBtn = null;
      }
   }
}

