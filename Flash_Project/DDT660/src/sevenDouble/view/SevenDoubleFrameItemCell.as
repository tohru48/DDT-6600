package sevenDouble.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import sevenDouble.SevenDoubleManager;
   import sevenDouble.data.SevenDoubleCarInfo;
   
   public class SevenDoubleFrameItemCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _titleTip:FilterFrameText;
      
      private var _awardInfoTxt1:FilterFrameText;
      
      private var _awardInfoTxt2:FilterFrameText;
      
      private var _awardInfoTxt3:FilterFrameText;
      
      private var _sevenDoubleDefault:FilterFrameText;
      
      private var _sevenDoubleBtn:TextButton;
      
      private var _index:int;
      
      private var _info:SevenDoubleCarInfo;
      
      private var _calledIcon:Bitmap;
      
      public function SevenDoubleFrameItemCell(index:int, info:SevenDoubleCarInfo)
      {
         super();
         this._index = index;
         this._info = info;
         this.initView();
         this.initEvent();
         this.refreshView(null);
         if(this._sevenDoubleBtn && SevenDoubleManager.instance.freeCount <= 0 && SevenDoubleManager.instance.usableCount <= 0)
         {
            this._sevenDoubleBtn.enable = false;
         }
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.sevenDouble.cellBg" + this._index);
         this._calledIcon = ComponentFactory.Instance.creatBitmap("asset.sevenDouble.hasCalled");
         this._calledIcon.visible = false;
         this._titleTip = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.cellTitleTxt");
         this._titleTip.text = LanguageMgr.GetTranslation("sevenDouble.frame.cellTitleTxt");
         this._awardInfoTxt1 = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.cellAwardTxt");
         this._awardInfoTxt1.text = LanguageMgr.GetTranslation("sevenDouble.frame.cellAwardTxt1") + this._info.prestige;
         this._awardInfoTxt2 = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.cellAwardTxt");
         PositionUtils.setPos(this._awardInfoTxt2,"sevenDouble.frame.cellAwardTxt2Pos");
         this._awardInfoTxt2.text = LanguageMgr.GetTranslation("sevenDouble.frame.cellAwardTxt2",this._info.itemCount);
         this._awardInfoTxt3 = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.cellAwardTxt");
         PositionUtils.setPos(this._awardInfoTxt3,"sevenDouble.frame.cellAwardTxt3Pos");
         this._awardInfoTxt3.text = LanguageMgr.GetTranslation("sevenDouble.frame.cellAwardTxt3",this._info.speed);
         addChild(this._bg);
         addChild(this._calledIcon);
         addChild(this._titleTip);
         addChild(this._awardInfoTxt1);
         addChild(this._awardInfoTxt2);
         addChild(this._awardInfoTxt3);
         if(this._index == 0)
         {
            this._sevenDoubleDefault = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.cellTitleTxt");
            PositionUtils.setPos(this._sevenDoubleDefault,"sevenDouble.frame.cellSevenDoubleTxtPos");
            this._sevenDoubleDefault.text = LanguageMgr.GetTranslation("sevenDouble.frame.cellsevenDoubleTxt");
            addChild(this._sevenDoubleDefault);
         }
         else
         {
            this._sevenDoubleBtn = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.cellCallTxtbtn");
            this._sevenDoubleBtn.text = LanguageMgr.GetTranslation("sevenDouble.frame.cellCallTxtbtnTxt");
            this._sevenDoubleBtn.x = 45;
            addChild(this._sevenDoubleBtn);
         }
      }
      
      private function refreshView(event:Event) : void
      {
         if(SevenDoubleManager.instance.carStatus == this._index)
         {
            if(this._index != 0)
            {
               this._sevenDoubleBtn.text = LanguageMgr.GetTranslation("sevenDouble.frame.cellCallTxtbtnTxt2");
               this._sevenDoubleBtn.x = 35;
               this._sevenDoubleBtn.enable = false;
            }
            this._calledIcon.visible = true;
         }
         else
         {
            if(SevenDoubleManager.instance.carStatus > this._index && Boolean(this._sevenDoubleBtn))
            {
               this._sevenDoubleBtn.text = LanguageMgr.GetTranslation("sevenDouble.frame.cellCallTxtbtnTxt");
               this._sevenDoubleBtn.x = 45;
               this._sevenDoubleBtn.enable = false;
            }
            this._calledIcon.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._sevenDoubleBtn))
         {
            this._sevenDoubleBtn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         }
         SevenDoubleManager.instance.addEventListener(SevenDoubleManager.CAR_STATUS_CHANGE,this.refreshView);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpObj:Object = SevenDoubleManager.instance.getBuyRecordStatus(0);
         tmpObj.isBand = false;
         if(Boolean(tmpObj.isNoPrompt))
         {
            if(Boolean(tmpObj.isBand) && PlayerManager.Instance.Self.BandMoney < this._info.needMoney)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bindMoneyPoorNote"));
               tmpObj.isNoPrompt = false;
            }
            else
            {
               if(!(!tmpObj.isBand && PlayerManager.Instance.Self.Money < this._info.needMoney))
               {
                  SocketManager.Instance.out.sendSevenDoubleCallCar(this._index,tmpObj.isBand);
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("moneyPoorNote"));
               tmpObj.isNoPrompt = false;
            }
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.frame.callCarConfirmTxt",this._info.needMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SevenDoubleBuyConfirmView",30,true,AlertManager.NOSELECTBTN);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.callConfirm,false,0,true);
      }
      
      private function callConfirm(evt:FrameEvent) : void
      {
         var confirmFrame2:BaseAlerFrame = null;
         var tmpObj:Object = null;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.callConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(confirmFrame.isBand && PlayerManager.Instance.Self.BandMoney < this._info.needMoney)
            {
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.callCarReConfirm,false,0,true);
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < this._info.needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as SevenDoubleBuyConfirmView).isNoPrompt)
            {
               tmpObj = SevenDoubleManager.instance.getBuyRecordStatus(0);
               tmpObj.isNoPrompt = true;
               tmpObj.isBand = confirmFrame.isBand;
            }
            SocketManager.Instance.out.sendSevenDoubleCallCar(this._index,confirmFrame.isBand);
         }
      }
      
      private function callCarReConfirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.callCarReConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < this._info.needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendSevenDoubleCallCar(this._index,false);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._sevenDoubleBtn))
         {
            this._sevenDoubleBtn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         SevenDoubleManager.instance.removeEventListener(SevenDoubleManager.CAR_STATUS_CHANGE,this.refreshView);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._titleTip = null;
         this._awardInfoTxt1 = null;
         this._awardInfoTxt2 = null;
         this._awardInfoTxt3 = null;
         this._sevenDoubleDefault = null;
         this._sevenDoubleBtn = null;
         this._info = null;
         this._calledIcon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

