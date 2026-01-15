package baglocked
{
   import baglocked.data.BagLockedEvent;
   import baglocked.phone4399.MsnConfirmAnalyzer;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.socket.CrazyTankPackageType;
   import ddt.events.BagEvent;
   import ddt.loader.LoaderCreate;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import road7th.comm.PackageIn;
   
   public class BaglockedManager
   {
      
      private static var _instance:BaglockedManager;
      
      public var phoneNum:String = "10000000000";
      
      public var isPhoneBind:Boolean = false;
      
      public var checkBindCase:int = 0;
      
      public function BaglockedManager()
      {
         super();
         this.initEvent();
      }
      
      public static function get Instance() : BaglockedManager
      {
         if(_instance == null)
         {
            _instance = new BaglockedManager();
         }
         return _instance;
      }
      
      public function show() : void
      {
         BagLockedController.Instance.openBagLockedGetFrame();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(BagLockedEvent.DEL_QUESTION,this.__delQuestionHandler);
      }
      
      public function addLockPwdEvent() : void
      {
         SocketManager.Instance.addEventListener(BagLockedEvent.GET_BACK_LOCK_PWD,this.__getBackLockPwdHandler);
      }
      
      public function removeLockPwdEvent() : void
      {
         SocketManager.Instance.removeEventListener(BagLockedEvent.GET_BACK_LOCK_PWD,this.__getBackLockPwdHandler);
      }
      
      protected function __getBackLockPwdHandler(event:BagLockedEvent) : void
      {
         var flag:Boolean = false;
         var count:int = 0;
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readByte();
         if(cmd == CrazyTankPackageType.CHECK_PHONE_BINDING)
         {
            this.isPhoneBind = pkg.readBoolean();
            switch(this.checkBindCase)
            {
               case 0:
                  BagLockedController.Instance.explainFrame2.phoneServiceBtn.enable = this.isPhoneBind;
                  break;
               case 1:
                  this.isPhoneBind = true;
                  if(this.isPhoneBind)
                  {
                     if(PlayerManager.Instance.Self.questionOne == "")
                     {
                        BagLockedController.Instance.openSetPassFrame1();
                     }
                     else
                     {
                        BagLockedController.Instance.openSetPassFrameNew();
                     }
                     BagLockedController.Instance.closeExplainFrame();
                     this.removeLockPwdEvent();
                  }
                  else
                  {
                     BagLockedController.Instance.openBindPhoneFrame();
                     BagLockedController.Instance.closeExplainFrame();
                  }
            }
            return;
         }
         var step:int = pkg.readInt();
         switch(cmd)
         {
            case CrazyTankPackageType.GET_BACK_BY_PHONE:
               switch(step)
               {
                  case 0:
                     flag = pkg.readBoolean();
                     if(flag)
                     {
                        BagLockedController.Instance.close();
                        BagLockedController.Instance.openChangePhoneFrame1();
                     }
                     break;
                  case 1:
                     BagLockedController.Instance.close();
                     BagLockedController.Instance.openChangePhoneFrame2();
                     break;
                  case 2:
                     break;
                  case 3:
                     BagLockedController.Instance.close();
                     BagLockedController.Instance.openChangePhoneFrame3();
                     break;
                  case 4:
                     BagLockedController.Instance.close();
                     BagLockedController.Instance.openChangePhoneFrame4();
                     break;
                  case 5:
                     break;
                  case 6:
                     BagLockedController.Instance.close();
                     this.removeLockPwdEvent();
               }
               break;
            case CrazyTankPackageType.GET_BACK_BY_QUESTION:
               switch(step)
               {
                  case 0:
                     flag = pkg.readBoolean();
                     if(flag)
                     {
                        count = pkg.readInt();
                        BagLockedController.Instance.close();
                        BagLockedController.Instance.openQuestionConfirmFrame1();
                        BagLockedController.Instance.questionConfirmFrame1.setRestTimes(count);
                     }
                     break;
                  case 1:
                     flag = pkg.readBoolean();
                     if(flag)
                     {
                        BagLockedController.Instance.close();
                        BagLockedController.Instance.openQuestionConfirmFrame2();
                     }
                     else
                     {
                        count = pkg.readInt();
                        BagLockedController.Instance.questionConfirmFrame1.setRestTimes(count);
                     }
                     break;
                  case 2:
                     BagLockedController.Instance.close();
                     BagLockedController.Instance.openQuestionConfirmFrame3();
                     break;
                  case 3:
                     break;
                  case 4:
                     BagLockedController.Instance.close();
                     this.removeLockPwdEvent();
               }
               break;
            case CrazyTankPackageType.DELETE_QUESTION:
               switch(step)
               {
                  case 0:
                     flag = pkg.readBoolean();
                     if(flag)
                     {
                        BagLockedController.Instance.close();
                        BagLockedController.Instance.openDeleteQuestionFrame1();
                     }
                     break;
                  case 1:
                     BagLockedController.Instance.close();
                     BagLockedController.Instance.openDeleteQuestionFrame2();
                     break;
                  case 2:
                     break;
                  case 3:
                     BagLockedController.Instance.close();
                     PlayerManager.Instance.Self.questionOne = "";
                     PlayerManager.Instance.Self.questionTwo = "";
                     PlayerManager.Instance.Self.bagPwdState = false;
                     PlayerManager.Instance.Self.bagLocked = false;
                     PlayerManager.Instance.Self.onReceiveTypes(BagEvent.AFTERDEL);
                     this.removeLockPwdEvent();
               }
               break;
            case CrazyTankPackageType.DELETE_PWD_BY_PHONE:
               switch(step)
               {
                  case 0:
                     flag = pkg.readBoolean();
                     if(flag)
                     {
                        BagLockedController.Instance.close();
                        BagLockedController.Instance.openDeletePwdByphoneFrame1();
                     }
                     break;
                  case 1:
                     BagLockedController.Instance.close();
                     BagLockedController.Instance.openDeletePwdByphoneFrame2();
                     break;
                  case 2:
                     break;
                  case 3:
                     BagLockedController.Instance.close();
                     PlayerManager.Instance.Self.bagPwdState = false;
                     PlayerManager.Instance.Self.bagLocked = false;
                     PlayerManager.Instance.Self.onReceiveTypes(BagEvent.AFTERDEL);
                     this.removeLockPwdEvent();
               }
         }
      }
      
      public function requestConfirm(type:int, code:String = "") : void
      {
         var loader:BaseLoader = LoaderCreate.Instance.requestMsnConfirm(type,code);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      public function msnConfirmAnalyeComplete(analyzer:MsnConfirmAnalyzer) : void
      {
         switch(analyzer.type)
         {
            case 1:
               if(analyzer.value)
               {
                  BagLockedController.Instance.close();
                  BagLockedController.Instance.openConfirmNum4399Frame();
               }
               else
               {
                  MessageTipManager.getInstance().show(analyzer.alertMessage);
               }
               break;
            case 2:
               if(analyzer.value)
               {
                  BagLockedController.Instance.close();
               }
               MessageTipManager.getInstance().show(analyzer.alertMessage);
         }
      }
      
      protected function __delQuestionHandler(event:BagLockedEvent) : void
      {
         PlayerManager.Instance.Self.bagPwdState = false;
         PlayerManager.Instance.Self.bagLocked = false;
         PlayerManager.Instance.Self.questionOne = "";
         PlayerManager.Instance.Self.questionTwo = "";
         PlayerManager.Instance.Self.onReceiveTypes(BagEvent.AFTERDEL);
      }
   }
}

