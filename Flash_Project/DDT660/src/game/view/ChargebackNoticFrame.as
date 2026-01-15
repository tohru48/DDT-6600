package game.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ChargebackNoticFrame extends Frame
   {
      
      private var okBtn:SimpleBitmapButton;
      
      private var cancelBtn:SimpleBitmapButton;
      
      private var bg:Bitmap;
      
      private var player_name:GradientText;
      
      private var place:int;
      
      public function ChargebackNoticFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this.okBtn.addEventListener(MouseEvent.CLICK,this.onClickOK);
         this.cancelBtn.addEventListener(MouseEvent.CLICK,this.onClickCancel);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this.okBtn.removeEventListener(MouseEvent.CLICK,this.onClickOK);
         this.cancelBtn.removeEventListener(MouseEvent.CLICK,this.onClickCancel);
      }
      
      private function onFrameResponse(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      private function onClickOK(evt:MouseEvent) : void
      {
         if(this.place == -1)
         {
            this.dispose();
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            this.dispose();
            BaglockedManager.Instance.show();
            return;
         }
         GameInSocketOut.sendGameRoomKick(this.place);
         this.dispose();
      }
      
      private function onClickCancel(evt:MouseEvent) : void
      {
         this.dispose();
      }
      
      private function initView() : void
      {
         super.init();
         this.okBtn = ComponentFactory.Instance.creat("game.chargebackNotic.ok");
         this.cancelBtn = ComponentFactory.Instance.creat("game.chargebackNotic.cancel");
         this.bg = ComponentFactory.Instance.creatBitmap("asset.room.chargebackNotic.bg");
         this.player_name = ComponentFactory.Instance.creatComponentByStylename("game.chargebackNotic.name");
         addToContent(this.bg);
         addToContent(this.okBtn);
         addToContent(this.cancelBtn);
         addToContent(this.player_name);
         this.escEnable = true;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this.okBtn);
         this.okBtn = null;
         ObjectUtils.disposeObject(this.cancelBtn);
         this.cancelBtn = null;
         ObjectUtils.disposeObject(this.bg);
         this.bg = null;
         ObjectUtils.disposeObject(this.player_name);
         this.player_name = null;
         super.dispose();
      }
      
      public function ShowModal(_place:int = -1) : void
      {
         this.place = _place;
         this.player_name.text = PlayerManager.Instance.Self.NickName;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

