package Dice.Model
{
   import Dice.Controller.DiceController;
   import Dice.Event.DiceEvent;
   import Dice.VO.DiceCell;
   import Dice.VO.DiceCellInfo;
   import com.pickgliss.ui.ComponentFactory;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class DiceModel extends EventDispatcher
   {
      
      private var _CELL_COUNT:int = 20;
      
      private var _popupAlert:int = 12;
      
      private var _diceType:int = 0;
      
      private var _freeCount:int = 0;
      
      private var _refreshPrice:int;
      
      private var _commonDicePrice:int;
      
      private var _doubleDicePrice:int;
      
      private var _bigDicePrice:int;
      
      private var _smallDicePrice:int;
      
      private var _MAX_LEVEL:int = 5;
      
      private var _levelInfo:Array;
      
      private var _LuckIntegral_Level:int = 0;
      
      private var _LuckIntegral:int = 0;
      
      private var _currentPosition:int = 0;
      
      private var _cellItem:Array;
      
      private var _cellPosition:Array;
      
      private var _useFirstCell:Boolean = false;
      
      private var _isPlayDownMovie:Boolean = false;
      
      private var _rewardItems:Array;
      
      public function DiceModel(target:IEventDispatcher = null)
      {
         this.initialize();
         super(target);
      }
      
      public function get rewardItems() : Array
      {
         return this._rewardItems;
      }
      
      public function set rewardItems(value:Array) : void
      {
         this._rewardItems = value;
      }
      
      public function get popupAlert() : int
      {
         return this._popupAlert;
      }
      
      public function set popupAlert(value:int) : void
      {
         this._popupAlert = value;
      }
      
      public function get isPlayDownMovie() : Boolean
      {
         return this._isPlayDownMovie;
      }
      
      public function set isPlayDownMovie(value:Boolean) : void
      {
         this._isPlayDownMovie = value;
      }
      
      public function get diceType() : int
      {
         return this._diceType;
      }
      
      public function set diceType(value:int) : void
      {
         this._diceType = value;
      }
      
      public function get levelInfo() : Array
      {
         return this._levelInfo;
      }
      
      public function set levelInfo(value:Array) : void
      {
         this._levelInfo = value;
      }
      
      public function get MAX_LEVEL() : int
      {
         return this._MAX_LEVEL;
      }
      
      public function set MAX_LEVEL(value:int) : void
      {
         this._MAX_LEVEL = value;
         this._levelInfo = [];
      }
      
      public function get smallDicePrice() : int
      {
         return this._smallDicePrice;
      }
      
      public function set smallDicePrice(value:int) : void
      {
         this._smallDicePrice = value;
      }
      
      public function get bigDicePrice() : int
      {
         return this._bigDicePrice;
      }
      
      public function set bigDicePrice(value:int) : void
      {
         this._bigDicePrice = value;
      }
      
      public function get doubleDicePrice() : int
      {
         return this._doubleDicePrice;
      }
      
      public function set doubleDicePrice(value:int) : void
      {
         this._doubleDicePrice = value;
      }
      
      public function get commonDicePrice() : int
      {
         return this._commonDicePrice;
      }
      
      public function set commonDicePrice(value:int) : void
      {
         this._commonDicePrice = value;
      }
      
      public function get refreshPrice() : int
      {
         return this._refreshPrice;
      }
      
      public function set refreshPrice(value:int) : void
      {
         this._refreshPrice = value;
      }
      
      public function get freeCount() : int
      {
         return this._freeCount;
      }
      
      public function set freeCount(value:int) : void
      {
         if(this._freeCount != value)
         {
            if(value < 0)
            {
               value = 0;
            }
            this._freeCount = value;
            DiceController.Instance.dispatchEvent(new DiceEvent(DiceEvent.CHANGED_FREE_COUNT));
         }
      }
      
      public function get LuckIntegralLevel() : int
      {
         return this._LuckIntegral_Level;
      }
      
      public function set LuckIntegralLevel(value:int) : void
      {
         if(this._LuckIntegral_Level != value + 1)
         {
            this._LuckIntegral_Level = value + 1;
         }
      }
      
      public function get CELL_COUNT() : int
      {
         return this._CELL_COUNT;
      }
      
      public function get userFirstCell() : Boolean
      {
         return this._useFirstCell;
      }
      
      public function set cellCount(value:int) : void
      {
         this._CELL_COUNT = value;
         this._cellItem = [];
         this._cellPosition = [];
      }
      
      public function set userFirstCell(value:Boolean) : void
      {
         this._useFirstCell = value;
      }
      
      private function initialize() : void
      {
      }
      
      public function setCellInfo() : void
      {
         var info:DiceCellInfo = null;
         for(var i:int = 0; i < this._CELL_COUNT; i++)
         {
            if(Boolean(this._cellPosition[i]))
            {
               this._cellPosition[i].dispose();
               this._cellPosition[i] = null;
            }
            info = ComponentFactory.Instance.creatCustomObject("asset.dice.cellInfo." + (i + 1));
            this._cellPosition[i] = info;
         }
      }
      
      public function get LuckIntegral() : int
      {
         return this._LuckIntegral;
      }
      
      public function set LuckIntegral(value:int) : void
      {
         if(this._LuckIntegral != value)
         {
            this._LuckIntegral = value;
         }
         DiceController.Instance.dispatchEvent(new DiceEvent(DiceEvent.CHANGED_LUCKINTEGRAL));
      }
      
      public function get currentPosition() : int
      {
         return this._currentPosition;
      }
      
      public function set currentPosition(value:int) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         else if(value >= this._CELL_COUNT)
         {
            value = this._CELL_COUNT - 1;
         }
         if(value != DiceController.Instance.CurrentPosition)
         {
            this._currentPosition = value;
            DiceController.Instance.dispatchEvent(new DiceEvent(DiceEvent.CHANGED_PLAYER_POSITION));
         }
      }
      
      public function get cellIDs() : Array
      {
         return this._cellItem;
      }
      
      public function get cellPosition() : Array
      {
         return this._cellPosition;
      }
      
      public function addCellItem(cellValue:DiceCell) : void
      {
         this._cellItem.push(cellValue);
      }
      
      public function removeCellItem(index:int) : void
      {
         if(index < this._cellItem.length)
         {
            if(Boolean(this._cellItem[index]))
            {
               this._cellItem[index].dispose();
            }
            this._cellItem[index] = null;
            this._cellItem.splice(index,1);
         }
      }
      
      public function removeAllItem() : void
      {
         var i:int = 0;
         if(Boolean(this._cellItem))
         {
            for(i = int(this._cellItem.length); i > 0; i--)
            {
               this.removeCellItem(i - 1);
            }
         }
      }
      
      public function dispose() : void
      {
         this._cellItem = null;
         this._cellPosition = null;
      }
   }
}

