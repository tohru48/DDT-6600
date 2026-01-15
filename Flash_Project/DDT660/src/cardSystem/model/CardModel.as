package cardSystem.model
{
   import cardSystem.CardEvent;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import cardSystem.data.SetsInfo;
   import cardSystem.data.SetsUpgradeRuleInfo;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class CardModel extends EventDispatcher
   {
      
      public static const OPEN_FOUR_NEEDS_TWOSTAR:int = 1;
      
      public static const OPEN_FIVE_NEEDS_THREESTAR:int = 2;
      
      public static const OPEN_FIVE_NEEDS_THREESTARTWO:int = 3;
      
      public static const MONSTER_CARDS:int = 0;
      
      public static const WEQPON_CARDS:int = 1;
      
      public static const PVE_CARDS:int = 2;
      
      public static const CELLS_SUM:int = 15;
      
      public static const EQUIP_CELLS_SUM:int = 5;
      
      private var _setsList:DictionaryData;
      
      private var _setsSortRuleVector:Vector.<SetsInfo>;
      
      public var upgradeRuleVec:Vector.<SetsUpgradeRuleInfo>;
      
      public var propIncreaseDic:DictionaryData;
      
      private var _inputSoul:int;
      
      private var _grooveinfo:Vector.<GrooveInfo>;
      
      private var _playerid:int;
      
      public var tempCardGroove:GrooveInfo;
      
      public function CardModel()
      {
         super();
      }
      
      public function get setsSortRuleVector() : Vector.<SetsInfo>
      {
         return this._setsSortRuleVector;
      }
      
      public function set setsSortRuleVector(value:Vector.<SetsInfo>) : void
      {
         this._setsSortRuleVector = value;
         dispatchEvent(new CardEvent(CardEvent.SETSSORTRULE_INIT_COMPLETE,this.setsSortRuleVector));
      }
      
      public function set GrooveInfoVector(value:Vector.<GrooveInfo>) : void
      {
         this._grooveinfo = value;
      }
      
      public function get GrooveInfoVector() : Vector.<GrooveInfo>
      {
         if(this._grooveinfo == null)
         {
            return null;
         }
         return this._grooveinfo;
      }
      
      public function set PlayerId(value:int) : void
      {
         this._playerid = value;
      }
      
      public function get PlayerId() : int
      {
         return this._playerid;
      }
      
      public function get setsList() : DictionaryData
      {
         return this._setsList;
      }
      
      public function set setsList(value:DictionaryData) : void
      {
         this._setsList = value;
         dispatchEvent(new CardEvent(CardEvent.SETSPROP_INIT_COMPLETE,this.setsList));
      }
      
      public function get inputSoul() : int
      {
         return this._inputSoul;
      }
      
      public function set inputSoul(value:int) : void
      {
         this._inputSoul = value;
      }
      
      public function fourIsOpen() : Boolean
      {
         var cardInfo:CardInfo = null;
         var num:int = 0;
         for each(cardInfo in PlayerManager.Instance.Self.cardBagDic)
         {
            if(cardInfo.Level >= 20)
            {
               num++;
            }
         }
         return num >= OPEN_FOUR_NEEDS_TWOSTAR;
      }
      
      public function fiveIsOpen() : Boolean
      {
         var cardInfo:CardInfo = null;
         var num:int = 0;
         for each(cardInfo in PlayerManager.Instance.Self.cardBagDic)
         {
            if(cardInfo.Level == 30)
            {
               num++;
            }
         }
         return num >= OPEN_FOUR_NEEDS_TWOSTAR;
      }
      
      public function fiveIsOpen2() : Boolean
      {
         var cardInfo:CardInfo = null;
         var num:int = 0;
         for each(cardInfo in PlayerManager.Instance.Self.cardBagDic)
         {
            if(cardInfo.Level >= 20)
            {
               num++;
            }
         }
         return num >= OPEN_FIVE_NEEDS_THREESTARTWO;
      }
      
      public function get Pages() : int
      {
         return Math.ceil(PlayerManager.Instance.Self.cardBagDic.length / CELLS_SUM);
      }
      
      public function getDataByPage(nowPage:int) : DictionaryData
      {
         var info:CardInfo = null;
         var result:DictionaryData = new DictionaryData();
         var data:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         var up:int = (nowPage - 1) * CELLS_SUM + EQUIP_CELLS_SUM;
         var down:int = up + CELLS_SUM;
         for each(info in data)
         {
            if(info.Place >= up && info.Place < down)
            {
               result[info.Place] = info;
            }
         }
         return result;
      }
      
      public function getBagListData() : Array
      {
         var info:CardInfo = null;
         var m:int = 0;
         var n:int = 0;
         var result:Array = new Array();
         var data:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         var max:int = 0;
         for each(info in data)
         {
            m = info.Place % 4 == 0 ? int(info.Place / 4 - 2) : int(info.Place / 4 - 1);
            if(result[m] == null)
            {
               result[m] = new Array();
            }
            n = info.Place % 4 == 0 ? 4 : int(info.Place % 4);
            result[m][0] = m + 1;
            result[m][n] = info;
            if(m + 1 > max)
            {
               max = m + 1;
            }
         }
         if(max < 3)
         {
            max = 3;
         }
         for(var i:int = 0; i < max; i++)
         {
            if(result[i] == null)
            {
               result[i] = new Array();
               result[i][0] = i + 1;
            }
         }
         return result;
      }
      
      public function getSetsCardFromCardBag(setsId:String) : Vector.<CardInfo>
      {
         var cardInfo:CardInfo = null;
         var data:DictionaryData = PlayerManager.Instance.Self.cardBagDic;
         var infoVec:Vector.<CardInfo> = new Vector.<CardInfo>();
         for each(cardInfo in data)
         {
            if(cardInfo.templateInfo.Property7 == setsId)
            {
               infoVec.push(cardInfo);
            }
         }
         return infoVec;
      }
   }
}

