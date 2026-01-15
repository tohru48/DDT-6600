package GodSyah
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class SyahItem extends Sprite
   {
      
      private var _itemBg:Bitmap;
      
      private var _cell:SyahCell;
      
      private var _mode:SyahMode;
      
      private var _info:InventoryItemInfo;
      
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
      
      private var _vec:Vector.<FilterFrameText>;
      
      public function SyahItem()
      {
         super();
         this._buildUI();
      }
      
      public function setSyahItemInfo(info:InventoryItemInfo) : void
      {
         this._info = info;
         this._mode = SyahManager.Instance.getSyahModeByInfo(info);
         this._createInfo();
      }
      
      private function _buildUI() : void
      {
         this._itemBg = ComponentFactory.Instance.creatBitmap("wonderfulactivity.GodSyah.syahView.item.bg");
         this._hp = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.ability");
         this._armor = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.ability");
         this._damage = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.ability");
         this._attack = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.ability");
         this._defense = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.ability");
         this._agility = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.ability");
         this._lucky = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.ability");
         this._hpValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.abilityValue");
         this._armorValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.abilityValue");
         this._damageValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.abilityValue");
         this._attackValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.abilityValue");
         this._defenseValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.abilityValue");
         this._agilityValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.abilityValue");
         this._luckyValue = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.abilityValue");
         this._hp.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.hp");
         this._armor.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.armor");
         this._damage.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.damage");
         this._attack.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.attack");
         this._defense.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.defense");
         this._agility.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.agility");
         this._lucky.text = LanguageMgr.GetTranslation("ddt.GodSyah.tip.lucky");
         addChild(this._itemBg);
      }
      
      private function _createInfo() : void
      {
         this._hpValue.text = "+" + this._mode.hp;
         this._armorValue.text = "+" + this._mode.armor;
         this._damageValue.text = "+" + this._mode.damage;
         this._attackValue.text = "+" + this._mode.attack;
         this._defenseValue.text = "+" + this._mode.defense;
         this._agilityValue.text = "+" + this._mode.agility;
         this._luckyValue.text = "+" + this._mode.lucky;
         this._cell = ComponentFactory.Instance.creatCustomObject("godSyah.syahview.syahcell");
         this._cell.info = this._info;
         this._vec = new Vector.<FilterFrameText>();
         if(parseInt(this._attackValue.text) > 0)
         {
            this._vec.push(this._attack);
            this._vec.push(this._attackValue);
         }
         if(parseInt(this._defenseValue.text) > 0)
         {
            this._vec.push(this._defense);
            this._vec.push(this._defenseValue);
         }
         if(parseInt(this._agilityValue.text) > 0)
         {
            this._vec.push(this._agility);
            this._vec.push(this._agilityValue);
         }
         if(parseInt(this._luckyValue.text) > 0)
         {
            this._vec.push(this._lucky);
            this._vec.push(this._luckyValue);
         }
         if(parseInt(this._hpValue.text) > 0)
         {
            this._vec.push(this._hp);
            this._vec.push(this._hpValue);
         }
         if(parseInt(this._armorValue.text) > 0)
         {
            this._vec.push(this._armor);
            this._vec.push(this._armorValue);
         }
         if(parseInt(this._damageValue.text) > 0)
         {
            this._vec.push(this._damage);
            this._vec.push(this._damageValue);
         }
         addChild(this._cell);
         this._arrangeText();
      }
      
      private function _arrangeText() : void
      {
         switch(this._vec.length)
         {
            case 2:
               this._vec[0].x = 157;
               this._vec[1].x = 215;
               this._vec[0].y = this._vec[1].y = 43;
               break;
            case 4:
               this._vec[0].x = 157;
               this._vec[1].x = 215;
               this._vec[2].x = 248;
               this._vec[3].x = 313;
               this._vec[0].y = this._vec[1].y = this._vec[2].y = this._vec[3].y = 43;
               break;
            case 6:
               this._vec[0].x = this._vec[4].x = 157;
               this._vec[1].x = this._vec[5].x = 215;
               this._vec[2].x = 248;
               this._vec[3].x = 313;
               this._vec[0].y = this._vec[1].y = this._vec[2].y = this._vec[3].y = 21;
               this._vec[4].y = this._vec[5].y = 63;
               break;
            case 8:
               this._vec[0].x = this._vec[4].x = 157;
               this._vec[1].x = this._vec[5].x = 215;
               this._vec[2].x = this._vec[6].x = 248;
               this._vec[3].x = this._vec[7].x = 313;
               this._vec[0].y = this._vec[1].y = this._vec[2].y = this._vec[3].y = 21;
               this._vec[4].y = this._vec[5].y = this._vec[6].y = this._vec[7].y = 63;
               break;
            case 10:
               this._vec[0].x = this._vec[4].x = this._vec[8].x = 157;
               this._vec[1].x = this._vec[5].x = this._vec[9].x = 215;
               this._vec[2].x = this._vec[6].x = 248;
               this._vec[3].x = this._vec[7].x = 313;
               this._vec[0].y = this._vec[1].y = this._vec[2].y = this._vec[3].y = 21;
               this._vec[4].y = this._vec[5].y = this._vec[6].y = this._vec[7].y = 42;
               this._vec[8].y = this._vec[9].y = 63;
               break;
            case 12:
               this._vec[0].x = this._vec[4].x = this._vec[8].x = 157;
               this._vec[1].x = this._vec[5].x = this._vec[9].x = 215;
               this._vec[2].x = this._vec[6].x = this._vec[10].x = 248;
               this._vec[3].x = this._vec[7].x = this._vec[11].x = 313;
               this._vec[0].y = this._vec[1].y = this._vec[2].y = this._vec[3].y = 21;
               this._vec[4].y = this._vec[5].y = this._vec[6].y = this._vec[7].y = 42;
               this._vec[8].y = this._vec[9].y = this._vec[10].y = this._vec[11].y = 63;
               break;
            case 14:
               this._vec[0].x = this._vec[4].x = this._vec[8].x = this._vec[12].x = 157;
               this._vec[1].x = this._vec[5].x = this._vec[9].x = this._vec[13].x = 215;
               this._vec[2].x = this._vec[6].x = this._vec[10].x = 248;
               this._vec[3].x = this._vec[7].x = this._vec[11].x = 313;
               this._vec[0].y = this._vec[1].y = this._vec[2].y = this._vec[3].y = 12;
               this._vec[4].y = this._vec[5].y = this._vec[6].y = this._vec[7].y = 32;
               this._vec[8].y = this._vec[9].y = this._vec[10].y = this._vec[11].y = 52;
               this._vec[12].y = this._vec[13].y = 72;
         }
         for(var i:int = 0; i < this._vec.length; i++)
         {
            addChild(this._vec[i]);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._itemBg))
         {
            ObjectUtils.disposeObject(this._itemBg);
            this._itemBg = null;
         }
         if(Boolean(this._hp))
         {
            ObjectUtils.disposeObject(this._hp);
            this._hp = null;
         }
         if(Boolean(this._armor))
         {
            ObjectUtils.disposeObject(this._armor);
            this._armor = null;
         }
         if(Boolean(this._damage))
         {
            ObjectUtils.disposeObject(this._damage);
            this._damage = null;
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
         if(Boolean(this._hpValue))
         {
            ObjectUtils.disposeObject(this._hpValue);
            this._hpValue = null;
         }
         if(Boolean(this._armorValue))
         {
            ObjectUtils.disposeObject(this._armorValue);
            this._armorValue = null;
         }
         if(Boolean(this._damageValue))
         {
            ObjectUtils.disposeObject(this._damageValue);
            this._damageValue = null;
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
      }
   }
}

