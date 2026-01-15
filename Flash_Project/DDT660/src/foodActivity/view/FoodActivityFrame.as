package foodActivity.view
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
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import foodActivity.FoodActivityManager;
   import store.HelpFrame;
   import wonderfulActivity.data.GiftConditionInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class FoodActivityFrame extends Frame
   {
      
      private static var MONEY:int = 100;
      
      private var _bg:Bitmap;
      
      private var _countBg:Bitmap;
      
      private var _boxArr:Vector.<FoodActivityBox>;
      
      private var _boxNumTxtArr:Vector.<FilterFrameText>;
      
      private var _sp:Sprite;
      
      private var _progress:Bitmap;
      
      private var _btnBg:ScaleBitmapImage;
      
      private var _simpleBtn:SimpleBitmapButton;
      
      private var _payBtn:SimpleBitmapButton;
      
      private var _ripeTxt:FilterFrameText;
      
      private var _countTxt:FilterFrameText;
      
      private var _boxMc:MovieClip;
      
      private var _getAwardBtn:MovieClip;
      
      private var _defaultLength:int = 11;
      
      private var _defaultRipeNum:int = 60;
      
      private var _giftState:int;
      
      private var _data:GmActivityInfo;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var frame:int;
      
      public function FoodActivityFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var box:FoodActivityBox = null;
         var boxNumTxt:FilterFrameText = null;
         var award:String = null;
         var kii:int = 0;
         var tip:Object = null;
         var giftInfo:GiftRewardInfo = null;
         var conditionVec:Vector.<GiftConditionInfo> = null;
         var name:String = null;
         this._bg = ComponentFactory.Instance.creat("foodActivity.bg");
         addToContent(this._bg);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("foodActivity.helpBtn");
         addToContent(this._helpBtn);
         this._progress = ComponentFactory.Instance.creat("foodActivity.progress");
         addToContent(this._progress);
         this._sp = new Sprite();
         this._sp.x = this._progress.x;
         this._sp.y = this._progress.y;
         this._sp.graphics.beginFill(16777215,0);
         this._sp.graphics.drawRect(0,0,this._progress.width,this._progress.height);
         this._sp.graphics.endFill();
         this._progress.cacheAsBitmap = true;
         this._progress.mask = this._sp;
         addToContent(this._sp);
         this._boxArr = new Vector.<FoodActivityBox>();
         for(var i:int = 0; i < 5; i++)
         {
            box = new FoodActivityBox();
            box.play(1);
            box.x = 237 + 93 * (i - 1);
            box.y = 110;
            addToContent(box);
            this._boxArr.push(box);
         }
         this._boxNumTxtArr = new Vector.<FilterFrameText>();
         for(var j:int = 0; j < 5; j++)
         {
            boxNumTxt = ComponentFactory.Instance.creatComponentByStylename("foodActivity.boxNumTxt");
            boxNumTxt.x = 151 + 93 * j;
            boxNumTxt.y = 152;
            addToContent(boxNumTxt);
            this._boxNumTxtArr.push(boxNumTxt);
         }
         this._ripeTxt = ComponentFactory.Instance.creatComponentByStylename("foodActivity.ripeTxt");
         addToContent(this._ripeTxt);
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("foodActivity.countTxt");
         addToContent(this._countTxt);
         this._countBg = ComponentFactory.Instance.creat("foodActivity.countBg");
         addToContent(this._countBg);
         this._boxMc = ComponentFactory.Instance.creat("foodActivity.box.mc");
         this._boxMc.x = 334;
         this._boxMc.y = 194;
         this._boxMc.gotoAndStop(1);
         addToContent(this._boxMc);
         this._getAwardBtn = ComponentFactory.Instance.creat("foodActivity.getAward.btn");
         this._getAwardBtn.visible = false;
         this._getAwardBtn.x = 326;
         this._getAwardBtn.y = 205;
         addToContent(this._getAwardBtn);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("foodActivity.buttonBackBg");
         addToContent(this._btnBg);
         this._simpleBtn = ComponentFactory.Instance.creatComponentByStylename("foodActivity.simpleBtn");
         addToContent(this._simpleBtn);
         this._payBtn = ComponentFactory.Instance.creatComponentByStylename("foodActivity.payBtn");
         addToContent(this._payBtn);
         this._data = FoodActivityManager.Instance.info;
         if(!this._data)
         {
            return;
         }
         for(var bi:int = 0; bi < this._boxArr.length; bi++)
         {
            if(!this._boxArr[bi].tipData)
            {
               award = "";
               for(kii = 0; kii < this._data.giftbagArray[bi].giftRewardArr.length; kii++)
               {
                  giftInfo = this._data.giftbagArray[bi].giftRewardArr[kii];
                  conditionVec = this._data.giftbagArray[bi].giftConditionArr;
                  name = ItemManager.Instance.getTemplateById(giftInfo.templateId).Name;
                  award += name + "x" + giftInfo.count + (kii == this._data.giftbagArray[bi].giftRewardArr.length - 1 ? "" : "、\n");
               }
               tip = new Object();
               tip.content = LanguageMgr.GetTranslation("foodActivity.boxTipTxt",conditionVec[0].conditionValue,conditionVec[1].conditionValue);
               tip.awards = award;
               this._boxArr[bi].tipStyle = "foodActivity.view.FoodActivityTip";
               this._boxArr[bi].tipDirctions = "2,1";
               this._boxArr[bi].tipData = tip;
            }
         }
         this.updateProgress();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._simpleBtn.addEventListener(MouseEvent.CLICK,this.__simpleHandler);
         this._payBtn.addEventListener(MouseEvent.CLICK,this.__payHandler);
         this._boxMc.addEventListener(MouseEvent.CLICK,this.__getAwardHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpHandler);
      }
      
      protected function __helpHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("foodActivity.frame.HelpPrompt" + this._data.activityChildType);
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("foodActivity.frame.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function updateProgress() : void
      {
         var box:FoodActivityBox = null;
         var cookingNumArr:Array = null;
         var k:int = 0;
         var i:int = 0;
         for each(box in this._boxArr)
         {
            box.play(1);
         }
         this._giftState = 0;
         cookingNumArr = new Array();
         for(k = 0; k < this._data.giftbagArray.length; k++)
         {
            cookingNumArr.push(this._data.giftbagArray[k].giftConditionArr[0].conditionValue);
         }
         var max:int = int(cookingNumArr[4]);
         var sum:int = FoodActivityManager.Instance.ripeNum + this._defaultRipeNum;
         if(sum == this._defaultRipeNum)
         {
            this._sp.width = this._defaultLength;
         }
         else if(sum < max)
         {
            for(i = 1; i < cookingNumArr.length; i++)
            {
               if(sum < cookingNumArr[i])
               {
                  this._giftState = 1 << i - 1;
                  this._boxArr[i - 1].play(2);
                  this._sp.width = this._defaultLength + int(93 * ((sum - cookingNumArr[i - 1]) / (cookingNumArr[i] - cookingNumArr[i - 1]) + i - 1));
                  break;
               }
            }
         }
         else
         {
            this._giftState = 1 << 4;
            this._boxArr[this._boxArr.length - 1].play(2);
            this._sp.width = this._progress.width;
         }
         this._boxMc.mouseEnabled = this._boxMc.mouseChildren = this._boxMc.buttonMode = this._getAwardBtn.visible = this._giftState != 0;
         this._boxNumTxtArr[0].text = (cookingNumArr[0] - 1).toString();
         for(var j:int = 1; j < this._boxNumTxtArr.length - 1; j++)
         {
            this._boxNumTxtArr[j].text = cookingNumArr[j];
         }
         this._boxNumTxtArr[4].text = "" + max;
         this._ripeTxt.text = "" + (FoodActivityManager.Instance.ripeNum + this._defaultRipeNum);
         this._countTxt.text = "" + FoodActivityManager.Instance.cookingCount;
      }
      
      protected function __simpleHandler(event:MouseEvent) : void
      {
         if(!this.click())
         {
            return;
         }
         SocketManager.Instance.out.cooking(1);
      }
      
      protected function __payHandler(event:MouseEvent) : void
      {
         var confirmFrame:BaseAlerFrame = null;
         if(!this.click())
         {
            return;
         }
         var msg:String = LanguageMgr.GetTranslation("foodActivity.perfectCookingTxt",MONEY);
         confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      protected function __confirm(event:FrameEvent) : void
      {
         var alertFrame:BaseAlerFrame = null;
         SoundManager.instance.playButtonSound();
         var confirmFrame:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
               ObjectUtils.disposeObject(confirmFrame);
               return;
            }
            if(PlayerManager.Instance.Self.Money >= MONEY)
            {
               FoodActivityManager.Instance.ripeNum = this._defaultRipeNum;
               SocketManager.Instance.out.cooking(2);
            }
            else
            {
               alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
               ObjectUtils.disposeObject(confirmFrame);
            }
         }
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      protected function _response(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function click() : Boolean
      {
         SoundManager.instance.playButtonSound();
         if(FoodActivityManager.Instance.cookingCount <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("foodActivity.noCookingCount"));
            return false;
         }
         if(this._giftState != 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("foodActivity.canNotCooking"));
            return false;
         }
         return true;
      }
      
      public function updateBoxMc() : void
      {
         this._simpleBtn.enable = this._payBtn.enable = this._getAwardBtn.visible = false;
         this._boxMc.gotoAndStop(2);
         this._boxMc.y = 223;
         this._boxMc.addEventListener(Event.ENTER_FRAME,this.__enterHandler);
      }
      
      public function failRewardUpdate() : void
      {
         this._boxMc.mouseEnabled = this._boxMc.mouseChildren = this._boxMc.buttonMode = true;
      }
      
      protected function __getAwardHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._boxMc.mouseEnabled = this._boxMc.mouseChildren = this._boxMc.buttonMode = false;
         SocketManager.Instance.out.cookingGetAward(this._giftState);
      }
      
      protected function __enterHandler(event:Event) : void
      {
         ++this.frame;
         if(this.frame >= 120)
         {
            this.frame = 0;
            this._simpleBtn.enable = this._payBtn.enable = true;
            this._boxMc.removeEventListener(Event.ENTER_FRAME,this.__enterHandler);
            this._boxMc.gotoAndStop(1);
            this._boxMc.y = 194;
            this.updateProgress();
         }
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            FoodActivityManager.Instance.disposeFrame();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._simpleBtn.removeEventListener(MouseEvent.CLICK,this.__simpleHandler);
         this._payBtn.removeEventListener(MouseEvent.CLICK,this.__payHandler);
         this._boxMc.removeEventListener(MouseEvent.CLICK,this.__getAwardHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpHandler);
      }
      
      override public function dispose() : void
      {
         var box:FoodActivityBox = null;
         var boxTxt:FilterFrameText = null;
         this.removeEvent();
         for each(box in this._boxArr)
         {
            ObjectUtils.disposeObject(box);
            box = null;
         }
         this._boxArr = null;
         for each(boxTxt in this._boxNumTxtArr)
         {
            ObjectUtils.disposeObject(boxTxt);
            boxTxt = null;
         }
         this._boxNumTxtArr = null;
         this._boxMc.removeEventListener(Event.ENTER_FRAME,this.__enterHandler);
         this._boxMc.parent.removeChild(this._boxMc);
         this._boxMc = null;
         this._getAwardBtn.parent.removeChild(this._getAwardBtn);
         this._getAwardBtn = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._countBg);
         this._countBg = null;
         ObjectUtils.disposeObject(this._btnBg);
         this._btnBg = null;
         ObjectUtils.disposeObject(this._simpleBtn);
         this._simpleBtn = null;
         ObjectUtils.disposeObject(this._payBtn);
         this._payBtn = null;
         ObjectUtils.disposeObject(this._ripeTxt);
         this._ripeTxt = null;
         ObjectUtils.disposeObject(this._countTxt);
         this._countTxt = null;
         this._sp.graphics.clear();
         ObjectUtils.disposeObject(this._sp);
         this._sp = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         super.dispose();
      }
   }
}

