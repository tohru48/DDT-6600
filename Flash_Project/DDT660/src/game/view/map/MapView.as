package game.view.map
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BallInfo;
   import ddt.data.PathInfo;
   import ddt.data.map.MapInfo;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.loader.MapLoader;
   import ddt.manager.BallManager;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.IMEManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.FaceContainer;
   import ddt.view.chat.ChatEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Transform;
   import flash.system.IME;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import game.GameManager;
   import game.actions.ActionManager;
   import game.actions.BaseAction;
   import game.animations.AnimationLevel;
   import game.animations.AnimationSet;
   import game.animations.BaseSetCenterAnimation;
   import game.animations.IAnimate;
   import game.animations.NewHandAnimation;
   import game.animations.ShockingSetCenterAnimation;
   import game.animations.SpellSkillAnimation;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.TurnedLiving;
   import game.objects.BombAsset;
   import game.objects.GameLiving;
   import game.objects.GamePlayer;
   import game.objects.GameSimpleBoss;
   import game.objects.SimpleBox;
   import game.view.GameViewBase;
   import game.view.smallMap.SmallMapView;
   import im.IMController;
   import phy.maps.Ground;
   import phy.maps.Map;
   import phy.object.PhysicalObj;
   import phy.object.Physics;
   import road7th.data.DictionaryData;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.controller.NewHandGuideManager;
   
   public class MapView extends Map
   {
      
      public static const ADD_BOX:String = "addBox";
      
      public static const FRAMERATE_OVER_COUNT:int = 25;
      
      public static const OVER_FRAME_GAPE:int = 46;
      
      private var _game:GameInfo;
      
      private var _info:MapInfo;
      
      private var _animateSet:AnimationSet;
      
      private var _minX:Number;
      
      private var _minY:Number;
      
      private var _minScaleX:Number;
      
      private var _minScaleY:Number;
      
      private var _minSkyScaleX:Number;
      
      private var _minScale:Number;
      
      private var _smallMap:SmallMapView;
      
      private var _actionManager:ActionManager;
      
      public var gameView:GameViewBase;
      
      public var currentFocusedLiving:GameLiving;
      
      private var _currentTurn:int;
      
      private var _circle:Shape;
      
      private var _y:Number;
      
      private var _x:Number;
      
      private var _dotteLineArr:Array;
      
      private var _dotteLineSp:Sprite;
      
      private var _currentFocusedLiving:GameLiving;
      
      private var _currentFocusLevel:int;
      
      private var _currentPlayer:TurnedLiving;
      
      private var _smallObjs:Array;
      
      private var _scale:Number = 1;
      
      private var _frameRateCounter:int;
      
      private var _currentFrameRateOverCount:int = 0;
      
      private var _frameRateAlert:BaseAlerFrame;
      
      private var _objects:Dictionary = new Dictionary();
      
      private var _gamePlayerList:Vector.<GamePlayer> = new Vector.<GamePlayer>();
      
      private var box:Sprite = new Sprite();
      
      public var monkeyWind:Number = wind;
      
      private var expName:Vector.<String> = new Vector.<String>();
      
      private var expDic:Dictionary = new Dictionary();
      
      private var _currentTopLiving:GameLiving;
      
      private var _container:Sprite;
      
      private var _bigBox:MovieClipWrapper;
      
      private var _isPickBigBox:Boolean;
      
      private var _picIdList:Array;
      
      private var _picMoveDelay:int;
      
      private var _picList:Array;
      
      private var _picStartPoint:Point;
      
      private var _lastPic:BaseCell;
      
      private var _boxTimer:Timer;
      
      public function MapView(game:GameInfo, loader:MapLoader)
      {
         GameManager.Instance.Current.selfGamePlayer.currentMap = this;
         this._game = game;
         var skyBitmap:Bitmap = new Bitmap(loader.backBmp.bitmapData);
         var f:Ground = Boolean(loader.foreBmp) ? new Ground(loader.foreBmp.bitmapData.clone(),true) : null;
         var s:Ground = Boolean(loader.deadBmp) ? new Ground(loader.deadBmp.bitmapData.clone(),false) : null;
         var info:MapInfo = loader.info;
         super(skyBitmap,f,s,loader.middle);
         airResistance = info.DragIndex;
         gravity = info.Weight;
         this._info = info;
         this._animateSet = new AnimationSet(this,PathInfo.GAME_WIDTH,PathInfo.GAME_HEIGHT);
         if(PathManager.dottelineEnable)
         {
            this.initDotteLine();
         }
         this._smallMap = new SmallMapView(this,GameManager.Instance.Current.missionInfo);
         this._smallMap.update();
         this._smallObjs = new Array();
         this._minX = -bound.width + PathInfo.GAME_WIDTH;
         this._minY = -bound.height + PathInfo.GAME_HEIGHT;
         this._minScaleX = PathInfo.GAME_WIDTH / bound.width;
         this._minScaleY = PathInfo.GAME_HEIGHT / bound.height;
         this._minSkyScaleX = PathInfo.GAME_WIDTH / _sky.width;
         if(this._minScaleX < this._minScaleY)
         {
            this._minScale = this._minScaleY;
         }
         else
         {
            this._minScale = this._minScaleX;
         }
         if(this._minScaleX < this._minSkyScaleX)
         {
            this._minScale = this._minSkyScaleX;
         }
         else
         {
            this._minScale = this._minScaleX;
         }
         this._actionManager = new ActionManager();
         this.setCenter(this._info.ForegroundWidth / 2,this._info.ForegroundHeight / 2,false);
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         ChatManager.Instance.addEventListener(ChatEvent.SET_FACECONTIANER_LOCTION,this.__setFacecontainLoctionAction);
         this.initOutCrater();
         this.initBox();
      }
      
      public function set currentTurn(i:int) : void
      {
         this._currentTurn = i;
         dispatchEvent(new GameEvent(GameEvent.TURN_CHANGED,this._currentTurn));
      }
      
      public function get currentTurn() : int
      {
         return this._currentTurn;
      }
      
      public function requestForFocus(target:GameLiving, level:int = 0) : void
      {
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         var x:int = GameManager.Instance.Current.selfGamePlayer.pos.x;
         if(Boolean(this._currentFocusedLiving))
         {
            if(Math.abs(target.pos.x - x) > Math.abs(this._currentFocusedLiving.x - x))
            {
               return;
            }
         }
         if(level < this._currentFocusLevel)
         {
            return;
         }
         this._currentFocusedLiving = target;
         this._currentFocusLevel = level;
         this._currentFocusedLiving.needFocus(0,0,{
            "strategy":"directly",
            "priority":level
         });
      }
      
      public function cancelFocus(target:GameLiving = null) : void
      {
         if(target == null)
         {
            this._currentFocusedLiving = null;
            this._currentFocusLevel = 0;
         }
         if(target == this._currentFocusedLiving)
         {
            this._currentFocusedLiving = null;
            this._currentFocusLevel = 0;
         }
      }
      
      public function get currentPlayer() : TurnedLiving
      {
         return this._currentPlayer;
      }
      
      public function set currentPlayer(value:TurnedLiving) : void
      {
         this._currentPlayer = value;
      }
      
      public function get game() : GameInfo
      {
         return this._game;
      }
      
      public function get info() : MapInfo
      {
         return this._info;
      }
      
      public function get smallMap() : SmallMapView
      {
         return this._smallMap;
      }
      
      public function get animateSet() : AnimationSet
      {
         return this._animateSet;
      }
      
      private function initDotteLine() : void
      {
         var tempBitmap:Bitmap = null;
         GameManager.Instance.Current.selfGamePlayer.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__updateDotteLineState);
         this._dotteLineArr = new Array();
         this._dotteLineSp = new Sprite();
         this._dotteLineSp.mouseEnabled = false;
         this._dotteLineSp.mouseChildren = false;
         this._dotteLineSp.x = -this.x;
         this._dotteLineSp.y = -this.y;
         this._dotteLineSp.visible = false;
         var tempBitmapData:BitmapData = ComponentFactory.Instance.creatBitmapData("asset.game.mapDotteLine");
         for(var i:int = 1; i <= 9; i++)
         {
            tempBitmap = new Bitmap(tempBitmapData.clone());
            tempBitmap.x = PathInfo.GAME_WIDTH / 10 * i - tempBitmap.width / 2;
            this._dotteLineSp.addChild(tempBitmap);
            this._dotteLineArr.push(tempBitmap);
         }
         addChild(this._dotteLineSp);
         tempBitmapData.dispose();
      }
      
      private function __updateDotteLineState(evt:LivingEvent) : void
      {
         if(Boolean(GameManager.Instance.Current.selfGamePlayer) && GameManager.Instance.Current.selfGamePlayer.isAttacking)
         {
            this._dotteLineSp.visible = true;
         }
         else
         {
            this._dotteLineSp.visible = false;
         }
      }
      
      private function removeDottleLine() : void
      {
         var i:int = 0;
         if(Boolean(GameManager.Instance.Current.selfGamePlayer))
         {
            GameManager.Instance.Current.selfGamePlayer.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__updateDotteLineState);
         }
         if(Boolean(this._dotteLineArr))
         {
            for(i = 0; i < this._dotteLineArr.length; i++)
            {
               ObjectUtils.disposeObject(this._dotteLineArr[i]);
               this._dotteLineArr[i] = null;
            }
            this._dotteLineArr = null;
         }
         if(Boolean(this._dotteLineSp))
         {
            ObjectUtils.disposeAllChildren(this._dotteLineSp);
            ObjectUtils.disposeObject(this._dotteLineSp);
            this._dotteLineSp = null;
         }
      }
      
      private function initOutCrater() : void
      {
         var i:int = 0;
         var pos:Point = null;
         var ballInfo:BallInfo = null;
         var bombAsset:BombAsset = null;
         var outBombs:DictionaryData = this._game.outBombs;
         if(outBombs.length > 0)
         {
            for(i = 0; i < outBombs.length; i++)
            {
               pos = new Point(outBombs.list[i].X,outBombs.list[i].Y);
               ballInfo = BallManager.findBall(outBombs.list[i].Id);
               bombAsset = BallManager.getBombAsset(ballInfo.craterID);
               Dig(pos,bombAsset.crater,bombAsset.craterBrink);
            }
            outBombs.clear();
         }
      }
      
      private function initBox() : void
      {
         var outBoxs:DictionaryData = null;
         var i:int = 0;
         var box:SimpleBox = null;
         outBoxs = this._game.outBoxs;
         if(outBoxs.length > 0)
         {
            for(i = 0; i < outBoxs.length; i++)
            {
               box = new SimpleBox(outBoxs.list[i].bid,String(PathInfo.GAME_BOXPIC),outBoxs.list[i].subType);
               box.x = outBoxs.list[i].bx;
               box.y = outBoxs.list[i].by;
               this.addPhysical(box);
            }
            outBoxs.clear();
         }
      }
      
      public function DigOutCrater(outBombs:DictionaryData) : void
      {
         var i:int = 0;
         var pos:Point = null;
         var ballInfo:BallInfo = null;
         var bombAsset:BombAsset = null;
         if(outBombs.length > 0)
         {
            for(i = 0; i < outBombs.length; i++)
            {
               pos = new Point(outBombs.list[i].X,outBombs.list[i].Y);
               ballInfo = BallManager.findBall(outBombs.list[i].Id);
               bombAsset = BallManager.getBombAsset(ballInfo.craterID);
               Dig(pos,bombAsset.crater,bombAsset.craterBrink);
            }
            outBombs.clear();
         }
      }
      
      private function __setFacecontainLoctionAction(e:Event) : void
      {
         this.setExpressionLoction();
      }
      
      private function get minX() : Number
      {
         return -bound.width * this.scale + PathInfo.GAME_WIDTH;
      }
      
      private function get minY() : Number
      {
         return -bound.height * this.scale + PathInfo.GAME_HEIGHT;
      }
      
      private function __mouseClick(event:MouseEvent) : void
      {
         stage.focus = this;
         if(Boolean(ChatManager.Instance.input.parent) && !NewHandGuideManager.Instance.isNewHandFB())
         {
            SoundManager.instance.play("008");
            ChatManager.Instance.switchVisible();
         }
      }
      
      public function spellKill(player:GamePlayer) : IAnimate
      {
         var skill:SpellSkillAnimation = null;
         if(RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            skill = new SpellSkillAnimation(player.x,player.y,PathInfo.GAME_WIDTH,PathInfo.GAME_HEIGHT,this._info.ForegroundWidth - 100,this._info.ForegroundHeight + 600,player,this.gameView);
         }
         else
         {
            skill = new SpellSkillAnimation(player.x,player.y,PathInfo.GAME_WIDTH,PathInfo.GAME_HEIGHT,this._info.ForegroundWidth,this._info.ForegroundHeight,player,this.gameView);
         }
         this.animateSet.addAnimation(skill);
         SoundManager.instance.play("097");
         return skill;
      }
      
      public function get isPlayingMovie() : Boolean
      {
         return this._animateSet.current is SpellSkillAnimation;
      }
      
      override public function set x(value:Number) : void
      {
         value = value < this.minX ? this.minX : (value > 0 ? 0 : value);
         this._x = value;
         super.x = this._x;
         if(Boolean(this._dotteLineSp))
         {
            this._dotteLineSp.x = -this.x;
         }
      }
      
      override public function set y(value:Number) : void
      {
         value = value < this.minY ? this.minY : (value > 0 ? 0 : value);
         this._y = value;
         super.y = this._y;
         if(Boolean(this._dotteLineSp))
         {
            this._dotteLineSp.y = -this.y;
         }
      }
      
      override public function get x() : Number
      {
         return this._x;
      }
      
      override public function get y() : Number
      {
         return this._y;
      }
      
      override public function set transform(value:Transform) : void
      {
         super.transform = value;
      }
      
      public function set scale(value:Number) : void
      {
         if(value > 1)
         {
            value = 1;
         }
         if(value < this._minScale)
         {
            value = this._minScale;
         }
         this._scale = value;
         var _matrix:Matrix = new Matrix();
         _matrix.scale(this._scale,this._scale);
         transform.matrix = _matrix;
         _sky.scaleX = _sky.scaleY = Math.pow(this._scale,-1 / 2);
         this.updateSky();
      }
      
      public function get minScale() : Number
      {
         return this._minScale;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function setCenter(px:Number, py:Number, isTween:Boolean) : void
      {
         this._animateSet.addAnimation(new BaseSetCenterAnimation(px,py,50,!isTween,AnimationLevel.MIDDLE));
      }
      
      public function scenarioSetCenter(px:Number, py:Number, type:int) : void
      {
         switch(type)
         {
            case 3:
               this._animateSet.addAnimation(new ShockingSetCenterAnimation(px,py,50,false,AnimationLevel.HIGHT,9));
               break;
            case 2:
               this._animateSet.addAnimation(new ShockingSetCenterAnimation(px,py,165,false,AnimationLevel.HIGHT,9));
               break;
            default:
               this._animateSet.addAnimation(new BaseSetCenterAnimation(px,py,100,false,AnimationLevel.HIGHT,4));
         }
      }
      
      public function livingSetCenter(px:Number, py:Number, isTween:Boolean, priority:int = 2, data:Object = null) : void
      {
         if(Boolean(this._animateSet))
         {
            this._animateSet.addAnimation(new BaseSetCenterAnimation(px,py,25,!isTween,priority,0,data));
         }
      }
      
      public function setSelfCenter(isTween:Boolean, priority:int = 2, data:Object = null) : void
      {
         var self:Living = this._game.livings[this._game.selfGamePlayer.LivingID];
         if(self == null)
         {
            return;
         }
         this._animateSet.addAnimation(new BaseSetCenterAnimation(self.pos.x - 50,self.pos.y - 150,25,!isTween,priority,0,data));
      }
      
      public function act(action:BaseAction) : void
      {
         this._actionManager.act(action);
      }
      
      public function showShoot(x:Number, y:Number) : void
      {
         this._circle = new Shape();
         this._circle.graphics.beginFill(16711680);
         this._circle.graphics.drawCircle(x,y,3);
         this._circle.graphics.drawCircle(x,y,1);
         this._circle.graphics.endFill();
         addChild(this._circle);
      }
      
      override protected function update() : void
      {
         super.update();
         if(!IMController.Instance.privateChatFocus)
         {
            if(ChatManager.Instance.input.parent == null)
            {
               if(IME.enabled)
               {
                  IMEManager.disable();
               }
               if(Boolean(stage) && stage.focus == null)
               {
                  stage.focus = this;
               }
            }
            if(StageReferance.stage.focus is TextField && TextField(StageReferance.stage.focus).type == TextFieldType.INPUT)
            {
               if(!IME.enabled)
               {
                  IMEManager.enable();
               }
            }
            else if(IME.enabled)
            {
               IMEManager.disable();
            }
         }
         else if(!IME.enabled)
         {
            IMEManager.enable();
         }
         if(this._animateSet.update())
         {
            this.updateSky();
         }
         this._actionManager.execute();
         this.checkOverFrameRate();
      }
      
      private function checkOverFrameRate() : void
      {
         if(this._game.gameMode == GameManager.CHRISTMAS_MODEL && StageReferance.stage.frameRate > 45)
         {
            SocketManager.Instance.socket.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,LanguageMgr.GetTranslation("tank.manager.RoomManager.break")));
            return;
         }
         if(SharedManager.Instance.hasCheckedOverFrameRate)
         {
            return;
         }
         if(this._game == null)
         {
            return;
         }
         if(this._game.PlayerCount <= 4)
         {
            return;
         }
         if(Boolean(this._currentPlayer) && this._currentPlayer.LivingID == this._game.selfGamePlayer.LivingID)
         {
            return;
         }
         var currentTime:int = getTimer();
         if(currentTime - this._frameRateCounter > OVER_FRAME_GAPE && this._frameRateCounter != 0)
         {
            ++this._currentFrameRateOverCount;
            if(this._currentFrameRateOverCount > FRAMERATE_OVER_COUNT)
            {
               if(this._frameRateAlert == null && SharedManager.Instance.showParticle)
               {
                  this._frameRateAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.game.map.smallMapView.slow"),"",LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  this._frameRateAlert.addEventListener(FrameEvent.RESPONSE,this.__onRespose);
                  SharedManager.Instance.hasCheckedOverFrameRate = true;
                  SharedManager.Instance.save();
               }
            }
         }
         else
         {
            this._currentFrameRateOverCount = 0;
         }
         this._frameRateCounter = currentTime;
      }
      
      private function __onRespose(event:FrameEvent) : void
      {
         this._frameRateAlert.removeEventListener(FrameEvent.RESPONSE,this.__onRespose);
         this._frameRateAlert.dispose();
         SharedManager.Instance.showParticle = false;
      }
      
      private function overFrameOk() : void
      {
         SharedManager.Instance.showParticle = false;
      }
      
      public function get mapBitmap() : Bitmap
      {
         var bitData:BitmapData = new BitmapData(StageReferance.stageWidth,StageReferance.stageHeight);
         var pos:Point = globalToLocal(new Point(0,0));
         bitData.draw(this,new Matrix(1,0,0,1,-pos.x,-pos.y),null,null);
         return new Bitmap(bitData,"auto",true);
      }
      
      private function updateSky() : void
      {
         var _skyWScalePercent:Number = NaN;
         var _middleHScalePercent:Number = NaN;
         var _middleWScalePercent:Number = NaN;
         if(this._scale < 1)
         {
         }
         var _skyHScalePercent:Number = (sky.height * this._scale - PathInfo.GAME_HEIGHT) / (bound.height * this._scale - PathInfo.GAME_HEIGHT);
         _skyWScalePercent = (sky.width * this._scale - PathInfo.GAME_WIDTH) / (bound.width * this._scale - PathInfo.GAME_WIDTH);
         _skyHScalePercent = isNaN(_skyHScalePercent) || _skyHScalePercent == Number.NEGATIVE_INFINITY || _skyHScalePercent == Number.POSITIVE_INFINITY ? 1 : _skyHScalePercent;
         _skyWScalePercent = isNaN(_skyWScalePercent) || _skyWScalePercent == Number.NEGATIVE_INFINITY || _skyWScalePercent == Number.POSITIVE_INFINITY ? 1 : _skyWScalePercent;
         _sky.y = this.y * (_skyHScalePercent - 1) / this._scale;
         _sky.x = this.x * (_skyWScalePercent - 1) / this._scale;
         if(Boolean(_middle))
         {
            _middleHScalePercent = (_middle.height * this._scale - PathInfo.GAME_HEIGHT) / (bound.height * this._scale - PathInfo.GAME_HEIGHT);
            _middleWScalePercent = (_middle.width * this._scale - PathInfo.GAME_WIDTH) / (bound.width * this._scale - PathInfo.GAME_WIDTH);
            _middleHScalePercent = isNaN(_middleHScalePercent) || _middleHScalePercent == Number.NEGATIVE_INFINITY || _middleHScalePercent == Number.POSITIVE_INFINITY ? 1 : _middleHScalePercent;
            _middleWScalePercent = isNaN(_middleWScalePercent) || _middleWScalePercent == Number.NEGATIVE_INFINITY || _middleWScalePercent == Number.POSITIVE_INFINITY ? 1 : _middleWScalePercent;
            _middle.y = this.y * (_middleHScalePercent - 1) / this._scale;
            _middle.x = this.x * (_middleWScalePercent - 1) / this._scale;
         }
         this._smallMap.setScreenPos(this.x,this.y);
      }
      
      public function getPhysical(id:int) : PhysicalObj
      {
         return this._objects[id];
      }
      
      public function get getOneSimpleBoss() : GameSimpleBoss
      {
         var tmp:PhysicalObj = null;
         for each(tmp in this._objects)
         {
            if(tmp is GameSimpleBoss)
            {
               return tmp as GameSimpleBoss;
            }
         }
         return null;
      }
      
      public function drawdraw(energy:Number, angle:Number, x:Number, y:Number) : void
      {
      }
      
      override public function addPhysical(phy:Physics) : void
      {
         var obj:PhysicalObj = null;
         super.addPhysical(phy);
         if(phy is PhysicalObj)
         {
            obj = phy as PhysicalObj;
            this._objects[obj.Id] = obj;
            if(Boolean(obj.smallView))
            {
               this._smallMap.addObj(obj.smallView);
               this._smallMap.updatePos(obj.smallView,obj.pos);
            }
         }
         if(phy is GamePlayer)
         {
            this._gamePlayerList.push(phy);
         }
      }
      
      private function controlExpNum(temp:GamePlayer) : void
      {
         var randomNum:int = 0;
         var randomExpnickname:String = null;
         var randomExpcontainer:FaceContainer = null;
         if(this.expName.length < 2)
         {
            if(this.expName.indexOf(temp.facecontainer.nickName.text) < 0)
            {
               this.expName.push(temp.facecontainer.nickName.text);
               this.expDic[temp.facecontainer.nickName.text] = temp.facecontainer;
            }
         }
         else if(this.expName.indexOf(temp.facecontainer.nickName.text) < 0)
         {
            randomNum = int(Math.random() * 2);
            randomExpnickname = this.expName[randomNum];
            randomExpcontainer = this.expDic[randomExpnickname] as FaceContainer;
            if(randomExpcontainer.isActingExpression)
            {
               randomExpcontainer.doClearFace();
            }
            this.expName[randomNum] = temp.facecontainer.nickName.text;
            delete this.expDic[randomExpnickname];
            this.expDic[temp.facecontainer.nickName.text] = temp.facecontainer;
         }
      }
      
      private function resetDicAndVec(temp:GamePlayer) : void
      {
         var tempIndex:int = int(this.expName.indexOf(temp.facecontainer.nickName.text));
         if(tempIndex >= 0)
         {
            delete this.expDic[this.expName[tempIndex]];
            this.expName.splice(tempIndex,1);
         }
      }
      
      public function setExpressionLoction() : void
      {
         var temp:GamePlayer = null;
         var pointAtStage:Point = null;
         var tempFlg:int = 0;
         if(!this._gamePlayerList || this._gamePlayerList.length == 0)
         {
            return;
         }
         for(var i:int = 0; i < this._gamePlayerList.length; i++)
         {
            temp = this._gamePlayerList[i];
            if(temp == null || !temp.isLiving || temp.facecontainer == null)
            {
               this._gamePlayerList.splice(i,1);
            }
            else if(temp.facecontainer.isActingExpression)
            {
               if(!(temp.facecontainer.expressionID >= 49 || temp.facecontainer.expressionID <= 0))
               {
                  pointAtStage = this.localToGlobal(new Point(temp.x,temp.y));
                  tempFlg = this.onStageFlg(pointAtStage);
                  if(tempFlg == 0)
                  {
                     temp.facecontainer.x = 0;
                     temp.facecontainer.y = -100;
                     this.resetDicAndVec(temp);
                     temp.facecontainer.isShowNickName = false;
                  }
                  else if(tempFlg == 1)
                  {
                     temp.facecontainer.x = temp.facecontainer.width / 2 + 30 - pointAtStage.x;
                     temp.facecontainer.y = 270 + temp.facecontainer.height / 2 - pointAtStage.y;
                     this.controlExpNum(temp);
                     temp.facecontainer.isShowNickName = true;
                  }
                  if(this.expName.length == 2)
                  {
                     (this.expDic[this.expName[1]] as FaceContainer).x += 80;
                  }
               }
            }
            else
            {
               temp.facecontainer.x = 0;
               temp.facecontainer.y = -100;
               temp.facecontainer.isShowNickName = false;
               this.resetDicAndVec(temp);
            }
         }
      }
      
      private function onStageFlg(tempPoint:Point) : int
      {
         if(tempPoint == null)
         {
            return 100;
         }
         if(tempPoint.x >= 0 && tempPoint.x <= 1000 && tempPoint.y >= 0 && tempPoint.y <= 600)
         {
            return 0;
         }
         return 1;
      }
      
      public function addObject(phy:Physics) : void
      {
         var obj:PhysicalObj = null;
         if(phy is PhysicalObj)
         {
            obj = phy as PhysicalObj;
            this._objects[obj.Id] = obj;
         }
      }
      
      public function bringToFront($info:Living) : void
      {
         if(!$info)
         {
            return;
         }
         var phy:Physics = this._objects[$info.LivingID] as Physics;
         if(Boolean(phy))
         {
            super.addPhysical(phy);
         }
      }
      
      public function phyBringToFront(phy:PhysicalObj) : void
      {
         if(Boolean(phy))
         {
            super.addChild(phy);
         }
      }
      
      override public function removePhysical(phy:Physics) : void
      {
         var obj:PhysicalObj = null;
         super.removePhysical(phy);
         if(phy is PhysicalObj)
         {
            obj = phy as PhysicalObj;
            if(Boolean(this._objects) && Boolean(this._objects[obj.Id]))
            {
               delete this._objects[obj.Id];
            }
            if(Boolean(this._smallMap) && Boolean(obj.smallView))
            {
               this._smallMap.removeObj(obj.smallView);
            }
         }
      }
      
      override public function addMapThing(phy:Physics) : void
      {
         var obj:PhysicalObj = null;
         super.addMapThing(phy);
         if(phy is PhysicalObj)
         {
            obj = phy as PhysicalObj;
            this._objects[obj.Id] = obj;
            if(Boolean(obj.smallView))
            {
               this._smallMap.addObj(obj.smallView);
               this._smallMap.updatePos(obj.smallView,obj.pos);
            }
         }
      }
      
      override public function removeMapThing(phy:Physics) : void
      {
         var obj:PhysicalObj = null;
         super.removeMapThing(phy);
         if(phy is PhysicalObj)
         {
            obj = phy as PhysicalObj;
            if(Boolean(this._objects[obj.Id]))
            {
               delete this._objects[obj.Id];
            }
            if(Boolean(obj.smallView))
            {
               this._smallMap.removeObj(obj.smallView);
            }
         }
      }
      
      public function get actionCount() : int
      {
         return this._actionManager.actionCount;
      }
      
      public function lockFocusAt(pos:Point) : void
      {
         this.animateSet.addAnimation(new NewHandAnimation(pos.x,pos.y - 150,int.MAX_VALUE,false,AnimationLevel.HIGHEST));
      }
      
      public function releaseFocus() : void
      {
         this.animateSet.clear();
      }
      
      public function executeAtOnce() : void
      {
         this._actionManager.executeAtOnce();
         this._animateSet.clear();
      }
      
      public function traceCurrentAction() : void
      {
         this._actionManager.traceAllRemainAction(PlayerManager.Instance.Self.NickName);
      }
      
      public function bringToStageTop(living:PhysicalObj) : void
      {
         if(Boolean(this._currentTopLiving))
         {
            this.addPhysical(this._currentTopLiving);
         }
         if(Boolean(this._container) && Boolean(this._container.parent))
         {
            this._container.parent.removeChild(this._container);
         }
         this._currentTopLiving = this._objects[living.Id] as GameLiving;
         if(this._container == null)
         {
            this._container = new Sprite();
            this._container.x = this.x;
            this._container.y = this.y;
         }
         if(Boolean(this._currentTopLiving))
         {
            this._container.addChild(this._currentTopLiving);
         }
         LayerManager.Instance.addToLayer(this._container,LayerManager.GAME_BASE_LAYER,false,0,false);
      }
      
      public function restoreStageTopLiving() : void
      {
         if(Boolean(this._currentTopLiving) && this._currentTopLiving.isExist)
         {
            this.addPhysical(this._currentTopLiving);
         }
         if(Boolean(this._container) && Boolean(this._container.parent))
         {
            this._container.parent.removeChild(this._container);
         }
         this._currentTopLiving = null;
      }
      
      public function setMatrx(m:Matrix) : void
      {
         transform.matrix = m;
         if(Boolean(this._container))
         {
            this._container.transform.matrix = m;
         }
      }
      
      public function dropOutBox(array:Array) : void
      {
         this._picIdList = array;
         this.setSelfCenter(false);
         this._isPickBigBox = false;
         this._bigBox = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.dropOut.bigBox.red"),true);
         _livingLayer.addChild(this._bigBox.movie);
         var tmpPoint:Point = this.getTwoHundredDisPoint(this._game.selfGamePlayer.pos.x,this._game.selfGamePlayer.pos.y,this._bigBox.movie.width / 2,this._bigBox.movie.height / 2,this._game.selfGamePlayer.direction);
         this._bigBox.movie.x = tmpPoint.x;
         this._bigBox.movie.y = tmpPoint.y;
         this._bigBox.endFrame = 29;
         this._bigBox.addEventListener(Event.COMPLETE,this.dropEndHandler,false,0,true);
         this._bigBox.movie.addEventListener(MouseEvent.CLICK,this.__onBigBoxClick);
         this._bigBox.movie.buttonMode = true;
         this._bigBox.gotoAndPlay(1);
         this._bigBox.movie.addEventListener(Event.ENTER_FRAME,this.playSoundEffect);
         this._boxTimer = new Timer(1000,9);
         this._boxTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__openBox);
         this._boxTimer.start();
      }
      
      protected function __openBox(event:TimerEvent) : void
      {
         if(Boolean(this._boxTimer))
         {
            this._boxTimer.stop();
            this._boxTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__openBox);
            this._boxTimer = null;
         }
         this.pickBigBoxSuccessHandler();
      }
      
      protected function __onBigBoxClick(event:MouseEvent) : void
      {
         if(Boolean(this._boxTimer))
         {
            this._boxTimer.stop();
            this._boxTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__openBox);
            this._boxTimer = null;
         }
         this._bigBox.movie.buttonMode = false;
         this._bigBox.movie.removeEventListener(MouseEvent.CLICK,this.__onBigBoxClick);
         this.pickBigBoxSuccessHandler();
      }
      
      public function pickBigBoxSuccessHandler() : void
      {
         this._bigBox.gotoAndPlay("open");
         this._picStartPoint = new Point(this._bigBox.movie.x - 22.5,this._bigBox.movie.y - 120 - 22.5);
         this._picMoveDelay = 4;
         this._bigBox.movie.addEventListener(Event.ENTER_FRAME,this.playPickBoxAwardMove,false,0,true);
         GameInSocketOut.sendGameSkipNext(0);
      }
      
      private function playPickBoxAwardMove(event:Event) : void
      {
         var len:int = 0;
         var tag:int = 0;
         var i:int = 0;
         var bg:Bitmap = null;
         var tmpPic:BaseCell = null;
         var tmpX:Number = NaN;
         if(this._bigBox.movie.currentFrame == 37)
         {
            this._picList = [];
            len = int(this._picIdList.length);
            tag = -1;
            for(i = 0; i < len; i++)
            {
               bg = new Bitmap(new BitmapData(45,45,true,0));
               tmpPic = new BaseCell(bg,ItemManager.Instance.getTemplateById(this._picIdList[i]));
               tmpPic.x = this._picStartPoint.x;
               tmpPic.y = this._picStartPoint.y;
               this._picList.push(tmpPic);
               addChild(tmpPic);
               if(len % 2 == 0)
               {
                  tmpX = int(i / 2) * tag * 50 + 25 * tag + tmpPic.x;
               }
               else
               {
                  tmpX = int((i + 1) / 2) * tag * 50 + tmpPic.x;
               }
               TweenLite.to(tmpPic,0.2,{"x":tmpX});
               tag *= -1;
            }
         }
         else if(this._bigBox.movie.currentFrame == 50)
         {
            this._picList.sortOn("x",Array.NUMERIC);
            this._lastPic = this._picList[this._picList.length - 1];
            addEventListener(Event.ENTER_FRAME,this.playPickBoxAwardMove2);
         }
         else if(this._bigBox.movie.currentFrame == 84)
         {
            this._bigBox.gotoAndStop(84);
            this._bigBox.movie.removeEventListener(Event.ENTER_FRAME,this.playPickBoxAwardMove);
         }
      }
      
      private function playPickBoxAwardMove2(event:Event) : void
      {
         ++this._picMoveDelay;
         if(this._picMoveDelay < 5)
         {
            return;
         }
         this._picMoveDelay = 0;
         this.pickBigBoxSuccessHandler2(this._picList.shift());
         if(this._picList.length == 0)
         {
            removeEventListener(Event.ENTER_FRAME,this.playPickBoxAwardMove2);
         }
      }
      
      private function pickBigBoxSuccessHandler2(pic:BaseCell) : void
      {
         TweenLite.to(pic,0.5,{
            "y":pic.y - 60,
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.upMoveEndHandler,
            "onCompleteParams":[pic]
         });
      }
      
      private function upMoveEndHandler(pic:BaseCell) : void
      {
         this.lightCartoonPlayEndHandler(pic);
      }
      
      private function lightCartoonPlayEndHandler(pic:BaseCell) : void
      {
         if(!this._game || !this._game.selfGamePlayer || !this._game.selfGamePlayer.pos)
         {
            return;
         }
         var arrivePos:Point = new Point(this._game.selfGamePlayer.pos.x,this._game.selfGamePlayer.pos.y);
         var tmpxx:Number = (pic.x + arrivePos.x) / 2;
         var tmpyy:Number = Math.min(pic.y,arrivePos.y) - 200;
         TweenMax.to(pic,1,{
            "scaleX":0.1,
            "scaleY":0.1,
            "bezier":[{
               "x":tmpxx,
               "y":tmpyy
            },{
               "x":arrivePos.x,
               "y":arrivePos.y
            }],
            "onComplete":this.pickBigBoxEndHandler,
            "onCompleteParams":[pic]
         });
      }
      
      private function pickBigBoxEndHandler(pic:BaseCell) : void
      {
         if(!pic)
         {
            return;
         }
         pic.dispose();
         pic = null;
      }
      
      private function playSoundEffect(evnet:Event) : void
      {
         if(this._bigBox.movie.currentFrame == 13)
         {
            SoundManager.instance.play("164");
            this._bigBox.movie.removeEventListener(Event.ENTER_FRAME,this.playSoundEffect);
            this._bigBox.movie.buttonMode = true;
            this._bigBox.movie.mouseChildren = false;
            this._bigBox.movie.addEventListener(MouseEvent.CLICK,this.openBigBox,false,0,true);
         }
      }
      
      private function openBigBox(event:MouseEvent) : void
      {
         this._bigBox.movie.buttonMode = false;
         this._bigBox.movie.removeEventListener(MouseEvent.CLICK,this.openBigBox);
         this._isPickBigBox = true;
      }
      
      private function dropEndHandler(event:Event) : void
      {
         this._bigBox.removeEventListener(Event.COMPLETE,this.dropEndHandler);
         this._bigBox.gotoAndStop("stop");
      }
      
      private function getTwoHundredDisPoint(x:Number, y:Number, width:Number, height:Number, direction:int) : Point
      {
         var point1:Point = null;
         y = 150;
         var tmp:Number = x + 200 * direction + width * direction;
         if(!this.IsOutMap(tmp,y) && this.IsEmpty(tmp,y))
         {
            return findYLineNotEmptyPointDown(x + 200 * direction,y,this.bound.height);
         }
         direction *= -1;
         tmp = x + 200 * direction + width * direction;
         return findYLineNotEmptyPointDown(x + 200 * direction,y,this.bound.height);
      }
      
      override public function dispose() : void
      {
         var p:PhysicalObj = null;
         super.dispose();
         this.removeDottleLine();
         this._currentTopLiving = null;
         ChatManager.Instance.removeEventListener(ChatEvent.SET_FACECONTIANER_LOCTION,this.__setFacecontainLoctionAction);
         if(Boolean(this._boxTimer))
         {
            this._boxTimer.stop();
            this._boxTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__openBox);
            this._boxTimer = null;
         }
         if(Boolean(this._container) && Boolean(this._container.parent))
         {
            this._container.parent.removeChild(this._container);
         }
         this._container = null;
         if(Boolean(this.box) && Boolean(this.box.parent))
         {
            this.box.parent.removeChild(this.box);
         }
         this.box = null;
         if(this._frameRateAlert != null)
         {
            this._frameRateAlert.removeEventListener(FrameEvent.RESPONSE,this.__onRespose);
            this._frameRateAlert.dispose();
            this._frameRateAlert = null;
         }
         for each(p in this._objects)
         {
            p.dispose();
            p = null;
         }
         this._objects = null;
         this._game = null;
         this._info = null;
         this._currentFocusedLiving = null;
         this.currentFocusedLiving = null;
         this._currentPlayer = null;
         this._smallMap.dispose();
         this._smallMap = null;
         this._animateSet.dispose();
         this._animateSet = null;
         this._actionManager.clear();
         this._actionManager = null;
         this.gameView = null;
         this._gamePlayerList = null;
      }
   }
}

