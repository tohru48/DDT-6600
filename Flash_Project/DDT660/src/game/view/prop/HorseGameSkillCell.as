package game.view.prop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import game.model.LocalPlayer;
   import horse.HorseManager;
   import horse.data.HorseSkillVo;
   import horse.view.HorseSkillCell;
   
   public class HorseGameSkillCell extends Sprite implements Disposeable
   {
      
      public static const CELL_CLICKED:String = "cell_clicked";
      
      private var _skillId:int;
      
      private var _shortcutKey:String;
      
      private var _skillCell:HorseSkillCell;
      
      private var _countTxt:FilterFrameText;
      
      private var _grayCoverSprite:Sprite;
      
      private var _coldDownTxt:FilterFrameText;
      
      private var _lastUpClickTime:int = 0;
      
      private var _grayFilter:Array;
      
      private var _isCanUse:Boolean = true;
      
      private var _isAttacking:Boolean = false;
      
      private var _needColdNum:int = -1;
      
      private var _coldNum:int;
      
      private var _self:LocalPlayer;
      
      private var _enabled:Boolean = false;
      
      private var _skillInfo:HorseSkillVo;
      
      private var _isCanUse2:Boolean = true;
      
      public function HorseGameSkillCell(skillId:int, shortcutKey:String, self:LocalPlayer)
      {
         super();
         this._skillId = skillId;
         this._shortcutKey = shortcutKey;
         this._self = self;
         this._grayFilter = ComponentFactory.Instance.creatFilters("grayFilter");
         if(this._skillId > 0)
         {
            this._skillInfo = HorseManager.instance.getHorseSkillInfoById(this._skillId);
            this._needColdNum = this._skillInfo.ColdDown;
            this.buttonMode = true;
         }
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var fore:Bitmap = null;
         var back:Bitmap = ComponentFactory.Instance.creatBitmap("asset.game.prop.ItemBack");
         addChild(back);
         if(this._skillId > 0)
         {
            this._skillCell = new HorseSkillCell(this._skillId,false,true);
            this._skillCell.x = -3;
            this._skillCell.y = -3;
            addChild(this._skillCell);
         }
         fore = ComponentFactory.Instance.creatBitmap("asset.game.prop.ItemFore");
         fore.y = 2;
         fore.x = 2;
         addChild(fore);
         if(this._skillId > 0)
         {
            this._grayCoverSprite = new Sprite();
            this._grayCoverSprite.graphics.beginFill(0,0.5);
            this._grayCoverSprite.graphics.drawRect(back.x,back.y,back.width,back.height);
            this._grayCoverSprite.graphics.endFill();
            this._grayCoverSprite.mouseChildren = false;
            this._grayCoverSprite.mouseEnabled = false;
            addChild(this._grayCoverSprite);
            this._coldDownTxt = ComponentFactory.Instance.creatComponentByStylename("game.horseGameSkillCell.coldDownTxt");
            addChild(this._coldDownTxt);
            this._grayCoverSprite.visible = false;
            this._coldDownTxt.visible = false;
         }
         var shortcutKeyImg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.game.prop.ShortcutKey" + this._shortcutKey);
         shortcutKeyImg.y = -2;
         addChild(shortcutKeyImg);
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("game.customPropCell.countTxt");
         if(this._skillId > 0)
         {
            this._countTxt.visible = true;
            this._countTxt.text = this._skillInfo.UseCount.toString();
         }
         else
         {
            this._countTxt.visible = false;
         }
         addChild(this._countTxt);
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._skillCell))
         {
            addEventListener(MouseEvent.CLICK,this.__clicked);
         }
      }
      
      public function useSkill() : void
      {
         if(this._skillId > 0)
         {
            this.__clicked(null);
         }
      }
      
      private function __clicked(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         StageReferance.stage.focus = null;
         if(!this._isCanUse2)
         {
            return;
         }
         if(!this._enabled)
         {
            return;
         }
         if(!this._isCanUse)
         {
            return;
         }
         if(!this._isAttacking)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.NotAttacking"));
            return;
         }
         if(this._self.LockState)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.lockState.cannotUseSkill"));
            return;
         }
         if(this._self.energy < this._skillInfo.CostEnergy)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.EmptyEnergy"));
            return;
         }
         if(getTimer() - this._lastUpClickTime <= 1000)
         {
            return;
         }
         if(this._skillInfo.BallType == 1)
         {
            if(this._self.isUsedItem)
            {
               return;
            }
            this._self.flyEnabled = false;
            this._self.deputyWeaponEnabled = false;
            this._self.rightPropEnabled = false;
            this._self.spellKillEnabled = false;
            this._self.isUsedPetSkillWithNoItem = true;
         }
         this._lastUpClickTime = getTimer();
         SocketManager.Instance.out.sendPetSkill(this._skillId,2);
         dispatchEvent(new Event(CELL_CLICKED));
         this.setEnable(false);
         this._self.energy -= this.skillInfo.CostEnergy;
      }
      
      private function setEnable(value:Boolean) : void
      {
         this._isCanUse = value;
         if(this._isCanUse && this._enabled && this._isCanUse2)
         {
            this._skillCell.filters = null;
         }
         else
         {
            this._skillCell.filters = this._grayFilter;
         }
      }
      
      public function get skillId() : int
      {
         return this._skillId;
      }
      
      public function setColdCount(cd:int, count:int) : void
      {
         var restCount:int = this._skillInfo.UseCount - count;
         this._countTxt.text = restCount.toString();
         if(restCount > 0)
         {
            this._coldNum = cd;
            if(this._coldNum > 0)
            {
               this.setEnable(false);
               this.coldDownShowHide(true);
            }
         }
         else
         {
            this.setEnable(false);
         }
      }
      
      public function useCompleteHandler(isUse:Boolean, restCount:int) : void
      {
         if(isUse)
         {
            this.setEnable(false);
            this._countTxt.text = restCount.toString();
            if(restCount > 0)
            {
               this._coldNum = this._needColdNum + 1;
               this.coldDownShowHide(true);
            }
         }
         else
         {
            this.setEnable(true);
         }
      }
      
      public function attackChangeHandler(isAttacking:Boolean) : void
      {
         if(!this._skillCell)
         {
            return;
         }
         this._isAttacking = isAttacking;
         if(this._isAttacking)
         {
            this.isCanUse2 = true;
         }
      }
      
      public function roundOneEndHandler() : void
      {
         if(!this._skillCell)
         {
            return;
         }
         if(this._coldNum > 0)
         {
            --this._coldNum;
            if(this._coldNum <= 0)
            {
               this.setEnable(true);
               this.coldDownShowHide(false);
            }
            else
            {
               this.coldDownShowHide(true);
            }
         }
      }
      
      private function coldDownShowHide(isShow:Boolean) : void
      {
         this._grayCoverSprite.visible = isShow;
         this._coldDownTxt.visible = isShow;
         this._coldDownTxt.text = Math.min(this._coldNum,this._needColdNum).toString();
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(val:Boolean) : void
      {
         if(!this._skillCell)
         {
            return;
         }
         if(this._enabled != val)
         {
            this._enabled = val;
            if(this._enabled && this._isCanUse && this._isCanUse2)
            {
               this._skillCell.filters = null;
            }
            else
            {
               this._skillCell.filters = this._grayFilter;
            }
         }
      }
      
      public function get isCanUse2() : Boolean
      {
         return this._isCanUse2;
      }
      
      public function set isCanUse2(val:Boolean) : void
      {
         if(!this._skillCell)
         {
            return;
         }
         if(this._isCanUse2 != val)
         {
            this._isCanUse2 = val;
            if(this._isCanUse2 && this._isCanUse && this._enabled)
            {
               this._skillCell.filters = null;
            }
            else
            {
               this._skillCell.filters = this._grayFilter;
            }
         }
      }
      
      public function get skillInfo() : HorseSkillVo
      {
         return this._skillInfo;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._skillCell))
         {
            removeEventListener(MouseEvent.CLICK,this.__clicked);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._skillCell = null;
         this._countTxt = null;
         this._coldDownTxt = null;
         this._grayCoverSprite = null;
         this._grayFilter = null;
         this._self = null;
         this._skillInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

