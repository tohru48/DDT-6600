package sevenDouble.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import road7th.data.DictionaryData;
   import sevenDouble.SevenDoubleManager;
   import sevenDouble.data.SevenDoublePlayerInfo;
   import sevenDouble.event.SevenDoubleEvent;
   import sevenDouble.player.SevenDoubleGameItem;
   import sevenDouble.player.SevenDoubleGamePlayer;
   
   public class SevenDoubleMapView extends Sprite implements Disposeable
   {
      
      private var _mapLayer:Sprite;
      
      private var _playerLayer:Sprite;
      
      private var _playerList:Vector.<SevenDoubleGamePlayer>;
      
      private var _selfPlayer:SevenDoubleGamePlayer;
      
      private var _itemList:DictionaryData = new DictionaryData();
      
      private var _playerItemList:Array = [];
      
      private var _rankArriveList:Array = [];
      
      private var _needRankList:DictionaryData;
      
      private var _isStartGame:Boolean = false;
      
      private var _mapBitmapData:BitmapData;
      
      private var _startOrEndIcon:BitmapData;
      
      private var _finishCowboy:MovieClip;
      
      private var _runPercent:SevenDoubleRunPercentView;
      
      private var _enterFrameCount:int = 0;
      
      private var _isTween:Boolean = false;
      
      public function SevenDoubleMapView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set runPercent(value:SevenDoubleRunPercentView) : void
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
         var startIcon:Bitmap = null;
         var endIcon:Bitmap = null;
         var bitmap:Bitmap = null;
         this._mapLayer = new Sprite();
         addChild(this._mapLayer);
         this._mapBitmapData = ComponentFactory.Instance.creatBitmapData("asset.sevenDouble.mapBg");
         for(var i:int = 0; i < 12; i++)
         {
            bitmap = new Bitmap(this._mapBitmapData);
            bitmap.x = i * 1862;
            this._mapLayer.addChild(bitmap);
         }
         var tmp:BitmapData = new BitmapData(884,600);
         tmp.copyPixels(this._mapBitmapData,new Rectangle(0,0,884,600),new Point(0,0));
         tmpBitmap = new Bitmap(tmp);
         tmpBitmap.x = 12 * 1862;
         this._mapLayer.addChild(tmpBitmap);
         this._startOrEndIcon = ComponentFactory.Instance.creatBitmapData("asset.sevenDouble.gameStartEndTagIcon");
         startIcon = new Bitmap(this._startOrEndIcon);
         startIcon.x = 232;
         startIcon.y = -5;
         endIcon = new Bitmap(this._startOrEndIcon);
         endIcon.x = 22732;
         endIcon.y = -5;
         this._finishCowboy = ComponentFactory.Instance.creat("asset.sevenDouble.gameFinishCowboy");
         this._finishCowboy.gotoAndStop(1);
         this._finishCowboy.scaleX = 0.7;
         this._finishCowboy.scaleY = 0.7;
         this._finishCowboy.x = 22956;
         this._finishCowboy.y = 316;
         this._mapLayer.addChild(startIcon);
         this._mapLayer.addChild(endIcon);
         this._mapLayer.addChild(this._finishCowboy);
      }
      
      private function initPlayer() : void
      {
         var tmp:SevenDoublePlayerInfo = null;
         var tmpP:SevenDoubleGamePlayer = null;
         this._playerLayer = new Sprite();
         addChild(this._playerLayer);
         var playerInfoList:Vector.<SevenDoublePlayerInfo> = SevenDoubleManager.instance.playerList;
         if(!playerInfoList)
         {
            return;
         }
         this._playerList = new Vector.<SevenDoubleGamePlayer>();
         this._needRankList = new DictionaryData();
         var len:int = int(playerInfoList.length);
         for(var i:int = 0; i < len; i++)
         {
            tmp = playerInfoList[i];
            tmpP = new SevenDoubleGamePlayer(tmp);
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
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.MOVE,this.moveHandler);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.REFRESH_ITEM,this.refreshItemHandler);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.REFRESH_BUFF,this.refreshBuffHandler);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.USE_SKILL,this.useSkillHandler);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.RE_ENTER_ALL_INFO,this.createPlayerHandler);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.FIGHT_STATE_CHANGE,this.playerFightStateChangeHandler);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.RANK_ARRIVE_LIST,this.rankArriveListChangeHandler);
      }
      
      private function rankArriveListChangeHandler(event:SevenDoubleEvent) : void
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
         var tmpEvent:SevenDoubleEvent = new SevenDoubleEvent(SevenDoubleManager.RANK_LIST);
         tmpEvent.data = this._rankArriveList.concat(rankList);
         SevenDoubleManager.instance.dispatchEvent(tmpEvent);
      }
      
      private function playerFightStateChangeHandler(event:SevenDoubleEvent) : void
      {
         var tmp:SevenDoubleGamePlayer = null;
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
      
      private function useSkillHandler(event:SevenDoubleEvent) : void
      {
         var tmp:SevenDoubleGamePlayer = null;
         var dataInfo:Object = event.data;
         for each(tmp in this._playerList)
         {
            if(tmp.playerInfo.zoneId == dataInfo.zoneId && tmp.playerInfo.id == dataInfo.id)
            {
               if(Boolean(dataInfo.sound))
               {
                  SoundManager.instance.play("sevenDouble04");
               }
               tmp.x = dataInfo.leapX + 280;
               break;
            }
         }
      }
      
      private function refreshBuffHandler(event:SevenDoubleEvent) : void
      {
         var tmp:SevenDoubleGamePlayer = null;
         var dataInfo:Object = event.data;
         for each(tmp in this._playerList)
         {
            if(tmp.playerInfo.zoneId == dataInfo.zoneId && tmp.playerInfo.id == dataInfo.id)
            {
               if(tmp.playerInfo.isSelf)
               {
                  if((dataInfo.acceleEndTime as Date).getTime() - tmp.playerInfo.acceleEndTime.getTime() > 1000)
                  {
                     SoundManager.instance.play("sevenDouble01");
                  }
                  if((dataInfo.deceleEndTime as Date).getTime() - tmp.playerInfo.deceleEndTime.getTime() > 1000)
                  {
                     SoundManager.instance.play("sevenDouble02");
                  }
                  else if((dataInfo.deceleEndTime as Date).getTime() - tmp.playerInfo.deceleEndTime.getTime() < -1000)
                  {
                     SoundManager.instance.play("sevenDouble05");
                  }
                  if((dataInfo.invisiEndTime as Date).getTime() - tmp.playerInfo.invisiEndTime.getTime() > 1000)
                  {
                     SoundManager.instance.play("sevenDouble03");
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
      
      private function refreshItemHandler(event:SevenDoubleEvent) : void
      {
         var obj:Object = null;
         var tmpItem:SevenDoubleGameItem = null;
         var tag:int = 0;
         var addItem:SevenDoubleGameItem = null;
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
               addItem = new SevenDoubleGameItem(obj.index,obj.type,obj.posX);
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
      
      private function moveHandler(event:SevenDoubleEvent) : void
      {
         var tmp:SevenDoubleGamePlayer = null;
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
         var tmp:SevenDoubleGamePlayer = null;
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
         var tmp:SevenDoubleGamePlayer = null;
         this._isStartGame = true;
         for each(tmp in this._playerList)
         {
            tmp.startGame();
         }
      }
      
      public function endGame() : void
      {
         var tmp:SevenDoubleGamePlayer = null;
         this._isStartGame = false;
         for each(tmp in this._playerList)
         {
            tmp.endGame();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.updateMap);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.MOVE,this.moveHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.REFRESH_ITEM,this.refreshItemHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.REFRESH_BUFF,this.refreshBuffHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.USE_SKILL,this.useSkillHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.RE_ENTER_ALL_INFO,this.createPlayerHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.FIGHT_STATE_CHANGE,this.playerFightStateChangeHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.RANK_ARRIVE_LIST,this.rankArriveListChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._finishCowboy))
         {
            this._finishCowboy.gotoAndStop(2);
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
         if(Boolean(this._startOrEndIcon))
         {
            this._startOrEndIcon.dispose();
         }
         this._startOrEndIcon = null;
         this._finishCowboy = null;
         this._runPercent = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

