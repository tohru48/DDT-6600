package vip
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.GradientText;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.SelfInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import vip.data.VipModelInfo;
   import vip.view.RechargeAlertTxt;
   import vip.view.VIPHelpFrame;
   import vip.view.VIPRechargeAlertFrame;
   import vip.view.VipFrame;
   import vip.view.VipViewFrame;
   
   public class VipController extends EventDispatcher
   {
      
      private static var _instance:VipController;
      
      public static var useFirst:Boolean = true;
      
      public static var loadComplete:Boolean = false;
      
      public var info:VipModelInfo;
      
      public var isRechargePoped:Boolean;
      
      private var _vipFrame:VipFrame;
      
      private var _vipViewFrame:VipViewFrame;
      
      private var _isShow:Boolean;
      
      private var _helpframe:VIPHelpFrame;
      
      private var _rechargeAlertFrame:VIPRechargeAlertFrame;
      
      private var _rechargeAlertLoad:Boolean = false;
      
      public function VipController()
      {
         super();
      }
      
      public static function get instance() : VipController
      {
         if(!_instance)
         {
            _instance = new VipController();
         }
         return _instance;
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showVipFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
         }
      }
      
      public function showRechargeAlert() : void
      {
         var selfInfo:SelfInfo = null;
         var rechargeAlertTxt:RechargeAlertTxt = null;
         if(loadComplete)
         {
            if(this._rechargeAlertFrame == null)
            {
               this._rechargeAlertFrame = ComponentFactory.Instance.creatComponentByStylename("vip.vipRechargeAlertFrame");
               selfInfo = PlayerManager.Instance.Self;
               rechargeAlertTxt = new RechargeAlertTxt();
               rechargeAlertTxt.AlertContent = selfInfo.VIPLevel;
               this._rechargeAlertFrame.content = rechargeAlertTxt;
               this._rechargeAlertFrame.show();
               this._rechargeAlertFrame.addEventListener(FrameEvent.RESPONSE,this.__responseRechargeAlertHandler);
            }
         }
         else if(useFirst)
         {
            this._rechargeAlertLoad = true;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
            useFirst = false;
         }
      }
      
      public function helpframeNull() : void
      {
         if(Boolean(this._helpframe))
         {
            this._helpframe = null;
         }
      }
      
      protected function __responseHandler(event:FrameEvent) : void
      {
         this._helpframe.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._helpframe.dispose();
         }
      }
      
      protected function __responseRechargeAlertHandler(event:FrameEvent) : void
      {
         this._rechargeAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__responseRechargeAlertHandler);
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._rechargeAlertFrame.dispose();
         }
         if(Boolean(this._rechargeAlertFrame))
         {
            this._rechargeAlertFrame = null;
         }
      }
      
      private function showVipFrame() : void
      {
         if(Boolean(this._vipFrame))
         {
            this.hide();
         }
         this._vipFrame = ComponentFactory.Instance.creatComponentByStylename("vip.VipFrame");
         this._vipFrame.show();
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            if(this._rechargeAlertLoad)
            {
               this.showRechargeAlert();
            }
            else
            {
               this.show();
            }
         }
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      public function sendOpenVip(name:String, days:int, bool:Boolean = true) : void
      {
         SocketManager.Instance.out.sendOpenVip(name,days,bool);
      }
      
      public function hide() : void
      {
         if(this._vipFrame != null)
         {
            this._vipFrame.dispose();
         }
         this._vipFrame = null;
      }
      
      public function getVipNameTxt($width:int = -1, typeVIP:int = 1) : GradientText
      {
         var text:GradientText = null;
         switch(typeVIP)
         {
            case 0:
               throw new Error("会员类型错误,不能为非会员玩家创建会员字体.");
            case 1:
               text = ComponentFactory.Instance.creatComponentByStylename("vipName");
               break;
            case 2:
               text = ComponentFactory.Instance.creatComponentByStylename("vipName");
         }
         if(Boolean(text))
         {
            if($width != -1)
            {
               text.textField.width = $width;
            }
            else
            {
               text.textField.autoSize = "left";
            }
            return text;
         }
         return ComponentFactory.Instance.creatComponentByStylename("vipName");
      }
      
      public function getVIPStrengthenEx(level:int) : Number
      {
         if(level - 1 < 0)
         {
            return 0;
         }
         var arr:Array = ServerConfigManager.instance.VIPStrengthenEx;
         if(Boolean(arr))
         {
            return arr[level - 1];
         }
         return 0;
      }
   }
}

