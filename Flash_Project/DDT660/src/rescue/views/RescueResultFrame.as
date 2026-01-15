package rescue.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import hall.hallInfo.playerInfo.ImgNumConverter;
   import rescue.data.RescueResultInfo;
   
   public class RescueResultFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _sceneImg:Bitmap;
      
      private var _scoreContainer:Sprite;
      
      private var _scoreTxt:Sprite;
      
      private var _hbox:HBox;
      
      private var _star:Bitmap;
      
      private var _winOrClose:Bitmap;
      
      private var _submitBtn:TextButton;
      
      public function RescueResultFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("rescue.resultFrameTitle");
         this._bg = ComponentFactory.Instance.creat("rescue.result.bg");
         addToContent(this._bg);
         this._submitBtn = ComponentFactory.Instance.creat("ddtstore.HelpFrame.EnterBtn");
         PositionUtils.setPos(this._submitBtn,"rescue.result.submitBtnPos");
         this._submitBtn.text = LanguageMgr.GetTranslation("ok");
         addToContent(this._submitBtn);
         this._scoreContainer = new Sprite();
         this._scoreContainer.graphics.beginFill(0,0);
         this._scoreContainer.graphics.drawRect(0,0,110,35);
         this._scoreContainer.graphics.endFill();
         addToContent(this._scoreContainer);
         PositionUtils.setPos(this._scoreContainer,"rescue.result.scorePos");
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._submitBtn.addEventListener(MouseEvent.CLICK,this.__submitBtnClick);
      }
      
      protected function __submitBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      public function setData(info:RescueResultInfo) : void
      {
         this._sceneImg = ComponentFactory.Instance.creat("rescue.scene" + info.sceneId);
         PositionUtils.setPos(this._sceneImg,"rescue.result.scenePos");
         addToContent(this._sceneImg);
         this._scoreTxt = ImgNumConverter.instance.convertToImg(info.score,"rescue.result.num",17);
         this._scoreContainer.addChild(this._scoreTxt);
         this._scoreTxt.x = (this._scoreContainer.width - this._scoreTxt.width) / 2;
         this._hbox = ComponentFactory.Instance.creatComponentByStylename("rescue.result.starHBox");
         addToContent(this._hbox);
         for(var i:int = 1; i <= info.star; i++)
         {
            this._star = ComponentFactory.Instance.creat("rescue.star");
            this._hbox.addChild(this._star);
         }
         this._hbox.refreshChildPos();
         if(info.isWin)
         {
            this._winOrClose = ComponentFactory.Instance.creat("asset.experience.rightViewWin");
         }
         else
         {
            this._winOrClose = ComponentFactory.Instance.creat("asset.experience.rightViewLose");
         }
         PositionUtils.setPos(this._winOrClose,"rescue.result.winOrLosePos");
         addToContent(this._winOrClose);
         this._winOrClose.scaleX = 0.8;
         this._winOrClose.scaleY = 0.8;
         this._winOrClose.smoothing = true;
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._submitBtn.removeEventListener(MouseEvent.CLICK,this.__submitBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._sceneImg);
         this._sceneImg = null;
         ObjectUtils.disposeObject(this._scoreContainer);
         this._scoreContainer = null;
         ObjectUtils.disposeObject(this._scoreTxt);
         this._scoreTxt = null;
         ObjectUtils.disposeObject(this._hbox);
         this._hbox = null;
         ObjectUtils.disposeObject(this._star);
         this._star = null;
         ObjectUtils.disposeObject(this._winOrClose);
         this._winOrClose = null;
         ObjectUtils.disposeObject(this._submitBtn);
         this._submitBtn = null;
         super.dispose();
      }
   }
}

