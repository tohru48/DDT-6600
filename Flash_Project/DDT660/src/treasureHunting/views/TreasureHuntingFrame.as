package treasureHunting.views
{
   import bagAndInfo.cell.BaseCell;
   import baglocked.BaglockedManager;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenProxy;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.AddPublicTipManager;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import treasureHunting.TreasureEvent;
   import treasureHunting.TreasureManager;
   import treasureHunting.items.TreasureItem;
   
   public class TreasureHuntingFrame extends Frame
   {
      
      private static const RESTRICT:String = "0-9";
      
      private static const DEFAULT:String = "1";
      
      private static const LENGTH:int = 16;
      
      private static const NUMBER:int = 4;
      
      private var _content:Sprite;
      
      private var _bg:ScaleBitmapImage;
      
      private var _treasureTitle:ScaleBitmapImage;
      
      private var _itemList:SimpleTileList;
      
      private var _itemArr:Vector.<TreasureItem>;
      
      private var _timesTxt:ScaleBitmapImage;
      
      private var _timesInput:FilterFrameText;
      
      private var _showPrizeBtn:BaseButton;
      
      private var _rankPrizeBtn:SimpleBitmapButton;
      
      private var _huntingBtn:BaseButton;
      
      private var _maxBtn:BaseButton;
      
      private var _glint:MovieClip;
      
      private var _lastTimeTxt:FilterFrameText;
      
      private var _myNumberTxt:FilterFrameText;
      
      private var _bagBtn:SimpleBitmapButton;
      
      private var _recordBtn:SimpleBitmapButton;
      
      private var _luckyStoneBG:Bitmap;
      
      private var _bagView:TreasureBagView;
      
      private var _rankView:TreasureRankView;
      
      private var _recordView:TreasureRecordView;
      
      private var _glintTimer:Timer;
      
      private var _rankTimer:Timer;
      
      private var _ran:int;
      
      private var _unitPrice:int;
      
      private var totalScore:int = 0;
      
      private var isClickMax:Boolean = false;
      
      private var moveCell:BaseCell;
      
      private var luckStoneCell:BaseCell;
      
      public function TreasureHuntingFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      private function initData() : void
      {
         SocketManager.Instance.out.sendQequestBadLuck();
         TreasureManager.instance.setFrame(this);
         this._glintTimer = new Timer(300,10);
         this._glintTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._glintTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._rankTimer = new Timer(5 * 60 * 1000);
         this._rankTimer.addEventListener(TimerEvent.TIMER,this.updateRank);
         this._unitPrice = TreasureManager.instance.needMoney;
      }
      
      protected function updateRank(event:TimerEvent) : void
      {
         SocketManager.Instance.out.sendQequestBadLuck();
      }
      
      private function initView() : void
      {
         var item:TreasureItem = null;
         AddPublicTipManager.Instance.type = AddPublicTipManager.MIGONG;
         this._content = new Sprite();
         PositionUtils.setPos(this._content,"treasureHunting.Treasure.ContentPos2");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Treasure.BG");
         this._content.addChild(this._bg);
         this._treasureTitle = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Treasure.Titile");
         this._content.addChild(this._treasureTitle);
         this._itemList = ComponentFactory.Instance.creatCustomObject("treasureHunting.Treasure.SimpleTileList",[NUMBER]);
         this._itemArr = new Vector.<TreasureItem>();
         for(var i:int = 1; i <= LENGTH; i++)
         {
            item = new TreasureItem();
            item.initView(i);
            this._itemList.addChild(item);
            this._itemArr.push(item);
         }
         this._content.addChild(this._itemList);
         this._itemArr[0].selectedLight.visible = true;
         this._timesTxt = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Treasure.TimesTxtImage");
         this._content.addChild(this._timesTxt);
         this._timesInput = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Treasure.TimesTxt");
         this._content.addChild(this._timesInput);
         this._timesInput.maxChars = 2;
         this._timesInput.text = DEFAULT;
         this._timesInput.restrict = RESTRICT;
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Treasure.MaxBtn");
         this._content.addChild(this._maxBtn);
         this._huntingBtn = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Treasure.HuntBtn");
         this._content.addChild(this._huntingBtn);
         this._showPrizeBtn = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.Treasure.AwardBtn");
         this._content.addChild(this._showPrizeBtn);
         this._rankPrizeBtn = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.rankPrizeBtn");
         this._rankPrizeBtn.visible = false;
         this._content.addChild(this._rankPrizeBtn);
         this._bagView = new TreasureBagView();
         PositionUtils.setPos(this._bagView,"treasureHunting.rightViewPos");
         this._content.addChild(this._bagView);
         this._rankView = new TreasureRankView();
         PositionUtils.setPos(this._rankView,"treasureHunting.rightViewPos");
         this._content.addChild(this._rankView);
         this._rankView.visible = false;
         this._recordView = new TreasureRecordView();
         PositionUtils.setPos(this._recordView,"treasureHunting.rightViewPos");
         this._content.addChild(this._recordView);
         this._recordView.visible = false;
         this._luckyStoneBG = ComponentFactory.Instance.creat("treasureHunting.luckyStoneBG");
         this._content.addChild(this._luckyStoneBG);
         this._bagBtn = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.bagBtn");
         this._content.addChild(this._bagBtn);
         this._bagBtn.visible = false;
         this._recordBtn = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.recordBtn");
         this._content.addChild(this._recordBtn);
         this._myNumberTxt = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.stoneNumberTxt");
         this._content.addChild(this._myNumberTxt);
         this._myNumberTxt.text = PlayerManager.Instance.Self.badLuckNumber.toString();
         addToContent(this._content);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._showPrizeBtn.addEventListener(MouseEvent.CLICK,this.onShowPrizeBtnClick);
         this._rankPrizeBtn.addEventListener(MouseEvent.CLICK,this.onRankPrizeBtnClick);
         this._timesInput.addEventListener(Event.CHANGE,this._change);
         this._huntingBtn.addEventListener(MouseEvent.CLICK,this.onHuntingBtnClick);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.onMaxBtnClick);
         this._bagBtn.addEventListener(MouseEvent.CLICK,this.onBagBtnClick);
         this._recordBtn.addEventListener(MouseEvent.CLICK,this.onRecordBtnClick);
         RouletteManager.instance.addEventListener(CaddyEvent.UPDATE_BADLUCK,this.__updateLastTime);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updateInfo);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeBadLuckNumber);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONVERT_SCORE,this.__getConverteds);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HUNTING_BY_SCORE,this.__getRemainScore);
      }
      
      private function __getRemainScore(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this.totalScore = pkg.readInt();
      }
      
      private function __getConverteds(event:CrazyTankSocketEvent) : void
      {
         var alert:BaseAlerFrame = null;
         var pkg:PackageIn = event.pkg;
         var isConvert:Boolean = pkg.readBoolean();
         var convertSorce:int = pkg.readInt();
         this.totalScore = pkg.readInt();
         if(convertSorce != 0 && !isConvert && TreasureManager.instance.isAlert)
         {
            TreasureManager.instance.isAlert = false;
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.convertedAll",convertSorce),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert.mouseEnabled = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseII);
         }
      }
      
      private function _responseII(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendConvertScore(true);
         }
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      protected function onExchangeBtnClick(event:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this.totalScore < 30)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureHunting.notEnough"));
         }
         else
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("treasureHunting.exchangeAll",Math.floor(this.totalScore / 30)),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert.mouseEnabled = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseIII);
         }
      }
      
      private function _responseIII(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseIII);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendHuntingByScore();
         }
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      protected function onRankBtnClick(event:MouseEvent) : void
      {
         this._bagBtn.visible = true;
         this._recordBtn.visible = true;
         this._rankView.visible = true;
         this._bagView.visible = false;
         this._recordView.visible = false;
      }
      
      protected function onBagBtnClick(event:MouseEvent) : void
      {
         this._bagBtn.visible = false;
         this._recordBtn.visible = true;
         this._rankView.visible = false;
         this._bagView.visible = true;
         this._recordView.visible = false;
      }
      
      protected function onRecordBtnClick(event:MouseEvent) : void
      {
         this._bagBtn.visible = true;
         this._recordBtn.visible = false;
         this._rankView.visible = false;
         this._bagView.visible = false;
         this._recordView.visible = true;
         SocketManager.Instance.out.sendRequestAwards(CaddyModel.TREASURE_HUNTING);
      }
      
      private function onShowPrizeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         TreasureManager.instance.openShowPrize();
      }
      
      private function onRankPrizeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         TreasureManager.instance.openRankPrize();
      }
      
      private function _change(event:Event) : void
      {
         var current:int = int(this._timesInput.text);
         var num:String = this._timesInput.text.toString();
         var bagSize:int = TreasureBagView.BAG_SIZE;
         if(current > bagSize)
         {
            this._timesInput.text = bagSize.toString();
         }
         if(num == "0" || num == "")
         {
            this._timesInput.text = "1";
         }
      }
      
      private function onHuntingBtnClick(event:MouseEvent) : void
      {
         var caddyBag:int = 0;
         var max:int = 0;
         var str:String = null;
         SoundManager.instance.play("008");
         if(this.isClickMax)
         {
            caddyBag = PlayerManager.Instance.Self.CaddyBag.items.length;
            max = TreasureBagView.BAG_SIZE - PlayerManager.Instance.Self.CaddyBag.items.length;
            if(PlayerManager.Instance.Self.Money < max * this._unitPrice)
            {
               max = Math.floor(PlayerManager.Instance.Self.Money / this._unitPrice) as int;
            }
            if(max == 0)
            {
               max = 1;
            }
            this._timesInput.text = String(max);
         }
         this.isClickMax = false;
         if(this._timesInput.text == "" || this._timesInput.text == "0")
         {
            return;
         }
         var count:int = parseInt(this._timesInput.text);
         if(SharedManager.Instance.isRemindTreasureBind)
         {
            str = LanguageMgr.GetTranslation("treasureHunting.alert.title",this._unitPrice * count,count);
            TreasureManager.instance.showTransactionFrame(str,this.payForHunting,this.noAlertView,null,false);
         }
         else
         {
            this.payForHunting(SharedManager.Instance.isTreasureBind);
         }
      }
      
      private function onMaxBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var caddyBag:int = PlayerManager.Instance.Self.CaddyBag.items.length;
         var max:int = TreasureBagView.BAG_SIZE - PlayerManager.Instance.Self.CaddyBag.items.length;
         if(PlayerManager.Instance.Self.Money < max * this._unitPrice)
         {
            max = Math.floor(PlayerManager.Instance.Self.Money / this._unitPrice) as int;
         }
         if(max == 0)
         {
            max = 1;
         }
         this._timesInput.text = String(max);
         this.isClickMax = true;
      }
      
      private function payForHunting(isBind:Boolean) : void
      {
         SharedManager.Instance.isTreasureBind = isBind;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var count:int = parseInt(this._timesInput.text);
         if(isBind && PlayerManager.Instance.Self.BandMoney < this._unitPrice * count)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureHunting.tip2"));
            SharedManager.Instance.isRemindTreasureBind = true;
            return;
         }
         if(!isBind && PlayerManager.Instance.Self.Money < this._unitPrice * count)
         {
            LeavePageManager.showFillFrame();
            SharedManager.Instance.isRemindTreasureBind = true;
            return;
         }
         if(count == 1)
         {
            this._huntingBtn.enable = false;
            TreasureManager.instance.isMovieComplete = false;
            TreasureManager.instance.addMask();
         }
         TreasureManager.instance.closeTransactionFrame();
         SocketManager.Instance.out.sendPayForHunting(isBind,count);
         this.isClickMax = false;
         this._timesInput.text = 1 + "";
      }
      
      private function noAlertView(isSelected:Boolean) : void
      {
         SharedManager.Instance.isRemindTreasureBind = !isSelected;
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         var tmp:int = 0;
         this.removeAllItemLight();
         do
         {
            tmp = Math.floor(Math.random() * 16) as int;
         }
         while(tmp == this._ran);
         
         this._ran = tmp;
         this._itemArr[this._ran].selectedLight.visible = true;
         SoundManager.instance.play("203");
      }
      
      private function removeAllItemLight() : void
      {
         if(this._itemArr == null)
         {
            return;
         }
         for(var i:int = 0; i <= this._itemArr.length - 1; i++)
         {
            this._itemArr[i].selectedLight.visible = false;
         }
      }
      
      private function onTimerComplete(event:TimerEvent) : void
      {
         var indexArr:Array = TreasureManager.instance.lightIndexArr;
         this.removeAllItemLight();
         this._glint = ComponentFactory.Instance.creat("treasureHunting.GlintAsset");
         this._glint.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         var index:int = int(indexArr[0]);
         this._glint.scaleX = 1.3;
         this._glint.scaleY = 1.3;
         this._glint.x = this._itemList.x + this._itemArr[index].x + 10;
         this._glint.y = this._itemList.y + this._itemArr[index].y + 10;
         this._content.addChild(this._glint);
      }
      
      public function creatMoveCell(templateID:int) : void
      {
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,75,75);
         shape.graphics.endFill();
         var item:InventoryItemInfo = new InventoryItemInfo();
         item.TemplateID = templateID;
         item = ItemManager.fill(item);
         if(templateID == 11550)
         {
            this.luckStoneCell = new BaseCell(shape);
            this.luckStoneCell.info = item;
         }
         else
         {
            this.moveCell = new BaseCell(shape);
            this.moveCell.info = item;
         }
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var indexArr:Array = null;
         var index:int = 0;
         if(this._glint.currentFrame == this._glint.totalFrames)
         {
            this._glint.stop();
            this._glint.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this._content.removeChild(this._glint);
            this._glint = null;
            indexArr = TreasureManager.instance.lightIndexArr;
            index = int(indexArr[0]);
            this._itemArr[index].selectedLight.visible = true;
            SoundManager.instance.play("204");
            this._itemArr[index].addChild(this.moveCell);
            this.moveCell.visible = false;
            this.addMoveEffect(this.moveCell,582,67);
            if(Boolean(this.luckStoneCell))
            {
               this._itemArr[index].addChild(this.luckStoneCell);
               this.luckStoneCell.visible = false;
               this.addMoveEffect(this.luckStoneCell,625,488);
               this.luckStoneCell = null;
            }
            this._huntingBtn.enable = true;
         }
      }
      
      private function addMoveEffect($item:DisplayObject, targetX:int, targetY:int) : void
      {
         var tp:TweenProxy = null;
         var timeline:TimelineLite = null;
         var tw:TweenLite = null;
         var tw1:TweenLite = null;
         if(!$item)
         {
            return;
         }
         var tempBitmapD:BitmapData = new BitmapData($item.width,$item.height,true,0);
         tempBitmapD.draw($item);
         var bitmap:Bitmap = new Bitmap(tempBitmapD,"auto",true);
         addChild(bitmap);
         tp = TweenProxy.create(bitmap);
         tp.registrationX = tp.width / 2;
         tp.registrationY = tp.height / 2;
         var pos:Point = DisplayUtils.localizePoint(this,$item);
         tp.x = pos.x + tp.width / 2;
         tp.y = pos.y + tp.height / 2;
         timeline = new TimelineLite();
         timeline.vars.onComplete = this.twComplete;
         timeline.vars.onCompleteParams = [timeline,tp,bitmap];
         tw = new TweenLite(tp,0.4,{
            "x":targetX,
            "y":targetY
         });
         tw1 = new TweenLite(tp,0.4,{
            "scaleX":0.1,
            "scaleY":0.1
         });
         timeline.append(tw);
         timeline.append(tw1,-0.2);
      }
      
      private function twComplete(timeline:TimelineLite, tp:TweenProxy, bitmap:Bitmap) : void
      {
         if(Boolean(timeline))
         {
            timeline.kill();
         }
         if(Boolean(tp))
         {
            tp.destroy();
         }
         if(Boolean(bitmap.parent))
         {
            bitmap.parent.removeChild(bitmap);
            bitmap.bitmapData.dispose();
         }
         tp = null;
         bitmap = null;
         timeline = null;
         this.movieComplete();
      }
      
      private function movieComplete() : void
      {
         if(TreasureManager.instance.msgStr != "")
         {
            MessageTipManager.getInstance().show(TreasureManager.instance.countMsg);
            ChatManager.Instance.sysChatYellow(TreasureManager.instance.msgStr);
            TreasureManager.instance.countMsg = "";
            TreasureManager.instance.msgStr = "";
         }
         TreasureManager.instance.isMovieComplete = true;
         TreasureManager.instance.removeMask();
         TreasureManager.instance.dispatchEvent(new TreasureEvent(TreasureEvent.MOVIE_COMPLETE));
      }
      
      public function startTimer() : void
      {
         this._glintTimer.reset();
         this._glintTimer.start();
      }
      
      public function lightUpItemArr() : void
      {
         var index2:int = 0;
         var indexArr:Array = TreasureManager.instance.lightIndexArr;
         this.removeAllItemLight();
         for(var i:int = 0; i <= indexArr.length - 1; i++)
         {
            index2 = int(indexArr[i]);
            this._itemArr[index2].selectedLight.visible = true;
         }
         MessageTipManager.getInstance().show(TreasureManager.instance.countMsg);
         ChatManager.Instance.sysChatYellow(TreasureManager.instance.msgStr);
         TreasureManager.instance.countMsg = "";
         TreasureManager.instance.msgStr = "";
      }
      
      protected function _response(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            if(TreasureManager.instance.checkBag())
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("treasureHunting.alert.ensureGetAll"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alert.mouseEnabled = false;
               alert.addEventListener(FrameEvent.RESPONSE,this.onAlertResponse);
            }
            else
            {
               this.dispose();
            }
         }
      }
      
      private function onAlertResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onAlertResponse);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.getAllTreasure();
            this.dispose();
         }
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function __updateLastTime(event:CaddyEvent) : void
      {
         if(Boolean(this._lastTimeTxt))
         {
            this._lastTimeTxt.text = LanguageMgr.GetTranslation("treasureHunting.lastTimeTxt") + event.lastTime.replace(/:\d+$/g,"");
         }
      }
      
      private function __changeBadLuckNumber(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["BadLuckNumber"]))
         {
            if(PlayerManager.Instance.Self.badLuckNumber == 0)
            {
               this._myNumberTxt.text = PlayerManager.Instance.Self.badLuckNumber.toString();
            }
         }
      }
      
      protected function __updateInfo(event:CrazyTankSocketEvent) : void
      {
         this._myNumberTxt.text = PlayerManager.Instance.Self.badLuckNumber.toString();
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._showPrizeBtn))
         {
            this._showPrizeBtn.removeEventListener(MouseEvent.CLICK,this.onShowPrizeBtnClick);
         }
         if(Boolean(this._timesInput))
         {
            this._timesInput.removeEventListener(Event.CHANGE,this._change);
         }
         if(Boolean(this._huntingBtn))
         {
            this._huntingBtn.removeEventListener(MouseEvent.CLICK,this.onHuntingBtnClick);
         }
         if(Boolean(this._maxBtn))
         {
            this._maxBtn.removeEventListener(MouseEvent.CLICK,this.onMaxBtnClick);
         }
         if(Boolean(this._bagBtn))
         {
            this._bagBtn.removeEventListener(MouseEvent.CLICK,this.onBagBtnClick);
         }
         if(Boolean(this._recordBtn))
         {
            this._recordBtn.addEventListener(MouseEvent.CLICK,this.onRecordBtnClick);
         }
         RouletteManager.instance.removeEventListener(CaddyEvent.UPDATE_BADLUCK,this.__updateLastTime);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updateInfo);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeBadLuckNumber);
      }
      
      override public function dispose() : void
      {
         AddPublicTipManager.Instance.type = 0;
         this.removeEvents();
         TreasureManager.instance.dispose();
         if(Boolean(this._glintTimer))
         {
            this._glintTimer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._glintTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this._glintTimer = null;
         }
         if(Boolean(this._rankTimer))
         {
            this._rankTimer.removeEventListener(TimerEvent.TIMER,this.updateRank);
            this._rankTimer = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._treasureTitle))
         {
            ObjectUtils.disposeObject(this._treasureTitle);
         }
         this._treasureTitle = null;
         if(Boolean(this._timesTxt))
         {
            ObjectUtils.disposeObject(this._timesTxt);
         }
         this._timesTxt = null;
         if(Boolean(this._timesInput))
         {
            ObjectUtils.disposeObject(this._timesInput);
         }
         this._timesInput = null;
         if(Boolean(this._itemList))
         {
            ObjectUtils.disposeObject(this._itemList);
         }
         this._itemList = null;
         if(Boolean(this._showPrizeBtn))
         {
            ObjectUtils.disposeObject(this._showPrizeBtn);
         }
         this._showPrizeBtn = null;
         if(Boolean(this._huntingBtn))
         {
            ObjectUtils.disposeObject(this._huntingBtn);
         }
         this._huntingBtn = null;
         if(Boolean(this._maxBtn))
         {
            ObjectUtils.disposeObject(this._maxBtn);
         }
         this._maxBtn = null;
         if(Boolean(this._rankPrizeBtn))
         {
            ObjectUtils.disposeObject(this._rankPrizeBtn);
         }
         this._rankPrizeBtn = null;
         if(Boolean(this._bagBtn))
         {
            ObjectUtils.disposeObject(this._bagBtn);
         }
         this._bagBtn = null;
         if(Boolean(this._recordBtn))
         {
            ObjectUtils.disposeObject(this._recordBtn);
         }
         this._recordBtn = null;
         if(Boolean(this._luckyStoneBG))
         {
            ObjectUtils.disposeObject(this._luckyStoneBG);
         }
         this._luckyStoneBG = null;
         if(Boolean(this._bagView))
         {
            ObjectUtils.disposeObject(this._bagView);
         }
         this._bagView = null;
         if(Boolean(this._rankView))
         {
            ObjectUtils.disposeObject(this._rankView);
         }
         this._rankView = null;
         if(Boolean(this._recordView))
         {
            ObjectUtils.disposeObject(this._recordView);
         }
         this._recordView = null;
         if(Boolean(this._myNumberTxt))
         {
            ObjectUtils.disposeObject(this._myNumberTxt);
         }
         this._myNumberTxt = null;
         if(Boolean(this.moveCell))
         {
            ObjectUtils.disposeObject(this.moveCell);
         }
         this.moveCell = null;
         if(Boolean(this.luckStoneCell))
         {
            ObjectUtils.disposeObject(this.luckStoneCell);
         }
         this.luckStoneCell = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
         this._itemArr = null;
         super.dispose();
      }
      
      public function get huntingBtn() : BaseButton
      {
         return this._huntingBtn;
      }
      
      public function get bagView() : TreasureBagView
      {
         return this._bagView;
      }
   }
}

