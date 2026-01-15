package store.newFusion.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import store.newFusion.FusionNewManager;
   import store.newFusion.data.FusionNewVo;
   
   public class FusionNewRightView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _fusionBg:Bitmap;
      
      private var _successBg:Bitmap;
      
      private var _fusionCell:BagCell;
      
      private var _materialList:Vector.<FusionNewMaterialCell>;
      
      private var _data:FusionNewVo;
      
      private var _successTipTxt:FilterFrameText;
      
      private var _successRateTxt:FilterFrameText;
      
      private var _needMoneyTipTxt:FilterFrameText;
      
      private var _needMoneyNumTxt:FilterFrameText;
      
      private var _moneyIcon:Bitmap;
      
      private var _fusionBtn:SimpleBitmapButton;
      
      private var _stopBtn:SimpleBitmapButton;
      
      private var _inputNumBg:Bitmap;
      
      private var _inputNumTxt:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _maxNum:int;
      
      private var _inCount:int = 0;
      
      private var _isInFusion:Boolean = false;
      
      private var _coverSprite:Sprite;
      
      private var _previewTxt:FilterFrameText;
      
      private var _fusionNameTxt:FilterFrameText;
      
      private var _fusionNum:int;
      
      private var _fusionAttribute:SelectedCheckButton;
      
      public function FusionNewRightView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmp:FusionNewMaterialCell = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.newFusion.rightViewBg");
         this._fusionBg = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipmentCellBg");
         PositionUtils.setPos(this._fusionBg,"store.newFusion.rightView.fusionBgPos");
         this._successBg = ComponentFactory.Instance.creatBitmap("asset.newFusion.successBg");
         addChild(this._bg);
         addChild(this._fusionBg);
         addChild(this._successBg);
         this._inputNumBg = ComponentFactory.Instance.creatBitmap("asset.newFusion.inputBg");
         this._inputNumTxt = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.inputTxt");
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.maxBtn");
         addChild(this._inputNumBg);
         addChild(this._inputNumTxt);
         addChild(this._maxBtn);
         this._successTipTxt = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.rightView.successTipTxt");
         this._successTipTxt.text = LanguageMgr.GetTranslation("ddt.store.newFusion.rightView.successTipTxt");
         this._successRateTxt = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.rightView.successRateTxt");
         this._needMoneyTipTxt = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.rightView.successTipTxt");
         PositionUtils.setPos(this._needMoneyTipTxt,"store.newFusion.rightView.needMoneyTipTxtPos");
         this._needMoneyTipTxt.text = LanguageMgr.GetTranslation("ddt.store.newFusion.rightView.needMoneyTipTxt");
         this._needMoneyNumTxt = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.rightView.needMoneyNumTxt");
         this._needMoneyNumTxt.text = "1600";
         this._moneyIcon = ComponentFactory.Instance.creatBitmap("asset.ddtcore.Gold");
         PositionUtils.setPos(this._moneyIcon,"store.newFusion.rightView.moneyIconPos");
         addChild(this._successTipTxt);
         addChild(this._successRateTxt);
         addChild(this._needMoneyTipTxt);
         addChild(this._needMoneyNumTxt);
         addChild(this._moneyIcon);
         this._fusionBtn = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.fusionBtn");
         addChild(this._fusionBtn);
         this._coverSprite = new Sprite();
         this._coverSprite.x = -1000;
         this._coverSprite.y = -600;
         this._coverSprite.graphics.beginFill(0,0);
         this._coverSprite.graphics.drawRect(0,0,2000,1200);
         this._coverSprite.graphics.endFill();
         addChild(this._coverSprite);
         this._coverSprite.visible = false;
         this._stopBtn = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.stopBtn");
         addChild(this._stopBtn);
         this._stopBtn.visible = false;
         this._fusionCell = new BagCell(1,null,true,null,false);
         this._fusionCell.x = this._fusionBg.x + 30;
         this._fusionCell.y = this._fusionBg.y + 33;
         this._fusionCell.setBgVisible(false);
         addChild(this._fusionCell);
         this._materialList = new Vector.<FusionNewMaterialCell>();
         for(i = 0; i < 4; i++)
         {
            tmp = new FusionNewMaterialCell(i + 1);
            tmp.x = 213 + i % 2 * (30 + tmp.width);
            tmp.y = 53 + int(i / 2) * (30 + tmp.height);
            addChild(tmp);
            this._materialList.push(tmp);
         }
         this._previewTxt = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.rightView.previewTxt");
         this._previewTxt.text = LanguageMgr.GetTranslation("store.view.fusion.PreviewFrame.preview");
         addChild(this._previewTxt);
         this._fusionNameTxt = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.rightView.fusionNameTxt");
         addChild(this._fusionNameTxt);
         this._fusionAttribute = ComponentFactory.Instance.creatComponentByStylename("store.newFusion.rightView.fusionAttribute");
         this._fusionAttribute.text = LanguageMgr.GetTranslation("store.view.fusion.PreviewFrame.fusionAttribute");
         addChild(this._fusionAttribute);
         this._fusionAttribute.visible = false;
         this._fusionAttribute.selected = true;
      }
      
      private function initEvent() : void
      {
         this._fusionBtn.addEventListener(MouseEvent.CLICK,this.fusionHandler,false,0,true);
         this._stopBtn.addEventListener(MouseEvent.CLICK,this.stopHandler,false,0,true);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.changeMaxHandler,false,0,true);
         this._inputNumTxt.addEventListener(Event.CHANGE,this.inputTextChangeHandler,false,0,true);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_FUSION,this.fusionCompleteHandler);
      }
      
      private function stopHandler(event:MouseEvent) : void
      {
         this._isInFusion = false;
         --this._inCount;
         this.stopContinuousView();
         this.refreshView(this._data);
      }
      
      private function stopContinuousView() : void
      {
         this._stopBtn.visible = false;
         this._coverSprite.visible = false;
         FusionNewManager.instance.isInContinuousFusion = false;
      }
      
      private function startContinuousView() : void
      {
         this._stopBtn.visible = true;
         this._coverSprite.visible = true;
         FusionNewManager.instance.isInContinuousFusion = true;
      }
      
      private function fusionCompleteHandler(evt:CrazyTankSocketEvent) : void
      {
         if(Boolean(this._data) && this._data.FusionRate < 100)
         {
            if(this._isInFusion)
            {
               --this._inCount;
               if(this._inCount > 0 && this.checkGoldEnough())
               {
                  this._inputNumTxt.text = this._inCount.toString();
                  setTimeout(this.delayFusion,500);
               }
               else
               {
                  this._isInFusion = false;
                  this.stopContinuousView();
                  this.refreshView(this._data);
               }
            }
         }
         else
         {
            this._isInFusion = false;
            this.stopContinuousView();
            this.refreshView(this._data);
         }
      }
      
      private function delayFusion() : void
      {
         if(this._isInFusion)
         {
            this.fusionItem(1);
         }
      }
      
      private function changeMaxHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._inputNumTxt.text = this._maxNum.toString();
      }
      
      private function inputTextChangeHandler(event:Event) : void
      {
         var num:int = int(this._inputNumTxt.text);
         if(num < 1)
         {
            this._inputNumTxt.text = "1";
         }
         if(num > this._maxNum)
         {
            this._inputNumTxt.text = this._maxNum.toString();
         }
      }
      
      private function fusionHandler(event:MouseEvent) : void
      {
         var fusionNum:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!this.checkGoldEnough())
         {
            return;
         }
         var tmpNumInput:int = int(this._inputNumTxt.text);
         if(tmpNumInput <= 0)
         {
            return;
         }
         if(this._data.FusionRate >= 100 || tmpNumInput == 1)
         {
            fusionNum = tmpNumInput;
            this._inCount = 0;
            this._isInFusion = false;
         }
         else
         {
            fusionNum = 1;
            this._inCount = tmpNumInput;
            this._isInFusion = true;
            this.startContinuousView();
         }
         this.fusionItem(fusionNum);
      }
      
      private function fusionItem(num:int) : void
      {
         var alert:BaseAlerFrame = null;
         if(this._data.isNeedPopBindTipWindow(num))
         {
            this._fusionNum = num;
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.store.newFusion.bindTipTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._response2);
            this._isInFusion = false;
            --this._inCount;
            this.stopContinuousView();
         }
         else
         {
            SocketManager.Instance.out.sendItemFusion(this._data.FusionID,num,this._fusionAttribute.selected);
         }
      }
      
      private function _response2(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response2);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            SocketManager.Instance.out.sendItemFusion(this._data.FusionID,this._fusionNum,this._fusionAttribute.selected);
         }
      }
      
      private function checkGoldEnough() : Boolean
      {
         var alert:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.Gold < 1600)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseV);
            return false;
         }
         return true;
      }
      
      private function _responseV(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFastPurchaseGold();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = EquipType.GOLD_BOX;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function refreshView(data:FusionNewVo) : void
      {
         if(this._data != data)
         {
            this._inCount = 0;
         }
         this._data = data;
         if(Boolean(this._data))
         {
            if(!this._isInFusion)
            {
               this._fusionCell.info = this._data.fusionItemInfo;
               this._fusionCell.visible = true;
               this._successRateTxt.text = this._data.FusionRate <= 5 ? LanguageMgr.GetTranslation("store.fusion.preview.LowRate") : this._data.FusionRate + "%";
               this._successRateTxt.visible = true;
               this._fusionNameTxt.text = this._data.fusionItemInfo.Name;
               this._fusionNameTxt.visible = true;
               this._fusionAttribute.visible = data.FusionType == FusionNewVo.JEWELLRY_TYPE ? true : false;
               this._maxNum = this._data.canFusionCount;
               if(this._maxNum > 0)
               {
                  this._inputNumTxt.text = this._inCount > 0 ? this._inCount.toString() : "1";
                  this._fusionBtn.enable = true;
               }
               else
               {
                  this._inputNumTxt.text = "0";
                  this._fusionBtn.enable = false;
               }
               this._inputNumTxt.visible = true;
               this._maxBtn.enable = true;
            }
         }
         else
         {
            this._fusionCell.visible = false;
            this._successRateTxt.visible = false;
            this._fusionNameTxt.visible = false;
            this._fusionAttribute.visible = false;
            this._maxNum = 0;
            this._inputNumTxt.text = "0";
            this._inputNumTxt.visible = false;
            this._maxBtn.enable = false;
            this._fusionBtn.enable = false;
         }
         for(var i:int = 0; i < 4; i++)
         {
            this._materialList[i].refreshView(this._data);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._fusionBtn))
         {
            this._fusionBtn.removeEventListener(MouseEvent.CLICK,this.fusionHandler);
         }
         if(Boolean(this._stopBtn))
         {
            this._stopBtn.removeEventListener(MouseEvent.CLICK,this.stopHandler);
         }
         if(Boolean(this._maxBtn))
         {
            this._maxBtn.removeEventListener(MouseEvent.CLICK,this.changeMaxHandler);
         }
         if(Boolean(this._inputNumTxt))
         {
            this._inputNumTxt.removeEventListener(Event.CHANGE,this.inputTextChangeHandler);
         }
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_FUSION,this.fusionCompleteHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._fusionBg = null;
         this._successBg = null;
         this._inputNumBg = null;
         this._inputNumTxt = null;
         this._maxBtn = null;
         this._successTipTxt = null;
         this._successRateTxt = null;
         this._needMoneyTipTxt = null;
         this._needMoneyNumTxt = null;
         this._moneyIcon = null;
         this._fusionBtn = null;
         this._coverSprite = null;
         this._stopBtn = null;
         this._fusionCell = null;
         this._previewTxt = null;
         this._fusionNameTxt = null;
         this._materialList = null;
         this._data = null;
         if(Boolean(this._fusionAttribute))
         {
            ObjectUtils.disposeObject(this._fusionAttribute);
         }
         this._fusionAttribute = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

