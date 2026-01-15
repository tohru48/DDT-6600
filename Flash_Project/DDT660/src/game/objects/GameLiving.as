package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffType;
   import ddt.events.LivingCommandEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import ddt.view.chat.chatBall.ChatBallBase;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameManager;
   import game.actions.BaseAction;
   import game.actions.LivingFallingAction;
   import game.actions.LivingJumpAction;
   import game.actions.LivingMoveAction;
   import game.actions.LivingTurnAction;
   import game.animations.ShockMapAnimation;
   import game.model.Living;
   import game.model.Player;
   import game.model.SimpleBoss;
   import game.model.SmallEnemy;
   import game.view.AutoPropEffect;
   import game.view.EffectIconContainer;
   import game.view.IDisplayPack;
   import game.view.LeftPlayerCartoonView;
   import game.view.buff.FightBuffBar;
   import game.view.effects.BaseMirariEffectIcon;
   import game.view.effects.ShootPercentView;
   import game.view.effects.ShowEffect;
   import game.view.map.MapView;
   import game.view.smallMap.SmallLiving;
   import game.view.smallMap.SmallPlayer;
   import phy.object.PhysicalObj;
   import phy.object.PhysicsLayer;
   import phy.object.SmallObject;
   import road.game.resource.ActionMovie;
   import road.game.resource.ActionMovieEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.data.StringObject;
   import road7th.utils.AutoDisappear;
   import road7th.utils.MovieClipWrapper;
   import tank.events.ActionEvent;
   
   public class GameLiving extends PhysicalObj
   {
      
      protected static var SHOCK_EVENT:String = "shockEvent";
      
      protected static var SHOCK_EVENT2:String = "shockEvent2";
      
      protected static var SHIELD:String = "shield";
      
      protected static var BOMB_EVENT:String = "bombEvent";
      
      public static var SHOOT_PREPARED:String = "shootPrepared";
      
      protected static var RENEW:String = "renew";
      
      protected static var NEED_FOCUS:String = "focus";
      
      protected static var PLAY_EFFECT:String = "playeffect";
      
      protected static var PLAYER_EFFECT:String = "effect";
      
      protected static var ATTACK_COMPLETE_FOCUS:String = "attackCompleteFocus";
      
      public static const stepY:int = 7;
      
      public static const npcStepX:int = 1;
      
      public static const npcStepY:int = 3;
      
      protected var _info:Living;
      
      protected var _actionMovie:ActionMovie;
      
      protected var _chatballview:ChatBallBase;
      
      protected var _smallView:SmallLiving;
      
      protected var speedMult:int = 1;
      
      protected var _nickName:FilterFrameText;
      
      protected var _targetBlood:int;
      
      protected var targetAttackEffect:int;
      
      protected var _originalHeight:Number;
      
      protected var _originalWidth:Number;
      
      public var bodyWidth:Number;
      
      public var bodyHeight:Number;
      
      public var isExist:Boolean = true;
      
      protected var _turns:int;
      
      private var _offsetX:Number = 0;
      
      private var _offsetY:Number = 0;
      
      private var _speedX:Number = 3;
      
      private var _speedY:Number = 7;
      
      protected var _bloodStripBg:Bitmap;
      
      protected var _HPStrip:ScaleFrameImage;
      
      protected var _bloodWidth:int;
      
      protected var _buffBar:FightBuffBar;
      
      private var _fightPower:FilterFrameText;
      
      private var _buffEffect:DictionaryData = new DictionaryData();
      
      private var _effectIconContainer:EffectIconContainer;
      
      protected var counter:int = 1;
      
      protected var ap:Number = 0;
      
      protected var effectForzen:Sprite;
      
      protected var lock:MovieClip;
      
      protected var _isDie:Boolean = false;
      
      protected var _effRect:Rectangle;
      
      private var _attackEffectPlayer:PhysicalObj;
      
      private var _attackEffectPlaying:Boolean = false;
      
      protected var _attackEffectPos:Point = new Point(0,5);
      
      protected var _moviePool:Object = new Object();
      
      private var _hiddenByServer:Boolean;
      
      protected var _propArray:Array;
      
      private var _onSmallMap:Boolean = true;
      
      public function GameLiving(info:Living)
      {
         this._info = info;
         this.initView();
         this.initListener();
         this.initInfoChange();
         super(info.LivingID);
      }
      
      public static function getAttackEffectAssetByID(id:int) : MovieClip
      {
         return ClassUtils.CreatInstance("asset.game.AttackEffect" + id.toString()) as MovieClip;
      }
      
      public function get stepX() : int
      {
         return this._speedX * this.speedMult;
      }
      
      public function get stepY() : int
      {
         return this._speedY * this.speedMult;
      }
      
      override public function get x() : Number
      {
         return super.x + this._offsetX;
      }
      
      override public function get y() : Number
      {
         return super.y + this._offsetY;
      }
      
      public function get EffectIcon() : EffectIconContainer
      {
         if(this._effectIconContainer == null)
         {
         }
         return this._effectIconContainer;
      }
      
      override public function get layer() : int
      {
         if(this.info.isBottom)
         {
            return PhysicsLayer.AppointBottom;
         }
         return PhysicsLayer.GameLiving;
      }
      
      public function get info() : Living
      {
         return this._info;
      }
      
      public function get map() : MapView
      {
         return _map as MapView;
      }
      
      private function __fightPowerChanged(event:LivingEvent) : void
      {
         if(this._info.fightPower > 0 && this._info.fightPower <= 100)
         {
            this.fightPowerVisible = true;
            this._fightPower.text = LanguageMgr.GetTranslation("ddt.games.powerText",this._info.fightPower);
         }
         else
         {
            this._fightPower.text = "";
         }
      }
      
      public function setFightPower(fightPower:int) : void
      {
         if(fightPower > 0 && fightPower <= 100)
         {
            this.fightPowerVisible = true;
            this._fightPower.text = LanguageMgr.GetTranslation("ddt.games.powerText",fightPower);
         }
         else
         {
            this._fightPower.text = "";
         }
      }
      
      public function set fightPowerVisible(value:Boolean) : void
      {
         this._fightPower.visible = value;
      }
      
      protected function initView() : void
      {
         this._propArray = [];
         this._bloodStripBg = ComponentFactory.Instance.creatBitmap("asset.game.smallHPStripBgAsset");
         this._HPStrip = ComponentFactory.Instance.creatComponentByStylename("asset.game.HPStrip");
         this._HPStrip.x += this._bloodStripBg.x = -this._bloodStripBg.width / 2 + 2;
         this._HPStrip.y += this._bloodStripBg.y = 20;
         this._bloodWidth = this._HPStrip.width;
         addChild(this._bloodStripBg);
         addChild(this._HPStrip);
         this._HPStrip.setFrame(this.info.team);
         this._fightPower = ComponentFactory.Instance.creatComponentByStylename("GameLiving.fightPower");
         this._nickName = ComponentFactory.Instance.creatComponentByStylename("GameLiving.nickName");
         if(this.info.playerInfo != null)
         {
            this._nickName.text = this.info.playerInfo.NickName;
         }
         else
         {
            this._nickName.text = this.info.name;
         }
         this._nickName.setFrame(this.info.team);
         this._nickName.x = -this._nickName.width / 2 + 2;
         this._nickName.y = this._bloodStripBg.y + this._bloodStripBg.height / 2 + 4;
         this._buffBar = new FightBuffBar();
         this._buffBar.y = -98;
         addChild(this._buffBar);
         this._buffBar.update(this._info.turnBuffs);
         this._buffBar.x = -(this._buffBar.width / 2);
         addChild(this._nickName);
         this._fightPower.x = this._nickName.x - 27;
         this._fightPower.y = this._nickName.y - 130;
         addChild(this._fightPower);
         this.initSmallMapObject();
         mouseChildren = mouseEnabled = false;
         this._bloodStripBg.visible = this._HPStrip.visible = this._nickName.visible = this._info.isShowBlood;
         this.updateBloodStrip();
      }
      
      protected function initInfoChange() : void
      {
         if(this._info.isFrozen)
         {
            this.effectForzen = ClassUtils.CreatInstance("asset.gameFrostEffectAsset") as MovieClip;
            this.effectForzen.y = 24;
            addChild(this.effectForzen);
         }
         if(this._info.isHidden)
         {
            if(this._info.team != GameManager.Instance.Current.selfGamePlayer.team)
            {
               this.visible = false;
               if(Boolean(this._smallView))
               {
                  this._smallView.visible = false;
                  this._smallView.alpha = 0;
               }
               alpha = 0;
            }
            else
            {
               alpha = 0.5;
               if(Boolean(this._smallView))
               {
                  this._smallView.alpha = 0.5;
               }
            }
         }
      }
      
      protected function initSmallMapObject() : void
      {
         var smallPlayer:SmallPlayer = null;
         if(this._info.isShowSmallMapPoint)
         {
            if(this._info.isPlayer())
            {
               smallPlayer = new SmallPlayer();
               this._smallView = smallPlayer;
            }
            else
            {
               this._smallView = new SmallLiving();
            }
            this._smallView.info = this._info;
         }
      }
      
      protected function initEffectIcon() : void
      {
      }
      
      protected function initFreezonRect() : void
      {
         this._effRect = new Rectangle(0,24,200,200);
      }
      
      public function addChildrenByPack(pack:IDisplayPack) : void
      {
         var someDO:DisplayObject = null;
         for each(someDO in pack.content)
         {
            addChild(someDO);
         }
      }
      
      protected function initListener() : void
      {
         this._info.addEventListener(LivingEvent.BEAT,this.__beat);
         this._info.addEventListener(LivingEvent.BEGIN_NEW_TURN,this.__beginNewTurn);
         this._info.addEventListener(LivingEvent.BLOOD_CHANGED,this.__bloodChanged);
         this._info.addEventListener(LivingEvent.DIE,this.__die);
         this._info.addEventListener(LivingEvent.DIR_CHANGED,this.__dirChanged);
         this._info.addEventListener(LivingEvent.FALL,this.__fall);
         this._info.addEventListener(LivingEvent.FORZEN_CHANGED,this.__forzenChanged);
         this._info.addEventListener(LivingEvent.HIDDEN_CHANGED,this.__hiddenChanged);
         this._info.addEventListener(LivingEvent.PLAY_MOVIE,this.__playMovie);
         this._info.addEventListener(LivingEvent.TURN_ROTATION,this.__turnRotation);
         this._info.addEventListener(LivingEvent.JUMP,this.__jump);
         this._info.addEventListener(LivingEvent.MOVE_TO,this.__moveTo);
         this._info.addEventListener(LivingEvent.MAX_HP_CHANGED,this.__maxHpChanged);
         this._info.addEventListener(LivingEvent.LOCK_STATE,this.__lockStateChanged);
         this._info.addEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
         this._info.addEventListener(LivingEvent.SHOOT,this.__shoot);
         this._info.addEventListener(LivingEvent.TRANSMIT,this.__transmit);
         this._info.addEventListener(LivingEvent.SAY,this.__say);
         this._info.addEventListener(LivingEvent.START_MOVING,this.__startMoving);
         this._info.addEventListener(LivingEvent.CHANGE_STATE,this.__changeState);
         this._info.addEventListener(LivingEvent.SHOW_ATTACK_EFFECT,this.__showAttackEffect);
         this._info.addEventListener(LivingEvent.BOMBED,this.__bombed);
         this._info.addEventListener(LivingEvent.PLAYSKILLMOVIE,this.__playSkillMovie);
         this._info.addEventListener(LivingEvent.BUFF_CHANGED,this.__buffChanged);
         this._info.addEventListener(LivingEvent.PLAY_CONTINUOUS_EFFECT,this.__playContinuousEffect);
         this._info.addEventListener(LivingEvent.REMOVE_CONTINUOUS_EFFECT,this.__removeContinuousEffect);
         this._info.addEventListener(LivingCommandEvent.COMMAND,this.__onLivingCommand);
         this._chatballview.addEventListener(Event.COMPLETE,this.onChatBallComplete);
         if(Boolean(this._actionMovie))
         {
            this._actionMovie.addEventListener("renew",this.__renew);
            this._actionMovie.addEventListener(SHOCK_EVENT2,this.__shockMap2);
            this._actionMovie.addEventListener(SHOCK_EVENT,this.__shockMap);
            this._actionMovie.addEventListener(NEED_FOCUS,this.__needFocus);
            this._actionMovie.addEventListener(SHIELD,this.__showDefence);
            this._actionMovie.addEventListener(ATTACK_COMPLETE_FOCUS,this.__attackCompleteFocus);
            this._actionMovie.addEventListener(BOMB_EVENT,this.__startBlank);
            this._actionMovie.addEventListener(PLAY_EFFECT,this.__playEffect);
            this._actionMovie.addEventListener(PLAYER_EFFECT,this.__playerEffect);
         }
      }
      
      public function replaceMovie() : void
      {
         var movieClass:Class = null;
         if(this._actionMovie && this._actionMovie.shouldReplace && this.info && ModuleLoader.hasDefinition(this.info.actionMovieName))
         {
            removeChild(this._actionMovie);
            this._actionMovie = null;
            movieClass = ModuleLoader.getDefinition(this.info.actionMovieName) as Class;
            this._actionMovie = new movieClass();
            this._info.actionMovieBitmap = new Bitmap(this.getBodyBitmapData("show2"));
            this._info.thumbnail = this.getBodyBitmapData("show");
            this._actionMovie.scaleX = -this._info.direction;
            this._actionMovie.mouseEnabled = false;
            this._actionMovie.mouseChildren = false;
            this._actionMovie.scrollRect = null;
            this._actionMovie.shouldReplace = false;
            this._actionMovie.gotoAndStop(1);
            addChild(this._actionMovie);
         }
      }
      
      protected function __addToState(event:Event) : void
      {
         this.initInfoChange();
      }
      
      protected function __removeContinuousEffect(event:LivingEvent) : void
      {
         this.removeBuffEffect(int(event.paras[0]));
      }
      
      protected function __playContinuousEffect(event:LivingEvent) : void
      {
         this.showBuffEffect(event.paras[0],int(event.paras[1]));
      }
      
      protected function __buffChanged(event:LivingEvent) : void
      {
         if(event.paras[0] == BuffType.Turn && this._info && this._info.isLiving)
         {
            if(Boolean(this._buffBar))
            {
               this._buffBar.update(this._info.turnBuffs);
               if(this._info.turnBuffs.length > 0)
               {
                  this._buffBar.x = 5 - this._buffBar.width / 2;
                  this._buffBar.y = this.bodyHeight * -1 - 23;
                  addChild(this._buffBar);
               }
               else if(Boolean(this._buffBar.parent))
               {
                  this._buffBar.parent.removeChild(this._buffBar);
               }
            }
         }
         if(!this._info.isLiving)
         {
            GameManager.Instance.gameView.deleteAnimation(2);
         }
      }
      
      protected function __removeSkillMovie(event:LivingEvent) : void
      {
      }
      
      protected function __applySkill(event:LivingEvent) : void
      {
      }
      
      protected function __playSkillMovie(event:LivingEvent) : void
      {
         this.showEffect(event.paras[0]);
      }
      
      protected function __skillMovieComplete(event:Event) : void
      {
         var movie:MovieClipWrapper = event.currentTarget as MovieClipWrapper;
         movie.removeEventListener(Event.COMPLETE,this.__skillMovieComplete);
      }
      
      protected function __bombed(event:LivingEvent) : void
      {
      }
      
      protected function removeListener() : void
      {
         if(Boolean(this._info))
         {
            this._info.removeEventListener(LivingEvent.BEAT,this.__beat);
            this._info.removeEventListener(LivingEvent.BEGIN_NEW_TURN,this.__beginNewTurn);
            this._info.removeEventListener(LivingEvent.BLOOD_CHANGED,this.__bloodChanged);
            this._info.removeEventListener(LivingEvent.DIE,this.__die);
            this._info.removeEventListener(LivingEvent.DIR_CHANGED,this.__dirChanged);
            this._info.removeEventListener(LivingEvent.FALL,this.__fall);
            this._info.removeEventListener(LivingEvent.FORZEN_CHANGED,this.__forzenChanged);
            this._info.removeEventListener(LivingEvent.HIDDEN_CHANGED,this.__hiddenChanged);
            this._info.removeEventListener(LivingEvent.PLAY_MOVIE,this.__playMovie);
            this._info.removeEventListener(LivingEvent.TURN_ROTATION,this.__turnRotation);
            this._info.removeEventListener(LivingEvent.PLAYSKILLMOVIE,this.__playSkillMovie);
            this._info.removeEventListener(LivingEvent.REMOVESKILLMOVIE,this.__removeSkillMovie);
            this._info.removeEventListener(LivingEvent.JUMP,this.__jump);
            this._info.removeEventListener(LivingEvent.MOVE_TO,this.__moveTo);
            this._info.removeEventListener(LivingEvent.LOCK_STATE,this.__lockStateChanged);
            this._info.removeEventListener(LivingEvent.POS_CHANGED,this.__posChanged);
            this._info.removeEventListener(LivingEvent.SHOOT,this.__shoot);
            this._info.removeEventListener(LivingEvent.TRANSMIT,this.__transmit);
            this._info.removeEventListener(LivingEvent.SAY,this.__say);
            this._info.removeEventListener(LivingEvent.START_MOVING,this.__startMoving);
            this._info.removeEventListener(LivingEvent.CHANGE_STATE,this.__changeState);
            this._info.removeEventListener(LivingEvent.SHOW_ATTACK_EFFECT,this.__showAttackEffect);
            this._info.removeEventListener(LivingEvent.BOMBED,this.__bombed);
            this._info.removeEventListener(LivingEvent.APPLY_SKILL,this.__applySkill);
            this._info.removeEventListener(LivingEvent.BUFF_CHANGED,this.__buffChanged);
            this._info.removeEventListener(LivingEvent.MAX_HP_CHANGED,this.__maxHpChanged);
            this._info.removeEventListener(LivingEvent.PLAY_CONTINUOUS_EFFECT,this.__playContinuousEffect);
            this._info.removeEventListener(LivingEvent.REMOVE_CONTINUOUS_EFFECT,this.__removeContinuousEffect);
            this._info.removeEventListener(LivingCommandEvent.COMMAND,this.__onLivingCommand);
         }
         if(Boolean(this._chatballview))
         {
            this._chatballview.removeEventListener(Event.COMPLETE,this.onChatBallComplete);
         }
         if(Boolean(this._actionMovie))
         {
            this._actionMovie.removeEventListener("renew",this.__renew);
            this._actionMovie.removeEventListener(SHOCK_EVENT2,this.__shockMap2);
            this._actionMovie.removeEventListener(SHOCK_EVENT,this.__shockMap);
            this._actionMovie.removeEventListener(NEED_FOCUS,this.__needFocus);
            this._actionMovie.removeEventListener(SHIELD,this.__showDefence);
            this._actionMovie.removeEventListener(BOMB_EVENT,this.__startBlank);
            this._actionMovie.removeEventListener(PLAY_EFFECT,this.__playEffect);
            this._actionMovie.removeEventListener(PLAYER_EFFECT,this.__playerEffect);
         }
      }
      
      protected function __shockMap(evt:ActionEvent) : void
      {
         if(Boolean(this.map))
         {
            this.map.animateSet.addAnimation(new ShockMapAnimation(this,evt.param as int,20));
         }
      }
      
      protected function __shockMap2(evt:Event) : void
      {
         if(Boolean(this.map))
         {
            this.map.animateSet.addAnimation(new ShockMapAnimation(this,30,20));
         }
      }
      
      protected function __renew(evt:Event) : void
      {
         this._info.showAttackEffect(2);
      }
      
      protected function __startBlank(evt:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.drawBlank);
      }
      
      protected function drawBlank(evt:Event) : void
      {
         if(this.counter <= 15)
         {
            graphics.clear();
            this.ap = 1 / 225 * (this.counter * this.counter);
            graphics.beginFill(16777215,this.ap);
            graphics.drawRect(-3000,-1800,7000,4200);
         }
         else if(this.counter <= 23)
         {
            graphics.clear();
            this.ap = 1;
            graphics.beginFill(16777215,this.ap);
            graphics.drawRect(-3000,-1800,7000,4200);
         }
         else if(this.counter <= 75)
         {
            graphics.clear();
            this.ap -= 0.02;
            graphics.beginFill(16777215,this.ap);
            graphics.drawRect(-3000,-1800,7000,4200);
         }
         else
         {
            graphics.clear();
            removeEventListener(Event.ENTER_FRAME,this.drawBlank);
         }
         ++this.counter;
      }
      
      protected function __showDefence(evt:Event) : void
      {
         var show:ShowEffect = null;
         show = new ShowEffect(ShowEffect.GUARD);
         show.x = this.x + this.offset();
         show.y = this.y - 50 + this.offset(25);
         _map.addChild(show);
      }
      
      protected function __addEffectHandler(e:DictionaryEvent) : void
      {
         var baseeffect:BaseMirariEffectIcon = e.data as BaseMirariEffectIcon;
         this.EffectIcon.handleEffect(baseeffect.mirariType,baseeffect.getEffectIcon());
      }
      
      protected function __removeEffectHandler(e:DictionaryEvent) : void
      {
         var baseeffect:BaseMirariEffectIcon = e.data as BaseMirariEffectIcon;
         this.EffectIcon.removeEffect(baseeffect.mirariType);
      }
      
      protected function __clearEffectHandler(e:DictionaryEvent) : void
      {
         this.EffectIcon.clearEffectIcon();
      }
      
      protected function __sizeChangeHandler(e:Event) : void
      {
         this.EffectIcon.x = 5 - this.EffectIcon.width / 2;
         this.EffectIcon.y = this.bodyHeight * -1 - this.EffectIcon.height;
      }
      
      protected function __changeState(evt:LivingEvent) : void
      {
      }
      
      protected function initMovie() : void
      {
         var movieClass:Class = null;
         if(!this.info)
         {
            return;
         }
         if(ModuleLoader.hasDefinition(this.info.actionMovieName))
         {
            movieClass = ModuleLoader.getDefinition(this.info.actionMovieName) as Class;
            this._actionMovie = new movieClass();
            this._info.actionMovieBitmap = new Bitmap(this.getBodyBitmapData("show2"));
            this._info.thumbnail = this.getBodyBitmapData("show");
            this._actionMovie.mouseEnabled = false;
            this._actionMovie.mouseChildren = false;
            this._actionMovie.scrollRect = null;
            addChild(this._actionMovie);
            this._actionMovie.gotoAndStop(1);
            this._actionMovie.scaleX = -this._info.direction;
            this._actionMovie.shouldReplace = false;
         }
         else if(ModuleLoader.hasDefinition("game.living.defaultSmallEnemyLiving"))
         {
            if(this.info.typeLiving != 4 && this.info.typeLiving != 5 && this.info.typeLiving != 6 && this.info.typeLiving != 12)
            {
               movieClass = ModuleLoader.getDefinition("game.living.defaultSmallEnemyLiving") as Class;
            }
            else
            {
               movieClass = ModuleLoader.getDefinition("game.living.defaultSimpleBossLiving") as Class;
            }
            this._actionMovie = new movieClass();
            this._info.actionMovieBitmap = new Bitmap(this.getBodyBitmapData("show2"));
            this._info.thumbnail = this.getBodyBitmapData("show");
            this._actionMovie.mouseEnabled = false;
            this._actionMovie.mouseChildren = false;
            this._actionMovie.scrollRect = null;
            addChild(this._actionMovie);
            this._actionMovie.gotoAndStop(1);
            this._actionMovie.scaleX = 1;
            this._actionMovie.shouldReplace = true;
         }
         this.initChatball();
      }
      
      protected function initChatball() : void
      {
         this._chatballview = new ChatBallPlayer();
         this._originalHeight = this._actionMovie.height;
         this._originalWidth = this._actionMovie.width;
         addChild(this._chatballview);
      }
      
      protected function __startMoving(event:LivingEvent) : void
      {
         if(_map == null)
         {
            return;
         }
         var pos:Point = _map.findYLineNotEmptyPointDown(this.x,this.y,_map.height);
         if(pos == null)
         {
            pos = new Point(this.x,_map.height + 1);
         }
         this._info.fallTo(pos,20);
      }
      
      protected function __say(event:LivingEvent) : void
      {
         if(this._info.isHidden)
         {
            return;
         }
         this._chatballview.x = 0;
         this._chatballview.y = 0;
         addChild(this._chatballview);
         var data:String = event.paras[0] as String;
         var type:int = 0;
         if(Boolean(event.paras[1]))
         {
            type = int(event.paras[1]);
         }
         this._chatballview.setText(data,type);
         this.fitChatBallPos();
      }
      
      protected function fitChatBallPos() : void
      {
         this._chatballview.x = this.popPos.x;
         this._chatballview.y = this.popPos.y;
         if(Boolean(this.popDir))
         {
            this._chatballview.directionY = this.popDir.y - this._chatballview.y;
            this._chatballview.directionX = this.popDir.x - this._chatballview.x;
         }
      }
      
      protected function get popPos() : Point
      {
         if(Boolean(this.movie["popupPos"]))
         {
            return new Point(this.movie["popupPos"].x,this.movie["popupPos"].y);
         }
         return new Point(-(this._originalWidth * 0.4) * this.movie.scaleX,-(this._originalHeight * 0.8) * this.movie.scaleY);
      }
      
      protected function get popDir() : Point
      {
         if(Boolean(this.movie["popupDir"]))
         {
            return new Point(this.movie["popupDir"].x,this.movie["popupDir"].y);
         }
         return this.popPos;
      }
      
      override public function collidedByObject(obj:PhysicalObj) : void
      {
      }
      
      protected function __beat(event:LivingEvent) : void
      {
         if(_isLiving)
         {
            this.targetAttackEffect = event.paras[0][0].attackEffect;
            this._actionMovie.doAction(event.paras[0][0].action,this.updateTargetsBlood,event.paras);
         }
      }
      
      protected function updateTargetsBlood(arg:Array) : void
      {
         var living:Living = null;
         if(arg == null)
         {
            return;
         }
         var selfFocus:Boolean = false;
         for(var i:int = 0; i < arg.length; i++)
         {
            if(Boolean(arg[i]) && Boolean(arg[i].target) && Boolean(arg[i].target.isLiving))
            {
               living = arg[i].target;
               living.isHidden = false;
               living.showAttackEffect(arg[i].attackEffect);
               living.updateBlood(arg[i].targetBlood,3,arg[i].damage);
               if(!selfFocus)
               {
                  this.map.setCenter(living.pos.x,living.pos.y - 150,true);
               }
               if(living.isSelf)
               {
                  selfFocus = true;
               }
            }
         }
      }
      
      protected function __beginNewTurn(event:LivingEvent) : void
      {
      }
      
      protected function __playMovie(event:LivingEvent) : void
      {
         if(Boolean(this._actionMovie))
         {
            this._actionMovie.doAction(event.paras[0],event.paras[1],event.paras[2]);
         }
      }
      
      protected function __turnRotation(event:LivingEvent) : void
      {
         this.act(new LivingTurnAction(this,event.paras[0],event.paras[1],event.paras[2]));
      }
      
      protected function __bloodChanged(event:LivingEvent) : void
      {
         var movie:ShootPercentView = null;
         var showBlood:int = 0;
         if(!this.isExist || !_map)
         {
            return;
         }
         var diff:Number = event.value - event.old;
         var type:int = int(event.paras[0]);
         switch(type)
         {
            case 0:
               diff = Number(event.paras[1]);
               if(diff != 0 && this._info.blood != 0)
               {
                  movie = new ShootPercentView(Math.abs(diff),1,true);
                  movie.x = this.x + this.offset();
                  movie.y = this.y - 50 + this.offset(25);
                  movie.scaleX = movie.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(movie);
                  if(this._info.isHidden)
                  {
                     if(this._info.team == GameManager.Instance.Current.selfGamePlayer.team)
                     {
                        movie.alpha == 0.5;
                     }
                     else
                     {
                        this.visible = false;
                        movie.alpha = 0;
                     }
                  }
               }
               break;
            case 90:
               movie = new ShootPercentView(0,2);
               movie.x = this.x + this.offset();
               movie.y = this.y - 50 + this.offset(25);
               movie.scaleX = movie.scaleY = 0.8 + Math.random() * 0.4;
               _map.addToPhyLayer(movie);
               break;
            case 5:
               break;
            case 3:
               showBlood = int(event.paras[1]);
               diff = showBlood;
               if(diff != 0)
               {
                  movie = new ShootPercentView(Math.abs(diff),1,false);
                  movie.x = this.x + this.offset();
                  movie.y = this.y - 50 + this.offset(25);
                  movie.scaleX = movie.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(movie);
               }
               break;
            case 11:
               showBlood = int(event.paras[1]);
               if(showBlood < 0)
               {
                  diff = showBlood;
               }
               if(diff != 0)
               {
                  movie = new ShootPercentView(Math.abs(diff),event.paras[0],false);
                  movie.x = this.x - 70;
                  movie.y = this.y - 80;
                  movie.scaleX = movie.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(movie);
               }
               break;
            default:
               showBlood = int(event.paras[1]);
               if(showBlood < 0)
               {
                  diff = showBlood;
               }
               if(diff != 0)
               {
                  movie = new ShootPercentView(Math.abs(diff),event.paras[0],false);
                  movie.x = this.x + this.offset();
                  movie.y = this.y - 50 + this.offset(25);
                  movie.scaleX = movie.scaleY = 0.8 + Math.random() * 0.4;
                  _map.addToPhyLayer(movie);
                  if(this._info.isHidden)
                  {
                     if(this._info.team == GameManager.Instance.Current.selfGamePlayer.team)
                     {
                        movie.alpha == 0.5;
                     }
                     else
                     {
                        this.visible = false;
                        movie.alpha = 0;
                     }
                  }
               }
         }
         this.updateBloodStrip();
      }
      
      protected function __maxHpChanged(event:LivingEvent) : void
      {
         this.updateBloodStrip();
      }
      
      protected function updateBloodStrip() : void
      {
         if(this.info.blood < 0)
         {
            this._HPStrip.width = 0;
         }
         else
         {
            this._HPStrip.width = Math.floor(this._bloodWidth / this.info.maxBlood * this.info.blood);
         }
      }
      
      private function offset(off:int = 30) : int
      {
         var i:int = int(Math.random() * 10);
         if(i % 2 == 0)
         {
            return -int(Math.random() * off);
         }
         return int(Math.random() * off);
      }
      
      protected function __die(event:LivingEvent) : void
      {
         if(_isLiving)
         {
            _isLiving = false;
            this.die();
         }
      }
      
      override public function die() : void
      {
         this.info.isFrozen = false;
         this.info.isNoNole = false;
         this.info.isHidden = false;
         if(Boolean(this._bloodStripBg) && Boolean(this._bloodStripBg.parent))
         {
            this._bloodStripBg.parent.removeChild(this._bloodStripBg);
         }
         if(Boolean(this._HPStrip) && Boolean(this._HPStrip.parent))
         {
            this._HPStrip.parent.removeChild(this._HPStrip);
         }
         if(Boolean(this._buffBar))
         {
            this._buffBar.dispose();
         }
         this._buffBar = null;
         this.removeAllPetBuffEffects();
      }
      
      public function revive() : void
      {
         this._info.revive();
         _isLiving = true;
         if(Boolean(this._bloodStripBg))
         {
            addChild(this._bloodStripBg);
         }
         if(Boolean(this._HPStrip))
         {
            addChild(this._HPStrip);
         }
         this._buffBar = new FightBuffBar();
         this._buffBar.y = -98;
         this._buffBar.update(this._info.turnBuffs);
         this._buffBar.x = -(this._buffBar.width / 2);
      }
      
      protected function __dirChanged(event:LivingEvent) : void
      {
         if((this._info is SmallEnemy || this._info is SimpleBoss) && this._actionMovie && this._actionMovie.shouldReplace)
         {
            this.movie.scaleX = 1;
            return;
         }
         if(this._info.direction > 0)
         {
            this.movie.scaleX = -1;
         }
         else
         {
            this.movie.scaleX = 1;
         }
      }
      
      protected function __forzenChanged(event:LivingEvent) : void
      {
         if(this._info.isFrozen)
         {
            this.effectForzen = ClassUtils.CreatInstance("asset.gameFrostEffectAsset") as MovieClip;
            this.effectForzen.y = 24;
            addChild(this.effectForzen);
         }
         else if(Boolean(this.effectForzen))
         {
            removeChild(this.effectForzen);
            this.effectForzen = null;
         }
      }
      
      protected function __lockStateChanged(evt:LivingEvent) : void
      {
         if(this._info.LockState)
         {
            this.lock = ClassUtils.CreatInstance("asset.gameII.LockAsset") as MovieClip;
            this.lock.x = 10;
            this.lock.y = 5;
            addChild(this.lock);
            if(evt.paras[0] == 2)
            {
               this.lock.y += 50;
               this.lock.scaleY = 0.8;
               this.lock.scaleX = 0.8;
               this.lock.stop();
               this.lock.alpha = 0.7;
            }
         }
         else if(Boolean(this.lock))
         {
            removeChild(this.lock);
            this.lock = null;
         }
      }
      
      protected function __hiddenChanged(event:LivingEvent) : void
      {
         if(this._info.isHidden)
         {
            if(this._info.team != GameManager.Instance.Current.selfGamePlayer.team)
            {
               this.visible = false;
               if(Boolean(this._smallView))
               {
                  this._smallView.visible = false;
                  this._smallView.alpha = 0;
               }
               alpha = 0;
            }
            else
            {
               alpha = 0.5;
               if(Boolean(this._smallView))
               {
                  this._smallView.alpha = 0.5;
               }
            }
         }
         else
         {
            alpha = 1;
            this.visible = true;
            if(Boolean(this._smallView))
            {
               this._smallView.visible = true;
               this._smallView.alpha = 1;
            }
            parent.addChild(this);
         }
      }
      
      protected function __posChanged(event:LivingEvent) : void
      {
         var angle:Number = NaN;
         pos = this._info.pos;
         if(_isLiving)
         {
            angle = calcObjectAngle(16);
            this._info.playerAngle = angle;
         }
         if(Boolean(this.map))
         {
            this.map.smallMap.updatePos(this.smallView,pos);
         }
      }
      
      protected function __jump(event:LivingEvent) : void
      {
         this.doAction(event.paras[2]);
         this.act(new LivingJumpAction(this,event.paras[0],event.paras[1],event.paras[3]));
      }
      
      protected function __moveTo(event:LivingEvent) : void
      {
         var offset:Point = null;
         var action:String = event.paras[4];
         this.doAction(action);
         var speed:int = int(event.paras[5]);
         if(speed == 0)
         {
            speed = 7;
         }
         var pt:Point = event.paras[1] as Point;
         var dir:int = int(event.paras[2]);
         var endAction:String = event.paras[6];
         if(this.x == pt.x && this.y == pt.y)
         {
            return;
         }
         var path:Array = [];
         var tx:int = this.x;
         var ty:int = this.y;
         var thisPos:Point = new Point(this.x,this.y);
         var direction:int = pt.x > tx ? 1 : -1;
         var p:Point = new Point(this.x,this.y);
         if(action.substr(0,3) == "fly")
         {
            offset = new Point(pt.x - p.x,pt.y - p.y);
            while(true)
            {
               if(offset.length > speed)
               {
                  offset.normalize(speed);
                  p = new Point(p.x + offset.x,p.y + offset.y);
                  offset = new Point(pt.x - p.x,pt.y - p.y);
                  if(Boolean(p))
                  {
                     continue;
                  }
                  path.push(pt);
               }
               path.push(p);
            }
         }
         else
         {
            while((pt.x - tx) * direction > 0)
            {
               p = _map.findNextWalkPoint(tx,ty,direction,speed * npcStepX,speed * npcStepY);
               if(!Boolean(p))
               {
                  break;
               }
               path.push(p);
               tx = p.x;
               ty = p.y;
            }
         }
         if(path.length > 0)
         {
            this._info.act(new LivingMoveAction(this,path,dir,endAction));
         }
         else if(endAction != "")
         {
            this.doAction(endAction);
         }
         else
         {
            this._info.doDefaultAction();
         }
      }
      
      public function canMoveDirection(dir:Number) : Boolean
      {
         return !this.map.IsOutMap(this.x + (15 + Player.MOVE_SPEED) * dir,this.y);
      }
      
      public function canStand(x:int, y:int) : Boolean
      {
         return !this.map.IsEmpty(x - 1,y) || !this.map.IsEmpty(x + 1,y);
      }
      
      public function getNextWalkPoint(dir:int) : Point
      {
         if(this.canMoveDirection(dir))
         {
            return _map.findNextWalkPoint(this.x,this.y,dir,this.stepX,this.stepY);
         }
         return null;
      }
      
      private function __needFocus(evt:ActionMovieEvent) : void
      {
         if(Boolean(evt.data))
         {
            this.needFocus(evt.data.x,evt.data.y,evt.data);
         }
      }
      
      protected function __playEffect(evt:ActionMovieEvent) : void
      {
      }
      
      protected function __playerEffect(evt:ActionMovieEvent) : void
      {
      }
      
      public function needFocus(offsetX:int = 0, offsetY:int = 0, data:Object = null) : void
      {
         if(Boolean(this.map))
         {
            this.map.livingSetCenter(this.x + offsetX,this.y + offsetY - 150,true,2,data);
         }
      }
      
      private function __attackCompleteFocus(event:ActionMovieEvent) : void
      {
         this.map.setSelfCenter(true,2,event.data);
      }
      
      protected function __shoot(event:LivingEvent) : void
      {
      }
      
      protected function __transmit(event:LivingEvent) : void
      {
         this.info.pos = event.paras[0];
      }
      
      protected function __fall(event:LivingEvent) : void
      {
         this._info.act(new LivingFallingAction(this,event.paras[0],event.paras[1],event.paras[3]));
      }
      
      public function get actionMovie() : ActionMovie
      {
         return this._actionMovie;
      }
      
      public function get movie() : Sprite
      {
         return this._actionMovie;
      }
      
      public function doAction(actionType:*) : void
      {
         if(this._actionMovie != null)
         {
            this._actionMovie.doAction(actionType);
         }
      }
      
      public function showEffect(classLink:String) : void
      {
         var mc:AutoDisappear = null;
         if(Boolean(classLink) && ModuleLoader.hasDefinition(classLink))
         {
            mc = new AutoDisappear(ClassUtils.CreatInstance(classLink));
            addChild(mc);
         }
      }
      
      public function showBuffEffect(classLink:String, buffId:int) : void
      {
         var mc:DisplayObject = null;
         if(Boolean(classLink) && ModuleLoader.hasDefinition(classLink))
         {
            if(!this._buffEffect)
            {
               return;
            }
            if(Boolean(this._buffEffect) && this._buffEffect.hasKey(buffId))
            {
               this.removeBuffEffect(buffId);
            }
            mc = ClassUtils.CreatInstance(classLink) as DisplayObject;
            addChild(mc);
            this._buffEffect.add(buffId,mc);
         }
      }
      
      public function removeBuffEffect(buffId:int) : void
      {
         var mc:DisplayObject = null;
         if(Boolean(this._buffEffect) && this._buffEffect.hasKey(buffId))
         {
            mc = this._buffEffect[buffId] as DisplayObject;
            if(Boolean(mc) && Boolean(mc.parent))
            {
               removeChild(mc);
            }
            this._buffEffect.remove(buffId);
         }
      }
      
      public function act(action:BaseAction) : void
      {
         this._info.act(action);
      }
      
      public function traceCurrentAction() : void
      {
         this._info.traceCurrentAction();
      }
      
      override public function update(dt:Number) : void
      {
         if(this._isDie)
         {
            return;
         }
         super.update(dt);
         this._info.update();
      }
      
      private function getBodyBitmapData(action:String = "") : BitmapData
      {
         var oldWidth:Number = this._actionMovie.width;
         var container:Sprite = new Sprite();
         this.bodyWidth = this._actionMovie.width;
         this.bodyHeight = this._actionMovie.height;
         this._actionMovie.gotoAndStop(action);
         var hasChangedSize:Boolean = false;
         if(LeftPlayerCartoonView.SHOW_BITMAP_WIDTH < this._actionMovie.width)
         {
            this._actionMovie.width = LeftPlayerCartoonView.SHOW_BITMAP_WIDTH;
            this._actionMovie.scaleY = this._actionMovie.scaleX;
            hasChangedSize = true;
         }
         container.addChild(this._actionMovie);
         var clipRect:Rectangle = this._actionMovie.getBounds(this._actionMovie);
         this._actionMovie.x = -clipRect.x * this._actionMovie.scaleX;
         this._actionMovie.y = -clipRect.y * this._actionMovie.scaleX;
         var bitmapdata:BitmapData = new BitmapData(container.width,container.height,true,0);
         bitmapdata.draw(container);
         if(hasChangedSize)
         {
            this._actionMovie.width = oldWidth;
            this._actionMovie.scaleY = this._actionMovie.scaleX = 1;
         }
         this._actionMovie.doAction("stand");
         this._actionMovie.x = this._actionMovie.y = 0;
         container.removeChild(this._actionMovie);
         return bitmapdata;
      }
      
      protected function deleteSmallView() : void
      {
         if(Boolean(this._bloodStripBg))
         {
            if(Boolean(this._bloodStripBg.parent))
            {
               this._bloodStripBg.parent.removeChild(this._bloodStripBg);
            }
            this._bloodStripBg.bitmapData.dispose();
            this._bloodStripBg = null;
         }
         if(Boolean(this._HPStrip))
         {
            if(Boolean(this._HPStrip.parent))
            {
               this._HPStrip.parent.removeChild(this._HPStrip);
            }
            this._HPStrip.dispose();
            this._HPStrip = null;
         }
         if(Boolean(this._nickName))
         {
            if(Boolean(this._nickName.parent))
            {
               this._nickName.parent.removeChild(this._nickName);
            }
         }
         if(Boolean(this._smallView))
         {
            this._smallView.dispose();
            this._smallView.visible = false;
         }
         this._smallView = null;
      }
      
      private function removeAllPetBuffEffects() : void
      {
         var buf:DisplayObject = null;
         if(Boolean(this._buffEffect))
         {
            for each(buf in this._buffEffect.list)
            {
               ObjectUtils.disposeObject(buf);
            }
            this._buffEffect = null;
         }
      }
      
      override public function dispose() : void
      {
         var o:Object = null;
         super.dispose();
         this.removeListener();
         this._info = null;
         this.deleteSmallView();
         this.removeAllPetBuffEffects();
         if(Boolean(this._buffBar))
         {
            ObjectUtils.disposeObject(this._buffBar);
            this._buffBar = null;
         }
         if(Boolean(this._fightPower))
         {
            ObjectUtils.disposeObject(this._fightPower);
         }
         this._fightPower = null;
         if(Boolean(this._nickName))
         {
            this._nickName.dispose();
         }
         this._nickName = null;
         if(Boolean(this._chatballview))
         {
            this._chatballview.dispose();
            if(Boolean(this._chatballview.parent))
            {
               this._chatballview.parent.removeChild(this._chatballview);
            }
         }
         if(Boolean(this._actionMovie))
         {
            this._actionMovie.dispose();
            this._actionMovie = null;
         }
         if(Boolean(_map))
         {
            _map.removePhysical(this);
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this.cleanMovies();
         this.isExist = false;
         if(Boolean(this._propArray))
         {
            for each(o in this._propArray)
            {
               ObjectUtils.disposeObject(o);
            }
         }
         this._propArray = null;
      }
      
      public function get EffectRect() : Rectangle
      {
         return this._effRect;
      }
      
      override public function get smallView() : SmallObject
      {
         return this._smallView;
      }
      
      protected function __showAttackEffect(event:LivingEvent) : void
      {
         if(this._attackEffectPlaying)
         {
            return;
         }
         if(this._info == null)
         {
            return;
         }
         this._attackEffectPlaying = true;
         var effectID:int = int(event.paras[0]);
         var effect:MovieClip = this.creatAttackEffectAssetByID(effectID);
         effect.scaleX = -1 * this._info.direction;
         var warpper:MovieClipWrapper = new MovieClipWrapper(effect,true,true);
         warpper.addEventListener(Event.COMPLETE,this.__playComplete);
         warpper.gotoAndPlay(1);
         this._attackEffectPlayer = new PhysicalObj(-1);
         this._attackEffectPlayer.addChild(warpper.movie);
         var pos:Point = _map.globalToLocal(this.movie.localToGlobal(this._attackEffectPos));
         this._attackEffectPlayer.x = pos.x;
         this._attackEffectPlayer.y = pos.y;
         _map.addPhysical(this._attackEffectPlayer);
      }
      
      private function __playComplete(event:Event) : void
      {
         if(Boolean(event.currentTarget))
         {
            event.currentTarget.removeEventListener(Event.COMPLETE,this.__playComplete);
         }
         if(Boolean(_map))
         {
            _map.removePhysical(this._attackEffectPlayer);
         }
         if(Boolean(this._attackEffectPlayer) && Boolean(this._attackEffectPlayer.parent))
         {
            this._attackEffectPlayer.parent.removeChild(this._attackEffectPlayer);
         }
         this._attackEffectPlaying = false;
         this._attackEffectPlayer = null;
      }
      
      protected function hasMovie(name:String) : Boolean
      {
         return this._moviePool.hasOwnProperty(name);
      }
      
      protected function creatAttackEffectAssetByID(id:int) : MovieClip
      {
         var mc:MovieClip = null;
         var name:String = "asset.game.AttackEffect" + id;
         if(this.hasMovie(name))
         {
            return this._moviePool[name] as MovieClip;
         }
         mc = ClassUtils.CreatInstance("asset.game.AttackEffect" + id.toString()) as MovieClip;
         this._moviePool[name] = mc;
         return mc;
      }
      
      private function cleanMovies() : void
      {
         var key:String = null;
         var movie:MovieClip = null;
         for(key in this._moviePool)
         {
            movie = this._moviePool[key];
            movie.stop();
            ObjectUtils.disposeObject(movie);
            delete this._moviePool[key];
         }
      }
      
      public function showBlood(value:Boolean) : void
      {
         this._bloodStripBg.visible = this._HPStrip.visible = value;
         this._nickName.visible = value;
      }
      
      override public function setActionMapping(source:String, target:String) : void
      {
         this._actionMovie.setActionMapping(source,target);
      }
      
      override public function set visible(value:Boolean) : void
      {
         if(this.hiddenByServer)
         {
            return;
         }
         super.visible = value;
         if(this._onSmallMap == false)
         {
            return;
         }
         if(Boolean(this._smallView))
         {
            this._smallView.visible = value;
         }
      }
      
      private function get hiddenByServer() : Boolean
      {
         return this._hiddenByServer;
      }
      
      private function set hiddenByServer(value:Boolean) : void
      {
         if(value)
         {
            super.visible = false;
         }
         else
         {
            super.visible = true;
         }
         this._hiddenByServer = value;
      }
      
      protected function __onLivingCommand(evt:LivingCommandEvent) : void
      {
         switch(evt.commandType)
         {
            case "focusSelf":
               this.map.setCenter(GameManager.Instance.Current.selfGamePlayer.pos.x,GameManager.Instance.Current.selfGamePlayer.pos.x,false);
               break;
            case "focus":
               this.needFocus(evt.object.x,evt.object.y);
               return;
         }
      }
      
      protected function onChatBallComplete(evt:Event) : void
      {
         if(Boolean(this._chatballview) && Boolean(this._chatballview.parent))
         {
            this._chatballview.parent.removeChild(this._chatballview);
         }
         if(Boolean(GameManager.Instance.gameView.messageBtn))
         {
            GameManager.Instance.gameView.messageBtn.visible = true;
         }
      }
      
      protected function doUseItemAnimation(skip:Boolean = false) : void
      {
         var using:MovieClipWrapper = new MovieClipWrapper(MovieClip(ClassUtils.CreatInstance("asset.game.ghostPcikPropAsset")),true,true);
         using.addFrameScriptAt(12,this.headPropEffect);
         SoundManager.instance.play("039");
         using.movie.x = 0;
         using.movie.y = -10;
         if(!skip)
         {
            addChild(using.movie);
         }
      }
      
      protected function headPropEffect() : void
      {
         var movie:DisplayObject = null;
         var head:AutoPropEffect = null;
         var pic:String = null;
         if(Boolean(this._propArray) && this._propArray.length > 0)
         {
            if(this._propArray[0] is String)
            {
               pic = this._propArray.shift();
               if(pic == "-1")
               {
                  movie = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.specialKillAsset");
               }
               else
               {
                  movie = PropItemView.createView(pic,60,60);
               }
               head = new AutoPropEffect(movie);
               head.x = -5;
               head.y = -140;
            }
            else
            {
               movie = this._propArray.shift() as DisplayObject;
               head = new AutoPropEffect(movie);
               head.x = 5;
               head.y = -140;
            }
            addChild(head);
         }
      }
      
      override public function startMoving() : void
      {
         super.startMoving();
         if(Boolean(this._info))
         {
            this._info.isMoving = true;
         }
      }
      
      override public function stopMoving() : void
      {
         super.stopMoving();
         if(Boolean(this._info))
         {
            this._info.isMoving = false;
         }
      }
      
      public function setProperty(property:String, value:String) : void
      {
         var vo:StringObject = new StringObject(value);
         switch(property)
         {
            case "visible":
               this.hiddenByServer = !vo.getBoolean();
               return;
            case "offsetX":
               this._offsetX = vo.getInt();
               this.map.smallMap.updatePos(this._smallView,new Point(this.x,this.y));
               return;
            case "offsetY":
               this._offsetY = vo.getInt();
               this.map.smallMap.updatePos(this._smallView,new Point(this.x,this.y));
               return;
            case "speedX":
               this.speedMult = vo.getInt() / this._speedX;
               break;
            case "speedY":
               this.speedMult = vo.getInt() / this._speedY;
               break;
            case "onSmallMap":
               if(Boolean(this.smallView))
               {
                  this.smallView.visible = vo.getBoolean();
               }
               this._onSmallMap = vo.getBoolean();
               if(this._onSmallMap && Boolean(this._smallView))
               {
                  this._smallView.info = this._info;
               }
               break;
            default:
               this.info.setProperty(property,value);
         }
      }
      
      public function changeSmallViewColor(index:int) : void
      {
         if(Boolean(this._smallView))
         {
            this._smallView.setColor(index);
         }
      }
   }
}

