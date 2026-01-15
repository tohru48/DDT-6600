package ddt.data.quest
{
   public class QuestDataInfo
   {
      
      public var isGet:Boolean;
      
      public var repeatLeft:int;
      
      public var hadChecked:Boolean;
      
      public var quality:int;
      
      private var _questID:int;
      
      private var _progress:Array;
      
      public var CompleteDate:Date;
      
      private var _isAchieved:Boolean;
      
      private var _isNew:Boolean;
      
      private var _informed:Boolean;
      
      private var _isExist:Boolean;
      
      public function QuestDataInfo(id:int)
      {
         super();
         this._questID = id;
         this.hadChecked = false;
         this._isNew = false;
         this._informed = false;
      }
      
      public function set isExist(value:Boolean) : void
      {
         this._isExist = value;
      }
      
      public function get isExist() : Boolean
      {
         return this._isExist;
      }
      
      public function get id() : int
      {
         return this._questID;
      }
      
      public function set isNew(value:Boolean) : void
      {
         this._isNew = value;
      }
      
      public function get isNew() : Boolean
      {
         return this._isNew;
      }
      
      public function set informed(value:Boolean) : void
      {
         this._informed = value;
      }
      
      public function get needInformed() : Boolean
      {
         if(!this._informed && this._isNew)
         {
            return true;
         }
         return false;
      }
      
      public function get isAchieved() : Boolean
      {
         return this._isAchieved;
      }
      
      public function set isAchieved(isAchieved:Boolean) : void
      {
         this._isAchieved = isAchieved;
      }
      
      public function setProgress(con0:int, con1:int = 0, con2:int = 0, con3:int = 0) : void
      {
         if(!this._progress)
         {
            this._progress = new Array();
         }
         if(this.id == 3001)
         {
         }
         this._progress[0] = con0;
         this._progress[1] = con1;
         this._progress[2] = con2;
         this._progress[3] = con3;
      }
      
      public function setProgressConcoat(proArray:Array) : void
      {
         var tmpLen:int = int(proArray.length);
         for(var i:int = 0; i < tmpLen; i++)
         {
            this._progress[i + 4] = proArray[i];
         }
      }
      
      public function get progress() : Array
      {
         return this._progress;
      }
      
      public function get isCompleted() : Boolean
      {
         if(!this._progress)
         {
            return false;
         }
         if(this._progress[0] <= 0 && this._progress[1] <= 0 && this._progress[2] <= 0 && this._progress[3] <= 0)
         {
            return true;
         }
         return false;
      }
      
      public function get ConditionCount() : int
      {
         if(Boolean(this._progress[0]))
         {
            return this._progress[0];
         }
         return 0;
      }
      
      public function set ConditionCount(i:int) : void
      {
      }
   }
}

