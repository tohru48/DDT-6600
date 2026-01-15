package store.view.fusion
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class FusionSelectNumAlertFrame extends BaseAlerFrame
   {
      
      private var _alertInfo:AlertInfo;
      
      private var _bg:Bitmap;
      
      private var _btn1:BaseButton;
      
      private var _btn2:BaseButton;
      
      private var _inputText:FilterFrameText;
      
      private var _inputBg:Image;
      
      private var _maxNum:int = 0;
      
      private var _minNum:int = 1;
      
      private var _nowNum:int = 1;
      
      public var index:int;
      
      private var _goodsinfo:InventoryItemInfo;
      
      public function FusionSelectNumAlertFrame()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("store.fusion.autoSplit.inputNumber"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._btn1 = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerBt1");
         this._btn2 = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerBt2");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtstore.FusionSpiltTextrBg");
         this._inputBg = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerInputTextBG");
         this._inputText = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerInputText");
         this._inputText.restrict = "0-9";
         addToContent(this._bg);
         addToContent(this._inputBg);
         addToContent(this._btn1);
         addToContent(this._btn2);
         addToContent(this._inputText);
      }
      
      public function show(max:int = 5, min:int = 1) : void
      {
         this._maxNum = max;
         this._minNum = min;
         this._nowNum = this._maxNum;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function upSee() : void
      {
         this._inputText.text = this._nowNum.toString();
         this._upbtView();
      }
      
      private function removeView() : void
      {
         if(Boolean(this._alertInfo))
         {
            this._alertInfo = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._inputBg))
         {
            ObjectUtils.disposeObject(this._inputBg);
         }
         this._inputBg = null;
         if(Boolean(this._btn1))
         {
            ObjectUtils.disposeObject(this._btn1);
         }
         this._btn1 = null;
         if(Boolean(this._btn2))
         {
            ObjectUtils.disposeObject(this._btn2);
         }
         this._btn2 = null;
         if(Boolean(this._inputText))
         {
            ObjectUtils.disposeObject(this._inputText);
         }
         this._inputText = null;
      }
      
      private function setEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._inputText.addEventListener(Event.CHANGE,this._changeInput);
         this._inputText.addEventListener(KeyboardEvent.KEY_DOWN,this.__enterHanlder);
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._btn1.addEventListener(MouseEvent.CLICK,this.click_btn1);
         this._btn2.addEventListener(MouseEvent.CLICK,this.click_btn2);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         if(Boolean(this._inputText))
         {
            this._inputText.removeEventListener(Event.CHANGE,this._changeInput);
         }
         if(Boolean(this._inputText))
         {
            this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN,this.__enterHanlder);
         }
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(Boolean(this._btn1))
         {
            this._btn1.removeEventListener(MouseEvent.CLICK,this.click_btn1);
         }
         if(Boolean(this._btn2))
         {
            this._btn2.removeEventListener(MouseEvent.CLICK,this.click_btn2);
         }
      }
      
      private function __addToStageHandler(e:Event) : void
      {
         this._inputText.appendText(this._nowNum.toString());
         this._inputText.setFocus();
         this._upbtView();
      }
      
      private function _changeInput(e:Event) : void
      {
         if(int(this._inputText.text) == 0)
         {
            this._nowNum = 1;
         }
         else if(int(this._inputText.text) > this._maxNum)
         {
            this._nowNum = this._maxNum;
         }
         else
         {
            this._nowNum = int(this._inputText.text);
         }
         this.upSee();
      }
      
      private function __enterHanlder(event:KeyboardEvent) : void
      {
         event.stopImmediatePropagation();
         if(event.keyCode == Keyboard.ENTER)
         {
            this.__confirm();
         }
         if(event.keyCode == Keyboard.ESCAPE)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function click_btn1(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._nowNum += 1;
         this.upSee();
      }
      
      private function click_btn2(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._nowNum -= 1;
         this.upSee();
      }
      
      private function _upbtView() : void
      {
         this._btn1.enable = true;
         this._btn2.enable = true;
         if(this._nowNum == this._minNum)
         {
            this._btn2.enable = false;
         }
         else if(this._nowNum == this._maxNum)
         {
            this._btn1.enable = false;
         }
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         var e:FusionSelectEvent = null;
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               e = new FusionSelectEvent(FusionSelectEvent.NOTSELL,this._nowNum);
               e.info = this.goodsinfo;
               e.index = this.index;
               dispatchEvent(e);
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.__confirm();
         }
      }
      
      private function __confirm() : void
      {
         var e:FusionSelectEvent = null;
         if(int(this._inputText.text) >= this._maxNum)
         {
            this._nowNum = this._maxNum;
         }
         else if(int(this._inputText.text) == 0)
         {
            this._nowNum = 1;
         }
         e = new FusionSelectEvent(FusionSelectEvent.SELL,this._nowNum);
         e.info = this.goodsinfo;
         e.index = this.index;
         dispatchEvent(e);
      }
      
      public function get goodsinfo() : InventoryItemInfo
      {
         return this._goodsinfo;
      }
      
      public function set goodsinfo(value:InventoryItemInfo) : void
      {
         this._goodsinfo = value;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}

