package lanternriddles
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   import ddtActivityIcon.DdtActivityIconManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import lanternriddles.data.LanternDataAnalyzer;
   import lanternriddles.data.LanternriddlesPackageType;
   import lanternriddles.event.LanternEvent;
   import lanternriddles.view.LanternRiddlesView;
   import road7th.comm.PackageIn;
   
   public class LanternRiddlesManager extends EventDispatcher
   {
      
      private static var _instance:LanternRiddlesManager;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private var _isBegin:Boolean;
      
      private var _lanternView:LanternRiddlesView;
      
      private var _questionInfo:Object;
      
      public function LanternRiddlesManager()
      {
         super();
      }
      
      public static function get instance() : LanternRiddlesManager
      {
         if(!_instance)
         {
            _instance = new LanternRiddlesManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         DdtActivityIconManager.Instance.addEventListener(LanternEvent.LANTERN_SETTIME,this.__onSetLanternTime);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_BEGIN,this.__onAddLanternIcon);
      }
      
      protected function __onAddLanternIcon(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         var event:CrazyTankSocketEvent = null;
         switch(cmd)
         {
            case LanternriddlesPackageType.LANTERNRIDDLES_BEGIN:
               this.openOrclose(pkg);
               break;
            case LanternriddlesPackageType.LANTERNRIDDLES_QUESTION:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_QUESTION,pkg);
               break;
            case LanternriddlesPackageType.LANTERNRIDDLES_RANKINFO:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_RANKINFO,pkg);
               break;
            case LanternriddlesPackageType.LANTERNRIDDLES_SKILL:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_SKILL,pkg);
               break;
            case LanternriddlesPackageType.LANTERNRIDDLES_ANSWERRESULT:
               event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_ANSWERRESULT,pkg);
               break;
            case LanternriddlesPackageType.LANTERNRIDDLES_BEGINTIPS:
               this.onBeginTips(pkg);
         }
         if(Boolean(event))
         {
            dispatchEvent(event);
         }
      }
      
      protected function onBeginTips(pkg:PackageIn) : void
      {
         var minite:int = pkg.readInt();
         if(StateManager.currentStateType != StateType.FIGHTING)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.beginTipsText",minite));
         }
         var data:ChatData = new ChatData();
         data.channel = ChatInputView.GM_NOTICE;
         data.msg = LanguageMgr.GetTranslation("lanternRiddles.view.beginTipsText",minite);
         ChatManager.Instance.chat(data);
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         this._isBegin = pkg.readBoolean();
         if(this._isBegin)
         {
            this.smallBugleTips();
            this.showLanternBtn();
         }
         else
         {
            this.deleteLanternBtn();
         }
      }
      
      private function smallBugleTips() : void
      {
         var data:ChatData = new ChatData();
         data.type = ChatFormats.CLICK_LANTERN_BEGIN;
         data.channel = ChatInputView.CROSS_NOTICE;
         data.msg = LanguageMgr.GetTranslation("hall.view.LanternBegin");
         ChatManager.Instance.chat(data);
      }
      
      public function showLanternBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LANTERNRIDDLES,true);
      }
      
      public function onLanternShow(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.show();
      }
      
      protected function __onSetLanternTime(event:LanternEvent) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LANTERNRIDDLES,true,event.Time);
      }
      
      public function deleteLanternBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LANTERNRIDDLES,false);
      }
      
      public function questionInfo(analyer:LanternDataAnalyzer) : void
      {
         this._questionInfo = analyer.data;
      }
      
      public function get info() : Object
      {
         return this._questionInfo;
      }
      
      public function show() : void
      {
         if(!this._isBegin)
         {
            ShowTipManager.Instance.showTip(LanguageMgr.GetTranslation("lanternRiddles.view.activityExpired"));
            return;
         }
         if(loadComplete)
         {
            this.showLanternFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LANTERN_RIDDLES);
         }
      }
      
      public function hide() : void
      {
         this.dispose();
      }
      
      private function dispose() : void
      {
         this.removeEvent();
         if(this._lanternView != null)
         {
            this._lanternView.dispose();
            this._lanternView = null;
         }
      }
      
      private function removeEvent() : void
      {
         DdtActivityIconManager.Instance.removeEventListener(LanternEvent.LANTERN_SETTIME,this.__onSetLanternTime);
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.LANTERN_RIDDLES)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.LANTERN_RIDDLES)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function showLanternFrame() : void
      {
         this._lanternView = ComponentFactory.Instance.creatComponentByStylename("view.LanternRiddlesView");
         this._lanternView.show();
      }
      
      public function checkMoney(money:int) : Boolean
      {
         if(PlayerManager.Instance.Self.Money < money)
         {
            LeavePageManager.showFillFrame();
            return true;
         }
         return false;
      }
      
      public function get isBegin() : Boolean
      {
         return this._isBegin;
      }
   }
}

