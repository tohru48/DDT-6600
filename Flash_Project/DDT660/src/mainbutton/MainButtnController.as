package mainbutton
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mainbutton.data.MainButtonManager;
   
   public class MainButtnController extends EventDispatcher
   {
      
      private static var _instance:MainButtnController;
      
      public static var useFirst:Boolean = true;
      
      public static var loadComplete:Boolean = false;
      
      public static var ACTIVITIES:String = "1";
      
      public static var ROULETTE:String = "2";
      
      public static var VIP:String = "3";
      
      public static var SIGN:String = "5";
      
      public static var AWARD:String = "6";
      
      public static var ANGELBLESS:String = "7";
      
      public static var FIRSTRECHARGE:String = "8";
      
      public static var DICE:String = "8";
      
      public static var DDT_ACTIVITY:String = "ddtactivity";
      
      public static var DDT_AWARD:String = "ddtaward";
      
      public static var ICONCLOSE:String = "iconClose";
      
      public static var CLOSESIGN:String = "closeSign";
      
      public static var ICONOPEN:String = "iconOpen";
      
      public var btnList:Vector.<MainButton>;
      
      private var _currntType:String;
      
      private var _awardFrame:AwardFrame;
      
      private var _dailAwardState:Boolean;
      
      private var _vipAwardState:Boolean;
      
      public function MainButtnController()
      {
         super();
      }
      
      public static function get instance() : MainButtnController
      {
         if(!_instance)
         {
            _instance = new MainButtnController();
         }
         return _instance;
      }
      
      public function show(type:String) : void
      {
         this._currntType = type;
         if(loadComplete)
         {
            this.showFrame(this._currntType);
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTMAINBTN);
            useFirst = false;
         }
      }
      
      private function showFrame(pType:String) : void
      {
         switch(pType)
         {
            case MainButtnController.DDT_AWARD:
               this._awardFrame = ComponentFactory.Instance.creatCustomObject("ddtmainbutton.AwardFrame");
               LayerManager.Instance.addToLayer(this._awardFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDTMAINBTN)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDTMAINBTN)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            this.showFrame(this._currntType);
         }
      }
      
      public function set DailyAwardState(state:Boolean) : void
      {
         this._dailAwardState = state;
      }
      
      public function get DailyAwardState() : Boolean
      {
         return this._dailAwardState;
      }
      
      public function set VipAwardState(state:Boolean) : void
      {
         this._vipAwardState = state;
      }
      
      public function get VipAwardState() : Boolean
      {
         return this._vipAwardState;
      }
      
      public function get BtnList() : Vector.<MainButton>
      {
         return this.btnList;
      }
      
      public function test() : Vector.<MainButton>
      {
         this.btnList = new Vector.<MainButton>();
         var btn:MainButton = MainButtonManager.instance.getInfoByID(ACTIVITIES);
         var btn1:MainButton = MainButtonManager.instance.getInfoByID(ROULETTE);
         var btn3:MainButton = MainButtonManager.instance.getInfoByID(SIGN);
         var btn4:MainButton = MainButtonManager.instance.getInfoByID(AWARD);
         var btn5:MainButton = MainButtonManager.instance.getInfoByID(ANGELBLESS);
         var btn8:MainButton = MainButtonManager.instance.getInfoByID(DICE);
         if(btn.IsShow)
         {
            btn.btnMark = 1;
            btn.btnServerVisable = 1;
            btn.btnCompleteVisable = 1;
            this.btnList.push(btn);
         }
         else
         {
            btn.btnMark = 1;
            btn.btnServerVisable = 2;
            btn.btnCompleteVisable = 2;
         }
         return this.btnList;
      }
   }
}

