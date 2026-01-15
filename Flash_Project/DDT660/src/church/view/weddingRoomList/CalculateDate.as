package church.view.weddingRoomList
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.TimeManager;
   
   public class CalculateDate
   {
      
      public function CalculateDate()
      {
         super();
      }
      
      public static function start(lastDate:Date) : Array
      {
         var dat:Date = TimeManager.Instance.Now();
         var arr:Array = new Array();
         var gapHours:int = (dat.valueOf() - lastDate.valueOf()) / (60 * 60000);
         if(PlayerManager.Instance.Self.isFirstDivorce == 0)
         {
            arr[0] = "<font COLOR=\'#FF0000\'>" + LanguageMgr.GetTranslation("church.weddingRoom.frame.firstDivorce.note") + "</font>";
            arr[1] = "<font COLOR=\'#FF0000\'>" + ServerConfigManager.instance.firstDivorcedMoney + "</font>";
         }
         else if(gapHours >= 720)
         {
            arr[0] = "<font COLOR=\'#FF0000\'>" + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.exceedmounth") + "</font>";
            arr[1] = "<font COLOR=\'#FF0000\'>" + ServerConfigManager.instance.firstDivorcedMoney + "</font>";
         }
         else if(gapHours >= 24 && gapHours < 720)
         {
            arr[0] = "<font COLOR=\'#FF0000\'>" + String(int(gapHours / 24)) + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.day") + "</font>";
            arr[1] = "<font COLOR=\'#FF0000\'>" + PlayerManager.Instance.merryDiscountArr[3] + "</font>";
         }
         else if(gapHours < 24)
         {
            arr[0] = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.notenoughday");
            arr[1] = "<font COLOR=\'#FF0000\'>" + PlayerManager.Instance.merryDiscountArr[3] + "</font>";
         }
         return arr;
      }
      
      public static function needMoney(lastDate:Date) : int
      {
         var num:int = 0;
         var dat:Date = TimeManager.Instance.Now();
         var gapHours:int = (dat.valueOf() - lastDate.valueOf()) / (60 * 60000);
         if(gapHours >= 720 || PlayerManager.Instance.Self.isFirstDivorce == 0)
         {
            num = int(ServerConfigManager.instance.firstDivorcedMoney);
         }
         else
         {
            num = int(PlayerManager.Instance.merryDiscountArr[3]);
         }
         return num;
      }
   }
}

