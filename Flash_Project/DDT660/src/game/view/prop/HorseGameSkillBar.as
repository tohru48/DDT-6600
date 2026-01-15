package game.view.prop
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.filters.ColorMatrixFilter;
   import game.GameManager;
   import game.model.LocalPlayer;
   import horse.HorseManager;
   import horse.data.HorseSkillVo;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import road7th.data.DictionaryData;
   
   public class HorseGameSkillBar extends Sprite implements Disposeable
   {
      
      private var _cellList:Vector.<HorseGameSkillCell>;
      
      private var _self:LocalPlayer;
      
      private var _enabled:Boolean = true;
      
      private var _turnEnabled:Boolean = true;
      
      public function HorseGameSkillBar(self:LocalPlayer)
      {
         super();
         this._self = self;
         this.initView();
         this.initEvent();
         this.skillInfoInit(null);
      }
      
      private function initView() : void
      {
         this._cellList = new Vector.<HorseGameSkillCell>();
         var tmpUseSkillList:DictionaryData = HorseManager.instance.curUseSkillList;
         var tmpZ:HorseGameSkillCell = new HorseGameSkillCell(tmpUseSkillList.hasKey("1") ? int(tmpUseSkillList["1"]) : -1,"z",this._self);
         var tmpX:HorseGameSkillCell = new HorseGameSkillCell(tmpUseSkillList.hasKey("2") ? int(tmpUseSkillList["2"]) : -1,"x",this._self);
         var tmpC:HorseGameSkillCell = new HorseGameSkillCell(tmpUseSkillList.hasKey("3") ? int(tmpUseSkillList["3"]) : -1,"c",this._self);
         PositionUtils.setPos(tmpZ,"CustomPropCellPosz");
         PositionUtils.setPos(tmpX,"CustomPropCellPosx");
         PositionUtils.setPos(tmpC,"CustomPropCellPosc");
         addChild(tmpZ);
         addChild(tmpX);
         addChild(tmpC);
         this._cellList.push(tmpZ);
         this._cellList.push(tmpX);
         this._cellList.push(tmpC);
      }
      
      private function initEvent() : void
      {
         this._self.addEventListener(LivingEvent.HORSE_SKILL_USE,this.useSkillHandler);
         this._self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.onAttackingChange);
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ROUND_ONE_END,this.__onRoundOneEnd);
         this._self.addEventListener(LivingEvent.CUSTOMENABLED_CHANGED,this.__customEnabledChanged);
         this._self.addEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChange);
         this._self.addEventListener(LivingEvent.PROPENABLED_CHANGED,this.__enabledChanged);
         this._self.addEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         this._self.addEventListener(LivingEvent.USING_ITEM,this.__onUseItem);
         GameManager.Instance.addEventListener(GameManager.SKILL_INFO_INIT_GAME,this.skillInfoInit);
         for(var i:int = 0; i <= this._cellList.length - 1; i++)
         {
            this._cellList[i].addEventListener(HorseGameSkillCell.CELL_CLICKED,this.__horseGameSkillCellClicked);
         }
      }
      
      protected function __horseGameSkillCellClicked(event:Event) : void
      {
         this._turnEnabled = false;
         this.enabled = false;
      }
      
      private function __keyDown(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case KeyStroke.VK_Z.getCode():
               this._cellList[0].useSkill();
               break;
            case KeyStroke.VK_X.getCode():
               this._cellList[1].useSkill();
               break;
            case KeyStroke.VK_C.getCode():
               this._cellList[2].useSkill();
         }
      }
      
      protected function __onRoundOneEnd(event:CrazyTankSocketEvent) : void
      {
         var tmp:HorseGameSkillCell = null;
         this._turnEnabled = true;
         this.enabled = this._turnEnabled && this._self.propEnabled && this._self.customPropEnabled;
         for each(tmp in this._cellList)
         {
            tmp.roundOneEndHandler();
         }
      }
      
      private function onAttackingChange(event:LivingEvent) : void
      {
         var tmp:HorseGameSkillCell = null;
         for each(tmp in this._cellList)
         {
            tmp.attackChangeHandler(this._self.isAttacking);
         }
      }
      
      private function useSkillHandler(event:LivingEvent) : void
      {
         var tmp:HorseGameSkillCell = null;
         var args:Array = event.paras;
         for each(tmp in this._cellList)
         {
            if(tmp.skillId == args[0])
            {
               tmp.useCompleteHandler(args[1],args[2]);
               break;
            }
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(val:Boolean) : void
      {
         var cell:HorseGameSkillCell = null;
         if(this._enabled != val)
         {
            this._enabled = val;
            for each(cell in this._cellList)
            {
               cell.enabled = this._enabled;
            }
            if(this._enabled)
            {
               filters = null;
               this.updatePropByEnergy();
            }
            else
            {
               filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
            }
         }
      }
      
      private function __energyChange(event:LivingEvent) : void
      {
         if(this._enabled)
         {
            this.updatePropByEnergy();
         }
      }
      
      private function updatePropByEnergy() : void
      {
         var cell:HorseGameSkillCell = null;
         var info:HorseSkillVo = null;
         for each(cell in this._cellList)
         {
            if(Boolean(cell.skillInfo))
            {
               info = cell.skillInfo;
               if(Boolean(info))
               {
                  if(this._self.energy < info.CostEnergy)
                  {
                     cell.enabled = false;
                  }
                  else
                  {
                     cell.enabled = true;
                  }
               }
            }
         }
      }
      
      private function __enabledChanged(event:LivingEvent) : void
      {
         this.enabled = this._turnEnabled && this._self.propEnabled && this._self.customPropEnabled;
      }
      
      private function __customEnabledChanged(evt:LivingEvent) : void
      {
         this.enabled = this._turnEnabled && this._self.customPropEnabled;
      }
      
      private function __usingSpecialKill(event:LivingEvent) : void
      {
         var cell:HorseGameSkillCell = null;
         var info:HorseSkillVo = null;
         for each(cell in this._cellList)
         {
            info = cell.skillInfo;
            if(Boolean(info) && info.BallType == 1)
            {
               cell.isCanUse2 = false;
            }
         }
      }
      
      private function __onUseItem(event:LivingEvent) : void
      {
         this.__usingSpecialKill(null);
      }
      
      private function skillInfoInit(event:Event) : void
      {
         var len:int = 0;
         var i:int = 0;
         var cell:HorseGameSkillCell = null;
         var info:HorseSkillVo = null;
         var infoList:Array = GameManager.Instance.horseSkillList;
         if(Boolean(infoList))
         {
            for(len = int(infoList.length); i < len; )
            {
               for each(cell in this._cellList)
               {
                  info = cell.skillInfo;
                  if(Boolean(info) && info.ID == infoList[i].id)
                  {
                     cell.setColdCount(infoList[i].cd,infoList[i].count);
                     break;
                  }
               }
               i++;
            }
            GameManager.Instance.horseSkillList = null;
         }
      }
      
      public function enter() : void
      {
         this.enabled = this._turnEnabled && this._self.propEnabled && this._self.customPropEnabled;
      }
      
      public function leaving() : void
      {
      }
      
      private function removeEvent() : void
      {
         this._self.removeEventListener(LivingEvent.HORSE_SKILL_USE,this.useSkillHandler);
         this._self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.onAttackingChange);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ROUND_ONE_END,this.__onRoundOneEnd);
         this._self.removeEventListener(LivingEvent.CUSTOMENABLED_CHANGED,this.__customEnabledChanged);
         this._self.removeEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChange);
         this._self.removeEventListener(LivingEvent.PROPENABLED_CHANGED,this.__enabledChanged);
         this._self.removeEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         this._self.removeEventListener(LivingEvent.USING_ITEM,this.__onUseItem);
         GameManager.Instance.removeEventListener(GameManager.SKILL_INFO_INIT_GAME,this.skillInfoInit);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._cellList = null;
         this._self = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

