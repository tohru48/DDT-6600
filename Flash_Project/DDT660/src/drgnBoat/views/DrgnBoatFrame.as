package drgnBoat.views
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
   import drgnBoat.DrgnBoatManager;
   import drgnBoat.data.DrgnBoatInfoVo;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class DrgnBoatFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _bottomBg:ScaleBitmapImage;
      
      private var _cellList:Vector.<DrgnBoatFrameItemCell>;
      
      private var _btn:SimpleBitmapButton;
      
      private var _countTxt:FilterFrameText;
      
      private var _helpBtn:DrgnBoatHelpBtn;
      
      private var _doubleTagIcon:Bitmap;
      
      private var _matchView:DrgnBoatMatchView;
      
      public function DrgnBoatFrame()
      {
         super();
         InviteManager.Instance.enabled = false;
         this._cellList = new Vector.<DrgnBoatFrameItemCell>();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var data:DrgnBoatInfoVo = null;
         var tmp:DrgnBoatFrameItemCell = null;
         titleText = LanguageMgr.GetTranslation("drgnBoat.race.frameTitle");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.framebg");
         addToContent(this._bg);
         this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.bottomBg");
         addToContent(this._bottomBg);
         for(var i:int = 0; i < 3; i++)
         {
            data = DrgnBoatManager.instance.dataInfo;
            tmp = new DrgnBoatFrameItemCell(i,DrgnBoatManager.instance.dataInfo.carInfo[i]);
            tmp.x = 8 + (tmp.width - 2) * i;
            tmp.y = 10;
            addToContent(tmp);
            this._cellList.push(tmp);
         }
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.countTxt");
         this.refreshEnterCountHandler(null);
         addToContent(this._countTxt);
         this._helpBtn = new DrgnBoatHelpBtn(false);
         addToContent(this._helpBtn);
         this._doubleTagIcon = ComponentFactory.Instance.creatBitmap("drgnBoat.doubleScoreIcon");
         addToContent(this._doubleTagIcon);
         this.refreshDoubleTagIcon();
      }
      
      private function refreshDoubleTagIcon() : void
      {
         if(DrgnBoatManager.instance.isInDoubleTime)
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
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.START_GAME,this.startGameHandler);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.ENTER_GAME,this.enterGameHandler);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.END,this.endHandler);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.REFRESH_ENTER_COUNT,this.refreshEnterCountHandler);
      }
      
      private function refreshEnterCountHandler(event:Event) : void
      {
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
            ObjectUtils.disposeObject(this._btn);
         }
         var tmpFreeCount:int = DrgnBoatManager.instance.freeCount;
         this._btn = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.startBtn");
         addToContent(this._btn);
         this._countTxt.text = "(" + tmpFreeCount + ")";
         if(tmpFreeCount <= 0)
         {
            this._btn.enable = false;
         }
      }
      
      private function endHandler(event:Event) : void
      {
         SocketManager.Instance.out.sendEscortCancelGame();
         this.dispose();
      }
      
      private function enterGameHandler(event:Event) : void
      {
         this.dispose();
         StateManager.setState(StateType.DRGN_BOAT);
      }
      
      private function startGameHandler(event:Event) : void
      {
         this._matchView = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.matchView");
         LayerManager.Instance.addToLayer(this._matchView,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(DrgnBoatManager.instance.freeCount > 0)
         {
            SocketManager.Instance.out.sendEscortStartGame(false);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("drgnBoat.noEnoughUsableCount"));
         }
         this._btn.enable = false;
         setTimeout(this.enableBtn,5000);
      }
      
      private function enableBtn() : void
      {
         this._btn.enable = true;
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
            tmpNeedMoney = DrgnBoatManager.instance.startGameNeedMoney;
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
            if((confirmFrame as DrgnBoatBuyConfirmView).isNoPrompt)
            {
               tmpObj = DrgnBoatManager.instance.getBuyRecordStatus(1);
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
            needMoney = DrgnBoatManager.instance.startGameNeedMoney;
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
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.START_GAME,this.startGameHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.ENTER_GAME,this.enterGameHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.END,this.endHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.REFRESH_ENTER_COUNT,this.refreshEnterCountHandler);
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

