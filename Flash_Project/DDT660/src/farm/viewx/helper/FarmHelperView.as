package farm.viewx.helper
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ShopType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import farm.viewx.ConfirmHelperMoneyAlertFrame;
   import farm.viewx.confirmStopHelperFrame;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import store.HelpFrame;
   
   public class FarmHelperView extends Frame
   {
      
      private var _titleBg:DisplayObject;
      
      private var _helperFramBg1:ScaleBitmapImage;
      
      private var _helperFramBg2:ScaleBitmapImage;
      
      private var _onekeyStartBtn:TextButton;
      
      private var _onekeyCloseBtn:TextButton;
      
      private var _helperShowText1:FilterFrameText;
      
      private var _helperShowText2:FilterFrameText;
      
      private var _helperShowTime:FilterFrameText;
      
      private var _helperSelSeed:FilterFrameText;
      
      private var _helperSelTime:FilterFrameText;
      
      private var _needSeed:FilterFrameText;
      
      private var _needSeedText:FilterFrameText;
      
      private var _getSeedText:FilterFrameText;
      
      private var _getSeed:FilterFrameText;
      
      private var _getSeedNumOne:int;
      
      private var _getSeedNum:int;
      
      private var _remainTime:FilterFrameText;
      
      private var _helpBtn:TextButton;
      
      private var _farmChoose:ComboBox;
      
      private var _timeChoose:ComboBox;
      
      private var _farmNumChoose:ComboBox;
      
      private var _listArray:Array;
      
      private var _listArrayID:Array;
      
      private var _listSeedNum:Array;
      
      private var _listTimeTextArray:Array;
      
      private var _listTimeArray:Array;
      
      private var _currentTime:int;
      
      private var _currentID:int;
      
      private var _timer:Timer;
      
      private var _timerSeed:Timer;
      
      private var _timeText:FilterFrameText;
      
      private var _timeDiff:int;
      
      private var _autoTime:int;
      
      private var _seedItemInfo:Vector.<ShopItemInfo>;
      
      private var _beginFrame:HelperBeginFrame;
      
      private var _typeString:String;
      
      private var _infoList:Vector.<ShopItemInfo>;
      
      private var _configmPnl:ConfirmHelperMoneyAlertFrame;
      
      private var _stopHelpeCconfigm:confirmStopHelperFrame;
      
      private var _modelType:int;
      
      public function FarmHelperView()
      {
         super();
         this.initView();
         this.addEvent();
         escEnable = true;
      }
      
      private function initView() : void
      {
         this._listArray = new Array();
         this._listArrayID = new Array();
         this._listSeedNum = new Array();
         this._listTimeTextArray = ["12saat","24saat"];
         this._listTimeArray = new Array(12 * 60,24 * 60);
         this._currentTime = 12 * 60;
         this._titleBg = ComponentFactory.Instance.creat("assets.farm.farmHelper.title");
         addChild(this._titleBg);
         this._helperFramBg1 = ComponentFactory.Instance.creatComponentByStylename("helperFrame.bg1");
         addToContent(this._helperFramBg1);
         this._helperFramBg2 = ComponentFactory.Instance.creatComponentByStylename("helperFrame.bg2");
         addToContent(this._helperFramBg2);
         this._onekeyStartBtn = ComponentFactory.Instance.creatComponentByStylename("asset.farm.onekeyStartBtn");
         this._onekeyStartBtn.text = LanguageMgr.GetTranslation("ddt.farm.StartBtn.text");
         this._onekeyStartBtn.enable = false;
         addToContent(this._onekeyStartBtn);
         this._onekeyCloseBtn = ComponentFactory.Instance.creatComponentByStylename("asset.farm.onekeyCloseBtn");
         this._onekeyCloseBtn.visible = false;
         this._onekeyCloseBtn.text = LanguageMgr.GetTranslation("ddt.farm.CloseBtn.text");
         addToContent(this._onekeyCloseBtn);
         this._helperShowText1 = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperShowTxt1");
         this._helperShowText1.text = LanguageMgr.GetTranslation("ddt.farm.helperShow.text1");
         addToContent(this._helperShowText1);
         this._helperShowText2 = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperShowTxt2");
         addToContent(this._helperShowText2);
         this._helperShowTime = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperShowTime");
         addToContent(this._helperShowTime);
         this._helperSelSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperSelSeed");
         this._helperSelSeed.text = LanguageMgr.GetTranslation("ddt.farm.helperSelSeed.text");
         addToContent(this._helperSelSeed);
         this._helperSelTime = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperSelTime");
         this._helperSelTime.text = LanguageMgr.GetTranslation("ddt.farm.helperSeltime.text");
         addToContent(this._helperSelTime);
         this._needSeedText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperNeedSeedText");
         this._needSeedText.text = LanguageMgr.GetTranslation("ddt.farm.helperNeedSeed.text");
         addToContent(this._needSeedText);
         this._needSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperNeedSeed");
         addToContent(this._needSeed);
         this._getSeedText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperGetSeedText");
         this._getSeedText.text = LanguageMgr.GetTranslation("ddt.farm.helperGetSeed.text");
         addToContent(this._getSeedText);
         this._getSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperGetSeed");
         addToContent(this._getSeed);
         this._remainTime = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperRemainTime");
         this._remainTime.text = LanguageMgr.GetTranslation("ddt.farm.helperNeedTime.text");
         addToContent(this._remainTime);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helpBtn");
         this._helpBtn.text = LanguageMgr.GetTranslation("ddt.farm.helpBtn.text");
         addToContent(this._helpBtn);
         this._farmChoose = ComponentFactory.Instance.creatComponentByStylename("asset.farm.farmChoose");
         addToContent(this._farmChoose);
         this._timeChoose = ComponentFactory.Instance.creatComponentByStylename("asset.farm.timeChoose");
         addToContent(this._timeChoose);
         this._infoList = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         this.setComboxContent();
         this._timeText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperTimerText");
         addToContent(this._timeText);
         if(PlayerManager.Instance.Self.isFarmHelper)
         {
            this.setBtnEna(false);
            this.setTimes();
            this.setGetSeedCount();
         }
         this.setHelperTime();
         this._seedItemInfo = ShopManager.Instance.getValidSortedGoodsByType(ShopType.FARM_SEED_TYPE,1,this._farmChoose.listPanel.vectorListModel.size() + 1);
      }
      
      private function setHelperTime() : void
      {
         var date:Date = null;
         var date1:Date = null;
         if(FarmModelController.instance.model.isHelperMay || PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= FarmModelController.instance.model.vipLimitLevel)
         {
            if(PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= FarmModelController.instance.model.vipLimitLevel)
            {
               date = PlayerManager.Instance.Self.VIPExpireDay as Date;
               this._helperShowTime.text = date.fullYear + "-" + (date.month + 1) + "-";
               this._helperShowTime.text += date.date + " " + this.fixZero(date.hours) + ":" + this.fixZero(date.minutes);
               this._helperShowText2.text = LanguageMgr.GetTranslation("ddt.farm.helperShow.text2");
            }
            else
            {
               date1 = FarmModelController.instance.model.stopTime as Date;
               this._helperShowTime.text = date1.fullYear + "-" + (date1.month + 1) + "-";
               this._helperShowTime.text += date1.date + " " + this.fixZero(date1.hours) + ":" + this.fixZero(date1.minutes);
               this._helperShowText2.text = LanguageMgr.GetTranslation("ddt.farm.helperShow.text2");
            }
         }
         else
         {
            this._helperShowTime.text = "";
            this._helperShowText2.text = "";
         }
      }
      
      private function setComboxContent() : void
      {
         var name:String = null;
         var ID:int = 0;
         this._farmChoose.beginChanges();
         this._farmChoose.selctedPropName = "text";
         var comboxModel:VectorListModel = this._farmChoose.listPanel.vectorListModel;
         comboxModel.clear();
         for(var i:int = 0; i < this._infoList.length; i++)
         {
            if(this._infoList[i] && this._infoList[i].TemplateInfo.CategoryID == 32 && this._infoList[i].TemplateInfo.Property7 == "1")
            {
               if(PlayerManager.Instance.Self.VIPLevel < ServerConfigManager.instance.getPrivilegeMinLevel(ServerConfigManager.PRIVILEGE_CANBUYFERT) || !PlayerManager.Instance.Self.IsVIP)
               {
                  continue;
               }
            }
            if(PlayerManager.Instance.Self.Grade >= this._infoList[i].LimitGrade)
            {
               name = this._infoList[i].TemplateInfo.Name;
               ID = this._infoList[i].TemplateID;
               this._listArray.push(name);
               this._listArrayID.push(ID);
               this._listSeedNum.push(int(this._infoList[i].TemplateInfo.Property2));
               comboxModel.append(name);
               if(PlayerManager.Instance.Self.isFarmHelper && this._infoList[i].TemplateID == FarmModelController.instance.model.helperArray[1])
               {
                  this._farmChoose.textField.text = this._infoList[i].TemplateInfo.Name;
               }
            }
         }
         this._farmChoose.listPanel.list.updateListView();
         this._farmChoose.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._farmChoose.commitChanges();
         this._timeChoose.beginChanges();
         this._timeChoose.selctedPropName = "text";
         this._timeChoose.textField.text = "12" + LanguageMgr.GetTranslation("hour");
         var comboxModel2:VectorListModel = this._timeChoose.listPanel.vectorListModel;
         comboxModel2.clear();
         comboxModel2.append(this._listTimeTextArray[0]);
         comboxModel2.append(this._listTimeTextArray[1]);
         this._timeChoose.listPanel.list.updateListView();
         this._timeChoose.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick2);
         this._timeChoose.commitChanges();
      }
      
      private function setBtnEna(value:Boolean = true) : void
      {
         if(Boolean(this._onekeyStartBtn))
         {
            if(value == true)
            {
               if(this._listArrayID.length > 0)
               {
                  this._onekeyStartBtn.enable = value;
               }
            }
            else
            {
               this._onekeyStartBtn.visible = value;
            }
         }
         if(Boolean(this._onekeyCloseBtn))
         {
            this._onekeyCloseBtn.visible = !value;
         }
         if(Boolean(this._farmChoose))
         {
            this._farmChoose.enable = value;
            this._farmChoose.filters = value == true ? ComponentFactory.Instance.creatFilters("lightFilter") : ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(Boolean(this._timeChoose))
         {
            this._timeChoose.enable = value;
            this._timeChoose.filters = value == true ? ComponentFactory.Instance.creatFilters("lightFilter") : ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__closeFarmHelper);
         this._onekeyStartBtn.addEventListener(MouseEvent.CLICK,this.__onekeyStartClick);
         this._onekeyCloseBtn.addEventListener(MouseEvent.CLICK,this.__onekeyCloseClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpClick);
         this._farmChoose.button.addEventListener(MouseEvent.CLICK,this.__comBoxBtnClick);
         this._timeChoose.button.addEventListener(MouseEvent.CLICK,this.__comBoxBtnClick);
         FarmModelController.instance.addEventListener(FarmEvent.BEGIN_HELPER,this.__beginHelper);
         FarmModelController.instance.addEventListener(FarmEvent.STOP_HELPER,this.__stopHelper);
         FarmModelController.instance.addEventListener(FarmEvent.CONFIRM_STOP_HELPER,this.__confirmStopHelper);
         FarmModelController.instance.model.addEventListener(FarmEvent.PAY_HELPER,this.__showHelperTime);
      }
      
      private function __showHelperTime(pEvent:FarmEvent) : void
      {
         this.setHelperTime();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __closeFarmHelper(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function __beginHelper(event:FarmEvent) : void
      {
         if(PlayerManager.Instance.Self.isFarmHelper)
         {
            this.setBtnEna(false);
            this.setTimes();
            this.setGetSeedCount();
         }
      }
      
      private function __stopHelper(event:FarmEvent) : void
      {
         if(!PlayerManager.Instance.Self.isFarmHelper)
         {
            if(Boolean(this._timer))
            {
               this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
            }
            if(Boolean(this._timerSeed))
            {
               this._timerSeed.removeEventListener(TimerEvent.TIMER,this.__timerSeedHandler);
            }
            this.setBtnEna(true);
         }
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         var tempInfo:ShopItemInfo = null;
         var info:ShopItemInfo = null;
         SoundManager.instance.play("008");
         this._currentID = this._listArrayID[event.index];
         for each(info in this._infoList)
         {
            if(info.TemplateID == this._currentID)
            {
               tempInfo = info;
               break;
            }
         }
         this._getSeedNumOne = this._listSeedNum[event.index];
         this._onekeyStartBtn.enable = true;
         switch(tempInfo.APrice1)
         {
            case -1:
               this._modelType = -1;
               break;
            case -2:
               this._modelType = -2;
               break;
            case -8:
               this._modelType = -8;
               break;
            case -9:
               this._modelType = -9;
               break;
            default:
               this._modelType = -1;
         }
         this._needSeed.text = this.getseedCountByID().toString();
         this._getSeed.text = this._getSeedNum.toString() + "/" + this._getSeedNum.toString();
      }
      
      private function __itemClick2(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentTime = this._listTimeArray[event.index];
         this._needSeed.text = this.getseedCountByID().toString();
         this._getSeed.text = this._getSeedNum.toString() + "/" + this._getSeedNum.toString();
      }
      
      private function getseedCountByID() : int
      {
         var nowDate:int = 0;
         var needTime:int = this.findSeedTimebyID(this._currentID);
         var filedCounts:int = 0;
         var fieldsInfo:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         for(var m:int = 0; m < FarmModelController.instance.model.fieldsInfo.length; m++)
         {
            nowDate = (new Date().getTime() - fieldsInfo[m].payTime.getTime()) / (1000 * 60 * 60);
            if(fieldsInfo[m].fieldValidDate > nowDate || fieldsInfo[m].fieldValidDate == -1)
            {
               filedCounts++;
            }
         }
         var seedCount:int = int(filedCounts * this._currentTime / needTime);
         this._getSeedNum = filedCounts * this._currentTime / needTime * this._getSeedNumOne;
         return seedCount;
      }
      
      private function findSeedTimebyID(ID:int) : int
      {
         for(var i:int = 0; i < this._seedItemInfo.length; i++)
         {
            if(this._currentID == this._seedItemInfo[i].TemplateID)
            {
               return int(this._seedItemInfo[i].TemplateInfo.Property3);
            }
         }
         return 0;
      }
      
      private function __comBoxBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __onekeyStartClick(e:MouseEvent) : void
      {
         var seedInfoCount:int = 0;
         var seedCount:int = 0;
         var times:int = 0;
         if(this._farmChoose.textField.text == null)
         {
            return;
         }
         SoundManager.instance.play("008");
         var selfInfo:SelfInfo = PlayerManager.Instance.Self;
         if(FarmModelController.instance.model.isHelperMay || PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= FarmModelController.instance.model.vipLimitLevel)
         {
            seedInfoCount = FarmModelController.instance.model.getSeedCountByID(this._currentID);
            seedCount = this.getseedCountByID();
            times = 0;
            this._beginFrame = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperView.beginFrame");
            this._beginFrame.seedID = this._currentID;
            this._beginFrame.seedTime = this._currentTime;
            this._beginFrame.getCount = this._getSeedNum;
            this._beginFrame.modelType = this._modelType;
            if(seedInfoCount > 0)
            {
               this._beginFrame.needCount = seedCount > seedInfoCount ? seedCount - seedInfoCount : 0;
               this._beginFrame.haveCount = seedInfoCount > seedCount ? seedCount : seedInfoCount;
            }
            else
            {
               this._beginFrame.needCount = seedCount;
               this._beginFrame.haveCount = 0;
            }
            this._beginFrame.show();
         }
         else
         {
            this._configmPnl = ComponentFactory.Instance.creatComponentByStylename("farm.confirmHelperMoneyAlertFrame");
            LayerManager.Instance.addToLayer(this._configmPnl,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __onekeyCloseClick(e:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SoundManager.instance.play("008");
         this._stopHelpeCconfigm = ComponentFactory.Instance.creatComponentByStylename("farm.confirmStopHelperFrame");
         LayerManager.Instance.addToLayer(this._stopHelpeCconfigm,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __confirmStopHelper(event:FarmEvent) : void
      {
         var array1:Array = new Array();
         array1.push(false);
         SocketManager.Instance.out.sendBeginHelper(array1);
         this.dispose();
      }
      
      private function setTimes() : void
      {
         var startTime1:Date = FarmModelController.instance.model.helperArray[2];
         var startTime2:int = startTime1.getTime() / 1000;
         var nowTime1:Date = TimeManager.Instance.Now();
         var nowTime2:int = nowTime1.getTime() / 1000;
         this._autoTime = FarmModelController.instance.model.helperArray[3] * 60;
         if(nowTime2 - startTime2 < 0)
         {
            this._timeDiff = this._autoTime;
         }
         else
         {
            this._timeDiff = this._autoTime - (nowTime2 - startTime2);
         }
         this._timer = new Timer(1000,int(this._timeDiff));
         this._timer.start();
         this._timerSeed = new Timer(60000);
         this._timerSeed.start();
         if(this._timeText == null)
         {
            this._timeText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperTimerText");
            addChild(this._timeText);
         }
         if(this._needSeed == null)
         {
            this._needSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperNeedSeed");
            addChild(this._needSeed);
         }
         this._needSeed.text = FarmModelController.instance.model.helperArray[4];
         this._timeChoose.textField.text = FarmModelController.instance.model.helperArray[3] / 60 + LanguageMgr.GetTranslation("hour");
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         this._timerSeed.addEventListener(TimerEvent.TIMER,this.__timerSeedHandler);
      }
      
      private function __timerSeedHandler(evnet:TimerEvent) : void
      {
         this.setGetSeedCount();
      }
      
      private function setGetSeedCount() : void
      {
         if(this._getSeed == null)
         {
            this._getSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperGetSeed");
            addChild(this._getSeed);
         }
         this._getSeed.text = String(int((1 - this._timeDiff / this._autoTime) * FarmModelController.instance.model.helperArray[5])) + "/" + FarmModelController.instance.model.helperArray[5].toString();
      }
      
      private function __timerHandler(evnet:TimerEvent) : void
      {
         var array2:Array = null;
         this._timeText.text = this.getTimeDiff(this._timeDiff);
         --this._timeDiff;
         if(this._timeDiff == 0)
         {
            array2 = new Array();
            array2.push(false);
            SocketManager.Instance.out.sendBeginHelper(array2);
            this.dispose();
         }
      }
      
      private function getTimeDiff(diff:int) : String
      {
         var h:uint = 0;
         var m:uint = 0;
         var s:uint = 0;
         if(diff >= 0)
         {
            h = Math.floor(diff / 60 / 60);
            diff %= 60 * 60;
            m = Math.floor(diff / 60);
            diff %= 60;
            s = uint(diff);
         }
         return this.fixZero(h) + ":" + this.fixZero(m) + ":" + this.fixZero(s);
      }
      
      private function fixZero(num:uint) : String
      {
         return num < 10 ? "0" + String(num) : String(num);
      }
      
      private function __helpClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("farm.helper.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("farm.helper.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.farm.helper.help.readme");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         this._onekeyStartBtn.removeEventListener(MouseEvent.CLICK,this.__onekeyStartClick);
         this._onekeyCloseBtn.removeEventListener(MouseEvent.CLICK,this.__onekeyCloseClick);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpClick);
         removeEventListener(FrameEvent.RESPONSE,this.__closeFarmHelper);
         this._farmChoose.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._timeChoose.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick2);
         FarmModelController.instance.removeEventListener(FarmEvent.BEGIN_HELPER,this.__beginHelper);
         FarmModelController.instance.removeEventListener(FarmEvent.STOP_HELPER,this.__stopHelper);
         FarmModelController.instance.removeEventListener(FarmEvent.CONFIRM_STOP_HELPER,this.__confirmStopHelper);
         FarmModelController.instance.model.removeEventListener(FarmEvent.PAY_HELPER,this.__showHelperTime);
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
         }
      }
      
      private function removeItem() : void
      {
         if(Boolean(this._onekeyStartBtn))
         {
            ObjectUtils.disposeObject(this._onekeyStartBtn);
         }
         this._onekeyStartBtn = null;
         if(Boolean(this._onekeyCloseBtn))
         {
            ObjectUtils.disposeObject(this._onekeyCloseBtn);
         }
         this._onekeyCloseBtn = null;
         if(Boolean(this._helperShowText1))
         {
            ObjectUtils.disposeObject(this._helperShowText1);
         }
         this._helperShowText1 = null;
         if(Boolean(this._helperShowText2))
         {
            ObjectUtils.disposeObject(this._helperShowText2);
         }
         this._helperShowText2 = null;
         if(Boolean(this._helperShowTime))
         {
            ObjectUtils.disposeObject(this._helperShowTime);
         }
         this._helperShowTime = null;
         if(Boolean(this._farmChoose))
         {
            ObjectUtils.disposeObject(this._farmChoose);
         }
         this._farmChoose = null;
         if(Boolean(this._timeChoose))
         {
            ObjectUtils.disposeObject(this._timeChoose);
         }
         this._timeChoose = null;
         if(Boolean(this._farmNumChoose))
         {
            ObjectUtils.disposeObject(this._farmNumChoose);
         }
         this._farmNumChoose = null;
         if(Boolean(this._listArray))
         {
            ObjectUtils.disposeObject(this._listArray);
         }
         this._listArray = null;
         if(Boolean(this._helperSelSeed))
         {
            ObjectUtils.disposeObject(this._helperSelSeed);
         }
         this._helperSelTime = null;
         if(Boolean(this._helperSelTime))
         {
            ObjectUtils.disposeObject(this._helperSelTime);
         }
         this._helperSelTime = null;
         if(Boolean(this._needSeed))
         {
            ObjectUtils.disposeObject(this._needSeed);
         }
         this._needSeed = null;
         if(Boolean(this._needSeedText))
         {
            ObjectUtils.disposeObject(this._needSeedText);
         }
         this._needSeedText = null;
         if(Boolean(this._getSeedText))
         {
            ObjectUtils.disposeObject(this._getSeedText);
         }
         this._getSeedText = null;
         if(Boolean(this._getSeed))
         {
            ObjectUtils.disposeObject(this._getSeed);
         }
         this._getSeed = null;
         if(Boolean(this._remainTime))
         {
            ObjectUtils.disposeObject(this._remainTime);
         }
         this._remainTime = null;
         if(Boolean(this._helperFramBg1))
         {
            ObjectUtils.disposeObject(this._helperFramBg1);
         }
         this._helperFramBg1 = null;
         if(Boolean(this._helperFramBg2))
         {
            ObjectUtils.disposeObject(this._helperFramBg2);
         }
         this._helperFramBg2 = null;
         if(Boolean(this._beginFrame))
         {
            ObjectUtils.disposeObject(this._beginFrame);
         }
         this._beginFrame = null;
         if(Boolean(this._timer))
         {
            ObjectUtils.disposeObject(this._timer);
         }
         this._timer = null;
         if(Boolean(this._timeText))
         {
            ObjectUtils.disposeObject(this._timeText);
         }
         this._timeText = null;
         if(Boolean(this._configmPnl))
         {
            this._configmPnl.dispose();
         }
         this._configmPnl = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeItem();
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

