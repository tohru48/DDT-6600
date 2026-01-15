package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.ChurchManager;
   import ddt.manager.PlayerManager;
   import im.IMController;
   
   public class LoginAnalyzer extends DataAnalyzer
   {
      
      public var tempPassword:String;
      
      public function LoginAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xml:XML = new XML(data);
         var result:String = xml.@value;
         message = xml.@message;
         if(result == "true")
         {
            PlayerManager.Instance.isReportGameProfile = false;
            PlayerManager.Instance.Self.beginChanges();
            ObjectUtils.copyPorpertiesByXML(PlayerManager.Instance.Self,xml..Item[0]);
            PlayerManager.Instance.Self.commitChanges();
            PlayerManager.Instance.Account.Password = this.tempPassword;
            ChurchManager.instance.selfRoom = xml..Item[0].@IsCreatedMarryRoom == "false" ? null : new ChurchRoomInfo();
            PlayerManager.Instance.isReportGameProfile = true;
            onAnalyzeComplete();
            IMController.Instance.setupRecentContactsList();
         }
         else
         {
            onAnalyzeError();
         }
      }
   }
}

