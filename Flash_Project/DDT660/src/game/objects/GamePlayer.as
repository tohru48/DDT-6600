package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.PlayerAction;
   import ddt.data.EquipType;
   import ddt.data.FightBuffInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import ddt.view.ExpMovie;
   import ddt.view.FaceContainer;
   import ddt.view.character.GameCharacter;
   import ddt.view.character.ShowCharacter;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import ddt.view.common.DailyLeagueLevel;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.actions.GhostMoveAction;
   import game.actions.PlayerBeatAction;
   import game.actions.PlayerFallingAction;
   import game.actions.PlayerWalkAction;
   import game.actions.PrepareShootAction;
   import game.actions.SelfSkipAction;
   import game.actions.ShootBombAction;
   import game.actions.SkillActions.ResolveHurtAction;
   import game.actions.SkillActions.RevertAction;
   import game.animations.AnimationLevel;
   import game.animations.BaseSetCenterAnimation;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import horse.HorseManager;
   import horse.data.HorseSkillVo;
   import pet.date.PetSkillTemplateInfo;
   import phy.maps.Map;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.StringObject;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class GamePlayer extends GameTurnedLiving
   {
      
      protected var _player:Sprite;
      
      protected var _attackPlayerCite:MovieClip;
      
      private var _levelIcon:LevelIcon;
      
      private var _leagueRank:DailyLeagueLevel;
      
      protected var _consortiaName:FilterFrameText;
      
      private var _facecontainer:FaceContainer;
      
      private var _ballpos:Point;
      
      private var _expView:ExpMovie;
      
      private var _resolveHurtMovie:MovieClipWrapper;
      
      private var _petMovie:GamePetMovie;
      
      private var _currentPetSkill:PetSkillTemplateInfo;
      
      private var _badgeIcon:Bitmap;
      
      private var _danderFire:MovieClip;
      
      public var isShootPrepared:Boolean;
      
      public var UsedPetSkill:DictionaryData = new DictionaryData();
      
      private var _character:ShowCharacter;
      
      private var _body:GameCharacter;
      
      private var _weaponMovie:MovieClip;
      
      private var _currentWeaponMovie:MovieClip;
      
      private var _currentWeaponMovieAction:String = "";
      
      private var _tomb:TombView;
      
      private var _isNeedActRevive:Boolean = false;
      
      private var _reviveTimer:Timer;
      
      private var labelMapping:Dictionary = new Dictionary();
      
      public function GamePlayer(player:Player, character:ShowCharacter, movie:GameCharacter = null)
      {
         this._character = character;
         this._body = movie;
         super(player);
         this.initBuff();
         this._ballpos = new Point(30,-20);
         if(Boolean(player.currentPet))
         {
            this._petMovie = new GamePetMovie(player.currentPet.petInfo,this);
            this._petMovie.addEventListener(GamePetMovie.PlayEffect,this.__playPlayerEffect);
         }
      }
      
      public function replacePlayerSource(character:ShowCharacter, movie:GameCharacter) : void
      {
         this._character = character;
         this._body = movie;
      }
      
      protected function __playPlayerEffect(event:Event) : void
      {
         if(ModuleLoader.hasDefinition(this._currentPetSkill.EffectClassLink))
         {
            this.showEffect(this._currentPetSkill.EffectClassLink);
         }
      }
      
      public function get facecontainer() : FaceContainer
      {
         return this._facecontainer;
      }
      
      public function set facecontainer(value:FaceContainer) : void
      {
         this._facecontainer = value;
      }
      
      override protected function initView() : void
      {
         var gameInfo:GameInfo = null;
         var self:SelfInfo = null;
         var tmpItemInfo:ItemTemplateInfo = null;
         bodyHeight = 55;
         super.initView();
         this._player = new Sprite();
         this._player.y = -3;
         addChild(this._player);
         _nickName.x = -19;
         this._body.x = 0;
         this._body.doAction(this.getAction("stand"));
         this._player.addChild(this._body as DisplayObject);
         this._player.mouseChildren = this._player.mouseEnabled = false;
         _chatballview = new ChatBallPlayer();
         this._attackPlayerCite = ClassUtils.CreatInstance("asset.game.AttackCiteAsset") as MovieClip;
         this._attackPlayerCite.y = -75;
         this._attackPlayerCite.mouseChildren = this._attackPlayerCite.mouseEnabled = false;
         if(this.player.isAttacking && !RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._attackPlayerCite.gotoAndStop(_info.team);
            removeChild(this._attackPlayerCite);
         }
         this._levelIcon = new LevelIcon();
         this._levelIcon.setInfo(this.player.playerInfo.Grade,this.player.playerInfo.Repute,this.player.playerInfo.WinCount,this.player.playerInfo.TotalCount,this.player.playerInfo.FightPower,this.player.playerInfo.Offer,true);
         this._levelIcon.setSize(LevelIcon.SIZE_BIG);
         this._levelIcon.x = -52;
         this._levelIcon.y = _bloodStripBg.y - 5;
         addChild(this._levelIcon);
         if(Boolean(this.player.playerInfo.ConsortiaName) || Boolean(this.player.playerInfo.honor))
         {
            this._consortiaName = ComponentFactory.Instance.creatComponentByStylename("GameLiving.ConsortiaName");
            this._consortiaName.text = this.player.playerInfo.showDesignation;
            if(this.player.playerInfo.ConsortiaID != 0)
            {
               gameInfo = GameManager.Instance.Current;
               self = PlayerManager.Instance.Self;
               if(self.ConsortiaID == 0 || self.ConsortiaID == this.player.playerInfo.ConsortiaID && self.ZoneID == this.player.playerInfo.ZoneID || gameInfo && gameInfo.gameMode == 2)
               {
                  this._consortiaName.setFrame(3);
               }
               else
               {
                  this._consortiaName.setFrame(2);
               }
            }
            else
            {
               this._consortiaName.setFrame(1);
            }
            this._consortiaName.x = _nickName.x;
            this._consortiaName.y = _nickName.y + _nickName.height / 2 + 5;
            addChild(this._consortiaName);
         }
         this._expView = new ExpMovie();
         addChild(this._expView);
         this._expView.y = -60;
         this._expView.x = -50;
         this._expView.scaleX = this._expView.scaleY = 1.5;
         this._facecontainer = new FaceContainer();
         addChild(this._facecontainer);
         this._facecontainer.y = -100;
         this._facecontainer.setNickName(_nickName.text);
         if(_info.playerInfo.pvpBadgeId != 0)
         {
            tmpItemInfo = ItemManager.Instance.getTemplateById(_info.playerInfo.pvpBadgeId);
            if(Boolean(tmpItemInfo))
            {
               this._badgeIcon = ComponentFactory.Instance.creatBitmap("asset.game.badgeIcon" + tmpItemInfo.Property1);
               this._badgeIcon.x = -2;
               this._badgeIcon.y = -80;
               addChild(this._badgeIcon);
            }
         }
         if(Boolean(this._body.wing) && !_info.playerInfo.wingHide)
         {
            this.addWing();
         }
         else
         {
            this.removeWing();
         }
         _propArray = new Array();
         this.__dirChanged(null);
         if(this.player.dander >= Player.TOTAL_DANDER)
         {
            if(this._danderFire == null)
            {
               this._danderFire = MovieClip(ClassUtils.CreatInstance("asset.game.danderAsset"));
               this._danderFire.x = 3;
               this._danderFire.y = this._body.y + 5;
               this._danderFire.mouseChildren = this._danderFire.mouseEnabled = false;
            }
            this._danderFire.play();
            this._player.addChild(this._danderFire);
         }
      }
      
      private function initBuff() : void
      {
         var i:int = 0;
         var buff:FightBuffInfo = null;
         if(Boolean(_info))
         {
            _info.turnBuffs = _info.outTurnBuffs;
            _buffBar.update(_info.turnBuffs);
            if(_info.turnBuffs.length > 0)
            {
               _buffBar.x = 5 - _buffBar.width / 2;
               _buffBar.y = bodyHeight * -1 - 23;
               addChild(_buffBar);
            }
            else if(Boolean(_buffBar.parent))
            {
               _buffBar.parent.removeChild(_buffBar);
            }
            for(i = 0; i < _info.turnBuffs.length; i++)
            {
               buff = _info.turnBuffs[i];
               buff.execute(this.info);
            }
         }
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         this.player.addEventListener(LivingEvent.ADD_STATE,this.__addState);
         this.player.addEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this.player.addEventListener(LivingEvent.USING_ITEM,this.__usingItem);
         this.player.addEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         this.player.addEventListener(LivingEvent.DANDER_CHANGED,this.__danderChanged);
         this.player.addEventListener(LivingEvent.PLAYER_MOVETO,this.__playerMoveTo);
         this.player.addEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         this.player.addEventListener(LivingEvent.PET_BEAT,this.__petBeat);
         this.player.addEventListener(LivingEvent.HORSE_SKILL_USE,this.__useSkillHandler);
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         _info.addEventListener(LivingEvent.BOX_PICK,this.__boxPickHandler);
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         this.player.removeEventListener(LivingEvent.ADD_STATE,this.__addState);
         this.player.removeEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this.player.removeEventListener(LivingEvent.USING_ITEM,this.__usingItem);
         this.player.removeEventListener(LivingEvent.USING_SPECIAL_SKILL,this.__usingSpecialKill);
         this.player.removeEventListener(LivingEvent.DANDER_CHANGED,this.__danderChanged);
         this.player.removeEventListener(LivingEvent.PLAYER_MOVETO,this.__playerMoveTo);
         this.player.removeEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
         this.player.removeEventListener(LivingEvent.PET_BEAT,this.__petBeat);
         this.player.removeEventListener(LivingEvent.HORSE_SKILL_USE,this.__useSkillHandler);
         if(Boolean(this._weaponMovie))
         {
            this._weaponMovie.addEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
         }
         if(Boolean(this._petMovie))
         {
            this._petMovie.removeEventListener(GamePetMovie.PlayEffect,this.__playPlayerEffect);
         }
         ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,this.__getChat);
         ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,this.__getFace);
         _info.removeEventListener(LivingEvent.BOX_PICK,this.__boxPickHandler);
      }
      
      override public function get movie() : Sprite
      {
         return this._player;
      }
      
      protected function __boxPickHandler(e:LivingEvent) : void
      {
         if(PlayerManager.Instance.Self.FightBag.itemNumber > 3)
         {
            ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.game.gameplayer.proplist.full"));
         }
      }
      
      override protected function __applySkill(event:LivingEvent) : void
      {
         var paras:Array = event.paras;
         var skill:int = int(paras[0]);
         switch(skill)
         {
            case SkillType.ResolveHurt:
               this.applyResolveHurt(paras[1]);
               break;
            case SkillType.Revert:
               this.applyRevert(paras[1]);
         }
      }
      
      private function applyRevert(pkg:PackageIn) : void
      {
         map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,1,false,AnimationLevel.HIGHT));
         map.act(new RevertAction(map.spellKill(this),this.player,pkg));
      }
      
      private function applyResolveHurt(pkg:PackageIn) : void
      {
         map.animateSet.addAnimation(new BaseSetCenterAnimation(x,y - 150,1,false,AnimationLevel.HIGHT));
         map.act(new ResolveHurtAction(map.spellKill(this),this.player,pkg));
      }
      
      protected function __addState(event:LivingEvent) : void
      {
      }
      
      protected function __useSkillHandler(event:LivingEvent) : void
      {
         var horseSkillVo:HorseSkillVo = HorseManager.instance.getHorseSkillInfoById(event.paras[0]);
         if(Boolean(horseSkillVo) && horseSkillVo.Pic != "-1")
         {
            _propArray.push(horseSkillVo.Pic);
            this.doUseItemAnimation();
         }
      }
      
      protected function __usingItem(event:LivingEvent) : void
      {
         var prop:ItemTemplateInfo = null;
         if(event.paras[0] is ItemTemplateInfo)
         {
            prop = event.paras[0];
            _propArray.push(prop.Pic);
            this.doUseItemAnimation(EquipType.hasPropAnimation(event.paras[0]) != null);
         }
         else if(event.paras[0] is DisplayObject)
         {
            _propArray.push(event.paras[0]);
            this.doUseItemAnimation();
         }
      }
      
      protected function __usingSpecialKill(event:LivingEvent) : void
      {
         _propArray.push("-1");
         this.doUseItemAnimation();
      }
      
      override protected function doUseItemAnimation(skip:Boolean = false) : void
      {
         var using:MovieClipWrapper = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset")),true,true);
         using.addFrameScriptAt(12,headPropEffect);
         SoundManager.instance.play("039");
         using.movie.x = 0;
         using.movie.y = -10;
         if(!skip)
         {
            addChild(using.movie);
         }
         if(_isLiving)
         {
            this.doAction(this._body.handClipAction);
            this.body.WingState = GameCharacter.GAME_WING_CLIP;
         }
      }
      
      protected function __danderChanged(event:LivingEvent) : void
      {
         if(this.player.dander >= Player.TOTAL_DANDER && _isLiving)
         {
            if(this._danderFire == null)
            {
               this._danderFire = MovieClip(ClassUtils.CreatInstance("asset.game.danderAsset"));
               this._danderFire.x = 3;
               this._danderFire.y = this._body.y + 5;
               this._danderFire.mouseEnabled = false;
               this._danderFire.mouseChildren = false;
            }
            this._danderFire.play();
            this._player.addChild(this._danderFire);
         }
         else if(Boolean(this._danderFire) && Boolean(this._danderFire.parent))
         {
            this._danderFire.stop();
            this._player.removeChild(this._danderFire);
         }
      }
      
      override protected function __posChanged(event:LivingEvent) : void
      {
         pos = this.player.pos;
         if(_isLiving)
         {
            this._player.rotation = calcObjectAngle();
            this.player.playerAngle = this._player.rotation;
         }
         this.playerMove();
         if(Boolean(map) && Boolean(map.smallMap))
         {
            map.smallMap.updatePos(smallView,pos);
         }
      }
      
      public function playerMove() : void
      {
      }
      
      override protected function __dirChanged(event:LivingEvent) : void
      {
         super.__dirChanged(event);
         if(Boolean(this._facecontainer))
         {
            this._facecontainer.scaleX = 1;
         }
         if(!this.player.isLiving)
         {
            this.setSoulPos();
         }
      }
      
      override protected function __attackingChanged(event:LivingEvent) : void
      {
         super.__attackingChanged(event);
         this.attackingViewChanged();
      }
      
      protected function attackingViewChanged() : void
      {
         if(this.player.isAttacking && this.player.isLiving)
         {
            this._attackPlayerCite.gotoAndStop(_info.team);
            addChild(this._attackPlayerCite);
         }
         else if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
      }
      
      override protected function __hiddenChanged(event:LivingEvent) : void
      {
         super.__hiddenChanged(event);
         if(_info.isHidden)
         {
            if(Boolean(_chatballview))
            {
               _chatballview.visible = false;
            }
         }
      }
      
      override protected function __say(event:LivingEvent) : void
      {
         var data:String = null;
         var type:int = 0;
         if(!_info.isHidden)
         {
            data = event.paras[0];
            type = 0;
            if(Boolean(event.paras[1]))
            {
               type = int(event.paras[1]);
            }
            if(type != 9)
            {
               type = this.player.playerInfo.paopaoType;
            }
            this.say(data,type);
         }
      }
      
      override protected function __bloodChanged(event:LivingEvent) : void
      {
         super.__bloodChanged(event);
         if(event.paras[0] != 0)
         {
            if(_isLiving)
            {
               this._body.doAction(this.getAction("cry"));
               this._body.WingState = GameCharacter.GAME_WING_CRY;
            }
         }
         updateBloodStrip();
      }
      
      override protected function __shoot(event:LivingEvent) : void
      {
         var bombs:Array = event.paras[0];
         this.player.currentBomb = bombs[0].Template.ID;
         if((RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM || RoomManager.Instance.current.type == RoomInfo.STONEEXPLORE_ROOM) && !(this is GameLocalPlayer))
         {
            act(new PrepareShootAction(this));
            act(new ShootBombAction(this,bombs,event.paras[1],_info.shootInterval));
         }
         else
         {
            map.act(new PrepareShootAction(this));
            map.act(new ShootBombAction(this,bombs,event.paras[1],_info.shootInterval));
         }
      }
      
      protected function shootIntervalDegression() : void
      {
         if(_info.shootInterval == 12)
         {
            _info.shootInterval = 9;
            return;
         }
         if(_info.shootInterval == 9)
         {
            _info.shootInterval = 5;
            return;
         }
      }
      
      override protected function __beat(event:LivingEvent) : void
      {
         act(new PlayerBeatAction(this));
      }
      
      protected function __usePetSkill(event:LivingEvent) : void
      {
         var skill:PetSkillTemplateInfo = PetSkillManager.getSkillByID(event.value);
         if(skill == null)
         {
            throw new Error("找不到技能，技能ID为：" + event.value);
         }
         if(skill.isActiveSkill)
         {
            switch(skill.BallType)
            {
               case PetSkillTemplateInfo.BALL_TYPE_0:
                  this.usePetSkill(skill);
                  break;
               case PetSkillTemplateInfo.BALL_TYPE_1:
                  if(GameManager.Instance.Current.selfGamePlayer.team == info.team)
                  {
                     GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                  }
                  break;
               case PetSkillTemplateInfo.BALL_TYPE_2:
                  if(GameManager.Instance.Current.selfGamePlayer.team == info.team)
                  {
                     GameManager.Instance.Current.selfGamePlayer.soulPropEnabled = false;
                  }
                  this.usePetSkill(skill,this.skipSelfTurn);
                  break;
               case PetSkillTemplateInfo.BALL_TYPE_3:
                  this.usePetSkill(skill);
            }
            this.UsedPetSkill.add(skill.ID,skill);
            SoundManager.instance.play("039");
         }
      }
      
      private function __petBeat(event:LivingEvent) : void
      {
         var actName:String = event.paras[0];
         var pt:Point = event.paras[1];
         var targets:Array = event.paras[2];
         this.playPetMovie(actName,pt,this.updateHp,[targets]);
      }
      
      private function playPetMovie(actName:String, pt:Point, callBack:Function = null, args:Array = null) : void
      {
         if(!this._petMovie)
         {
            return;
         }
         this._petMovie.show(pt.x,pt.y);
         this._petMovie.direction = info.direction;
         if(callBack == null)
         {
            this._petMovie.doAction(actName,this.hidePetMovie);
         }
         else
         {
            this._petMovie.doAction(actName,callBack,args);
         }
      }
      
      public function hidePetMovie() : void
      {
         if(Boolean(this._petMovie))
         {
            this._petMovie.hide();
         }
      }
      
      private function updateHp(targets:Array) : void
      {
         var target:Object = null;
         var t:Living = null;
         var hp:int = 0;
         var damage:int = 0;
         var dander:int = 0;
         for each(target in targets)
         {
            t = target.target;
            hp = int(target.hp);
            damage = int(target.damage);
            dander = int(target.dander);
            t.updateBlood(hp,3,damage);
            if(t is Player)
            {
               Player(t).dander = dander;
            }
         }
         if(Boolean(this._petMovie))
         {
            this._petMovie.hide();
         }
      }
      
      public function usePetSkill(skill:PetSkillTemplateInfo, callback:Function = null) : void
      {
         this._currentPetSkill = skill;
         this.playPetMovie(skill.Action,_info.pos,callback);
      }
      
      private function skipSelfTurn() : void
      {
         this.hidePetMovie();
         if(info is LocalPlayer)
         {
            act(new SelfSkipAction(LocalPlayer(info)));
         }
      }
      
      protected function __playerMoveTo(event:LivingEvent) : void
      {
         var type:int = int(event.paras[0]);
         switch(type)
         {
            case 0:
               act(new PlayerWalkAction(this,event.paras[1],event.paras[2],this.getAction("walk")));
               break;
            case 1:
               act(new PlayerFallingAction(this,event.paras[1],event.paras[3],false));
               break;
            case 2:
               act(new GhostMoveAction(this,event.paras[1],event.paras[4]));
               break;
            case 3:
               act(new PlayerFallingAction(this,event.paras[1],event.paras[3],true));
               break;
            case 4:
               act(new PlayerWalkAction(this,event.paras[1],event.paras[2],this.getAction("stand")));
         }
      }
      
      override protected function __fall(event:LivingEvent) : void
      {
         act(new PlayerFallingAction(this,event.paras[0],true,false));
      }
      
      override protected function __jump(event:LivingEvent) : void
      {
      }
      
      private function setSoulPos() : void
      {
         if(this._player.scaleX == -1)
         {
            this._body.x = -6;
         }
         else
         {
            this._body.x = -13;
         }
      }
      
      public function get character() : ShowCharacter
      {
         return this._character;
      }
      
      public function get body() : GameCharacter
      {
         return this._body;
      }
      
      public function get player() : Player
      {
         return info as Player;
      }
      
      private function addWing() : void
      {
         if(this._body.wing == null)
         {
            return;
         }
         this._body.setWingPos(this._body.weaponX * this._body.scaleX,this._body.weaponY * this._body.scaleY);
         this._body.setWingScale(this._body.scaleX,this._body.scaleY);
         if(Boolean(this._body.leftWing) && this._body.leftWing.parent != this._player)
         {
            this._player.addChild(this._body.rightWing);
            this._player.addChildAt(this._body.leftWing,0);
         }
         this._body.switchWingVisible(_info.isLiving);
         this._body.WingState = GameCharacter.GAME_WING_WAIT;
      }
      
      private function removeWing() : void
      {
         if(Boolean(this._body.leftWing) && Boolean(this._body.leftWing.parent))
         {
            this._body.leftWing.parent.removeChild(this._body.leftWing);
         }
         if(Boolean(this._body.rightWing) && Boolean(this._body.rightWing.parent))
         {
            this._body.rightWing.parent.removeChild(this._body.rightWing);
         }
      }
      
      public function get weaponMovie() : MovieClip
      {
         return this._weaponMovie;
      }
      
      public function set weaponMovie(value:MovieClip) : void
      {
         if(value != this._weaponMovie)
         {
            if(Boolean(this._weaponMovie) && Boolean(this._weaponMovie.parent))
            {
               this._weaponMovie.removeEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
               this._weaponMovie.parent.removeChild(this._weaponMovie);
            }
            this._weaponMovie = value;
            this._currentWeaponMovie = null;
            this._currentWeaponMovieAction = "";
            if(Boolean(this._weaponMovie))
            {
               this._weaponMovie.stop();
               this._weaponMovie.addEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
               this._weaponMovie.x = this._body.weaponX * this._body.scaleX;
               this._weaponMovie.y = this._body.weaponY * this._body.scaleY;
               this._weaponMovie.scaleX = this._body.scaleX;
               this._weaponMovie.scaleY = this._body.scaleY;
               this._weaponMovie.visible = false;
               this._player.addChild(this._weaponMovie);
               if(Boolean(this._body.wing) && !_info.playerInfo.wingHide)
               {
                  this.addWing();
               }
               else
               {
                  this.removeWing();
               }
            }
         }
      }
      
      private function checkCurrentMovie(e:Event) : void
      {
         if(this._weaponMovie == null)
         {
            return;
         }
         this._currentWeaponMovie = this._weaponMovie.getChildAt(0) as MovieClip;
         if(Boolean(this._currentWeaponMovie) && this._currentWeaponMovieAction != "")
         {
            this._weaponMovie.removeEventListener(Event.ENTER_FRAME,this.checkCurrentMovie);
            this.setWeaponMoiveActionSyc(this._currentWeaponMovieAction);
         }
      }
      
      public function setWeaponMoiveActionSyc(action:String) : void
      {
         if(Boolean(this._currentWeaponMovie))
         {
            this._currentWeaponMovie.gotoAndPlay(action);
         }
         else
         {
            this._currentWeaponMovieAction = action;
         }
      }
      
      override public function die() : void
      {
         super.die();
         this.player.isSpecialSkill = false;
         this.player.skill = -1;
         SoundManager.instance.play("042");
         this.weaponMovie = null;
         this._player.rotation = 0;
         this._player.y = 25;
         if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
         _HPStrip.visible = false;
         _bloodStripBg.visible = false;
         this._tomb = new TombView();
         this._tomb.pos = this.pos;
         if(Boolean(_map))
         {
            _map.addPhysical(this._tomb);
         }
         this._tomb.startMoving();
         this.player.pos = new Point(x,y - 70);
         this.player.startMoving();
         if(Boolean(RoomManager.Instance.current) && (RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM || RoomManager.Instance.current.type == RoomInfo.STONEEXPLORE_ROOM))
         {
            this._tomb.addEventListener(GameEvent.UPDATE_NAMEPOS,this.__updateNamePos);
            this._player.visible = false;
         }
         else
         {
            this.doAction(GameCharacter.SOUL);
         }
         this.setSoulPos();
         _nickName.y += 10;
         if(Boolean(this._consortiaName))
         {
            this._consortiaName.y += 10;
         }
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.y += 20;
         }
         if(Boolean(this._leagueRank))
         {
            this._leagueRank.y += 20;
         }
         if(Boolean(_map))
         {
            _map.setTopPhysical(this);
         }
         if(Boolean(this._danderFire) && Boolean(this._danderFire.parent))
         {
            this._danderFire.parent.removeChild(this._danderFire);
         }
         this._danderFire = null;
         if(Boolean(this._petMovie))
         {
            this._petMovie.dispose();
         }
         this._petMovie = null;
         this._isNeedActRevive = false;
      }
      
      protected function __updateNamePos(event:Event) : void
      {
         this.y = this._tomb.y - 30;
      }
      
      override public function revive() : void
      {
         this._isNeedActRevive = true;
         var tmpMc:MovieClip = ComponentFactory.Instance.creat("asset.game.skill.reviveMc");
         var tmpMcW:MovieClipWrapper = new MovieClipWrapper(tmpMc,true,true);
         tmpMcW.addEventListener(Event.COMPLETE,this.reviveCompleteHandler,false,0,true);
         addChild(tmpMcW.movie);
         if(!this._reviveTimer)
         {
            this._reviveTimer = new Timer(2500);
            this._reviveTimer.addEventListener(TimerEvent.TIMER,this.insureActRevive,false,0,true);
         }
         this._reviveTimer.start();
      }
      
      private function reviveCompleteHandler(event:Event) : void
      {
         var tmpMcW:MovieClipWrapper = null;
         if(Boolean(event))
         {
            tmpMcW = event.currentTarget as MovieClipWrapper;
            tmpMcW.removeEventListener(Event.COMPLETE,this.reviveCompleteHandler);
         }
         if(!this._isNeedActRevive)
         {
            return;
         }
         super.revive();
         ObjectUtils.disposeObject(this._tomb);
         this._tomb = null;
         this._player.visible = true;
         this.doAction(GameCharacter.STAND_LACK_HP);
         if(Boolean(this.player.currentPet))
         {
            this._petMovie = new GamePetMovie(this.player.currentPet.petInfo,this);
            this._petMovie.addEventListener(GamePetMovie.PlayEffect,this.__playPlayerEffect);
         }
         this._player.y = -3;
         _nickName.y -= 10;
         if(Boolean(this._consortiaName))
         {
            this._consortiaName.y -= 10;
         }
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.y -= 20;
         }
         if(Boolean(this._leagueRank))
         {
            this._leagueRank.y -= 20;
         }
         _HPStrip.visible = true;
         _bloodStripBg.visible = true;
         this._isNeedActRevive = false;
      }
      
      private function insureActRevive(event:TimerEvent) : void
      {
         this.reviveCompleteHandler(null);
         if(!this._isNeedActRevive)
         {
            if(Boolean(this._reviveTimer))
            {
               this._reviveTimer.stop();
            }
         }
      }
      
      public function clearDebuff() : void
      {
         var tmpMc:MovieClip = ComponentFactory.Instance.creat("asset.game.skill.clearDebuffMc");
         var tmpMcW:MovieClipWrapper = new MovieClipWrapper(tmpMc,true,true);
         addChild(tmpMcW.movie);
      }
      
      override protected function __beginNewTurn(event:LivingEvent) : void
      {
         super.__beginNewTurn(event);
         this.UsedPetSkill.clear();
         if(_isLiving)
         {
            this._body.doAction(this._body.standAction);
            this._body.randomCryType();
         }
         this.weaponMovie = null;
         this.player.skill = -1;
         this.isShootPrepared = false;
         _info.shootInterval = Player.SHOOT_INTERVAL;
         if(contains(this._attackPlayerCite))
         {
            removeChild(this._attackPlayerCite);
         }
      }
      
      private function __getChat(evt:ChatEvent) : void
      {
         if(this.player.isHidden && this.player.team != GameManager.Instance.Current.selfGamePlayer.team)
         {
            return;
         }
         var data:ChatData = ChatData(evt.data).clone();
         data.msg = Helpers.deCodeString(data.msg);
         if(data.channel == 2 || data.channel == 3)
         {
            return;
         }
         if(data.zoneID == -1)
         {
            if(data.senderID == this.player.playerInfo.ID)
            {
               this.say(data.msg,this.player.playerInfo.paopaoType);
            }
         }
         else if(data.senderID == this.player.playerInfo.ID && data.zoneID == this.player.playerInfo.ZoneID)
         {
            this.say(data.msg,this.player.playerInfo.paopaoType);
         }
      }
      
      private function say(msg:String, paopaoType:int) : void
      {
         _chatballview.setText(msg,paopaoType);
         addChild(_chatballview);
         fitChatBallPos();
      }
      
      override protected function get popPos() : Point
      {
         if(!_info.isLiving)
         {
            return new Point(18,-20);
         }
         return new Point(18,-40);
      }
      
      override protected function get popDir() : Point
      {
         return null;
      }
      
      private function __getFace(evt:ChatEvent) : void
      {
         var id:int = 0;
         var delay:int = 0;
         if(this.player.isHidden && this.player.team != GameManager.Instance.Current.selfGamePlayer.team)
         {
            return;
         }
         var data:Object = evt.data;
         if(data["playerid"] == this.player.playerInfo.ID)
         {
            id = int(data["faceid"]);
            delay = int(data["delay"]);
            if(id >= 49)
            {
               setTimeout(this.showFace,delay,id);
            }
            else
            {
               this.showFace(id);
            }
            if(id < 49 && id > 0)
            {
               ChatManager.Instance.dispatchEvent(new ChatEvent(ChatEvent.SET_FACECONTIANER_LOCTION));
            }
         }
      }
      
      private function showFace(id:int) : void
      {
         if(this._facecontainer == null)
         {
            return;
         }
         this._facecontainer.scaleX = 1;
         this._facecontainer.setFace(id);
      }
      
      public function shootPoint() : Point
      {
         var p:Point = this._ballpos;
         p = this._body.localToGlobal(p);
         return _map.globalToLocal(p);
      }
      
      override public function doAction(actionType:*) : void
      {
         if(actionType is PlayerAction)
         {
            this._body.doAction(actionType);
         }
      }
      
      override public function dispose() : void
      {
         this.removeListener();
         super.dispose();
         if(Boolean(_chatballview))
         {
            _chatballview.dispose();
            _chatballview = null;
         }
         if(Boolean(this._facecontainer))
         {
            this._facecontainer.dispose();
            this._facecontainer = null;
         }
         if(Boolean(this._petMovie))
         {
            this._petMovie.dispose();
         }
         this._petMovie = null;
         if(Boolean(this._consortiaName))
         {
            ObjectUtils.disposeObject(this._consortiaName);
         }
         this._consortiaName = null;
         ObjectUtils.disposeObject(this._badgeIcon);
         this._badgeIcon = null;
         if(Boolean(this._attackPlayerCite))
         {
            if(Boolean(this._attackPlayerCite.parent))
            {
               this._attackPlayerCite.parent.removeChild(this._attackPlayerCite);
            }
         }
         this._attackPlayerCite = null;
         this._character = null;
         this._body = null;
         if(Boolean(this._weaponMovie))
         {
            this._weaponMovie.stop();
            this._weaponMovie = null;
         }
         if(Boolean(this._danderFire) && Boolean(this._danderFire.parent))
         {
            this._danderFire.stop();
            this._player.removeChild(this._danderFire);
         }
         if(Boolean(this._levelIcon))
         {
            if(Boolean(this._levelIcon.parent))
            {
               this._levelIcon.parent.removeChild(this._levelIcon);
            }
            this._levelIcon.dispose();
         }
         this._levelIcon = null;
         if(Boolean(this._leagueRank))
         {
            ObjectUtils.disposeObject(this._leagueRank);
         }
         this._leagueRank = null;
         ObjectUtils.disposeObject(this._expView);
         this._expView = null;
         ObjectUtils.disposeObject(this._tomb);
         this._tomb = null;
         if(Boolean(this._reviveTimer))
         {
            this._reviveTimer.removeEventListener(TimerEvent.TIMER,this.insureActRevive);
            this._reviveTimer.stop();
         }
         this._reviveTimer = null;
      }
      
      override protected function __bombed(event:LivingEvent) : void
      {
         this.body.bombed();
      }
      
      override public function setMap(map:Map) : void
      {
         super.setMap(map);
         if(Boolean(map))
         {
            this.__posChanged(null);
         }
      }
      
      override public function setProperty(property:String, value:String) : void
      {
         var vo:StringObject = null;
         var gainEXP:Number = NaN;
         vo = new StringObject(value);
         switch(property)
         {
            case "GhostGPUp":
               gainEXP = vo.getInt();
               this._expView.exp = gainEXP;
               this._expView.play();
               this._body.doAction(GameCharacter.SOUL_SMILE);
         }
         super.setProperty(property,value);
      }
      
      public function set gainEXP(value:int) : void
      {
         _nickName.text = String(value);
      }
      
      override public function setActionMapping(source:String, target:String) : void
      {
         if(source.length <= 0)
         {
            return;
         }
         this.labelMapping[source] = target;
      }
      
      public function getAction(type:String) : PlayerAction
      {
         if(Boolean(this.labelMapping[type]))
         {
            type = this.labelMapping[type];
         }
         switch(type)
         {
            case "stand":
               return this._body.standAction;
            case "walk":
               return this._body.walkAction;
            case "cry":
               return GameCharacter.CRY;
            case "soul":
               return GameCharacter.SOUL;
            default:
               return this._body.standAction;
         }
      }
   }
}

