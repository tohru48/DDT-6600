package sevenDouble.view
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
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import sevenDouble.SevenDoubleManager;
   
   public class SevenDoubleFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _bottomBg:ScaleBitmapImage;
      
      private var _cellList:Vector.<SevenDoubleFrameItemCell>;
      
      private var _btn:SimpleBitmapButton;
      
      private var _countTxt:FilterFrameText;
      
      private var _matchView:SevenDoubleMatchView;
      
      private var _helpBtn:SevenDoubleHelpBtn;
      
      private var _doubleTagIcon:Bitmap;
      
      public function SevenDoubleFrame()
      {
         super();
         this._cellList = new Vector.<SevenDoubleFrameItemCell>();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var tmp:SevenDoubleFrameItemCell = null;
         titleText = LanguageMgr.GetTranslation("sevenDouble.frame.titleTxt");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.bg");
         addToContent(this._bg);
         this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.bottomBg");
         addToContent(this._bottomBg);
         for(var i:int = 0; i < 3; i++)
         {
            tmp = new SevenDoubleFrameItemCell(i,SevenDoubleManager.instance.dataInfo.carInfo[i]);
            tmp.x = 8 + (tmp.width + 4) * i;
            tmp.y = 10;
            addToContent(tmp);
            this._cellList.push(tmp);
         }
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.countTxt");
         this.refreshEnterCountHandler(null);
         addToContent(this._countTxt);
         this._helpBtn = new SevenDoubleHelpBtn(false);
         addToContent(this._helpBtn);
         this._doubleTagIcon = ComponentFactory.Instance.creatBitmap("asset.sevenDouble.doubleScoreIcon");
         addToContent(this._doubleTagIcon);
         this.refreshDoubleTagIcon();
      }
      
      private function refreshDoubleTagIcon() : void
      {
         if(SevenDoubleManager.instance.isInDoubleTime)
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
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.START_GAME,this.startGameHandler);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.ENTER_GAME,this.enterGameHandler);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.END,this.endHandler);
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.REFRESH_ENTER_COUNT,this.refreshEnterCountHandler);
      }
      
      private function refreshEnterCountHandler(event:Event) : void
      {
         var tmpCount:int = 0;
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
            ObjectUtils.disposeObject(this._btn);
         }
         var tmpFreeCount:int = SevenDoubleManager.instance.freeCount;
         if(tmpFreeCount > 0)
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.freeBtn");
            tmpCount = tmpFreeCount;
         }
         else
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.startBtn");
            tmpCount = SevenDoubleManager.instance.usableCount;
         }
         addToContent(this._btn);
         this._countTxt.text = "(" + tmpCount + ")";
      }
      
      private function endHandler(event:Event) : void
      {
         SocketManager.Instance.out.sendSevenDoubleCancelGame();
         this.dispose();
      }
      
      private function enterGameHandler(event:Event) : void
      {
         this.dispose();
         StateManager.setState(StateType.SEVEN_DOUBLE_SCENE);
      }
      
      private function startGameHandler(event:Event) : void
      {
         this._matchView = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.matchView");
         this._matchView.show();
         this._matchView.addEventListener(FrameEvent.RESPONSE,this.cancelMatchHandler,false,0,true);
      }
      
      private function cancelMatchHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendSevenDoubleCancelGame();
            this.disposeMatchView();
         }
      }
      
      private function disposeMatchView() : void
      {
         if(Boolean(this._matchView))
         {
            this._matchView.removeEventListener(FrameEvent.RESPONSE,this.cancelMatchHandler);
            ObjectUtils.disposeObject(this._matchView);
            this._matchView = null;
         }
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
         if(SevenDoubleManager.instance.freeCount > 0)
         {
            SocketManager.Instance.out.sendSevenDoubleStartGame(false);
         }
         else
         {
            if(SevenDoubleManager.instance.usableCount <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("sevenDouble.noEnoughUsableCount"));
               return;
            }
            tmpNeedMoney = SevenDoubleManager.instance.startGameNeedMoney;
            tmpObj = SevenDoubleManager.instance.getBuyRecordStatus(1);
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
                     SocketManager.Instance.out.sendSevenDoubleStartGame(tmpObj.isBand);
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("moneyPoorNote"));
                  tmpObj.isNoPrompt = false;
               }
            }
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.frame.startGameConfirmTxt",tmpNeedMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SevenDoubleBuyConfirmView",30,true);
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
            tmpNeedMoney = SevenDoubleManager.instance.startGameNeedMoney;
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < tmpNeedMoney)
            {
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.startGameReConfirm,false,0,true);
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < tmpNeedMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as SevenDoubleBuyConfirmView).isNoPrompt)
            {
               tmpObj = SevenDoubleManager.instance.getBuyRecordStatus(1);
               tmpObj.isNoPrompt = true;
               tmpObj.isBand = confirmFrame.isBand;
            }
            SocketManager.Instance.out.sendSevenDoubleStartGame(confirmFrame.isBand);
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
            needMoney = SevenDoubleManager.instance.startGameNeedMoney;
            if(PlayerManager.Instance.Self.Money < needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendSevenDoubleStartGame(false);
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
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.START_GAME,this.startGameHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.ENTER_GAME,this.enterGameHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.END,this.endHandler);
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.REFRESH_ENTER_COUNT,this.refreshEnterCountHandler);
      }
      
      override public function dispose() : void
      {
         this.disposeMatchView();
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._bottomBg = null;
         this._cellList = null;
         this._btn = null;
         this._countTxt = null;
         this._helpBtn = null;
         this._doubleTagIcon = null;
      }
   }
}

