package auctionHouse.view
{
   import bagAndInfo.bag.BagFrame;
   import bagAndInfo.cell.DragEffect;
   import beadSystem.beadSystemManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.MultipleLineTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import shop.view.NewShopBugleView;
   
   public class AuctionSellLeftView extends Sprite implements Disposeable
   {
      
      private var _bid_btn:BaseButton;
      
      private var _bidLight:Bitmap;
      
      private var _keep:FilterFrameText;
      
      private var _startMoney:FilterFrameText;
      
      private var _mouthfulM:FilterFrameText;
      
      private var name_txt:FilterFrameText;
      
      private var _selectRate:Number = 1;
      
      private var _bidTime1:SelectedCheckButton;
      
      private var _bidTime2:SelectedCheckButton;
      
      private var _bidTime3:SelectedCheckButton;
      
      private var _sellLoudBtn:SelectedCheckButton;
      
      private var _sellLoudBtnTxt:FilterFrameText;
      
      private var _currentTime:SelectedButton;
      
      private var _cellsItems:Vector.<AuctionCellView>;
      
      private var _cell:AuctionCellView;
      
      private var _dragArea:AuctionDragInArea;
      
      private var _bag:BagFrame;
      
      private var _cellGoodsID:int;
      
      private var _auctionObjectBg:BaseButton;
      
      private var _auctionObject:Sprite;
      
      private var _selectObjectTip:MultipleLineTip;
      
      private var _auctionObjectFrame:int = 0;
      
      private var _lowestPrice:Number;
      
      private var _selectCheckBtn:SelectedCheckButton;
      
      private var _cellShowTipAble:Boolean = false;
      
      private var _shopBugle:NewShopBugleView;
      
      public function AuctionSellLeftView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var bg:MutipleImage = ComponentFactory.Instance.creat("auctionHouse.LeftBG2");
         addChild(bg);
         var _Sellbg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauction.Sellbg");
         addChild(_Sellbg);
         _Sellbg.y = 57;
         var _Sellbg1:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauction.Sellbg");
         addChild(_Sellbg1);
         _Sellbg1.y = 302;
         var _SellItembg:MovieImage = ComponentFactory.Instance.creatComponentByStylename("ddtauction.sellItemBG1");
         addChild(_SellItembg);
         var _SellItembg1:MovieImage = ComponentFactory.Instance.creatComponentByStylename("ddtauction.sellItemBG2");
         addChild(_SellItembg1);
         var _textInputBg:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("ddtauction.sellItemBG3");
         addChild(_textInputBg);
         var _textInputBg1:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("ddtauction.sellItemBG4");
         addChild(_textInputBg1);
         var _Selltext:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellViewTextI");
         _Selltext.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.text");
         addChild(_Selltext);
         var _Selltext1:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellViewTextII");
         _Selltext1.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.text1");
         addChild(_Selltext1);
         var _Selltext2:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellViewTextIII");
         _Selltext2.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.text2");
         addChild(_Selltext2);
         var _Selltext3:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellViewTextIIII");
         _Selltext3.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.text3");
         addChild(_Selltext3);
         var _Selltext4:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellViewTextIIIII");
         _Selltext4.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.text4");
         addChild(_Selltext4);
         var _timerText:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellViewtimerTextI");
         _timerText.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.timer8");
         addChild(_timerText);
         var _timerText1:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellViewtimerTextII");
         _timerText1.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.timer24");
         addChild(_timerText1);
         var _timerText2:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellViewtimerTextIII");
         _timerText2.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.timer48");
         addChild(_timerText2);
         var _helpText:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellViewhelpText");
         _helpText.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.view.text5");
         addChild(_helpText);
         var icon0:MutipleImage = ComponentFactory.Instance.creat("auctionHouse.SellLeftIcon0");
         addChild(icon0);
         var icon1:MutipleImage = ComponentFactory.Instance.creat("auctionHouse.SellLeftIcon1");
         addChild(icon1);
         var icon2:MutipleImage = ComponentFactory.Instance.creat("auctionHouse.SellLeftIcon2");
         addChild(icon2);
         this._bid_btn = ComponentFactory.Instance.creat("auctionHouse.StartBid_btn");
         this._bid_btn.enable = false;
         addChild(this._bid_btn);
         this._bidLight = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.StartBidLightbtn");
         this._bidLight.visible = false;
         addChild(this._bidLight);
         this._keep = ComponentFactory.Instance.creat("auctionHouse.SellkeepText");
         addChild(this._keep);
         this._startMoney = ComponentFactory.Instance.creat("auctionHouse.startMoneyText");
         addChild(this._startMoney);
         this._mouthfulM = ComponentFactory.Instance.creat("auctionHouse.mouthfulText");
         addChild(this._mouthfulM);
         this._keep.restrict = this._startMoney.restrict = this._mouthfulM.restrict = "0-9";
         this._startMoney.maxChars = this._mouthfulM.maxChars = 9;
         this.name_txt = ComponentFactory.Instance.creat("auctionHouse.NameText");
         this._bidTime1 = ComponentFactory.Instance.creat("auctionHouse.bidTime1_btn");
         addChild(this._bidTime1);
         this._bidTime2 = ComponentFactory.Instance.creat("auctionHouse.bidTime2_btn");
         addChild(this._bidTime2);
         this._bidTime3 = ComponentFactory.Instance.creat("auctionHouse.bidTime3_btn");
         addChild(this._bidTime3);
         this._currentTime = this._bidTime1;
         this._selectRate = 1;
         this._sellLoudBtn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellLouderBtn");
         this._sellLoudBtnTxt = ComponentFactory.Instance.creat("asset.auctionHouse.sellLouderBtnTxt");
         this._sellLoudBtnTxt.text = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.fastAuction");
         this._sellLoudBtn.addChild(this._sellLoudBtnTxt);
         addChild(this._sellLoudBtn);
         this._cellsItems = new Vector.<AuctionCellView>();
         this._cell = ComponentFactory.Instance.creatCustomObject("auctionHouse.AuctionCellView");
         this._cell.buttonMode = true;
         this._cellsItems.push(this._cell);
         this._auctionObject = new Sprite();
         this._auctionObjectBg = ComponentFactory.Instance.creat("auctionHouse.auctionObjCell");
         this._auctionObjectBg.alpha = 0;
         this._auctionObject.addChild(this._auctionObjectBg);
         this._auctionObject.addChild(this.name_txt);
         addChild(this._auctionObject);
         addChild(this._cell);
         this._selectObjectTip = ComponentFactory.Instance.creatCustomObject("auctionHouse.SellSelectedBtn");
         this._selectObjectTip.tipData = LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.Choose");
         this._selectObjectTip.mouseChildren = false;
         this._selectObjectTip.mouseEnabled = false;
         this._dragArea = new AuctionDragInArea(this._cellsItems);
         addChildAt(this._dragArea,0);
         this._bag = ComponentFactory.Instance.creat("auctionHouse.view.GoodsBagFrame");
         this._bag.titleText = LanguageMgr.GetTranslation("tank.auctionHouse.view.BagFrame.Choose");
         this._bag.moveEnable = true;
         this._bag.bagView.cellDoubleClickEnable = false;
         this.clear();
      }
      
      private function addEvent() : void
      {
         this._cell.addEventListener(AuctionCellView.SELECT_BID_GOOD,this.__setBidGood);
         this._cell.addEventListener(Event.CHANGE,this.__selectGood);
         this._bid_btn.addEventListener(MouseEvent.CLICK,this.__startBid);
         this._bid_btn.addEventListener(MouseEvent.MOUSE_OVER,this.__bid_btnOver);
         this._bid_btn.addEventListener(MouseEvent.MOUSE_OUT,this.__bid_btnOut);
         this._startMoney.addEventListener(Event.CHANGE,this.__change);
         this._mouthfulM.addEventListener(Event.CHANGE,this.__change);
         this._startMoney.addEventListener(TextEvent.TEXT_INPUT,this.__textInput);
         this._mouthfulM.addEventListener(TextEvent.TEXT_INPUT,this.__textInputMouth);
         this._auctionObject.addEventListener(MouseEvent.CLICK,this._onAuctionObjectClicked);
         this._cell.addEventListener(AuctionCellView.CELL_MOUSEOVER,this._onAuctionObjectOver);
         this._cell.addEventListener(AuctionCellView.CELL_MOUSEOUT,this._onAuctionObjectOut);
         this._bidTime1.addEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bidTime2.addEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bidTime3.addEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bag.addEventListener(CellEvent.DRAGSTART,this.__startShine);
         this._bag.addEventListener(CellEvent.DRAGSTOP,this.__stopShine);
         this._bag.addEventListener(CellEvent.BAG_CLOSE,this.__CellstartShine);
      }
      
      private function __selectBidTimeII(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this.selectBidUpdate(evt.currentTarget as SelectedButton);
      }
      
      private function selectBidUpdate(button:SelectedButton) : void
      {
         if(this._currentTime != button)
         {
            this._currentTime.selected = false;
         }
         if(Boolean(button))
         {
            switch(button.name)
            {
               case this._bidTime1.name:
                  this._currentTime = this._bidTime1;
                  this._selectRate = 1;
                  SoundManager.instance.play("008");
                  break;
               case this._bidTime2.name:
                  this._currentTime = this._bidTime2;
                  this._selectRate = 2;
                  SoundManager.instance.play("008");
                  break;
               case this._bidTime3.name:
                  this._currentTime = this._bidTime3;
                  this._selectRate = 3;
                  SoundManager.instance.play("008");
                  break;
               default:
                  this._currentTime = this._bidTime1;
                  this._selectRate = 1;
            }
         }
         else
         {
            this._currentTime = this._bidTime1;
            this._selectRate = 1;
         }
         if(Boolean(this._currentTime))
         {
            this._currentTime.selected = true;
         }
         this.update();
      }
      
      private function removeEvent() : void
      {
         this._cell.removeEventListener(AuctionCellView.SELECT_BID_GOOD,this.__setBidGood);
         this._cell.removeEventListener(Event.CHANGE,this.__selectGood);
         this._bid_btn.removeEventListener(MouseEvent.CLICK,this.__startBid);
         this._bid_btn.removeEventListener(MouseEvent.MOUSE_OVER,this.__bid_btnOver);
         this._bid_btn.removeEventListener(MouseEvent.MOUSE_OUT,this.__bid_btnOut);
         this._startMoney.removeEventListener(Event.CHANGE,this.__change);
         this._mouthfulM.removeEventListener(Event.CHANGE,this.__change);
         this._startMoney.removeEventListener(TextEvent.TEXT_INPUT,this.__textInput);
         this._mouthfulM.removeEventListener(TextEvent.TEXT_INPUT,this.__textInputMouth);
         this._auctionObject.removeEventListener(MouseEvent.CLICK,this._onAuctionObjectClicked);
         this._cell.removeEventListener(AuctionCellView.CELL_MOUSEOVER,this._onAuctionObjectOver);
         this._cell.removeEventListener(AuctionCellView.CELL_MOUSEOUT,this._onAuctionObjectOut);
         this._bidTime1.removeEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bidTime2.removeEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bidTime3.removeEventListener(MouseEvent.CLICK,this.__selectBidTimeII);
         this._bag.removeEventListener(CellEvent.DRAGSTART,this.__startShine);
         this._bag.removeEventListener(CellEvent.DRAGSTOP,this.__stopShine);
         this._bag.removeEventListener(CellEvent.BAG_CLOSE,this.__startShine);
      }
      
      internal function addStage() : void
      {
         this._currentTime = this._bidTime1;
         this._selectRate = 1;
         this.update();
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         this._cell.dragDrop(effect);
      }
      
      internal function clear() : void
      {
         this.name_txt.text = "";
         this._startMoney.text = "";
         this._mouthfulM.text = "";
         this._keep.text = "";
         if(Boolean(this._cell.getSource()) && Boolean(this._cell.info))
         {
            this._cell.clearLinkCell();
         }
         this._startMoney.mouseEnabled = false;
         this._mouthfulM.mouseEnabled = false;
         this.__selectBidTimeII(new MouseEvent(MouseEvent.CLICK));
         this.__stopShine(null);
      }
      
      internal function hideReady() : void
      {
         this._bag.hide();
      }
      
      public function openBagFrame() : void
      {
         this._bag.show();
      }
      
      private function update() : void
      {
         this._keep.text = this.getKeep();
      }
      
      private function getRate() : int
      {
         return this._selectRate;
      }
      
      private function getKeep() : String
      {
         if(this._selectRate == 1)
         {
            return "100";
         }
         if(this._selectRate == 2)
         {
            return "200";
         }
         if(this._selectRate == 3)
         {
            return "300";
         }
         return "100";
      }
      
      private function _onAuctionObjectClicked(evt:Event) : void
      {
         this._auctionObject.mouseChildren = false;
         this._auctionObject.mouseEnabled = false;
         if(Boolean(this._cell.info) && Boolean(this._bag.parent))
         {
            this._cell.onObjectClicked();
            return;
         }
         this.__setBidGood(null);
      }
      
      private function _onAuctionObjectOver(evt:Event) : void
      {
         if(this._cell.info == null)
         {
            this._selectObjectTip.x = localToGlobal(new Point(this._auctionObject.x + this._auctionObject.width / 2,this._auctionObject.y + this._auctionObject.height)).x + 10;
            this._selectObjectTip.y = localToGlobal(new Point(this._auctionObject.x + this._auctionObject.width / 2,this._auctionObject.y + this._auctionObject.height)).y + this._auctionObject.height - 5;
            LayerManager.Instance.addToLayer(this._selectObjectTip,LayerManager.GAME_TOP_LAYER);
         }
         this._auctionObjectBg.alpha = 1;
      }
      
      private function _onAuctionObjectOut(evt:Event) : void
      {
         if(Boolean(this._selectObjectTip.parent))
         {
            this._selectObjectTip.parent.removeChild(this._selectObjectTip);
         }
         this._auctionObjectBg.alpha = 0;
      }
      
      private function __setBidGood(event:Event) : void
      {
         if(Boolean(this._cell) && Boolean(this._cell.info))
         {
            this._cellGoodsID = this._cell.info.TemplateID;
         }
         if(!this._cell.info || !this._bag.parent)
         {
            this.openBagFrame();
            SoundManager.instance.play("047");
         }
         this.__stopShine(null);
      }
      
      private function __CellstartShine(e:CellEvent) : void
      {
         if(this._cell.info != null)
         {
            return;
         }
         this._auctionObject.addEventListener(Event.ENTER_FRAME,this._auctionObjectflash);
      }
      
      private function __startShine(e:CellEvent) : void
      {
         this._auctionObject.addEventListener(Event.ENTER_FRAME,this._auctionObjectflash);
      }
      
      private function __stopShine(e:CellEvent) : void
      {
         this._auctionObject.removeEventListener(Event.ENTER_FRAME,this._auctionObjectflash);
         this._auctionObjectBg.alpha = 0;
         this._auctionObjectFrame = 0;
      }
      
      private function _auctionObjectflash(e:Event) : void
      {
         this._auctionObjectFrame += 1;
         if(this._auctionObjectFrame == 6)
         {
            this._auctionObjectBg.alpha = 1;
         }
         else if(this._auctionObjectFrame == 12)
         {
            this._auctionObjectBg.alpha = 0;
            this._auctionObjectFrame = 0;
         }
      }
      
      private function __selectGood(event:Event) : void
      {
         if(Boolean(this._cell.info))
         {
            this.initInfo();
         }
         else
         {
            this.clear();
            this._bid_btn.enable = false;
         }
      }
      
      private function initInfo() : void
      {
         var obj:Object = null;
         if(EquipType.isBead(int(this._cell.info.Property1)))
         {
            this.name_txt.text = beadSystemManager.Instance.getBeadName(this._cell.itemInfo);
         }
         else
         {
            this.name_txt.text = this._cell.info.Name;
         }
         this._startMoney.mouseEnabled = true;
         if(!isNaN(this._cell.info.FloorPrice))
         {
            this._startMoney.text = String(this._lowestPrice = this._cell.goodsCount * this._cell.info.FloorPrice);
         }
         this._mouthfulM.mouseEnabled = true;
         this._bid_btn.enable = true;
         if(SharedManager.Instance.AuctionInfos != null && SharedManager.Instance.AuctionInfos[this._cell.info.Name] != null)
         {
            obj = SharedManager.Instance.AuctionInfos[this._cell.info.Name];
            if(obj.itemType != this._cell.info.Data || obj.itemLevel != this._cell.info.Level)
            {
               this.selectBidUpdate(null);
               return;
            }
            if(Boolean(obj))
            {
               this._mouthfulM.text = obj.mouthfulPrice == 0 ? "" : obj.mouthfulPrice;
               if(Number(obj.startPrice) > Number(this._startMoney.text))
               {
                  this._startMoney.text = obj.startPrice;
               }
               switch(obj.time)
               {
                  case 0:
                     this.selectBidUpdate(this._bidTime1);
                     break;
                  case 1:
                     this.selectBidUpdate(this._bidTime2);
                     break;
                  case 2:
                     this.selectBidUpdate(this._bidTime3);
                     break;
                  default:
                     this.selectBidUpdate(this._bidTime1);
               }
            }
         }
         else
         {
            this.selectBidUpdate(null);
         }
      }
      
      private function __bid_btnOver(e:MouseEvent) : void
      {
         this._bidLight.visible = true;
      }
      
      private function __bid_btnOut(e:MouseEvent) : void
      {
         this._bidLight.visible = false;
      }
      
      private function __startBid(event:MouseEvent) : void
      {
         var alert1:BaseAlerFrame = null;
         SoundManager.instance.play("047");
         if(this._sellLoudBtn.selected)
         {
            if(SharedManager.Instance.isAuctionHouseTodayUseBugle)
            {
               if(this._selectCheckBtn == null)
               {
                  this._selectCheckBtn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.noMoraAlert");
                  this._selectCheckBtn.text = LanguageMgr.GetTranslation("dice.alert.nextPrompt");
               }
               alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.UseBugle"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               alert1.moveEnable = false;
               alert1.addChild(this._selectCheckBtn);
               alert1.addEventListener(FrameEvent.RESPONSE,function(e:FrameEvent):void
               {
                  if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
                  {
                     if(_selectCheckBtn.selected)
                     {
                        SharedManager.Instance.isAuctionHouseTodayUseBugle = !_selectCheckBtn.selected;
                     }
                     sendFastAuctionBugle();
                  }
                  alert1.dispose();
                  _selectCheckBtn.dispose();
                  _selectCheckBtn = null;
               });
            }
            else
            {
               this.autionFunc();
            }
         }
         else
         {
            this.autionFunc();
         }
      }
      
      public function sendFastAuctionBugle(type:int = 11101) : void
      {
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(type,true) <= 0)
         {
            if(!this._shopBugle || !this._shopBugle.info)
            {
               this._shopBugle = new NewShopBugleView(type);
            }
            else if(this._shopBugle.type != type)
            {
               this._shopBugle.dispose();
               this._shopBugle = null;
               this._shopBugle = new NewShopBugleView(type);
            }
         }
         else
         {
            this.autionFunc();
         }
      }
      
      private function _responseV(evt:FrameEvent) : void
      {
         var _quick:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            _quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _quick.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function auctionGood() : void
      {
         var bagType:int = 0;
         var place:int = 0;
         var price:int = 0;
         var mouthful:int = 0;
         var validTime:int = 0;
         var goodsCount:int = 0;
         var obj:Object = null;
         if(Boolean(this._cell.info))
         {
            bagType = (this._cell.info as InventoryItemInfo).BagType;
            place = (this._cell.info as InventoryItemInfo).Place;
            price = Math.floor(Number(this._startMoney.text));
            mouthful = this._mouthfulM.text == "" ? 0 : int(Math.floor(Number(this._mouthfulM.text)));
            validTime = this._selectRate - 1;
            goodsCount = this._cell.goodsCount;
            SocketManager.Instance.out.auctionGood(bagType,place,1,price,mouthful,validTime,goodsCount,this._sellLoudBtn.selected);
            obj = {};
            obj.itemName = this._cell.info.Name;
            obj.itemType = this._cell.info.Data;
            obj.itemLevel = this._cell.info.Level;
            obj.startPrice = price;
            obj.mouthfulPrice = mouthful;
            obj.time = validTime;
            SharedManager.Instance.AuctionInfos[this._cell.info.Name] = obj;
            SharedManager.Instance.save();
         }
         this.selectBidUpdate(null);
         this._startMoney.stage.focus = null;
         this._mouthfulM.stage.focus = null;
      }
      
      private function autionFunc() : void
      {
         var alert:BaseAlerFrame = null;
         if(!this._cell.info)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.ChooseTwo"));
            return;
         }
         if(this._startMoney.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.Price"));
            return;
         }
         if(this._mouthfulM.text != "" || this._startMoney.text != "")
         {
            if(Number(this._startMoney.text) < this._lowestPrice || Number(this._startMoney.text) <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.Lowest",String(this._lowestPrice)));
               return;
            }
            if(StringUtils.trim(this._mouthfulM.text) != "" && Number(this._startMoney.text) >= Number(this._mouthfulM.text))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.PriceTwo"));
               return;
            }
         }
         if(Number(this._keep.text) > PlayerManager.Instance.Self.Gold)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseV);
            return;
         }
         this.auctionGood();
      }
      
      private function __change(event:Event) : void
      {
         if(Number(this._startMoney.text) == 0)
         {
            this._startMoney.text = "";
         }
         this.update();
      }
      
      private function __textInput(event:TextEvent) : void
      {
         if(Number(this._keep.text) + Number(event.text) == 0)
         {
            if(this._keep.selectedText.length <= 0)
            {
               event.preventDefault();
            }
         }
      }
      
      private function __textInputMouth(event:TextEvent) : void
      {
         var txt:TextField = event.target as TextField;
         if(Number(txt.text) + Number(event.text) == 0)
         {
            if(txt.selectedText.length <= 0)
            {
               event.preventDefault();
            }
         }
      }
      
      private function __timeChange(event:Event) : void
      {
         this.update();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._cellsItems = null;
         if(Boolean(this._dragArea))
         {
            ObjectUtils.disposeObject(this._dragArea);
         }
         this._dragArea = null;
         if(Boolean(this._bid_btn))
         {
            ObjectUtils.disposeObject(this._bid_btn);
         }
         this._bid_btn = null;
         if(Boolean(this._keep))
         {
            ObjectUtils.disposeObject(this._keep);
         }
         this._keep = null;
         if(Boolean(this._startMoney))
         {
            ObjectUtils.disposeObject(this._startMoney);
         }
         this._startMoney = null;
         if(Boolean(this._mouthfulM))
         {
            ObjectUtils.disposeObject(this._mouthfulM);
         }
         this._mouthfulM = null;
         if(Boolean(this._bag))
         {
            ObjectUtils.disposeObject(this._bag);
         }
         this._bag = null;
         if(Boolean(this.name_txt))
         {
            ObjectUtils.disposeObject(this.name_txt);
         }
         this.name_txt = null;
         if(Boolean(this._selectObjectTip))
         {
            ObjectUtils.disposeObject(this._selectObjectTip);
         }
         this._selectObjectTip = null;
         if(Boolean(this._auctionObject))
         {
            ObjectUtils.disposeObject(this._auctionObject);
         }
         this._auctionObject = null;
         if(Boolean(this._bidTime1))
         {
            ObjectUtils.disposeObject(this._bidTime1);
         }
         this._bidTime1 = null;
         if(Boolean(this._bidTime2))
         {
            ObjectUtils.disposeObject(this._bidTime1);
         }
         this._bidTime2 = null;
         if(Boolean(this._bidTime3))
         {
            ObjectUtils.disposeObject(this._bidTime1);
         }
         this._bidTime3 = null;
         if(Boolean(this._currentTime))
         {
            ObjectUtils.disposeObject(this._bidTime1);
         }
         this._currentTime = null;
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(Boolean(this._auctionObjectBg))
         {
            ObjectUtils.disposeObject(this._auctionObjectBg);
         }
         this._auctionObjectBg = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

