package escort.view
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
   import escort.EscortManager;
   import escort.data.EscortCarInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class EscortFrameItemCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _titleTip:FilterFrameText;
      
      private var _awardInfoTxt1:FilterFrameText;
      
      private var _awardInfoTxt2:FilterFrameText;
      
      private var _awardInfoTxt3:FilterFrameText;
      
      private var _escortDefault:FilterFrameText;
      
      private var _escortBtn:TextButton;
      
      private var _index:int;
      
      private var _info:EscortCarInfo;
      
      private var _calledIcon:Bitmap;
      
      public function EscortFrameItemCell(index:int, info:EscortCarInfo)
      {
         super();
         this._index = index;
         this._info = info;
         this.initView();
         this.initEvent();
         this.refreshView(null);
         if(Boolean(this._escortBtn) && EscortManager.instance.freeCount <= 0)
         {
            this._escortBtn.enable = false;
         }
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.escort.cellBg" + this._index);
         this._calledIcon = ComponentFactory.Instance.creatBitmap("asset.escort.hasCalled");
         this._calledIcon.visible = false;
         this._titleTip = ComponentFactory.Instance.creatComponentByStylename("escort.frame.cellTitleTxt");
         this._titleTip.text = LanguageMgr.GetTranslation("escort.frame.cellTitleTxt");
         this._awardInfoTxt1 = ComponentFactory.Instance.creatComponentByStylename("escort.frame.cellAwardTxt");
         this._awardInfoTxt1.text = LanguageMgr.GetTranslation("escort.frame.cellAwardTxt1") + this._info.itemCount;
         this._awardInfoTxt2 = ComponentFactory.Instance.creatComponentByStylename("escort.frame.cellAwardTxt");
         PositionUtils.setPos(this._awardInfoTxt2,"escort.frame.cellAwardTxt2Pos");
         this._awardInfoTxt2.text = LanguageMgr.GetTranslation("escort.frame.cellAwardTxt2",this._info.itemCount);
         this._awardInfoTxt3 = ComponentFactory.Instance.creatComponentByStylename("escort.frame.cellAwardTxt");
         PositionUtils.setPos(this._awardInfoTxt3,"escort.frame.cellAwardTxt3Pos");
         this._awardInfoTxt3.text = LanguageMgr.GetTranslation("escort.frame.cellAwardTxt3") + this._info.prestige;
         addChild(this._bg);
         addChild(this._calledIcon);
         addChild(this._titleTip);
         addChild(this._awardInfoTxt1);
         addChild(this._awardInfoTxt3);
         if(this._index == 0)
         {
            this._escortDefault = ComponentFactory.Instance.creatComponentByStylename("escort.frame.cellTitleTxt");
            PositionUtils.setPos(this._escortDefault,"escort.frame.cellEscortTxtPos");
            this._escortDefault.text = LanguageMgr.GetTranslation("escort.frame.cellEscortTxt");
            addChild(this._escortDefault);
         }
         else
         {
            this._escortBtn = ComponentFactory.Instance.creatComponentByStylename("escort.frame.cellCallTxtbtn");
            this._escortBtn.text = LanguageMgr.GetTranslation("escort.frame.cellCallTxtbtnTxt");
            addChild(this._escortBtn);
         }
      }
      
      private function refreshView(event:Event) : void
      {
         if(EscortManager.instance.carStatus == this._index)
         {
            if(this._index != 0)
            {
               this._escortBtn.text = LanguageMgr.GetTranslation("escort.frame.cellCallTxtbtnTxt2");
               this._escortBtn.enable = false;
            }
            this._calledIcon.visible = true;
         }
         else
         {
            if(EscortManager.instance.carStatus > this._index && Boolean(this._escortBtn))
            {
               this._escortBtn.text = LanguageMgr.GetTranslation("escort.frame.cellCallTxtbtnTxt");
               this._escortBtn.enable = false;
            }
            this._calledIcon.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._escortBtn))
         {
            this._escortBtn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         }
         EscortManager.instance.addEventListener(EscortManager.CAR_STATUS_CHANGE,this.refreshView);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpObj:Object = EscortManager.instance.getBuyRecordStatus(0);
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
                  SocketManager.Instance.out.sendEscortCallCar(this._index,tmpObj.isBand);
                  return;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("moneyPoorNote"));
               tmpObj.isNoPrompt = false;
            }
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("escort.frame.callCarConfirmTxt",this._info.needMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"EscortBuyConfirmView",30,true,AlertManager.SELECTBTN);
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
               confirmFrame2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("escort.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               confirmFrame2.moveEnable = false;
               confirmFrame2.addEventListener(FrameEvent.RESPONSE,this.callCarReConfirm,false,0,true);
               return;
            }
            if(!confirmFrame.isBand && PlayerManager.Instance.Self.Money < this._info.needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if((confirmFrame as EscortBuyConfirmView).isNoPrompt)
            {
               tmpObj = EscortManager.instance.getBuyRecordStatus(0);
               tmpObj.isNoPrompt = true;
               tmpObj.isBand = confirmFrame.isBand;
            }
            SocketManager.Instance.out.sendEscortCallCar(this._index,confirmFrame.isBand);
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
            SocketManager.Instance.out.sendEscortCallCar(this._index,false);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._escortBtn))
         {
            this._escortBtn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         EscortManager.instance.removeEventListener(EscortManager.CAR_STATUS_CHANGE,this.refreshView);
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
         this._escortDefault = null;
         this._escortBtn = null;
         this._info = null;
         this._calledIcon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

