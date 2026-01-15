package catchInsect.data
{
   import catchInsect.player.PlayerVO;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class CatchInsectItemInfo extends EventDispatcher
   {
      
      public var TemplateID:int;
      
      public var Count:int = 1;
      
      private var _templateInfo:ItemTemplateInfo;
      
      public var isUp:Boolean;
      
      public var isFall:Boolean;
      
      public var num:int = 10;
      
      private var _playerDefaultPos:Point;
      
      private var _fightOver:Boolean;
      
      private var _roomClose:Boolean;
      
      private var _myPlayerVO:PlayerVO;
      
      private var _isLiving:Boolean;
      
      private var _current_Blood:Number;
      
      private var _cutValue:Number;
      
      private var _snowNum:int;
      
      public function CatchInsectItemInfo($TemplateID:int = 0)
      {
         super();
         this.TemplateID = $TemplateID;
      }
      
      public function get TemplateInfo() : ItemTemplateInfo
      {
         if(this._templateInfo == null)
         {
            return ItemManager.Instance.getTemplateById(this.TemplateID);
         }
         return this._templateInfo;
      }
      
      public function get playerDefaultPos() : Point
      {
         return this._playerDefaultPos;
      }
      
      public function set playerDefaultPos(value:Point) : void
      {
         this._playerDefaultPos = value;
      }
      
      public function get fightOver() : Boolean
      {
         return this._fightOver;
      }
      
      public function set fightOver(value:Boolean) : void
      {
         this._fightOver = value;
      }
      
      public function get roomClose() : Boolean
      {
         return this._roomClose;
      }
      
      public function set roomClose(value:Boolean) : void
      {
         this._roomClose = value;
      }
      
      public function get myPlayerVO() : PlayerVO
      {
         return this._myPlayerVO;
      }
      
      public function set myPlayerVO(value:PlayerVO) : void
      {
         this._myPlayerVO = value;
      }
      
      public function set current_Blood(value:Number) : void
      {
         if(this._current_Blood == value)
         {
            this._cutValue = -1;
            return;
         }
         this._cutValue = this._current_Blood - value;
         this._current_Blood = value;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get current_Blood() : Number
      {
         return this._current_Blood;
      }
      
      public function set isLiving(value:Boolean) : void
      {
         this._isLiving = value;
         if(!this._isLiving)
         {
            this.current_Blood = 0;
         }
      }
      
      public function get isLiving() : Boolean
      {
         return this._isLiving;
      }
      
      public function get snowNum() : int
      {
         return this._snowNum;
      }
      
      public function set snowNum(value:int) : void
      {
         this._snowNum = value;
      }
   }
}

