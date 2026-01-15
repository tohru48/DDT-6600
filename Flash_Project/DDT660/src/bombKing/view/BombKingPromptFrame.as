package bombKing.view
{
   import bombKing.BombKingManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   public class BombKingPromptFrame extends BaseAlerFrame
   {
      
      private var _bmpNpc:Bitmap;
      
      private var _bmpTxt:Bitmap;
      
      public function BombKingPromptFrame()
      {
         super();
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.initView();
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            BombKingManager.instance.onShow();
         }
         this.dispose();
      }
      
      private function initView() : void
      {
         info = new AlertInfo();
         _info.moveEnable = false;
         _info.autoButtonGape = false;
         _info.submitLabel = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         _info.customPos = ComponentFactory.Instance.creatCustomObject("trainer.bombKing.posBtn");
         this._bmpNpc = ComponentFactory.Instance.creatBitmap("asset.trainer.welcome.girl2");
         PositionUtils.setPos(this._bmpNpc,"league.LeagueStartNoticeView.girlPos");
         addToContent(this._bmpNpc);
         this._bmpTxt = ComponentFactory.Instance.creatBitmap("asset.bombKing.bombKingNotice");
         addToContent(this._bmpTxt);
         ChatManager.Instance.releaseFocus();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._bmpTxt = null;
         this._bmpNpc = null;
      }
      
      public function show() : void
      {
         var pos:Point = null;
         pos = ComponentFactory.Instance.creatCustomObject("trainer.posLeagueStart");
         x = pos.x;
         y = pos.y;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

