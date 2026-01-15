package trainer.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.geom.Point;
   import trainer.controller.NewHandGuideManager;
   
   public class WelcomeView extends BaseAlerFrame
   {
      
      private var _bmpTxt:FilterFrameText;
      
      private var _bmpTxt1:FilterFrameText;
      
      private var _bmpNpc:Bitmap;
      
      private var _txtName:FilterFrameText;
      
      public function WelcomeView()
      {
         super();
         this.initView();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bmpTxt = null;
         this._bmpTxt1 = null;
         this._bmpNpc = null;
         this._txtName = null;
         super.dispose();
      }
      
      private function initView() : void
      {
         info = new AlertInfo();
         _info.showCancel = false;
         _info.moveEnable = false;
         _info.autoButtonGape = false;
         _info.submitLabel = LanguageMgr.GetTranslation("ok");
         _info.customPos = ComponentFactory.Instance.creatCustomObject("trainer.welcome.mainFrame.okBtn.pos");
         this._bmpNpc = ComponentFactory.Instance.creat("asset.trainer.welcome.girl2");
         addToContent(this._bmpNpc);
         this._bmpTxt = ComponentFactory.Instance.creatComponentByStylename("trainer.welcome.conentText");
         this._bmpTxt.text = LanguageMgr.GetTranslation("trainer.welcome.conentText.text");
         addToContent(this._bmpTxt);
         this._bmpTxt1 = ComponentFactory.Instance.creatComponentByStylename("trainer.welcome.conentText1");
         this._bmpTxt1.text = LanguageMgr.GetTranslation("trainer.welcome.conentText.text1");
         addToContent(this._bmpTxt1);
         this._txtName = ComponentFactory.Instance.creat("trainer.welcome.name");
         this._txtName.text = PlayerManager.Instance.Self.NickName;
         addToContent(this._txtName);
         ChatManager.Instance.releaseFocus();
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            SoundManager.instance.play("008");
            NewHandGuideManager.Instance.mapID = 111;
            SocketManager.Instance.out.createUserGuide();
         }
      }
      
      public function show() : void
      {
         var pos:Point = null;
         pos = ComponentFactory.Instance.creatCustomObject("trainer.posWelcome");
         x = pos.x;
         y = pos.y;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

