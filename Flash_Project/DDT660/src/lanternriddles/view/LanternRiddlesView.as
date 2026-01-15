package lanternriddles.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import lanternriddles.LanternRiddlesManager;
   import lanternriddles.data.LanternAwardInfo;
   import lanternriddles.data.LanternInfo;
   import lanternriddles.event.LanternEvent;
   import road7th.comm.PackageIn;
   
   public class LanternRiddlesView extends Frame
   {
      
      private static var RANK_NUM:int = 8;
      
      private var _bg:Bitmap;
      
      private var _questionView:QuestionView;
      
      private var _doubleBtn:BaseButton;
      
      private var _hitBtn:BaseButton;
      
      private var _freeDouble:FilterFrameText;
      
      private var _freeHit:FilterFrameText;
      
      private var _careInfo:FilterFrameText;
      
      private var _questionNum:FilterFrameText;
      
      private var _myRank:FilterFrameText;
      
      private var _myInteger:FilterFrameText;
      
      private var _rankVec:Vector.<LanternRankItem>;
      
      private var _offY:int = 40;
      
      private var _doubleFreeCount:int;
      
      private var _hitFreeCount:int;
      
      private var _doublePrice:int;
      
      private var _hitPrice:int;
      
      private var _hitFlag:Boolean;
      
      private var _alertAsk:LanternAlertView;
      
      public function LanternRiddlesView()
      {
         super();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("lanternRiddles.view.Title");
         this._bg = ComponentFactory.Instance.creat("lantern.view.bg");
         addToContent(this._bg);
         this._questionView = new QuestionView();
         addToContent(this._questionView);
         this._doubleBtn = ComponentFactory.Instance.creat("lantern.view.doubleBtn");
         addToContent(this._doubleBtn);
         this._freeDouble = ComponentFactory.Instance.creatComponentByStylename("lantern.view.freeDouble");
         this._doubleBtn.addChild(this._freeDouble);
         this._hitBtn = ComponentFactory.Instance.creat("lantern.view.hitBtn");
         addToContent(this._hitBtn);
         this._freeHit = ComponentFactory.Instance.creatComponentByStylename("lantern.view.freeHit");
         this._hitBtn.addChild(this._freeHit);
         this._careInfo = ComponentFactory.Instance.creatComponentByStylename("lantern.view.careInfo");
         this._careInfo.text = LanguageMgr.GetTranslation("lanternRiddles.view.careInfoText");
         addToContent(this._careInfo);
         this._questionNum = ComponentFactory.Instance.creatComponentByStylename("lantern.view.questionNum");
         addToContent(this._questionNum);
         this._myRank = ComponentFactory.Instance.creatComponentByStylename("lantern.view.rank");
         addToContent(this._myRank);
         this._myInteger = ComponentFactory.Instance.creatComponentByStylename("lantern.view.integer");
         addToContent(this._myInteger);
         this._rankVec = new Vector.<LanternRankItem>();
         this.addRankView();
      }
      
      private function addRankView() : void
      {
         var rank:LanternRankItem = null;
         var i:int = 0;
         for(i = 0; i < RANK_NUM; i++)
         {
            rank = new LanternRankItem();
            rank.buttonMode = true;
            PositionUtils.setPos(rank,"lantern.view.rankPos");
            rank.y += i * this._offY;
            addToContent(rank);
            this._rankVec.push(rank);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._doubleBtn.addEventListener(MouseEvent.CLICK,this._onDoubleBtnClick);
         this._hitBtn.addEventListener(MouseEvent.CLICK,this.__onHitBtnClick);
         LanternRiddlesManager.instance.addEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_QUESTION,this.__onSetQuestionInfo);
         LanternRiddlesManager.instance.addEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_RANKINFO,this.__onSetRankInfo);
         LanternRiddlesManager.instance.addEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_SKILL,this.__onSetBtnEnable);
      }
      
      protected function __onSetBtnEnable(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var flag:Boolean = pkg.readBoolean();
         if(this._hitFlag)
         {
            this._questionView.setSelectBtnEnable(false);
            this._hitBtn.enable = !flag;
         }
         else
         {
            this._doubleBtn.enable = !flag;
         }
      }
      
      protected function __onSetQuestionInfo(event:CrazyTankSocketEvent) : void
      {
         var endDate:Date = null;
         var integer:int = 0;
         var rightNum:int = 0;
         var option:int = 0;
         var hitFlag:Boolean = false;
         var doubleFlag:Boolean = false;
         var pkg:PackageIn = event.pkg;
         var index:int = pkg.readInt();
         var questionID:int = pkg.readInt();
         var info:LanternInfo = LanternRiddlesManager.instance.info[questionID];
         if(Boolean(info))
         {
            this._questionView.count = pkg.readInt();
            endDate = pkg.readDate();
            this._doubleFreeCount = pkg.readInt();
            this._doublePrice = pkg.readInt();
            this._hitFreeCount = pkg.readInt();
            this._hitPrice = pkg.readInt();
            integer = pkg.readInt();
            rightNum = pkg.readInt();
            option = pkg.readInt();
            hitFlag = pkg.readBoolean();
            doubleFlag = pkg.readBoolean();
            info.QuestionIndex = index;
            info.QuestionID = questionID;
            info.Option = option;
            info.EndDate = endDate;
            this._questionView.setSelectBtnEnable(true);
            this._questionView.info = info;
            this._freeDouble.text = LanguageMgr.GetTranslation("lanternRiddles.view.freeText",this._doubleFreeCount);
            this._freeHit.text = LanguageMgr.GetTranslation("lanternRiddles.view.freeText",this._hitFreeCount);
            this._myInteger.text = integer.toString();
            this._questionNum.text = LanguageMgr.GetTranslation("lanternRiddles.view.questionNumText",rightNum);
            if(this._questionView.countDownTime > 0)
            {
               this._doubleBtn.enable = !doubleFlag;
               this._hitBtn.enable = !hitFlag;
               if(!this._hitBtn.enable)
               {
                  this._questionView.setSelectBtnEnable(false);
               }
            }
            else
            {
               this._questionView.setSelectBtnEnable(false);
               this._doubleBtn.enable = false;
               this._hitBtn.enable = false;
            }
            SocketManager.Instance.out.sendLanternRiddlesRankInfo();
            if(Boolean(this._alertAsk))
            {
               this._alertAsk.dispose();
               this._alertAsk = null;
            }
         }
      }
      
      protected function __onSetRankInfo(event:CrazyTankSocketEvent) : void
      {
         var rankInfo:LanternInfo = null;
         var awardNum:int = 0;
         var j:int = 0;
         var awardInfo:LanternAwardInfo = null;
         var pkg:PackageIn = event.pkg;
         var infoArray:Array = [];
         this._myRank.text = String(pkg.readInt());
         var length:int = pkg.readInt();
         for(var i:int = 0; i < length; i++)
         {
            rankInfo = new LanternInfo();
            rankInfo.Rank = pkg.readInt();
            rankInfo.NickName = pkg.readUTF();
            rankInfo.TypeVIP = pkg.readByte();
            rankInfo.Integer = pkg.readInt();
            awardNum = pkg.readInt();
            for(j = 0; j < awardNum; j++)
            {
               awardInfo = new LanternAwardInfo();
               awardInfo.TempId = pkg.readInt();
               awardInfo.AwardNum = pkg.readInt();
               awardInfo.IsBind = pkg.readBoolean();
               awardInfo.ValidDate = pkg.readInt();
               rankInfo.AwardInfoVec.push(awardInfo);
            }
            infoArray.push(rankInfo);
         }
         infoArray.sortOn("Rank",Array.NUMERIC);
         for(var m:int = 0; m < infoArray.length; m++)
         {
            this._rankVec[m].info = infoArray[m];
         }
      }
      
      protected function _onDoubleBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._hitFlag = false;
         if(this._doubleFreeCount <= 0)
         {
            if(!SharedManager.Instance.isBuyInteger)
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               this._alertAsk = ComponentFactory.Instance.creatComponentByStylename("lantern.view.alertView");
               this._alertAsk.text = LanguageMgr.GetTranslation("lanternRiddles.view.buyDoubleInteger.alertInfo",this._doublePrice);
               LayerManager.Instance.addToLayer(this._alertAsk,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               this._alertAsk.addEventListener(LanternEvent.LANTERN_SELECT,this.__onLanternAlertSelect);
               this._alertAsk.addEventListener(FrameEvent.RESPONSE,this.__onBuyHandle);
            }
            else if(this.payment(SharedManager.Instance.isBuyIntegerBind))
            {
               SocketManager.Instance.out.sendLanternRiddlesUseSkill(this._questionView.info.QuestionID,this._questionView.info.QuestionIndex,1,SharedManager.Instance.isBuyIntegerBind);
            }
         }
         else if(!this._hitBtn.enable || this._questionView.info.Option != 0)
         {
            SocketManager.Instance.out.sendLanternRiddlesUseSkill(this._questionView.info.QuestionID,this._questionView.info.QuestionIndex,1);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("lanternRiddles.view.doubleClick.tipsInfo"));
         }
      }
      
      protected function __onLanternAlertSelect(event:LanternEvent) : void
      {
         this.setBindFlag(event.flag);
      }
      
      protected function __onBuyHandle(event:FrameEvent) : void
      {
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(LanternEvent.LANTERN_SELECT,this.__onLanternAlertSelect);
         frame.removeEventListener(FrameEvent.RESPONSE,this.__onBuyHandle);
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._hitFlag)
               {
                  SharedManager.Instance.isBuyHitBind = frame.isBand;
               }
               else
               {
                  SharedManager.Instance.isBuyIntegerBind = frame.isBand;
               }
               if(this.payment(frame.isBand) && !LanternRiddlesManager.instance.checkMoney(50))
               {
                  SocketManager.Instance.out.sendLanternRiddlesUseSkill(this._questionView.info.QuestionID,this._questionView.info.QuestionIndex,this._hitFlag ? 0 : 1,frame.isBand);
               }
               this._hitBtn.enable = false;
               break;
            default:
               this.setBindFlag(false);
         }
         frame.dispose();
         frame = null;
      }
      
      private function setBindFlag(flag:Boolean) : void
      {
         if(this._hitFlag)
         {
            SharedManager.Instance.isBuyHit = flag;
         }
         else
         {
            SharedManager.Instance.isBuyInteger = flag;
         }
      }
      
      private function payment(isBand:Boolean) : Boolean
      {
         var alertFrame:BaseAlerFrame = null;
         if(isBand)
         {
            if(!this.checkMoney(true))
            {
               alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
               alertFrame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
               return false;
            }
         }
         else if(!this.checkMoney(false))
         {
            alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
            return false;
         }
         return true;
      }
      
      protected function __onHitBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._hitFlag = true;
         if(this._hitFreeCount <= 0)
         {
            if(!SharedManager.Instance.isBuyHit)
            {
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               this._alertAsk = ComponentFactory.Instance.creatComponentByStylename("lantern.view.alertView");
               this._alertAsk.text = LanguageMgr.GetTranslation("lanternRiddles.view.buyHit.alertInfo",this._hitPrice);
               LayerManager.Instance.addToLayer(this._alertAsk,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               this._alertAsk.addEventListener(LanternEvent.LANTERN_SELECT,this.__onLanternAlertSelect);
               this._alertAsk.addEventListener(FrameEvent.RESPONSE,this.__onBuyHandle);
            }
            else
            {
               if(this.payment(SharedManager.Instance.isBuyHitBind))
               {
                  SocketManager.Instance.out.sendLanternRiddlesUseSkill(this._questionView.info.QuestionID,this._questionView.info.QuestionIndex,0,SharedManager.Instance.isBuyHitBind);
               }
               this._hitBtn.enable = false;
            }
         }
         else
         {
            SocketManager.Instance.out.sendLanternRiddlesUseSkill(this._questionView.info.QuestionID,this._questionView.info.QuestionIndex,0);
            this._hitBtn.enable = false;
         }
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.sendLanternRiddlesQuestion();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._doubleBtn.removeEventListener(MouseEvent.CLICK,this._onDoubleBtnClick);
         this._hitBtn.removeEventListener(MouseEvent.CLICK,this.__onHitBtnClick);
         LanternRiddlesManager.instance.removeEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_QUESTION,this.__onSetQuestionInfo);
         LanternRiddlesManager.instance.removeEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_RANKINFO,this.__onSetRankInfo);
         LanternRiddlesManager.instance.removeEventListener(CrazyTankSocketEvent.LANTERNRIDDLES_SKILL,this.__onSetBtnEnable);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               LanternRiddlesManager.instance.hide();
         }
      }
      
      private function onResponseHander(e:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onResponseHander);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(!this.checkMoney(false))
            {
               alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
               return;
            }
            SocketManager.Instance.out.sendLanternRiddlesUseSkill(this._questionView.info.QuestionID,this._questionView.info.QuestionIndex,this._hitFlag ? 0 : 1,false);
         }
         e.currentTarget.dispose();
      }
      
      private function _response(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function checkMoney(isBand:Boolean) : Boolean
      {
         var money:int = this._hitFlag ? this._hitPrice : this._doublePrice;
         if(isBand)
         {
            if(PlayerManager.Instance.Self.BandMoney < money)
            {
               return false;
            }
         }
         else if(PlayerManager.Instance.Self.Money < money)
         {
            return false;
         }
         return true;
      }
      
      override public function dispose() : void
      {
         var i:int = 0;
         super.dispose();
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._questionView))
         {
            this._questionView.dispose();
            this._questionView = null;
         }
         if(Boolean(this._doubleBtn))
         {
            this._doubleBtn.dispose();
            this._doubleBtn = null;
         }
         if(Boolean(this._hitBtn))
         {
            this._hitBtn.dispose();
            this._hitBtn = null;
         }
         if(Boolean(this._freeDouble))
         {
            this._freeDouble.dispose();
            this._freeDouble = null;
         }
         if(Boolean(this._freeHit))
         {
            this._freeHit.dispose();
            this._freeHit = null;
         }
         if(Boolean(this._careInfo))
         {
            this._careInfo.dispose();
            this._careInfo = null;
         }
         if(Boolean(this._myRank))
         {
            this._myRank.dispose();
            this._myRank = null;
         }
         if(Boolean(this._myInteger))
         {
            this._myInteger.dispose();
            this._myInteger = null;
         }
         if(Boolean(this._rankVec))
         {
            for(i = 0; i < this._rankVec.length; i++)
            {
               this._rankVec[i].dispose();
               this._rankVec[i] = null;
            }
            this._rankVec.length = 0;
            this._rankVec = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

