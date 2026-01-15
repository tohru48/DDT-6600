package Dice.Controller
{
   import Dice.Event.DiceEvent;
   import Dice.Model.DiceModel;
   import Dice.VO.DiceAwardInfo;
   import Dice.VO.DiceCell;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   
   [Event(name="dice_refresh_data",type="Dice.Event.DiceEvent")]
   public class DiceController extends EventDispatcher
   {
      
      private static var _instance:DiceController;
      
      private var _model:DiceModel;
      
      private var _isFirst:Boolean = true;
      
      public function DiceController(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get Instance() : DiceController
      {
         if(_instance == null)
         {
            _instance = new DiceController();
         }
         return _instance;
      }
      
      public function set isFirst(value:Boolean) : void
      {
         this._isFirst = value;
      }
      
      public function get hasUsedFirstCell() : Boolean
      {
         return this._model.userFirstCell;
      }
      
      public function get CELL_COUNT() : int
      {
         return this._model.CELL_COUNT;
      }
      
      public function get cellIDs() : Array
      {
         return this._model.cellIDs;
      }
      
      public function get MAX_LEVEL() : int
      {
         return this._model.MAX_LEVEL;
      }
      
      public function get freeCount() : int
      {
         return this._model.freeCount;
      }
      
      public function set freeCount(value:int) : void
      {
         this._model.freeCount = value;
      }
      
      public function get diceType() : int
      {
         return this._model.diceType;
      }
      
      public function get commonDicePrice() : int
      {
         return this._model.commonDicePrice;
      }
      
      public function get doubleDicePrice() : int
      {
         return this._model.doubleDicePrice;
      }
      
      public function get bigDicePrice() : int
      {
         return this._model.bigDicePrice;
      }
      
      public function get smallDicePrice() : int
      {
         return this._model.smallDicePrice;
      }
      
      public function get refreshPrice() : int
      {
         return this._model.refreshPrice;
      }
      
      public function get canPopupNextRefreshWindow() : Boolean
      {
         return (this._model.popupAlert & 1) == 1;
      }
      
      public function get canPopupNextStartWindow() : Boolean
      {
         return (this._model.popupAlert & 2) == 2;
      }
      
      public function get rewardItems() : Array
      {
         return this._model.rewardItems;
      }
      
      public function set rewardItems(value:Array) : void
      {
         this._model.rewardItems = value;
      }
      
      public function setPopupNextRefreshWindow(value:Boolean) : void
      {
         if(value)
         {
            this._model.popupAlert |= 1;
         }
         else
         {
            this._model.popupAlert &= 14;
         }
      }
      
      public function setPopupNextStartWindow(value:Boolean) : void
      {
         if(value)
         {
            this._model.popupAlert |= 2;
         }
         else
         {
            this._model.popupAlert &= 13;
         }
      }
      
      public function cannotPopupNextStartWindow() : void
      {
         this._model.popupAlert |= 2;
      }
      
      public function set isPlayDownMovie(value:Boolean) : void
      {
         this._model.isPlayDownMovie = value;
      }
      
      public function get isPlayDownMovie() : Boolean
      {
         return this._model.isPlayDownMovie;
      }
      
      public function setDestinationCell(value:int) : void
      {
         var list:Array = this._model.cellIDs;
         for(var i:int = 0; i < list.length; i++)
         {
            if(Boolean(list[i]))
            {
               if(i != value)
               {
                  list[i].isDestination = false;
               }
               else
               {
                  list[i].isDestination = true;
               }
            }
         }
      }
      
      public function set diceType(value:int) : void
      {
         this._model.diceType = value;
      }
      
      public function get LuckIntegralLevel() : int
      {
         return this._model.LuckIntegralLevel;
      }
      
      public function get canUseModel() : Boolean
      {
         if(this._model != null)
         {
            return true;
         }
         return false;
      }
      
      public function set LuckIntegralLevel(value:int) : void
      {
         this._model.LuckIntegralLevel = value;
      }
      
      public function get LuckIntegral() : int
      {
         return this._model.LuckIntegral;
      }
      
      public function get cellPosition() : Array
      {
         return this._model.cellPosition;
      }
      
      public function get CurrentPosition() : int
      {
         return this._model.currentPosition;
      }
      
      public function set CurrentPosition(value:int) : void
      {
         this._model.currentPosition = value;
      }
      
      public function setCellInfo() : void
      {
         this._model.setCellInfo();
      }
      
      public function get AwardLevelInfo() : Array
      {
         return this._model.levelInfo;
      }
      
      public function install(pkg:PackageIn) : void
      {
         this.initialize(pkg);
         this.addEvent();
      }
      
      public function unInstall() : void
      {
         dispatchEvent(new DiceEvent(DiceEvent.ACTIVE_CLOSE));
         this.removeEvent();
         if(Boolean(this._model))
         {
            this._model.dispose();
            this._model = null;
         }
      }
      
      private function initialize(pkg:PackageIn) : void
      {
         var _temp1:int = 0;
         var _temp2:int = 0;
         var _str:String = null;
         var j:int = 0;
         this._model = new DiceModel();
         this._model.freeCount = pkg.readInt();
         this._model.refreshPrice = pkg.readInt();
         this._model.commonDicePrice = pkg.readInt();
         this._model.doubleDicePrice = pkg.readInt();
         this._model.bigDicePrice = pkg.readInt();
         this._model.smallDicePrice = pkg.readInt();
         this._model.MAX_LEVEL = pkg.readInt();
         for(var i:int = 0; i < this._model.MAX_LEVEL; i++)
         {
            _temp1 = pkg.readInt();
            _temp2 = pkg.readInt();
            _str = "";
            for(j = 0; j < _temp2; j++)
            {
               _str += "," + pkg.readInt() + "|" + pkg.readInt();
            }
            _str = _str.substring(1);
            this._model.levelInfo[i] = new DiceAwardInfo(i + 1,_temp1,_str);
         }
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DICE_RECEIVE_DATA,this.__onReceiveData);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DICE_RECEIVE_RESULT,this.__receiveResult);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DICE_RECEIVE_DATA,this.__onReceiveData);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DICE_RECEIVE_RESULT,this.__receiveResult);
      }
      
      private function __onReceiveData(event:CrazyTankSocketEvent) : void
      {
         var temp_level:int = 0;
         var temp_luckintegral:int = 0;
         var pkg:PackageIn = event.pkg;
         this._model.userFirstCell = pkg.readBoolean();
         this._model.currentPosition = pkg.readInt() + 1;
         temp_level = pkg.readInt();
         temp_luckintegral = pkg.readInt();
         if(this._isFirst)
         {
            this._model.LuckIntegralLevel = temp_level;
            this._isFirst = false;
         }
         if(DiceController.Instance.LuckIntegralLevel != temp_level + 1 || temp_level == -1 && temp_luckintegral < this._model.LuckIntegral)
         {
            this._model.LuckIntegralLevel = temp_level;
            this._model.isPlayDownMovie = true;
            dispatchEvent(new DiceEvent(DiceEvent.CHANGED_LUCKINTEGRAL_LEVEL));
         }
         this._model.LuckIntegral = temp_luckintegral;
         this._model.freeCount = pkg.readInt();
         this.ReceiveListByPkg(pkg);
      }
      
      private function ReceiveListByPkg(pkg:PackageIn) : void
      {
         var cell:DiceCell = null;
         var bg:MovieClip = null;
         var shape:MovieClip = null;
         var info:ItemTemplateInfo = null;
         var count:int = 0;
         var start:int = this._model.userFirstCell ? 0 : 1;
         this._model.removeAllItem();
         count = (this._model.cellCount = pkg.readInt() + start) - start;
         this._model.setCellInfo();
         for(var i:int = 0; i < count; i++)
         {
            bg = ComponentFactory.Instance.creat("asset.dice.bg" + (start + i + 1));
            shape = ComponentFactory.Instance.creat("asset.cell.mask" + (start + i));
            info = ItemManager.Instance.getTemplateById(pkg.readInt());
            cell = new DiceCell(bg,this._model.cellPosition[i + start],info,shape);
            cell.position = pkg.readInt();
            cell.strengthLevel = pkg.readInt();
            cell.count = pkg.readInt();
            cell.validate = pkg.readInt();
            cell.isBind = pkg.readBoolean();
            this._model.addCellItem(cell);
         }
         dispatchEvent(new DiceEvent(DiceEvent.REFRESH_DATA));
         if(StateManager.currentStateType != StateType.DICE_SYSTEM)
         {
            StateManager.setState(StateType.DICE_SYSTEM);
         }
      }
      
      private function __receiveResult(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var proxy:Object = new Object();
         proxy.position = pkg.readInt() + 1;
         proxy.result = pkg.readInt();
         proxy.luckIntegral = pkg.readInt();
         proxy.level = pkg.readInt();
         proxy.freeCount = pkg.readInt();
         proxy.rewardItem = pkg.readUTF();
         if(DiceController.Instance.CurrentPosition != proxy.position)
         {
            DiceController.Instance.CurrentPosition = proxy.position;
         }
         this._model.freeCount = proxy.freeCount;
         if(DiceController.Instance.LuckIntegralLevel != proxy.level + 1 || proxy.level == -1 && this._model.LuckIntegral > proxy.luckIntegral)
         {
            this._model.LuckIntegralLevel = proxy.level;
            this._model.isPlayDownMovie = true;
            dispatchEvent(new DiceEvent(DiceEvent.CHANGED_LUCKINTEGRAL_LEVEL));
         }
         this._model.LuckIntegral = proxy.luckIntegral;
         dispatchEvent(new DiceEvent(DiceEvent.GET_DICE_RESULT_DATA,proxy));
      }
   }
}

