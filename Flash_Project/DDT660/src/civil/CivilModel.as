package civil
{
   import ddt.data.player.CivilPlayerInfo;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   
   public class CivilModel extends EventDispatcher
   {
      
      private var _civilPlayers:Array;
      
      private var _currentcivilItemInfo:CivilPlayerInfo;
      
      private var _totalPage:int;
      
      private var _currentLeafSex:Boolean = true;
      
      private var _register:Boolean = false;
      
      private var _IsFirst:Boolean = false;
      
      public function CivilModel(isFirst:Boolean)
      {
         this._IsFirst = isFirst;
         super();
      }
      
      public function set currentcivilItemInfo($info:CivilPlayerInfo) : void
      {
         this._currentcivilItemInfo = $info;
         dispatchEvent(new CivilEvent(CivilEvent.SELECTED_CHANGE));
      }
      
      public function get currentcivilItemInfo() : CivilPlayerInfo
      {
         return this._currentcivilItemInfo;
      }
      
      public function upSelfPublishEquit(b:Boolean) : void
      {
         for(var i:int = 0; i < this._civilPlayers.length; i++)
         {
            if(PlayerManager.Instance.Self.ID == this._civilPlayers[i].UserId)
            {
               (this._civilPlayers[i] as CivilPlayerInfo).IsPublishEquip = b;
               break;
            }
         }
      }
      
      public function upSelfIntroduction(msg:String) : void
      {
         for(var i:int = 0; i < this._civilPlayers.length; i++)
         {
            if(PlayerManager.Instance.Self.ID == this._civilPlayers[i].UserId)
            {
               (this._civilPlayers[i] as CivilPlayerInfo).Introduction = msg;
               break;
            }
         }
      }
      
      public function set civilPlayers(value:Array) : void
      {
         this._civilPlayers = value;
         var len:int = int(this._civilPlayers.length);
         for(var i:int = 0; i < len; i++)
         {
            if(PlayerManager.Instance.Self.ID == this._civilPlayers[i].UserId && PlayerManager.Instance.Self.Introduction == "")
            {
               PlayerManager.Instance.Self.Introduction = (this._civilPlayers[i] as CivilPlayerInfo).Introduction;
               break;
            }
         }
         dispatchEvent(new CivilEvent(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE));
      }
      
      public function update() : void
      {
      }
      
      public function updateBtn() : void
      {
         dispatchEvent(new CivilEvent(CivilEvent.CIVIL_UPDATE_BTN));
      }
      
      public function get civilPlayers() : Array
      {
         return this._civilPlayers;
      }
      
      public function set TotalPage(value:int) : void
      {
         this._totalPage = value;
      }
      
      public function get TotalPage() : int
      {
         return this._totalPage;
      }
      
      public function get sex() : Boolean
      {
         return this._currentLeafSex;
      }
      
      public function set sex(value:Boolean) : void
      {
         this._currentLeafSex = value;
      }
      
      public function get registed() : Boolean
      {
         return this._register;
      }
      
      public function set registed(val:Boolean) : void
      {
         this._register = val;
         dispatchEvent(new CivilEvent(CivilEvent.REGISTER_CHANGE));
      }
      
      public function get IsFirst() : Boolean
      {
         return this._IsFirst;
      }
      
      public function dispose() : void
      {
         this._civilPlayers = null;
         this.currentcivilItemInfo = null;
      }
   }
}

