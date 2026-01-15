package room.transnational
{
   import com.pickgliss.action.BaseAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import ddt.constants.CacheConsts;
   import ddt.manager.LanguageMgr;
   
   public class SnapAction extends BaseAction
   {
      
      private var title:String;
      
      private var msg:String;
      
      private var submitLabel:String = "";
      
      private var cancelLabel:String = "";
      
      private var autoDispose:Boolean = false;
      
      private var enableHtml:Boolean = false;
      
      private var multiLine:Boolean = false;
      
      private var blockBackgound:int = 0;
      
      private var cacheFlag:String = null;
      
      private var frameStyle:String = "SimpleAlert";
      
      private var buttonGape:int = 30;
      
      private var autoButtonGape:Boolean = true;
      
      private var type:int = 0;
      
      private var __enterConsortiaConfirm:Function;
      
      public function SnapAction(callback:Function, title:String, msg:String, submitLabel:String = "", cancelLabel:String = "", autoDispose:Boolean = false, enableHtml:Boolean = false, multiLine:Boolean = false, blockBackgound:int = 0, cacheFlag:String = null, frameStyle:String = "SimpleAlert", buttonGape:int = 30, autoButtonGape:Boolean = true, type:int = 0)
      {
         this.__enterConsortiaConfirm = callback;
         this.title = title;
         this.msg = msg;
         this.submitLabel = submitLabel;
         this.cancelLabel = cancelLabel;
         this.autoDispose = autoDispose;
         this.enableHtml = enableHtml;
         this.multiLine = multiLine;
         this.blockBackgound = blockBackgound;
         this.cacheFlag = cacheFlag;
         this.frameStyle = frameStyle;
         this.buttonGape = buttonGape;
         this.autoButtonGape = autoButtonGape;
         this.type = type;
         super();
      }
      
      override public function act() : void
      {
         var _enterConfirm:SimpleAlert = null;
         _enterConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.manager.PlayerManager.request"),this.msg,LanguageMgr.GetTranslation("tank.manager.PlayerManager.sure"),LanguageMgr.GetTranslation("tank.manager.PlayerManager.refuse"),false,true,true,LayerManager.ALPHA_BLOCKGOUND,CacheConsts.ALERT_IN_FIGHT) as SimpleAlert;
         _enterConfirm.addEventListener(FrameEvent.RESPONSE,this.__enterConsortiaConfirm);
      }
   }
}

