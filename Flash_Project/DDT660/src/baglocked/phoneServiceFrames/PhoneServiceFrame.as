package baglocked.phoneServiceFrames
{
   import baglocked.BagLockedController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PhoneServiceFrame extends Frame
   {
      
      public static const TYPE_SERVICE:int = 0;
      
      public static const TYPE_CHANGE:int = 1;
      
      public static const TYPE_DELETE:int = 2;
      
      private var _bagLockedController:BagLockedController;
      
      private var _BG:ScaleBitmapImage;
      
      private var _checkBtn1:SelectedCheckButton;
      
      private var _checkBtn2:SelectedCheckButton;
      
      private var _nextBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _selectedGroup:SelectedButtonGroup;
      
      private var type:int;
      
      public function PhoneServiceFrame()
      {
         super();
      }
      
      public function init2(type:int) : void
      {
         this.type = type;
         this._BG = ComponentFactory.Instance.creatComponentByStylename("baglocked.phoneServiceBG");
         addToContent(this._BG);
         this._checkBtn1 = ComponentFactory.Instance.creatComponentByStylename("baglocked.changePhone");
         addToContent(this._checkBtn1);
         this._checkBtn2 = ComponentFactory.Instance.creatComponentByStylename("baglocked.deleteQuestion");
         addToContent(this._checkBtn2);
         switch(type)
         {
            case TYPE_SERVICE:
               this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.phoneService");
               this._checkBtn1.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.changePhoneTxt");
               this._checkBtn2.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.deleteQuestionTxt");
               break;
            case TYPE_CHANGE:
               this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.changePhoneTxt");
               this._checkBtn1.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.changeByPhoneNum");
               this._checkBtn2.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.changeByQuestion");
               break;
            case TYPE_DELETE:
               this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.deletePwdTxt");
               this._checkBtn1.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.deletePwdByPhone");
               this._checkBtn2.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.deletePwdByQuestion");
         }
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._nextBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.next");
         PositionUtils.setPos(this._nextBtn,"bagLocked.nextBtnPos");
         addToContent(this._nextBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         PositionUtils.setPos(this._cancelBtn,"bagLocked.cancelBtnPos");
         addToContent(this._cancelBtn);
         this._selectedGroup = new SelectedButtonGroup();
         this._selectedGroup.addSelectItem(this._checkBtn1);
         this._selectedGroup.addSelectItem(this._checkBtn2);
         this._selectedGroup.selectIndex = 0;
         if(type == TYPE_DELETE)
         {
            this._checkBtn1.visible = false;
            this._selectedGroup.selectIndex = 1;
            this._checkBtn2.y = 57;
         }
         this.addEvent();
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._bagLockedController.close();
         }
      }
      
      public function set bagLockedController(value:BagLockedController) : void
      {
         this._bagLockedController = value;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __nextBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(this.type)
         {
            case TYPE_SERVICE:
               switch(this._selectedGroup.selectIndex)
               {
                  case 0:
                     this._bagLockedController.close();
                     this._bagLockedController.openChangePhoneFrame();
                     break;
                  case 1:
                     if(PlayerManager.Instance.Self.questionOne == "")
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.haveNoQuestion"));
                     }
                     else
                     {
                        SocketManager.Instance.out.deletePwdQuestion(0);
                     }
               }
               break;
            case TYPE_CHANGE:
               switch(this._selectedGroup.selectIndex)
               {
                  case 0:
                     SocketManager.Instance.out.getBackLockPwdByPhone(0);
                     break;
                  case 1:
                     if(PlayerManager.Instance.Self.questionOne == "")
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.haveNoQuestion"));
                     }
                     else
                     {
                        SocketManager.Instance.out.getBackLockPwdByQuestion(0);
                     }
               }
               break;
            case TYPE_DELETE:
               switch(this._selectedGroup.selectIndex)
               {
                  case 0:
                     SocketManager.Instance.out.deletePwdByPhone(0);
                     break;
                  case 1:
                     if(PlayerManager.Instance.Self.leftTimes > 0)
                     {
                        this._bagLockedController.close();
                        this._bagLockedController.openDelPassFrame();
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.tryTomorrow"));
                     }
               }
         }
      }
      
      protected function __itemClick(event:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function __cancelBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._bagLockedController.close();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._checkBtn1.addEventListener(Event.CHANGE,this.__itemClick);
         this._checkBtn2.addEventListener(Event.CHANGE,this.__itemClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextBtnClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelBtnClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._checkBtn1.removeEventListener(Event.CHANGE,this.__itemClick);
         this._checkBtn2.removeEventListener(Event.CHANGE,this.__itemClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__nextBtnClick);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._checkBtn1))
         {
            ObjectUtils.disposeObject(this._checkBtn1);
         }
         this._checkBtn1 = null;
         if(Boolean(this._checkBtn2))
         {
            ObjectUtils.disposeObject(this._checkBtn2);
         }
         this._checkBtn2 = null;
         if(Boolean(this._nextBtn))
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         if(Boolean(this._cancelBtn))
         {
            ObjectUtils.disposeObject(this._cancelBtn);
         }
         this._cancelBtn = null;
         super.dispose();
      }
   }
}

