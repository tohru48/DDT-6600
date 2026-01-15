package campbattle.view
{
   import campbattle.CampBattleManager;
   import campbattle.data.RoleData;
   import campbattle.view.roleView.CampBattleMonsterRole;
   import campbattle.view.roleView.CampBattleOtherRole;
   import campbattle.view.roleView.CampBattlePlayer;
   import campbattle.view.roleView.CampGameSmallEnemy;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import game.model.SmallEnemy;
   import game.objects.GameLiving;
   import hall.event.NewHallEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class CampBattleMap extends Sprite
   {
      
      public static const GAME_WIDTH:int = 1000;
      
      public static const GAME_HEIGHT:int = 600;
      
      public static var MAP_SIZE:Array = [3208,2000];
      
      protected var _mapClassDefinition:String;
      
      protected var _playerModel:DictionaryData;
      
      protected var _monsterModel:DictionaryData;
      
      protected var _bgLayer:Sprite;
      
      protected var _articleLayer:Sprite;
      
      protected var _decorationLayer:Sprite;
      
      protected var _meshLayer:Sprite;
      
      protected var _sceneScene:SceneScene;
      
      private var _roleList:Array;
      
      private var _monsterList:Array;
      
      private var _isLoadMapComplete:Boolean;
      
      private var _targetRole:CampBattlePlayer;
      
      private var _mainRole:CampBattlePlayer;
      
      private var _actItemList:Array;
      
      private var _gameLiving:GameLiving;
      
      private var _sendMove:Function;
      
      private var _mouseMovie:MovieClip;
      
      private var _antoObjList:Array;
      
      private var _lastClick:Number = 0;
      
      private var _clickInterval:Number = 200;
      
      private var _addMonsterTimer:Timer;
      
      private var _mIndex:int;
      
      private var _mapResUrl:String;
      
      private var _smallMap:Bitmap;
      
      public function CampBattleMap(mapClassDefinition:String, mapResUrl:String, playerModel:DictionaryData = null, monsterModel:DictionaryData = null, actItemList:Array = null, smallMap:Bitmap = null)
      {
         super();
         this._actItemList = actItemList;
         this._mapClassDefinition = mapClassDefinition;
         this._playerModel = new DictionaryData();
         this._playerModel.setData(playerModel);
         this._monsterModel = monsterModel;
         this._roleList = [];
         this._monsterList = [];
         this._antoObjList = [];
         this._mapResUrl = mapResUrl;
         this._smallMap = smallMap;
         if(Boolean(this._smallMap))
         {
            addChild(this._smallMap);
         }
         this.loaderMap(mapResUrl);
      }
      
      private function loaderMap(str:String) : void
      {
         var mapLoader:BaseLoader = LoadResourceManager.Instance.createLoader(str,BaseLoader.MODULE_LOADER);
         mapLoader.addEventListener(LoaderEvent.COMPLETE,this.onMapLoadComplete);
         mapLoader.addEventListener(LoaderEvent.LOAD_ERROR,this.onMapLoadError);
         LoadResourceManager.Instance.startLoad(mapLoader);
      }
      
      protected function onMapLoadError(event:LoaderEvent) : void
      {
         ChatManager.Instance.sysChatRed("地图资源加载出错Url=" + this._mapResUrl);
      }
      
      private function onMapLoadComplete(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.onMapLoadComplete);
         this._isLoadMapComplete = true;
         this.initMap();
         this.initEvent();
         this.initSceneScene();
         this.initPlayerList();
         this.initMonstersList();
      }
      
      private function initPlayerList() : void
      {
         for(var i:int = 0; i < this._playerModel.length; i++)
         {
            this.addRoleToMap(this._playerModel.list[i]);
         }
      }
      
      private function initMonstersList() : void
      {
         if(this._monsterModel.length > 0)
         {
            this._addMonsterTimer = new Timer(500);
            this._addMonsterTimer.repeatCount = this._monsterModel.length;
            this._addMonsterTimer.start();
            this._addMonsterTimer.addEventListener(TimerEvent.TIMER,this.__onMonsterTimerHander);
            this._addMonsterTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__onMonsterTimerCompleteHander);
         }
      }
      
      private function __onMonsterTimerHander(e:TimerEvent) : void
      {
         var eData:SmallEnemy = this._monsterModel.list[this._mIndex] as SmallEnemy;
         var sEnemy:CampGameSmallEnemy = new CampGameSmallEnemy(eData);
         PositionUtils.setPos(sEnemy,eData.pos);
         this._monsterList.push(sEnemy);
         this._antoObjList.push(sEnemy);
         this._articleLayer.addChild(sEnemy);
         ++this._mIndex;
      }
      
      private function __onMonsterTimerCompleteHander(event:TimerEvent) : void
      {
         this._addMonsterTimer.stop();
         this._addMonsterTimer.removeEventListener(TimerEvent.TIMER,this.__onMonsterTimerHander);
         this._addMonsterTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onMonsterTimerCompleteHander);
         this._addMonsterTimer = null;
         this._mIndex = 0;
      }
      
      private function checkRoleList() : void
      {
         var role:CampBattlePlayer = null;
         var disX:int = 0;
         var disY:int = 0;
         if(this._roleList.length != this._playerModel.length)
         {
            return;
         }
         var len:int = int(this._roleList.length);
         for(var i:int = 0; i < len; i++)
         {
            role = this._roleList[i] as CampBattlePlayer;
            if(!(role.playerInfo.zoneID == PlayerManager.Instance.Self.ZoneID && role.playerInfo.ID == PlayerManager.Instance.Self.ID))
            {
               disX = Math.abs(this._mainRole.x - role.x);
               disY = Math.abs(this._mainRole.y - role.y);
               role.visible = disX > 500 || disY > 300 ? false : true;
            }
         }
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onPlayerClickHander);
         addEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         if(Boolean(this._monsterModel))
         {
            this._monsterModel.addEventListener(DictionaryEvent.ADD,this.__onAddMonsters);
            this._monsterModel.addEventListener(DictionaryEvent.REMOVE,this.__onRemoveMonsters);
         }
         this._playerModel.addEventListener(DictionaryEvent.ADD,this.__onAddPlayer);
         this._playerModel.addEventListener(DictionaryEvent.REMOVE,this.__onRemovePlayer);
         this._playerModel.addEventListener(DictionaryEvent.UPDATE,this.__onUpdatePlayerStatus);
         PlayerManager.Instance.addEventListener(NewHallEvent.SETSELFPLAYERPOS,this.__onSetSelfPlayerPos);
      }
      
      protected function __onSetSelfPlayerPos(event:NewHallEvent) : void
      {
         this.__onPlayerClickHander(event.data[0]);
      }
      
      protected function __onAddMonsters(event:DictionaryEvent) : void
      {
         var enemy:CampGameSmallEnemy = new CampGameSmallEnemy(event.data as SmallEnemy);
         enemy.setStateType((event.data as SmallEnemy).stateType);
         this._monsterList.push(enemy);
         this._articleLayer.addChild(enemy);
         this._antoObjList.push(enemy);
      }
      
      private function __onRemoveMonsters(event:DictionaryEvent) : void
      {
         var id:int = (event.data as SmallEnemy).LivingID;
         var index:int = this.getMonsterIndex(id);
         if(!this._monsterList[index])
         {
            return;
         }
         var enemy:CampGameSmallEnemy = this._monsterList[index] as CampGameSmallEnemy;
         this._monsterList.splice(index,1);
         this.deleAntoObjList(enemy);
         enemy.dispose();
         enemy.dispose();
         enemy = null;
      }
      
      public function getMonsterIndex(id:int) : int
      {
         var len:int = int(this._monsterList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(id == CampGameSmallEnemy(this._monsterList[i]).info.LivingID)
            {
               return i;
            }
         }
         return 0;
      }
      
      private function __onPlayerClickHander(e:MouseEvent) : void
      {
         var targetPoint:Point = null;
         if(!this._mainRole || this._mainRole.playerInfo.stateType == 4)
         {
            return;
         }
         this._targetRole = null;
         targetPoint = new Point(mouseX,mouseY);
         if(getTimer() - this._lastClick > this._clickInterval)
         {
            this._lastClick = getTimer();
            if(!this._sceneScene.hit(targetPoint))
            {
               this._mainRole.walk(targetPoint);
               this._mouseMovie.x = targetPoint.x;
               this._mouseMovie.y = targetPoint.y;
               this._mouseMovie.play();
               SocketManager.Instance.out.CampbattleRoleMove(this._mainRole.playerInfo.zoneID,this._mainRole.playerInfo.ID,targetPoint);
            }
         }
      }
      
      protected function initMouseMovie() : void
      {
         var mvClass:Class = ClassUtils.uiSourceDomain.getDefinition("asset.campBattle.MouseClickMovie") as Class;
         this._mouseMovie = new mvClass() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         this._bgLayer.addChild(this._mouseMovie);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._mainRole))
         {
            this._mainRole.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
         }
         removeEventListener(MouseEvent.CLICK,this.__onPlayerClickHander);
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHander);
         if(Boolean(this._monsterModel))
         {
            this._monsterModel.removeEventListener(DictionaryEvent.ADD,this.__onAddMonsters);
            this._monsterModel.removeEventListener(DictionaryEvent.REMOVE,this.__onRemoveMonsters);
         }
         this._playerModel.removeEventListener(DictionaryEvent.ADD,this.__onAddPlayer);
         this._playerModel.removeEventListener(DictionaryEvent.REMOVE,this.__onRemovePlayer);
         this._playerModel.removeEventListener(DictionaryEvent.UPDATE,this.__onUpdatePlayerStatus);
         PlayerManager.Instance.removeEventListener(NewHallEvent.SETSELFPLAYERPOS,this.__onSetSelfPlayerPos);
      }
      
      public function setCenter(event:SceneCharacterEvent = null, isReturn:Boolean = true, pos:Point = null) : void
      {
         var xf:Number = NaN;
         var yf:Number = NaN;
         var tmpPos:Point = null;
         if(Boolean(this._mainRole))
         {
            tmpPos = this._mainRole.playerPoint;
         }
         else
         {
            tmpPos = pos;
         }
         xf = -(tmpPos.x - GAME_WIDTH / 2);
         yf = -(tmpPos.y - GAME_HEIGHT / 2) + 50;
         if(xf > 0)
         {
            xf = 0;
         }
         if(xf < GAME_WIDTH - MAP_SIZE[0])
         {
            xf = GAME_WIDTH - MAP_SIZE[0];
         }
         if(yf > 0)
         {
            yf = 0;
         }
         if(yf < GAME_HEIGHT - MAP_SIZE[1])
         {
            yf = GAME_HEIGHT - MAP_SIZE[1];
         }
         x = xf;
         y = yf;
      }
      
      private function enterFrameHander(e:Event) : void
      {
         this.roleDeepthSort();
         if(Boolean(this._mainRole))
         {
            this.setCenter(null,false,this._mainRole.playerPoint);
            this.checkRoleList();
         }
      }
      
      public function checkPonitDistance(p:Point, fun:Function, id:int = 0, zoneID:int = 0) : void
      {
         var fp:Point = null;
         var dis:int = 0;
         var desPoint:Point = null;
         if(Boolean(this._mainRole))
         {
            fp = new Point(this._mainRole.x,this._mainRole.y);
            dis = Math.abs(Point.distance(fp,p));
            if(dis > 100)
            {
               desPoint = this.getDesPoint(fp,p,dis);
               this._mouseMovie.x = desPoint.x;
               this._mouseMovie.y = desPoint.y;
               this._mouseMovie.play();
               SocketManager.Instance.out.CampbattleRoleMove(this._mainRole.playerInfo.zoneID,this._mainRole.playerInfo.ID,desPoint);
               this._mainRole.walk(desPoint,fun,id,zoneID);
            }
            else if(id != 0 && zoneID != 0)
            {
               fun(zoneID,id);
            }
            else if(id != 0)
            {
               fun(id);
            }
            else
            {
               fun();
            }
         }
      }
      
      private function getDesPoint(fp:Point, p:Point, dis:int) : Point
      {
         var xOff:int = fp.x - p.x < 0 ? -1 : 1;
         var yOff:int = fp.y - p.y < 0 ? -1 : 1;
         return new Point(Math.abs(100 * (fp.x - p.x) / dis) * xOff + p.x,Math.abs(100 * (fp.y - p.y) / dis) * yOff + p.y);
      }
      
      private function roleDeepthSort() : void
      {
         var len:int = 0;
         var i:int = 0;
         if(this._antoObjList.length > 1)
         {
            len = int(this._antoObjList.length);
            this._antoObjList.sortOn("y",Array.NUMERIC);
            for(i = 0; i < len; i++)
            {
               this._articleLayer.addChild(this._antoObjList[i]);
            }
         }
      }
      
      protected function __onAddPlayer(event:DictionaryEvent) : void
      {
         this.addRoleToMap(event.data as RoleData);
      }
      
      private function addRoleToMap(data:RoleData) : void
      {
         var role:CampBattlePlayer = null;
         if(!data)
         {
            return;
         }
         if(data.zoneID == PlayerManager.Instance.Self.ZoneID && data.ID == PlayerManager.Instance.Self.ID)
         {
            role = this.creatRole(data,this.roleCallback);
            role.mouseEnabled = false;
            role.mouseChildren = false;
         }
         else
         {
            role = this.creatRole(data,this.otherRoleCallback);
            role.mouseEnabled = false;
         }
      }
      
      private function creatRole(roleData:RoleData, fun:Function) : CampBattlePlayer
      {
         var role:CampBattlePlayer = null;
         switch(roleData.type)
         {
            case 1:
               role = new CampBattlePlayer(roleData,fun);
               break;
            case 2:
               role = new CampBattleOtherRole(roleData,fun);
               break;
            case 3:
               role = new CampBattleMonsterRole(roleData,fun);
         }
         return role;
      }
      
      private function playerActionChange(evt:SceneCharacterEvent) : void
      {
         var type:String = evt.data.toString();
         if(type == "naturalStandFront" || type == "naturalStandBack")
         {
            if(Boolean(this._mouseMovie))
            {
               this._mouseMovie.gotoAndStop(1);
            }
         }
      }
      
      public function setRoleState(zoneID:int, userID:int, stateType:int) : void
      {
         var role:CampBattlePlayer = null;
         var len:int = int(this._roleList.length);
         for(var i:int = 0; i < len; i++)
         {
            role = this._roleList[i] as CampBattlePlayer;
            if(role.playerInfo.zoneID == zoneID && role.playerInfo.ID == userID)
            {
               role.setStateType(stateType);
               break;
            }
         }
      }
      
      public function setMonsterState(ID:int, stateType:int) : void
      {
         var enemy:CampGameSmallEnemy = null;
         var len:int = int(this._monsterList.length);
         for(var i:int = 0; i < len; i++)
         {
            enemy = this._monsterList[i] as CampGameSmallEnemy;
            if(enemy.info.LivingID == ID)
            {
               enemy.setStateType(stateType);
               break;
            }
         }
      }
      
      private function deleAntoObjList(obj:Object) : void
      {
         var len:int = int(this._antoObjList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(obj is CampBattlePlayer)
            {
               if(this._antoObjList[i] is CampBattlePlayer)
               {
                  if(CampBattlePlayer(obj).playerInfo.zoneID == CampBattlePlayer(this._antoObjList[i]).playerInfo.zoneID && CampBattlePlayer(obj).playerInfo.ID == CampBattlePlayer(this._antoObjList[i]).playerInfo.ID)
                  {
                     this._antoObjList.splice(i,1);
                     return;
                  }
               }
            }
            else if(obj is CampGameSmallEnemy)
            {
               if(this._antoObjList[i] is CampGameSmallEnemy)
               {
                  if(CampGameSmallEnemy(obj).LivingID == CampGameSmallEnemy(this._antoObjList[i]).LivingID && CampGameSmallEnemy(obj).LivingID == CampGameSmallEnemy(this._antoObjList[i]).LivingID)
                  {
                     this._antoObjList.splice(i,1);
                     return;
                  }
               }
            }
         }
      }
      
      private function roleCallback(role:CampBattlePlayer, isLoadSucceed:Boolean, vFlag:int = 1) : void
      {
         if(vFlag == 0)
         {
            if(Boolean(role))
            {
               this._mainRole = role;
               this._mainRole.sceneCharacterStateType = "natural";
               this._mainRole.update();
               this._mainRole.scene = this._sceneScene;
               this._mainRole.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE,this.playerActionChange);
               try
               {
                  this._articleLayer.addChild(this._mainRole);
                  this._roleList.push(this._mainRole);
                  this._antoObjList.push(role);
                  this.setCenter(null,false,this._mainRole.playerPoint);
               }
               catch(error:Error)
               {
               }
            }
         }
      }
      
      private function otherRoleCallback(role:CampBattlePlayer, isLoadSucceed:Boolean, vFlag:int = 1) : void
      {
         if(!role)
         {
            return;
         }
         if(vFlag != 0)
         {
            return;
         }
         role.sceneCharacterStateType = "natural";
         role.update();
         role.scene = this._sceneScene;
         role.mouseChildren = false;
         role.mouseEnabled = false;
         if(role.playerInfo.team != CampBattleManager.instance.model.myTeam)
         {
            role.mouseChildren = true;
         }
         this._articleLayer.addChild(role);
         this._roleList.push(role);
         this._antoObjList.push(role);
      }
      
      public function hideRoles(bool:Boolean) : void
      {
         var role:CampBattlePlayer = null;
         var len:int = int(this._roleList.length);
         for(var i:int = 0; i < len; i++)
         {
            role = this._roleList[i] as CampBattlePlayer;
            if(role.playerInfo.ID != PlayerManager.Instance.Self.ID)
            {
               role.visible = bool;
            }
         }
      }
      
      protected function __onUpdatePlayerStatus(event:DictionaryEvent) : void
      {
         var player:RoleData = null;
         var key:String = (event.data as RoleData).zoneID + "_" + (event.data as RoleData).ID;
         if(Boolean(this._playerModel[key]))
         {
            player = this._playerModel[key] as RoleData;
         }
      }
      
      public function getCurrRole(zoneID:int, userID:int) : CampBattlePlayer
      {
         var key:String = zoneID + "_" + userID;
         var index:int = this.getRoleIndex(key);
         return CampBattlePlayer(this._roleList[index]);
      }
      
      public function getMainRole() : CampBattlePlayer
      {
         return this._mainRole;
      }
      
      protected function __onRemovePlayer(event:DictionaryEvent) : void
      {
         var key:String = (event.data as RoleData).zoneID + "_" + (event.data as RoleData).ID;
         var index:int = this.getRoleIndex(key);
         var player:CampBattlePlayer = this._roleList[index] as CampBattlePlayer;
         this._roleList.splice(index,1);
         this.deleAntoObjList(player);
         if(player == this._targetRole)
         {
            this._targetRole = null;
         }
         if(Boolean(player))
         {
            if(Boolean(player.parent))
            {
               player.parent.removeChild(player);
            }
            player.dispose();
         }
         player = null;
      }
      
      public function roleMoves(zoneID:int, userID:int, p:Point) : void
      {
         var role:CampBattlePlayer = null;
         if(!this._roleList)
         {
            return;
         }
         var key:String = zoneID + "_" + userID;
         var index:int = this.getRoleIndex(key);
         if(Boolean(this._roleList[index]))
         {
            role = this._roleList[index] as CampBattlePlayer;
            role.walk(p);
         }
      }
      
      private function getRoleIndex(id:String) : int
      {
         var role:CampBattlePlayer = null;
         var len:int = int(this._roleList.length);
         for(var i:int = 0; i < len; i++)
         {
            role = this._roleList[i] as CampBattlePlayer;
            if(id == role.playerInfo.zoneID + "_" + role.playerInfo.ID)
            {
               return i;
            }
         }
         return 0;
      }
      
      private function initMap() : void
      {
         var mapRes:MovieClip = new (ClassUtils.uiSourceDomain.getDefinition(this._mapClassDefinition) as Class)() as MovieClip;
         var acticle:Sprite = mapRes.getChildByName("articleLayer") as Sprite;
         var mesh:Sprite = mapRes.getChildByName("mesh") as Sprite;
         var bg:Sprite = mapRes.getChildByName("bg") as Sprite;
         var bgSize:Sprite = mapRes.getChildByName("bgSize") as Sprite;
         var decoration:Sprite = mapRes.getChildByName("decoration") as Sprite;
         this._bgLayer = bg == null ? new Sprite() : bg;
         this._articleLayer = acticle == null ? new Sprite() : acticle;
         this._decorationLayer = decoration == null ? new Sprite() : decoration;
         this._decorationLayer.mouseEnabled = false;
         this._decorationLayer.mouseChildren = false;
         this._meshLayer = mesh == null ? new Sprite() : mesh;
         this._meshLayer.alpha = 0;
         this._meshLayer.mouseChildren = false;
         this._meshLayer.mouseEnabled = false;
         MAP_SIZE = [bg.width,bg.height];
         addChild(this._bgLayer);
         addChild(this._articleLayer);
         addChild(this._decorationLayer);
         addChild(this._meshLayer);
         this.initBtnList();
         this.initMouseMovie();
         if(Boolean(this._smallMap))
         {
            removeChild(this._smallMap);
            this._smallMap.bitmapData.dispose();
            this._smallMap = null;
         }
      }
      
      private function initBtnList() : void
      {
         var len:int = int(this._actItemList.length);
         for(var i:int = 0; i < len; i++)
         {
            this._articleLayer.addChild(this._actItemList[i]);
         }
      }
      
      private function clearBtnList() : void
      {
         var len:int = int(this._actItemList.length);
         for(var i:int = 0; i < len; i++)
         {
            ObjectUtils.disposeObject(this._actItemList[i]);
            this._actItemList[i] = null;
         }
      }
      
      protected function initSceneScene() : void
      {
         this._sceneScene = new SceneScene();
         this._sceneScene.setHitTester(new PathMapHitTester(this._meshLayer));
      }
      
      private function clearRoleList() : void
      {
         var role:CampBattlePlayer = null;
         var len:int = int(this._roleList.length);
         for(var i:int = 0; i < len; i++)
         {
            role = this._roleList[i];
            role.dispose();
            role = null;
         }
         this._roleList = [];
      }
      
      private function clearMonstList() : void
      {
         var em:CampGameSmallEnemy = null;
         var len:int = int(this._monsterList.length);
         for(var i:int = 0; i < len; i++)
         {
            em = this._monsterList[i];
            em.dispose();
            em = null;
         }
         this._monsterList.length = 0;
      }
      
      private function clearAntoObjList() : void
      {
         var em:CampGameSmallEnemy = null;
         var role:CampBattlePlayer = null;
         var len:int = int(this._antoObjList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this._antoObjList[i] is CampGameSmallEnemy)
            {
               em = this._antoObjList[i] as CampGameSmallEnemy;
               em.dispose();
               em = null;
            }
            else if(this._antoObjList[i] is CampBattlePlayer)
            {
               role = this._antoObjList[i] as CampBattlePlayer;
               role.dispose();
               role = null;
            }
         }
         this._antoObjList.length = 0;
      }
      
      public function dispose() : void
      {
         var disp:DisplayObject = null;
         var mc:MovieClip = null;
         if(Boolean(this._smallMap))
         {
            removeChild(this._smallMap);
            this._smallMap.bitmapData.dispose();
            this._smallMap = null;
         }
         if(Boolean(this._addMonsterTimer))
         {
            this._addMonsterTimer.stop();
            this._addMonsterTimer.removeEventListener(TimerEvent.TIMER,this.__onMonsterTimerHander);
            this._addMonsterTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__onMonsterTimerCompleteHander);
            this._addMonsterTimer = null;
         }
         this.removeEvent();
         this.clearRoleList();
         this.clearMonstList();
         this.clearBtnList();
         this.clearAntoObjList();
         while(Boolean(this._articleLayer.numChildren))
         {
            ObjectUtils.disposeObject(this._articleLayer.getChildAt(0));
         }
         while(Boolean(this._bgLayer.numChildren))
         {
            if(this._bgLayer.getChildAt(0) is DisplayObject)
            {
               disp = this._bgLayer.getChildAt(0) as DisplayObject;
               this._bgLayer.removeChild(disp);
               disp = null;
            }
            else
            {
               ObjectUtils.disposeObject(this._bgLayer.getChildAt(0));
            }
         }
         while(Boolean(this._meshLayer.numChildren))
         {
            ObjectUtils.disposeObject(this._meshLayer.getChildAt(0));
         }
         while(Boolean(this._decorationLayer.numChildren))
         {
            if(this._decorationLayer.getChildAt(0) is MovieClip)
            {
               mc = this._decorationLayer.getChildAt(0) as MovieClip;
               mc.stop();
               while(Boolean(mc.numChildren))
               {
                  ObjectUtils.disposeObject(mc.getChildAt(0));
               }
               ObjectUtils.disposeObject(mc);
               mc = null;
            }
            else
            {
               ObjectUtils.disposeObject(this._decorationLayer.getChildAt(0));
            }
         }
         ObjectUtils.disposeObject(this._mainRole);
         ObjectUtils.disposeObject(this._mouseMovie);
         ObjectUtils.disposeObject(this._bgLayer);
         ObjectUtils.disposeObject(this._articleLayer);
         ObjectUtils.disposeObject(this._decorationLayer);
         ObjectUtils.disposeObject(this._meshLayer);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._monsterModel = null;
         this._bgLayer = null;
         this._articleLayer = null;
         this._decorationLayer = null;
         this._meshLayer = null;
         this._roleList = null;
         this._monsterList = null;
         this._targetRole = null;
         this._playerModel = null;
         this._antoObjList = null;
         this._mouseMovie = null;
         this._mainRole = null;
      }
      
      public function get playerModel() : DictionaryData
      {
         return this._playerModel;
      }
   }
}

