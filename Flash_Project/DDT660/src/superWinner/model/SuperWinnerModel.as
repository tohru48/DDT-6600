package superWinner.model
{
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import superWinner.data.SuperWinnerAwardsMode;
   import superWinner.data.SuperWinnerPlayerInfo;
   import superWinner.event.SuperWinnerEvent;
   
   public class SuperWinnerModel extends EventDispatcher
   {
      
      private const AWARDSNAME:Array = [LanguageMgr.GetTranslation("ddt.superWinner.award1"),LanguageMgr.GetTranslation("ddt.superWinner.award2"),LanguageMgr.GetTranslation("ddt.superWinner.award3"),LanguageMgr.GetTranslation("ddt.superWinner.award4"),LanguageMgr.GetTranslation("ddt.superWinner.award5"),LanguageMgr.GetTranslation("ddt.superWinner.award6")];
      
      private var _playerlist:DictionaryData;
      
      private var _self:PlayerInfo;
      
      private var _playerNum:uint;
      
      private var _awardArr:Array = [];
      
      private var _myAwardArr:Array = [];
      
      private var _isCurrentDiceGetAward:Boolean = false;
      
      private var _currentAwardLevel:uint;
      
      private var _currentDicePoints:Vector.<int>;
      
      private var _lastDicePoints:Vector.<int>;
      
      private var _championDices:Vector.<int>;
      
      private var _championInfo:SuperWinnerPlayerInfo;
      
      private var _roomId:int;
      
      private var _showMsg:Boolean;
      
      private var _endDate:Date;
      
      private var _awardsVector:Vector.<SuperWinnerAwardsMode>;
      
      public function SuperWinnerModel()
      {
         super();
         this._playerlist = new DictionaryData(true);
         this._self = PlayerManager.Instance.Self;
      }
      
      public function setRoomInfo(pkg:PackageIn) : void
      {
         this.formatPlayerList(pkg);
         this.formatAwards(pkg);
         this.formatMyAwards(pkg);
         this.flushChampion(pkg);
         this._endDate = pkg.readDate();
         this._roomId = pkg.readInt();
      }
      
      public function formatPlayerList(pkg:PackageIn) : void
      {
         var info:SuperWinnerPlayerInfo = null;
         this.playerNum = pkg.readByte();
         for(var i:uint = 0; i < this.playerNum; i++)
         {
            info = new SuperWinnerPlayerInfo();
            info.ID = pkg.readInt();
            info.NickName = pkg.readUTF();
            info.IsVIP = pkg.readBoolean();
            info.Sex = pkg.readBoolean();
            info.IsOnline = pkg.readBoolean();
            info.Grade = pkg.readByte();
            this._playerlist.add(info.ID,info);
         }
         dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.INIT_PLAYERS));
      }
      
      public function formatAwards(pkg:PackageIn) : void
      {
         var arr:Array = [];
         for(var ii:uint = 0; ii < 6; ii++)
         {
            arr.push(pkg.readByte());
         }
         this.awards = arr;
         dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.FLUSH_AWARDS));
      }
      
      public function sendGetAwardsMsg(pkg:PackageIn) : void
      {
         var playerName:String = null;
         var lv:uint = 0;
         var awardName:String = null;
         var str:String = null;
         var evt:SuperWinnerEvent = null;
         var getAwardsNum:int = pkg.readByte();
         for(var i:int = 0; i < getAwardsNum; i++)
         {
            playerName = pkg.readUTF();
            lv = uint(pkg.readByte());
            if(lv != 6)
            {
               awardName = this.getAwardNameByLevel(lv);
               str = LanguageMgr.GetTranslation("ddt.superWinner.someoneGetAward",playerName,awardName);
               evt = new SuperWinnerEvent(SuperWinnerEvent.NOTICE);
               evt.resultData = str;
               dispatchEvent(evt);
            }
         }
      }
      
      public function getAwardNameByLevel(lv:int) : String
      {
         return this.AWARDSNAME[lv - 1];
      }
      
      public function formatMyAwards(pkg:PackageIn) : void
      {
         var arr1:Array = [];
         for(var iii:uint = 0; iii < 6; iii++)
         {
            arr1.push(pkg.readByte());
         }
         this.myAwards = arr1;
         dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.FLUSH_MY_AWARDS));
      }
      
      public function flushChampion(pkg:PackageIn, showMsg:Boolean = false) : void
      {
         var evt:SuperWinnerEvent = null;
         var hadChampion:Boolean = false;
         var vt:Vector.<int> = null;
         var i:int = 0;
         var championId:int = pkg.readInt();
         this._showMsg = showMsg;
         if(championId == 0)
         {
            return;
         }
         hadChampion = false;
         vt = new Vector.<int>(6);
         if(Boolean(this.championItem))
         {
            hadChampion = true;
         }
         this.setChampionItem(championId);
         for(i = 0; i < 6; i++)
         {
            vt[i] = pkg.readByte();
         }
         this.championDices = vt;
         evt = new SuperWinnerEvent(SuperWinnerEvent.CHAMPIOM_CHANGE);
         evt.resultData = hadChampion;
         dispatchEvent(evt);
      }
      
      public function get isShowChampionMsg() : Boolean
      {
         return this._showMsg;
      }
      
      public function joinRoom(pkg:PackageIn) : void
      {
         var info:SuperWinnerPlayerInfo = new SuperWinnerPlayerInfo();
         info.ID = pkg.readInt();
         info.NickName = pkg.readUTF();
         info.IsVIP = pkg.readBoolean();
         info.Sex = pkg.readBoolean();
         info.IsOnline = pkg.readBoolean();
         info.Grade = pkg.readByte();
         this._playerlist.add(info.ID,info);
      }
      
      public function set lastDicePoints(val:Vector.<int>) : void
      {
         this._lastDicePoints = val;
      }
      
      public function get lastDicePoints() : Vector.<int>
      {
         return this._lastDicePoints;
      }
      
      public function set currentDicePoints(val:Vector.<int>) : void
      {
         this._currentDicePoints = val;
      }
      
      public function get currentDicePoints() : Vector.<int>
      {
         return this._currentDicePoints;
      }
      
      public function set isCurrentDiceGetAward(val:Boolean) : void
      {
         this._isCurrentDiceGetAward = val;
      }
      
      public function get isCurrentDiceGetAward() : Boolean
      {
         return this._isCurrentDiceGetAward;
      }
      
      public function set currentAwardLevel(val:uint) : void
      {
         this._currentAwardLevel = val;
      }
      
      public function get currentAwardLevel() : uint
      {
         return this._currentAwardLevel;
      }
      
      public function getPlayerList() : DictionaryData
      {
         return this._playerlist;
      }
      
      public function getSelfPlayerInfo() : PlayerInfo
      {
         return this._self;
      }
      
      public function set playerNum($count:uint) : void
      {
         this._playerNum = $count;
      }
      
      public function get playerNum() : uint
      {
         return this._playerNum;
      }
      
      public function set awards(arr:Array) : void
      {
         this._awardArr = arr;
      }
      
      public function get awards() : Array
      {
         return this._awardArr;
      }
      
      public function set myAwards(arr:Array) : void
      {
         this._myAwardArr = arr;
      }
      
      public function get myAwards() : Array
      {
         return this._myAwardArr;
      }
      
      public function set championDices(val:Vector.<int>) : void
      {
         this._championDices = val;
      }
      
      public function get championDices() : Vector.<int>
      {
         return this._championDices;
      }
      
      public function setChampionItem(val:int) : void
      {
         this._championInfo = this.getPlayerList()[val];
      }
      
      public function get championItem() : SuperWinnerPlayerInfo
      {
         return this._championInfo;
      }
      
      public function get roomId() : int
      {
         return this._roomId;
      }
      
      public function get endData() : Date
      {
         return this._endDate;
      }
      
      public function get awardsVector() : Vector.<SuperWinnerAwardsMode>
      {
         return this._awardsVector;
      }
      
      public function set awardsVector(val:Vector.<SuperWinnerAwardsMode>) : void
      {
         this._awardsVector = val;
      }
   }
}

