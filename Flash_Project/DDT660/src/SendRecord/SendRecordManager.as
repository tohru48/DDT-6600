package SendRecord
{
   import ddt.manager.DesktopManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.StatisticManager;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.system.fscommand;
   import flash.utils.Dictionary;
   
   public class SendRecordManager
   {
      
      private static var _instance:SendRecordManager;
      
      private var _browserInfo:String = "";
      
      public function SendRecordManager()
      {
         super();
      }
      
      public static function get Instance() : SendRecordManager
      {
         if(_instance == null)
         {
            _instance = new SendRecordManager();
         }
         return _instance;
      }
      
      private function sendRecordUserVersion(paramStr:String = "") : void
      {
         var key:String = null;
         var request:URLRequest = null;
         var data:Array = null;
         var paramsCount:int = 0;
         var i:int = 0;
         var userInfo:Dictionary = new Dictionary();
         if(paramStr != "")
         {
            data = paramStr.split("|");
            paramsCount = data.length / 2;
            for(i = 0; i < paramsCount; i++)
            {
               userInfo[data[i * 2]] = data[i * 2 + 1];
            }
         }
         var varialbes:URLVariables = new URLVariables();
         var urlLoader:URLLoader = new URLLoader();
         varialbes.Browser = this._browserInfo;
         varialbes.SiteName = StatisticManager.siteName;
         varialbes.UserName = PlayerManager.Instance.Account.Account;
         varialbes.Flash = Capabilities.version.split(" ")[1];
         varialbes.Sys = Capabilities.os;
         varialbes.Is64Bit = Capabilities.supports64BitProcesses;
         varialbes.Screen = Capabilities.screenResolutionX + "X" + Capabilities.screenResolutionY;
         for(key in userInfo)
         {
            varialbes[key] = userInfo[key];
         }
         request = new URLRequest(PathManager.solveRequestPath("RecordSysInfo.ashx"));
         request.method = URLRequestMethod.POST;
         request.data = varialbes;
         urlLoader.load(request);
      }
      
      private function browserInfo(msg:String) : void
      {
         this._browserInfo = msg;
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            this.sendRecordUserVersion();
         }
         else
         {
            ExternalInterface.addCallback("GetUserData",this.sendRecordUserVersion);
            fscommand("AddUserData");
         }
      }
      
      public function setUp() : void
      {
         var msg:String = null;
         if(ExternalInterface.available)
         {
            msg = ExternalInterface.call("getBrowserInfo");
            this.browserInfo(msg);
         }
      }
   }
}

