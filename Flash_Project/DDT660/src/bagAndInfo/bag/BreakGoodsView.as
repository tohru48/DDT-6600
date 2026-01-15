package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class BreakGoodsView extends BaseAlerFrame
   {
      
      private static const EnterKeyCode:int = 13;
      
      private static const ESCkeyCode:int = 27;
      
      private var _input:FilterFrameText;
      
      private var _NumString:FilterFrameText;
      
      private var _tipString:FilterFrameText;
      
      private var _inputBG:Scale9CornerImage;
      
      private var _cell:BagCell;
      
      private var _upBtn:SimpleBitmapButton;
      
      private var _downBtn:SimpleBitmapButton;
      
      public function BreakGoodsView()
      {
         super();
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         var _alertInfo:AlertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.split");
         info = _alertInfo;
         this._input = ComponentFactory.Instance.creatComponentByStylename("breakGoodsInput");
         this._input.text = "1";
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("breakInputbg");
         this._inputBG.x = this._input.x - 1;
         this._inputBG.y = this._input.y - 2;
         addToContent(this._inputBG);
         addToContent(this._input);
         this._NumString = ComponentFactory.Instance.creatComponentByStylename("breakGoodsNumText");
         this._NumString.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.num");
         addToContent(this._NumString);
         this._tipString = ComponentFactory.Instance.creatComponentByStylename("breakGoodsPleasEnterText");
         this._tipString.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.input");
         addToContent(this._tipString);
         submitButtonEnable = false;
         this._upBtn = ComponentFactory.Instance.creatComponentByStylename("breakUpButton");
         addToContent(this._upBtn);
         this._downBtn = ComponentFactory.Instance.creatComponentByStylename("breakDownButton");
         addToContent(this._downBtn);
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._input.addEventListener(Event.CHANGE,this.__input);
         this._input.addEventListener(KeyboardEvent.KEY_UP,this.__onInputKeyUp);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__onToStage);
         this._upBtn.addEventListener(MouseEvent.CLICK,this.__onUpBtn);
         this._downBtn.addEventListener(MouseEvent.CLICK,this.__onDownBtn);
      }
      
      private function __onUpBtn(e:Event) : void
      {
         var tempInt:int = int(this._input.text);
         tempInt++;
         this._input.text = String(tempInt);
         this.downBtnEnable();
      }
      
      private function __onDownBtn(e:Event) : void
      {
         var tempInt:int = int(this._input.text);
         if(tempInt == 0)
         {
            return;
         }
         tempInt--;
         this._input.text = String(tempInt);
         this.downBtnEnable();
      }
      
      private function __onToStage(evt:Event) : void
      {
      }
      
      private function __onInputKeyUp(evt:KeyboardEvent) : void
      {
         switch(evt.keyCode)
         {
            case EnterKeyCode:
               this.okFun();
               break;
            case ESCkeyCode:
               this.dispose();
         }
      }
      
      private function __getFocus(event:Event) : void
      {
         this._input.setFocus();
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._input))
         {
            this._input.removeEventListener(Event.CHANGE,this.__input);
            this._input.removeEventListener(KeyboardEvent.KEY_UP,this.__onInputKeyUp);
         }
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__onToStage);
         removeEventListener(MouseEvent.CLICK,this.__onUpBtn);
         removeEventListener(MouseEvent.CLICK,this.__onDownBtn);
      }
      
      private function __input(e:Event) : void
      {
         submitButtonEnable = this._input.text != "";
         this.downBtnEnable();
      }
      
      private function downBtnEnable() : void
      {
         if(!this._input.text || this._input.text == "" || int(this._input.text) < 1)
         {
            this._downBtn.enable = false;
         }
         else
         {
            this._downBtn.enable = true;
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __okClickCall(e:ComponentEvent) : void
      {
         this.okFun();
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.okFun();
         }
      }
      
      private function getFocus() : void
      {
         if(Boolean(stage))
         {
            stage.focus = this._input;
         }
      }
      
      private function okFun() : void
      {
         var info:InventoryItemInfo = null;
         var toPlace:int = 0;
         var currentBagInfo:BagInfo = null;
         var i:int = 0;
         var j:int = 0;
         SoundManager.instance.play("008");
         var n:int = int(this._input.text);
         if(n > 0 && n < this._cell.itemInfo.Count)
         {
            info = this._cell.splitItem(n);
            toPlace = -1;
            currentBagInfo = PlayerManager.Instance.Self.getBag(info.BagType);
            if(info.BagType == BagInfo.EQUIPBAG)
            {
               i = 31;
               while(true)
               {
                  if(i < 80)
                  {
                     if(currentBagInfo.items[i] != null)
                     {
                        continue;
                     }
                     toPlace = i;
                  }
                  i++;
               }
            }
            else if(info.BagType == BagInfo.PROPBAG)
            {
               for(j = 0; j < 49; j++)
               {
                  if(currentBagInfo.items[j] == null)
                  {
                     toPlace = j;
                     break;
                  }
               }
            }
            if(toPlace == -1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.BreakFail"));
            }
            else
            {
               SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,info.BagType,toPlace,info.Count);
            }
            this.dispose();
         }
         else if(n == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.wrong2"));
            this._input.text = "";
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.right"));
            this._input.text = "";
         }
      }
      
      override public function dispose() : void
      {
         SoundManager.instance.play("008");
         this.removeEvent();
         ObjectUtils.disposeObject(this._inputBG);
         this._inputBG = null;
         ObjectUtils.disposeObject(this._input);
         this._input = null;
         ObjectUtils.disposeObject(this._NumString);
         this._NumString = null;
         ObjectUtils.disposeObject(this._tipString);
         this._tipString = null;
         this._cell = null;
         if(Boolean(this._upBtn))
         {
            ObjectUtils.disposeObject(this._upBtn);
         }
         this._upBtn = null;
         if(Boolean(this._downBtn))
         {
            ObjectUtils.disposeObject(this._downBtn);
         }
         this._downBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
      
      public function get cell() : BagCell
      {
         return this._cell;
      }
      
      public function set cell(value:BagCell) : void
      {
         this._cell = value;
      }
   }
}

