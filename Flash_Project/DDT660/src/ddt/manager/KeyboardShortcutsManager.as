package ddt.manager
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.LayerManager;
   import ddt.states.StateType;
   import email.manager.MailManager;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import gotopage.view.GotoPageController;
   import horse.HorseManager;
   import im.IMController;
   import org.aswing.KeyStroke;
   import petsBag.PetsBagManager;
   import petsBag.petsAdvanced.PetsAdvancedManager;
   import setting.controll.SettingController;
   
   public class KeyboardShortcutsManager
   {
      
      private static var _instance:KeyboardShortcutsManager;
      
      public static const GAME_PREPARE:int = 1;
      
      public static const GAME:int = 2;
      
      public static const BAG:int = 3;
      
      public static const FRIEND:int = 4;
      
      public static const GAME_WAIT:int = 5;
      
      private var isProhibit_M:Boolean;
      
      private var isProhibit_B:Boolean;
      
      private var isProhibit_Q:Boolean;
      
      private var isProhibit_F:Boolean;
      
      private var isProhibit_G:Boolean;
      
      private var isProhibit_H:Boolean;
      
      private var isProhibit_T:Boolean;
      
      private var isProhibit_R:Boolean;
      
      private var isProhibit_S:Boolean;
      
      private var isProhibit_P:Boolean;
      
      private var isFullForbid:Boolean;
      
      private var isAddEvent:Boolean = true;
      
      private var isForbiddenSection:Boolean = true;
      
      private var isProhibitNewHand_M:Boolean = true;
      
      private var isProhibitNewHand_B:Boolean = true;
      
      private var isProhibitNewHand_F:Boolean = true;
      
      private var isProhibitNewHand_T:Boolean = true;
      
      private var isProhibitNewHand_R:Boolean = true;
      
      private var isProhibitNewHand_S:Boolean = true;
      
      private var isProhibitNewHand_H:Boolean = true;
      
      private var isProhibitNewHand_P:Boolean = true;
      
      private var isProhibitNewHand_Q:Boolean = true;
      
      public function KeyboardShortcutsManager()
      {
         super();
      }
      
      public static function get Instance() : KeyboardShortcutsManager
      {
         if(_instance == null)
         {
            _instance = new KeyboardShortcutsManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         if(this.isAddEvent)
         {
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_UP,this.__onKeyDown);
            this.isAddEvent = false;
         }
      }
      
      private function __onKeyDown(event:KeyboardEvent) : void
      {
         if(this.isFullForbid)
         {
            return;
         }
         if(this.isForbiddenSection)
         {
            this.getKeyboardShortcutsState();
         }
         if(event.target is TextField && (event.target as TextField).type == TextFieldType.INPUT)
         {
            return;
         }
         if(LayerManager.Instance.backGroundInParent)
         {
            this.closeCurrentFrame(event.keyCode);
            return;
         }
         switch(event.keyCode)
         {
            case KeyStroke.VK_M.getCode():
               if(this.isProhibit_M && this.isProhibitNewHand_M)
               {
                  SoundManager.instance.play("003");
                  HorseManager.instance.loadModule();
               }
               break;
            case KeyStroke.VK_B.getCode():
               if(this.isProhibit_B && this.isProhibitNewHand_B)
               {
                  SoundManager.instance.play("003");
                  StageReferance.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
                  BagAndInfoManager.Instance.showBagAndInfo();
               }
               break;
            case KeyStroke.VK_Q.getCode():
               if(this.isProhibit_Q && this.isProhibitNewHand_Q)
               {
                  SoundManager.instance.play("003");
                  TaskManager.instance.switchVisible();
               }
               break;
            case KeyStroke.VK_F.getCode():
               if(this.isProhibit_F && this.isProhibitNewHand_F)
               {
                  if(PlayerManager.Instance.Self.Grade >= 11)
                  {
                     SoundManager.instance.play("003");
                     IMController.Instance.switchVisible();
                  }
               }
               break;
            case KeyStroke.VK_G.getCode():
               if(this.isProhibit_G)
               {
                  if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.DUNGEON_LIST || StateManager.currentStateType == StateType.ROOM_LIST)
                  {
                     if(PlayerManager.Instance.Self.Grade >= 17)
                     {
                        SoundManager.instance.play("003");
                        StateManager.setState(StateType.CONSORTIA);
                     }
                  }
               }
               break;
            case KeyStroke.VK_H.getCode():
               if(this.isProhibit_H && this.isProhibitNewHand_H)
               {
                  SoundManager.instance.play("003");
                  SettingController.Instance.switchVisible();
               }
               break;
            case KeyStroke.VK_T.getCode():
               if(this.isProhibit_T && this.isProhibitNewHand_T)
               {
                  SoundManager.instance.play("003");
                  GotoPageController.Instance.switchVisible();
               }
               break;
            case KeyStroke.VK_R.getCode():
               if(this.isProhibit_R && this.isProhibitNewHand_R)
               {
                  if(PlayerManager.Instance.Self.Grade >= 11)
                  {
                     SoundManager.instance.play("003");
                     MailManager.Instance.switchVisible();
                  }
               }
               break;
            case KeyStroke.VK_S.getCode():
               break;
            case KeyStroke.VK_P.getCode():
               if(this.isProhibit_P && this.isProhibitNewHand_P)
               {
                  if(PlayerManager.Instance.Self.Grade >= 25)
                  {
                     SoundManager.instance.play("003");
                     PetsBagManager.instance.show();
                  }
               }
         }
      }
      
      private function closeCurrentFrame(keyCode:uint) : void
      {
         switch(keyCode)
         {
            case KeyStroke.VK_M.getCode():
               if(this.isProhibit_M && this.isProhibitNewHand_M)
               {
                  SoundManager.instance.play("003");
                  HorseManager.instance.closeFrame();
               }
               break;
            case KeyStroke.VK_B.getCode():
               if(this.isProhibit_B && this.isProhibitNewHand_B && BagAndInfoManager.Instance.isShown)
               {
                  SoundManager.instance.play("003");
                  BagAndInfoManager.Instance.hideBagAndInfo();
               }
               break;
            case KeyStroke.VK_R.getCode():
               if(this.isProhibit_R && this.isProhibitNewHand_R && MailManager.Instance.isShow)
               {
                  SoundManager.instance.play("003");
                  MailManager.Instance.hide();
               }
               break;
            case KeyStroke.VK_H.getCode():
               if(this.isProhibit_H && SettingController.Instance.isShow)
               {
                  SoundManager.instance.play("003");
                  SettingController.Instance.hide();
               }
               break;
            case KeyStroke.VK_T.getCode():
               if(this.isProhibit_T && this.isProhibitNewHand_T && GotoPageController.Instance.isShow)
               {
                  SoundManager.instance.play("003");
                  GotoPageController.Instance.hide();
               }
               break;
            case KeyStroke.VK_Q.getCode():
               if(this.isProhibit_Q && TaskManager.instance.isShow)
               {
                  SoundManager.instance.play("003");
                  TaskManager.instance.switchVisible();
               }
               break;
            case KeyStroke.VK_S.getCode():
               break;
            case KeyStroke.VK_Q.getCode():
               if(this.isProhibit_Q && TaskManager.instance.isShow)
               {
                  SoundManager.instance.play("003");
                  TaskManager.instance.switchVisible();
               }
               break;
            case KeyStroke.VK_P.getCode():
               if(this.isProhibit_P && this.isProhibitNewHand_P && PetsBagManager.instance.isShow() && !PetsAdvancedManager.Instance.isPetsAdvancedViewShow)
               {
                  SoundManager.instance.play("003");
                  PetsBagManager.instance.hide();
               }
         }
      }
      
      private function getKeyboardShortcutsState() : void
      {
         var currentStateType:String = StateManager.currentStateType;
         switch(currentStateType)
         {
            case StateType.FIGHT_LIB_GAMEVIEW:
            case StateType.FIGHTING:
            case StateType.LODING_TRAINER:
            case StateType.LOGIN:
            case StateType.CHURCH_ROOM:
            case StateType.HOT_SPRING_ROOM:
            case StateType.COLLECTION_TASK_SCENE:
               this.isProhibit_M = false;
               this.isProhibit_B = false;
               this.isProhibit_Q = false;
               this.isProhibit_F = false;
               this.isProhibit_H = false;
               this.isProhibit_T = false;
               this.isProhibit_R = false;
               this.isProhibit_S = false;
               this.isProhibit_G = true;
               this.isProhibit_P = false;
               break;
            case StateType.AUCTION:
            case StateType.SHOP:
               this.isProhibit_M = true;
               this.isProhibit_B = false;
               this.isProhibit_Q = true;
               this.isProhibit_F = true;
               this.isProhibit_H = true;
               this.isProhibit_T = true;
               this.isProhibit_R = true;
               this.isProhibit_S = true;
               this.isProhibit_G = true;
               this.isProhibit_P = true;
               break;
            case StateType.TRAINER1:
            case StateType.TRAINER2:
               this.isProhibit_M = false;
               this.isProhibit_B = false;
               this.isProhibit_Q = false;
               this.isProhibit_F = false;
               this.isProhibit_H = true;
               this.isProhibit_T = false;
               this.isProhibit_R = false;
               this.isProhibit_S = false;
               this.isProhibit_G = false;
               this.isProhibit_P = false;
               break;
            default:
               this.isProhibit_M = true;
               this.isProhibit_B = true;
               this.isProhibit_Q = true;
               this.isProhibit_F = true;
               this.isProhibit_H = true;
               this.isProhibit_T = true;
               this.isProhibit_R = true;
               this.isProhibit_S = true;
               this.isProhibit_G = true;
               this.isProhibit_P = true;
         }
         if(PlayerManager.Instance.Self.Grade < 3)
         {
            this.isProhibit_G = false;
         }
      }
      
      public function forbiddenFull() : void
      {
         this.isFullForbid = true;
      }
      
      public function cancelForbidden() : void
      {
         this.isFullForbid = false;
      }
      
      public function forbiddenSection(type:int, state:Boolean) : void
      {
         this.isForbiddenSection = state;
         switch(type)
         {
            case GAME_PREPARE:
               this.isProhibit_M = false;
               this.isProhibit_B = false;
               this.isProhibit_Q = true;
               this.isProhibit_F = true;
               this.isProhibit_H = false;
               this.isProhibit_T = false;
               this.isProhibit_R = false;
               this.isProhibit_S = false;
               this.isProhibit_P = false;
               break;
            case GAME:
               this.isProhibit_M = false;
               this.isProhibit_B = false;
               this.isProhibit_Q = false;
               this.isProhibit_F = false;
               this.isProhibit_H = true;
               this.isProhibit_T = false;
               this.isProhibit_R = false;
               this.isProhibit_S = false;
               this.isProhibit_P = false;
               break;
            case GAME_WAIT:
               this.isProhibit_M = true;
               this.isProhibit_B = true;
               this.isProhibit_Q = true;
               this.isProhibit_F = true;
               this.isProhibit_H = true;
               this.isProhibit_T = true;
               this.isProhibit_R = true;
               this.isProhibit_S = true;
               this.isProhibit_P = true;
         }
      }
      
      public function prohibitNewHandBag(state:Boolean) : void
      {
         this.isProhibitNewHand_B = state;
      }
      
      public function prohibitNewHandFriend(state:Boolean) : void
      {
         this.isProhibitNewHand_F = state;
      }
      
      public function prohibitNewHandChannel(state:Boolean) : void
      {
         this.isProhibitNewHand_T = state;
      }
      
      public function prohibitNewHandMail(state:Boolean) : void
      {
         this.isProhibitNewHand_R = state;
      }
      
      public function prohibitNewHandCalendar(state:Boolean) : void
      {
         this.isProhibitNewHand_S = state;
      }
      
      public function prohibitNewHandSeting(state:Boolean) : void
      {
         this.isProhibitNewHand_H = state;
      }
      
      public function prohibitNewHandPetsBag(state:Boolean) : void
      {
         this.isProhibitNewHand_P = state;
      }
      
      public function prohibitNewHandTask(state:Boolean) : void
      {
         this.isProhibitNewHand_Q = state;
      }
   }
}

