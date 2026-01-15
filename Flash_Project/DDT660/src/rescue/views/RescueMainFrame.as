package rescue.views
{
   import baglocked.BaglockedManager;
   import catchInsect.data.RescueSceneInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.GameManager;
   import rescue.RescueManager;
   import rescue.components.RescuePrizeItem;
   import rescue.components.RescueSceneItem;
   import rescue.components.RescueShopItem;
   import rescue.data.RescueEvent;
   import rescue.data.RescueRewardInfo;
   import road7th.comm.PackageIn;
   import store.HelpFrame;
   
   public class RescueMainFrame extends Frame
   {
      
      private static const NUM:int = 3;
      
      private var _bg:Bitmap;
      
      private var _sceneArr:Vector.<RescueSceneItem>;
      
      private var _tileList:SimpleTileList;
      
      private var _txtImg:Bitmap;
      
      private var _arrowTxt:FilterFrameText;
      
      private var _bloodPackTxt:FilterFrameText;
      
      private var _kingBlessTxt:FilterFrameText;
      
      private var _shopVBox:VBox;
      
      private var _prizeHBox:HBox;
      
      private var _prizeArr:Vector.<RescuePrizeItem>;
      
      private var _challengeBtn:SimpleBitmapButton;
      
      private var _CDTimeBg:ScaleBitmapImage;
      
      private var _CDTimeTxt:FilterFrameText;
      
      private var _accelerateBtn:SimpleBitmapButton;
      
      private var _countTxt:FilterFrameText;
      
      private var _help:BaseButton;
      
      private var _remainSecond:int;
      
      private var _curIndex:int;
      
      private var _cleanCDcount:int;
      
      private var _CDTimer:Timer;
      
      public function RescueMainFrame()
      {
         super();
         this.initData();
         this.initView();
         this.initEvents();
      }
      
      private function initData() : void
      {
         this._sceneArr = new Vector.<RescueSceneItem>();
         this._prizeArr = new Vector.<RescuePrizeItem>();
         SocketManager.Instance.out.requestRescueFrameInfo();
         SocketManager.Instance.out.requestRescueItemInfo();
         this._CDTimer = new Timer(1000);
         this._CDTimer.addEventListener(TimerEvent.TIMER,this.__onCDTimer);
      }
      
      private function initView() : void
      {
         var item:RescueSceneItem = null;
         var item2:RescueShopItem = null;
         var item3:RescuePrizeItem = null;
         titleText = LanguageMgr.GetTranslation("rescue.title");
         this._bg = ComponentFactory.Instance.creat("rescue.bg");
         addToContent(this._bg);
         this._txtImg = ComponentFactory.Instance.creat("rescue.txtImg");
         addToContent(this._txtImg);
         this._arrowTxt = ComponentFactory.Instance.creatComponentByStylename("rescue.numTxt");
         PositionUtils.setPos(this._arrowTxt,"rescue.arrowTxtPos");
         addToContent(this._arrowTxt);
         this._arrowTxt.text = "26";
         this._bloodPackTxt = ComponentFactory.Instance.creatComponentByStylename("rescue.numTxt");
         PositionUtils.setPos(this._bloodPackTxt,"rescue.bloodPackTxtPos");
         addToContent(this._bloodPackTxt);
         this._bloodPackTxt.text = "26";
         this._kingBlessTxt = ComponentFactory.Instance.creatComponentByStylename("rescue.numTxt");
         PositionUtils.setPos(this._kingBlessTxt,"rescue.kingBlessTxtPos");
         addToContent(this._kingBlessTxt);
         this._kingBlessTxt.text = "26";
         this._challengeBtn = ComponentFactory.Instance.creatComponentByStylename("rescue.challengeBtn");
         addToContent(this._challengeBtn);
         this._tileList = ComponentFactory.Instance.creat("rescue.tileList",[NUM]);
         addToContent(this._tileList);
         for(var i:int = 1; i <= 6; i++)
         {
            item = new RescueSceneItem(i);
            this._tileList.addChild(item);
            this._sceneArr.push(item);
            item.setData(false);
         }
         this._curIndex = 0;
         this._sceneArr[0].setSelected(true);
         this._shopVBox = ComponentFactory.Instance.creatComponentByStylename("rescue.shopVBox");
         addToContent(this._shopVBox);
         for(var j:int = 0; j <= 2; j++)
         {
            item2 = new RescueShopItem(j);
            this._shopVBox.addChild(item2);
         }
         this._prizeHBox = ComponentFactory.Instance.creatComponentByStylename("rescue.prizeHBox");
         addToContent(this._prizeHBox);
         for(var k:int = 0; k <= 2; k++)
         {
            item3 = new RescuePrizeItem(k);
            this._prizeHBox.addChild(item3);
            this._prizeArr.push(item3);
         }
         this._CDTimeBg = ComponentFactory.Instance.creatComponentByStylename("rescue.cdTimeBg");
         addToContent(this._CDTimeBg);
         this._CDTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.commonTipText");
         PositionUtils.setPos(this._CDTimeTxt,"rescue.cdTimeTxtPos");
         addToContent(this._CDTimeTxt);
         this._CDTimeTxt.text = "00:00:00";
         this._accelerateBtn = ComponentFactory.Instance.creatComponentByStylename("rescue.accelerateBtn");
         addToContent(this._accelerateBtn);
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("rescue.countTxt");
         addToContent(this._countTxt);
         this._countTxt.text = "(3)";
         this._help = ComponentFactory.Instance.creat("rescue.helpBtn");
         addToContent(this._help);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         SocketManager.Instance.addEventListener(RescueEvent.FRAME_INFO,this.__updateView);
         SocketManager.Instance.addEventListener(RescueEvent.ITEM_INFO,this.__updateItem);
         SocketManager.Instance.addEventListener(RescueEvent.CLEAN_CD,this.__cleanCD);
         SocketManager.Instance.addEventListener(RescueEvent.BUY_ITEM,this.__buyItem);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         this._challengeBtn.addEventListener(MouseEvent.CLICK,this.__challengeBtnClick);
         this._accelerateBtn.addEventListener(MouseEvent.CLICK,this.__accelerateBtnClick);
         this._help.addEventListener(MouseEvent.CLICK,this.__helpBtnClick);
      }
      
      private function __helpBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("rescue.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("rescue.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.changeSubmitButtonX(50);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.ringstation.helpTitle");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      protected function __updateItem(event:RescueEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._arrowTxt.text = pkg.readInt().toString();
         this._bloodPackTxt.text = pkg.readInt().toString();
         this._kingBlessTxt.text = pkg.readInt().toString();
      }
      
      protected function __buyItem(event:RescueEvent) : void
      {
         SocketManager.Instance.out.requestRescueItemInfo();
      }
      
      protected function __cleanCD(event:RescueEvent) : void
      {
         SocketManager.Instance.out.requestRescueFrameInfo(this._sceneArr[this._curIndex].sceneId);
      }
      
      protected function __accelerateBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpNeedMoney:int = this.getNeedMoney();
         if(RescueManager.instance.isNoPrompt)
         {
            if(RescueManager.instance.isBand && PlayerManager.Instance.Self.BandMoney < tmpNeedMoney)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bindMoneyPoorNote"));
               RescueManager.instance.isNoPrompt = false;
            }
            else
            {
               if(!(!RescueManager.instance.isBand && PlayerManager.Instance.Self.Money < tmpNeedMoney))
               {
                  SocketManager.Instance.out.sendRescueCleanCD(RescueManager.instance.isBand,this._sceneArr[this._curIndex].sceneId);
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("moneyPoorNote"));
               RescueManager.instance.isNoPrompt = false;
            }
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("rescue.cleanCDtxt",this.getNeedMoney()),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"rescue.confirmView",30,true,AlertManager.SELECTBTN);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.comfirmHandler,false,0,true);
      }
      
      private function comfirmHandler(event:FrameEvent) : void
      {
         var tmpNeedMoney:int = 0;
         var confirmFrame2:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.comfirmHandler);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            tmpNeedMoney = this.getNeedMoney();
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < tmpNeedMoney)
            {
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.reConfirmHandler,false,0,true);
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < tmpNeedMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as RescueConfirmView).isNoPrompt)
            {
               RescueManager.instance.isNoPrompt = true;
               RescueManager.instance.isBand = confirmFrame.isBand;
            }
            SocketManager.Instance.out.sendRescueCleanCD(confirmFrame.isBand,this._sceneArr[this._curIndex].sceneId);
         }
      }
      
      private function reConfirmHandler(evt:FrameEvent) : void
      {
         var needMoney:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.reConfirmHandler);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            needMoney = this.getNeedMoney();
            if(PlayerManager.Instance.Self.Money < needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendRescueCleanCD(confirmFrame.isBand,this._sceneArr[this._curIndex].sceneId);
         }
      }
      
      private function getNeedMoney() : int
      {
         var arr:Array = ServerConfigManager.instance.rescueCleanCDPrice;
         var base:int = parseInt(arr[0]);
         var increase:int = parseInt(arr[1]);
         return base + this._cleanCDcount * increase;
      }
      
      protected function __challengeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendRescueChallenge(this._sceneArr[this._curIndex].sceneId);
      }
      
      protected function __updateView(event:RescueEvent) : void
      {
         var sceneId:int = 0;
         var idx:int = 0;
         var info:RescueSceneInfo = null;
         var pkg:PackageIn = event.pkg;
         var len:int = pkg.readInt();
         for(var i:int = 0; i <= len - 1; i++)
         {
            sceneId = pkg.readInt();
            idx = sceneId - 1;
            if(Boolean(this._sceneArr[idx]))
            {
               this._sceneArr[idx].removeEventListener(MouseEvent.CLICK,this.__itemClick);
               info = new RescueSceneInfo();
               info.starCount = pkg.readInt();
               info.rewardStatus = pkg.readInt();
               info.freeCount = pkg.readInt();
               info.remainSecond = pkg.readInt();
               info.cleanCDcount = pkg.readInt();
               this._sceneArr[idx].buttonMode = true;
               this._sceneArr[idx].setData(true,info);
               this._sceneArr[idx].addEventListener(MouseEvent.CLICK,this.__itemClick);
            }
         }
         this._remainSecond = this._sceneArr[this._curIndex].info.remainSecond;
         this._CDTimeTxt.text = this.parseDate(this._remainSecond);
         if(this._remainSecond > 0)
         {
            this._CDTimer.start();
         }
         this._cleanCDcount = this._sceneArr[this._curIndex].info.cleanCDcount;
         this.updatePrize();
      }
      
      protected function __onCDTimer(event:TimerEvent) : void
      {
         if(this._remainSecond < 0)
         {
            this._CDTimer.stop();
            SocketManager.Instance.out.requestRescueFrameInfo(this._sceneArr[this._curIndex].sceneId);
            return;
         }
         this._CDTimeTxt.text = this.parseDate(this._remainSecond);
         --this._remainSecond;
      }
      
      private function parseDate(remain:int) : String
      {
         var s:int = remain % 60;
         remain = int(Math.floor(remain / 60));
         var m:int = remain % 60;
         remain = int(Math.floor(remain / 60));
         var h:int = remain % 60;
         var ss:String = s >= 10 ? s.toString() : "0" + s;
         var mm:String = m >= 10 ? m.toString() : "0" + m;
         var hh:String = h >= 10 ? h.toString() : "0" + h;
         return hh + ":" + mm + ":" + ss;
      }
      
      protected function __itemClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var item:RescueSceneItem = event.currentTarget as RescueSceneItem;
         for(var i:int = 0; i <= this._sceneArr.length - 1; i++)
         {
            if(item == this._sceneArr[i])
            {
               this._curIndex = i;
            }
            this._sceneArr[i].setSelected(false);
         }
         item.setSelected(true);
         RescueManager.instance.curIndex = this._curIndex;
         SocketManager.Instance.out.requestRescueFrameInfo(this._sceneArr[this._curIndex].sceneId);
      }
      
      private function updatePrize() : void
      {
         var rewardInfo:RescueRewardInfo = null;
         var status:int = 0;
         var i:int = 0;
         for each(rewardInfo in RescueManager.instance.rewardArr)
         {
            if(rewardInfo.MissionID != this._sceneArr[this._curIndex].sceneId)
            {
               continue;
            }
            switch(rewardInfo.Star)
            {
               case 11:
                  this._prizeArr[0].setData(rewardInfo);
                  break;
               case 12:
                  this._prizeArr[1].setData(rewardInfo);
                  break;
               case 13:
                  this._prizeArr[2].setData(rewardInfo);
                  break;
            }
         }
         status = this._sceneArr[this._curIndex].info.rewardStatus;
         for(i = 0; i <= this._prizeArr.length - 1; i++)
         {
            this._prizeArr[i].setStatus(status & 3);
            status >>= 2;
         }
         if(this._sceneArr[this._curIndex].info.freeCount > 0)
         {
            this._countTxt.text = "(" + this._sceneArr[this._curIndex].info.freeCount + ")";
            this._countTxt.visible = true;
         }
         else
         {
            this._countTxt.visible = false;
         }
         if(this._sceneArr[this._curIndex].info.freeCount > 0 || this._remainSecond <= 0)
         {
            this._challengeBtn.enable = true;
         }
         else
         {
            this._challengeBtn.enable = false;
         }
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
         SocketManager.Instance.removeEventListener(RescueEvent.FRAME_INFO,this.__updateView);
         SocketManager.Instance.removeEventListener(RescueEvent.ITEM_INFO,this.__updateItem);
         SocketManager.Instance.removeEventListener(RescueEvent.CLEAN_CD,this.__cleanCD);
         SocketManager.Instance.removeEventListener(RescueEvent.BUY_ITEM,this.__buyItem);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         this._challengeBtn.removeEventListener(MouseEvent.CLICK,this.__challengeBtnClick);
         this._accelerateBtn.removeEventListener(MouseEvent.CLICK,this.__accelerateBtnClick);
         this._help.removeEventListener(MouseEvent.CLICK,this.__helpBtnClick);
         this._CDTimer.stop();
         this._CDTimer.removeEventListener(TimerEvent.TIMER,this.__onCDTimer);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         for(var i:int = 0; i <= this._sceneArr.length - 1; i++)
         {
            ObjectUtils.disposeObject(this._sceneArr[i]);
            this._sceneArr[i] = null;
         }
         for(var j:int = 0; j <= this._prizeArr.length - 1; j++)
         {
            ObjectUtils.disposeObject(this._prizeArr[j]);
            this._prizeArr[j] = null;
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._tileList);
         this._tileList = null;
         ObjectUtils.disposeObject(this._txtImg);
         this._txtImg = null;
         ObjectUtils.disposeObject(this._arrowTxt);
         this._arrowTxt = null;
         ObjectUtils.disposeObject(this._bloodPackTxt);
         this._bloodPackTxt = null;
         ObjectUtils.disposeObject(this._kingBlessTxt);
         this._kingBlessTxt = null;
         ObjectUtils.disposeObject(this._shopVBox);
         this._shopVBox = null;
         ObjectUtils.disposeObject(this._prizeHBox);
         this._prizeHBox = null;
         ObjectUtils.disposeObject(this._challengeBtn);
         this._challengeBtn = null;
         ObjectUtils.disposeObject(this._CDTimeBg);
         this._CDTimeBg = null;
         ObjectUtils.disposeObject(this._CDTimeTxt);
         this._CDTimeTxt = null;
         ObjectUtils.disposeObject(this._countTxt);
         this._countTxt = null;
         ObjectUtils.disposeObject(this._accelerateBtn);
         this._accelerateBtn = null;
         ObjectUtils.disposeObject(this._help);
         this._help = null;
         super.dispose();
      }
   }
}

