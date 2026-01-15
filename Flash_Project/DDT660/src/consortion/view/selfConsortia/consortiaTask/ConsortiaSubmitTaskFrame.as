package consortion.view.selfConsortia.consortiaTask
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class ConsortiaSubmitTaskFrame extends BaseAlerFrame
   {
      
      private static var RESET_MONEY:int = 500;
      
      private static var SUBMIT_RICHES:int = 5000;
      
      private var _myResetBtn:TextButton;
      
      private var _myOkBtn:TextButton;
      
      private var _itemTxtI:FilterFrameText;
      
      private var _itemTxtII:FilterFrameText;
      
      private var _itemTxtIII:FilterFrameText;
      
      public function ConsortiaSubmitTaskFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var alerInfo:AlertInfo = new AlertInfo();
         alerInfo.submitLabel = LanguageMgr.GetTranslation("consortia.task.releaseTable");
         alerInfo.title = LanguageMgr.GetTranslation("consortia.task.releasetitle");
         alerInfo.showCancel = false;
         alerInfo.showSubmit = false;
         alerInfo.enterEnable = false;
         alerInfo.escEnable = false;
         info = alerInfo;
         var bg:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTaskBG");
         this._myResetBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.reset");
         this._myOkBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.ok");
         this._myResetBtn.text = LanguageMgr.GetTranslation("consortia.task.resetTable");
         this._myOkBtn.text = LanguageMgr.GetTranslation("consortia.task.okTable");
         this._itemTxtI = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.itemTxtI");
         this._itemTxtII = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.itemTxtII");
         this._itemTxtIII = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.itemTxtIII");
         addToContent(bg);
         addToContent(this._myResetBtn);
         addToContent(this._myOkBtn);
         addToContent(this._itemTxtI);
         addToContent(this._itemTxtII);
         addToContent(this._itemTxtIII);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         ConsortionModelControl.Instance.TaskModel.addEventListener(ConsortiaTaskEvent.GETCONSORTIATASKINFO,this.__getTaskInfo);
         this._myResetBtn.addEventListener(MouseEvent.CLICK,this.__resetClick);
         this._myOkBtn.addEventListener(MouseEvent.CLICK,this.__okClick);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         ConsortionModelControl.Instance.TaskModel.removeEventListener(ConsortiaTaskEvent.GETCONSORTIATASKINFO,this.__getTaskInfo);
         this._myResetBtn.removeEventListener(MouseEvent.CLICK,this.__resetClick);
         this._myOkBtn.removeEventListener(MouseEvent.CLICK,this.__okClick);
      }
      
      private function __response(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            ObjectUtils.disposeObject(this);
         }
      }
      
      private function __resetClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.resetTable"),LanguageMgr.GetTranslation("consortia.task.resetContent"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
      }
      
      private function __okClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.SUMBIT_TASK);
      }
      
      private function _responseI(e:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < RESET_MONEY)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopItem.Money"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
               alert.addEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
            }
            else
            {
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.RESET_TASK);
            }
         }
         ObjectUtils.disposeObject(e.currentTarget as BaseAlerFrame);
      }
      
      private function __onNoMoneyResponse(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         alert.disposeChildren = true;
         alert.dispose();
         alert = null;
         if(e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __getTaskInfo(e:ConsortiaTaskEvent) : void
      {
         if(e.value == ConsortiaTaskModel.RESET_TASK)
         {
            this.taskInfo = ConsortionModelControl.Instance.TaskModel.taskInfo;
         }
         else if(e.value == ConsortiaTaskModel.SUMBIT_TASK)
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      public function set taskInfo(value:ConsortiaTaskInfo) : void
      {
         this._itemTxtI.text = "1 .  " + value.itemList[0]["content"];
         this._itemTxtII.text = "2 .  " + value.itemList[1]["content"];
         this._itemTxtIII.text = "3 .  " + value.itemList[2]["content"];
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._myResetBtn))
         {
            ObjectUtils.disposeObject(this._myResetBtn);
         }
         this._myResetBtn = null;
         if(Boolean(this._myOkBtn))
         {
            ObjectUtils.disposeObject(this._myOkBtn);
         }
         this._myOkBtn = null;
         if(Boolean(this._itemTxtI))
         {
            ObjectUtils.disposeObject(this._itemTxtI);
         }
         this._itemTxtI = null;
         if(Boolean(this._itemTxtII))
         {
            ObjectUtils.disposeObject(this._itemTxtII);
         }
         this._itemTxtII = null;
         if(Boolean(this._itemTxtIII))
         {
            ObjectUtils.disposeObject(this._itemTxtIII);
         }
         this._itemTxtIII = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

