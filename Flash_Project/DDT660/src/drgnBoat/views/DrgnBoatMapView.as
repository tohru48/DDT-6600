package drgnBoat.views
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import drgnBoat.DrgnBoatManager;
   import drgnBoat.components.DrgnBoatNPCpaopao;
   import drgnBoat.data.DrgnBoatCarInfo;
   import drgnBoat.data.DrgnBoatPlayerInfo;
   import drgnBoat.event.DrgnBoatEvent;
   import drgnBoat.player.DrgnBoatGameItem;
   import drgnBoat.player.DrgnBoatGamePlayer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class DrgnBoatMapView extends Sprite implements Disposeable
   {
      
      public static const LEN:int = 33600;
      
      public static const INIT_X:int = 280;
      
      private var _mapLayer:Sprite;
      
      private var _playerLayer:Sprite;
      
      private var _playerList:Vector.<DrgnBoatGamePlayer>;
      
      private var _selfPlayer:DrgnBoatGamePlayer;
      
      private var _itemList:DictionaryData = new DictionaryData();
      
      private var _playerItemList:Array = [];
      
      private var _rankArriveList:Array = [];
      
      private var _needRankList:DictionaryData;
      
      private var _isStartGame:Boolean = false;
      
      private var _mapBitmapData:BitmapData;
      
      private var _startMc:MovieClip;
      
      private var _endMc:MovieClip;
      
      private var _boguArr:Array;
      
      private var _finishTag:Bitmap;
      
      private var _runPercent:DrgnBoatRunPercent;
      
      private var _arriveCountDown:DrgnBoatArriveCountDown;
      
      private var _npcArriveTime:Date;
      
      private var _npcPlayer:DrgnBoatGamePlayer;
      
      private var _paopaoView:DrgnBoatNPCpaopao;
      
      private var _enterFrameCount:int = 0;
      
      private var _secondCount:int = 0;
      
      private var _beyondNPC:Boolean;
      
      private var _endFlag:Boolean = false;
      
      private var _isTween:Boolean = false;
      
      public function DrgnBoatMapView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set runPercent(value:DrgnBoatRunPercent) : void
      {
         this._runPercent = value;
      }
      
      public function set arriveCountDown(value:DrgnBoatArriveCountDown) : void
      {
         this._arriveCountDown = value;
      }
      
      private function initView() : void
      {
         this.initMapLayer();
         this.initPlayer();
      }
      
      private function initMapLayer() : void
      {
         var mc:MovieClip = null;
         var bitmap:Bitmap = null;
         this._mapLayer = new Sprite();
         addChild(this._mapLayer);
         this._mapBitmapData = ComponentFactory.Instance.creatBitmapData("drgnBoat.mapBg");
         var count:int = Math.ceil(LEN / 1551);
         for(var i:int = 0; i <= count; i++)
         {
            bitmap = new Bitmap(this._mapBitmapData);
            bitmap.x = i * 1551;
            this._mapLayer.addChild(bitmap);
         }
         this._startMc = ComponentFactory.Instance.creat("drgnBoat.StartEndTagMC");
         this._startMc.gotoAndStop(1);
         this._startMc.x = INIT_X;
         this._startMc.y = 174;
         this._endMc = ComponentFactory.Instance.creat("drgnBoat.StartEndTagMC");
         this._endMc.gotoAndStop(1);
         this._endMc.x = INIT_X + LEN;
         this._endMc.y = 174;
         this._boguArr = [];
         for(i = 0; i <= 2; i++)
         {
            mc = ComponentFactory.Instance.creat("drgnBoat.bogu" + i);
            mc.gotoAndPlay(1);
            mc.x = 300 + i * 1000;
            mc.y = 120;
            this._boguArr.push(mc);
            this._mapLayer.addChild(mc);
         }
         this._mapLayer.addChild(this._startMc);
         this._mapLayer.addChild(this._endMc);
      }
      
      private function initPlayer() : void
      {
         var tmp:DrgnBoatPlayerInfo = null;
         var tmpP:DrgnBoatGamePlayer = null;
         var totalTime:int = 0;
         var cha:int = 0;
         this._playerLayer = new Sprite();
         addChild(this._playerLayer);
         var playerInfoList:Vector.<DrgnBoatPlayerInfo> = DrgnBoatManager.instance.playerList;
         if(!playerInfoList)
         {
            return;
         }
         this._playerList = new Vector.<DrgnBoatGamePlayer>();
         this._needRankList = new DictionaryData();
         var len:int = int(playerInfoList.length);
         for(var i:int = 0; i < len; i++)
         {
            tmp = playerInfoList[i];
            tmpP = new DrgnBoatGamePlayer(tmp);
            this._playerLayer.addChild(tmpP);
            this._playerList.push(tmpP);
            this._playerItemList.push(tmpP);
            this._needRankList.add(i.toString(),i);
            if(tmp.isSelf)
            {
               this._selfPlayer = tmpP;
               DrgnBoatManager.instance.selfPlayer = this._selfPlayer;
            }
         }
         var info:DrgnBoatPlayerInfo = new DrgnBoatPlayerInfo();
         info.carType = 3;
         info.name = "巴罗夫";
         if(Boolean(this._npcArriveTime))
         {
            totalTime = ServerConfigManager.instance.dragonBoatFastTime * 1000;
            cha = this._npcArriveTime.getTime() - TimeManager.Instance.Now().getTime();
            cha = cha > 0 ? cha : 0;
            info.posX = INIT_X + LEN - cha / totalTime * LEN;
         }
         this._npcPlayer = new DrgnBoatGamePlayer(info);
         this._playerLayer.addChild(this._npcPlayer);
         this._playerList.push(this._npcPlayer);
         this._playerItemList.push(this._npcPlayer);
         this._needRankList.add(i.toString(),i);
         this.playerItemDepth();
         this.refreshNeedRankList();
         this.setCenter(false);
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ENTER_FRAME,this.updateMap,false,0,true);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.MOVE,this.moveHandler);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.REFRESH_ITEM,this.refreshItemHandler);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.REFRESH_BUFF,this.refreshBuffHandler);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.USE_SKILL,this.useSkillHandler);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.LAUNCH_MISSILE,this.playLaunchMcHandler);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.RE_ENTER_ALL_INFO,this.createPlayerHandler);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.FIGHT_STATE_CHANGE,this.playerFightStateChangeHandler);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.RANK_ARRIVE_LIST,this.rankArriveListChangeHandler);
      }
      
      private function rankArriveListChangeHandler(event:DrgnBoatEvent) : void
      {
         this._rankArriveList = event.data as Array;
         this.refreshNeedRankList();
      }
      
      private function refreshNeedRankList() : void
      {
         var tmp:int = 0;
         var tmp2:int = 0;
         var obj:Object = null;
         if(!this._playerList || !this._rankArriveList)
         {
            return;
         }
         var needDelete:Array = [];
         for each(tmp in this._needRankList)
         {
            for each(obj in this._rankArriveList)
            {
               if(obj.id == this._playerList[tmp].playerInfo.id && obj.zoneId == this._playerList[tmp].playerInfo.zoneId)
               {
                  needDelete.push(tmp);
                  break;
               }
            }
         }
         for each(tmp2 in needDelete)
         {
            this._needRankList.remove(tmp2.toString());
         }
      }
      
      private function updateRankList() : void
      {
         var i:int = 0;
         var rankList:Array = null;
         var len:int = 0;
         var j:int = 0;
         if(!this._playerList)
         {
            return;
         }
         var tmpPlayerList:Array = [];
         for each(i in this._needRankList)
         {
            tmpPlayerList.push(this._playerList[i]);
         }
         tmpPlayerList.sortOn("x",Array.NUMERIC | Array.DESCENDING);
         rankList = [];
         len = int(tmpPlayerList.length);
         for(j = 0; j < len; j++)
         {
            rankList.push({
               "name":tmpPlayerList[j].playerInfo.name,
               "carType":tmpPlayerList[j].playerInfo.carType,
               "isSelf":tmpPlayerList[j].playerInfo.isSelf
            });
         }
         var tmpEvent:DrgnBoatEvent = new DrgnBoatEvent(DrgnBoatManager.RANK_LIST);
         tmpEvent.data = this._rankArriveList.concat(rankList);
         DrgnBoatManager.instance.dispatchEvent(tmpEvent);
      }
      
      private function playerFightStateChangeHandler(event:DrgnBoatEvent) : void
      {
         var tmp:DrgnBoatGamePlayer = null;
         var dataInfo:Object = event.data;
         for each(tmp in this._playerList)
         {
            if(tmp.playerInfo.zoneId == dataInfo.zoneId && tmp.playerInfo.id == dataInfo.id)
            {
               tmp.playerInfo.fightState = dataInfo.fightState;
               tmp.refreshFightMc();
               tmp.x = dataInfo.posX + INIT_X;
               break;
            }
         }
      }
      
      private function createPlayerHandler(event:Event) : void
      {
         this.initPlayer();
      }
      
      private function useSkillHandler(event:DrgnBoatEvent) : void
      {
         var tmp:DrgnBoatGamePlayer = null;
         var dataInfo:Object = event.data;
         for each(tmp in this._playerList)
         {
            if(tmp.playerInfo.zoneId == dataInfo.zoneId && tmp.playerInfo.id == dataInfo.id)
            {
               if(Boolean(dataInfo.sound))
               {
                  SoundManager.instance.play("escort04");
               }
               tmp.x = dataInfo.leapX + INIT_X;
               break;
            }
         }
      }
      
      private function refreshBuffHandler(event:DrgnBoatEvent) : void
      {
         var tmp:DrgnBoatGamePlayer = null;
         var dataInfo:Object = event.data;
         for each(tmp in this._playerList)
         {
            if(tmp.playerInfo.zoneId == dataInfo.zoneId && tmp.playerInfo.id == dataInfo.id)
            {
               if(tmp.playerInfo.isSelf)
               {
                  if((dataInfo.acceleEndTime as Date).getTime() - tmp.playerInfo.acceleEndTime.getTime() > 1000)
                  {
                     SoundManager.instance.play("escort01");
                  }
                  if((dataInfo.deceleEndTime as Date).getTime() - tmp.playerInfo.deceleEndTime.getTime() > 1000)
                  {
                     SoundManager.instance.play("escort02");
                  }
                  else if((dataInfo.deceleEndTime as Date).getTime() - tmp.playerInfo.deceleEndTime.getTime() < -1000)
                  {
                     SoundManager.instance.play("escort05");
                  }
                  if((dataInfo.invisiEndTime as Date).getTime() - tmp.playerInfo.invisiEndTime.getTime() > 1000)
                  {
                     SoundManager.instance.play("escort03");
                  }
                  if((dataInfo.missileEndTime as Date).getTime() - tmp.playerInfo.missileEndTime.getTime() > 1000)
                  {
                     SoundManager.instance.play("087");
                  }
                  else if((dataInfo.missileEndTime as Date).getTime() - tmp.playerInfo.missileEndTime.getTime() < -1000)
                  {
                     SoundManager.instance.play("escort05");
                  }
               }
               tmp.playerInfo.acceleEndTime = dataInfo.acceleEndTime;
               tmp.playerInfo.deceleEndTime = dataInfo.deceleEndTime;
               tmp.playerInfo.invisiEndTime = dataInfo.invisiEndTime;
               tmp.playerInfo.missileEndTime = dataInfo.missileEndTime;
               tmp.playerInfo.missileHitEndTime = new Date(TimeManager.Instance.Now().getTime() + 1000);
               tmp.refreshBuffCountDown();
               break;
            }
         }
      }
      
      private function refreshItemHandler(event:DrgnBoatEvent) : void
      {
         var obj:Object = null;
         var tmpItem:DrgnBoatGameItem = null;
         var tag:int = 0;
         var addItem:DrgnBoatGameItem = null;
         var itemData:Object = event.data;
         var tmpItemList:Array = itemData.itemList;
         for each(obj in tmpItemList)
         {
            tmpItem = this._itemList[obj.index];
            ObjectUtils.disposeObject(tmpItem);
            if(Boolean(tmpItem))
            {
               this._playerItemList.splice(this._playerItemList.indexOf(tmpItem),1);
            }
            tag = int(obj.tag);
            if(tag == 0)
            {
               this._itemList.remove(obj.index);
            }
            else
            {
               addItem = new DrgnBoatGameItem(obj.index,obj.type,obj.posX);
               this._playerLayer.addChild(addItem);
               this._itemList.add(obj.index,addItem);
               this._playerItemList.push(addItem);
            }
         }
         this.playerItemDepth();
      }
      
      private function playerItemDepth() : void
      {
         this._playerItemList.sortOn("y",Array.NUMERIC);
         var len:int = int(this._playerItemList.length);
         for(var i:int = 0; i < len; i++)
         {
            this._playerLayer.addChild(this._playerItemList[i]);
         }
      }
      
      private function moveHandler(event:DrgnBoatEvent) : void
      {
         var tmp:DrgnBoatGamePlayer = null;
         var dataInfo:Object = event.data;
         for each(tmp in this._playerList)
         {
            if(tmp.playerInfo.zoneId == dataInfo.zoneId && tmp.playerInfo.id == dataInfo.id)
            {
               tmp.destinationX = dataInfo.destX;
               break;
            }
         }
      }
      
      private function updateMap(event:Event) : void
      {
         var tmp:DrgnBoatGamePlayer = null;
         var mc:MovieClip = null;
         var carInfo:DrgnBoatCarInfo = null;
         if(!this._isStartGame)
         {
            return;
         }
         ++this._enterFrameCount;
         if(this._enterFrameCount > 25)
         {
            this.updateRankList();
            this.calibrateNpcPos();
            this._enterFrameCount = 0;
            ++this._secondCount;
            if(this._secondCount % 60 == 0)
            {
               if(!this._beyondNPC && !this._endFlag)
               {
                  this.npcChat(LanguageMgr.GetTranslation("drgnBoat.npc.beyond"),1);
               }
            }
         }
         if(this._npcPlayer.x >= INIT_X + LEN)
         {
            if(!this._endFlag)
            {
               if(this._beyondNPC)
               {
                  this.npcChat(LanguageMgr.GetTranslation("drgnBoat.npc.loseEnd"),1);
               }
               else
               {
                  this.npcChat(LanguageMgr.GetTranslation("drgnBoat.npc.winEnd"),1);
               }
               this._endFlag = true;
            }
         }
         else
         {
            this._npcPlayer.x += DrgnBoatManager.instance.npcSpeed;
         }
         var flag:Boolean = false;
         for each(tmp in this._playerList)
         {
            tmp.updatePlayer();
            if(tmp.x > this._npcPlayer.x)
            {
               flag = true;
            }
         }
         if(flag && !this._beyondNPC && !this._endFlag)
         {
            this.npcChat(LanguageMgr.GetTranslation("drgnBoat.npc.beyonded"));
         }
         this._beyondNPC = flag;
         this.setCenter();
         if(this._selfPlayer.x >= this._boguArr[1].x)
         {
            mc = this._boguArr.shift() as MovieClip;
            mc.x += 3000;
            this._boguArr.push(mc);
         }
         if(Boolean(this._selfPlayer) && Boolean(this._arriveCountDown))
         {
            carInfo = DrgnBoatManager.instance.dataInfo.carInfo[this._selfPlayer.playerInfo.carType];
            this._arriveCountDown.refreshView(this._selfPlayer.x,carInfo.speed);
         }
      }
      
      private function calibrateNpcPos() : void
      {
         var totalTime:int = ServerConfigManager.instance.dragonBoatFastTime * 1000;
         var cha:int = this._npcArriveTime.getTime() - TimeManager.Instance.Now().getTime();
         cha = cha > 0 ? cha : 0;
         var posX:int = INIT_X + LEN - cha / totalTime * LEN;
         if(Math.abs(posX - this._npcPlayer.x) >= 50)
         {
            this._npcPlayer.x = posX;
         }
      }
      
      private function setCenter(isNeedTween:Boolean = true) : void
      {
         if(!this._selfPlayer)
         {
            return;
         }
         if(this._isTween)
         {
            return;
         }
         var xf:Number = 350 - this._selfPlayer.x;
         if(xf > 0)
         {
            xf = 0;
         }
         if(xf < 1000 - this._mapLayer.width)
         {
            xf = 1000 - this._mapLayer.width;
         }
         var tmp:Number = Math.abs(x - xf);
         if(isNeedTween && tmp > 14)
         {
            TweenLite.to(this,tmp / 400 * 0.5,{
               "x":xf,
               "onComplete":this.tweenComplete
            });
            this._isTween = true;
         }
         else
         {
            x = xf;
         }
      }
      
      private function tweenComplete() : void
      {
         this._isTween = false;
      }
      
      public function startGame() : void
      {
         var tmp:DrgnBoatGamePlayer = null;
         this._isStartGame = true;
         for each(tmp in this._playerList)
         {
            tmp.startGame();
         }
      }
      
      public function endGame() : void
      {
         var tmp:DrgnBoatGamePlayer = null;
         this._isStartGame = false;
         for each(tmp in this._playerList)
         {
            tmp.endGame();
         }
      }
      
      private function playLaunchMcHandler(event:DrgnBoatEvent) : void
      {
         var tmp:DrgnBoatGamePlayer = null;
         var timer:Timer = null;
         var obj:Object = event.data;
         for each(tmp in this._playerList)
         {
            if(tmp.playerInfo.id == obj.id && tmp.playerInfo.zoneId == obj.zoneId)
            {
               if(tmp.playerInfo.isSelf)
               {
                  timer = new Timer(2000,1);
                  timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__launchTimerComplete);
                  timer.start();
               }
               tmp.playerInfo.missileLaunchEndTime = new Date(TimeManager.Instance.Now().getTime() + 2000);
               tmp.refreshBuffCountDown();
               break;
            }
         }
      }
      
      protected function __launchTimerComplete(event:TimerEvent) : void
      {
         var timer:Timer = event.target as Timer;
         timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__launchTimerComplete);
         timer.stop();
         var args:Array = DrgnBoatManager.instance.missileArgArr;
         SocketManager.Instance.out.sendEscortUseSkill(args[0],args[1],args[2],args[3],args[4]);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.MOVE,this.moveHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.REFRESH_ITEM,this.refreshItemHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.REFRESH_BUFF,this.refreshBuffHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.USE_SKILL,this.useSkillHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.LAUNCH_MISSILE,this.playLaunchMcHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.RE_ENTER_ALL_INFO,this.createPlayerHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.FIGHT_STATE_CHANGE,this.playerFightStateChangeHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.RANK_ARRIVE_LIST,this.rankArriveListChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._startMc))
         {
            this._startMc.gotoAndStop(2);
         }
         if(Boolean(this._endMc))
         {
            this._endMc.gotoAndStop(2);
         }
         ObjectUtils.disposeObject(this._npcPlayer);
         this._npcPlayer = null;
         if(Boolean(this._paopaoView))
         {
            this._paopaoView.removeEventListener(Event.COMPLETE,this.__paopaoViewHide);
         }
         ObjectUtils.disposeObject(this._paopaoView);
         this._paopaoView = null;
         ObjectUtils.disposeAllChildren(this._mapLayer);
         ObjectUtils.disposeAllChildren(this._playerLayer);
         ObjectUtils.disposeAllChildren(this);
         this._mapLayer = null;
         this._playerLayer = null;
         this._playerList = null;
         this._selfPlayer = null;
         this._itemList = null;
         this._rankArriveList = null;
         if(Boolean(this._mapBitmapData))
         {
            this._mapBitmapData.dispose();
         }
         this._mapBitmapData = null;
         this._runPercent = null;
         this._startMc = null;
         this._endMc = null;
         this._finishTag = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get selfPlayer() : DrgnBoatGamePlayer
      {
         return this._selfPlayer;
      }
      
      public function set npcArriveTime(value:Date) : void
      {
         this._npcArriveTime = value;
         var totalTime:int = ServerConfigManager.instance.dragonBoatFastTime * 1000;
         var cha:int = this._npcArriveTime.getTime() - TimeManager.Instance.Now().getTime();
         cha = cha > 0 ? cha : 0;
         this._npcPlayer.x = INIT_X + LEN - cha / totalTime * LEN;
      }
      
      public function npcChat(str:String, direction:int = 0) : void
      {
         if(Boolean(this._paopaoView))
         {
            this._paopaoView.removeEventListener(Event.COMPLETE,this.__paopaoViewHide);
         }
         ObjectUtils.disposeObject(this._paopaoView);
         this._paopaoView = null;
         this._paopaoView = new DrgnBoatNPCpaopao(direction);
         this._paopaoView.addEventListener(Event.COMPLETE,this.__paopaoViewHide);
         this._npcPlayer.addChild(this._paopaoView);
         this._paopaoView.setTxt(str);
      }
      
      protected function __paopaoViewHide(event:Event) : void
      {
         this._paopaoView.removeEventListener(Event.COMPLETE,this.__paopaoViewHide);
         ObjectUtils.disposeObject(this._paopaoView);
         this._paopaoView = null;
      }
   }
}

