package escort.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import escort.EscortManager;
   import escort.data.EscortPlayerInfo;
   import escort.event.EscortEvent;
   import escort.player.EscortGameItem;
   import escort.player.EscortGamePlayer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import road7th.data.DictionaryData;
   
   public class EscortMapView extends Sprite implements Disposeable
   {
      
      private var _mapLayer:Sprite;
      
      private var _playerLayer:Sprite;
      
      private var _playerList:Vector.<EscortGamePlayer>;
      
      private var _selfPlayer:EscortGamePlayer;
      
      private var _itemList:DictionaryData = new DictionaryData();
      
      private var _playerItemList:Array = [];
      
      private var _rankArriveList:Array = [];
      
      private var _needRankList:DictionaryData;
      
      private var _isStartGame:Boolean = false;
      
      private var _mapBitmapData:BitmapData;
      
      private var _startMc:MovieClip;
      
      private var _endMc:MovieClip;
      
      private var _finishTag:Bitmap;
      
      private var _runPercent:EscortRunPercentView;
      
      private var _enterFrameCount:int = 0;
      
      private var _isTween:Boolean = false;
      
      public function EscortMapView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set runPercent(value:EscortRunPercentView) : void
      {
         this._runPercent = value;
      }
      
      private function initView() : void
      {
         this.initMapLayer();
         this.initPlayer();
      }
      
      private function initMapLayer() : void
      {
         var tmpBitmap:Bitmap = null;
         var bitmap:Bitmap = null;
         this._mapLayer = new Sprite();
         addChild(this._mapLayer);
         this._mapBitmapData = ComponentFactory.Instance.creatBitmapData("asset.escort.mapBg");
         for(var i:int = 0; i < 12; i++)
         {
            bitmap = new Bitmap(this._mapBitmapData);
            bitmap.x = i * 1978;
            this._mapLayer.addChild(bitmap);
         }
         var tmp:BitmapData = new BitmapData(884,600);
         tmp.copyPixels(this._mapBitmapData,new Rectangle(0,0,884,600),new Point(0,0));
         tmpBitmap = new Bitmap(tmp);
         tmpBitmap.x = 12 * 1978;
         this._mapLayer.addChild(tmpBitmap);
         this._startMc = ComponentFactory.Instance.creat("asset.escort.gameStartTagMC");
         this._startMc.gotoAndStop(1);
         this._startMc.x = 67;
         this._startMc.y = -5;
         this._endMc = ComponentFactory.Instance.creat("asset.escort.gameEndTagMC");
         this._endMc.gotoAndStop(1);
         this._endMc.x = 22739;
         this._endMc.y = -5;
         this._mapLayer.addChild(this._startMc);
         this._mapLayer.addChild(this._endMc);
      }
      
      private function initPlayer() : void
      {
         var tmp:EscortPlayerInfo = null;
         var tmpP:EscortGamePlayer = null;
         this._playerLayer = new Sprite();
         addChild(this._playerLayer);
         var playerInfoList:Vector.<EscortPlayerInfo> = EscortManager.instance.playerList;
         if(!playerInfoList)
         {
            return;
         }
         this._playerList = new Vector.<EscortGamePlayer>();
         this._needRankList = new DictionaryData();
         var len:int = int(playerInfoList.length);
         for(var i:int = 0; i < len; i++)
         {
            tmp = playerInfoList[i];
            tmpP = new EscortGamePlayer(tmp);
            this._playerLayer.addChild(tmpP);
            this._playerList.push(tmpP);
            this._playerItemList.push(tmpP);
            this._needRankList.add(i.toString(),i);
            if(tmp.isSelf)
            {
               this._selfPlayer = tmpP;
            }
         }
         this.playerItemDepth();
         this.refreshNeedRankList();
         this.setCenter(false);
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ENTER_FRAME,this.updateMap,false,0,true);
         EscortManager.instance.addEventListener(EscortManager.MOVE,this.moveHandler);
         EscortManager.instance.addEventListener(EscortManager.REFRESH_ITEM,this.refreshItemHandler);
         EscortManager.instance.addEventListener(EscortManager.REFRESH_BUFF,this.refreshBuffHandler);
         EscortManager.instance.addEventListener(EscortManager.USE_SKILL,this.useSkillHandler);
         EscortManager.instance.addEventListener(EscortManager.RE_ENTER_ALL_INFO,this.createPlayerHandler);
         EscortManager.instance.addEventListener(EscortManager.FIGHT_STATE_CHANGE,this.playerFightStateChangeHandler);
         EscortManager.instance.addEventListener(EscortManager.RANK_ARRIVE_LIST,this.rankArriveListChangeHandler);
      }
      
      private function rankArriveListChangeHandler(event:EscortEvent) : void
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
               "carType":tmpPlayerList[j].playerInfo.carType
            });
         }
         var tmpEvent:EscortEvent = new EscortEvent(EscortManager.RANK_LIST);
         tmpEvent.data = this._rankArriveList.concat(rankList);
         EscortManager.instance.dispatchEvent(tmpEvent);
      }
      
      private function playerFightStateChangeHandler(event:EscortEvent) : void
      {
         var tmp:EscortGamePlayer = null;
         var dataInfo:Object = event.data;
         for each(tmp in this._playerList)
         {
            if(tmp.playerInfo.zoneId == dataInfo.zoneId && tmp.playerInfo.id == dataInfo.id)
            {
               tmp.playerInfo.fightState = dataInfo.fightState;
               tmp.refreshFightMc();
               tmp.x = dataInfo.posX + 280;
               break;
            }
         }
      }
      
      private function createPlayerHandler(event:Event) : void
      {
         this.initPlayer();
      }
      
      private function useSkillHandler(event:EscortEvent) : void
      {
         var tmp:EscortGamePlayer = null;
         var dataInfo:Object = event.data;
         for each(tmp in this._playerList)
         {
            if(tmp.playerInfo.zoneId == dataInfo.zoneId && tmp.playerInfo.id == dataInfo.id)
            {
               if(Boolean(dataInfo.sound))
               {
                  SoundManager.instance.play("escort04");
               }
               tmp.x = dataInfo.leapX + 280;
               break;
            }
         }
      }
      
      private function refreshBuffHandler(event:EscortEvent) : void
      {
         var tmp:EscortGamePlayer = null;
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
               }
               tmp.playerInfo.acceleEndTime = dataInfo.acceleEndTime;
               tmp.playerInfo.deceleEndTime = dataInfo.deceleEndTime;
               tmp.playerInfo.invisiEndTime = dataInfo.invisiEndTime;
               tmp.refreshBuffCountDown();
               break;
            }
         }
      }
      
      private function refreshItemHandler(event:EscortEvent) : void
      {
         var obj:Object = null;
         var tmpItem:EscortGameItem = null;
         var tag:int = 0;
         var addItem:EscortGameItem = null;
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
               addItem = new EscortGameItem(obj.index,obj.type,obj.posX);
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
      
      private function moveHandler(event:EscortEvent) : void
      {
         var tmp:EscortGamePlayer = null;
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
         var tmp:EscortGamePlayer = null;
         if(!this._isStartGame)
         {
            return;
         }
         ++this._enterFrameCount;
         if(this._enterFrameCount > 25)
         {
            this.updateRankList();
            this._enterFrameCount = 0;
         }
         for each(tmp in this._playerList)
         {
            tmp.updatePlayer();
         }
         this.setCenter();
         if(Boolean(this._selfPlayer) && Boolean(this._runPercent))
         {
            this._runPercent.refreshView(this._selfPlayer.x);
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
         var tmp:EscortGamePlayer = null;
         this._isStartGame = true;
         for each(tmp in this._playerList)
         {
            tmp.startGame();
         }
      }
      
      public function endGame() : void
      {
         var tmp:EscortGamePlayer = null;
         this._isStartGame = false;
         for each(tmp in this._playerList)
         {
            tmp.endGame();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         EscortManager.instance.removeEventListener(EscortManager.MOVE,this.moveHandler);
         EscortManager.instance.removeEventListener(EscortManager.REFRESH_ITEM,this.refreshItemHandler);
         EscortManager.instance.removeEventListener(EscortManager.REFRESH_BUFF,this.refreshBuffHandler);
         EscortManager.instance.removeEventListener(EscortManager.USE_SKILL,this.useSkillHandler);
         EscortManager.instance.removeEventListener(EscortManager.RE_ENTER_ALL_INFO,this.createPlayerHandler);
         EscortManager.instance.removeEventListener(EscortManager.FIGHT_STATE_CHANGE,this.playerFightStateChangeHandler);
         EscortManager.instance.removeEventListener(EscortManager.RANK_ARRIVE_LIST,this.rankArriveListChangeHandler);
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
   }
}

