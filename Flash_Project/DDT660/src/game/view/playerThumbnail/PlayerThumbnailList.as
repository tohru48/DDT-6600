package game.view.playerThumbnail
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.events.GameEvent;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.PlayerThumbnailTip;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Player;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import room.model.RoomInfo;
   import trainer.data.Step;
   
   public class PlayerThumbnailList extends Sprite implements Disposeable
   {
      
      private var _info:DictionaryData;
      
      private var _players:DictionaryData;
      
      private var _dirct:int;
      
      private var _gm:GameInfo;
      
      private var _index:String;
      
      private var _list:Array;
      
      private var _thumbnailTip:PlayerThumbnailTip;
      
      public function PlayerThumbnailList(info:DictionaryData, gm:GameInfo, dirct:int = 1)
      {
         super();
         this._dirct = dirct;
         this._info = info;
         this._gm = gm;
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var j:int = 0;
         var i:String = null;
         var player:PlayerThumbnail = null;
         this._list = [];
         this._players = new DictionaryData();
         if(Boolean(this._info))
         {
            j = 0;
            for(i in this._info)
            {
               this._index = i;
               if(this._gm.gameMode != RoomInfo.TRANSNATIONALFIGHT_ROOM)
               {
                  player = new PlayerThumbnail(this._info[i],this._dirct);
                  player.addEventListener("playerThumbnailEvent",this.__onTipClick);
                  player.addEventListener(GameEvent.WISH_SELECT,this.__thumbnailHandle);
               }
               else
               {
                  player = new PlayerThumbnail(this._info[i],this._dirct,false);
               }
               this._players.add(i,player);
               addChild(player);
               this._list.push(player);
            }
         }
         this.arrange();
      }
      
      private function __onTipClick(e:Event) : void
      {
         var __addTip:Function = null;
         __addTip = function(event:Event):void
         {
            if(Boolean((event.currentTarget as PlayerThumbnailTip).tipDisplay))
            {
               (event.currentTarget as PlayerThumbnailTip).tipDisplay.recoverTip();
            }
         };
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_TEN_PERSENT))
         {
            return;
         }
         this._thumbnailTip = ShowTipManager.Instance.getTipInstanceByStylename("ddt.view.tips.PlayerThumbnailTip") as PlayerThumbnailTip;
         if(this._thumbnailTip == null)
         {
            this._thumbnailTip = ShowTipManager.Instance.createTipByStyleName("ddt.view.tips.PlayerThumbnailTip");
            this._thumbnailTip.addEventListener("playerThumbnailTipItemClick",__addTip);
         }
         this._thumbnailTip.tipDisplay = e.currentTarget as PlayerThumbnail;
         this._thumbnailTip.x = this.mouseX;
         this._thumbnailTip.y = e.currentTarget.height + e.currentTarget.y + 12;
         PositionUtils.setPos(this._thumbnailTip,localToGlobal(new Point(this._thumbnailTip.x,this._thumbnailTip.y)));
         if(GameManager.Instance.Current.roomType != FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            LayerManager.Instance.addToLayer(this._thumbnailTip,LayerManager.GAME_DYNAMIC_LAYER,false);
         }
      }
      
      private function __thumbnailHandle(e:GameEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.WISH_SELECT,e.data));
      }
      
      private function arrange() : void
      {
         var child:DisplayObject = null;
         var count:int = 0;
         while(count < numChildren)
         {
            child = getChildAt(count);
            if(this._dirct < 0)
            {
               child.x = (count + 1) * (child.width + 4) * this._dirct;
            }
            else
            {
               child.x = count * (child.width + 4) * this._dirct;
            }
            count++;
         }
      }
      
      private function initEvents() : void
      {
         this._info.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._info.addEventListener(DictionaryEvent.ADD,this.__addLiving);
      }
      
      private function removeEvents() : void
      {
         this._info.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._info.removeEventListener(DictionaryEvent.ADD,this.__addLiving);
      }
      
      private function __addLiving(e:DictionaryEvent) : void
      {
         var info:Player = null;
         var player:PlayerThumbnail = null;
         if(e.data is Player)
         {
            info = e.data as Player;
            player = new PlayerThumbnail(info,this._dirct);
            player.addEventListener("playerThumbnailEvent",this.__onTipClick);
            player.addEventListener(GameEvent.WISH_SELECT,this.__thumbnailHandle);
            this._players.add(String(info.playerInfo.ID),player);
            addChild(player);
            this._list.push(player);
            this.arrange();
         }
      }
      
      private function delePlayer(id:int) : void
      {
         var p:PlayerThumbnail = null;
         var len:int = int(this._list.length);
         for(var i:int = 0; i < len; i++)
         {
            p = this._list[i] as PlayerThumbnail;
            if(p.info.ID == id)
            {
               removeChild(p);
               this._list.splice(i,1);
               break;
            }
         }
      }
      
      public function __removePlayer(evt:DictionaryEvent) : void
      {
         var info:Player = evt.data as Player;
         if(Boolean(info) && Boolean(info.playerInfo))
         {
            if(Boolean(this._players[info.playerInfo.ID]))
            {
               this._players[info.playerInfo.ID].removeEventListener("playerThumbnailEvent",this.__onTipClick);
               this._players[info.playerInfo.ID].removeEventListener(GameEvent.WISH_SELECT,this.__thumbnailHandle);
               this._players[info.playerInfo.ID].dispose();
               delete this._players[info.playerInfo.ID];
            }
         }
         this.arrange();
      }
      
      public function dispose() : void
      {
         var i:String = null;
         this.removeEvents();
         for(i in this._players)
         {
            if(Boolean(this._players[i]))
            {
               this._players[i].removeEventListener("playerThumbnailEvent",this.__onTipClick);
               this._players[i].removeEventListener(GameEvent.WISH_SELECT,this.__thumbnailHandle);
               this._players[i].dispose();
            }
         }
         this._players = null;
         if(Boolean(this._thumbnailTip))
         {
            this._thumbnailTip.tipDisplay = null;
         }
         this._thumbnailTip = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

