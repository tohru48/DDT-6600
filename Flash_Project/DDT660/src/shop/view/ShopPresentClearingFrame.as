package shop.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.NameInputDropListTarget;
   import ddt.view.chat.ChatFriendListPanel;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ShopPresentClearingFrame extends Frame
   {
      
      public static const GIVETYPE:int = 0;
      
      public static const FPAYTYPE_LIHUN:int = 1;
      
      public static const FPAYTYPE_SHOP:int = 2;
      
      public static const FPAYTYPE_PAIMAI:int = 3;
      
      protected var _titleTxt:FilterFrameText;
      
      protected var _descriptTxt:FilterFrameText;
      
      protected var _type:int;
      
      protected var _BG:Image;
      
      protected var _BG1:ScaleBitmapImage;
      
      private var _textAreaBg:Image;
      
      protected var _comboBoxLabel:FilterFrameText;
      
      protected var _chooseFriendBtn:TextButton;
      
      protected var _nameInput:NameInputDropListTarget;
      
      protected var _dropList:DropList;
      
      protected var _friendList:ChatFriendListPanel;
      
      protected var _cancelBtn:TextButton;
      
      protected var _okBtn:TextButton;
      
      private var _textArea:TextArea;
      
      private var _selectPlayerId:int = -1;
      
      public function ShopPresentClearingFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get titleTxt() : FilterFrameText
      {
         return this._titleTxt;
      }
      
      public function get nameInput() : NameInputDropListTarget
      {
         return this._nameInput;
      }
      
      public function get presentBtn() : BaseButton
      {
         return this._okBtn;
      }
      
      public function get textArea() : TextArea
      {
         return this._textArea;
      }
      
      public function get selectPlayerId() : int
      {
         return this._selectPlayerId;
      }
      
      public function setType(type:int = 0) : void
      {
         this._type = type;
         if(this._type == GIVETYPE)
         {
            this.titleText = LanguageMgr.GetTranslation("shop.view.present");
            this._comboBoxLabel.text = LanguageMgr.GetTranslation("shop.PresentFrame.ComboBoxLabel");
            this._friendList.setup(this.selectName,true);
         }
         else if(this._type == FPAYTYPE_LIHUN)
         {
            this.titleText = LanguageMgr.GetTranslation("shop.view.friendPay");
            this._descriptTxt.text = LanguageMgr.GetTranslation("shop.ShopIIPresentView.askunwedding");
            this._friendList.setup(this.selectName,false);
            this._comboBoxLabel.text = "";
            this._titleTxt.text = "";
         }
         else if(this._type == FPAYTYPE_SHOP)
         {
            this.titleText = LanguageMgr.GetTranslation("shop.view.friendPay");
            this._descriptTxt.text = LanguageMgr.GetTranslation("shop.ShopIIPresentView.askpay");
            this._comboBoxLabel.text = "";
            this._titleTxt.text = "";
            this._friendList.setup(this.selectName,true);
         }
         else if(this._type == FPAYTYPE_PAIMAI)
         {
            this.titleText = LanguageMgr.GetTranslation("shop.view.friendPay");
            this._descriptTxt.text = LanguageMgr.GetTranslation("shop.ShopIIPresentView.askpay");
            this._comboBoxLabel.text = "";
            this._titleTxt.text = "";
            this._friendList.setup(this.selectName,true);
         }
      }
      
      protected function initView() : void
      {
         escEnable = true;
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PresentFrame.titleText");
         this._titleTxt.text = LanguageMgr.GetTranslation("shop.PresentFrame.titleText");
         this._descriptTxt = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.decriptTxt");
         addToContent(this._descriptTxt);
         this._BG = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrameBg1");
         this._comboBoxLabel = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.ComboBoxLabel");
         this._comboBoxLabel.text = LanguageMgr.GetTranslation("shop.PresentFrame.ComboBoxLabel");
         this._chooseFriendBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.ChooseFriendBtn");
         this._chooseFriendBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.ChooseFriendButtonText");
         this._nameInput = ComponentFactory.Instance.creatCustomObject("ddtshop.ClearingInterface.nameInput");
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
         this._dropList.targetDisplay = this._nameInput;
         this._dropList.x = this._nameInput.x;
         this._dropList.y = this._nameInput.y + this._nameInput.height;
         this._friendList = new ChatFriendListPanel();
         this._friendList.setup(this.selectName,false);
         this._textArea = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PresentClearingTextArea");
         this._textArea.maxChars = 200;
         this._textAreaBg = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.TextAreaBg");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.CancelBtn");
         this._cancelBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.OkBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         addToContent(this._titleTxt);
         addToContent(this._BG);
         addToContent(this._comboBoxLabel);
         addToContent(this._chooseFriendBtn);
         addToContent(this._nameInput);
         addToContent(this._textArea);
         this._textArea.addChild(this._textAreaBg);
         addToContent(this._cancelBtn);
         addToContent(this._okBtn);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function onlyFriendSelectView() : void
      {
         this._BG.height -= 172;
         this._BG.y += 2;
         this._textArea.visible = false;
         this._cancelBtn.y -= 172;
         this._okBtn.y -= 172;
         this.height -= 172;
      }
      
      protected function selectName(nick:String, id:int = 0) : void
      {
         this._selectPlayerId = id;
         this.setName(nick);
         this._friendList.setVisible = false;
      }
      
      public function setName(value:String) : void
      {
         this._nameInput.text = value;
      }
      
      public function get Name() : String
      {
         return this._nameInput.text;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._nameInput.addEventListener(Event.CHANGE,this.__onReceiverChange);
         this._chooseFriendBtn.addEventListener(MouseEvent.CLICK,this.__showFramePanel);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelPresent);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideDropList);
      }
      
      private function __cancelPresent(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new FrameEvent(FrameEvent.CANCEL_CLICK));
         this.dispose();
      }
      
      private function __buyMoney(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LeavePageManager.leaveToFillPath();
      }
      
      private function __showFramePanel(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var pos:Point = this._chooseFriendBtn.localToGlobal(new Point(0,0));
         this._friendList.x = pos.x - 95;
         this._friendList.y = pos.y + this._chooseFriendBtn.height;
         this._friendList.setVisible = true;
         LayerManager.Instance.addToLayer(this._friendList,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._nameInput))
         {
            this._nameInput.removeEventListener(Event.CHANGE,this.__onReceiverChange);
         }
         if(Boolean(this._chooseFriendBtn))
         {
            this._chooseFriendBtn.removeEventListener(MouseEvent.CLICK,this.__showFramePanel);
         }
         if(Boolean(this._cancelBtn))
         {
            this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__buyMoney);
         }
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideDropList);
      }
      
      protected function __hideDropList(event:Event) : void
      {
         if(event.target is FilterFrameText)
         {
            return;
         }
         if(Boolean(this._dropList) && Boolean(this._dropList.parent))
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(Boolean(this._dropList))
         {
            this._dropList = null;
         }
         if(Boolean(this._friendList))
         {
            ObjectUtils.disposeObject(this._friendList);
         }
         this._friendList = null;
         this._titleTxt = null;
         this._BG = null;
         this._comboBoxLabel = null;
         this._chooseFriendBtn = null;
         this._nameInput = null;
         this._dropList = null;
         this._cancelBtn = null;
         this._okBtn = null;
         ObjectUtils.disposeObject(this._textAreaBg);
         this._textAreaBg = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __onReceiverChange(event:Event) : void
      {
         if(this._nameInput.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var list:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterSearch(this.filterRepeatInArray(list),this._nameInput.text);
      }
      
      private function filterRepeatInArray(filterArr:Array) : Array
      {
         var j:int = 0;
         var arr:Array = new Array();
         for(var i:int = 0; i < filterArr.length; i++)
         {
            if(i == 0)
            {
               arr.push(filterArr[i]);
            }
            for(j = 0; j < arr.length; j++)
            {
               if(arr[j].NickName == filterArr[i].NickName)
               {
                  break;
               }
               if(j == arr.length - 1)
               {
                  arr.push(filterArr[i]);
               }
            }
         }
         return arr;
      }
      
      private function filterSearch(list:Array, targetStr:String) : Array
      {
         var result:Array = [];
         for(var i:int = 0; i < list.length; i++)
         {
            if(list[i].NickName.indexOf(targetStr) != -1)
            {
               result.push(list[i]);
            }
         }
         return result;
      }
   }
}

