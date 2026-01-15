package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipSuitTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.data.goods.SuitTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   
   public class LaterEquipmentGoodView extends Component
   {
      
      public static const THISWIDTH:int = 200;
      
      public static const EQUIPNUM:int = 19;
      
      public static var isShow:Boolean = true;
      
      private var SUITNUM:int;
      
      private var _bg:ScaleBitmapImage;
      
      private var _topName:FilterFrameText;
      
      private var _setNum:FilterFrameText;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _rule2:ScaleBitmapImage;
      
      private var _setsPropVec:Vector.<FilterFrameText>;
      
      private var _validity:Vector.<FilterFrameText>;
      
      private var _thisHeight:int;
      
      private var _thisWidht:int;
      
      private var _info:SuitTemplateInfo;
      
      private var _itemInfo:ItemTemplateInfo;
      
      private var _EquipInfo:InventoryItemInfo;
      
      private var _playerInfo:PlayerInfo;
      
      private var _suitId:int;
      
      private var _ContainEquip:Array;
      
      public function LaterEquipmentGoodView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      private function initData() : void
      {
         var arr:Array = null;
         if(Boolean(ItemManager.Instance.EquipSuit))
         {
            arr = ItemManager.Instance.EquipSuit[this._info.SuitId] as Array;
            if(Boolean(arr))
            {
               this.SUITNUM = arr.length;
            }
         }
         this._setsPropVec = new Vector.<FilterFrameText>(this.SUITNUM);
         this._validity = new Vector.<FilterFrameText>(this.SUITNUM);
         for(var i:int = 0; i < this.SUITNUM; i++)
         {
            this._setsPropVec[i] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.setsPropText");
            this._validity[i] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.setsPropText");
         }
      }
      
      private function showText() : void
      {
         for(var j:int = 0; j < this.SUITNUM; j++)
         {
            addChild(this._setsPropVec[j]);
            addChild(this._validity[j]);
         }
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(data:Object) : void
      {
         if(Boolean(data))
         {
            this._itemInfo = data as ItemTemplateInfo;
            this.visible = true;
            _tipData = this._itemInfo;
            this._suitId = this._itemInfo.SuitId;
            if(this._suitId != 0)
            {
               this._info = ItemManager.Instance.getSuitTemplateByID(String(this._suitId));
               if(Boolean(this._info))
               {
                  this.showTip();
               }
               else
               {
                  this.visible = false;
               }
            }
            else
            {
               this.visible = false;
            }
         }
         else
         {
            this.visible = false;
         }
      }
      
      public function showTip() : void
      {
         this.updateView();
      }
      
      private function updateView() : void
      {
         this.clear();
         this.initData();
         this.showText();
         this.showHeadPart();
         this.showMiddlePart();
         this.showButtomPart();
         this.upBackground();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._topName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.name");
         this._setNum = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.name");
         addChild(this._bg);
         addChild(this._rule1);
         addChild(this._rule2);
         addChild(this._topName);
         addChild(this._setNum);
      }
      
      private function showHeadPart() : void
      {
         this._topName.text = this._info.SuitName;
         if(!LaterEquipmentGoodView.isShow)
         {
            this._topName.textColor = 10066329;
         }
         this._rule1.x = this._topName.x;
         this._rule1.y = this._topName.y + this._topName.textHeight + 7;
         this._thisHeight = this._rule1.y + this._rule1.height;
         this._thisWidht = this._thisWidht > this._rule1.y + this._rule1.width ? this._thisWidht : int(this._rule1.y + this._rule1.width);
      }
      
      private function showMiddlePart() : void
      {
         var propArr:Array = null;
         var i:int = 0;
         var equipInfo:ItemTemplateInfo = null;
         var equipinfo:EquipSuitTemplateInfo = null;
         var equip:Array = null;
         var n:int = 0;
         var index:int = 0;
         this._playerInfo = Boolean(ItemManager.Instance.playerInfo) ? ItemManager.Instance.playerInfo : PlayerManager.Instance.Self;
         this._ContainEquip = ItemManager.Instance.EquipSuit[this._info.SuitId] as Array;
         if(this._ContainEquip == null)
         {
            return;
         }
         propArr = new Array();
         var containequip:Array = new Array();
         var equipArr:Array = new Array();
         var signArr:Array = new Array();
         for(var j:int = 0; j < this._ContainEquip.length; j++)
         {
            if(this._ContainEquip[j])
            {
               equipInfo = ItemManager.Instance.getTemplateById(int(this._ContainEquip[j]));
               propArr.push(this._ContainEquip[j].PartName);
            }
         }
         for(var k:int = 0; k < EQUIPNUM; k++)
         {
            this._EquipInfo = this._playerInfo.Bag.getItemAt(k);
            if(this._EquipInfo != null)
            {
               equipArr.push([this._EquipInfo.TemplateID,this._EquipInfo.Place]);
            }
         }
         for(i = 0; i < this._setsPropVec.length; i++)
         {
            if(i < propArr.length)
            {
               this._setsPropVec[i].visible = true;
               this._setsPropVec[i].text = propArr[i];
               equipinfo = ItemManager.Instance.getEquipSuitbyContainEquip(this._setsPropVec[i].text);
               equip = equipinfo.ContainEquip.split(",");
               loop3:
               for(n = 0; n < equipArr.length; n++)
               {
                  for(index = 0; index < equip.length; index++)
                  {
                     if(equip[index] == equipArr[n][0] && signArr.indexOf(equipArr[n]) == -1)
                     {
                        this._setsPropVec[i].textColor = 10092339;
                        signArr.push(equipArr[n]);
                        break loop3;
                     }
                     this._setsPropVec[i].textColor = 10066329;
                  }
               }
               if(!LaterEquipmentGoodView.isShow)
               {
                  this._setsPropVec[i].textColor = 10066329;
               }
               if(!LaterEquipmentGoodView.isShow)
               {
                  this._setsPropVec[i].textColor = 10066329;
               }
               this._setsPropVec[i].y = this._rule1.y + this._rule1.height + 8 + 24 * i;
               if(i == propArr.length - 1)
               {
                  this._rule2.x = this._setsPropVec[i].x;
                  this._rule2.y = this._setsPropVec[i].y + this._setsPropVec[i].textHeight + 7;
               }
            }
            else
            {
               this._setsPropVec[i].visible = false;
            }
         }
         this._thisHeight = this._rule2.y + this._rule2.height;
      }
      
      private function showButtomPart() : void
      {
         var j:int = 0;
         var containequip:Array = null;
         var m:int = 0;
         var n:int = 0;
         var con:int = 0;
         var equipNum:Array = new Array();
         var equipArr:Array = new Array();
         for(var k:int = 0; k < EQUIPNUM; k++)
         {
            this._EquipInfo = this._playerInfo.Bag.getItemAt(k);
            if(this._EquipInfo != null)
            {
               equipArr.push([this._EquipInfo.TemplateID,this._EquipInfo.Place]);
            }
         }
         for(var i:int = 0; i < this._ContainEquip.length; i++)
         {
            containequip = this._ContainEquip[i].ContainEquip.split(",");
            loop2:
            for(m = 0; m < containequip.length; m++)
            {
               for(n = 0; n < equipArr.length; n++)
               {
                  if(equipArr[n][0] == containequip[m] && equipNum.indexOf(equipArr[n]) == -1)
                  {
                     equipNum.push(equipArr[n]);
                     break loop2;
                  }
               }
            }
         }
         for(j = 0; j < this.SUITNUM; j++)
         {
            if(this._info["SkillDescribe" + (j + 1)] != "")
            {
               this._validity[j].visible = true;
               con = int(this._info["EqipCount" + (j + 1)]);
               if(equipNum.length >= con)
               {
                  this._validity[j].text = LanguageMgr.GetTranslation("ddt.goodTip.laterEquipmentGoodView.equip",con) + "\n    " + this._info["SkillDescribe" + (j + 1)];
                  this._validity[j].textColor = QualityType.QUALITY_COLOR[2];
                  if(!LaterEquipmentGoodView.isShow)
                  {
                     this._validity[j].text = LanguageMgr.GetTranslation("ddt.goodTip.laterEquipmentGoodView.equip",con) + "\n    " + this._info["SkillDescribe" + (j + 1)];
                     this._validity[j].textColor = 10066329;
                  }
               }
               else
               {
                  this._validity[j].text = LanguageMgr.GetTranslation("ddt.goodTip.laterEquipmentGoodView.equip",con) + "\n    " + this._info["SkillDescribe" + (j + 1)];
                  this._validity[j].textColor = 10066329;
                  if(!LaterEquipmentGoodView.isShow)
                  {
                     this._validity[j].text = LanguageMgr.GetTranslation("ddt.goodTip.laterEquipmentGoodView.equip",con) + "\n    " + this._info["SkillDescribe" + (j + 1)];
                     this._validity[j].textColor = 10066329;
                  }
               }
            }
            else
            {
               this._validity[j].visible = false;
            }
            this._validity[j].y = this._thisHeight;
            this._thisHeight = this._validity[j].y + this._validity[j].textHeight;
            this._thisWidht = this._thisWidht > this._validity[j].x + this._validity[j].textWidth ? this._thisWidht : int(this._validity[j].x + this._validity[j].textWidth);
         }
         this._setNum.text = "(" + equipNum.length + "/" + this._ContainEquip.length + ")";
         this._setNum.x = this._topName.textWidth + 12;
         this._setNum.y = this._topName.y;
         if(!LaterEquipmentGoodView.isShow)
         {
            this._setNum.text = "(" + 0 + "/" + this._ContainEquip.length + ")";
            this._setNum.textColor = 10066329;
         }
         this._thisWidht = this._thisWidht > this._setNum.x + this._setNum.width ? this._thisWidht : int(this._setNum.x + this._setNum.width);
      }
      
      private function upBackground() : void
      {
         this._bg.height = this._thisHeight + 13;
         this._bg.width = this._thisWidht + 13;
         this.updateWH();
      }
      
      private function updateWH() : void
      {
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      private function clear() : void
      {
         var j:int = 0;
         var i:int = 0;
         this.SUITNUM = 0;
         if(Boolean(this._setsPropVec) && this._setsPropVec.length > 0)
         {
            for(j = 0; j < this._setsPropVec.length; j++)
            {
               this._setsPropVec[j].dispose();
               this._setsPropVec[j] = null;
            }
            this._setsPropVec = null;
         }
         if(Boolean(this._validity) && this._validity.length > 0)
         {
            for(i = 0; i < this._validity.length; i++)
            {
               this._validity[i].dispose();
               this._validity[i] = null;
            }
            this._validity = null;
         }
      }
      
      public function getBGWidth() : int
      {
         return this._bg.width;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bg))
         {
            this._bg.dispose();
            this._bg = null;
         }
         if(Boolean(this._rule1))
         {
            this._rule1.dispose();
            this._rule1 = null;
         }
         if(Boolean(this._rule2))
         {
            this._rule2.dispose();
            this._rule2 = null;
         }
         if(Boolean(this._topName))
         {
            this._topName.dispose();
            this._topName = null;
         }
         if(Boolean(this._setNum))
         {
            this._setNum.dispose();
            this._setNum = null;
         }
         this.clear();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

