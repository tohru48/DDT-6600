package beadSystem.views
{
   import baglocked.BaglockedManager;
   import beadSystem.beadSystemManager;
   import beadSystem.data.BeadEvent;
   import beadSystem.model.BeadModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kingBless.KingBlessManager;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class BeadGetView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _requestBtn1:SimpleBitmapButton;
      
      private var _requestBtn2:SimpleBitmapButton;
      
      private var _requestBtn3:SimpleBitmapButton;
      
      private var _requestBtn4:SimpleBitmapButton;
      
      private var _requestBtn1MC:MovieClip;
      
      private var _requestBtn2MC:MovieClip;
      
      private var _requestBtn3MC:MovieClip;
      
      private var _requestBtn4MC:MovieClip;
      
      private var _autoOpenBeadTimer:Timer;
      
      private var _autoOpenBeadCheckBtn:SelectedCheckButton;
      
      private var _isSelectAutoCheck:Boolean = false;
      
      private var _isServerReplied:Boolean = false;
      
      private var _isFirst:Boolean = true;
      
      private var _alertConfirm:BaseAlerFrame;
      
      private var _alertCharge:BaseAlerFrame;
      
      private var _titleBmp:Bitmap;
      
      private var _freeTipTxt:FilterFrameText;
      
      public function BeadGetView()
      {
         super();
         this.initView();
         this.initEvent();
         this.createMovies();
         this.initBtnState();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("beadSystem.getBead.bg");
         addChild(this._bg);
         this._requestBtn1 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn1");
         this._requestBtn1.tipData = 0;
         this._requestBtn2 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn2");
         this._requestBtn2.tipData = 1;
         this._requestBtn2.enable = false;
         this._requestBtn3 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn3");
         this._requestBtn3.tipData = 2;
         this._requestBtn3.enable = false;
         this._requestBtn4 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn4");
         this._requestBtn4.tipData = 3;
         this._requestBtn4.enable = false;
         this._autoOpenBeadCheckBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.autoOpenBeadCheckBtn");
         this._autoOpenBeadCheckBtn.text = LanguageMgr.GetTranslation("ddt.beadSystem.autoOpen");
         this._titleBmp = ComponentFactory.Instance.creatBitmap("beadSystem.autoOpenTitle");
         this._freeTipTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBeadView.freeGetTipTxt");
         addChild(this._requestBtn1);
         addChild(this._requestBtn2);
         addChild(this._requestBtn3);
         addChild(this._requestBtn4);
         addChild(this._autoOpenBeadCheckBtn);
         addChild(this._titleBmp);
         addChild(this._freeTipTxt);
         this.refreshFreeTipTxt(null);
      }
      
      private function createMovies() : void
      {
         this._requestBtn1MC = ClassUtils.CreatInstance("beadSystem.requestBtn1.movie");
         this._requestBtn1MC.gotoAndStop(1);
         this._requestBtn1MC.mouseEnabled = false;
         this._requestBtn1MC.mouseChildren = false;
         this._requestBtn1MC.x = 7;
         this._requestBtn1MC.y = 14;
         this._requestBtn2MC = ClassUtils.CreatInstance("beadSystem.requestBtn2.movie");
         this._requestBtn2MC.gotoAndStop(1);
         this._requestBtn2MC.mouseEnabled = false;
         this._requestBtn2MC.mouseChildren = false;
         this._requestBtn2MC.x = 114;
         this._requestBtn2MC.y = 9;
         this._requestBtn2MC.visible = false;
         this._requestBtn3MC = ClassUtils.CreatInstance("beadSystem.requestBtn3.movie");
         this._requestBtn3MC.gotoAndStop(1);
         this._requestBtn3MC.mouseEnabled = false;
         this._requestBtn3MC.mouseChildren = false;
         this._requestBtn3MC.x = 220;
         this._requestBtn3MC.y = 9;
         this._requestBtn3MC.visible = false;
         this._requestBtn4MC = ClassUtils.CreatInstance("beadSystem.requestBtn4.movie");
         this._requestBtn4MC.gotoAndStop(1);
         this._requestBtn4MC.mouseEnabled = false;
         this._requestBtn4MC.mouseChildren = false;
         this._requestBtn4MC.x = 327;
         this._requestBtn4MC.y = 9;
         this._requestBtn4MC.visible = false;
         addChild(this._requestBtn1MC);
         addChild(this._requestBtn2MC);
         addChild(this._requestBtn3MC);
         addChild(this._requestBtn4MC);
      }
      
      private function initBtnState() : void
      {
         if(BeadModel.beadRequestBtnIndex > 0)
         {
            this.buttonState(BeadModel.beadRequestBtnIndex);
         }
      }
      
      private function initEvent() : void
      {
         this._requestBtn1.addEventListener(MouseEvent.CLICK,this.__requestClick);
         this._requestBtn2.addEventListener(MouseEvent.CLICK,this.__requestClick);
         this._requestBtn3.addEventListener(MouseEvent.CLICK,this.__requestClick);
         this._requestBtn4.addEventListener(MouseEvent.CLICK,this.__requestClick);
         this._autoOpenBeadCheckBtn.addEventListener(Event.SELECT,this.__autoCheck);
         this._autoOpenBeadCheckBtn.addEventListener(MouseEvent.CLICK,this.__onAutoBtnClick);
         this.addEventListener("unSelectAutoOpenBtn",this.__onOpenBeadAlertCancelled);
         beadSystemManager.Instance.addEventListener(BeadEvent.AUTOOPENBEAD,this.__onViewIndexChanged);
         KingBlessManager.instance.addEventListener(KingBlessManager.UPDATE_BUFF_DATA_EVENT,this.refreshFreeTipTxt);
         KingBlessManager.instance.addEventListener(KingBlessManager.UPDATE_MAIN_EVENT,this.refreshFreeTipTxt);
      }
      
      private function refreshFreeTipTxt(event:Event) : void
      {
         var freeCount:int = KingBlessManager.instance.getOneBuffData(KingBlessManager.BEAD_MASTER);
         if(freeCount > 0)
         {
            this._freeTipTxt.text = LanguageMgr.GetTranslation("ddt.beadSystem.getBeadView.freeGetTipTxt",freeCount);
            this._freeTipTxt.visible = true;
         }
         else
         {
            this._freeTipTxt.visible = false;
         }
      }
      
      private function __onOpenBeadAlertCancelled(pEvent:Event) : void
      {
         this._isSelectAutoCheck = false;
         this._autoOpenBeadCheckBtn.selected = false;
      }
      
      private function removeEvent() : void
      {
         this._requestBtn1.removeEventListener(MouseEvent.CLICK,this.__requestClick);
         this._requestBtn2.removeEventListener(MouseEvent.CLICK,this.__requestClick);
         this._requestBtn3.removeEventListener(MouseEvent.CLICK,this.__requestClick);
         this._requestBtn4.removeEventListener(MouseEvent.CLICK,this.__requestClick);
         this._autoOpenBeadCheckBtn.removeEventListener(Event.SELECT,this.__autoCheck);
         this._autoOpenBeadCheckBtn.removeEventListener(MouseEvent.CLICK,this.__onAutoBtnClick);
         this.removeEventListener("unSelectAutoOpenBtn",this.__onOpenBeadAlertCancelled);
         beadSystemManager.Instance.removeEventListener(BeadEvent.AUTOOPENBEAD,this.__onViewIndexChanged);
         KingBlessManager.instance.removeEventListener(KingBlessManager.UPDATE_BUFF_DATA_EVENT,this.refreshFreeTipTxt);
         KingBlessManager.instance.removeEventListener(KingBlessManager.UPDATE_MAIN_EVENT,this.refreshFreeTipTxt);
      }
      
      private function __onViewIndexChanged(pEvent:BeadEvent) : void
      {
         if(pEvent.CellId == 3)
         {
            this.removeTimer();
         }
      }
      
      private function __onAutoBtnClick(pEvent:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            this._autoOpenBeadCheckBtn.selected = false;
            return;
         }
      }
      
      private function __autoCheck(pEvent:Event) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         if(this._autoOpenBeadCheckBtn.selected)
         {
            if(PlayerManager.Instance.Self.Money < ServerConfigManager.instance.getRequestBeadPrice()[this.getMaxRequestBtn()] && KingBlessManager.instance.getOneBuffData(KingBlessManager.BEAD_MASTER) <= 0)
            {
               if(!this._alertCharge)
               {
                  this._alertCharge = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  this._alertCharge.moveEnable = false;
                  this._alertCharge.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
                  return;
               }
            }
            else if(!this._alertConfirm)
            {
               this._alertConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.autoOpenBeadAlertTip"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
               this._alertConfirm.addEventListener(FrameEvent.RESPONSE,this.__onAutoOpenResponse);
            }
         }
         else if(!this._autoOpenBeadCheckBtn.selected && this._isSelectAutoCheck)
         {
            this.removeTimer();
         }
      }
      
      private function __onAutoOpenResponse(pEvent:FrameEvent) : void
      {
         this._alertConfirm.removeEventListener(FrameEvent.RESPONSE,this.__onAutoOpenResponse);
         switch(pEvent.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               dispatchEvent(new Event("unSelectAutoOpenBtn"));
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.addTimer();
               this._isSelectAutoCheck = true;
               beadSystemManager.Instance.dispatchEvent(new BeadEvent(BeadEvent.AUTOOPENBEAD,1));
         }
         ObjectUtils.disposeObject(this._alertConfirm);
         this._alertConfirm = null;
      }
      
      private function __requestClick(pEvent:MouseEvent) : void
      {
         var vBtn:SimpleBitmapButton = null;
         if(!this._isSelectAutoCheck)
         {
            SoundManager.instance.play("008");
            vBtn = pEvent.currentTarget as SimpleBitmapButton;
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(PlayerManager.Instance.Self.Money < ServerConfigManager.instance.getRequestBeadPrice()[int(vBtn.tipData)] && KingBlessManager.instance.getOneBuffData(KingBlessManager.BEAD_MASTER) <= 0)
            {
               if(!this._alertCharge)
               {
                  this._alertCharge = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  this._alertCharge.moveEnable = false;
                  this._alertCharge.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
                  return;
               }
            }
            SocketManager.Instance.out.sendOpenBead(int(vBtn.tipData));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.autoOpenBeadTip"));
         }
         if(NewHandContainer.Instance.hasArrow(ArrowType.LEAD_BEAD_CANDLESTICK))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.LEAD_BEAD_CANDLESTICK);
         }
      }
      
      private function __poorManResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._alertCharge.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            dispatchEvent(new Event("unSelectAutoOpenBtn"));
            LeavePageManager.leaveToFillPath();
         }
         else
         {
            dispatchEvent(new Event("unSelectAutoOpenBtn"));
         }
         ObjectUtils.disposeObject(this._alertCharge);
         this._alertCharge = null;
      }
      
      public function buttonState(pIndex:int) : void
      {
         if((pIndex & 1) == 1)
         {
            this._requestBtn2.enable = true;
            this._requestBtn2MC.visible = true;
         }
         else
         {
            this._requestBtn2.enable = false;
            this._requestBtn2MC.visible = false;
         }
         if((pIndex & 2) > 0)
         {
            this._requestBtn3.enable = true;
            this._requestBtn3MC.visible = true;
         }
         else
         {
            this._requestBtn3.enable = false;
            this._requestBtn3MC.visible = false;
         }
         if((pIndex & 4) > 0)
         {
            this._requestBtn4.enable = true;
            this._requestBtn4MC.visible = true;
         }
         else
         {
            this._requestBtn4.enable = false;
            this._requestBtn4MC.visible = false;
         }
         this._isServerReplied = true;
      }
      
      private function addTimer() : void
      {
         if(!this._autoOpenBeadTimer)
         {
            this._autoOpenBeadTimer = new Timer(1000);
         }
         this._autoOpenBeadTimer.addEventListener(TimerEvent.TIMER,this.__onAutoOpen);
         this._autoOpenBeadTimer.start();
      }
      
      public function removeTimer() : void
      {
         if(Boolean(this._autoOpenBeadTimer))
         {
            this._autoOpenBeadTimer.stop();
            this._autoOpenBeadTimer.removeEventListener(TimerEvent.TIMER,this.__onAutoOpen);
         }
         dispatchEvent(new Event("unSelectAutoOpenBtn"));
         beadSystemManager.Instance.dispatchEvent(new BeadEvent(BeadEvent.AUTOOPENBEAD,0));
      }
      
      private function __onAutoOpen(pEvent:TimerEvent) : void
      {
         this.autoOpenBead();
      }
      
      private function autoOpenBead() : void
      {
         if(PlayerManager.Instance.Self.Money >= ServerConfigManager.instance.getRequestBeadPrice()[this.getMaxRequestBtn()] || KingBlessManager.instance.getOneBuffData(KingBlessManager.BEAD_MASTER) > 0)
         {
            if(this._isServerReplied || this._isFirst)
            {
               SoundManager.instance.play("008");
               SocketManager.Instance.out.sendOpenBead(this.getMaxRequestBtn());
               this._isServerReplied = false;
               this._isFirst = false;
            }
            return;
         }
         this.removeTimer();
         if(!this._alertCharge)
         {
            this._alertCharge = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            this._alertCharge.moveEnable = false;
            this._alertCharge.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         }
      }
      
      private function getMaxRequestBtn() : int
      {
         var result:int = 0;
         if(this._requestBtn4MC.visible)
         {
            result = 3;
         }
         else if(this._requestBtn3MC.visible)
         {
            result = 2;
         }
         else if(this._requestBtn2MC.visible)
         {
            result = 1;
         }
         else if(this._requestBtn1MC.visible)
         {
            result = 0;
         }
         return result;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeTimer();
         this._autoOpenBeadTimer = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._requestBtn1))
         {
            ObjectUtils.disposeObject(this._requestBtn1);
         }
         this._requestBtn1 = null;
         if(Boolean(this._requestBtn2))
         {
            ObjectUtils.disposeObject(this._requestBtn1);
         }
         this._requestBtn1 = null;
         if(Boolean(this._requestBtn3))
         {
            ObjectUtils.disposeObject(this._requestBtn1);
         }
         this._requestBtn1 = null;
         if(Boolean(this._requestBtn4))
         {
            ObjectUtils.disposeObject(this._requestBtn1);
         }
         this._requestBtn1 = null;
         if(Boolean(this._requestBtn1MC))
         {
            ObjectUtils.disposeObject(this._requestBtn1MC);
         }
         this._requestBtn1MC = null;
         if(Boolean(this._requestBtn2MC))
         {
            ObjectUtils.disposeObject(this._requestBtn2MC);
         }
         this._requestBtn2MC = null;
         if(Boolean(this._requestBtn3MC))
         {
            ObjectUtils.disposeObject(this._requestBtn3MC);
         }
         this._requestBtn3MC = null;
         if(Boolean(this._requestBtn4MC))
         {
            ObjectUtils.disposeObject(this._requestBtn4MC);
         }
         this._requestBtn4MC = null;
         if(Boolean(this._autoOpenBeadCheckBtn))
         {
            ObjectUtils.disposeObject(this._autoOpenBeadCheckBtn);
         }
         this._autoOpenBeadCheckBtn = null;
         if(Boolean(this._titleBmp))
         {
            ObjectUtils.disposeObject(this._titleBmp);
         }
         this._titleBmp = null;
         ObjectUtils.disposeObject(this._freeTipTxt);
         this._freeTipTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

