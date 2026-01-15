package Dice.View
{
   import Dice.Controller.DiceController;
   import Dice.Event.DiceEvent;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DiceSystemPanel extends Sprite implements Disposeable
   {
      
      private var _controller:DiceController;
      
      private var _bg:Bitmap;
      
      private var _startBG:Bitmap;
      
      private var _startArrow:Bitmap;
      
      private var _freeCount:FilterFrameText;
      
      private var _startBtn:ScaleFrameImage;
      
      private var _cellItem:Array;
      
      private var _target:int = -1;
      
      private var _baseAlert:BaseAlerFrame;
      
      private var _selectCheckBtn:SelectedCheckButton;
      
      private var _poorManAlert:BaseAlerFrame;
      
      public function DiceSystemPanel()
      {
         super();
         this.preInitialize();
      }
      
      public function set Controller(value:DiceController) : void
      {
         this._controller = value;
         this.initialize();
         this.addEvent();
      }
      
      private function initialize() : void
      {
         addChild(this._startBG);
         addChild(this._freeCount);
         addChild(this._startBtn);
         this._startBtn.buttonMode = true;
         this._startBtn.setFrame(DiceController.Instance.diceType + 1);
         this._freeCount.text = LanguageMgr.GetTranslation("dice.freeCount",DiceController.Instance.freeCount);
         this._cellItem = this._controller.cellIDs;
         if(!this._controller.hasUsedFirstCell)
         {
            if(this._startArrow == null)
            {
               this._startArrow = ComponentFactory.Instance.creatBitmap("asset.dice.startArrow");
            }
            addChild(this._startArrow);
         }
         var i:int = 0;
         while(i < this._cellItem.length && i < this._controller.CELL_COUNT)
         {
            if(Boolean(this._cellItem[i]))
            {
               addChild(this._cellItem[i]);
            }
            i++;
         }
      }
      
      private function preInitialize() : void
      {
         this._startBG = ComponentFactory.Instance.creatBitmap("asset.dice.bg1");
         this._freeCount = ComponentFactory.Instance.creatComponentByStylename("asset.dice.freeCount");
         this._startBtn = ComponentFactory.Instance.creatComponentByStylename("asset.dice.startBtn");
      }
      
      private function addEvent() : void
      {
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__onStartBtnClick);
         DiceController.Instance.addEventListener(DiceEvent.PLAYER_ISWALKING,this.__onPlayerState);
         DiceController.Instance.addEventListener(DiceEvent.GET_DICE_RESULT_DATA,this.__getDiceResultData);
         DiceController.Instance.addEventListener(DiceEvent.CHANGED_DICETYPE,this.__onDicetypeChanged);
         DiceController.Instance.addEventListener(DiceEvent.REFRESH_DATA,this.__onRefreshData);
         DiceController.Instance.addEventListener(DiceEvent.CHANGED_FREE_COUNT,this.__onFreeCountChanged);
      }
      
      private function removeEvent() : void
      {
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__onStartBtnClick);
         DiceController.Instance.removeEventListener(DiceEvent.PLAYER_ISWALKING,this.__onPlayerState);
         DiceController.Instance.removeEventListener(DiceEvent.GET_DICE_RESULT_DATA,this.__getDiceResultData);
         DiceController.Instance.removeEventListener(DiceEvent.CHANGED_DICETYPE,this.__onDicetypeChanged);
         DiceController.Instance.removeEventListener(DiceEvent.REFRESH_DATA,this.__onRefreshData);
         DiceController.Instance.removeEventListener(DiceEvent.CHANGED_FREE_COUNT,this.__onFreeCountChanged);
      }
      
      private function __onPlayerState(event:DiceEvent) : void
      {
         if(Boolean(event.resultData.isWalking))
         {
            this._startBtn.visible = false;
            DiceController.Instance.setDestinationCell(-1);
         }
         else
         {
            this._startBtn.visible = true;
            if(this._target != -1)
            {
               DiceController.Instance.setDestinationCell(this._target - 1);
            }
         }
      }
      
      private function __getDiceResultData(event:DiceEvent) : void
      {
         var _proxy:Object = event.resultData;
         if(Boolean(_proxy))
         {
            this._target = (int(_proxy.position) + int(_proxy.result)) % DiceController.Instance.CELL_COUNT;
            this._target += this._target < int(_proxy.position) && !DiceController.Instance.hasUsedFirstCell ? 1 : 0;
         }
         this._startBtn.visible = false;
      }
      
      private function __onStartBtnClick(event:MouseEvent) : void
      {
         var price:int = DiceController.Instance.commonDicePrice;
         if(DiceController.Instance.diceType == 1)
         {
            price = DiceController.Instance.doubleDicePrice;
         }
         else if(DiceController.Instance.diceType == 2)
         {
            price = DiceController.Instance.bigDicePrice;
         }
         else if(DiceController.Instance.diceType == 3)
         {
            price = DiceController.Instance.smallDicePrice;
         }
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < Number(price) && DiceController.Instance.freeCount <= 0)
         {
            if(Boolean(this._poorManAlert))
            {
               ObjectUtils.disposeObject(this._poorManAlert);
            }
            this._poorManAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            this._poorManAlert.moveEnable = false;
            this._poorManAlert.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            return;
         }
         this.AlertFeedeductionWindow();
      }
      
      private function __poorManResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._poorManAlert.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(this._poorManAlert);
         this._poorManAlert = null;
      }
      
      private function AlertFeedeductionWindow() : void
      {
         if(!DiceController.Instance.canPopupNextStartWindow && DiceController.Instance.freeCount <= 0)
         {
            this.openAlertFrame();
         }
         else
         {
            this._startBtn.visible = false;
            this.sendStartDataToServer();
         }
      }
      
      private function sendStartDataToServer() : void
      {
         GameInSocketOut.sendStartDiceInfo(DiceController.Instance.diceType,DiceController.Instance.CurrentPosition - 1);
      }
      
      private function openAlertFrame() : void
      {
         var type:String = null;
         var price:int = 0;
         var msg:String = null;
         if(this._selectCheckBtn == null)
         {
            this._selectCheckBtn = ComponentFactory.Instance.creatComponentByStylename("asset.dice.refreshAlert.selectedCheck");
            this._selectCheckBtn.text = LanguageMgr.GetTranslation("dice.alert.nextPrompt");
            this._selectCheckBtn.selected = DiceController.Instance.canPopupNextStartWindow;
            this._selectCheckBtn.addEventListener(MouseEvent.CLICK,this.__onCheckBtnClick);
         }
         switch(DiceController.Instance.diceType)
         {
            case 1:
               type = LanguageMgr.GetTranslation("dice.type.double");
               price = DiceController.Instance.doubleDicePrice;
               break;
            case 2:
               type = LanguageMgr.GetTranslation("dice.type.big");
               price = DiceController.Instance.bigDicePrice;
               break;
            case 3:
               type = LanguageMgr.GetTranslation("dice.type.small");
               price = DiceController.Instance.smallDicePrice;
               break;
            default:
               type = LanguageMgr.GetTranslation("dice.type.common");
               price = DiceController.Instance.commonDicePrice;
         }
         msg = LanguageMgr.GetTranslation("dice.type.prompt",type,price) + "\n\n";
         if(Boolean(this._baseAlert))
         {
            ObjectUtils.disposeObject(this._baseAlert);
         }
         this._baseAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,LayerManager.GAME_TOP_LAYER);
         this._baseAlert.addChild(this._selectCheckBtn);
         this._baseAlert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onCheckBtnClick(event:MouseEvent) : void
      {
         var _selectBtn:SelectedCheckButton = event.currentTarget as SelectedCheckButton;
         DiceController.Instance.setPopupNextStartWindow(_selectBtn.selected);
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._selectCheckBtn.removeEventListener(MouseEvent.CLICK,this.__onCheckBtnClick);
         ObjectUtils.disposeObject(this._selectCheckBtn);
         this._selectCheckBtn = null;
         alert.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.sendStartDataToServer();
         }
      }
      
      private function __onDicetypeChanged(event:DiceEvent) : void
      {
         this._startBtn.setFrame(DiceController.Instance.diceType + 1);
      }
      
      private function __onFreeCountChanged(event:DiceEvent) : void
      {
         this._freeCount.text = LanguageMgr.GetTranslation("dice.freeCount",DiceController.Instance.freeCount);
      }
      
      private function __onRefreshData(event:DiceEvent) : void
      {
         this.initialize();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._startBtn);
         this._startBtn = null;
         ObjectUtils.disposeObject(this._startBG);
         this._startBG = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._startArrow);
         this._startArrow = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

