package cardSystem.view.cardCollect
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class CardCollectView extends Frame implements Disposeable
   {
      
      private var _bigBG:ScaleBitmapImage;
      
      private var _BG:MutipleImage;
      
      private var _collectBag:CollectBagView;
      
      private var _preview:CollectPreview;
      
      private var _bg1:MutipleImage;
      
      public function CardCollectView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         titleText = LanguageMgr.GetTranslation("ddt.cardSystem.cardCollectView.title");
         this._bigBG = ComponentFactory.Instance.creatComponentByStylename("cardCollectView.BG");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("cardCollectView.BG1");
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("CollectPreview.BG2");
         this._preview = ComponentFactory.Instance.creatCustomObject("CollectPreview");
         this._collectBag = ComponentFactory.Instance.creatCustomObject("collectBagView");
         addToContent(this._bigBG);
         addToContent(this._BG);
         addToContent(this._bg1);
         addToContent(this._collectBag);
         addToContent(this._preview);
         this.__selectedHandler(null);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._collectBag.addEventListener(CollectBagView.SELECT,this.__selectedHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._collectBag.removeEventListener(CollectBagView.SELECT,this.__selectedHandler);
      }
      
      protected function __selectedHandler(event:Event) : void
      {
         this._preview.info = this._collectBag.currentItemSetsInfo;
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._BG = null;
         this._bg1 = null;
         this._bigBG = null;
         this._collectBag = null;
         this._preview = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

