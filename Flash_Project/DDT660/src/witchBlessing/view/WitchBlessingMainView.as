package witchBlessing.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import witchBlessing.WitchBlessingManager;
   import witchBlessing.data.WitchBlessingModel;
   
   public class WitchBlessingMainView extends Frame implements Disposeable
   {
      
      private var _leftView:Sprite;
      
      private var _rightView:Sprite;
      
      private var _bottom:ScaleBitmapImage;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var lv1Btn:SelectedButton;
      
      private var lv2Btn:SelectedButton;
      
      private var lv3Btn:SelectedButton;
      
      private var lv1View:WitchBlessingRightView;
      
      private var lv2View:WitchBlessingRightView;
      
      private var lv3View:WitchBlessingRightView;
      
      private var titleMc:MovieClip;
      
      private var _awardsTxt:FilterFrameText;
      
      private var _takeAwayTxt:FilterFrameText;
      
      private var _timeOpenTxt:FilterFrameText;
      
      private var _doubleTimeTxt:FilterFrameText;
      
      private var _progressTxtImage:Bitmap;
      
      private var _progressBg:Bitmap;
      
      private var _progressCover:Bitmap;
      
      private var _progressTxt:FilterFrameText;
      
      private var _blessLvTxt:FilterFrameText;
      
      private var blessBtn:BaseButton;
      
      private var talkBoxMc:MovieClip;
      
      private var blessHarderBtn:BaseButton;
      
      private var _witchBlessingFrame:WitchBlessingFrame;
      
      private var itemInfo:ItemTemplateInfo;
      
      private var cell:BagCell;
      
      private var maxNumInBag:int;
      
      private var maxMoneyCount:int;
      
      private const ITEMID:int = int(ServerConfigManager.instance.getWitchBlessItemId);
      
      private const ONCE_BLESS_EXP:int = ServerConfigManager.instance.getWitchBlessGP[0];
      
      private const ONCE_HARDER_BLESS_EXP:int = ServerConfigManager.instance.getWitchBlessGP[2];
      
      private const ONCE_BLESS_MONEY:int = ServerConfigManager.instance.getWitchBlessMoney;
      
      private var expArr:Array = [0,500,1200,2200];
      
      private var awardsNums:Array = [3,3,3];
      
      private var doubleMoney:Array = [0,0,0];
      
      public var nowLv:int = 0;
      
      private var needExp:int;
      
      private var allHarderBlessMax:int;
      
      private var allBlessMax:int;
      
      private var nextLvBlessMax:int;
      
      private var nextLvHarderBlessMax:int;
      
      private var _allIn:SelectedCheckButton;
      
      public function WitchBlessingMainView()
      {
         var model:WitchBlessingModel = WitchBlessingManager.Instance.model;
         this.expArr = model.ExpArr;
         this.awardsNums = model.AwardsNums;
         this.doubleMoney = model.DoubleMoney;
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _rightViewBigBg:Bitmap = null;
         var _nextTimeBg:Bitmap = null;
         this.itemInfo = ItemManager.Instance.getTemplateById(this.ITEMID) as ItemTemplateInfo;
         this.maxNumInBag = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this.itemInfo.TemplateID);
         this.maxMoneyCount = int(PlayerManager.Instance.Self.Money / this.ONCE_BLESS_MONEY);
         this.titleText = LanguageMgr.GetTranslation("witchBlessing.view.title");
         this._leftView = new Sprite();
         this._rightView = new Sprite();
         this.lv1View = new WitchBlessingRightView(1,this.awardsNums[0],this.doubleMoney[0]);
         this.lv2View = new WitchBlessingRightView(2,this.awardsNums[1],this.doubleMoney[1]);
         this.lv3View = new WitchBlessingRightView(3,this.awardsNums[2],this.doubleMoney[2]);
         this.lv2View.visible = false;
         this.lv3View.visible = false;
         this.titleMc = ComponentFactory.Instance.creat("witchBlessing.titleMc");
         this.titleMc.gotoAndStop(1);
         PositionUtils.setPos(this.titleMc,"witchBlessing.titleMcPos");
         PositionUtils.setPos(this._leftView,"witchBlessing.leftViewPos");
         PositionUtils.setPos(this._rightView,"witchBlessing.rightViewPos");
         this._bottom = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.frameBottom");
         var _leftBg:Bitmap = ComponentFactory.Instance.creat("asset.witchBlessing.leftBg");
         var _rightBg:Bitmap = ComponentFactory.Instance.creat("asset.witchBlessing.rightBg");
         _rightViewBigBg = ComponentFactory.Instance.creat("asset.witchBlessing.rightViewBigBg");
         var _purpleBg:Bitmap = ComponentFactory.Instance.creat("asset.witchBlessing.purpleBg");
         _nextTimeBg = ComponentFactory.Instance.creat("asset.witchBlessing.nextTimeBg");
         this.lv1Btn = ComponentFactory.Instance.creatComponentByStylename("blessingLv1.btn");
         this.lv2Btn = ComponentFactory.Instance.creatComponentByStylename("blessingLv2.btn");
         this.lv3Btn = ComponentFactory.Instance.creatComponentByStylename("blessingLv3.btn");
         this._takeAwayTxt = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.takeAwayTxt");
         this._takeAwayTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.takeAwayTxt",ServerConfigManager.instance.getWitchBlessGP[1]);
         this._timeOpenTxt = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.timeOpenTxt");
         this._timeOpenTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.timeOpenTxt",WitchBlessingManager.Instance.model.activityTime);
         this._doubleTimeTxt = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.doubletimeOpenTxt");
         this._doubleTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.doubleBlessTimeTxt",ServerConfigManager.instance.getWitchBlessDoubleGpTime);
         PositionUtils.setPos(this._doubleTimeTxt,"witchBlessing.doubleTimePos");
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this.lv1Btn);
         this._btnGroup.addSelectItem(this.lv2Btn);
         this._btnGroup.addSelectItem(this.lv3Btn);
         this._btnGroup.selectIndex = 0;
         this._progressTxtImage = ComponentFactory.Instance.creatBitmap("asset.witchBlessing.progressTxt");
         this._progressBg = ComponentFactory.Instance.creatBitmap("asset.witchBlessing.progressBg");
         this._progressCover = ComponentFactory.Instance.creatBitmap("asset.witchBlessing.progress");
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.progressTxt");
         this._progressTxt.text = "0/0";
         this._blessLvTxt = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.blessingLvTxt");
         this.blessBtn = ComponentFactory.Instance.creat("witchBlessing.blessBtn");
         this.blessHarderBtn = ComponentFactory.Instance.creat("witchBlessing.blessHarderBtn");
         this._allIn = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.allIn");
         this._allIn.text = LanguageMgr.GetTranslation("ddt.pets.risingStar.tisingStarTxt");
         this._allIn.selected = true;
         this.cell = new BagCell(0,this.itemInfo,false,null,false);
         this.cell.setBgVisible(false);
         this.cell.setContentSize(62,62);
         this.cell.setCount(this.maxNumInBag);
         PositionUtils.setPos(this.cell,"witchBlessing.cellPos");
         this.talkBoxMc = ComponentFactory.Instance.creat("asset.witchBlessing.talkBoxMc");
         var talkTxt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.talkTxt");
         this.talkBoxMc.addChild(talkTxt);
         talkTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.doubleBlessing");
         this.talkBoxMc.visible = false;
         PositionUtils.setPos(this.talkBoxMc,"witchBlessing.talkBoxMcPos");
         this._leftView.addChild(_leftBg);
         this._leftView.addChild(this._timeOpenTxt);
         this._leftView.addChild(this._doubleTimeTxt);
         this._leftView.addChild(this._progressTxtImage);
         this._leftView.addChild(this._progressBg);
         this._leftView.addChild(this._progressCover);
         this._leftView.addChild(this._progressTxt);
         this._leftView.addChild(this._blessLvTxt);
         this._leftView.addChild(this._allIn);
         this._leftView.addChild(this.blessBtn);
         this._leftView.addChild(this.blessHarderBtn);
         this._leftView.addChild(this.cell);
         this._leftView.addChild(this.talkBoxMc);
         this._rightView.addChild(this.lv1Btn);
         this._rightView.addChild(this.lv2Btn);
         this._rightView.addChild(this.lv3Btn);
         this._rightView.addChild(_rightViewBigBg);
         this._rightView.addChild(_nextTimeBg);
         this._rightView.addChild(this.lv1View);
         this._rightView.addChild(this.lv2View);
         this._rightView.addChild(this.lv3View);
         this._rightView.addChild(this.titleMc);
         addToContent(this._bottom);
         addToContent(_rightBg);
         addToContent(this._leftView);
         addToContent(this._rightView);
      }
      
      public function flushData() : void
      {
         this.talkBoxMc.visible = WitchBlessingManager.Instance.model.isDouble;
         var nowExp:int = WitchBlessingManager.Instance.model.totalExp;
         var viewArr:Array = [this.lv1View,this.lv2View,this.lv3View];
         for(var i:int = 3; i > 0; i--)
         {
            if(nowExp == this.expArr[3])
            {
               this.nowLv = 3;
               this.needExp = 0;
               break;
            }
            if(nowExp < this.expArr[i] && nowExp >= this.expArr[i - 1])
            {
               this.nowLv = i - 1;
               this.needExp = this.expArr[i] - nowExp;
               break;
            }
            if(nowExp == this.expArr[0])
            {
               this.nowLv = 0;
               this.needExp = this.expArr[1];
               break;
            }
         }
         if(WitchBlessingManager.Instance.model.isDouble)
         {
            this.allHarderBlessMax = Math.ceil((this.expArr[3] - nowExp) / (this.ONCE_HARDER_BLESS_EXP * 2));
            this.allBlessMax = Math.ceil((this.expArr[3] - nowExp) / (this.ONCE_BLESS_EXP * 2));
            if(this.nowLv != 3)
            {
               this.nextLvHarderBlessMax = Math.ceil((this.expArr[this.nowLv + 1] - nowExp) / (this.ONCE_HARDER_BLESS_EXP * 2));
               this.nextLvBlessMax = Math.ceil((this.expArr[this.nowLv + 1] - nowExp) / (this.ONCE_BLESS_EXP * 2));
            }
         }
         else
         {
            this.allHarderBlessMax = Math.ceil((this.expArr[3] - nowExp) / this.ONCE_HARDER_BLESS_EXP);
            this.allBlessMax = Math.ceil((this.expArr[3] - nowExp) / this.ONCE_BLESS_EXP);
            if(this.nowLv != 3)
            {
               this.nextLvHarderBlessMax = Math.ceil((this.expArr[this.nowLv + 1] - nowExp) / this.ONCE_HARDER_BLESS_EXP);
               this.nextLvBlessMax = Math.ceil((this.expArr[this.nowLv + 1] - nowExp) / this.ONCE_BLESS_EXP);
            }
         }
         this.flushEXP(nowExp);
         this.maxNumInBag = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this.itemInfo.TemplateID);
         this.maxMoneyCount = int(PlayerManager.Instance.Self.Money / this.ONCE_BLESS_MONEY);
         this.cell.setCount(this.maxNumInBag);
         this._blessLvTxt.text = this.nowLv + "";
         this.lv1View.flushGetAwardsTimes(WitchBlessingManager.Instance.model.lv1GetAwardsTimes);
         this.lv2View.flushGetAwardsTimes(WitchBlessingManager.Instance.model.lv2GetAwardsTimes);
         this.lv3View.flushGetAwardsTimes(WitchBlessingManager.Instance.model.lv3GetAwardsTimes);
         this.lv1View.flushCDTime(WitchBlessingManager.Instance.model.lv1CD);
         this.lv2View.flushCDTime(WitchBlessingManager.Instance.model.lv2CD);
         this.lv3View.flushCDTime(WitchBlessingManager.Instance.model.lv3CD);
      }
      
      private function flushEXP(nowExp:int) : void
      {
         var curHasExp:int = 0;
         var nowLvNeedExp:int = 0;
         if(this.nowLv == 3)
         {
            this._progressTxt.text = "0/0";
            this._progressCover.scaleX = 1;
         }
         else
         {
            curHasExp = nowExp - this.expArr[this.nowLv];
            nowLvNeedExp = curHasExp + this.needExp;
            this._progressTxt.text = curHasExp + "/" + nowLvNeedExp;
            this._progressCover.scaleX = curHasExp / nowLvNeedExp;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this.lv1Btn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this.lv2Btn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this.lv3Btn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this.blessHarderBtn.addEventListener(MouseEvent.CLICK,this.__blessHarderFunc);
         this.blessBtn.addEventListener(MouseEvent.CLICK,this.__blessFunc);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         }
         if(Boolean(this.lv1Btn))
         {
            this.lv1Btn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(Boolean(this.lv2Btn))
         {
            this.lv2Btn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(Boolean(this.lv3Btn))
         {
            this.lv3Btn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(Boolean(this.blessHarderBtn))
         {
            this.blessHarderBtn.removeEventListener(MouseEvent.CLICK,this.__blessHarderFunc);
         }
         if(Boolean(this.blessBtn))
         {
            this.blessBtn.removeEventListener(MouseEvent.CLICK,this.__blessFunc);
         }
      }
      
      private function __changeHandler(event:Event) : void
      {
         var index:int = this._btnGroup.selectIndex + 1;
         this.hideRightAllView();
         this.titleMc.gotoAndStop(index);
         (this["lv" + index + "View"] as WitchBlessingRightView).visible = true;
      }
      
      private function __blessFunc(e:MouseEvent) : void
      {
         var sendNum:int = 0;
         if(this.nowLv == 3)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("witchBlessing.view.nowLvIsThree"));
            return;
         }
         if(this.maxNumInBag > 0)
         {
            sendNum = 1;
            if(this._allIn.selected)
            {
               sendNum = this.nextLvBlessMax;
            }
            SocketManager.Instance.out.sendWitchBless(sendNum);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("witchBlessing.view.youCannotBlessing"));
         }
      }
      
      private function __blessHarderFunc(e:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < this.ONCE_BLESS_MONEY)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(this.nowLv == 3)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("witchBlessing.view.nowLvIsThree"));
            return;
         }
         if(this.maxMoneyCount > 0)
         {
            this._witchBlessingFrame = new WitchBlessingFrame();
            this._witchBlessingFrame = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.WitchBlessingFrame");
            this._witchBlessingFrame.addEventListener(FrameEvent.RESPONSE,this.__framResponse);
            this._witchBlessingFrame.show(this.getNeedCount(),this.needExp,this.maxMoneyCount,this.nextLvHarderBlessMax);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("witchBlessing.view.doubleBlessingNoMoney"));
         }
      }
      
      private function __framResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this._witchBlessingFrame.dispose();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SocketManager.Instance.out.sendWitchBless(this._witchBlessingFrame.count,true);
               this._witchBlessingFrame.dispose();
         }
      }
      
      private function getNeedCount() : int
      {
         return int(this.needExp / this.ONCE_BLESS_EXP);
      }
      
      private function hideRightAllView() : void
      {
         this.lv1View.visible = false;
         this.lv2View.visible = false;
         this.lv3View.visible = false;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
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
      
      private function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      override public function dispose() : void
      {
         SocketManager.Instance.out.witchBlessing_enter(1);
         super.dispose();
         this.removeEvent();
         this.lv1View.dispose();
         this.lv2View.dispose();
         this.lv3View.dispose();
         ObjectUtils.disposeAllChildren(this);
         WitchBlessingManager.Instance.hide();
         if(Boolean(this._leftView))
         {
            this._leftView = null;
         }
         if(Boolean(this._rightView))
         {
            this._rightView = null;
         }
         if(Boolean(this._bottom))
         {
            this._bottom = null;
         }
         if(Boolean(this._btnGroup))
         {
            this._btnGroup = null;
         }
         if(Boolean(this.lv1Btn))
         {
            this.lv1Btn = null;
         }
         if(Boolean(this.lv2Btn))
         {
            this.lv2Btn = null;
         }
         if(Boolean(this.lv3Btn))
         {
            this.lv3Btn = null;
         }
         if(Boolean(this.lv1View))
         {
            this.lv1View = null;
         }
         if(Boolean(this.lv2View))
         {
            this.lv2View = null;
         }
         if(Boolean(this.lv3View))
         {
            this.lv3View = null;
         }
         if(Boolean(this.titleMc))
         {
            this.titleMc = null;
         }
         if(Boolean(this._awardsTxt))
         {
            this._awardsTxt = null;
         }
         if(Boolean(this._takeAwayTxt))
         {
            this._takeAwayTxt = null;
         }
         if(Boolean(this._timeOpenTxt))
         {
            this._timeOpenTxt = null;
         }
         if(Boolean(this._doubleTimeTxt))
         {
            this._doubleTimeTxt = null;
         }
         if(Boolean(this._progressTxtImage))
         {
            this._progressTxtImage = null;
         }
         if(Boolean(this._progressBg))
         {
            this._progressBg = null;
         }
         if(Boolean(this._progressCover))
         {
            this._progressCover = null;
         }
         if(Boolean(this._progressTxt))
         {
            this._progressTxt = null;
         }
         if(Boolean(this._blessLvTxt))
         {
            this._blessLvTxt = null;
         }
         if(Boolean(this.blessBtn))
         {
            this.blessBtn = null;
         }
         if(Boolean(this.talkBoxMc))
         {
            this.talkBoxMc = null;
         }
         if(Boolean(this.blessHarderBtn))
         {
            this.blessHarderBtn = null;
         }
         if(Boolean(this._witchBlessingFrame) && Boolean(this._witchBlessingFrame.parent))
         {
            this._witchBlessingFrame.parent.removeChild(this._witchBlessingFrame);
            this._witchBlessingFrame = null;
         }
         if(Boolean(this.itemInfo))
         {
            this.itemInfo = null;
         }
         if(Boolean(this.cell))
         {
            this.cell = null;
         }
      }
   }
}

