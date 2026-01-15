package chickActivation.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import battleGroud.BattleGroudManager;
   import chickActivation.ChickActivationManager;
   import chickActivation.data.ChickActivationInfo;
   import chickActivation.event.ChickActivationEvent;
   import chickActivation.model.ChickActivationModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.DropGoodsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import shop.view.ShopPlayerCell;
   
   public class ChickActivationViewFrame extends Frame
   {
      
      private var _mainBg:Bitmap;
      
      private var _mainTitle:Bitmap;
      
      private var _helpTitle:Bitmap;
      
      private var _helpPanel:ScrollPanel;
      
      private var _helpTxt:FilterFrameText;
      
      private var _remainingTimeTxt:FilterFrameText;
      
      private var _group:SelectedButtonGroup;
      
      private var _selectBtn1:SelectedTextButton;
      
      private var _selectBtn2:SelectedTextButton;
      
      private var _groupTwo:SelectedButtonGroup;
      
      private var _selectEveryDay:SelectedButton;
      
      private var _selectWeekly:SelectedButton;
      
      private var _selectAfterThreeDays:SelectedButton;
      
      private var _selectLevelPacks:SelectedButton;
      
      private var _promptMovies:Array;
      
      private var _priceBitmap:Bitmap;
      
      private var _priceView:ChickActivationCoinsView;
      
      private var _moneyIcon:Bitmap;
      
      private var _lineBitmap1:Bitmap;
      
      private var _inputBg:Bitmap;
      
      private var _inputTxt:FilterFrameText;
      
      private var _activationBtn:BaseButton;
      
      private var _lineBitmap2:Bitmap;
      
      private var _receiveBtn:BaseButton;
      
      private var _levelPacks:ChickActivationLevelPacks;
      
      private var _ativationItems:ChickActivationItems;
      
      private var _clickRate:Number = 0;
      
      private var CHICKACTIVATION_CARDID:int = 201316;
      
      private var buyItemInfo:ShopItemInfo;
      
      public function ChickActivationViewFrame()
      {
         super();
         this.initView();
         this.updateView();
         this.tabHandler();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var promptMovie:MovieClip = null;
         this._mainBg = ComponentFactory.Instance.creatBitmap("assets.chickActivation.mainBg");
         addToContent(this._mainBg);
         this._mainTitle = ComponentFactory.Instance.creatBitmap("assets.chickActivation.mainTitle");
         addToContent(this._mainTitle);
         this._helpTitle = ComponentFactory.Instance.creatBitmap("assets.chickActivation.helpTitle");
         addToContent(this._helpTitle);
         this._helpPanel = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.helpScroll");
         addToContent(this._helpPanel);
         this._helpTxt = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.helpTxt");
         this._helpTxt.text = LanguageMgr.GetTranslation("tank.chickActivationFrame.helpTxtMsg");
         this._helpPanel.setView(this._helpTxt);
         this._helpPanel.invalidateViewport();
         this._remainingTimeTxt = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.remainingTimeTxt");
         this._remainingTimeTxt.htmlText = LanguageMgr.GetTranslation("tank.chickActivationFrame.remainingTimeTxtMsg",0);
         addToContent(this._remainingTimeTxt);
         this._selectBtn1 = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectBtn1");
         this._selectBtn1.text = LanguageMgr.GetTranslation("tank.chickActivationFrame.selectBtn1Txt");
         addToContent(this._selectBtn1);
         this._selectBtn2 = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectBtn2");
         this._selectBtn2.text = LanguageMgr.GetTranslation("tank.chickActivationFrame.selectBtn2Txt");
         addToContent(this._selectBtn2);
         this._group = new SelectedButtonGroup();
         this._group.addSelectItem(this._selectBtn1);
         this._group.addSelectItem(this._selectBtn2);
         this._group.selectIndex = 0;
         this._selectEveryDay = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectEveryDay");
         addToContent(this._selectEveryDay);
         this._selectWeekly = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectWeekly");
         addToContent(this._selectWeekly);
         this._selectAfterThreeDays = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectAfterThreeDays");
         addToContent(this._selectAfterThreeDays);
         this._selectLevelPacks = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.selectLevelPacks");
         addToContent(this._selectLevelPacks);
         this._groupTwo = new SelectedButtonGroup();
         this._groupTwo.addSelectItem(this._selectEveryDay);
         this._groupTwo.addSelectItem(this._selectWeekly);
         this._groupTwo.addSelectItem(this._selectAfterThreeDays);
         this._groupTwo.addSelectItem(this._selectLevelPacks);
         this._groupTwo.selectIndex = 0;
         this._promptMovies = [];
         for(var k:int = 0; k < 4; k++)
         {
            promptMovie = ClassUtils.CreatInstance("assets.chickActivation.promptMovie");
            PositionUtils.setPos(promptMovie,"chickActivation.promptMoviePos" + k);
            promptMovie.mouseChildren = false;
            promptMovie.mouseEnabled = false;
            promptMovie.visible = false;
            addToContent(promptMovie);
            this._promptMovies.push(promptMovie);
         }
         this._priceBitmap = ComponentFactory.Instance.creatBitmap("assets.chickActivation.priceBitmap");
         addToContent(this._priceBitmap);
         this._priceView = ComponentFactory.Instance.creatCustomObject("chickActivation.ChickActivationCoinsView");
         this._priceView.count = 0;
         addToContent(this._priceView);
         this._moneyIcon = ComponentFactory.Instance.creatBitmap("assets.chickActivation.moneyIcon");
         addToContent(this._moneyIcon);
         this._lineBitmap1 = ComponentFactory.Instance.creatBitmap("assets.chickActivation.lineBitmap");
         PositionUtils.setPos(this._lineBitmap1,"chickActivation.lineBitmapPos1");
         addToContent(this._lineBitmap1);
         this._inputBg = ComponentFactory.Instance.creatBitmap("assets.chickActivation.inputBg");
         addToContent(this._inputBg);
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("chickActivation.inputTxt");
         this._inputTxt.text = LanguageMgr.GetTranslation("tank.chickActivation.inputTxtMsg");
         addToContent(this._inputTxt);
         this._activationBtn = ComponentFactory.Instance.creatComponentByStylename("chickActivation.activationBtn");
         addToContent(this._activationBtn);
         this._lineBitmap2 = ComponentFactory.Instance.creatBitmap("assets.chickActivation.lineBitmap");
         PositionUtils.setPos(this._lineBitmap2,"chickActivation.lineBitmapPos2");
         addToContent(this._lineBitmap2);
         this._receiveBtn = ComponentFactory.Instance.creatComponentByStylename("chickActivation.receiveBtn");
         addToContent(this._receiveBtn);
         this._ativationItems = ComponentFactory.Instance.creatCustomObject("chickActivation.ativationItems");
         addToContent(this._ativationItems);
         this._levelPacks = ComponentFactory.Instance.creatCustomObject("chickActivation.ChickActivationLevelPacks");
         this._levelPacks.visible = false;
         addToContent(this._levelPacks);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._group.addEventListener(Event.CHANGE,this.__selectBtnHandler);
         this._groupTwo.addEventListener(Event.CHANGE,this.__selectBtnTwoHandler);
         this._inputTxt.addEventListener(MouseEvent.CLICK,this.__inputTxtHandler);
         this._activationBtn.addEventListener(MouseEvent.CLICK,this.__activationBtnHandler);
         this._receiveBtn.addEventListener(MouseEvent.CLICK,this.__receiveBtnHandler);
         this._levelPacks.addEventListener(ChickActivationEvent.CLICK_LEVELPACKS,this.__clickLevelPacksHandler);
         ChickActivationManager.instance.model.addEventListener(ChickActivationEvent.UPDATE_DATA,this.__updateDataHandler);
         ChickActivationManager.instance.model.addEventListener(ChickActivationEvent.GET_REWARD,this.__getRewardHandler);
      }
      
      private function __updateDataHandler(evt:ChickActivationEvent) : void
      {
         this.updateView();
      }
      
      private function updateView() : void
      {
         var model:ChickActivationModel = ChickActivationManager.instance.model;
         var day:int = ChickActivationManager.instance.model.getRemainingDay();
         if(PlayerManager.Instance.Self.Grade > 15 && model.keyOpenedType != 1 || model.keyOpenedType == 1 && day <= 0)
         {
            this._selectBtn1.enable = false;
            this._group.selectIndex = 1;
         }
         this._remainingTimeTxt.htmlText = LanguageMgr.GetTranslation("tank.chickActivationFrame.remainingTimeTxtMsg",day);
         this.updateShine();
         this.updateGetBtn();
         this._levelPacks.update();
         this.showBottomActivationButton();
      }
      
      private function updateShine() : void
      {
         var tempIndex:int = 0;
         var temp3:Boolean = false;
         var day:int = 0;
         var value1:int = 0;
         var temp1:Boolean = false;
         var temp2:Boolean = false;
         var value2:int = 0;
         var levelIndex:int = 0;
         var grade:int = 0;
         var i:int = 0;
         var j:int = 0;
         var value3:Boolean = false;
         var a:int = 0;
         var gainArr:Array = ChickActivationManager.instance.model.gainArr;
         var remainingDay:int = ChickActivationManager.instance.model.getRemainingDay();
         if(ChickActivationManager.instance.model.isKeyOpened > 0 && ChickActivationManager.instance.model.keyOpenedType == this._group.selectIndex + 1 && remainingDay > 0)
         {
            if(Boolean(gainArr) && gainArr.length > 0)
            {
               day = TimeManager.Instance.Now().day;
               if(day == 0)
               {
                  day = 7;
               }
               tempIndex = day - 1;
               value1 = int(gainArr[tempIndex]);
               if(value1 <= 0)
               {
                  temp1 = true;
               }
               MovieClip(this._promptMovies[0]).visible = temp1;
               MovieClip(this._promptMovies[1]).visible = gainArr[10] <= 0;
               if(day == 5)
               {
                  tempIndex = 7;
               }
               else if(day == 6)
               {
                  tempIndex = 8;
               }
               else if(day == 7)
               {
                  tempIndex = 9;
               }
               if(tempIndex > 6)
               {
                  value2 = int(gainArr[tempIndex]);
                  if(value2 <= 0)
                  {
                     temp2 = true;
                  }
               }
               MovieClip(this._promptMovies[2]).visible = temp2;
               if(this._group.selectIndex == 0)
               {
                  levelIndex = -1;
                  grade = PlayerManager.Instance.Self.Grade;
                  for(i = 0; i < this._levelPacks.packsLevelArr.length; i++)
                  {
                     if(this._levelPacks.packsLevelArr[i].level <= grade)
                     {
                        levelIndex = i;
                     }
                  }
                  if(levelIndex == -1)
                  {
                     MovieClip(this._promptMovies[3]).visible = false;
                  }
                  for(j = 0; j <= levelIndex; j++)
                  {
                     value3 = ChickActivationManager.instance.model.getGainLevel(j + 1);
                     if(!value3)
                     {
                        temp3 = true;
                        break;
                     }
                  }
                  MovieClip(this._promptMovies[3]).visible = temp3;
               }
               else
               {
                  MovieClip(this._promptMovies[3]).visible = false;
               }
            }
         }
         else
         {
            for(a = 0; a < this._promptMovies.length; a++)
            {
               MovieClip(this._promptMovies[a]).visible = false;
            }
         }
      }
      
      private function updateGetBtn() : void
      {
         var gainArr:Array = null;
         var tempIndex:int = 0;
         var temp:int = 0;
         var remainingDay:int = ChickActivationManager.instance.model.getRemainingDay();
         if(ChickActivationManager.instance.model.isKeyOpened > 0 && ChickActivationManager.instance.model.keyOpenedType == this._group.selectIndex + 1 && remainingDay > 0)
         {
            gainArr = ChickActivationManager.instance.model.gainArr;
            tempIndex = this.getNowGainArrIndex();
            if(gainArr.hasOwnProperty(tempIndex))
            {
               temp = int(gainArr[tempIndex]);
               if(temp > 0)
               {
                  this._receiveBtn.enable = false;
               }
               else
               {
                  this._receiveBtn.enable = true;
               }
            }
            else
            {
               this._receiveBtn.enable = false;
            }
         }
         else
         {
            this._receiveBtn.enable = false;
         }
      }
      
      private function getNowGainArrIndex() : int
      {
         var day:int = TimeManager.Instance.Now().day;
         var tempIndex:int = -1;
         if(day == 0)
         {
            day = 7;
         }
         if(this._groupTwo.selectIndex == 0)
         {
            tempIndex = day - 1;
         }
         else if(this._groupTwo.selectIndex == 2)
         {
            if(day == 5)
            {
               tempIndex = 7;
            }
            else if(day == 6)
            {
               tempIndex = 8;
            }
            else if(day == 7)
            {
               tempIndex = 9;
            }
         }
         else if(this._groupTwo.selectIndex == 1)
         {
            tempIndex = 10;
         }
         return tempIndex;
      }
      
      private function __getRewardHandler(evt:ChickActivationEvent) : void
      {
         var value:int = evt.resultData as int;
         if(value == 11)
         {
            return;
         }
         var qualityKey:String = "" + (ChickActivationManager.instance.model.keyOpenedType - 1);
         var keyOpenedType:int = ChickActivationManager.instance.model.keyOpenedType;
         if(value < 7)
         {
            qualityKey += ",0,1";
         }
         else if(value < 10)
         {
            qualityKey += ",2,5";
         }
         else if(value < 11)
         {
            qualityKey += ",1";
         }
         var qualityValue:int = int(ChickActivationManager.instance.model.qualityDic[qualityKey]);
         var arr:Array = ChickActivationManager.instance.model.itemInfoList[qualityValue];
         if(Boolean(arr))
         {
            this.playDropGoodsMovie(arr);
         }
      }
      
      private function __selectBtnHandler(evt:Event) : void
      {
         SoundManager.instance.play("008");
         this._groupTwo.selectIndex = 0;
         this.tabHandler();
         this.updateShine();
         this.showBottomActivationButton();
      }
      
      private function __selectBtnTwoHandler(evt:Event) : void
      {
         SoundManager.instance.play("008");
         this.tabHandler();
      }
      
      private function tabHandler() : void
      {
         this._ativationItems.visible = false;
         this._levelPacks.visible = false;
         this.showBottomPriceAndButton(true);
         this.updateGetBtn();
         this._selectLevelPacks.visible = this._group.selectIndex == 0;
         var index:int = this._groupTwo.selectIndex;
         if(index == 0)
         {
            this.findDataUpdateActivationItems();
            this.updatePriceView();
            this._ativationItems.visible = true;
         }
         else if(index == 1)
         {
            this.findDataUpdateActivationItems();
            this.updatePriceView();
            this._ativationItems.visible = true;
         }
         else if(index == 2)
         {
            this.findDataUpdateActivationItems();
            this.updatePriceView();
            this._ativationItems.visible = true;
         }
         else if(index == 3)
         {
            this._levelPacks.update();
            this._levelPacks.visible = true;
            this.updatePriceView();
         }
      }
      
      private function updatePriceView() : void
      {
         var price:int = 0;
         var dataArr:Array = null;
         var i:int = 0;
         var info:ChickActivationInfo = null;
         var qualityValue:int = ChickActivationManager.instance.model.findQualityValue(this.getQualityKey());
         if(ChickActivationManager.instance.model.itemInfoList.hasOwnProperty(qualityValue))
         {
            dataArr = ChickActivationManager.instance.model.itemInfoList[qualityValue];
            for(i = 0; i < dataArr.length; i++)
            {
               info = ChickActivationInfo(dataArr[i]);
               price += info.Probability;
            }
         }
         if(Boolean(this._priceView))
         {
            this._priceView.count = price;
         }
      }
      
      private function findDataUpdateActivationItems() : void
      {
         var dataArr:Array = null;
         var itemInfoList:Array = ChickActivationManager.instance.model.itemInfoList;
         var qualityDic:Dictionary = ChickActivationManager.instance.model.qualityDic;
         var qualityValue:int = ChickActivationManager.instance.model.findQualityValue(this.getQualityKey());
         if(itemInfoList.hasOwnProperty(qualityValue))
         {
            dataArr = itemInfoList[qualityValue];
            this._ativationItems.update(dataArr);
         }
         else
         {
            this._ativationItems.update(null);
         }
      }
      
      private function showBottomPriceAndButton($isBool:Boolean) : void
      {
         this._priceBitmap.visible = $isBool;
         this._moneyIcon.visible = $isBool;
         this._lineBitmap1.visible = $isBool;
         this._priceView.visible = $isBool;
         this._lineBitmap2.visible = $isBool;
         this._receiveBtn.visible = $isBool;
      }
      
      private function showBottomActivationButton() : void
      {
         var isBool:Boolean = false;
         var model:ChickActivationModel = ChickActivationManager.instance.model;
         var remainingDay:int = ChickActivationManager.instance.model.getRemainingDay();
         if(this._group.selectIndex == 0)
         {
            if(model.keyOpenedType == 0 && PlayerManager.Instance.Self.Grade <= 15 || model.keyOpenedType == 1 && remainingDay <= 0)
            {
               isBool = true;
            }
            else
            {
               isBool = false;
            }
         }
         else if(this._group.selectIndex == 1)
         {
            if(model.keyOpenedType == 0 && PlayerManager.Instance.Self.Grade > 15 || model.keyOpenedType == 2 && remainingDay <= 0)
            {
               isBool = true;
            }
            else
            {
               isBool = false;
            }
         }
         this._inputBg.visible = isBool;
         this._inputTxt.visible = isBool;
         this._activationBtn.visible = isBool;
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __inputTxtHandler(evt:MouseEvent) : void
      {
         if(this._inputTxt.text == LanguageMgr.GetTranslation("tank.chickActivation.inputTxtMsg"))
         {
            this._inputTxt.text = "";
         }
      }
      
      private function __activationBtnHandler(evt:MouseEvent) : void
      {
         var strKey:String = this._inputTxt.text;
         if(this._inputTxt.text == "" || this._inputTxt.text == LanguageMgr.GetTranslation("tank.chickActivation.inputTxtMsg"))
         {
            this.showBuyFrame();
            return;
         }
         if(this._inputTxt.text.length != 14)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.chickActivation.inputTxtMsg2"));
            return;
         }
         if(this.clickRateGo())
         {
            return;
         }
         SocketManager.Instance.out.sendChickActivationOpenKey(strKey);
      }
      
      private function showBuyFrame() : void
      {
         var moneyStr:String = null;
         var buyChickActivationFrame:BaseAlerFrame = null;
         var ai:AlertInfo = null;
         var buyContentTxt:FilterFrameText = null;
         var _cell:ShopPlayerCell = null;
         this.buyItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(this.CHICKACTIVATION_CARDID);
         if(Boolean(this.buyItemInfo))
         {
            moneyStr = this.buyItemInfo.getItemPrice(1).toString();
            buyChickActivationFrame = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.buyChickActivationFrame");
            buyChickActivationFrame.titleText = LanguageMgr.GetTranslation("tips");
            ai = new AlertInfo(LanguageMgr.GetTranslation("cancel"),LanguageMgr.GetTranslation("ok"));
            buyChickActivationFrame.info = ai;
            buyContentTxt = ComponentFactory.Instance.creatComponentByStylename("chickActivationFrame.contentTxt");
            buyContentTxt.text = LanguageMgr.GetTranslation("tank.chickActivation.inputTxtMsg3",moneyStr);
            buyChickActivationFrame.addToContent(buyContentTxt);
            _cell = CellFactory.instance.createShopCartItemCell() as ShopPlayerCell;
            _cell.info = this.buyItemInfo.TemplateInfo;
            PositionUtils.setPos(_cell,"chickActivationFrame.ShopPlayerCellPos");
            buyChickActivationFrame.addToContent(_cell);
            buyChickActivationFrame.addEventListener(FrameEvent.RESPONSE,this.__buyFrameResponse);
            LayerManager.Instance.addToLayer(buyChickActivationFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __buyFrameResponse(evt:FrameEvent) : void
      {
         var moneyValue:int = 0;
         SoundManager.instance.play("008");
         evt.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__buyFrameResponse);
         ObjectUtils.disposeAllChildren(evt.currentTarget as DisplayObjectContainer);
         ObjectUtils.disposeObject(evt.currentTarget);
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            moneyValue = this.buyItemInfo.getItemPrice(1).moneyValue;
            if(PlayerManager.Instance.Self.Money < moneyValue)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendBuyGoods([this.buyItemInfo.GoodsID],[1],[""],[0],[Boolean(0)],[""],1,null,[false]);
         }
      }
      
      public function clickRateGo() : Boolean
      {
         var temp:Number = new Date().time;
         if(temp - this._clickRate > 1000)
         {
            this._clickRate = temp;
            return false;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.chickActivation.clickRateMsg"));
         return true;
      }
      
      private function __receiveBtnHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.clickRateGo())
         {
            return;
         }
         if(ChickActivationManager.instance.model.isKeyOpened == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.chickActivation.receiveBtnMsg"));
            return;
         }
         var gainId:int = this.getNowGainArrIndex() + 1;
         SocketManager.Instance.out.sendChickActivationGetAward(gainId,0);
      }
      
      private function playDropGoodsMovie(arr:Array) : void
      {
         var itemInfo:InventoryItemInfo = null;
         var beginPoint:Point = ComponentFactory.Instance.creatCustomObject("chickActivation.dropGoodsBeginPos");
         var endPoint:Point = ComponentFactory.Instance.creatCustomObject("chickActivation.dropGoodsEndPos");
         var tempArr:Array = [];
         for(var i:int = 0; i < this._ativationItems.arrData.length; i++)
         {
            itemInfo = ChickActivationManager.instance.model.getInventoryItemInfo(this._ativationItems.arrData[i]);
            if(Boolean(itemInfo))
            {
               tempArr.push(itemInfo);
            }
         }
         DropGoodsManager.play(tempArr,beginPoint,endPoint,true);
      }
      
      private function getQualityKey() : String
      {
         var day:int = 0;
         var mainIndex:int = this._group.selectIndex;
         var index:int = this._groupTwo.selectIndex;
         var qualityKey:String = mainIndex + "," + index;
         if(index == 0)
         {
            day = 1;
            qualityKey += "," + day;
         }
         else if(index == 2)
         {
            day = 5;
            qualityKey += "," + day;
         }
         return qualityKey;
      }
      
      private function __clickLevelPacksHandler(evt:ChickActivationEvent) : void
      {
         var tempNum:int = 0;
         var totalPrestige:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.clickRateGo())
         {
            return;
         }
         var levelIndex:int = int(evt.resultData);
         var arr:Array = ServerConfigManager.instance.chickenActiveKeyLvAwardNeedPrestige;
         if(Boolean(arr) && arr.length > 0)
         {
            tempNum = int(arr[levelIndex - 1]);
            totalPrestige = BattleGroudManager.Instance.orderdata.totalPrestige;
            if(totalPrestige < tempNum)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.chickActivation.totalPrestigeMsg",tempNum));
               return;
            }
         }
         SocketManager.Instance.out.sendChickActivationGetAward(12,levelIndex);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._group.removeEventListener(Event.CHANGE,this.__selectBtnHandler);
         this._groupTwo.removeEventListener(Event.CHANGE,this.__selectBtnTwoHandler);
         this._inputTxt.removeEventListener(MouseEvent.CLICK,this.__inputTxtHandler);
         this._activationBtn.removeEventListener(MouseEvent.CLICK,this.__activationBtnHandler);
         this._receiveBtn.removeEventListener(MouseEvent.CLICK,this.__receiveBtnHandler);
         this._levelPacks.removeEventListener(ChickActivationEvent.CLICK_LEVELPACKS,this.__clickLevelPacksHandler);
         ChickActivationManager.instance.model.removeEventListener(ChickActivationEvent.UPDATE_DATA,this.__updateDataHandler);
         ChickActivationManager.instance.model.removeEventListener(ChickActivationEvent.GET_REWARD,this.__getRewardHandler);
      }
      
      override public function dispose() : void
      {
         var k:int = 0;
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._mainBg);
         this._mainBg = null;
         ObjectUtils.disposeObject(this._mainTitle);
         this._mainTitle = null;
         ObjectUtils.disposeObject(this._helpTitle);
         this._helpTitle = null;
         ObjectUtils.disposeObject(this._helpPanel);
         this._helpPanel = null;
         ObjectUtils.disposeObject(this._helpTxt);
         this._helpTxt = null;
         ObjectUtils.disposeObject(this._remainingTimeTxt);
         this._remainingTimeTxt = null;
         ObjectUtils.disposeObject(this._group);
         this._group = null;
         ObjectUtils.disposeObject(this._selectBtn1);
         this._selectBtn1 = null;
         ObjectUtils.disposeObject(this._selectBtn2);
         this._selectBtn2 = null;
         ObjectUtils.disposeObject(this._groupTwo);
         this._groupTwo = null;
         ObjectUtils.disposeObject(this._selectEveryDay);
         this._selectEveryDay = null;
         ObjectUtils.disposeObject(this._selectWeekly);
         this._selectWeekly = null;
         ObjectUtils.disposeObject(this._selectAfterThreeDays);
         this._selectAfterThreeDays = null;
         ObjectUtils.disposeObject(this._selectLevelPacks);
         this._selectLevelPacks = null;
         ObjectUtils.disposeObject(this._priceBitmap);
         this._priceBitmap = null;
         ObjectUtils.disposeObject(this._moneyIcon);
         this._moneyIcon = null;
         ObjectUtils.disposeObject(this._lineBitmap1);
         this._lineBitmap1 = null;
         ObjectUtils.disposeObject(this._inputBg);
         this._inputBg = null;
         ObjectUtils.disposeObject(this._inputTxt);
         this._inputTxt = null;
         ObjectUtils.disposeObject(this._activationBtn);
         this._activationBtn = null;
         ObjectUtils.disposeObject(this._lineBitmap2);
         this._lineBitmap2 = null;
         ObjectUtils.disposeObject(this._receiveBtn);
         this._receiveBtn = null;
         ObjectUtils.disposeObject(this._priceView);
         this._priceView = null;
         ObjectUtils.disposeObject(this._levelPacks);
         this._levelPacks = null;
         if(Boolean(this._promptMovies))
         {
            for(k = 0; k < this._promptMovies.length; k++)
            {
               this._promptMovies[k].stop();
               ObjectUtils.disposeObject(this._promptMovies[k]);
            }
            this._promptMovies = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

