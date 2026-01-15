package ddt.data.fightLib
{
   import ddt.data.EquipType;
   import ddt.manager.FightLibManager;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class FightLibInfo extends EventDispatcher
   {
      
      public static const MEASHUR_SCREEN:int = 1;
      
      public static const TWENTY_DEGREE:int = 2;
      
      public static const SIXTY_FIVE_DEGREE:int = 3;
      
      public static const HIGH_THROW:int = 4;
      
      public static const HIGH_GAP:int = 5;
      
      public static const EASY:int = 0;
      
      public static const NORMAL:int = 1;
      
      public static const DIFFICULT:int = 2;
      
      private static const AWARD_GIFTS:Array = [100,300,500];
      
      private static const AWARD_EXP:Array = [2000,5000,8000];
      
      private static const AWARD_ITEMS:Array = [[{
         "id":11021,
         "number":4
      },{
         "id":11002,
         "number":4
      },{
         "id":11006,
         "number":4
      },{
         "id":11010,
         "number":4
      },{
         "id":11014,
         "number":4
      },{
         "id":11408,
         "number":4
      }],[{
         "id":11022,
         "number":4
      },{
         "id":11003,
         "number":4
      },{
         "id":11007,
         "number":4
      },{
         "id":11011,
         "number":4
      },{
         "id":11015,
         "number":4
      },{
         "id":11408,
         "number":4
      }],[{
         "id":11023,
         "number":4
      },{
         "id":11004,
         "number":4
      },{
         "id":11008,
         "number":4
      },{
         "id":11012,
         "number":4
      },{
         "id":11016,
         "number":4
      },{
         "id":11408,
         "number":4
      }]];
      
      private var _id:int;
      
      private var _name:String;
      
      private var _difficulty:int;
      
      private var _requiedLevel:int;
      
      private var _description:String;
      
      private var _mapID:int;
      
      private var _commit:int = 0;
      
      private var value1:int;
      
      private var value2:int;
      
      public function FightLibInfo()
      {
         super();
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(value:int) : void
      {
         this._id = value;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function get difficulty() : int
      {
         return this._difficulty;
      }
      
      public function set difficulty(value:int) : void
      {
         this._difficulty = value;
         if(this._commit <= 0)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get requiedLevel() : int
      {
         return this._requiedLevel;
      }
      
      public function set requiedLevel(value:int) : void
      {
         this._requiedLevel = value;
         if(this._commit <= 0)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set description(value:String) : void
      {
         this._description = value;
      }
      
      public function get mapID() : int
      {
         return this._mapID;
      }
      
      public function set mapID(value:int) : void
      {
         this._mapID = value;
      }
      
      public function beginChange() : void
      {
         ++this._commit;
      }
      
      public function commitChange() : void
      {
         --this._commit;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function getAwardMedal() : int
      {
         var awardItems:Array = null;
         var item:Object = null;
         if(this.difficulty > -1 && this.difficulty < 3)
         {
            awardItems = this.getAwardInfoItems();
            for each(item in awardItems)
            {
               if(item.id == EquipType.MEDAL)
               {
                  return item.count;
               }
            }
         }
         return 0;
      }
      
      public function getAwardGiftsNum() : int
      {
         var awardItems:Array = null;
         var item:Object = null;
         if(this.difficulty > -1 && this.difficulty < 3)
         {
            awardItems = this.getAwardInfoItems();
            for each(item in awardItems)
            {
               if(item.id == EquipType.GIFT)
               {
                  return item.count;
               }
            }
         }
         return 0;
      }
      
      public function getAwardEXPNum() : int
      {
         var awardItems:Array = null;
         var item:Object = null;
         if(this.difficulty > -1 && this.difficulty < 3)
         {
            awardItems = this.getAwardInfoItems();
            for each(item in awardItems)
            {
               if(item.id == EquipType.EXP)
               {
                  return item.count;
               }
            }
         }
         return 0;
      }
      
      public function getAwardItems() : Array
      {
         var awardItems:Array = null;
         var item:Object = null;
         var result:Array = [];
         if(this.difficulty > -1 && this.difficulty < 3)
         {
            awardItems = this.getAwardInfoItems();
            for each(item in awardItems)
            {
               if(item.id != EquipType.GIFT && item.id != EquipType.EXP)
               {
                  result.push(item);
               }
            }
         }
         return result;
      }
      
      private function getAwardInfoItems() : Array
      {
         var result:Array = null;
         var awardInfo:FightLibAwardInfo = FightLibManager.Instance.getFightLibAwardInfoByID(this.id);
         switch(this.difficulty)
         {
            case EASY:
               result = awardInfo.easyAward;
               break;
            case NORMAL:
               result = awardInfo.normalAward;
               break;
            case DIFFICULT:
               result = awardInfo.difficultAward;
         }
         return result;
      }
      
      private function initMissionValue() : void
      {
         var info:String = PlayerManager.Instance.Self.fightLibMission.substr((this.id - 1000) * 2,2);
         this.value1 = int(info.substr(0,1));
         this.value2 = int(info.substr(1,1));
      }
      
      public function get InfoCanPlay() : Boolean
      {
         this.initMissionValue();
         return this.value1 > 0;
      }
      
      public function get easyCanPlay() : Boolean
      {
         return this.InfoCanPlay;
      }
      
      public function get normalCanPlay() : Boolean
      {
         this.initMissionValue();
         return this.value1 > 1;
      }
      
      public function get difficultCanPlay() : Boolean
      {
         this.initMissionValue();
         return this.value1 > 2;
      }
      
      public function get easyAwardGained() : Boolean
      {
         this.initMissionValue();
         return this.value2 > 0;
      }
      
      public function get normalAwardGained() : Boolean
      {
         this.initMissionValue();
         return this.value2 > 1;
      }
      
      public function get difficultAwardGained() : Boolean
      {
         this.initMissionValue();
         return this.value2 > 2;
      }
   }
}

