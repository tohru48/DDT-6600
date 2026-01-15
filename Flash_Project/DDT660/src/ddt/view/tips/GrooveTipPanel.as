package ddt.view.tips
{
   import cardSystem.CardControl;
   import cardSystem.GrooveInfoManager;
   import cardSystem.data.CardGrooveInfo;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.QualityType;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   
   public class GrooveTipPanel extends BaseTip implements ITip, Disposeable
   {
      
      public static const THISWIDTH:int = 200;
      
      public static const CARDTYPE:Array = [LanguageMgr.GetTranslation("BrowseLeftMenuView.equipCard"),LanguageMgr.GetTranslation("BrowseLeftMenuView.freakCard")];
      
      public static const CARDTYPE_VICE_MAIN:Array = [LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.vice"),LanguageMgr.GetTranslation("ddt.cardSystem.CardsTipPanel.main")];
      
      private var _bg:ScaleBitmapImage;
      
      private var _GrooveLevel:Bitmap;
      
      private var _GrooveLevelDetail:FilterFrameText;
      
      private var _rule1:ScaleBitmapImage;
      
      private var _propVec:Vector.<FilterFrameText>;
      
      private var _rule2:ScaleBitmapImage;
      
      private var _setsName:FilterFrameText;
      
      private var _setsPropVec:Vector.<FilterFrameText>;
      
      private var _validity:FilterFrameText;
      
      private var _cardInfo:CardInfo;
      
      private var _cardGrooveInfo:GrooveInfo;
      
      private var _place:int;
      
      private var _thisHeight:int;
      
      private var _EpDetail:FilterFrameText;
      
      private var _Explain:FilterFrameText;
      
      public function GrooveTipPanel()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._GrooveLevel = null;
         this._rule1 = null;
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
         this._validity = null;
         this._cardInfo = null;
         this._cardGrooveInfo = null;
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
         this._GrooveLevel = ComponentFactory.Instance.creatBitmap("asset.core.tip.GoodsLevel");
         PositionUtils.setPos(this._GrooveLevel,"core.cardLevelBmpOne.pos");
         this._GrooveLevelDetail = ComponentFactory.Instance.creatComponentByStylename("cardSystem.level.big");
         PositionUtils.setPos(this._GrooveLevelDetail,"core.cardLevel.pos");
         this._EpDetail = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.ExpPropTitle");
         PositionUtils.setPos(this._EpDetail,"core.cardTipEp.pos");
         this._Explain = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.ExplainTitle");
         this._propVec = new Vector.<FilterFrameText>(4);
         for(var j:int = 0; j < 4; j++)
         {
            this._propVec[j] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         }
         this._setsName = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         this._setsPropVec = new Vector.<FilterFrameText>(4);
         for(var n:int = 0; n < 4; n++)
         {
            this._setsPropVec[n] = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.setsPropText");
         }
         this._validity = ComponentFactory.Instance.creatComponentByStylename("CardsTipPanel.basePropTitle");
         super.init();
         super.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._GrooveLevel);
         addChild(this._GrooveLevelDetail);
         addChild(this._rule1);
         addChild(this._EpDetail);
         addChild(this._Explain);
         for(var j:int = 0; j < 4; j++)
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
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(data:Object) : void
      {
         if(Boolean(data))
         {
            this._cardInfo = data as CardInfo;
            this.visible = true;
            _tipData = this._cardInfo;
            this._place = this._cardInfo.Place;
            if(this._place < 5)
            {
               if(CardControl.Instance.model.GrooveInfoVector == null)
               {
                  this.visible = false;
               }
               else
               {
                  this._cardGrooveInfo = CardControl.Instance.model.GrooveInfoVector[this._place];
               }
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
      
      private function showHeadPart() : void
      {
         var cardInfo:CardGrooveInfo = null;
         var _grooveInfo1:CardGrooveInfo = null;
         var current:int = 0;
         var difference:int = 0;
         var _grooveInfo:CardGrooveInfo = GrooveInfoManager.instance.getInfoByLevel(String(this._cardGrooveInfo.Level),String(this._cardGrooveInfo.Type));
         this._GrooveLevelDetail.text = this._cardGrooveInfo.Level < 10 ? "0" + String(this._cardGrooveInfo.Level) : String(this._cardGrooveInfo.Level);
         if(this._cardGrooveInfo.Level >= 40)
         {
            this._EpDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.EP",0 + "/" + 0);
         }
         else
         {
            cardInfo = GrooveInfoManager.instance.getInfoByLevel(String(this._cardGrooveInfo.Level),String(this._cardGrooveInfo.Type));
            _grooveInfo1 = GrooveInfoManager.instance.getInfoByLevel(String(this._cardGrooveInfo.Level + 1),String(this._cardGrooveInfo.Type));
            current = this._cardGrooveInfo.GP - int(cardInfo.Exp);
            difference = int(_grooveInfo1.Exp) - int(cardInfo.Exp);
            this._EpDetail.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.EP",current + "/" + difference);
         }
         this._rule1.x = this._EpDetail.x;
         this._rule1.y = this._EpDetail.y + this._EpDetail.textHeight + 10;
         this._thisHeight = this._rule1.y + this._rule1.height;
      }
      
      private function showMiddlePart() : void
      {
         var i:int = 0;
         var propArr:Array = new Array();
         var _grooveInfo:CardGrooveInfo = GrooveInfoManager.instance.getInfoByLevel(String(this._cardGrooveInfo.Level),String(this._cardGrooveInfo.Type));
         if(int(_grooveInfo.Attack) >= 0)
         {
            propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Attack",this._cardGrooveInfo.realAttack));
         }
         if(int(_grooveInfo.Defend) >= 0)
         {
            propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Defence",this._cardGrooveInfo.realDefence));
         }
         if(int(_grooveInfo.Agility) >= 0)
         {
            propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Agility",this._cardGrooveInfo.realAgility));
         }
         if(int(_grooveInfo.Lucky) >= 0)
         {
            propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Luck",this._cardGrooveInfo.realLucky));
         }
         if(int(_grooveInfo.Damage) >= 0)
         {
            propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Gamage",this._cardGrooveInfo.realDamage));
         }
         if(int(_grooveInfo.Guard) >= 0)
         {
            propArr.push(LanguageMgr.GetTranslation("ddt.cardSystem.PropResetFrame.Guard",this._cardGrooveInfo.realGuard));
         }
         for(i = 0; i < 4; i++)
         {
            if(i < propArr.length)
            {
               this._propVec[i].visible = true;
               this._propVec[i].text = propArr[i];
               this._propVec[i].textColor = QualityType.QUALITY_COLOR[5];
               this._propVec[i].y = this._rule1.y + this._rule1.height + 8 + 24 * i;
               if(i == propArr.length - 1)
               {
                  this._rule2.x = this._propVec[i].x;
                  this._rule2.y = this._propVec[i].y + this._propVec[i].textHeight + 12;
               }
            }
            else
            {
               this._propVec[i].visible = false;
            }
            this._rule2.x = this._propVec[i].x;
            this._rule2.y = this._propVec[i].y + this._propVec[i].textHeight + 12;
            this._thisHeight = this._rule2.y + this._rule2.height;
         }
      }
      
      private function showButtomPart() : void
      {
         this._setsName.visible = false;
         for(var n:int = 0; n < this._setsPropVec.length; n++)
         {
            this._setsPropVec[n].visible = false;
         }
         this._validity.visible = false;
         this._Explain.visible = true;
         this._Explain.text = LanguageMgr.GetTranslation("ddt.cardsTipPanel.Groove.epdetai");
         this._Explain.y = this._thisHeight + 10;
         this._thisHeight = this._Explain.y + this._Explain.textHeight;
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

