package GodSyah
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   
   public class SyahTip extends Component
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _tipName:FilterFrameText;
      
      private var _line1:ScaleBitmapImage;
      
      private var _line2:ScaleBitmapImage;
      
      private var _hp:FilterFrameText;
      
      private var _hpValue:FilterFrameText;
      
      private var _armor:FilterFrameText;
      
      private var _armorValue:FilterFrameText;
      
      private var _damage:FilterFrameText;
      
      private var _damageValue:FilterFrameText;
      
      private var _attack:FilterFrameText;
      
      private var _attackValue:FilterFrameText;
      
      private var _defense:FilterFrameText;
      
      private var _defenseValue:FilterFrameText;
      
      private var _agility:FilterFrameText;
      
      private var _agilityValue:FilterFrameText;
      
      private var _lucky:FilterFrameText;
      
      private var _luckyValue:FilterFrameText;
      
      private var _valid:FilterFrameText;
      
      private var _lessValid:FilterFrameText;
      
      private var _itemPlace:int;
      
      private var _mode:SyahMode;
      
      private var _powerVec:Vector.<FilterFrameText>;
      
      private const SYAHVIEW:String = "syahview";
      
      private const BAGANDOTHERS:String = "bagandothers";
      
      public function SyahTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         this._buildUI();
      }
      
      public function setTipInfo(info:ItemTemplateInfo) : void
      {
         if(SyahManager.Instance.inView)
         {
            this._mode = SyahManager.Instance.getSyahModeByInfo(info);
            this._buildTipInfo(SyahManager.Instance.SYAHVIEW);
         }
         else
         {
            this._mode = SyahManager.Instance.getSyahModeByInfo(info);
            this._mode.isValid = SyahManager.Instance.setModeValid(info);
            this._buildTipInfo(SyahManager.Instance.BAGANDOTHERS);
         }
      }
      
      public function setBGWidth(bgWidth:int = 0) : void
      {
         this._bg.width = bgWidth;
      }
      
      private function _buildUI() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._line1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._line2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._tipName = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.tipName");
         this._hp = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.ability");
         this._armor = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.ability");
         this._damage = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.ability");
         this._attack = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.ability");
         this._defense = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.ability");
         this._agility = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.ability");
         this._lucky = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.ability");
         this._hpValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.abilityValue");
         this._armorValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.abilityValue");
         this._damageValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.abilityValue");
         this._attackValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.abilityValue");
         this._defenseValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.abilityValue");
         this._agilityValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.abilityValue");
         this._luckyValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.abilityValue");
         this._valid = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.valid");
         this._lessValid = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahTip.valid");
         addChild(this._bg);
         addChild(this._line1);
         addChild(this._line2);
         addChild(this._tipName);
         addChild(this._valid);
      }
      
      private function _buildTipInfo(type:String) : void
      {
         this._tipName.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.tipName");
         this._valid.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.valid",this._mode.valid);
         this._line1.x = this._tipName.x;
         this._line1.y = this._tipName.y + this._tipName.height + 2;
         if(type == this.SYAHVIEW)
         {
            this._showAllDetails();
         }
         else if(type == this.BAGANDOTHERS)
         {
            if(this._mode.isValid == false)
            {
               this._lessValid.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.lessvalid");
               addChild(this._lessValid);
               this._lessValid.x = this._tipName.x;
               this._lessValid.y = this._line1.y + this._line1.height + 2;
               this._line2.x = this._tipName.x;
               this._line2.y = this._lessValid.y + this._lessValid.height + 2;
            }
            else
            {
               this._showAllDetails();
            }
         }
         this._valid.x = this._tipName.x;
         this._valid.y = this._line2.y + this._line2.height + 2;
         this._bg.height = this._valid.y + this._valid.height + 10;
      }
      
      private function _showAllDetails() : void
      {
         this._hp.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.hp");
         this._armor.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.armor");
         this._damage.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.damage");
         this._attack.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.attack");
         this._defense.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.defense");
         this._agility.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.agility");
         this._lucky.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.lucky");
         this._attackValue.text = "+" + this._mode.attack;
         this._defenseValue.text = "+" + this._mode.defense;
         this._agilityValue.text = "+" + this._mode.agility;
         this._luckyValue.text = "+" + this._mode.lucky;
         this._hpValue.text = "+" + this._mode.hp;
         this._armorValue.text = "+" + this._mode.armor;
         this._damageValue.text = "+" + this._mode.damage;
         this._powerVec = new Vector.<FilterFrameText>();
         if(parseInt(this._attackValue.text) > 0)
         {
            this._powerVec.push(this._attack);
            this._powerVec.push(this._attackValue);
         }
         if(parseInt(this._defenseValue.text) > 0)
         {
            this._powerVec.push(this._defense);
            this._powerVec.push(this._defenseValue);
         }
         if(parseInt(this._agilityValue.text) > 0)
         {
            this._powerVec.push(this._agility);
            this._powerVec.push(this._agilityValue);
         }
         if(parseInt(this._luckyValue.text) > 0)
         {
            this._powerVec.push(this._lucky);
            this._powerVec.push(this._luckyValue);
         }
         if(parseInt(this._hpValue.text) > 0)
         {
            this._powerVec.push(this._hp);
            this._powerVec.push(this._hpValue);
         }
         if(parseInt(this._armorValue.text) > 0)
         {
            this._powerVec.push(this._armor);
            this._powerVec.push(this._armorValue);
         }
         if(parseInt(this._damageValue.text) > 0)
         {
            this._powerVec.push(this._damage);
            this._powerVec.push(this._damageValue);
         }
         for(var i:int = 0; i < this._powerVec.length; i += 2)
         {
            if(parseInt(this._powerVec[i + 1].text) > 0)
            {
               addChild(this._powerVec[i]);
               addChild(this._powerVec[i + 1]);
               if(i == 0)
               {
                  this._powerVec[i].y = this._powerVec[i + 1].y = this._line1.y + this._line1.height + 2;
               }
               else
               {
                  this._powerVec[i].y = this._powerVec[i + 1].y = this._powerVec[i - 1].y + this._powerVec[i - 1].height + 1;
               }
            }
         }
         this._line2.x = this._tipName.x;
         this._line2.y = this._powerVec[this._powerVec.length - 1].y + this._powerVec[this._powerVec.length - 1].height + 2;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._tipName))
         {
            ObjectUtils.disposeObject(this._tipName);
            this._tipName = null;
         }
         if(Boolean(this._line1))
         {
            ObjectUtils.disposeObject(this._line1);
            this._line1 = null;
         }
         if(Boolean(this._line2))
         {
            ObjectUtils.disposeObject(this._line2);
            this._line2 = null;
         }
         if(Boolean(this._hp))
         {
            ObjectUtils.disposeObject(this._hp);
            this._hp = null;
         }
         if(Boolean(this._hpValue))
         {
            ObjectUtils.disposeObject(this._hpValue);
            this._hpValue = null;
         }
         if(Boolean(this._armor))
         {
            ObjectUtils.disposeObject(this._armor);
            this._armor = null;
         }
         if(Boolean(this._armorValue))
         {
            ObjectUtils.disposeObject(this._armorValue);
            this._armorValue = null;
         }
         if(Boolean(this._damage))
         {
            ObjectUtils.disposeObject(this._damage);
            this._damage = null;
         }
         if(Boolean(this._damageValue))
         {
            ObjectUtils.disposeObject(this._damageValue);
            this._damageValue = null;
         }
         if(Boolean(this._attack))
         {
            ObjectUtils.disposeObject(this._attack);
            this._attack = null;
         }
         if(Boolean(this._attackValue))
         {
            ObjectUtils.disposeObject(this._attackValue);
            this._attackValue = null;
         }
         if(Boolean(this._defense))
         {
            ObjectUtils.disposeObject(this._defense);
            this._defense = null;
         }
         if(Boolean(this._defenseValue))
         {
            ObjectUtils.disposeObject(this._defenseValue);
            this._defenseValue = null;
         }
         if(Boolean(this._agility))
         {
            ObjectUtils.disposeObject(this._agility);
            this._agility = null;
         }
         if(Boolean(this._agilityValue))
         {
            ObjectUtils.disposeObject(this._agilityValue);
            this._agilityValue = null;
         }
         if(Boolean(this._lucky))
         {
            ObjectUtils.disposeObject(this._lucky);
            this._lucky = null;
         }
         if(Boolean(this._luckyValue))
         {
            ObjectUtils.disposeObject(this._luckyValue);
            this._luckyValue = null;
         }
         if(Boolean(this._valid))
         {
            ObjectUtils.disposeObject(this._valid);
            this._valid = null;
         }
      }
   }
}

