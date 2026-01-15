package bombKing.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   
   public class BombKingPrizeFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _desBg:Bitmap;
      
      private var _desTxt1:FilterFrameText;
      
      private var _desTxt2:FilterFrameText;
      
      private var _desTxt3:FilterFrameText;
      
      private var _NO1Img:Image;
      
      private var _NO2Img:Image;
      
      private var _NO3Img:Image;
      
      private var _otherImg:Image;
      
      public function BombKingPrizeFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("bombKing.prizes");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeFrame.bg");
         addToContent(this._bg);
         this._desBg = ComponentFactory.Instance.creat("bombKing.prizeDesBg");
         addToContent(this._desBg);
         this._desTxt1 = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeFrame.desTxt");
         PositionUtils.setPos(this._desTxt1,"bombKing.prizeFrame.desTxt1");
         addToContent(this._desTxt1);
         this._desTxt1.text = LanguageMgr.GetTranslation("bombKing.desTxt1");
         this._desTxt2 = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeFrame.desTxt2");
         PositionUtils.setPos(this._desTxt2,"bombKing.prizeFrame.desTxt2");
         addToContent(this._desTxt2);
         this._desTxt2.text = LanguageMgr.GetTranslation("bombKing.desTxt2");
         this._desTxt3 = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeFrame.desTxt2");
         PositionUtils.setPos(this._desTxt3,"bombKing.prizeFrame.desTxt3");
         addToContent(this._desTxt3);
         this._desTxt3.text = LanguageMgr.GetTranslation("bombKing.desTxt3");
         this._NO1Img = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeFrame.NO1");
         addToContent(this._NO1Img);
         this._NO1Img.tipData = 1;
         this._NO2Img = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeFrame.NO2");
         addToContent(this._NO2Img);
         this._NO2Img.tipData = 2;
         this._NO3Img = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeFrame.NO3");
         addToContent(this._NO3Img);
         this._NO3Img.tipData = 3;
         this._otherImg = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeFrame.Other");
         addToContent(this._otherImg);
         this._otherImg.tipData = 0;
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._desBg);
         this._desBg = null;
         ObjectUtils.disposeObject(this._desTxt1);
         this._desTxt1 = null;
         ObjectUtils.disposeObject(this._desTxt2);
         this._desTxt2 = null;
         ObjectUtils.disposeObject(this._desTxt3);
         this._desTxt3 = null;
         ObjectUtils.disposeObject(this._NO1Img);
         this._NO1Img = null;
         ObjectUtils.disposeObject(this._NO2Img);
         this._NO2Img = null;
         ObjectUtils.disposeObject(this._NO3Img);
         this._NO3Img = null;
         ObjectUtils.disposeObject(this._otherImg);
         this._otherImg = null;
         super.dispose();
      }
   }
}

