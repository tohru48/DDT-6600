package drgnBoat.views
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
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import drgnBoat.DrgnBoatManager;
   import drgnBoat.data.DrgnBoatCarInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DrgnBoatFrameItemCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _awardBmp:Bitmap;
      
      private var _currentBoat:Bitmap;
      
      private var _awardInfoTxt1:FilterFrameText;
      
      private var _awardInfoTxt2:FilterFrameText;
      
      private var _defaultTxt:FilterFrameText;
      
      private var _dressUpBtn:TextButton;
      
      private var _index:int;
      
      private var _info:DrgnBoatCarInfo;
      
      public function DrgnBoatFrameItemCell(index:int, info:DrgnBoatCarInfo)
      {
         super();
         this._index = index;
         this._info = info;
         this.initView();
         this.initEvent();
         this.refreshView(null);
         if(Boolean(this._dressUpBtn) && DrgnBoatManager.instance.freeCount <= 0)
         {
            this._dressUpBtn.enable = false;
         }
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("drgnBoat.cellBg" + this._index);
         addChild(this._bg);
         this._awardBmp = ComponentFactory.Instance.creat("drgnBoat.award");
         addChild(this._awardBmp);
         this._currentBoat = ComponentFactory.Instance.creat("drgnBoat.currentBoat");
         addChild(this._currentBoat);
         this._currentBoat.visible = false;
         this._awardInfoTxt1 = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.awardTxt");
         var item:InventoryItemInfo = new InventoryItemInfo();
         item.TemplateID = this._info.awardArr[0].templateId;
         ItemManager.fill(item);
         this._awardInfoTxt1.text = LanguageMgr.GetTranslation("drgnBoat.race.awardInfo1",item.Name,this._info.awardArr[0].count);
         addChild(this._awardInfoTxt1);
         this._awardInfoTxt2 = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.awardTxt");
         PositionUtils.setPos(this._awardInfoTxt2,"drgnBoat.race.awardTxtPos");
         item = new InventoryItemInfo();
         item.TemplateID = this._info.awardArr[1].templateId;
         ItemManager.fill(item);
         this._awardInfoTxt2.text = LanguageMgr.GetTranslation("drgnBoat.race.awardInfo1",item.Name,this._info.awardArr[1].count);
         addChild(this._awardInfoTxt2);
         switch(this._index)
         {
            case 0:
               this._defaultTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.defaultTxt");
               this._defaultTxt.text = LanguageMgr.GetTranslation("drgnBoat.race.noDress");
               addChild(this._defaultTxt);
               break;
            case 1:
               this._dressUpBtn = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.dressUpTxtbtn");
               this._dressUpBtn.text = LanguageMgr.GetTranslation("drgnBoat.race.normalDress");
               addChild(this._dressUpBtn);
               break;
            case 2:
               this._dressUpBtn = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.dressUpTxtbtn");
               this._dressUpBtn.text = LanguageMgr.GetTranslation("drgnBoat.race.luxuriousDress");
               addChild(this._dressUpBtn);
         }
      }
      
      private function refreshView(event:Event) : void
      {
         if(DrgnBoatManager.instance.carStatus == this._index)
         {
            this._currentBoat.visible = true;
            if(this._index != 0)
            {
               this._dressUpBtn.enable = false;
            }
         }
         else
         {
            this._currentBoat.visible = false;
            if(DrgnBoatManager.instance.carStatus > this._index && Boolean(this._dressUpBtn))
            {
               this._dressUpBtn.enable = false;
            }
         }
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._dressUpBtn))
         {
            this._dressUpBtn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         }
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.CAR_STATUS_CHANGE,this.refreshView);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpObj:Object = DrgnBoatManager.instance.getBuyRecordStatus(0);
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
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("drgnBoat.frame.callCarConfirmTxt",this._info.needMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"DrgnBoatBuyConfirmView",30,true,AlertManager.SELECTBTN);
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
            if((confirmFrame as DrgnBoatBuyConfirmView).isNoPrompt)
            {
               tmpObj = DrgnBoatManager.instance.getBuyRecordStatus(0);
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
         if(Boolean(this._dressUpBtn))
         {
            this._dressUpBtn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.CAR_STATUS_CHANGE,this.refreshView);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._awardInfoTxt1 = null;
         this._awardInfoTxt2 = null;
         this._defaultTxt = null;
         this._dressUpBtn = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

