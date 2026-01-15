package hall.player
{
   import church.view.churchScene.MoonSceneMap;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.OpitionEnum;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import ddt.view.DailyButtunBar;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import hall.event.NewHallEvent;
   import hall.player.vo.PlayerPetsInfo;
   import hall.player.vo.PlayerVO;
   import newTitle.NewTitleManager;
   import newVersionGuide.NewVersionGuideEvent;
   import newVersionGuide.NewVersionGuideManager;
   import playerDress.data.PlayerDressEvent;
   import road7th.comm.PackageIn;
   
   public class HallPlayerView extends Sprite
   {
      
      public static var initFlag:Boolean;
      
      public static var petsDisInfo:PlayerPetsInfo;
      
      public static var pointsArray:Array = [Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,2),new Point(0,0),new Point(0,-1),new Point(0,2)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,-1),new Point(-3,1),new Point(-3,0),new Point(-3,-1),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-1,-1),new Point(-1,0),new Point(-1,-1),new Point(-1,0),new Point(-1,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,-1),new Point(-3,2),new Point(-3,0),new Point(-3,-1),new Point(-3,2)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,0),new Point(0,0)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0
      ,1),new Point(0,2),new Point(0,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,1),new Point(0,2),new Point(0,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,1),new Point(0,2),new Point(0,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,1),new Point(0,2),new Point(0,1)])];
      
      public static var horsePicCherishPointsArray:Array = [Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,-1),new Point(-3,1),new Point(-3,0),new Point(-3,-1),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,-1),new Point(-3,1),new Point(-3,0),new Point(-3,-1),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,0),new Point(0,0)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,-1),new Point(-3,1),new Point(-3,0),new Point(-3,-1),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,-1),new Point(-3,1),new Point(-3,0),new Point(-3,-1),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,1),new Point(-3,0),new Point(-3,1),new Point(-3,0),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,-1),new Point(-3,1),new Point(-3,0),new Point(-3,-1),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0)
      ,new Point(-3,-1),new Point(-3,1),new Point(-3,0),new Point(-3,-1),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,-1),new Point(-3,1),new Point(-3,0),new Point(-3,-1),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,-1),new Point(-3,1),new Point(-3,0),new Point(-3,-1),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(-3,-1),new Point(-3,1),new Point(-3,0),new Point(-3,-1),new Point(-3,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,1),new Point(0,0),new Point(0,-1),new Point(0,1)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,0),new Point(0,0)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,0),new Point(0,0)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,0),new Point(0,0)]),Vector.<Point>([new Point(0,0)
      ,new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,0),new Point(0,0)]),Vector.<Point>([new Point(16,0),new Point(16,0),new Point(16,0),new Point(16,0),new Point(16,-1),new Point(16,0),new Point(16,0)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,0),new Point(0,0)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,0),new Point(0,0)]),Vector.<Point>([new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,0),new Point(0,-1),new Point(0,0),new Point(0,0)])];
      
      public var MapClickFlag:Boolean;
      
      private var _bg:Sprite;
      
      private var _playerBg:Sprite;
      
      private var _playerSprite:Sprite;
      
      private var _touchArea:Sprite;
      
      private var _hallView:MovieClip;
      
      private var _sceneScene:SceneScene;
      
      private var _meshLayer:Sprite;
      
      private var _hallBg:Sprite;
      
      private var _mouseMovie:MovieClip;
      
      private var _selfPlayer:HallPlayer;
      
      private var _friendPlayerDic:Dictionary;
      
      private var _playerArray:Array;
      
      private var _clickDate:Number = 0;
      
      private var _playerPos:Point = new Point(1456,496);
      
      private var _mapID:int;
      
      private var _hidFlag:Boolean;
      
      private var _loadPlayerDic:Dictionary;
      
      private var _unLoadPlayerDic:Dictionary;
      
      private var _loadPkg:PackageIn;
      
      private var _loadTimer:Timer;
      
      public function HallPlayerView(bg:Sprite, id:int)
      {
         super();
         this._bg = bg;
         this._playerBg = new Sprite();
         this._playerSprite = new Sprite();
         this._touchArea = new Sprite();
         this._friendPlayerDic = new Dictionary();
         this._playerArray = [];
         this._loadTimer = new Timer(500);
         this._loadTimer.addEventListener(TimerEvent.TIMER,this.__onloadPlayerRes);
         this.mapID = id;
         this._bg.addChild(this._playerBg);
         this._bg.addChild(this._playerSprite);
         this._bg.addChild(this._touchArea);
         this.initView();
         this.initEvent();
         initFlag = true;
         this.sendPkg();
      }
      
      private function initView() : void
      {
         this._hallView = ComponentFactory.Instance.creat("asset.hall.hallMainViewAsset0") as MovieClip;
         this._playerBg.addChild(this._hallView);
         this._hallBg = this._hallView.getChildByName("bg") as Sprite;
         this._meshLayer = this._hallView.getChildByName("mesh") as Sprite;
         this._meshLayer.alpha = 0;
         petsDisInfo = ComponentFactory.Instance.creatCustomObject("hall.petsInfo");
      }
      
      private function sendPkg() : void
      {
         var self:SelfInfo = PlayerManager.Instance.Self;
         if(self.isOld && self.Grade > 19 && !self.getOptionState(OpitionEnum.IsShowNewVersionGuide))
         {
            NewVersionGuideManager.instance.addEventListener(NewVersionGuideEvent.GUIDECOMPLETE,this.__sendPkg);
            NewVersionGuideManager.instance.setUp(this._hallView);
            return;
         }
         SocketManager.Instance.out.sendOtherPlayerInfo();
         PlayerManager.Instance.Self.OptionOnOff = OpitionEnum.setOpitionState(true,OpitionEnum.IsShowNewVersionGuide);
         SocketManager.Instance.out.sendOpition(PlayerManager.Instance.Self.OptionOnOff);
      }
      
      private function __sendPkg(event:NewVersionGuideEvent) : void
      {
         NewVersionGuideManager.instance.removeEventListener(NewVersionGuideEvent.GUIDECOMPLETE,this.__sendPkg);
         SocketManager.Instance.out.sendOtherPlayerInfo();
      }
      
      private function initEvent() : void
      {
         this._bg.addEventListener(MouseEvent.CLICK,this.__onPlayerClick);
         PlayerManager.Instance.addEventListener(NewHallEvent.SETSELFPLAYERPOS,this.__onSetSelfPlayerPos);
         PlayerManager.Instance.addEventListener(NewHallEvent.SHOWPETS,this.__onShowPets);
         SocketManager.Instance.addEventListener(PlayerDressEvent.UPDATE_PLAYERINFO,this.__updatePlayerDressInfo);
         SocketManager.Instance.addEventListener(NewHallEvent.UPDATETITLE,this.__updatePlayerTitle);
         SocketManager.Instance.addEventListener(NewHallEvent.PLAYERINFO,this.__onFriendPlayerInfo);
         SocketManager.Instance.addEventListener(NewHallEvent.OTHERPLAYERINFO,this.__onOtherFriendPlayerInfo);
         SocketManager.Instance.addEventListener(NewHallEvent.PLAYEREXIT,this.__onFriendPlayerExit);
         SocketManager.Instance.addEventListener(NewHallEvent.PLAYERMOVE,this.__onFriendPlayerMove);
         SocketManager.Instance.addEventListener(NewHallEvent.ADDPLAYE,this.__onAddNewPlayer);
         SocketManager.Instance.addEventListener(NewHallEvent.MODIFYDRESS,this.__onAddModifyPlayerDress);
         SocketManager.Instance.addEventListener(NewHallEvent.PLAYERHID,this.__onPlayerHid);
         SocketManager.Instance.addEventListener(NewHallEvent.UPDATEPLAYERTITLE,this.__onUpdatePlayerTitle);
      }
      
      protected function __onUpdatePlayerTitle(event:NewHallEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var id:int = pkg.readInt();
         var title:String = pkg.readUTF();
         var titleId:int = pkg.readInt();
         if(Boolean(this._loadPlayerDic[id]))
         {
            this._loadPlayerDic[id].playerInfo.honor = title;
            this._loadPlayerDic[id].playerInfo.honorId = titleId;
         }
         else if(Boolean(this._unLoadPlayerDic[id]))
         {
            this._unLoadPlayerDic[id].playerInfo.honor = title;
            this._unLoadPlayerDic[id].playerInfo.honorId = titleId;
         }
         else if(Boolean(this._friendPlayerDic[id]))
         {
            this._friendPlayerDic[id].playerVO.playerInfo.honor = title;
            this._friendPlayerDic[id].playerVO.playerInfo.honorId = titleId;
            this._friendPlayerDic[id].showPlayerTitle();
         }
      }
      
      protected function __onShowPets(event:NewHallEvent) : void
      {
         if(Boolean(this._selfPlayer))
         {
            this._selfPlayer.showPets(event.data[0],event.data[1]);
         }
      }
      
      protected function __onFriendPlayerInfo(event:NewHallEvent) : void
      {
         var playerVo:PlayerVO = null;
         var pkg:PackageIn = event.pkg;
         this._playerPos = new Point(pkg.readInt(),pkg.readInt());
         var playerNum:int = pkg.readInt();
         this._loadPkg = pkg;
         this._loadPlayerDic = new Dictionary();
         this._unLoadPlayerDic = new Dictionary();
         this.removePlayerByID();
         for(var i:int = 0; i < playerNum; i++)
         {
            playerVo = this.readPlayerInfoPkg(this._loadPkg);
            if(this.judgePlayerShow(playerVo.currentWalkStartPoint.x))
            {
               this._loadPlayerDic[playerVo.playerInfo.ID] = playerVo;
            }
            else
            {
               this._unLoadPlayerDic[playerVo.playerInfo.ID] = playerVo;
            }
         }
         if(!this._selfPlayer)
         {
            this.addSelfPlayer();
         }
         else
         {
            setTimeout(this.startLoadOtherPlayer,1500);
         }
      }
      
      private function startLoadOtherPlayer(flag:Boolean = true) : void
      {
         if(flag && !this.hasEventListener(Event.ENTER_FRAME))
         {
            addEventListener(Event.ENTER_FRAME,this.__updateFrame);
         }
         if(Boolean(this._loadTimer) && !this._loadTimer.running)
         {
            this._loadTimer.start();
         }
      }
      
      private function judgePlayerShow(playerX:int) : Boolean
      {
         var pos:Point = PositionUtils.creatPoint("hall.playerInfoPos");
         var offX:int = playerX + this._bg.x;
         if(offX > pos.x && offX < pos.y)
         {
            return true;
         }
         return false;
      }
      
      protected function __onloadPlayerRes(event:TimerEvent) : void
      {
         var id:String = null;
         var _loc3_:int = 0;
         var _loc4_:* = this._loadPlayerDic;
         for(id in _loc4_)
         {
            if(Boolean(this._loadPlayerDic[id]))
            {
               this.setPlayerInfo(this._loadPlayerDic[id]);
               delete this._loadPlayerDic[id];
            }
            else
            {
               this._loadPlayerDic = new Dictionary();
               this._loadTimer.stop();
               this._loadTimer.reset();
            }
         }
      }
      
      protected function __onPlayerHid(event:NewHallEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._hidFlag = pkg.readBoolean();
         if(this._hidFlag)
         {
            this.removePlayerByID();
            this._loadPlayerDic = new Dictionary();
            this._unLoadPlayerDic = new Dictionary();
         }
         var frameID:int = this._hidFlag ? 1 : 2;
         DailyButtunBar.Insance.setEyeBtnFrame(frameID);
      }
      
      protected function __updatePlayerTitle(event:NewHallEvent) : void
      {
         if(Boolean(this._selfPlayer))
         {
            if(NewTitleManager.instance.ShowTitle)
            {
               this._selfPlayer.showPlayerTitle();
            }
            else
            {
               this._selfPlayer.removePlayerTitle();
            }
         }
      }
      
      protected function __updatePlayerDressInfo(event:PlayerDressEvent) : void
      {
         if(Boolean(this._selfPlayer))
         {
            this._selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            this._selfPlayer.removeEventListener(NewHallEvent.BTNCLICK,this.__onFishWalk);
            this._playerSprite.removeChild(this._selfPlayer);
            this._playerArray.splice(this.getPlayerIndexById(this._selfPlayer.playerVO.playerInfo.ID),1);
            this._selfPlayer.dispose();
            this._selfPlayer = null;
         }
         this.addSelfPlayer();
      }
      
      protected function __onAddModifyPlayerDress(event:NewHallEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var playerVo:PlayerVO = this.readPlayerInfoPkg(pkg);
         this.removePlayerByID(playerVo.playerInfo.ID);
         if(this.judgePlayerShow(playerVo.currentWalkStartPoint.x))
         {
            if(!this._hidFlag)
            {
               this.setPlayerInfo(playerVo);
            }
         }
         else
         {
            this._unLoadPlayerDic[playerVo.playerInfo.ID] = playerVo;
         }
      }
      
      protected function __onAddNewPlayer(event:NewHallEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var playerVo:PlayerVO = this.readPlayerInfoPkg(pkg);
         if(this.judgePlayerShow(playerVo.currentWalkStartPoint.x))
         {
            if(!this._hidFlag)
            {
               this._loadPlayerDic[playerVo.playerInfo.ID] = playerVo;
               this.startLoadOtherPlayer();
            }
         }
         else
         {
            this._unLoadPlayerDic[playerVo.playerInfo.ID] = playerVo;
         }
      }
      
      protected function __onFriendPlayerMove(event:NewHallEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var id:int = pkg.readInt();
         var pos:Point = new Point(pkg.readInt(),pkg.readInt());
         var index:int = this.getPlayerIndexById(id);
         if(index != -1)
         {
            this._playerArray[index].playerVO.walkPath = this._sceneScene.searchPath(this._playerArray[index].playerPoint,pos);
            this._playerArray[index].playerVO.walkPath.shift();
            this._playerArray[index].playerVO.currentWalkStartPoint = this._playerArray[index].currentWalkStartPoint;
            return;
         }
         if(Boolean(this._unLoadPlayerDic[id]))
         {
            this._unLoadPlayerDic[id].currentWalkStartPoint = pos;
            return;
         }
         SocketManager.Instance.out.sendAddNewPlayer(id);
      }
      
      protected function __onFriendPlayerExit(event:NewHallEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var id:int = pkg.readInt();
         if(Boolean(this._unLoadPlayerDic[id]))
         {
            delete this._unLoadPlayerDic[id];
            return;
         }
         if(Boolean(this._loadPlayerDic[id]))
         {
            delete this._loadPlayerDic[id];
            return;
         }
         this.removePlayerByID(id);
      }
      
      private function addSelfPlayer() : void
      {
         var mvClass:Class = null;
         if(!this._mouseMovie)
         {
            mvClass = ClassUtils.uiSourceDomain.getDefinition("asset.hall.MouseClickMovie") as Class;
            this._mouseMovie = new mvClass() as MovieClip;
            this._mouseMovie.mouseChildren = false;
            this._mouseMovie.mouseEnabled = false;
            this._mouseMovie.stop();
            this._touchArea.addChild(this._mouseMovie);
         }
         this._sceneScene = new SceneScene();
         this._sceneScene.setHitTester(new PathMapHitTester(this._meshLayer));
         var selfPlayerVO:PlayerVO = new PlayerVO();
         selfPlayerVO.playerInfo = PlayerManager.Instance.Self;
         this._selfPlayer = new HallPlayer(selfPlayerVO,this.addPlayerCallBack);
         this._selfPlayer.mouseEnabled = false;
         this._selfPlayer.mouseChildren = false;
         this._selfPlayer.addEventListener(NewHallEvent.BTNCLICK,this.__onFishWalk);
         this._playerArray.push(this._selfPlayer);
      }
      
      protected function __onOtherFriendPlayerInfo(event:NewHallEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         if(!this._hidFlag)
         {
            this.setPlayerInfo(this.readPlayerInfoPkg(pkg),true);
         }
      }
      
      private function readPlayerInfoPkg(pkg:PackageIn) : PlayerVO
      {
         var friendVo:PlayerVO = new PlayerVO();
         friendVo.playerInfo = new PlayerInfo();
         friendVo.playerInfo.ID = pkg.readInt();
         friendVo.playerInfo.NickName = pkg.readUTF();
         friendVo.playerInfo.VIPLevel = pkg.readInt();
         friendVo.playerInfo.typeVIP = pkg.readInt();
         friendVo.playerInfo.Sex = pkg.readBoolean();
         friendVo.playerInfo.Style = pkg.readUTF();
         friendVo.playerInfo.Colors = pkg.readUTF();
         friendVo.playerInfo.MountsType = pkg.readInt();
         friendVo.playerInfo.PetsID = pkg.readInt();
         friendVo.currentWalkStartPoint = new Point(pkg.readInt(),pkg.readInt());
         friendVo.playerInfo.ConsortiaID = pkg.readInt();
         friendVo.playerInfo.badgeID = pkg.readInt();
         friendVo.playerInfo.ConsortiaName = pkg.readUTF();
         friendVo.playerInfo.honor = pkg.readUTF();
         friendVo.playerInfo.honorId = pkg.readInt();
         return friendVo;
      }
      
      private function setPlayerInfo(friendVo:PlayerVO, deleteFlag:Boolean = false) : void
      {
         if(deleteFlag)
         {
            this.removePlayerByID(friendVo.playerInfo.ID);
         }
         var friendPlayer:HallPlayer = new HallPlayer(friendVo,this.addPlayerCallBack);
      }
      
      private function removePlayerByID(id:int = 0) : void
      {
         var hallPlayer:HallPlayer = null;
         var key:String = null;
         var index:int = 0;
         if(id != 0)
         {
            if(Boolean(this._friendPlayerDic[id]))
            {
               hallPlayer = this._friendPlayerDic[id];
               if(this._playerSprite.contains(hallPlayer))
               {
                  this._playerSprite.removeChild(hallPlayer);
               }
               index = this.getPlayerIndexById(hallPlayer.playerVO.playerInfo.ID);
               if(index != -1)
               {
                  this._playerArray.splice(index,1);
               }
               delete this._friendPlayerDic[id];
               hallPlayer.dispose();
               hallPlayer = null;
            }
         }
         else
         {
            for(key in this._friendPlayerDic)
            {
               hallPlayer = this._friendPlayerDic[key];
               if(this._playerSprite.contains(hallPlayer))
               {
                  this._playerSprite.removeChild(hallPlayer);
               }
               hallPlayer.dispose();
               hallPlayer = null;
            }
            this._playerArray = new Array();
            if(Boolean(this._selfPlayer))
            {
               this._playerArray.push(this._selfPlayer);
            }
            this._friendPlayerDic = new Dictionary();
         }
      }
      
      private function addPlayerCallBack(hallPlayer:HallPlayer, isLoadSucceed:Boolean, vFlag:int) : void
      {
         if(vFlag == 0)
         {
            if(!hallPlayer)
            {
               return;
            }
            hallPlayer.setSceneCharacterDirectionDefault = hallPlayer.sceneCharacterDirection = hallPlayer.playerVO.scenePlayerDirection;
            if(!this._selfPlayer && hallPlayer.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               hallPlayer.sceneScene = this._sceneScene;
               this._selfPlayer = hallPlayer;
               this._selfPlayer.playerPoint = this._playerPos;
               if(NewTitleManager.instance.ShowTitle)
               {
                  this._selfPlayer.showPlayerTitle();
               }
               this._playerSprite.addChild(this._selfPlayer);
               this.ajustScreen();
               this.setCenter();
               this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
               setTimeout(this.startLoadOtherPlayer,1500);
            }
            else
            {
               hallPlayer.playerPoint = hallPlayer.playerVO.currentWalkStartPoint;
               if(this.getPlayerIndexById(hallPlayer.playerVO.playerInfo.ID) == -1)
               {
                  this._playerSprite.addChild(hallPlayer);
                  this._playerArray.push(hallPlayer);
               }
               hallPlayer.mouseEnabled = false;
               hallPlayer.showPlayerTitle();
               this._friendPlayerDic[hallPlayer.playerVO.playerInfo.ID] = hallPlayer;
            }
            hallPlayer.showPlayerInfo(petsDisInfo.disDic[hallPlayer.playerVO.playerInfo.MountsType]);
            hallPlayer.sceneCharacterStateType = "natural";
         }
      }
      
      private function playerActionChange(evt:SceneCharacterEvent) : void
      {
         var type:String = evt.data.toString();
         if(type == "naturalStandFront" || type == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
         }
      }
      
      protected function __updateFrame(event:Event) : void
      {
         var dis:Number = NaN;
         if(!this._playerArray)
         {
            removeEventListener(Event.ENTER_FRAME,this.__updateFrame);
            return;
         }
         this._playerArray.sortOn("playerY",Array.NUMERIC);
         for(var i:int = 0; i < this._playerArray.length; i++)
         {
            if(Boolean(this._playerArray[i]))
            {
               this._playerSprite.setChildIndex(this._playerArray[i],i);
               this._playerArray[i].updatePlayer();
               this._playerArray[i].visible = this.judgePlayerShow(this._playerArray[i].playerPoint.x);
               dis = Point.distance(this._selfPlayer.playerPoint,this._playerArray[i].playerPoint);
               if(this._playerArray[i].playerY > this._selfPlayer.playerY && dis < 100)
               {
                  this._playerArray[i].alpha = 0.5;
               }
               else
               {
                  this._playerArray[i].alpha = 1;
               }
            }
         }
      }
      
      protected function __onPlayerClick(event:MouseEvent) : void
      {
         var lastClick:Number = NaN;
         var clickInterval:Number = NaN;
         var targetPoint:Point = null;
         PlayerManager.Instance.dispatchEvent(new NewHallEvent(NewHallEvent.UPDATETIPSINFO,null,[null]));
         if(Boolean(this._selfPlayer))
         {
            lastClick = 0;
            clickInterval = 200;
            targetPoint = this._bg.globalToLocal(new Point(event.stageX,event.stageY));
            if(getTimer() - lastClick > clickInterval)
            {
               lastClick = getTimer();
               if(this.setSelfPlayerPos(targetPoint))
               {
                  this.MapClickFlag = true;
               }
            }
         }
      }
      
      protected function __onSetSelfPlayerPos(event:NewHallEvent) : void
      {
         var targetPoint:Point = this._bg.globalToLocal(new Point(event.data[0].stageX,event.data[0].stageY));
         if(this.setSelfPlayerPos(targetPoint,true))
         {
            this.MapClickFlag = true;
         }
      }
      
      public function setSelfPlayerPos(pos:Point, mouseFlag:Boolean = true) : Boolean
      {
         if(!this._sceneScene.hit(pos))
         {
            pos = this.setPlayerBorderPos(pos);
            this._mouseMovie.visible = mouseFlag;
            this._mouseMovie.x = pos.x;
            this._mouseMovie.y = pos.y;
            this._mouseMovie.play();
            this._playerPos = pos;
            this._selfPlayer.playerVO.walkPath = this._sceneScene.searchPath(this._selfPlayer.playerPoint,pos);
            this._selfPlayer.playerVO.walkPath.shift();
            this._selfPlayer.playerVO.currentWalkStartPoint = this._selfPlayer.currentWalkStartPoint;
            if(new Date().time - this._clickDate > 1000)
            {
               this._clickDate = new Date().time;
               this.sendMyPosition(this._selfPlayer.playerVO.walkPath.concat());
            }
            return true;
         }
         return false;
      }
      
      public function setPlayerBorderPos(pos:Point) : Point
      {
         if(this._mapID == 1 && this._selfPlayer.playerVO.playerInfo.Grade <= 10)
         {
            if(pos.x < 942)
            {
               pos.x = 942;
            }
            if(pos.x > 1863)
            {
               pos.x = 1863;
            }
         }
         else
         {
            if(pos.x < 73)
            {
               pos.x = 73;
            }
            if(pos.x > 3166)
            {
               pos.x = 3166;
            }
         }
         return pos;
      }
      
      protected function __onFishWalk(event:NewHallEvent) : void
      {
         if(!this.MapClickFlag)
         {
            dispatchEvent(new NewHallEvent(NewHallEvent.BTNCLICK));
         }
         this.MapClickFlag = false;
      }
      
      public function sendMyPosition(p:Array) : void
      {
         var i:uint = 0;
         for(var arr:Array = []; i < p.length; )
         {
            arr.push(int(p[i].x),int(p[i].y));
            i++;
         }
         SocketManager.Instance.out.sendPlayerPos(p[p.length - 1].x,p[p.length - 1].y);
      }
      
      protected function ajustScreen() : void
      {
         this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT,this.setCenter);
      }
      
      public function setCenter(event:SceneCharacterEvent = null) : void
      {
         var xf:Number = NaN;
         var yf:Number = NaN;
         var id1:String = null;
         var id2:String = null;
         if(this._mapID == 1)
         {
            this._bg.x = -900;
            return;
         }
         if(Boolean(this._selfPlayer))
         {
            xf = -(this._selfPlayer.x - MoonSceneMap.GAME_WIDTH / 2);
            yf = -(this._selfPlayer.y - MoonSceneMap.GAME_HEIGHT / 2) + 50;
         }
         if(xf > 0)
         {
            xf = 0;
         }
         if(xf < MoonSceneMap.GAME_WIDTH - this._hallBg.width)
         {
            xf = MoonSceneMap.GAME_WIDTH - this._hallBg.width;
         }
         if(yf > 0)
         {
            yf = 0;
         }
         if(yf < MoonSceneMap.GAME_HEIGHT - this._hallBg.height)
         {
            yf = MoonSceneMap.GAME_HEIGHT - this._hallBg.height;
         }
         this._bg.x = xf;
         this._bg.y = yf;
         for(id1 in this._unLoadPlayerDic)
         {
            if(!this._hidFlag && this._unLoadPlayerDic[id1] && Boolean(this._unLoadPlayerDic[id1].currentWalkStartPoint) && this.judgePlayerShow(this._unLoadPlayerDic[id1].currentWalkStartPoint.x))
            {
               this._loadPlayerDic[this._unLoadPlayerDic[id1].playerInfo.ID] = this._unLoadPlayerDic[id1];
               delete this._unLoadPlayerDic[id1];
            }
         }
         for(id2 in this._loadPlayerDic)
         {
            if(Boolean(this._loadPlayerDic[id2]))
            {
               this.startLoadOtherPlayer(false);
               break;
            }
         }
      }
      
      public function moveBgToTargetPos(posX:Number, posY:Number, delay:Number) : void
      {
         TweenLite.to(this._bg,delay,{
            "x":posX,
            "y":posY
         });
      }
      
      public function getSelfPlayerPos() : Point
      {
         if(Boolean(this._selfPlayer))
         {
            return this._selfPlayer.playerPoint;
         }
         return new Point(this._playerPos.x,this._playerPos.y);
      }
      
      private function getPlayerIndexById(id:int) : int
      {
         var index:int = -1;
         for(var i:int = 0; i < this._playerArray.length; i++)
         {
            if(this._playerArray[i].playerVO.playerInfo.ID == id)
            {
               index = i;
               break;
            }
         }
         return index;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__updateFrame);
         this._bg.removeEventListener(MouseEvent.CLICK,this.__onPlayerClick);
         PlayerManager.Instance.removeEventListener(NewHallEvent.SETSELFPLAYERPOS,this.__onSetSelfPlayerPos);
         PlayerManager.Instance.removeEventListener(NewHallEvent.SHOWPETS,this.__onShowPets);
         SocketManager.Instance.removeEventListener(PlayerDressEvent.UPDATE_PLAYERINFO,this.__updatePlayerDressInfo);
         SocketManager.Instance.removeEventListener(NewHallEvent.UPDATETITLE,this.__updatePlayerTitle);
         SocketManager.Instance.removeEventListener(NewHallEvent.PLAYERINFO,this.__onFriendPlayerInfo);
         SocketManager.Instance.removeEventListener(NewHallEvent.OTHERPLAYERINFO,this.__onOtherFriendPlayerInfo);
         SocketManager.Instance.removeEventListener(NewHallEvent.PLAYEREXIT,this.__onFriendPlayerExit);
         SocketManager.Instance.removeEventListener(NewHallEvent.PLAYERMOVE,this.__onFriendPlayerMove);
         SocketManager.Instance.removeEventListener(NewHallEvent.ADDPLAYE,this.__onAddNewPlayer);
         SocketManager.Instance.removeEventListener(NewHallEvent.MODIFYDRESS,this.__onAddModifyPlayerDress);
         SocketManager.Instance.removeEventListener(NewHallEvent.PLAYERHID,this.__onPlayerHid);
         SocketManager.Instance.removeEventListener(NewHallEvent.UPDATEPLAYERTITLE,this.__onUpdatePlayerTitle);
      }
      
      public function dispose() : void
      {
         initFlag = false;
         this.removeEvent();
         if(Boolean(this._hallView))
         {
            this._hallView = null;
         }
         if(Boolean(this._hallBg))
         {
            this._hallBg = null;
         }
         if(Boolean(this._selfPlayer))
         {
            this._selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
            this._selfPlayer.removeEventListener(NewHallEvent.BTNCLICK,this.__onFishWalk);
            this._selfPlayer.dispose();
            this._selfPlayer = null;
         }
         if(Boolean(this._sceneScene))
         {
            this._sceneScene.dispose();
            this._sceneScene = null;
         }
         if(Boolean(this._loadTimer))
         {
            this._loadTimer.removeEventListener(TimerEvent.TIMER,this.__onloadPlayerRes);
            this._loadTimer.stop();
            this._loadTimer.reset();
            this._loadTimer = null;
         }
         this.removePlayerByID();
         this._friendPlayerDic = null;
         this._playerArray = null;
         this._loadPlayerDic = null;
         this._unLoadPlayerDic = null;
         if(Boolean(this._mouseMovie))
         {
            ObjectUtils.disposeObject(this._mouseMovie);
            this._mouseMovie = null;
         }
         if(Boolean(this._meshLayer))
         {
            ObjectUtils.disposeAllChildren(this._meshLayer);
            this._meshLayer = null;
         }
         if(Boolean(this._playerBg))
         {
            ObjectUtils.disposeAllChildren(this._playerBg);
            this._playerBg = null;
         }
         if(Boolean(this._playerSprite))
         {
            ObjectUtils.disposeAllChildren(this._playerSprite);
            this._playerSprite = null;
         }
         if(Boolean(this._touchArea))
         {
            ObjectUtils.disposeAllChildren(this._touchArea);
            this._touchArea = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeAllChildren(this._bg);
            this._bg = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get hallView() : MovieClip
      {
         return this._hallView;
      }
      
      public function get touchArea() : Sprite
      {
         return this._touchArea;
      }
      
      public function set mapID(value:int) : void
      {
         this._mapID = value;
         if(this._mapID == 1)
         {
            this.setCenter();
         }
      }
   }
}

