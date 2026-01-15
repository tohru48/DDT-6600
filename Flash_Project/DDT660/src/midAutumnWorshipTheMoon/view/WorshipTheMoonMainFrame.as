package midAutumnWorshipTheMoon.view
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.ItemCellEffectMngr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import magicStone.components.MagicStoneConfirmView;
   import midAutumnWorshipTheMoon.WorshipTheMoonManager;
   import midAutumnWorshipTheMoon.model.WorshipTheMoonAwardsBoxInfo;
   import midAutumnWorshipTheMoon.model.WorshipTheMoonModel;
   import shop.view.ShopItemCell;
   
   public class WorshipTheMoonMainFrame extends Frame implements Disposeable
   {
      
      private var _model:WorshipTheMoonModel;
      
      private var _bg:Bitmap;
      
      private var _animationWorshipTheMoon:MovieClip;
      
      private var _listShiningMoonList:Vector.<DisplayObject>;
      
      private var _buyOnceBtn:SimpleBitmapButton;
      
      private var _buyTenTimesBtn:SimpleBitmapButton;
      
      private var _timesRemainTitle:Bitmap;
      
      private var _timesRemainTxt:FilterFrameText;
      
      private var _listAwardsMaybeGain:Vector.<BagCell>;
      
      private var _coolShiningFor200TimesItem:MovieClip;
      
      private var _awardsAfter200times:ShopItemCell;
      
      private var _gained200:Bitmap;
      
      private var _tipClickToGain200:Bitmap;
      
      private var _timesUsed:FilterFrameText;
      
      private var _ruleDetails:FilterFrameText;
      
      private var _timesGoingToWorship:int = 0;
      
      public function WorshipTheMoonMainFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         var i:int = 0;
         super.init();
         titleText = LanguageMgr.GetTranslation("worshipTheMoon.main.title");
         this._bg = ComponentFactory.Instance.creat("worshipTheMoon.BG");
         addToContent(this._bg);
         this._animationWorshipTheMoon = ComponentFactory.Instance.creat("worshipTheMoon.mc.shining");
         PositionUtils.setPos(this._animationWorshipTheMoon,"worshipTheMoon.pt.animation");
         this._animationWorshipTheMoon.mouseChildren = false;
         this._animationWorshipTheMoon.mouseEnabled = false;
         this._animationWorshipTheMoon.gotoAndStop(this._animationWorshipTheMoon.totalFrames);
         addToContent(this._animationWorshipTheMoon);
         this._listShiningMoonList = new Vector.<DisplayObject>();
         for(i = 0; i < 6; i++)
         {
            this._listShiningMoonList[i] = this._animationWorshipTheMoon.getChildByName("mn" + (i + 1).toString());
            this._listShiningMoonList[i].visible = false;
         }
         this._buyOnceBtn = ComponentFactory.Instance.creat("worshipTheMoon.btn.buyOnce");
         addToContent(this._buyOnceBtn);
         this._buyTenTimesBtn = ComponentFactory.Instance.creat("worshipTheMoon.btn.buyTenTimes");
         addToContent(this._buyTenTimesBtn);
         this._timesRemainTitle = ComponentFactory.Instance.creatBitmap("worshipTheMoon.bm.timesRemainTitle");
         addToContent(this._timesRemainTitle);
         this._timesRemainTxt = ComponentFactory.Instance.creat("worshipTheMoon.txt.TimesRemain");
         this._timesRemainTxt.mouseEnabled = false;
         addToContent(this._timesRemainTxt);
         this._listAwardsMaybeGain = new Vector.<BagCell>();
         for(i = 0; i < 12; i++)
         {
            this._listAwardsMaybeGain[i] = new BagCell(0);
            this._listAwardsMaybeGain[i].x = 624 + i % 4 * 50;
            this._listAwardsMaybeGain[i].y = 80 + int(i / 4) * 50;
            addToContent(this._listAwardsMaybeGain[i]);
         }
         var bg:Shape = new Shape();
         bg.graphics.beginFill(0,0);
         bg.graphics.drawRect(0,0,70,70);
         bg.graphics.endFill();
         this._awardsAfter200times = new ShopItemCell(bg);
         PositionUtils.setPos(this._awardsAfter200times,"worshipTheMoon.pt.on200");
         this._awardsAfter200times.useHandCursor = true;
         this._awardsAfter200times.buttonMode = true;
         addToContent(this._awardsAfter200times);
         this._coolShiningFor200TimesItem = ComponentFactory.Instance.creat("asset.core.icon.coolShining");
         this._coolShiningFor200TimesItem = ItemCellEffectMngr.getEffect(this._awardsAfter200times,ItemCellEffectMngr.EFFECT_RUN_AROUND,ItemCellEffectMngr.SIZE_SHOP_ITEM_CELL);
         this._coolShiningFor200TimesItem.alpha = 0.7;
         addToContent(this._coolShiningFor200TimesItem);
         this._gained200 = ComponentFactory.Instance.creatBitmap("worship.alreadyGet");
         this._tipClickToGain200 = ComponentFactory.Instance.creatBitmap("worshipTheMoon.clickToGain");
         this._timesUsed = ComponentFactory.Instance.creat("worshipTheMoon.txt.TimesUsed");
         this._timesUsed.mouseEnabled = false;
         addToContent(this._timesUsed);
         this._ruleDetails = ComponentFactory.Instance.creat("worshipTheMoon.txt.details");
         this._ruleDetails.mouseEnabled = false;
         this._ruleDetails.htmlText = LanguageMgr.GetTranslation("worshipTheMoon.Details",ServerConfigManager.instance.worshipMoonBeginDate,ServerConfigManager.instance.worshipMoonEndDate);
         addToContent(this._ruleDetails);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.onFrameClick);
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._awardsAfter200times.addEventListener(MouseEvent.CLICK,this.on200AwardsBoxClick);
      }
      
      protected function on200AwardsBoxClick(me:MouseEvent) : void
      {
         var state:int = this._model.canGain200AwardsBox();
         if(state == 2)
         {
            WorshipTheMoonManager.getInstance().requireWorship200AwardBox();
         }
      }
      
      protected function onFrameClick(me:MouseEvent) : void
      {
         switch(me.target)
         {
            case this._buyOnceBtn:
               SoundManager.instance.play("008");
               this._timesGoingToWorship = 1;
               this.showConfirmFrame(this._timesGoingToWorship);
               break;
            case this._buyTenTimesBtn:
               SoundManager.instance.play("008");
               this._timesGoingToWorship = 10;
               this.showConfirmFrame(this._timesGoingToWorship);
         }
      }
      
      private function getPrice() : int
      {
         return WorshipTheMoonModel.getInstance().getNeedMoney(this._timesGoingToWorship);
      }
      
      public function showConfirmFrame(times:int) : void
      {
         var showConfirmFrame:Boolean = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var needMoneyTimes:int = WorshipTheMoonModel.getInstance().getNeedMoneyTimes(times);
         var moneyNotEnough:Boolean = PlayerManager.Instance.Self.Money < WorshipTheMoonModel.getInstance().getNeedMoney(needMoneyTimes);
         var bindMoneyNotEnough:Boolean = PlayerManager.Instance.Self.BandMoney < WorshipTheMoonModel.getInstance().getNeedMoney(needMoneyTimes);
         var isOnceBindMoney:Boolean = WorshipTheMoonModel.getInstance().getIsOnceBtnUseBindMoney();
         var isTensBindMoney:Boolean = WorshipTheMoonModel.getInstance().getIsTensBtnUseBindMoney();
         if(times == 1)
         {
            if(isOnceBindMoney)
            {
               WorshipTheMoonModel.getInstance().onceBtnShowTipsAgain();
            }
            else if(!isOnceBindMoney && moneyNotEnough)
            {
               WorshipTheMoonModel.getInstance().onceBtnShowTipsAgain();
            }
         }
         else if(isTensBindMoney)
         {
            WorshipTheMoonModel.getInstance().tensBtnShowTipsAgain();
         }
         else if(!isTensBindMoney && moneyNotEnough)
         {
            WorshipTheMoonModel.getInstance().tensBtnShowTipsAgain();
         }
         if(times == 1)
         {
            showConfirmFrame = WorshipTheMoonModel.getInstance().getIsOnceBtnShowBuyTipThisLogin();
         }
         else
         {
            showConfirmFrame = WorshipTheMoonModel.getInstance().getIsTensBtnShowBuyTipThisLogin();
         }
         if(needMoneyTimes <= 0 || !showConfirmFrame)
         {
            this.disableBtns();
            WorshipTheMoonManager.getInstance().requireWorshipTheMoon(times);
            return;
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("worshipTheMoon.thisIsCostMoney",this.getPrice(),String(times)),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"worship.confirmView",30,true,AlertManager.SELECTBTN);
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
            tmpNeedMoney = this.getPrice();
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < tmpNeedMoney)
            {
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.reConfirmHandler,false,0,true);
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < tmpNeedMoney)
            {
               if(this._timesGoingToWorship == 1)
               {
                  WorshipTheMoonModel.getInstance().onceBtnNotShowBuyTipsAgainThisLogin(true);
               }
               else
               {
                  WorshipTheMoonModel.getInstance().tensBtnNotShowBuyTipsAgainThisLogin(true);
               }
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as MagicStoneConfirmView).isNoPrompt)
            {
               if(this._timesGoingToWorship == 1)
               {
                  WorshipTheMoonModel.getInstance().onceBtnNotShowBuyTipsAgainThisLogin(true);
               }
               else
               {
                  WorshipTheMoonModel.getInstance().tensBtnNotShowBuyTipsAgainThisLogin(true);
               }
            }
            if(this._timesGoingToWorship == 1)
            {
               WorshipTheMoonModel.getInstance().updateIsOnceBtnUseBindMoney(confirmFrame.isBand);
            }
            else
            {
               WorshipTheMoonModel.getInstance().updateIsTensBtnUseBindMoney(confirmFrame.isBand);
            }
            WorshipTheMoonManager.getInstance().requireWorshipTheMoon(this._timesGoingToWorship);
            this._timesGoingToWorship = 0;
         }
      }
      
      private function reConfirmHandler(evt:FrameEvent) : void
      {
         var needMoney:int = 0;
         SoundManager.instance.play("008");
         if(this._timesGoingToWorship == 1)
         {
            WorshipTheMoonModel.getInstance().onceBtnShowTipsAgain();
            WorshipTheMoonModel.getInstance().updateIsOnceBtnUseBindMoney(false);
         }
         else
         {
            WorshipTheMoonModel.getInstance().onceBtnShowTipsAgain();
            WorshipTheMoonModel.getInstance().updateIsTensBtnUseBindMoney(false);
         }
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.reConfirmHandler);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            needMoney = this.getPrice();
            if(PlayerManager.Instance.Self.Money < needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            WorshipTheMoonManager.getInstance().requireWorshipTheMoon(this._timesGoingToWorship);
            this._timesGoingToWorship = 0;
         }
      }
      
      public function updateTimesRemains() : void
      {
         if(Boolean(this._timesRemainTxt))
         {
            this._timesRemainTxt.text = this._model.getTimesRemain().toString();
         }
      }
      
      public function updateUsedTimes() : void
      {
         if(Boolean(this._timesUsed))
         {
            this._timesUsed.text = this._model.getUsedTimes().toString();
         }
      }
      
      public function updateAwardItemsCanGainList() : void
      {
         var idList:Vector.<int> = this._model.getItemsCanGainsIDList();
         var len:int = int(idList.length);
         for(var i:int = 0; i < len; i++)
         {
            this._listAwardsMaybeGain[i].info = ItemManager.Instance.getTemplateById(idList[i]);
         }
      }
      
      public function update200TimesGains() : void
      {
         if(this._awardsAfter200times == null)
         {
            return;
         }
         this._awardsAfter200times.info = ItemManager.Instance.getTemplateById(this._model.get200TimesGainsID());
         var state:int = this._model.canGain200AwardsBox();
         switch(state)
         {
            case 1:
               this._awardsAfter200times.filters = [];
               this._coolShiningFor200TimesItem.play();
               this._coolShiningFor200TimesItem.visible = true;
               this._tipClickToGain200.parent && this._awardsAfter200times.removeChild(this._tipClickToGain200);
               this._gained200.parent && this._awardsAfter200times.removeChild(this._gained200);
               break;
            case 2:
               this._awardsAfter200times.filters = [];
               this._coolShiningFor200TimesItem.play();
               this._coolShiningFor200TimesItem.visible = true;
               this._awardsAfter200times.addChild(this._tipClickToGain200);
               this._gained200.parent && this._awardsAfter200times.removeChild(this._gained200);
         }
      }
      
      public function playTenTimesAnimation() : void
      {
         this.disableBtns();
         if(this._animationWorshipTheMoon == null)
         {
            return;
         }
         this._animationWorshipTheMoon.addEventListener("show_result",this.timeToLightAll);
         this._animationWorshipTheMoon.gotoAndPlay(1);
      }
      
      protected function timeToLightAll(e:Event) : void
      {
         var len:int;
         var i:int;
         var onComplete:Function = null;
         var temp:DisplayObject = null;
         onComplete = function(obj:DisplayObject):void
         {
            obj.visible = false;
         };
         this._animationWorshipTheMoon.removeEventListener("show_result",this.timeToLightAll);
         len = int(this._listShiningMoonList.length);
         for(i = 0; i < len; i++)
         {
            this._listShiningMoonList[i].alpha = 0;
            this._listShiningMoonList[i].visible = true;
            temp = this._listShiningMoonList[i];
            TweenMax.to(this._listShiningMoonList[i],0.5,{
               "alpha":1,
               "yoyo":true,
               "repeat":3,
               "onComplete":onComplete,
               "onCompleteParams":[temp]
            });
         }
         setTimeout(this.showGainsAwardsAndresetBtns,3100);
      }
      
      public function playOnceAnimation() : void
      {
         this.disableBtns();
         if(this._animationWorshipTheMoon == null)
         {
            return;
         }
         this._animationWorshipTheMoon.addEventListener("show_result",this.timeToLightTheMoon);
         this._animationWorshipTheMoon.gotoAndPlay(1);
      }
      
      protected function timeToLightTheMoon(e:Event) : void
      {
         var len:int;
         var i:int;
         var moonType:int = 0;
         var onComplete:Function = null;
         onComplete = function():void
         {
            _listShiningMoonList[moonType].visible = false;
            showNotification();
            resetBtns();
         };
         this._animationWorshipTheMoon.removeEventListener("show_result",this.timeToLightTheMoon);
         len = int(this._listShiningMoonList.length);
         moonType = this._model.getCurrentMoonType() - 1;
         for(i = 0; i < len; i++)
         {
            this._listShiningMoonList[i].visible = false;
         }
         this._listShiningMoonList[moonType].alpha = 0;
         this._listShiningMoonList[moonType].visible = true;
         TweenMax.to(this._listShiningMoonList[moonType],0.5,{
            "alpha":1,
            "yoyo":true,
            "repeat":3,
            "onComplete":onComplete
         });
      }
      
      private function disableBtns() : void
      {
         if(_closeButton == null)
         {
            return;
         }
         escEnable = false;
         _closeButton.enable = false;
         _closeButton.mouseEnabled = false;
         _closeButton.mouseChildren = false;
         this._buyOnceBtn.enable = false;
         this._buyOnceBtn.mouseEnabled = false;
         this._buyOnceBtn.mouseChildren = false;
         this._buyTenTimesBtn.enable = false;
         this._buyTenTimesBtn.mouseEnabled = false;
         this._buyTenTimesBtn.mouseChildren = false;
      }
      
      private function showGainsAwardsAndresetBtns() : void
      {
         this.showGainsAwards();
         this.resetBtns();
      }
      
      private function resetBtns() : void
      {
         escEnable = true;
         if(_closeButton != null)
         {
            _closeButton.enable = true;
            _closeButton.mouseChildren = true;
            _closeButton.mouseEnabled = true;
         }
         if(this._buyOnceBtn != null)
         {
            this._buyOnceBtn.enable = true;
            this._buyOnceBtn.mouseEnabled = true;
            this._buyOnceBtn.mouseChildren = true;
         }
         if(this._buyTenTimesBtn != null)
         {
            this._buyTenTimesBtn.enable = true;
            this._buyTenTimesBtn.mouseEnabled = true;
            this._buyTenTimesBtn.mouseChildren = true;
         }
      }
      
      private function showNotification() : void
      {
         var moonName:String = null;
         var cakeName:String = null;
         var list:Vector.<WorshipTheMoonAwardsBoxInfo> = WorshipTheMoonModel.getInstance().getAwardsGainedBoxInfoList();
         var manager:ItemManager = ItemManager.Instance;
         var len:int = int(list.length);
         for(var i:int = 0; i < len; i++)
         {
            moonName = WorshipTheMoonAwardsBoxInfo.getMoonName(list[i].moonType);
            cakeName = WorshipTheMoonAwardsBoxInfo.getCakeName(list[i].moonType);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worshipTheMoon.notification",moonName,cakeName),0,true,3);
         }
      }
      
      private function showGainsAwards() : void
      {
         var i:int = 0;
         var j:int = 0;
         var arr:Array = new Array();
         var list:Vector.<WorshipTheMoonAwardsBoxInfo> = WorshipTheMoonModel.getInstance().getAwardsGainedBoxInfoList();
         var len:int = int(list.length);
         var manager:ItemManager = ItemManager.Instance;
         for(i = 0; i < len; i++)
         {
            arr[i] = {
               "info":manager.getTemplateById(list[i].id),
               "count":1
            };
         }
         var infos:Array = new Array();
         for(i = 0; i < len; i++)
         {
            j = 0;
            while(true)
            {
               if(j >= infos.length)
               {
                  infos.push(arr[i]);
                  break;
               }
               if(arr[i].info.TemplateID == infos[j].info.TemplateID)
               {
                  ++infos[j].count;
                  break;
               }
               j++;
            }
         }
         BagAndInfoManager.Instance.showPreviewFrame(LanguageMgr.GetTranslation("worshipTheMoon.preview.title"),infos);
      }
      
      override public function dispose() : void
      {
         var len:int = 0;
         var i:int = 0;
         this._awardsAfter200times != null && this._awardsAfter200times.removeEventListener(MouseEvent.CLICK,this.on200AwardsBoxClick);
         this.removeEventListener(MouseEvent.CLICK,this.onFrameClick);
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._animationWorshipTheMoon.removeEventListener("show_result",this.timeToLightAll);
         if(this._bg != null)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         this._listShiningMoonList.length = 0;
         this._listShiningMoonList = null;
         if(this._animationWorshipTheMoon != null)
         {
            this._animationWorshipTheMoon.gotoAndStop(1);
            len = this._animationWorshipTheMoon.numChildren;
            for(i = 0; i < len; i++)
            {
               if(this._animationWorshipTheMoon.getChildAt(i) is MovieClip)
               {
                  (this._animationWorshipTheMoon.getChildAt(i) as MovieClip).stop();
               }
            }
            ObjectUtils.disposeObject(this._animationWorshipTheMoon);
            this._animationWorshipTheMoon = null;
         }
         if(this._listAwardsMaybeGain != null)
         {
            this._listAwardsMaybeGain.length = 0;
            this._listAwardsMaybeGain = null;
         }
         if(this._buyOnceBtn != null)
         {
            ObjectUtils.disposeObject(this._buyOnceBtn);
            this._buyOnceBtn = null;
         }
         if(this._buyTenTimesBtn != null)
         {
            ObjectUtils.disposeObject(this._buyTenTimesBtn);
            this._buyTenTimesBtn = null;
         }
         if(this._timesRemainTitle != null)
         {
            ObjectUtils.disposeObject(this._timesRemainTitle);
            this._timesRemainTitle = null;
         }
         if(this._timesRemainTxt != null)
         {
            ObjectUtils.disposeObject(this._timesRemainTxt);
            this._timesRemainTxt = null;
         }
         if(this._listAwardsMaybeGain != null)
         {
            this._listAwardsMaybeGain.length = 0;
            this._listAwardsMaybeGain = null;
         }
         if(this._awardsAfter200times != null)
         {
            ObjectUtils.disposeObject(this._awardsAfter200times);
            this._awardsAfter200times = null;
         }
         if(this._coolShiningFor200TimesItem != null)
         {
            this._coolShiningFor200TimesItem.stop();
            ObjectUtils.disposeObject(this._coolShiningFor200TimesItem);
            this._coolShiningFor200TimesItem = null;
         }
         if(this._gained200 != null)
         {
            ObjectUtils.disposeObject(this._gained200);
            this._gained200 = null;
         }
         if(this._timesUsed != null)
         {
            ObjectUtils.disposeObject(this._timesUsed);
            this._timesUsed = null;
         }
         if(this._ruleDetails != null)
         {
            ObjectUtils.disposeObject(this._ruleDetails);
            this._ruleDetails = null;
         }
         if(this._tipClickToGain200 != null)
         {
            ObjectUtils.disposeObject(this._tipClickToGain200);
            this._tipClickToGain200 = null;
         }
         if(_closeButton != null)
         {
            ObjectUtils.disposeObject(_closeButton);
            _closeButton = null;
         }
         super.dispose();
      }
      
      private function _response(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         SoundManager.instance.play("008");
         WorshipTheMoonManager.getInstance().disposeMainFrame();
      }
      
      public function set model(value:WorshipTheMoonModel) : void
      {
         this._model = value;
      }
   }
}

