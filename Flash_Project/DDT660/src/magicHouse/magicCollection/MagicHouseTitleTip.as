package magicHouse.magicCollection
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   
   public class MagicHouseTitleTip extends BaseTip
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _tipTitle:FilterFrameText;
      
      private var _attack:FilterFrameText;
      
      private var _attackValue:FilterFrameText;
      
      private var _defense:FilterFrameText;
      
      private var _defenseValue:FilterFrameText;
      
      private var _damage:FilterFrameText;
      
      private var _damageValue:FilterFrameText;
      
      public function MagicHouseTitleTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         mouseChildren = false;
         mouseEnabled = false;
         super.init();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._tipTitle = ComponentFactory.Instance.creatComponentByStylename("magichouse.titleTip.Text");
         this._attack = ComponentFactory.Instance.creatComponentByStylename("magichouse.titleTip.Text");
         this._attackValue = ComponentFactory.Instance.creatComponentByStylename("magichouse.titleTip.Text");
         this._defense = ComponentFactory.Instance.creatComponentByStylename("magichouse.titleTip.Text");
         this._defenseValue = ComponentFactory.Instance.creatComponentByStylename("magichouse.titleTip.Text");
         this._damage = ComponentFactory.Instance.creatComponentByStylename("magichouse.titleTip.Text");
         this._damageValue = ComponentFactory.Instance.creatComponentByStylename("magichouse.titleTip.Text");
         this._attack.text = LanguageMgr.GetTranslation("magichouse.collectionView.titleTip.attack");
         this._defense.text = LanguageMgr.GetTranslation("magichouse.collectionView.titleTip.defense");
         this._damage.text = LanguageMgr.GetTranslation("magichouse.collectionView.titleTip.damage");
         PositionUtils.setPos(this._tipTitle,"magicHouse.titleTipTitleTxtPos");
         PositionUtils.setPos(this._attack,"magicHouse.titleTipAttackTxtPos");
         PositionUtils.setPos(this._defense,"magicHouse.titleTipDefenseTxtPos");
         PositionUtils.setPos(this._damage,"magicHouse.titleTipDamageTxtPos");
         PositionUtils.setPos(this._attackValue,"magicHouse.titleTipAttackValueTxtPos");
         PositionUtils.setPos(this._defenseValue,"magicHouse.titleTipDefenseValueTxtPos");
         PositionUtils.setPos(this._damageValue,"magicHouse.titleTipDamageValueTxtPos");
         addChild(this._tipTitle);
         addChild(this._attack);
         addChild(this._attackValue);
         addChild(this._defense);
         addChild(this._defenseValue);
         addChild(this._damage);
         addChild(this._damageValue);
         this.setBGWidth(150);
         this.setBGHeight(130);
         this.tipbackgound = this._bg;
      }
      
      override public function set tipData(data:Object) : void
      {
         super.tipData = data;
         this.setTitleText(data.title);
         this.atcAddValueText(data.magicAttack);
         this.defAddValueText(data.magicDefense);
         this.lukAddValueText(data.critDamage);
      }
      
      private function setTitleText(value:String) : void
      {
         this._tipTitle.text = value;
      }
      
      private function atcAddValueText(value:int) : void
      {
         this._attackValue.text = "+" + String(value);
      }
      
      private function defAddValueText(value:int) : void
      {
         this._defenseValue.text = "+" + String(value);
      }
      
      private function lukAddValueText(value:int) : void
      {
         this._damageValue.text = "+" + String(value);
      }
      
      public function setBGWidth(bgWidth:int = 0) : void
      {
         this._bg.width = bgWidth;
      }
      
      public function setBGHeight(bgHeight:int = 0) : void
      {
         this._bg.height = bgHeight;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._tipTitle))
         {
            addChild(this._tipTitle);
         }
         if(Boolean(this._attack))
         {
            addChild(this._attack);
         }
         if(Boolean(this._defense))
         {
            addChild(this._defense);
         }
         if(Boolean(this._damage))
         {
            addChild(this._damage);
         }
         if(Boolean(this._attackValue))
         {
            addChild(this._attackValue);
         }
         if(Boolean(this._defenseValue))
         {
            addChild(this._defenseValue);
         }
         if(Boolean(this._damageValue))
         {
            addChild(this._damageValue);
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
         if(Boolean(this._damage))
         {
            ObjectUtils.disposeObject(this._damage);
            this._damage = null;
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
         if(Boolean(this._damageValue))
         {
            ObjectUtils.disposeObject(this._damageValue);
            this._damageValue = null;
         }
      }
   }
}

