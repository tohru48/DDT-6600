package ddt.view.tips
{
   import cardSystem.CardControl;
   import cardSystem.CardTemplateInfoManager;
   import cardSystem.data.CardInfo;
   import cardSystem.data.CardTemplateInfo;
   import cardSystem.data.GrooveInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.data.SetsPropertyInfo;
   import cardSystem.view.LaterEquipmentGrooveView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.QualityType;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import road7th.data.DictionaryData;
   
   public class EquipmentCardsTips extends BaseTip implements ITip, Disposeable
   {
      
      public static const THISWIDTH:int = 350;
      
      public static const CARDTYPE:Array = [LanguageMgr.GetTranslation("BrowseLeftMenuView.equipCard"),LanguageMgr.GetTranslation("BrowseLeftMenuView.freakCard")];
      
      public static const CARDTYPE_VICE_MAIN:Array = [LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.vice"),LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.main")];
      
      private var _bg:ScaleBitmapImage;
      
      private var _cardName:FilterFrameText;
      
      private var _cardType:Bitmap;
      
      private var _cardTypeDetail:FilterFrameText;
      
      private var _cardLevel:Bitmap;
      
      private var _cardLevelDetail:FilterFrameText;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _band:ScaleFrameImage;
      
      private var _propVec:Vector.<FilterFrameText>;
      
      private var _rule2:ScaleBitmapImage;
      
      private var _setsName:FilterFrameText;
      
      private var _setsPropVec:Vector.<FilterFrameText>;
      
      private var _validity:FilterFrameText;
      
      private var _cardInfo:CardInfo;
      
      private var _thisHeight:int;
      
      private var _cardGrooveInfo:GrooveInfo;
      
      private var _place:int;
      
      private var _Quality:FilterFrameText;
      
      private var _QualityDetail:FilterFrameText;
      
      private var _laterEquipmentView:LaterEquipmentGrooveView;
      
      private var _isGroove:Boolean;
      
      public function EquipmentCardsTips()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._cardName = null;
         this._cardType = null;
         this._cardTypeDetail = null;
         this._cardLevel = null;
         this._rule1 = null;
         this._band = null;
         for(var j:int = 0; j < this._propVec.length; j++)
         {
            this._propVec[j] = null;
         }
         this._propVec = null;
         this._rule2 = null;
         this._setsName = null;
         for(var n:int = 0; n < this._setsPropVec.length; n++)
         {
            this._setsPropVec[n] = null;
         }
         this._setsPropVec = null;
         this._validity = null;
         this._cardInfo = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._band = ComponentFactory.Instance.creatComponentByStylename("tipPanel.band");
         this._cardName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.name");
         this._cardType = ComponentFactory.Instance.creatBitmap("asset.core.tip.GoodsType");
         PositionUtils.setPos(this._cardType,"CardsTipPanel.typePos");
         this._cardTypeDetail = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.typeDetail");
         this._cardLevel = ComponentFactory.Instance.creatBitmap("asset.core.tip.GoodsLevel");
         this._cardLevelDetail = ComponentFactory.Instance.creatComponentByStylename("cardSystem.level.big");
         this._propVec = new Vector.<FilterFrameText>(4);
         for(var j:int = 0; j < 6; j++)
         {
            this._propVec[j] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         }
         this._setsName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         this._setsPropVec = new Vector.<FilterFrameText>(4);
         for(var n:int = 0; n < 4; n++)
         {
            this._setsPropVec[n] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.setsPropText1");
         }
         this._validity = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         this._Quality = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.QualityTitle");
         this._QualityDetail = ComponentFactory.Instance.creatComponentByStylename("cardSystem.Quality");
         this._laterEquipmentView = new LaterEquipmentGrooveView();
         super.init();
         super.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._cardName);
         addChild(this._cardType);
         addChild(this._cardTypeDetail);
         addChild(this._rule1);
         addChild(this._band);
         addChild(this._Quality);
         addChild(this._QualityDetail);
         for(var j:int = 0; j < 6; j++)
         {
            addChild(this._propVec[j]);
         }
         addChild(this._rule2);
         addChild(this._setsName);
         for(var n:int = 0; n < 4; n++)
         {
            addChild(this._setsPropVec[n]);
         }
         addChild(this._validity);
         addChild(this._laterEquipmentView);
         this._laterEquipmentView.x = 350;
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(data:Object) : void
      {
         if(data is CardInfo)
         {
            this._cardInfo = data as CardInfo;
            this.visible = true;
            _tipData = this._cardInfo;
            this._place = this._cardInfo.Place;
            if(this._place == 2 || this._place == 4)
            {
               this._laterEquipmentView.x = -200;
            }
            else
            {
               this._laterEquipmentView.x = 350;
            }
            if(this._place < 5)
            {
               if(CardControl.Instance.model.GrooveInfoVector == null)
               {
                  this.visible = false;
               }
               else
               {
                  this._cardGrooveInfo = CardControl.Instance.model.GrooveInfoVector[this._place];
                  this._isGroove = true;
                  this._laterEquipmentView.visible = true;
                  this.laterEquipment(this._cardInfo);
               }
            }
            else
            {
               this._isGroove = false;
               this._laterEquipmentView.visible = false;
            }
            this.upview();
         }
         else
         {
            this.visible = false;
            _tipData = null;
         }
      }
      
      private function upview() : void
      {
         this._thisHeight = 0;
         this.showHeadPart();
         this.showMiddlePart();
         this.showButtomPart();
         this.upBackground();
      }
      
      private function laterEquipment(cardInfo:CardInfo) : void
      {
         if(!this._laterEquipmentView)
         {
            this._laterEquipmentView = new LaterEquipmentGrooveView();
         }
         this._laterEquipmentView.tipData = cardInfo;
      }
      
      private function showHeadPart() : void
      {
         this._cardName.text = this._cardInfo.templateInfo.Name;
         this._cardTypeDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.typeDetail",CARDTYPE[int(this._cardInfo.templateInfo.Property6)],CARDTYPE_VICE_MAIN[this._cardInfo.templateInfo.Property8]);
         this._Quality.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Quality");
         PositionUtils.setPos(this._Quality,"core.cardLevel.pos");
         this._QualityDetail.x = this._Quality.x + this._Quality.textWidth + 10;
         this._QualityDetail.y = this._Quality.y;
         this._band.setFrame(this._cardInfo.templateInfo.BindType == 0 ? 2 : 1);
         var level:int = this._cardInfo.Level == 30 ? 3 : (this._cardInfo.Level >= 20 ? 2 : (this._cardInfo.Level >= 10 ? 1 : 0));
         if(this._cardInfo.Level == 0)
         {
            this._cardName.textColor = 16777215;
         }
         else
         {
            this._cardName.textColor = QualityType.QUALITY_COLOR[level + 1];
         }
         if(this._cardInfo.CardType == 1)
         {
            this._QualityDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.jin");
         }
         else if(this._cardInfo.CardType == 2)
         {
            this._QualityDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.yin");
         }
         else if(this._cardInfo.CardType == 4)
         {
            this._QualityDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.baijin");
         }
         else
         {
            this._QualityDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.tong");
         }
         this._band.x = 200;
         this._band.y = 98;
         this._rule1.x = this._cardName.x;
         this._rule1.y = this._Quality.y + this._Quality.textHeight + 10;
         this._thisHeight = this._rule1.y + this._rule1.height;
      }
      
      private function showMiddlePart() : void
      {
         var propArr:Array = null;
         propArr = new Array();
         var cardTempleInfo:CardTemplateInfo = CardTemplateInfoManager.instance.getInfoByCardId(String(this._cardInfo.TemplateID),String(this._cardInfo.CardType));
         if(!this._isGroove)
         {
            if(Number(cardTempleInfo.AttackRate) < 1 || int(cardTempleInfo.AddAttack) + this._cardInfo.Attack != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack1") + (Number(cardTempleInfo.AttackRate) < 1 ? Number(cardTempleInfo.AttackRate) * 100 + "%" : "") + (int(cardTempleInfo.AddAttack) != 0 ? (int(cardTempleInfo.AddAttack) > 0 ? "+" + int(cardTempleInfo.AddAttack) : int(cardTempleInfo.AddAttack)) : "") + (this._cardInfo.Attack != 0 ? "(" + (this._cardInfo.Attack > 0 ? "+" + this._cardInfo.Attack : this._cardInfo.Attack) + ")" : ""));
            }
            if(Number(cardTempleInfo.DefendRate) < 1 || int(cardTempleInfo.AddDefend) + this._cardInfo.Defence != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence1") + (Number(cardTempleInfo.DefendRate) < 1 ? Number(cardTempleInfo.DefendRate) * 100 + "%" : "") + (int(cardTempleInfo.AddDefend) != 0 ? (int(cardTempleInfo.AddDefend) > 0 ? "+" + int(cardTempleInfo.AddDefend) : int(cardTempleInfo.AddDefend)) : "") + (this._cardInfo.Defence != 0 ? "(" + (this._cardInfo.Defence > 0 ? "+" + this._cardInfo.Defence : this._cardInfo.Defence) + ")" : ""));
            }
            if(Number(cardTempleInfo.AgilityRate) < 1 || int(cardTempleInfo.AddAgility) + this._cardInfo.Agility != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility1") + (Number(cardTempleInfo.AgilityRate) < 1 ? Number(cardTempleInfo.AgilityRate) * 100 + "%" : "") + (int(cardTempleInfo.AddAgility) != 0 ? (int(cardTempleInfo.AddAgility) > 0 ? "+" + int(cardTempleInfo.AddAgility) : int(cardTempleInfo.AddAgility)) : "") + (this._cardInfo.Agility != 0 ? "(" + (this._cardInfo.Agility > 0 ? "+" + this._cardInfo.Agility : this._cardInfo.Agility) + ")" : ""));
            }
            if(Number(cardTempleInfo.LuckyRate) < 1 || int(cardTempleInfo.AddLucky) + this._cardInfo.Luck != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck1") + (Number(cardTempleInfo.LuckyRate) < 1 ? Number(cardTempleInfo.LuckyRate) * 100 + "%" : "") + (int(cardTempleInfo.AddLucky) != 0 ? (int(cardTempleInfo.AddLucky) > 0 ? "+" + int(cardTempleInfo.AddLucky) : int(cardTempleInfo.AddLucky)) : "") + (this._cardInfo.Luck != 0 ? "(" + (this._cardInfo.Luck > 0 ? "+" + this._cardInfo.Luck : this._cardInfo.Luck) + ")" : ""));
            }
            if(Number(cardTempleInfo.DamageRate) < 1 || int(cardTempleInfo.AddDamage) + this._cardInfo.Damage != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Damage1") + (Number(cardTempleInfo.DamageRate) < 1 ? Number(cardTempleInfo.DamageRate) * 100 + "%" : "") + (int(cardTempleInfo.AddDamage) != 0 ? (int(cardTempleInfo.AddDamage) > 0 ? "+" + int(cardTempleInfo.AddDamage) : int(cardTempleInfo.AddDamage)) : "") + (this._cardInfo.Damage != 0 ? "(" + (this._cardInfo.Damage > 0 ? "+" + this._cardInfo.Damage : this._cardInfo.Damage) + ")" : ""));
            }
            if(Number(cardTempleInfo.GuardRate) < 1 || int(cardTempleInfo.AddGuard) + this._cardInfo.Guard != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard1") + (Number(cardTempleInfo.GuardRate) < 1 ? Number(cardTempleInfo.GuardRate) * 100 + "%" : "") + (int(cardTempleInfo.AddGuard) != 0 ? (int(cardTempleInfo.AddGuard) > 0 ? "+" + int(cardTempleInfo.AddGuard) : int(cardTempleInfo.AddGuard)) : "") + (this._cardInfo.Guard != 0 ? "(" + (this._cardInfo.Guard > 0 ? "+" + this._cardInfo.Guard : this._cardInfo.Guard) + ")" : ""));
            }
         }
         else
         {
            if(int(cardTempleInfo.AddAttack) + this._cardInfo.Attack != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack1") + (int(cardTempleInfo.AddAttack) != 0 ? (int(cardTempleInfo.AddAttack) > 0 ? "+" + int(cardTempleInfo.AddAttack) : int(cardTempleInfo.AddAttack)) : "") + (this._cardInfo.Attack != 0 ? "(" + (this._cardInfo.Attack > 0 ? "+" + this._cardInfo.Attack : this._cardInfo.Attack) + ")" : ""));
            }
            if(int(cardTempleInfo.AddDefend) + this._cardInfo.Defence != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence1") + (int(cardTempleInfo.AddDefend) != 0 ? (int(cardTempleInfo.AddDefend) > 0 ? "+" + int(cardTempleInfo.AddDefend) : int(cardTempleInfo.AddDefend)) : "") + (this._cardInfo.Defence != 0 ? "(" + (this._cardInfo.Defence > 0 ? "+" + this._cardInfo.Defence : this._cardInfo.Defence) + ")" : ""));
            }
            if(int(cardTempleInfo.AddAgility) + this._cardInfo.Agility != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility1") + (int(cardTempleInfo.AddAgility) != 0 ? (int(cardTempleInfo.AddAgility) > 0 ? "+" + int(cardTempleInfo.AddAgility) : int(cardTempleInfo.AddAgility)) : "") + (this._cardInfo.Agility != 0 ? "(" + (this._cardInfo.Agility > 0 ? "+" + this._cardInfo.Agility : this._cardInfo.Agility) + ")" : ""));
            }
            if(int(cardTempleInfo.AddLucky) + this._cardInfo.Luck != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck1") + (int(cardTempleInfo.AddLucky) != 0 ? (int(cardTempleInfo.AddLucky) > 0 ? "+" + int(cardTempleInfo.AddLucky) : int(cardTempleInfo.AddLucky)) : "") + (this._cardInfo.Luck != 0 ? "(" + (this._cardInfo.Luck > 0 ? "+" + this._cardInfo.Luck : this._cardInfo.Luck) + ")" : ""));
            }
            if(int(cardTempleInfo.AddDamage) + this._cardInfo.Damage != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Damage1") + (int(cardTempleInfo.AddDamage) != 0 ? (int(cardTempleInfo.AddDamage) > 0 ? "+" + int(cardTempleInfo.AddDamage) : int(cardTempleInfo.AddDamage)) : "") + (this._cardInfo.Damage != 0 ? "(" + (this._cardInfo.Damage > 0 ? "+" + this._cardInfo.Damage : this._cardInfo.Damage) + ")" : ""));
            }
            if(int(cardTempleInfo.AddGuard) + this._cardInfo.Guard != 0)
            {
               propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard1") + (int(cardTempleInfo.AddGuard) != 0 ? (int(cardTempleInfo.AddGuard) > 0 ? "+" + int(cardTempleInfo.AddGuard) : int(cardTempleInfo.AddGuard)) : "") + (this._cardInfo.Guard != 0 ? "(" + (this._cardInfo.Guard > 0 ? "+" + this._cardInfo.Guard : this._cardInfo.Guard) + ")" : ""));
            }
         }
         for(var j:int = 0; j < 6; j++)
         {
            if(j < propArr.length)
            {
               this._propVec[j].visible = true;
               this._propVec[j].text = propArr[j];
               this._propVec[j].textColor = QualityType.QUALITY_COLOR[5];
               this._propVec[j].y = this._rule1.y + this._rule1.height + 8 + 24 * j;
               if(j == propArr.length - 1)
               {
                  this._rule2.x = this._propVec[j].x;
                  this._rule2.y = this._propVec[j].y + this._propVec[j].textHeight + 12;
               }
            }
            else
            {
               this._propVec[j].visible = false;
            }
         }
         this._thisHeight = this._rule2.y + this._rule2.height;
      }
      
      private function showButtomPart() : void
      {
         var equipLevelVec:Vector.<int> = null;
         var cInfo:CardInfo = null;
         var bagLevelVec:Vector.<int> = null;
         var bagCard:DictionaryData = null;
         var bagCInfo:CardInfo = null;
         var m:int = 0;
         var setsVec:Vector.<SetsInfo> = null;
         var len:int = 0;
         var name:String = null;
         var i:int = 0;
         var grooveinfo:GrooveInfo = null;
         var valueArr:Array = null;
         var value:String = null;
         var con:int = 0;
         equipLevelVec = new Vector.<int>();
         var playerInfo:PlayerInfo = PlayerManager.Instance.findPlayer(this._cardInfo.UserID);
         var equipCard:DictionaryData = playerInfo.cardEquipDic;
         for each(cInfo in equipCard)
         {
            if(cInfo.templateInfo.Property7 == this._cardInfo.templateInfo.Property7 && cInfo.Count > -1)
            {
               if(!this._isGroove)
               {
                  equipLevelVec.push(cInfo.Level);
               }
               else
               {
                  grooveinfo = CardControl.Instance.model.GrooveInfoVector[cInfo.Place];
                  equipLevelVec.push(grooveinfo.Level);
               }
            }
         }
         equipLevelVec.sort(this.compareFun);
         bagLevelVec = new Vector.<int>();
         bagCard = playerInfo.cardBagDic;
         for each(bagCInfo in bagCard)
         {
            if(bagCInfo.templateInfo.Property7 == this._cardInfo.templateInfo.Property7)
            {
               if(!this._isGroove)
               {
                  bagLevelVec.push(bagCInfo.Level);
               }
               else
               {
                  bagLevelVec.push(this._cardGrooveInfo.Level);
               }
            }
         }
         bagLevelVec.sort(this.compareFun);
         m = 0;
         setsVec = CardControl.Instance.model.setsSortRuleVector;
         len = int(setsVec.length);
         name = "";
         for(i = 0; i < len; i++)
         {
            if(setsVec[i].ID == this._cardInfo.templateInfo.Property7)
            {
               m = int(setsVec[i].cardIdVec.length);
               name = setsVec[i].name;
               break;
            }
         }
         this._setsName.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.setsName",name,equipLevelVec.length,m);
         if(equipLevelVec.length > 0)
         {
            this._setsName.textColor = 16777215;
         }
         else
         {
            this._setsName.textColor = 10066329;
         }
         this._setsName.y = this._thisHeight + 5;
         this._thisHeight = this._setsName.y + this._setsName.textHeight;
         var setsInfoVec:Vector.<SetsPropertyInfo> = CardControl.Instance.model.setsList[this._cardInfo.templateInfo.Property7];
         var len2:int = int(setsInfoVec.length);
         for(var j:int = 0; j < 4; j++)
         {
            if(j < len2)
            {
               this._setsPropVec[j].visible = true;
               valueArr = setsInfoVec[j].value.split("|");
               value = "";
               con = setsInfoVec[j].condition;
               if(equipLevelVec.length >= con)
               {
                  if(valueArr.length == 4)
                  {
                     value = equipLevelVec[con - 1] == 40 ? valueArr[3] : (equipLevelVec[con - 1] >= 30 ? valueArr[3] : (equipLevelVec[con - 1] >= 20 ? valueArr[2] : (equipLevelVec[con - 1] >= 10 ? valueArr[1] : valueArr[0])));
                  }
                  else
                  {
                     value = valueArr[0];
                  }
                  this._setsPropVec[j].text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.equip",con) + "\n    " + setsInfoVec[j].Description.replace("{0}",value);
                  this._setsPropVec[j].textColor = QualityType.QUALITY_COLOR[2];
               }
               else
               {
                  if(valueArr.length == 4)
                  {
                     if(bagLevelVec.length >= con)
                     {
                        value = bagLevelVec[con - 1] == 40 ? valueArr[3] : (bagLevelVec[con - 1] >= 30 ? valueArr[3] : (bagLevelVec[con - 1] >= 20 ? valueArr[2] : (bagLevelVec[con - 1] >= 10 ? valueArr[1] : valueArr[0])));
                     }
                     else
                     {
                        value = valueArr[0];
                     }
                  }
                  else
                  {
                     value = valueArr[0];
                  }
                  this._setsPropVec[j].text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.equip",con) + "\n    " + setsInfoVec[j].Description.replace("{0}",value);
                  this._setsPropVec[j].textColor = 10066329;
               }
               this._setsPropVec[j].y = this._thisHeight + 4;
               this._thisHeight = this._setsPropVec[j].y + this._setsPropVec[j].textHeight;
            }
            else
            {
               this._setsPropVec[j].visible = false;
            }
         }
         this._validity.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
         this._validity.textColor = 16776960;
         this._validity.y = this._thisHeight + 10;
         this._thisHeight = this._validity.y + this._validity.textHeight;
      }
      
      private function compareFun(x:int, y:int) : Number
      {
         if(x < y)
         {
            return 1;
         }
         if(x > y)
         {
            return -1;
         }
         return 0;
      }
      
      private function upBackground() : void
      {
         this._bg.height = this._thisHeight + 13;
         this._bg.width = THISWIDTH;
         this.updateWH();
      }
      
      private function updateWH() : void
      {
         _width = this._bg.width;
         _height = this._bg.height;
      }
   }
}

