package fightFootballTime.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import fightFootballTime.view.FightFootballTimeMatchView;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class FightFootballTimeManager
   {
      
      private static var _instance:FightFootballTimeManager = null;
      
      public static const FIGHTFOOTBALLTIME_ROOM:int = 30;
      
      public var isInLoading:Boolean = false;
      
      private var _isopen:Boolean = false;
      
      private var callback:Function;
      
      public var takeoutAll:Boolean = false;
      
      private var fightFootballTimeMatchView:FightFootballTimeMatchView;
      
      private var _UILoadComplete:Boolean = false;
      
      public function FightFootballTimeManager()
      {
         super();
      }
      
      public static function get instance() : FightFootballTimeManager
      {
         if(_instance == null)
         {
            _instance = new FightFootballTimeManager();
         }
         return _instance;
      }
      
      public function set ShowIcon(value:Function) : void
      {
         this.callback = value;
      }
      
      public function Setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTFOOTBALLTIME_ACTIVE,this.__isopen);
      }
      
      public function get isopen() : Boolean
      {
         return this._isopen;
      }
      
      private function __isopen(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var active:Boolean = pkg.readBoolean();
         if(active)
         {
            this._isopen = true;
         }
         else
         {
            this._isopen = false;
         }
         if(this.callback != null)
         {
            this.callback(this._isopen);
         }
      }
      
      public function enterFightFootballTime() : void
      {
         SoundManager.instance.play("008");
         if(!this._UILoadComplete)
         {
            this.loadUIModule();
         }
         else
         {
            this.creatView();
         }
      }
      
      private function creatView() : void
      {
         if(Boolean(this.fightFootballTimeMatchView))
         {
            this.fightFootballTimeMatchView = null;
         }
         this.fightFootballTimeMatchView = ComponentFactory.Instance.creatComponentByStylename("fightFootballTime.matchView");
         this.fightFootballTimeMatchView.show();
         this.fightFootballTimeMatchView.addEventListener(FrameEvent.RESPONSE,this.__responseEvent);
      }
      
      private function __responseEvent(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.playButtonSound();
            GameInSocketOut.sendCancelWait();
            if(Boolean(this.fightFootballTimeMatchView))
            {
               this.fightFootballTimeMatchView.dispose();
            }
         }
      }
      
      private function loadUIModule() : void
      {
         if(!this._UILoadComplete)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FIGHTFOOTBALLTIME);
         }
         else
         {
            this.creatView();
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
      
      protected function __onUIModuleComplete(event:UIModuleEvent) : void
      {
         this._UILoadComplete = true;
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleSmallLoading.Instance.hide();
         this.creatView();
      }
      
      protected function __onProgress(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
   }
}

