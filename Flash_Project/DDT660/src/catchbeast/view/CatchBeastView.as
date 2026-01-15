package catchbeast.view
{
   import baglocked.BaglockedManager;
   import catchbeast.CatchBeastManager;
   import catchbeast.date.CatchBeastInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import road7th.comm.PackageIn;
   import store.HelpFrame;
   
   public class CatchBeastView extends Frame
   {
      
      private static var AWARD_NUM:int = 5;
      
      private var _progressInfo:Array = [{
         "damage":0,
         "pos":0
      },{
         "damage":5,
         "pos":104
      },{
         "damage":20,
         "pos":187
      },{
         "damage":50,
         "pos":270
      },{
         "damage":100,
         "pos":353
      },{
         "damage":200,
         "pos":436
      }];
      
      private var _bg:Bitmap;
      
      private var _helpBtn:BaseButton;
      
      private var _challengeBtn:BaseButton;
      
      private var _challengeNumText:FilterFrameText;
      
      private var _buyBuffBtn:BaseButton;
      
      private var _buyBuffNumText:FilterFrameText;
      
      private var _beastMovie:MovieImage;
      
      private var _progress:ScaleFrameImage;
      
      private var _progressSense:Sprite;
      
      private var _progressTips:OneLineTip;
      
      private var _damageInfo:FilterFrameText;
      
      private var _progressMask:Sprite;
      
      private var _careInfo:FilterFrameText;
      
      private var _getAwardVec:Vector.<MovieImage>;
      
      private var _info:CatchBeastInfo;
      
      public function CatchBeastView()
      {
         super();
         this._info = new CatchBeastInfo();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function initView() : void
      {
         var awardPos:Point = null;
         var getAward:MovieImage = null;
         titleText = LanguageMgr.GetTranslation("catchBeast.view.Title");
         this._bg = ComponentFactory.Instance.creat("catchBeast.view.bg");
         addToContent(this._bg);
         this._helpBtn = ComponentFactory.Instance.creat("catchBeast.view.helpBtn");
         addToContent(this._helpBtn);
         this._beastMovie = ComponentFactory.Instance.creat("catchBeast.view.beastMovie");
         addToContent(this._beastMovie);
         this._damageInfo = ComponentFactory.Instance.creatComponentByStylename("catchBeast.view.damageText");
         addToContent(this._damageInfo);
         this._progress = ComponentFactory.Instance.creatComponentByStylename("catchBeast.view.progressImage");
         addToContent(this._progress);
         this._progressTips = new OneLineTip();
         addToContent(this._progressTips);
         this._progressTips.x = this._progress.x;
         this._progressTips.y = this._progress.y - this._progress.height;
         this._progressTips.visible = false;
         this._challengeBtn = ComponentFactory.Instance.creat("catchBeast.view.challengeBtn");
         this._challengeBtn.tipData = LanguageMgr.GetTranslation("catchBeast.view.challengeTips");
         addToContent(this._challengeBtn);
         this._challengeNumText = ComponentFactory.Instance.creatComponentByStylename("catchBeast.view.challengeNum");
         this._challengeBtn.addChild(this._challengeNumText);
         this._buyBuffBtn = ComponentFactory.Instance.creat("catchBeast.view.buyBuffBtn");
         this._buyBuffBtn.tipData = LanguageMgr.GetTranslation("catchBeast.view.buyBuffTips");
         addToContent(this._buyBuffBtn);
         this._buyBuffNumText = ComponentFactory.Instance.creatComponentByStylename("catchBeast.view.buyBuffNum");
         this._buyBuffBtn.addChild(this._buyBuffNumText);
         this.createProgressMask();
         this.createProgressSense();
         this._careInfo = ComponentFactory.Instance.creatComponentByStylename("catchBeast.view.careInfoText");
         this._careInfo.text = LanguageMgr.GetTranslation("catchBeast.view.careInfo");
         addToContent(this._careInfo);
         this._getAwardVec = new Vector.<MovieImage>();
         awardPos = PositionUtils.creatPoint("catchBeast.view.awardPos");
         for(var i:int = 0; i < AWARD_NUM; i++)
         {
            getAward = ComponentFactory.Instance.creat("catchBeast.view.getAwardMovie");
            getAward.id = i;
            getAward.x = awardPos.x + i * 83;
            getAward.y = awardPos.y;
            addToContent(getAward);
            getAward.movie.gotoAndStop(1);
            this._getAwardVec.push(getAward);
         }
      }
      
      private function createProgressSense() : void
      {
         this._progressSense = new Sprite();
         this._progressSense.graphics.beginFill(0,0);
         this._progressSense.graphics.drawRect(0,0,this._progress.width,this._progress.height);
         this._progressSense.graphics.endFill();
         this._progressSense.buttonMode = true;
         PositionUtils.setPos(this._progressSense,this._progress);
         addToContent(this._progressSense);
      }
      
      private function createProgressMask() : void
      {
         this._progressMask = new Sprite();
         this._progressMask.graphics.beginFill(16777215);
         this._progressMask.graphics.drawRect(0,0,this._progress.width,this._progress.height);
         this._progressMask.graphics.endFill();
         this._progressMask.x = this._progress.x - this._progress.width;
         this._progressMask.y = this._progress.y;
         addToContent(this._progressMask);
         this._progress.mask = this._progressMask;
      }
      
      private function setProgressLength(num:int) : void
      {
         var offX:int = 0;
         if(num >= this._progressInfo[5].damage * 10000)
         {
            num = this._progressInfo[5].damage * 10000;
         }
         for(var i:int = 1; i < this._progressInfo.length; i++)
         {
            if(num <= this._progressInfo[i].damage * 10000)
            {
               offX = (this._progressInfo[i].pos - this._progressInfo[i - 1].pos) * (num - this._progressInfo[i - 1].damage * 10000) / ((this._progressInfo[i].damage - this._progressInfo[i - 1].damage) * 10000) + this._progressInfo[i - 1].pos;
               break;
            }
         }
         this._progressMask.x += offX;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
         this._challengeBtn.addEventListener(MouseEvent.CLICK,this.__onChallengeClick);
         this._buyBuffBtn.addEventListener(MouseEvent.CLICK,this.__onBuyBuffClick);
         this._progressSense.addEventListener(MouseEvent.MOUSE_OVER,this.__onProgressOver);
         this._progressSense.addEventListener(MouseEvent.MOUSE_OUT,this.__onProgressOut);
         CatchBeastManager.instance.addEventListener(CrazyTankSocketEvent.CATCHBEAST_VIEWINFO,this.__onSetViewInfo);
         CatchBeastManager.instance.addEventListener(CrazyTankSocketEvent.CATCHBEAST_GETAWARD,this.__onIsGetAward);
         CatchBeastManager.instance.addEventListener(CrazyTankSocketEvent.CATCHBEAST_BUYBUFF,this.__onIsBuyBuff);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_1 = true;
      }
      
      protected function __onHelpClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("catchBeast.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("catchBeast.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      protected function __onSetViewInfo(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         pkg = event.pkg;
         this._info.ChallengeNum = pkg.readInt();
         this._info.BuyBuffNum = pkg.readInt();
         this._info.BuffPrice = pkg.readInt();
         this._info.DamageNum = pkg.readInt();
         var length:int = pkg.readInt();
         for(var i:int = 0; i < length; i++)
         {
            this._getAwardVec[i].tipData = new GoodTipInfo();
            this._getAwardVec[i].tipData.itemInfo = this.setAwardBoxInfo(pkg.readInt());
            InventoryItemInfo(this._getAwardVec[i].tipData.itemInfo).IsBinds = true;
            this._progressInfo[i + 1].damage = pkg.readInt() / 10000;
            this._info.BoxState.push(pkg.readInt());
         }
         this._challengeBtn.enable = this._info.ChallengeNum <= 0 ? false : true;
         this._buyBuffBtn.enable = this._info.BuyBuffNum <= 0 ? false : true;
         this._challengeNumText.text = LanguageMgr.GetTranslation("catchBeast.view.challengeNum",this._info.ChallengeNum);
         this._buyBuffNumText.text = LanguageMgr.GetTranslation("catchBeast.view.challengeNum",this._info.BuyBuffNum);
         this._damageInfo.text = LanguageMgr.GetTranslation("catchBeast.view.damageInfo",this._progressInfo[1].damage,this._progressInfo[2].damage,this._progressInfo[3].damage,this._progressInfo[4].damage,this._progressInfo[5].damage);
         this.setProgressTipNum(this._info.DamageNum);
         this.setProgressLength(this._info.DamageNum);
         this.setAwardBoxState();
      }
      
      private function setProgressTipNum(num:int) : void
      {
         var str:String = num.toString() + "/" + (this._progressInfo[this._progressInfo.length - 1].damage * 10000).toString();
         this._progressTips.tipData = LanguageMgr.GetTranslation("catchBeast.view.progressTips",str);
      }
      
      private function setAwardBoxState() : void
      {
         for(var i:int = 0; i < this._info.BoxState.length; i++)
         {
            if(this._info.BoxState[i] == 2)
            {
               this._getAwardVec[i].buttonMode = true;
               this._getAwardVec[i].addEventListener(MouseEvent.CLICK,this.__onGetAward);
            }
            this._getAwardVec[i].movie.gotoAndStop(this._info.BoxState[i]);
         }
      }
      
      protected function __onGetAward(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var movie:MovieImage = event.currentTarget as MovieImage;
         this._getAwardVec[movie.id].removeEventListener(MouseEvent.CLICK,this.__onGetAward);
         SocketManager.Instance.out.sendCatchBeastGetAward(movie.id);
      }
      
      protected function __onIsGetAward(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var flag:Boolean = pkg.readBoolean();
         var id:int = pkg.readInt();
         if(flag)
         {
            this._getAwardVec[id].movie.gotoAndStop(3);
            this._getAwardVec[id].buttonMode = false;
         }
      }
      
      private function setAwardBoxInfo(id:int) : InventoryItemInfo
      {
         var itemInfo:InventoryItemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = id;
         return ItemManager.fill(itemInfo);
      }
      
      protected function __onProgressOver(event:MouseEvent) : void
      {
         this._progressTips.visible = true;
      }
      
      protected function __onProgressOut(event:MouseEvent) : void
      {
         this._progressTips.visible = false;
      }
      
      protected function __onBuyBuffClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var alertAsk:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("catchBeast.view.buyBuffInfoText",this._info.BuffPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false);
         alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertBuyBuff);
      }
      
      protected function __onIsBuyBuff(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var buyNum:int = pkg.readInt();
         this._buyBuffBtn.enable = buyNum <= 0 ? false : true;
         this._buyBuffNumText.text = LanguageMgr.GetTranslation("catchBeast.view.challengeNum",buyNum);
      }
      
      protected function __onChallengeClick(event:MouseEvent) : void
      {
         var alertAsk:BaseAlerFrame = null;
         SoundManager.instance.playButtonSound();
         if(this._info.ChallengeNum < 0)
         {
            this._challengeBtn.enable = false;
         }
         else
         {
            alertAsk = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("catchBeast.view.challengeInofText"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,AlertManager.NOSELECTBTN);
            alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertChallenge);
         }
      }
      
      protected function __alertChallenge(event:FrameEvent) : void
      {
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__alertChallenge);
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SocketManager.Instance.out.sendCatchBeastChallenge();
         }
         frame.dispose();
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.sendCatchBeastViewInfo();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpClick);
         this._challengeBtn.removeEventListener(MouseEvent.CLICK,this.__onChallengeClick);
         this._buyBuffBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyBuffClick);
         this._progressSense.removeEventListener(MouseEvent.MOUSE_OVER,this.__onProgressOver);
         this._progressSense.removeEventListener(MouseEvent.MOUSE_OUT,this.__onProgressOut);
         CatchBeastManager.instance.removeEventListener(CrazyTankSocketEvent.CATCHBEAST_VIEWINFO,this.__onSetViewInfo);
         CatchBeastManager.instance.removeEventListener(CrazyTankSocketEvent.CATCHBEAST_GETAWARD,this.__onIsGetAward);
         CatchBeastManager.instance.removeEventListener(CrazyTankSocketEvent.CATCHBEAST_BUYBUFF,this.__onIsBuyBuff);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_8 = true;
      }
      
      protected function __alertBuyBuff(event:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         var frame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyBuff);
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  ObjectUtils.disposeObject(event.currentTarget);
                  return;
               }
               if(frame.isBand)
               {
                  if(!this.checkMoney(true))
                  {
                     frame.dispose();
                     alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                     alertFrame.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
                     return;
                  }
               }
               else if(!this.checkMoney(false))
               {
                  frame.dispose();
                  alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               SocketManager.Instance.out.sendCatchBeastBuyBuff(frame.isBand);
               break;
         }
         frame.dispose();
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
            SocketManager.Instance.out.sendCatchBeastBuyBuff(false);
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
         if(isBand)
         {
            if(PlayerManager.Instance.Self.BandMoney < this._info.BuffPrice)
            {
               return false;
            }
         }
         else if(PlayerManager.Instance.Self.Money < this._info.BuffPrice)
         {
            return false;
         }
         return true;
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               CatchBeastManager.instance.hide();
         }
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
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.dispose();
            this._helpBtn = null;
         }
         if(Boolean(this._progress))
         {
            this._progress.dispose();
            this._progress = null;
         }
         if(Boolean(this._challengeBtn))
         {
            this._challengeBtn.dispose();
            this._challengeBtn = null;
         }
         if(Boolean(this._challengeNumText))
         {
            this._challengeNumText.dispose();
            this._challengeNumText = null;
         }
         if(Boolean(this._buyBuffNumText))
         {
            this._buyBuffNumText.dispose();
            this._buyBuffNumText = null;
         }
         if(Boolean(this._beastMovie))
         {
            this._beastMovie.dispose();
            this._beastMovie = null;
         }
         if(Boolean(this._damageInfo))
         {
            this._damageInfo.dispose();
            this._damageInfo = null;
         }
         if(Boolean(this._getAwardVec))
         {
            for(i = 0; i < this._getAwardVec.length; i++)
            {
               if(Boolean(this._getAwardVec[i]))
               {
                  this._getAwardVec[i].removeEventListener(MouseEvent.CLICK,this.__onGetAward);
                  this._getAwardVec[i].dispose();
                  this._getAwardVec[i] = null;
               }
            }
            this._getAwardVec.length = 0;
            this._getAwardVec = null;
         }
         if(Boolean(this._progressTips))
         {
            this._progressTips.dispose();
            this._progressTips = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

