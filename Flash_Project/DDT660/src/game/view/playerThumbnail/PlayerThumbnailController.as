package game.view.playerThumbnail
{
   import ddt.events.GameEvent;
   import flash.display.Sprite;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.objects.GameLiving;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class PlayerThumbnailController extends Sprite
   {
      
      private var _info:GameInfo;
      
      private var _team1:DictionaryData = new DictionaryData();
      
      private var _team2:DictionaryData = new DictionaryData();
      
      private var _list1:PlayerThumbnailList;
      
      private var _list2:PlayerThumbnailList;
      
      private var _bossThumbnailContainer:BossThumbnail;
      
      public function PlayerThumbnailController(info:GameInfo)
      {
         this._info = info;
         super();
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this.initInfo();
         this._list1 = new PlayerThumbnailList(this._team1,this._info,-1);
         this._list2 = new PlayerThumbnailList(this._team2,this._info);
         addChild(this._list1);
         this._list1.x = 246;
         this._list2.x = 360;
         addChild(this._list2);
      }
      
      private function initInfo() : void
      {
         var player:Living = null;
         var players:DictionaryData = this._info.livings;
         for each(player in players)
         {
            if(player is Player)
            {
               if(player.team == 1)
               {
                  this._team1.add((player as Player).playerInfo.ID,player);
               }
               else if(this._info.gameMode != 5)
               {
                  this._team2.add((player as Player).playerInfo.ID,player);
               }
            }
         }
      }
      
      public function addNewLiving(player:Living) : void
      {
         if(player.team == 1)
         {
            this._team1.add((player as Player).playerInfo.ID,player);
         }
         else if(this._info.gameMode != 5)
         {
            this._team2.add((player as Player).playerInfo.ID,player);
         }
      }
      
      public function set currentBoss(living:Living) : void
      {
         this.removeThumbnailContainer();
         if(living == null)
         {
            return;
         }
         this._bossThumbnailContainer = new BossThumbnail(living);
         this._bossThumbnailContainer.x = this._list1.x + 110;
         this._bossThumbnailContainer.y = -10;
         addChild(this._bossThumbnailContainer);
      }
      
      public function removeThumbnailContainer() : void
      {
         if(Boolean(this._bossThumbnailContainer))
         {
            this._bossThumbnailContainer.dispose();
         }
         this._bossThumbnailContainer = null;
      }
      
      public function addLiving(living:GameLiving) : void
      {
         if(living.info.typeLiving == 4 || living.info.typeLiving == 5 || living.info.typeLiving == 6 || living.info.typeLiving == 12)
         {
            if(this._info.gameMode != 5)
            {
               this.currentBoss = living.info;
            }
         }
         else if(living.info.typeLiving == 1 || living.info.typeLiving == 2)
         {
            this._team2.add(living.info.LivingID,living);
         }
      }
      
      public function updateHeadFigure(living:GameLiving, flag:Boolean) : void
      {
         if(flag)
         {
            if(Boolean(living.info))
            {
               this.currentBoss = living.info;
            }
         }
         else if(Boolean(living.info))
         {
            if(living.info.typeLiving == 4 || living.info.typeLiving == 5 || living.info.typeLiving == 6 || living.info.typeLiving == 12)
            {
               if(this._info.gameMode != 5)
               {
                  this.currentBoss = living.info;
               }
            }
         }
      }
      
      private function initEvents() : void
      {
         this._info.livings.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._list1.addEventListener(GameEvent.WISH_SELECT,this.__thumbnailListHandle);
         this._list2.addEventListener(GameEvent.WISH_SELECT,this.__thumbnailListHandle);
      }
      
      private function removeEvents() : void
      {
         this._info.livings.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._list1.removeEventListener(GameEvent.WISH_SELECT,this.__thumbnailListHandle);
         this._list2.removeEventListener(GameEvent.WISH_SELECT,this.__thumbnailListHandle);
      }
      
      private function __thumbnailListHandle(e:GameEvent) : void
      {
         dispatchEvent(new GameEvent(GameEvent.WISH_SELECT,e.data));
      }
      
      private function __removePlayer(evt:DictionaryEvent) : void
      {
         var player:Player = evt.data as Player;
         if(player == null)
         {
            return;
         }
         if(Boolean(player.character))
         {
            player.character.resetShowBitmapBig();
         }
         if(Boolean(this._bossThumbnailContainer) && this._bossThumbnailContainer.Id == player.LivingID)
         {
            this._bossThumbnailContainer.dispose();
            this._bossThumbnailContainer = null;
         }
         else if(player.team == 1)
         {
            this._team1.remove((evt.data as Player).playerInfo.ID);
         }
         else
         {
            this._team2.remove((evt.data as Player).playerInfo.ID);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._info = null;
         this._team1 = null;
         this._team2 = null;
         this._list1.dispose();
         this._list2.dispose();
         if(Boolean(this._bossThumbnailContainer))
         {
            this._bossThumbnailContainer.dispose();
         }
         this._bossThumbnailContainer = null;
         this._list1 = null;
         this._list2 = null;
      }
   }
}

