package bagAndInfo.bag
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class OpenBatchView extends BaseAlerFrame
   {
      
      private var _item:InventoryItemInfo;
      
      private var _txt:FilterFrameText;
      
      private var _inputBg:Bitmap;
      
      private var _inputText:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      public function OpenBatchView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set item(value:InventoryItemInfo) : void
      {
         this._item = value;
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         var _alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.bag.item.openBatch.titleStr"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _alertInfo.moveEnable = false;
         _alertInfo.autoDispose = false;
         _alertInfo.sound = "008";
         info = _alertInfo;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("openBatchView.promptTxt");
         this._txt.text = LanguageMgr.GetTranslation("ddt.bag.item.openBatch.promptStr");
         this._inputBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.openBatchView.inputBg");
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("openBatchView.inputTxt");
         this._inputText.text = "1";
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("openBatchView.maxBtn");
         addToContent(this._txt);
         addToContent(this._inputBg);
         addToContent(this._inputText);
         addToContent(this._maxBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHandler,false,0,true);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.changeMaxHandler,false,0,true);
         this._inputText.addEventListener(Event.CHANGE,this.inputTextChangeHandler,false,0,true);
      }
      
      private function changeMaxHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._item))
         {
            this._inputText.text = this._item.Count.toString();
         }
         if(this._item.Count >= 99)
         {
            this._inputText.text = 99 + "";
         }
      }
      
      private function inputTextChangeHandler(event:Event) : void
      {
         var num:int = 0;
         if(Boolean(this._item))
         {
            num = int(this._inputText.text);
            if(num >= 99)
            {
               num = 99;
               this._inputText.text = 99 + "";
            }
            if(num > this._item.Count)
            {
               this._inputText.text = this._item.Count.toString();
               if(this._item.Count >= 99)
               {
                  this._inputText.text = 99 + "";
               }
            }
            if(num < 1)
            {
               this._inputText.text = "1";
            }
         }
      }
      
      private function responseHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(Boolean(this._item))
               {
                  if(this._item.TemplateID == EquipType.DOUBLE_EXP_CARD || this._item.TemplateID == EquipType.DOUBLE_GESTE_CARD)
                  {
                     SocketManager.Instance.out.sendUseCard(this._item.BagType,this._item.Place,[this._item.TemplateID],this._item.PayType,false,true,int(this._inputText.text));
                  }
                  else if(this._item.TemplateID == EquipType.MY_CARDBOX || this._item.TemplateID == EquipType.MYSTICAL_CARDBOX)
                  {
                     SocketManager.Instance.out.sendOpenRandomBox(this._item.Place,int(this._inputText.text));
                  }
                  else if(this._item.CategoryID == EquipType.CARDBOX)
                  {
                     SocketManager.Instance.out.sendOpenCardBox(this._item.Place,int(this._inputText.text));
                  }
                  else if(this._item.Property5 == "-1")
                  {
                     SocketManager.Instance.out.treasurePuzzle_usePice(this._item.Place,int(this._inputText.text));
                  }
                  else
                  {
                     SocketManager.Instance.out.sendItemOpenUp(this._item.BagType,this._item.Place,int(this._inputText.text));
                  }
               }
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.responseHandler);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.changeMaxHandler);
         this._inputText.removeEventListener(Event.CHANGE,this.inputTextChangeHandler);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._item = null;
         this._txt = null;
         this._inputBg = null;
         this._inputText = null;
         this._maxBtn = null;
      }
   }
}

