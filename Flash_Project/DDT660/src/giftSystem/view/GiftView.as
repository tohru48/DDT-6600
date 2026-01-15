package giftSystem.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class GiftView extends Sprite implements Disposeable
   {
      
      private var _giftInfoView:GiftInfoView;
      
      private var _giftShopView:GiftShopView;
      
      private var _helpBtn:BaseButton;
      
      private var _info:PlayerInfo;
      
      private var _helpFrame:Frame;
      
      private var _okBtn:TextButton;
      
      private var _content:MovieImage;
      
      private var _bg:Scale9CornerImage;
      
      public function GiftView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set info(value:PlayerInfo) : void
      {
         if(this._info == value)
         {
            return;
         }
         this._info = value;
         this._giftInfoView.info = this._info;
      }
      
      private function initView() : void
      {
         this._giftInfoView = ComponentFactory.Instance.creatCustomObject("giftInfoView");
         this._giftShopView = ComponentFactory.Instance.creatCustomObject("giftShopView");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("GiftView.helpBtn");
         addChild(this._giftInfoView);
         addChild(this._giftShopView);
         addChild(this._helpBtn);
      }
      
      private function initEvent() : void
      {
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__openHelpFrame);
      }
      
      private function removeEvent() : void
      {
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__openHelpFrame);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._giftInfoView))
         {
            this._giftInfoView.dispose();
         }
         this._giftInfoView = null;
         if(Boolean(this._giftShopView))
         {
            this._giftShopView.dispose();
         }
         this._giftShopView = null;
         if(Boolean(this._helpBtn))
         {
            ObjectUtils.disposeObject(this._helpBtn);
         }
         this._helpBtn = null;
         if(Boolean(this._helpFrame))
         {
            this._okBtn.removeEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._helpFrame.dispose();
            if(Boolean(this._okBtn))
            {
               ObjectUtils.disposeObject(this._okBtn);
            }
            this._okBtn = null;
            if(Boolean(this._content))
            {
               ObjectUtils.disposeObject(this._content);
            }
            this._content = null;
            this._helpFrame = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __openHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._helpFrame == null)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("GiftView.helpFrame");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtgiftSystem.help.BG1");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("GiftView.helpFrame.OK");
            this._content = ComponentFactory.Instance.creatComponentByStylename("ddtgiftSystem.help.txt");
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("ddt.giftSystem.giftView.helpFrameTitle");
            this._helpFrame.addToContent(this._okBtn);
            this._helpFrame.addToContent(this._bg);
            this._helpFrame.addToContent(this._content);
            this._okBtn.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      protected function __helpFrameRespose(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      protected function __closeHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
   }
}

