package overSeasCommunity.vietnam.view.guestLogin
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.utils.MD5;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;
   
   public class GuestLoginManager extends Sprite
   {
      
      private static var _instance:GuestLoginManager;
      
      private var _showTimer:Timer;
      
      private var _addAccountBtn:BaseButton;
      
      public function GuestLoginManager()
      {
         super();
         this._showTimer = new Timer(int(LanguageMgr.GetTranslation("ddt.guest.Add.timer")),1);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USERREGISTEROK,this.__userRegisterOK);
      }
      
      public static function get Instance() : GuestLoginManager
      {
         if(_instance == null)
         {
            _instance = new GuestLoginManager();
         }
         return _instance;
      }
      
      public function initView() : void
      {
         this._addAccountBtn = ComponentFactory.Instance.creatComponentByStylename("core.guestLogin.addAccountBtn");
         this._addAccountBtn.addEventListener(MouseEvent.CLICK,this.__AddAccount);
         LayerManager.Instance.addToLayer(this._addAccountBtn,LayerManager.GAME_TOP_LAYER);
         if(ExternalInterface.available)
         {
            ExternalInterface.call("setUserID",PlayerManager.Instance.Self.ID);
         }
         this.restartTimer();
      }
      
      private function __AddAccount(e:MouseEvent) : void
      {
         GuestLoginManager.Instance.show();
      }
      
      private function __userRegisterOK(e:CrazyTankSocketEvent) : void
      {
         this.close();
         if(ExternalInterface.available)
         {
            ExternalInterface.call("setUserRegisterOK");
         }
      }
      
      public function show() : void
      {
         this.popup();
      }
      
      private function __show(event:TimerEvent) : void
      {
         this._showTimer.stop();
         this._showTimer.reset();
         this.popup();
      }
      
      private function popup() : void
      {
         var groupid:String = null;
         var userid:String = null;
         var keyPwd:String = null;
         var key:String = null;
         if(ExternalInterface.available)
         {
            groupid = PlayerManager.Instance.Self.ZoneID.toString();
            userid = PlayerManager.Instance.Self.ID.toString();
            keyPwd = "yk-MotL-qhpAo88-7road-mtl55dantang-login-logddt777";
            key = MD5.hash(userid + keyPwd);
            ExternalInterface.call("user_register",groupid,userid,key);
         }
      }
      
      private function restartTimer() : void
      {
         this._showTimer.stop();
         this._showTimer.reset();
         this._showTimer.addEventListener(TimerEvent.TIMER,this.__show);
         this._showTimer.start();
      }
      
      public function close() : void
      {
         if(Boolean(this._addAccountBtn))
         {
            this._addAccountBtn.removeEventListener(MouseEvent.CLICK,this.__AddAccount);
            if(Boolean(this._addAccountBtn.parent))
            {
               this._addAccountBtn.parent.removeChild(this._addAccountBtn);
            }
         }
         this._addAccountBtn = null;
         if(Boolean(this._showTimer))
         {
            this._showTimer.stop();
            this._showTimer.removeEventListener(TimerEvent.TIMER,this.__show);
         }
         this._showTimer = null;
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

