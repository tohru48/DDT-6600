package ddt.view.chat
{
   import baglocked.BaglockedManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.EquipType;
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.ChatManager;
   import ddt.manager.DebugManager;
   import ddt.manager.IMEManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.Helpers;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import road7th.utils.StringHelper;
   
   public class ChatInputField extends Sprite
   {
      
      public static const INPUT_MAX_CHAT:int = 90;
      
      private var CHANNEL_KEY_SET:Array = ["d","x","w","g","p","s","k"];
      
      private var CHANNEL_SET:Array = [0,1,2,3,4,5,15];
      
      private var _channel:int = -1;
      
      private var _currentHistoryOffset:int = 0;
      
      private var _inputField:TextField;
      
      private var _maxInputWidth:Number = 300;
      
      private var _nameTextField:TextField;
      
      private var _privateChatName:String;
      
      private var _userID:int;
      
      private var _privateChatInfo:Object;
      
      public function ChatInputField()
      {
         super();
         if(!ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_CBUGLE) || !PathManager.solveCrossBuggleEable())
         {
            this.CHANNEL_KEY_SET.splice(this.CHANNEL_KEY_SET.indexOf("k"),1);
            this.CHANNEL_SET.splice(this.CHANNEL_SET.indexOf(15),1);
         }
         if(!ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_BBUGLE))
         {
            this.CHANNEL_KEY_SET.splice(this.CHANNEL_KEY_SET.indexOf("d"),1);
            this.CHANNEL_SET.splice(this.CHANNEL_SET.indexOf(0),1);
         }
         if(!ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_SBUGLE))
         {
            this.CHANNEL_KEY_SET.splice(this.CHANNEL_KEY_SET.indexOf("x"),1);
            this.CHANNEL_SET.splice(this.CHANNEL_SET.indexOf(1),1);
         }
         this.initView();
      }
      
      public function get channel() : int
      {
         return this._channel;
      }
      
      public function set channel(channel:int) : void
      {
         if(this._channel == channel)
         {
            return;
         }
         this._channel = channel;
         this.setPrivateChatName("");
         this.setTextFormat(ChatFormats.getTextFormatByChannel(this._channel));
      }
      
      public function isFocus() : Boolean
      {
         var isF:Boolean = false;
         if(Boolean(StageReferance.stage))
         {
            isF = StageReferance.stage.focus == this._inputField;
         }
         return isF;
      }
      
      public function set maxInputWidth($width:Number) : void
      {
         this._maxInputWidth = $width;
         this.updatePosAndSize();
      }
      
      public function get privateChatName() : String
      {
         return this._privateChatName;
      }
      
      public function get privateUserID() : int
      {
         return this._userID;
      }
      
      public function get privateChatInfo() : Object
      {
         return this._privateChatInfo;
      }
      
      public function sendCurrnetText() : void
      {
         var i:int = 0;
         var list:Vector.<String> = null;
         var name:String = null;
         var msgs:String = null;
         if(this._channel == ChatInputView.SMALL_BUGLE || this._channel == ChatInputView.BIG_BUGLE || this._channel == ChatInputView.CROSS_BUGLE)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
         }
         var reg:RegExp = /\/\S*\s?/;
         var result:Array = reg.exec(this._inputField.text);
         var allLowString:String = this._inputField.text.toLocaleLowerCase();
         var isChangedChannel:Boolean = false;
         var isFastReply:Boolean = false;
         if(allLowString.indexOf("/") == 0)
         {
            for(i = 0; i < this.CHANNEL_KEY_SET.length; i++)
            {
               if(allLowString.indexOf("/" + this.CHANNEL_KEY_SET[i]) == 0)
               {
                  isChangedChannel = true;
                  SoundManager.instance.play("008");
                  this._inputField.text = allLowString.substring(2);
                  dispatchEvent(new ChatEvent(ChatEvent.INPUT_CHANNEL_CHANNGED,this.CHANNEL_SET[i]));
               }
            }
            if(!isChangedChannel)
            {
               list = ChatManager.Instance.model.customFastReply;
               for(i = 0; i < 5; i++)
               {
                  if(allLowString.indexOf("/" + String(i + 1)) == 0 && (allLowString.length == 2 || allLowString.charAt(2) == " "))
                  {
                     isFastReply = true;
                     if(list.length > i)
                     {
                        this._inputField.text = list[i];
                     }
                     else
                     {
                        this._inputField.text = "";
                     }
                     break;
                  }
               }
            }
            if(result && !isChangedChannel && !isFastReply)
            {
               name = String(result[0]).replace(" ","");
               name = name.replace("/","");
               if(name == "")
               {
                  return;
               }
               this._inputField.text = this._inputField.text.replace(reg,"");
               dispatchEvent(new ChatEvent(ChatEvent.CUSTOM_SET_PRIVATE_CHAT_TO,{
                  "channel":2,
                  "nickName":name
               }));
               return;
            }
         }
         if(allLowString.substr(0,2) != "/" + this.CHANNEL_KEY_SET[2])
         {
            msgs = this.parasMsgs(this._inputField.text);
            this._inputField.text = "";
            if(msgs == "")
            {
               return;
            }
            dispatchEvent(new ChatEvent(ChatEvent.INPUT_TEXT_CHANGED,msgs));
         }
      }
      
      public function setFocus() : void
      {
         if(Boolean(StageReferance.stage))
         {
            this.setTextFocus();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.__onAddToStage);
         }
      }
      
      public function setInputText(text:String) : void
      {
         if(text.indexOf("&lt;") > -1 || text.indexOf("&gt;") > -1)
         {
            this._inputField.htmlText = text;
            this._inputField.textColor = ChatFormats.CHAT_COLORS[this._channel];
         }
         else
         {
            this._inputField.text = text;
         }
         this._inputField.setTextFormat(ChatFormats.getTextFormatByChannel(this._channel));
      }
      
      public function setPrivateChatName(name:String, useID:int = 0, info:Object = null) : void
      {
         var txt:String = null;
         this.setTextFocus();
         this._privateChatName = name;
         this._userID = useID;
         this._privateChatInfo = info;
         if(this._privateChatName != "")
         {
            txt = "";
            txt = this._privateChatName;
            this._nameTextField.htmlText = LanguageMgr.GetTranslation("tank.view.chat.ChatInput.usernameField.text",txt);
            if(Boolean(this._privateChatInfo) && !(this._privateChatInfo is FriendListPlayer))
            {
               this._nameTextField.htmlText = LanguageMgr.GetTranslation("tank.view.chat.ChatInput.usernameField.textII",this._privateChatInfo.areaName,txt);
            }
         }
         else
         {
            this._nameTextField.text = "";
         }
         this.updatePosAndSize();
      }
      
      private function __onAddToStage(e:Event) : void
      {
         this.setTextFocus();
         removeEventListener(Event.ADDED_TO_STAGE,arguments.callee);
      }
      
      private function __onFieldKeyDown(event:KeyboardEvent) : void
      {
         if(this.isFocus())
         {
            event.stopImmediatePropagation();
            event.stopPropagation();
            if(event.keyCode == Keyboard.UP)
            {
               --this.currentHistoryOffset;
               if(this.getHistoryChat(this.currentHistoryOffset) != "")
               {
                  this._inputField.htmlText = this.getHistoryChat(this.currentHistoryOffset);
                  this._inputField.setTextFormat(ChatFormats.getTextFormatByChannel(this._channel));
                  this._inputField.addEventListener(Event.ENTER_FRAME,this.__setSelectIndexSync);
               }
            }
            else if(event.keyCode == Keyboard.DOWN)
            {
               ++this.currentHistoryOffset;
               this._inputField.text = this.getHistoryChat(this.currentHistoryOffset);
            }
         }
         if(event.keyCode == Keyboard.ENTER && !ChatManager.Instance.chatDisabled)
         {
            if(this._inputField.text.substr(0,1) == "#")
            {
               DebugManager.getInstance().handle(this._inputField.text);
               this._inputField.text = "";
            }
            else if(this._inputField.text != "" && this.parasMsgs(this._inputField.text) != "" && ChatManager.Instance.input.parent != null)
            {
               if(this.isFocus())
               {
                  if(ChatManager.Instance.state != ChatManager.CHAT_SHOP_STATE)
                  {
                     SoundManager.instance.play("008");
                     this.sendCurrnetText();
                     this._currentHistoryOffset = ChatManager.Instance.model.resentChats.length;
                  }
               }
               else if(this.canUseKeyboardSetFocus())
               {
                  this.setFocus();
               }
            }
            else
            {
               ChatManager.Instance.switchVisible();
               if(this.canUseKeyboardSetFocus())
               {
                  ChatManager.Instance.setFocus();
               }
               if(ChatManager.Instance.visibleSwitchEnable)
               {
                  SoundManager.instance.play("008");
               }
            }
         }
         if(ChatManager.Instance.input.parent != null)
         {
            if(ChatManager.Instance.visibleSwitchEnable)
            {
               IMEManager.enable();
            }
         }
      }
      
      private function canUseKeyboardSetFocus() : Boolean
      {
         if(!ChatManager.Instance.focusFuncEnabled)
         {
            return false;
         }
         if(ChatManager.Instance.input.parent != null && (ChatManager.Instance.state == ChatManager.CHAT_GAME_STATE || ChatManager.Instance.state == ChatManager.CHAT_GAMEOVER_STATE))
         {
            return true;
         }
         if(ChatManager.Instance.input.parent != null && StageReferance.stage.focus == null)
         {
            return true;
         }
         return false;
      }
      
      private function __onInputFieldChange(e:Event) : void
      {
         if(Boolean(this._inputField.text))
         {
            this._inputField.text = this._inputField.text.replace("\n","").replace("\r","");
         }
      }
      
      private function __setSelectIndexSync(event:Event) : void
      {
         this._inputField.removeEventListener(Event.ENTER_FRAME,this.__setSelectIndexSync);
         this._inputField.setSelection(this._inputField.text.length,this._inputField.text.length);
      }
      
      private function get currentHistoryOffset() : int
      {
         return this._currentHistoryOffset;
      }
      
      private function set currentHistoryOffset(value:int) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         if(value > ChatManager.Instance.model.resentChats.length - 1)
         {
            value = ChatManager.Instance.model.resentChats.length - 1;
         }
         this._currentHistoryOffset = value;
      }
      
      private function getHistoryChat(chatOffset:int) : String
      {
         if(chatOffset == -1)
         {
            return "";
         }
         return Helpers.deCodeString(ChatManager.Instance.model.resentChats[chatOffset].msg);
      }
      
      private function initView() : void
      {
         var startPos:Point = null;
         startPos = ComponentFactory.Instance.creatCustomObject("chat.InputFieldTextFieldStartPos");
         this._nameTextField = new TextField();
         this._nameTextField.type = TextFieldType.DYNAMIC;
         this._nameTextField.mouseEnabled = false;
         this._nameTextField.selectable = false;
         this._nameTextField.autoSize = TextFieldAutoSize.LEFT;
         this._nameTextField.x = startPos.x;
         this._nameTextField.y = startPos.y;
         addChild(this._nameTextField);
         this._inputField = new TextField();
         this._inputField.type = TextFieldType.INPUT;
         this._inputField.autoSize = TextFieldAutoSize.NONE;
         this._inputField.multiline = false;
         this._inputField.wordWrap = false;
         this._inputField.maxChars = INPUT_MAX_CHAT;
         this._inputField.x = startPos.x;
         this._inputField.y = startPos.y;
         this._inputField.height = 20;
         addChild(this._inputField);
         this._inputField.addEventListener(Event.CHANGE,this.__onInputFieldChange);
         this.setTextFormat(new TextFormat("Arial",12,65280));
         this.updatePosAndSize();
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__onFieldKeyDown,false,int.MAX_VALUE);
      }
      
      private function parasMsgs(fieldText:String) : String
      {
         var result:String = fieldText;
         result = StringHelper.trim(result);
         result = FilterWordManager.filterWrod(result);
         return StringHelper.rePlaceHtmlTextField(result);
      }
      
      private function setTextFocus() : void
      {
         StageReferance.stage.focus = this._inputField;
         this._inputField.setSelection(this._inputField.text.length,this._inputField.text.length);
      }
      
      private function setTextFormat(textFormat:TextFormat) : void
      {
         this._nameTextField.defaultTextFormat = textFormat;
         this._nameTextField.setTextFormat(textFormat);
         this._inputField.defaultTextFormat = textFormat;
         this._inputField.setTextFormat(textFormat);
      }
      
      private function updatePosAndSize() : void
      {
         this._inputField.x = 70 + this._nameTextField.textWidth;
         if(this._nameTextField.textWidth > this._maxInputWidth)
         {
            return;
         }
         this._inputField.width = this._maxInputWidth - this._nameTextField.textWidth;
      }
   }
}

