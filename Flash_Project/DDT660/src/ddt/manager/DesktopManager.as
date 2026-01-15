package ddt.manager
{
   import flash.external.ExternalInterface;
   
   public class DesktopManager
   {
      
      private static var _instance:DesktopManager;
      
      private var _desktopType:int;
      
      private var _isSend:Boolean;
      
      private var _landersAwardFlag:Boolean;
      
      public function DesktopManager()
      {
         super();
      }
      
      public static function get Instance() : DesktopManager
      {
         if(_instance == null)
         {
            _instance = new DesktopManager();
         }
         return _instance;
      }
      
      public function checkIsDesktop() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("SetIsDesktop",this.SetIsDesktop);
            ExternalInterface.addCallback("landersAward",this.landersAward);
            ExternalInterface.call("IsDesktop");
         }
      }
      
      private function landersAward() : void
      {
         this._landersAwardFlag = true;
      }
      
      private function SetIsDesktop() : void
      {
         this._desktopType = 1;
      }
      
      public function get isDesktop() : Boolean
      {
         return this._desktopType > 0;
      }
      
      public function get desktopType() : int
      {
         return this._desktopType;
      }
      
      public function backToLogin() : void
      {
         ExternalInterface.call("WindowReturn");
      }
      
      public function deskTopLogin() : void
      {
         if(this.isDesktop && !this._isSend)
         {
            SocketManager.Instance.out.sendDeskTopLogin();
            this._isSend = true;
         }
      }
      
      public function get landersAwardFlag() : Boolean
      {
         return this._landersAwardFlag;
      }
   }
}

