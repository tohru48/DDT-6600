package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.qqTips.QQTipsInfo;
   import ddt.view.qqTips.QQTipsView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import road7th.comm.PackageIn;
   
   public class QQtipsManager extends EventDispatcher
   {
      
      private static var _instance:QQtipsManager;
      
      public static const COLSE_QQ_TIPSVIEW:String = "Close_QQ_tipsView";
      
      private var _qqInfoList:Vector.<QQTipsInfo>;
      
      private var _isShowTipNow:Boolean;
      
      public var isGotoShop:Boolean = false;
      
      public var indexCurrentShop:int;
      
      public function QQtipsManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : QQtipsManager
      {
         if(_instance == null)
         {
            _instance = new QQtipsManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._qqInfoList = new Vector.<QQTipsInfo>();
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QQTIPS_GET_INFO,this.__getInfo);
      }
      
      private function __keyDown(e:KeyboardEvent) : void
      {
      }
      
      private function __getInfo(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var info:QQTipsInfo = new QQTipsInfo();
         info.title = pkg.readUTF();
         info.content = pkg.readUTF();
         info.maxLevel = pkg.readInt();
         info.minLevel = pkg.readInt();
         info.outInType = pkg.readInt();
         if(info.outInType == 0)
         {
            info.moduleType = pkg.readInt();
            info.inItemID = pkg.readInt();
         }
         else
         {
            info.url = pkg.readUTF();
         }
         if(info.minLevel <= PlayerManager.Instance.Self.Grade && PlayerManager.Instance.Self.Grade <= info.maxLevel)
         {
            if(this._qqInfoList.length > 0)
            {
               this._qqInfoList.splice(0,this._qqInfoList.length);
            }
            this._qqInfoList.push(info);
         }
         this.checkState();
      }
      
      public function checkState() : void
      {
         if(this._qqInfoList.length > 0 && this.getStateAble(StateManager.currentStateType))
         {
            if(this.isShowTipNow)
            {
               dispatchEvent(new Event(COLSE_QQ_TIPSVIEW));
            }
            this.__showQQTips();
         }
      }
      
      public function checkStateView(type:String) : void
      {
         if(this._qqInfoList.length > 0 && this.getStateAble(type))
         {
            this.__showQQTips();
         }
      }
      
      private function getStateAble(type:String) : Boolean
      {
         if(type == StateType.MAIN || type == StateType.AUCTION || type == StateType.DDTCHURCH_ROOM_LIST || type == StateType.ROOM_LIST || type == StateType.CONSORTIA || type == StateType.DUNGEON_LIST || type == StateType.HOT_SPRING_ROOM_LIST || type == StateType.FIGHT_LIB || type == StateType.ACADEMY_REGISTRATION || type == StateType.CIVIL || type == StateType.TOFFLIST)
         {
            return true;
         }
         return false;
      }
      
      private function __showQQTips() : void
      {
         var frame:QQTipsView = ComponentFactory.Instance.creatCustomObject("coreIconQQ.QQTipsView");
         frame.qqInfo = this._qqInfoList.shift();
         frame.show();
         this.isShowTipNow = true;
      }
      
      public function set isShowTipNow(value:Boolean) : void
      {
         this._isShowTipNow = value;
      }
      
      public function get isShowTipNow() : Boolean
      {
         return this._isShowTipNow;
      }
      
      public function gotoShop(index:int) : void
      {
         if(index > 3)
         {
            return;
         }
         this.isGotoShop = true;
         this.indexCurrentShop = index;
         StateManager.setState(StateType.SHOP);
      }
   }
}

