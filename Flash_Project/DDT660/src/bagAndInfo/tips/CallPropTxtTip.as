package bagAndInfo.tips
{
   import catchInsect.componets.CatchInsectRankCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   
   public class CallPropTxtTip extends BaseTip
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _tempData:Object;
      
      private var _oriW:int;
      
      private var _oriH:int;
      
      private var _attack:FilterFrameText;
      
      private var _attackValue:FilterFrameText;
      
      private var _defense:FilterFrameText;
      
      private var _defenseValue:FilterFrameText;
      
      private var _agility:FilterFrameText;
      
      private var _agilityValue:FilterFrameText;
      
      private var _lucky:FilterFrameText;
      
      private var _luckyValue:FilterFrameText;
      
      private var _validDate:FilterFrameText;
      
      private var _validDateValue:FilterFrameText;
      
      public var lukAdd:int = 0;
      
      public function CallPropTxtTip()
      {
         super();
         visible = false;
      }
      
      override protected function init() : void
      {
         visible = false;
         mouseChildren = false;
         mouseEnabled = false;
         super.init();
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._attack = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._defense = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._agility = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._lucky = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._validDate = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._validDate.visible = false;
         this._attackValue = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._defenseValue = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._agilityValue = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._luckyValue = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._validDateValue = ComponentFactory.Instance.creatComponentByStylename("ddtbagandinfo.Calltip.ability");
         this._validDateValue.visible = false;
         this._attack.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.attack");
         this._defense.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.defense");
         this._agility.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.agility");
         this._lucky.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.lucky");
         this._validDate.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.validDate");
         this._attackValue.text = "+999";
         this._defenseValue.text = "+999";
         this._agilityValue.text = "+999";
         this._luckyValue.text = "+999";
         this._validDateValue.text = "三个月";
         PositionUtils.setPos(this._attack,"Call.tip.attack.Pos");
         PositionUtils.setPos(this._defense,"Call.tip.defense.Pos");
         PositionUtils.setPos(this._agility,"Call.tip.agility.Pos");
         PositionUtils.setPos(this._lucky,"Call.tip.lucky.Pos");
         PositionUtils.setPos(this._validDate,"Call.tip.validDate.Pos");
         PositionUtils.setPos(this._attackValue,"Call.tip.attackValue.Pos");
         PositionUtils.setPos(this._defenseValue,"Call.tip.defenseValue.Pos");
         PositionUtils.setPos(this._agilityValue,"Call.tip.agilityValue.Pos");
         PositionUtils.setPos(this._luckyValue,"Call.tip.luckyValue.Pos");
         PositionUtils.setPos(this._validDateValue,"Call.tip.validDateValue.Pos");
         addChild(this._attack);
         addChild(this._defense);
         addChild(this._agility);
         addChild(this._lucky);
         addChild(this._validDate);
         addChild(this._attackValue);
         addChild(this._defenseValue);
         addChild(this._agilityValue);
         addChild(this._luckyValue);
         addChild(this._validDateValue);
         this.setBGWidth(150);
         this.setBGHeight(130);
         this.tipbackgound = this._bg;
      }
      
      public function setBGWidth(bgWidth:int = 0) : void
      {
         this._bg.width = bgWidth;
      }
      
      public function setBGHeight(bgHeight:int = 0) : void
      {
         this._bg.height = bgHeight;
      }
      
      private function _buildTipInfo(type:String) : void
      {
      }
      
      override public function set tipData(data:Object) : void
      {
         visible = false;
         super.tipData = data;
         this.atcAddValueText(data.Attack);
         this.defAddValueText(data.Defend);
         this.agiAddValueText(data.Agility);
         this.lukAddValueText(data.Lucky);
         if(CatchInsectRankCell.isCatch && data.ValidDate != null && data.ValidDate != "")
         {
            this.setBGWidth(195);
            this.setBGHeight(160);
            this._validDate.visible = true;
            this._validDateValue.visible = true;
            this.validDateValueText(data.ValidDate);
         }
         else
         {
            this.setBGWidth(150);
            this.setBGHeight(130);
            this._validDate.visible = false;
            this._validDateValue.visible = false;
         }
         var allAdd:int = data.Attack + data.Defend + data.Agility + data.Lucky;
         if(allAdd > 0 || CatchInsectRankCell.isCatch)
         {
            visible = true;
         }
      }
      
      private function atcAddValueText(value:int) : void
      {
         this._attackValue.text = "+" + String(value);
      }
      
      private function defAddValueText(value:int) : void
      {
         this._defenseValue.text = "+" + String(value);
      }
      
      private function agiAddValueText(value:int) : void
      {
         this._agilityValue.text = "+" + String(value);
      }
      
      private function lukAddValueText(value:int) : void
      {
         this._luckyValue.text = "+" + String(value);
      }
      
      private function validDateValueText(value:String) : void
      {
         this._validDateValue.text = value;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._attack))
         {
            addChild(this._attack);
         }
         if(Boolean(this._defense))
         {
            addChild(this._defense);
         }
         if(Boolean(this._agility))
         {
            addChild(this._agility);
         }
         if(Boolean(this._lucky))
         {
            addChild(this._lucky);
         }
         if(Boolean(this._validDate))
         {
            addChild(this._validDate);
         }
         if(Boolean(this._attackValue))
         {
            addChild(this._attackValue);
         }
         if(Boolean(this._defenseValue))
         {
            addChild(this._defenseValue);
         }
         if(Boolean(this._agilityValue))
         {
            addChild(this._agilityValue);
         }
         if(Boolean(this._luckyValue))
         {
            addChild(this._luckyValue);
         }
         if(Boolean(this._validDateValue))
         {
            addChild(this._validDateValue);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._attack))
         {
            ObjectUtils.disposeObject(this._attack);
            this._attack = null;
         }
         if(Boolean(this._defense))
         {
            ObjectUtils.disposeObject(this._defense);
            this._defense = null;
         }
         if(Boolean(this._agility))
         {
            ObjectUtils.disposeObject(this._agility);
            this._agility = null;
         }
         if(Boolean(this._lucky))
         {
            ObjectUtils.disposeObject(this._lucky);
            this._lucky = null;
         }
         if(Boolean(this._validDate))
         {
            ObjectUtils.disposeObject(this._validDate);
            this._validDate = null;
         }
         if(Boolean(this._attackValue))
         {
            ObjectUtils.disposeObject(this._attackValue);
            this._attackValue = null;
         }
         if(Boolean(this._defenseValue))
         {
            ObjectUtils.disposeObject(this._defenseValue);
            this._defenseValue = null;
         }
         if(Boolean(this._agilityValue))
         {
            ObjectUtils.disposeObject(this._agilityValue);
            this._agilityValue = null;
         }
         if(Boolean(this._luckyValue))
         {
            ObjectUtils.disposeObject(this._luckyValue);
            this._luckyValue = null;
         }
         if(Boolean(this._validDateValue))
         {
            ObjectUtils.disposeObject(this._validDateValue);
            this._validDateValue = null;
         }
      }
   }
}

