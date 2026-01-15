package catchInsect.view
{
   import catchInsect.CatchInsectMananger;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import store.HelpFrame;
   
   public class CatchInsectCheckGeinFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _indivPrizeView:IndivPrizeView;
      
      private var _selfZoneView:CatchInsectRankView;
      
      private var _crossZoneView:CatchInsectRankView;
      
      private var _hBox:HBox;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _indivPrizeBtn:SelectedTextButton;
      
      private var _selfZoneBtn:SelectedTextButton;
      
      private var _crossZoneBtn:SelectedTextButton;
      
      private var _scoreImg:Bitmap;
      
      private var _txtBg:Scale9CornerImage;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _convertBtn:SimpleBitmapButton;
      
      private var _tipsTxt:FilterFrameText;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var currentIndex:int;
      
      public function CatchInsectCheckGeinFrame()
      {
         super();
         this.initView();
         this.initEvents();
         SocketManager.Instance.out.updateInsectInfo();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("catchInsect.chooseFrameTitle");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("catchInsect.checkGeinFrame.bg");
         addToContent(this._bg);
         this._indivPrizeView = new IndivPrizeView();
         PositionUtils.setPos(this._indivPrizeView,"catchInsect.viewPos");
         addToContent(this._indivPrizeView);
         this._selfZoneView = new CatchInsectRankView(0);
         PositionUtils.setPos(this._selfZoneView,"catchInsect.viewPos");
         addToContent(this._selfZoneView);
         this._selfZoneView.visible = false;
         this._crossZoneView = new CatchInsectRankView(1);
         PositionUtils.setPos(this._crossZoneView,"catchInsect.viewPos");
         addToContent(this._crossZoneView);
         this._crossZoneView.visible = false;
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("catchInsect.checkGeinFrame.hBox");
         addToContent(this._hBox);
         this._indivPrizeBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.indivPrizeBtn");
         this._hBox.addChild(this._indivPrizeBtn);
         this._indivPrizeBtn.text = LanguageMgr.GetTranslation("catchInsect.geinFrame.tab1");
         this._selfZoneBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.selfZoneBtn");
         this._hBox.addChild(this._selfZoneBtn);
         this._selfZoneBtn.text = LanguageMgr.GetTranslation("catchInsect.geinFrame.tab2");
         this._crossZoneBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.crossZoneBtn");
         this._hBox.addChild(this._crossZoneBtn);
         this._crossZoneBtn.text = LanguageMgr.GetTranslation("catchInsect.geinFrame.tab3");
         this._scoreImg = ComponentFactory.Instance.creat("catchInsect.myScore");
         addToContent(this._scoreImg);
         this._txtBg = ComponentFactory.Instance.creatComponentByStylename("catchInsect.txtBg");
         addToContent(this._txtBg);
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.scoreTxt");
         addToContent(this._scoreTxt);
         this._scoreTxt.text = "80000000";
         this._convertBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.convertBtn");
         addToContent(this._convertBtn);
         this._tipsTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.tipsTxt");
         addToContent(this._tipsTxt);
         this._tipsTxt.text = LanguageMgr.GetTranslation("catchInsect.geinFrame.tips");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("catchInsect.HelpButton");
         addToContent(this._helpBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._indivPrizeBtn);
         this._btnGroup.addSelectItem(this._selfZoneBtn);
         this._btnGroup.addSelectItem(this._crossZoneBtn);
         this._btnGroup.selectIndex = 0;
         this.currentIndex = 0;
      }
      
      private function initEvents() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._convertBtn.addEventListener(MouseEvent.CLICK,this.__convertBtnClick);
         CatchInsectMananger.instance.addEventListener(CatchInsectMananger.UPDATE_INFO,this.__updateView);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpBtnClick);
      }
      
      protected function __helpBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("catchInsect.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("catchInsect.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.changeSubmitButtonX(50);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.ringstation.helpTitle");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __updateView(event:Event) : void
      {
         var total:int = CatchInsectMananger.instance.model.score;
         var avaible:int = CatchInsectMananger.instance.model.avaibleScore;
         var prizeStatus:int = CatchInsectMananger.instance.model.prizeStatus;
         this._scoreTxt.text = avaible + "/" + total;
         this._indivPrizeView.setPrizeStatus(prizeStatus);
      }
      
      protected function __convertBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:CatchInsectShopFrame = ComponentFactory.Instance.creatCustomObject("catchInsect.shopFrame");
         frame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         frame.show();
      }
      
      protected function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:Disposeable = event.target as Disposeable;
         frame.dispose();
         frame = null;
      }
      
      protected function __changeHandler(event:Event) : void
      {
         if(this._btnGroup.selectIndex == this.currentIndex)
         {
            return;
         }
         SoundManager.instance.play("008");
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._indivPrizeView.visible = true;
               this._selfZoneView.visible = false;
               this._crossZoneView.visible = false;
               break;
            case 1:
               this._indivPrizeView.visible = false;
               this._selfZoneView.visible = true;
               this._crossZoneView.visible = false;
               SocketManager.Instance.out.updateInsectLocalRank();
               SocketManager.Instance.out.updateInsectLocalSelfInfo();
               break;
            case 2:
               this._indivPrizeView.visible = false;
               this._selfZoneView.visible = false;
               this._crossZoneView.visible = true;
               SocketManager.Instance.out.updateInsectAreaRank();
               SocketManager.Instance.out.updateInsectAreaSelfInfo();
         }
         this.currentIndex = this._btnGroup.selectIndex;
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         }
         if(Boolean(this._convertBtn))
         {
            this._convertBtn.removeEventListener(MouseEvent.CLICK,this.__convertBtnClick);
         }
         CatchInsectMananger.instance.removeEventListener(CatchInsectMananger.UPDATE_INFO,this.__updateView);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         super.dispose();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._indivPrizeView);
         this._indivPrizeView = null;
         ObjectUtils.disposeObject(this._selfZoneView);
         this._selfZoneView = null;
         ObjectUtils.disposeObject(this._crossZoneView);
         this._crossZoneView = null;
         ObjectUtils.disposeObject(this._hBox);
         this._hBox = null;
         ObjectUtils.disposeObject(this._btnGroup);
         this._btnGroup = null;
         ObjectUtils.disposeObject(this._indivPrizeBtn);
         this._indivPrizeBtn = null;
         ObjectUtils.disposeObject(this._selfZoneBtn);
         this._selfZoneBtn = null;
         ObjectUtils.disposeObject(this._crossZoneBtn);
         this._crossZoneBtn = null;
         ObjectUtils.disposeObject(this._scoreImg);
         this._scoreImg = null;
         ObjectUtils.disposeObject(this._txtBg);
         this._txtBg = null;
         ObjectUtils.disposeObject(this._scoreTxt);
         this._scoreTxt = null;
         ObjectUtils.disposeObject(this._convertBtn);
         this._convertBtn = null;
         ObjectUtils.disposeObject(this._tipsTxt);
         this._tipsTxt = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
      }
   }
}

