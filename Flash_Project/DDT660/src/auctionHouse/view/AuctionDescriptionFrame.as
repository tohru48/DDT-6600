package auctionHouse.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AuctionDescriptionFrame extends Frame
   {
      
      private var _view:Sprite;
      
      private var _submitButton:TextButton;
      
      public function AuctionDescriptionFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._view = new Sprite();
         titleText = LanguageMgr.GetTranslation("ddt.auctionHouse.notesTitle");
         var bg:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("ddtauction.HelpFrame.FrameBg");
         this._view.addChild(bg);
         var textBitmap:MovieImage = ComponentFactory.Instance.creatComponentByStylename("asset.ddtauctionHouse.NotesContent");
         this._view.addChild(textBitmap);
         this._submitButton = ComponentFactory.Instance.creat("auctionHouse.NotesFrameEnter");
         this._submitButton.text = LanguageMgr.GetTranslation("ok");
         this._view.addChild(this._submitButton);
         addToContent(this._view);
         enterEnable = true;
         escEnable = true;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.addEventListener(MouseEvent.CLICK,this._submit);
      }
      
      private function _submit(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.close();
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.removeEventListener(MouseEvent.CLICK,this._submit);
         ObjectUtils.disposeObject(this._view);
         ObjectUtils.disposeObject(this);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._submitButton))
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this._submit);
            ObjectUtils.disposeObject(this._submitButton);
         }
         this._submitButton = null;
         if(Boolean(this._view))
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

