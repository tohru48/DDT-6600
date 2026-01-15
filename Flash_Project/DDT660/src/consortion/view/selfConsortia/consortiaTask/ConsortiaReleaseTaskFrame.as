package consortion.view.selfConsortia.consortiaTask
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   
   public class ConsortiaReleaseTaskFrame extends BaseAlerFrame
   {
      
      private var _arr:Array = [3,3,5,5,8,8,10,10,12,12];
      
      private var _releaseContentTextScale9BG:Scale9CornerImage;
      
      private var _content:MovieImage;
      
      private var _levelView:ConsortiaTaskLevelView;
      
      private var _selectedLevelRecord:int;
      
      public function ConsortiaReleaseTaskFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var alerInfo:AlertInfo = new AlertInfo();
         alerInfo.submitLabel = LanguageMgr.GetTranslation("consortia.task.releaseTable");
         alerInfo.title = LanguageMgr.GetTranslation("consortia.task.releaseTable.title");
         alerInfo.showCancel = false;
         info = alerInfo;
         this._releaseContentTextScale9BG = ComponentFactory.Instance.creatComponentByStylename("consortion.releaseContentTextScale9BG");
         this._content = ComponentFactory.Instance.creatComponentByStylename("conortion.releaseContentText");
         addToContent(this._releaseContentTextScale9BG);
         addToContent(this._content);
         this._levelView = new ConsortiaTaskLevelView();
         PositionUtils.setPos(this._levelView,"consortiaTask.levelViewPos");
         addToContent(this._levelView);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(ConsortionModelControl.Instance.TaskModel.isHaveTask_noRelease)
            {
               ConsortionModelControl.Instance.TaskModel.isHaveTask_noRelease = false;
               ObjectUtils.disposeObject(this);
            }
            else
            {
               this.__okClick();
               ObjectUtils.disposeObject(this);
            }
         }
         else
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      private function __okClick() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._selectedLevelRecord = this._levelView.selectedLevel;
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.okTable"),LanguageMgr.GetTranslation("consortia.task.OKContent",ServerConfigManager.instance.MissionRiches[this._selectedLevelRecord * 2 - 1]),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _responseII(e:FrameEvent) : void
      {
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.consortiaInfo.Riches < ServerConfigManager.instance.MissionRiches[this._selectedLevelRecord * 2 - 1])
            {
               this.__openRichesTip();
            }
            else
            {
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.RELEASE_TASK,true,this._selectedLevelRecord * 2 - 1);
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.SUMBIT_TASK);
               ObjectUtils.disposeObject(this);
            }
         }
         ObjectUtils.disposeObject(e.currentTarget as BaseAlerFrame);
      }
      
      private function __openRichesTip() : void
      {
         var enoughFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortion.skillItem.click.enough1"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
         enoughFrame.addEventListener(FrameEvent.RESPONSE,this.__noEnoughHandler);
      }
      
      private function __noEnoughHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               ConsortionModelControl.Instance.alertTaxFrame();
         }
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__noEnoughHandler);
         frame.dispose();
         frame = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         this._releaseContentTextScale9BG = null;
         this._content = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._levelView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

