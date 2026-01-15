package escort.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import escort.EscortManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EscortFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _bottomBg:ScaleBitmapImage;
      
      private var _cellList:Vector.<EscortFrameItemCell>;
      
      private var _btn:SimpleBitmapButton;
      
      private var _countTxt:FilterFrameText;
      
      private var _helpBtn:EscortHelpBtn;
      
      private var _doubleTagIcon:Bitmap;
      
      private var _matchView:EscortMatchView;
      
      public function EscortFrame()
      {
         super();
         InviteManager.Instance.enabled = false;
         this._cellList = new Vector.<EscortFrameItemCell>();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var tmp:EscortFrameItemCell = null;
         titleText = LanguageMgr.GetTranslation("escort.frame.titleTxt");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("escort.frame.bg");
         addToContent(this._bg);
         this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("escort.frame.bottomBg");
         addToContent(this._bottomBg);
         for(var i:int = 0; i < 3; i++)
         {
            tmp = new EscortFrameItemCell(i,EscortManager.instance.dataInfo.carInfo[i]);
            tmp.x = 8 + (tmp.width + 4) * i;
            tmp.y = 10;
            addToContent(tmp);
            this._cellList.push(tmp);
         }
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("escort.frame.countTxt");
         this.refreshEnterCountHandler(null);
         addToContent(this._countTxt);
         this._helpBtn = new EscortHelpBtn(false);
         addToContent(this._helpBtn);
         this._doubleTagIcon = ComponentFactory.Instance.creatBitmap("asset.escort.doubleScoreIcon");
         addToContent(this._doubleTagIcon);
         this.refreshDoubleTagIcon();
      }
      
      private function refreshDoubleTagIcon() : void
      {
         if(EscortManager.instance.isInDoubleTime)
         {
            this._doubleTagIcon.visible = true;
         }
         else
         {
            this._doubleTagIcon.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         EscortManager.instance.addEventListener(EscortManager.START_GAME,this.startGameHandler);
         EscortManager.instance.addEventListener(EscortManager.ENTER_GAME,this.enterGameHandler);
         EscortManager.instance.addEventListener(EscortManager.END,this.endHandler);
         EscortManager.instance.addEventListener(EscortManager.REFRESH_ENTER_COUNT,this.refreshEnterCountHandler);
      }
      
      private function refreshEnterCountHandler(event:Event) : void
      {
         var tmpCount:int = 0;
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
            ObjectUtils.disposeObject(this._btn);
         }
         var tmpFreeCount:int = EscortManager.instance.freeCount;
         if(tmpFreeCount > 0)
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("escort.frame.freeBtn");
            tmpCount = tmpFreeCount;
         }
         else
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("escort.frame.startBtn");
            tmpCount = EscortManager.instance.usableCount;
         }
         addToContent(this._btn);
         this._countTxt.text = "(" + tmpCount + ")";
      }
      
      private function endHandler(event:Event) : void
      {
         SocketManager.Instance.out.sendEscortCancelGame();
         this.dispose();
      }
      
      private function enterGameHandler(event:Event) : void
      {
         this.dispose();
         StateManager.setState(StateType.ESCORT);
      }
      
      private function startGameHandler(event:Event) : void
      {
         this._matchView = ComponentFactory.Instance.creatComponentByStylename("escort.frame.matchView");
         LayerManager.Instance.addToLayer(this._matchView,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         var tmpNeedMoney:int = 0;
         var tmpObj:Object = null;
         var confirmFrame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(EscortManager.instance.freeCount > 0)
         {
            SocketManager.Instance.out.sendEscortStartGame(false);
         }
         else
         {
            if(EscortManager.instance.usableCount <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("escort.noEnoughUsableCount"));
               return;
            }
            tmpNeedMoney = EscortManager.instance.startGameNeedMoney;
            tmpObj = EscortManager.instance.getBuyRecordStatus(1);
            if(Boolean(tmpObj.isNoPrompt))
            {
               if(Boolean(tmpObj.isBand) && PlayerManager.Instance.Self.BandMoney < tmpNeedMoney)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bindMoneyPoorNote"));
                  tmpObj.isNoPrompt = false;
               }
               else
               {
                  if(!(!tmpObj.isBand && PlayerManager.Instance.Self.Money < tmpNeedMoney))
                  {
                     SocketManager.Instance.out.sendEscortStartGame(tmpObj.isBand);
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("moneyPoorNote"));
                  tmpObj.isNoPrompt = false;
               }
            }
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("escort.frame.startGameConfirmTxt",tmpNeedMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"EscortBuyConfirmView",30,true,AlertManager.SELECTBTN);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.startConfirm,false,0,true);
         }
      }
      
      private function startConfirm(evt:FrameEvent) : void
      {
         var tmpNeedMoney:int = 0;
         var confirmFrame2:BaseAlerFrame = null;
         var tmpObj:Object = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.startConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            tmpNeedMoney = EscortManager.instance.startGameNeedMoney;
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < tmpNeedMoney)
            {
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("escort.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.startGameReConfirm,false,0,true);
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < tmpNeedMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as EscortBuyConfirmView).isNoPrompt)
            {
               tmpObj = EscortManager.instance.getBuyRecordStatus(1);
               tmpObj.isNoPrompt = true;
               tmpObj.isBand = confirmFrame.isBand;
            }
            SocketManager.Instance.out.sendEscortStartGame(confirmFrame.isBand);
         }
      }
      
      private function startGameReConfirm(evt:FrameEvent) : void
      {
         var needMoney:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.startGameReConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            needMoney = EscortManager.instance.startGameNeedMoney;
            if(PlayerManager.Instance.Self.Money < needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendEscortStartGame(false);
         }
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         EscortManager.instance.removeEventListener(EscortManager.START_GAME,this.startGameHandler);
         EscortManager.instance.removeEventListener(EscortManager.ENTER_GAME,this.enterGameHandler);
         EscortManager.instance.removeEventListener(EscortManager.END,this.endHandler);
         EscortManager.instance.removeEventListener(EscortManager.REFRESH_ENTER_COUNT,this.refreshEnterCountHandler);
      }
      
      override public function dispose() : void
      {
         InviteManager.Instance.enabled = true;
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._bottomBg = null;
         this._cellList = null;
         this._btn = null;
         this._countTxt = null;
         this._helpBtn = null;
         this._doubleTagIcon = null;
         ObjectUtils.disposeObject(this._matchView);
         this._matchView = null;
      }
   }
}

