package game.view.prop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightPropMode;
   import ddt.data.map.MapInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.LocalPlayer;
   import game.view.tool.PetEnergyStrip;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import pet.date.PetSkill;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.controller.PetBagController;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.data.ArrowType;
   
   public class PetSkillBar extends FightPropBar
   {
      
      private var _skillCells:Vector.<PetSkillCell>;
      
      private var _usedItem:Boolean = false;
      
      private var _usedSpecialSkill:Boolean = false;
      
      private var _usedPetSkill:Boolean = false;
      
      private var _bg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.game.petSkillBar.back");
      
      private var _petEnergyStrip:PetEnergyStrip;
      
      private var letters:Array = ["Q","E","T","Y","U"];
      
      public function PetSkillBar(self:LocalPlayer)
      {
         PositionUtils.setPos(this._bg,"game.petSikllBar.BGPos");
         addChild(this._bg);
         this._skillCells = new Vector.<PetSkillCell>();
         super(self);
         this.updateCellEnable();
         if(Boolean(GameManager.Instance.Current.selfGamePlayer.currentPet))
         {
            this._petEnergyStrip = new PetEnergyStrip(GameManager.Instance.Current.selfGamePlayer.currentPet);
            PositionUtils.setPos(this._petEnergyStrip,"asset.game.mpStripPos");
            addChild(this._petEnergyStrip);
         }
         this.skillInfoInit(null);
      }
      
      override public function enter() : void
      {
         this.addEvent();
      }
      
      override protected function addEvent() : void
      {
         var cell:PetSkillCell = null;
         for each(cell in this._skillCells)
         {
            if(cell.isEnabled)
            {
               cell.addEventListener(MouseEvent.CLICK,this.onCellClick);
            }
         }
         _self.currentPet.addEventListener(LivingEvent.PET_MP_CHANGE,this.__onChange);
         _self.currentPet.addEventListener(LivingEvent.USE_PET_SKILL,this.__onUsePetSkill);
         _self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__onAttackingChange);
         _self.addEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         _self.addEventListener(LivingEvent.USING_ITEM,this.__onUseItem);
         _self.addEventListener(LivingEvent.IS_CALCFORCE_CHANGE,this.__onChange);
         _self.addEventListener(LivingEvent.PETSKILL_ENABLED_CHANGED,this.__onChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_SKILL_CD,this.__petSkillCD);
         if(!(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM))
         {
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         }
         GameManager.Instance.addEventListener(LivingEvent.PETSKILL_USED_FAIL,this.__onPetSkillUsedFail);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ROUND_ONE_END,this.__onRoundOneEnd);
         GameManager.Instance.addEventListener(GameManager.SKILL_INFO_INIT_GAME,this.skillInfoInit);
      }
      
      override protected function removeEvent() : void
      {
         var cell:PetSkillCell = null;
         for each(cell in this._skillCells)
         {
            if(cell.isEnabled)
            {
               cell.removeEventListener(MouseEvent.CLICK,this.onCellClick);
            }
         }
         _self.currentPet.removeEventListener(LivingEvent.PET_MP_CHANGE,this.__onChange);
         _self.currentPet.removeEventListener(LivingEvent.USE_PET_SKILL,this.__onUsePetSkill);
         _self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__onAttackingChange);
         _self.removeEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         _self.removeEventListener(LivingEvent.USING_ITEM,this.__onUseItem);
         _self.removeEventListener(LivingEvent.IS_CALCFORCE_CHANGE,this.__onChange);
         _self.removeEventListener(LivingEvent.PETSKILL_ENABLED_CHANGED,this.__onChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_SKILL_CD,this.__petSkillCD);
         GameManager.Instance.removeEventListener(LivingEvent.PETSKILL_USED_FAIL,this.__onPetSkillUsedFail);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ROUND_ONE_END,this.__onRoundOneEnd);
         GameManager.Instance.removeEventListener(GameManager.SKILL_INFO_INIT_GAME,this.skillInfoInit);
         if(!(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM))
         {
            KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         }
      }
      
      override protected function __keyDown(event:KeyboardEvent) : void
      {
         var skillCell:PetSkillCell = null;
         if(GameManager.Instance.Current.mapIndex == 1405)
         {
            return;
         }
         if(Boolean(_self) && _self.isLocked)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.onlyFly"));
            return;
         }
         var index:int = -1;
         switch(event.keyCode)
         {
            case KeyStroke.VK_Q.getCode():
               index = 0;
               break;
            case KeyStroke.VK_E.getCode():
               index = 1;
               break;
            case KeyStroke.VK_T.getCode():
               index = 2;
               break;
            case KeyStroke.VK_Y.getCode():
               index = 3;
               break;
            case KeyStroke.VK_U.getCode():
               index = 4;
         }
         var key:String = this.letters[index];
         for each(skillCell in this._skillCells)
         {
            if(skillCell.shortcutKey == key && skillCell.skillInfo && skillCell.skillInfo.isActiveSkill && skillCell.isEnabled && skillCell.enabled)
            {
               skillCell.useProp();
               break;
            }
         }
      }
      
      private function __onPetSkillUsedFail(pEvent:LivingEvent) : void
      {
         this._usedPetSkill = false;
         _self.deputyWeaponEnabled = true;
         _self.isUsedPetSkillWithNoItem = false;
      }
      
      private function __onChange(event:LivingEvent) : void
      {
         this.updateCellEnable();
      }
      
      private function skillInfoInit(event:Event) : void
      {
         var len:int = 0;
         var i:int = 0;
         var cell:PetSkillCell = null;
         var infoList:Array = GameManager.Instance.petSkillList;
         if(Boolean(infoList))
         {
            for(len = int(infoList.length); i < len; )
            {
               for each(cell in this._skillCells)
               {
                  if(Boolean(cell.skillInfo) && cell.skillInfo.ID == infoList[i].id)
                  {
                     cell.turnNum = cell.skillInfo.ColdDown + 1 - infoList[i].cd;
                     break;
                  }
               }
               i++;
            }
            GameManager.Instance.petSkillList = null;
         }
      }
      
      private function __petSkillCD(event:CrazyTankSocketEvent) : void
      {
         var cell:PetSkillCell = null;
         var pkg:PackageIn = event.pkg;
         var skillid:int = pkg.readInt();
         var cd:int = pkg.readInt();
         for each(cell in this._skillCells)
         {
            if(cell.skillInfo.ID == skillid)
            {
               cell.turnNum = cell.skillInfo.ColdDown + 1 - cd;
            }
         }
         this.updateCellEnable();
      }
      
      private function __usingSpecialKill(event:LivingEvent) : void
      {
         var cell:PetSkillCell = null;
         for each(cell in this._skillCells)
         {
            cell.enabled = false;
         }
         this._usedSpecialSkill = true;
      }
      
      private function __onUseItem(event:LivingEvent) : void
      {
         var cell:PetSkillCell = null;
         for each(cell in this._skillCells)
         {
            if(Boolean(cell.skillInfo))
            {
               if(cell.skillInfo.BallType == PetSkillTemplateInfo.BALL_TYPE_1 || cell.skillInfo.BallType == PetSkillTemplateInfo.BALL_TYPE_2)
               {
                  cell.enabled = false;
               }
            }
         }
         this._usedItem = true;
      }
      
      private function __onUsePetSkill(event:LivingEvent) : void
      {
         var cell:PetSkillCell = null;
         for each(cell in this._skillCells)
         {
            if(Boolean(cell.skillInfo))
            {
               if(cell.skillInfo.ID == event.value)
               {
                  cell.turnNum = 0;
                  break;
               }
            }
         }
         this.updateCellEnable();
      }
      
      protected function __onRoundOneEnd(event:CrazyTankSocketEvent) : void
      {
         var cell:PetSkillCell = null;
         for each(cell in this._skillCells)
         {
            ++cell.turnNum;
         }
         this._usedItem = false;
         this._usedSpecialSkill = false;
         this._usedPetSkill = false;
         _self.isUsedPetSkillWithNoItem = false;
         this.updateCellEnable();
      }
      
      private function __onAttackingChange(event:LivingEvent) : void
      {
         this.updateCellEnable();
      }
      
      private function updateCellEnable() : void
      {
         var cell:PetSkillCell = null;
         var e:Boolean = _self.petSkillEnabled;
         for each(cell in this._skillCells)
         {
            if(Boolean(cell.skillInfo))
            {
               switch(cell.skillInfo.BallType)
               {
                  case PetSkillTemplateInfo.BALL_TYPE_0:
                     cell.enabled = e && _self.isAttacking && !this._usedPetSkill && !this._usedSpecialSkill && cell.skillInfo.CostMP <= _self.currentPet.MP && cell.turnNum > cell.skillInfo.ColdDown;
                     break;
                  case PetSkillTemplateInfo.BALL_TYPE_1:
                     cell.enabled = e && _self.isAttacking && !this._usedPetSkill && !this._usedItem && !this._usedSpecialSkill && cell.skillInfo.CostMP <= _self.currentPet.MP && cell.turnNum > cell.skillInfo.ColdDown;
                     break;
                  case PetSkillTemplateInfo.BALL_TYPE_2:
                     cell.enabled = e && _self.isAttacking && !this._usedPetSkill && !this._usedItem && !this._usedSpecialSkill && !_self.iscalcForce && cell.skillInfo.CostMP <= _self.currentPet.MP && cell.turnNum > cell.skillInfo.ColdDown;
                     break;
                  case PetSkillTemplateInfo.BALL_TYPE_3:
                     cell.enabled = e && _self.isAttacking && !this._usedPetSkill && !this._usedSpecialSkill && cell.skillInfo.CostMP <= _self.currentPet.MP && cell.turnNum > cell.skillInfo.ColdDown;
               }
            }
            if(PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.USE_PET_SKILL] > 0 && cell.enabled)
            {
               PetBagController.instance().showPetFarmGuildArrow(ArrowType.USE_PET_SKILL,0,"farmTrainer.petSkillUseArrowPos","asset.farmTrainer.clickHere","farmTrainer.petSkillUseTipPos",this);
            }
         }
      }
      
      private function onCellClick(event:MouseEvent) : void
      {
         if(_self.isLocked)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.onlyFly"));
            return;
         }
         var tgt:PetSkillCell = event.currentTarget as PetSkillCell;
         if(tgt.enabled && _self.isAttacking)
         {
            SoundManager.instance.play("008");
            if(tgt.skillInfo.BallType == PetSkillTemplateInfo.BALL_TYPE_1 || tgt.skillInfo.BallType == PetSkillTemplateInfo.BALL_TYPE_2)
            {
               if(_self.isUsedItem)
               {
                  return;
               }
               _self.customPropEnabled = false;
               _self.deputyWeaponEnabled = false;
               _self.isUsedPetSkillWithNoItem = true;
            }
            SocketManager.Instance.out.sendPetSkill(tgt.skillInfo.ID);
            this._usedPetSkill = true;
            if(PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.USE_PET_SKILL] > 0)
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.USE_PET_SKILL);
               PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.USE_PET_SKILL] = 0;
            }
         }
      }
      
      override public function dispose() : void
      {
         var cell:PetSkillCell = null;
         this.removeEvent();
         for each(cell in this._skillCells)
         {
            cell.dispose();
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         this._skillCells = null;
         if(Boolean(this._petEnergyStrip))
         {
            ObjectUtils.disposeObject(this._petEnergyStrip);
         }
         this._petEnergyStrip = null;
         super.dispose();
      }
      
      override protected function drawCells() : void
      {
         var pos:Point = null;
         var i:int = 0;
         var cellz:PetSkillCell = null;
         var skillid:int = 0;
         var skill:PetSkill = null;
         if(Boolean(_self.currentPet))
         {
            pos = ComponentFactory.Instance.creatCustomObject("CustomPetPropCellPos");
            for(i = 0; i < this.letters.length; i++)
            {
               cellz = new PetSkillCell(this.letters[i],FightPropMode.HORIZONTAL,false,33,33);
               skillid = int(_self.currentPet.equipedSkillIDs[i]);
               if(RoomManager.Instance.current.type == RoomInfo.RING_STATION)
               {
                  cellz.creteSkillCell(null,true);
               }
               else if(skillid > 0)
               {
                  skill = new PetSkill(skillid);
                  if(_self.currentMap.info.ID == MapInfo.TANABATA_ID)
                  {
                     cellz.creteSkillCell(null,true);
                  }
                  else
                  {
                     cellz.creteSkillCell(skill,true);
                  }
                  this._skillCells.push(cellz);
               }
               else if(skillid == 0)
               {
                  cellz.creteSkillCell(null);
               }
               else
               {
                  cellz.creteSkillCell(null,true);
               }
               cellz.setPossiton(pos.x + i * 35,pos.y);
               addChild(cellz);
            }
            drawLayer();
         }
      }
   }
}

