package treasure.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleUpDownImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import treasure.controller.TreasureManager;
   import treasure.events.TreasureEvents;
   import treasure.model.TreasureModel;
   
   public class TreasureView extends Sprite implements Disposeable
   {
      
      private var _model:TreasureModel;
      
      private var _bg:Bitmap;
      
      private var _loginDaysTitle:Bitmap;
      
      private var _numBg:Bitmap;
      
      private var _digTimesTitle:Bitmap;
      
      private var _helpTimesTitle:Bitmap;
      
      private var _line1:Bitmap;
      
      private var _line2:Bitmap;
      
      private var _loginDaysTf:FilterFrameText;
      
      private var infoFrameBg:ScaleUpDownImage;
      
      private var beginBtn:SimpleBitmapButton;
      
      private var endBtn:SimpleBitmapButton;
      
      private var box:Sprite;
      
      private var fieldView:TreasureField;
      
      private var _treasureReturnBar:TreasureReturnBar;
      
      private var _helpFrame:TreasureHelpFrame;
      
      public function TreasureView()
      {
         super();
         this._model = TreasureModel.instance;
         this.init();
         this.addListener();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.treasure.bg");
         this.infoFrameBg = ComponentFactory.Instance.creatComponentByStylename("asset.treasure.infoFrame.BG");
         this._loginDaysTitle = ComponentFactory.Instance.creatBitmap("asset.treasure.loginDays");
         this._numBg = ComponentFactory.Instance.creatBitmap("asset.treasure.numBg");
         this._digTimesTitle = ComponentFactory.Instance.creatBitmap("asset.treasure.digTimes");
         this._helpTimesTitle = ComponentFactory.Instance.creatBitmap("asset.treasure.helpTimes");
         this._line1 = ComponentFactory.Instance.creatBitmap("asset.treasure.line");
         this._line2 = ComponentFactory.Instance.creatBitmap("asset.treasure.line");
         this._loginDaysTf = ComponentFactory.Instance.creatComponentByStylename("asset.treasure.loginDaysTf");
         this.beginBtn = ComponentFactory.Instance.creatComponentByStylename("treasure.beginbtn");
         this.box = new Sprite();
         this._treasureReturnBar = ComponentFactory.Instance.creat("asset.treasure.returnMenu");
         this._helpFrame = ComponentFactory.Instance.creat("asset.treasure.helpFrame");
         PositionUtils.setPos(this._line1,"treasure.pos.line1");
         PositionUtils.setPos(this._line2,"treasure.pos.line2");
         addChild(this._bg);
         addChild(this.infoFrameBg);
         addChild(this._loginDaysTitle);
         addChild(this._numBg);
         addChild(this._digTimesTitle);
         addChild(this._helpTimesTitle);
         addChild(this._line1);
         addChild(this._line2);
         addChild(this._loginDaysTf);
         addChild(this.box);
         addChild(this.beginBtn);
         addChild(this._treasureReturnBar);
         this.fieldView = new TreasureField(this);
         addChild(this._helpFrame);
         if(TreasureModel.instance.isEndTreasure)
         {
            this.fieldView.setField(true);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.treasure.over"));
         }
         else if(TreasureModel.instance.isBeginTreasure)
         {
            this.fieldView.setField(false);
         }
         else
         {
            this.fieldView.setField(true);
         }
         this.initData();
      }
      
      private function initData() : void
      {
         var starArr:Array = null;
         var sunArr:Array = null;
         var iconForfex:Bitmap = null;
         var iconStar:Bitmap = null;
         var iconSun:Bitmap = null;
         if(TreasureModel.instance.isEndTreasure)
         {
            this.beginBtn.visible = false;
         }
         else if(TreasureModel.instance.isBeginTreasure)
         {
            this.beginBtn.visible = false;
         }
         else
         {
            this.beginBtn.visible = true;
         }
         this._loginDaysTf.text = String(TreasureModel.instance.logoinDays);
         var total:int = TreasureModel.instance.logoinDays > 2 ? 3 : TreasureModel.instance.logoinDays;
         if(Boolean(this.box))
         {
            ObjectUtils.disposeAllChildren(this.box);
         }
         for(var i:int = 0; i < TreasureModel.instance.friendHelpTimes; i++)
         {
            iconForfex = ComponentFactory.Instance.creatBitmap("asset.treasure.forfex");
            this.box.addChild(iconForfex);
            iconForfex.x = 60 + i * (iconForfex.width + 10);
         }
         starArr = [];
         for(var j:int = 0; j < total; j++)
         {
            iconStar = ComponentFactory.Instance.creatBitmap("asset.treasure.star");
            this.box.addChild(iconStar);
            iconStar.x = 60 + j * (iconStar.width + 10);
            iconStar.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            starArr.push(iconStar);
         }
         var sunNum:int = TreasureModel.instance.friendHelpTimes >= PathManager.treasureHelpTimes ? 1 : 0;
         sunArr = [];
         for(var n:int = 0; n < sunNum; n++)
         {
            iconSun = ComponentFactory.Instance.creatBitmap("asset.treasure.sun");
            this.box.addChild(iconSun);
            iconSun.x = 60 + total * (iconSun.width + 10);
            iconSun.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            sunArr.push(iconSun);
         }
         for(var jj:int = 0; jj < PlayerManager.Instance.Self.treasure; jj++)
         {
            if(Boolean(starArr[jj]))
            {
               starArr[jj].filters = null;
            }
         }
         for(var nn:int = 0; nn < PlayerManager.Instance.Self.treasureAdd; nn++)
         {
            if(Boolean(sunArr[nn]))
            {
               sunArr[nn].filters = null;
            }
         }
      }
      
      private function addListener() : void
      {
         this.beginBtn.addEventListener(MouseEvent.CLICK,this.__onbeginBtnClick);
         this._treasureReturnBar.addEventListener(TreasureEvents.RETURN_TREASURE,this.__returnHandler);
         TreasureManager.instance.addEventListener(TreasureEvents.BEREPAIR_FRIEND_FARM_SEND,this.__friendHelpFarmHandler);
         TreasureManager.instance.addEventListener(TreasureEvents.BEGIN_GAME,this.__beginGameHandler);
         TreasureManager.instance.addEventListener(TreasureEvents.DIG,this.__diHandler);
         TreasureManager.instance.addEventListener(TreasureEvents.END_GAME,this.__endGameHandler);
      }
      
      private function __endGameHandler(e:TreasureEvents) : void
      {
         this.fieldView.endGameShow();
      }
      
      private function __diHandler(e:TreasureEvents) : void
      {
         this.initData();
         this.fieldView.digField(e.info.pos);
      }
      
      private function __beginGameHandler(e:TreasureEvents) : void
      {
         this.beginBtn.visible = false;
         this.fieldView.playStartCartoon();
      }
      
      private function __returnHandler(e:TreasureEvents) : void
      {
         SoundManager.instance.play("008");
         FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
      }
      
      private function __friendHelpFarmHandler(e:TreasureEvents) : void
      {
         this.initData();
      }
      
      private function __onEndBtnClick(e:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         if(TreasureModel.instance.friendHelpTimes < PathManager.treasureHelpTimes)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.treasure.giveUp"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         }
         else
         {
            SocketManager.Instance.out.endTreasure();
         }
      }
      
      protected function __onFeedResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SocketManager.Instance.out.endTreasure();
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onFeedResponse);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function __onbeginBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.beginBtn.enable = false;
         SocketManager.Instance.out.startTreasure();
      }
      
      private function removeEvent() : void
      {
         this.beginBtn.removeEventListener(MouseEvent.CLICK,this.__onbeginBtnClick);
         this._treasureReturnBar.removeEventListener(TreasureEvents.RETURN_TREASURE,this.__returnHandler);
         TreasureManager.instance.removeEventListener(TreasureEvents.BEREPAIR_FRIEND_FARM_SEND,this.__friendHelpFarmHandler);
         TreasureManager.instance.removeEventListener(TreasureEvents.BEGIN_GAME,this.__beginGameHandler);
         TreasureManager.instance.removeEventListener(TreasureEvents.DIG,this.__diHandler);
         TreasureManager.instance.removeEventListener(TreasureEvents.END_GAME,this.__endGameHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this.box))
         {
            ObjectUtils.disposeAllChildren(this.box);
         }
         if(Boolean(this.box))
         {
            ObjectUtils.disposeObject(this.box);
         }
         this.box = null;
         if(Boolean(this._loginDaysTf))
         {
            ObjectUtils.disposeObject(this._loginDaysTf);
         }
         this._loginDaysTf = null;
         if(Boolean(this._line1))
         {
            ObjectUtils.disposeObject(this._line1);
         }
         this._line1 = null;
         if(Boolean(this._line2))
         {
            ObjectUtils.disposeObject(this._line2);
         }
         this._line2 = null;
         if(Boolean(this._helpTimesTitle))
         {
            ObjectUtils.disposeObject(this._helpTimesTitle);
         }
         this._helpTimesTitle = null;
         if(Boolean(this._digTimesTitle))
         {
            ObjectUtils.disposeObject(this._digTimesTitle);
         }
         this._digTimesTitle = null;
         if(Boolean(this._numBg))
         {
            ObjectUtils.disposeObject(this._numBg);
         }
         this._numBg = null;
         if(Boolean(this._loginDaysTitle))
         {
            ObjectUtils.disposeObject(this._loginDaysTitle);
         }
         this._loginDaysTitle = null;
         if(Boolean(this.infoFrameBg))
         {
            ObjectUtils.disposeObject(this.infoFrameBg);
         }
         this.infoFrameBg = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         this.fieldView.dispose();
         this.fieldView = null;
         this._helpFrame.dispose();
         this._helpFrame = null;
         this._treasureReturnBar.dispose();
         this._treasureReturnBar = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

