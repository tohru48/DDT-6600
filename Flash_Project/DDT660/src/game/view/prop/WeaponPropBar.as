package game.view.prop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.player.ConsortiaBattlePlayerInfo;
   import consortionBattle.view.ConsBatLosingStreakBuff;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.controller.NewHandGuideManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class WeaponPropBar extends FightPropBar
   {
      
      private var _canEnable:Boolean = true;
      
      protected var _losingStreakIcon:ConsBatLosingStreakBuff;
      
      private var _localFlyVisible:Boolean = true;
      
      private var _localDeputyWeaponVisible:Boolean = true;
      
      private var _localVisible:Boolean = true;
      
      public function WeaponPropBar(self:LocalPlayer)
      {
         super(self);
         this._canEnable = this.weaponEnabled();
         this.updatePropByEnergy();
         this.initLosingStreakInConsBat();
      }
      
      private function initLosingStreakInConsBat() : void
      {
         if(RoomManager.Instance.current.type != RoomInfo.CONSORTIA_BATTLE)
         {
            return;
         }
         var tmp:ConsortiaBattlePlayerInfo = ConsortiaBattleManager.instance.getPlayerInfo(PlayerManager.Instance.Self.ID);
         if(tmp.failBuffCount > 0)
         {
            this._losingStreakIcon = ComponentFactory.Instance.creatComponentByStylename("gameView.ConsBatLosingStreakBuff");
            addChild(this._losingStreakIcon);
            if(Boolean(_cells[1]))
            {
               _cells[1].visible = false;
            }
         }
      }
      
      private function weaponEnabled() : Boolean
      {
         var template:ItemTemplateInfo = null;
         var roomType:int = 0;
         if(RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
         {
            template = _self.playerInfo.SnapDeputyWeapon as ItemTemplateInfo;
         }
         else
         {
            template = _self.currentDeputyWeaponInfo.Template;
         }
         if(template.TemplateID == EquipType.WishKingBlessing)
         {
            roomType = RoomManager.Instance.current.type;
            if(roomType == RoomInfo.DUNGEON_ROOM || roomType == RoomInfo.ACADEMY_DUNGEON_ROOM || roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM || roomType == RoomInfo.WORLD_BOSS_FIGHT || StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
            {
               return false;
            }
         }
         if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BATTLE)
         {
            return false;
         }
         return true;
      }
      
      override protected function updatePropByEnergy() : void
      {
         _cells[0].enabled = _self.flyEnabled;
         if(!this._canEnable)
         {
            _self.deputyWeaponEnabled = false;
            _cells[1].setGrayFilter();
            _cells[1].removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
         _cells[1].enabled = _self.deputyWeaponEnabled;
         if(!_self.flyEnabled)
         {
            this.hideGuidePlane();
         }
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.FIGHTGROUND_ROOM)
         {
            _cells[1].info = null;
            _cells[1].removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
      }
      
      override protected function __itemClicked(event:MouseEvent) : void
      {
         var result:String = null;
         var templateid:int = 0;
         if(!this._localVisible)
         {
            return;
         }
         var cell:PropCell = event.currentTarget as PropCell;
         SoundManager.instance.play("008");
         var idx:int = int(_cells.indexOf(cell));
         switch(idx)
         {
            case 0:
               if(!this._localFlyVisible)
               {
                  return;
               }
               result = _self.useFly();
               break;
            case 1:
               if(!this._localDeputyWeaponVisible)
               {
                  return;
               }
               if(_self.isLocked)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.onlyFly"));
                  return;
               }
               result = _self.useDeputyWeapon();
               if(!_self.currentDeputyWeaponInfo.isShield)
               {
                  _self.rightPropEnabled = false;
               }
               break;
            default:
               result = UsePropErrorCode.None;
         }
         if(result == UsePropErrorCode.FlyNotCoolDown)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.NotCoolDown",_self.flyCoolDown));
         }
         else if(result == UsePropErrorCode.DeputyWeaponNotCoolDown)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop.NotCoolDown",_self.deputyWeaponCoolDown));
         }
         else if(result == UsePropErrorCode.DeputyWeaponEmpty)
         {
            templateid = RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM ? _self.selfInfo.SnapDeputyWeapon.TemplateID : _self.selfInfo.DeputyWeapon.TemplateID;
            switch(templateid)
            {
               case EquipType.Angle:
               case EquipType.TrueAngle:
               case EquipType.ExllenceAngle:
               case EquipType.FlyAngle:
               case EquipType.FlyAngleI:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse"));
                  break;
               case EquipType.TrueShield:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse2"));
                  break;
               case EquipType.ExcellentShield:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse3"));
                  break;
               case EquipType.WishKingBlessing:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.deputyWeapon.canNotUse4"));
            }
         }
         else if(result != UsePropErrorCode.None)
         {
            if(result != "LockState" || RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + result));
            }
         }
         else if(idx == 0)
         {
            this.hideGuidePlane();
            if(NewHandGuideManager.Instance.mapID == 115)
            {
               if(_self.pos.x < 990)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.view.arrow.ArrowView.energy"));
               }
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_PLANE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.PLANE_OPEN))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.view.arrow.ArrowView.energy"));
            }
         }
         StageReferance.stage.focus = null;
      }
      
      override protected function __keyDown(event:KeyboardEvent) : void
      {
         if(GameManager.Instance.Current.mapIndex == 1405)
         {
            return;
         }
         switch(event.keyCode)
         {
            case KeyStroke.VK_F.getCode():
               _cells[0].useProp();
               break;
            case KeyStroke.VK_R.getCode():
               if(_self.isLocked)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.campBattle.onlyFly"));
                  return;
               }
               if(RoomManager.Instance.current.type != RoomInfo.FIGHTGROUND_ROOM && RoomManager.Instance.current.type != RoomInfo.CONSORTIA_BATTLE)
               {
                  _cells[1].useProp();
               }
               break;
         }
         super.__keyDown(event);
      }
      
      override protected function addEvent() : void
      {
         var cell:PropCell = null;
         _self.addEventListener(LivingEvent.FLY_CHANGED,this.__flyChanged);
         _self.addEventListener(LivingEvent.DEPUTYWEAPON_CHANGED,this.__deputyWeaponChanged);
         _self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
         for each(cell in _cells)
         {
            cell.addEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
         super.addEvent();
      }
      
      override protected function __changeAttack(event:LivingEvent) : void
      {
         if(_self.isAttacking)
         {
            this.showGuidePlane();
            this.updatePropByEnergy();
         }
         else
         {
            this.hideGuidePlane();
         }
      }
      
      private function showGuidePlane() : void
      {
         if(NewHandGuideManager.Instance.mapID == 115)
         {
            if(_self.pos.x < 990)
            {
               if(_self.flyEnabled)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.TIP_PLANE,30,"trainer.posPlaneI");
               }
            }
         }
      }
      
      private function hideGuidePlane() : void
      {
         if(NewHandContainer.Instance.hasArrow(ArrowType.TIP_PLANE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_PLANE);
         }
      }
      
      private function __setDeputyWeaponNumber(event:CrazyTankSocketEvent) : void
      {
         var count:int = event.pkg.readInt();
         _cells[1].enabled = count != 0;
         WeaponPropCell(_cells[1]).setCount(count);
      }
      
      private function __deputyWeaponChanged(event:LivingEvent) : void
      {
         if(!this._canEnable)
         {
            _self.deputyWeaponEnabled = false;
         }
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.FIGHTGROUND_ROOM)
         {
            return;
         }
         _cells[1].enabled = _self.deputyWeaponEnabled;
         if(this._canEnable)
         {
            if(RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
            {
               WeaponPropCell(_cells[1]).setCount(_self.snapDeputyWeaponCount);
            }
            else if(RoomManager.Instance.current.type != RoomInfo.TRANSNATIONALFIGHT_ROOM)
            {
               WeaponPropCell(_cells[1]).setCount(_self.deputyWeaponCount);
            }
         }
      }
      
      private function __flyChanged(event:LivingEvent) : void
      {
         _cells[0].enabled = _self.flyEnabled;
         if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BATTLE)
         {
            (_cells[0] as WeaponPropCell).setCount(_self.flyCount);
            if(_self.flyCount <= 0)
            {
               _cells[0].setGrayFilter();
               _cells[0].removeEventListener(MouseEvent.CLICK,this.__itemClicked);
            }
         }
      }
      
      override protected function configUI() : void
      {
         _background = ComponentFactory.Instance.creatBitmap("asset.game.prop.WeaponBack");
         addChild(_background);
         super.configUI();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._losingStreakIcon))
         {
            ObjectUtils.disposeObject(this._losingStreakIcon);
            this._losingStreakIcon = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      override protected function drawCells() : void
      {
         var pos:Point = null;
         var template:ItemTemplateInfo = null;
         var cellf:WeaponPropCell = new WeaponPropCell("f",_mode);
         cellf.info = new PropInfo(ItemManager.Instance.getTemplateById(10016));
         pos = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPosf");
         cellf.setPossiton(pos.x,pos.y);
         addChild(cellf);
         var cellr:WeaponPropCell = new WeaponPropCell("r",_mode);
         pos = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPosr");
         cellr.setPossiton(pos.x,pos.y);
         addChild(cellr);
         if(_self.hasDeputyWeapon() || RoomManager.Instance.isTransnationalFight())
         {
            if(RoomManager.Instance.isTransnationalFight())
            {
               template = _self.playerInfo.SnapDeputyWeapon;
            }
            else
            {
               template = _self.currentDeputyWeaponInfo.Template;
            }
            if(template.TemplateID == EquipType.WishKingBlessing)
            {
               template.Property4 = _self.wishKingEnergy.toString();
               _self.currentDeputyWeaponInfo.energy = _self.wishKingEnergy;
               cellr.info = new PropInfo(template);
               _self.snapDeputyWeaponCount = _self.wishKingCount;
               cellr.setCount(_self.wishKingCount);
            }
            else
            {
               cellr.info = new PropInfo(template);
               if(RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
               {
                  cellr.setCount(_self.snapDeputyWeaponCount);
               }
               else
               {
                  cellr.setCount(_self.deputyWeaponCount);
               }
            }
         }
         _cells.push(cellf);
         _cells.push(cellr);
         super.drawCells();
      }
      
      override protected function removeEvent() : void
      {
         var cell:PropCell = null;
         _self.removeEventListener(LivingEvent.FLY_CHANGED,this.__flyChanged);
         _self.removeEventListener(LivingEvent.DEPUTYWEAPON_CHANGED,this.__deputyWeaponChanged);
         _self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
         for each(cell in _cells)
         {
            cell.removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
         super.removeEvent();
      }
      
      public function setFlyVisible(val:Boolean) : void
      {
         if(this._localFlyVisible != val)
         {
            this._localFlyVisible = val;
            if(this._localFlyVisible)
            {
               if(!_cells[0].parent)
               {
                  addChild(_cells[0]);
               }
            }
            else if(Boolean(_cells[0].parent))
            {
               _cells[0].parent.removeChild(_cells[0]);
            }
         }
      }
      
      public function setDeputyWeaponVisible(val:Boolean) : void
      {
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.FIGHTGROUND_ROOM)
         {
            return;
         }
         if(this._localDeputyWeaponVisible != val)
         {
            this._localDeputyWeaponVisible = val;
            if(this._localDeputyWeaponVisible)
            {
               if(!_cells[1].parent)
               {
                  addChild(_cells[1]);
               }
            }
            else if(Boolean(_cells[1].parent))
            {
               _cells[1].parent.removeChild(_cells[1]);
            }
         }
      }
      
      public function setVisible(val:Boolean) : void
      {
         this._localVisible = val;
      }
   }
}

