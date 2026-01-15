package oldPlayerRegress.data
{
   import oldPlayerRegress.RegressManager;
   import oldPlayerRegress.event.RegressEvent;
   import road7th.comm.PackageIn;
   
   public class RegressData
   {
      
      public static var isApplyEnable:Boolean;
      
      public static var isCallEnable:Boolean;
      
      public static var isAutoPop:Boolean = true;
      
      public static var isFirstLogin:Boolean = true;
      
      public static var isOver:Boolean = true;
      
      public function RegressData()
      {
         super();
      }
      
      public static function recvPacksInfo(pkg:PackageIn) : void
      {
         isCallEnable = Boolean(pkg.readInt()) ? false : true;
         isApplyEnable = Boolean(pkg.readInt()) ? false : true;
         var dayNum:int = pkg.readInt();
         isFirstLogin = dayNum > 1 ? false : true;
         var length:int = pkg.readInt();
         for(var i:int = 0; i < length; i++)
         {
            if(pkg.readByte() == 0)
            {
               isOver = false;
               break;
            }
         }
         RegressManager.instance.dispatchEvent(new RegressEvent(RegressEvent.REGRESS_ADD_REGRESSBTN));
      }
   }
}

