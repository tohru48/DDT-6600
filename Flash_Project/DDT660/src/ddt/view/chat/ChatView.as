package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import flash.display.Sprite;
   
   use namespace chat_system;
   
   public class ChatView extends Sprite
   {
      
      private var _input:ChatInputView;
      
      private var _output:ChatOutputView;
      
      private var _state:int = -1;
      
      private var _stateArr:Vector.<ChatViewInfo>;
      
      public function ChatView()
      {
         super();
         this.init();
      }
      
      public function get input() : ChatInputView
      {
         return this._input;
      }
      
      public function get output() : ChatOutputView
      {
         return this._output;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      private function updateViewState(value:int) : void
      {
         if(value == ChatManager.CHAT_TRAINER_STATE)
         {
            ChatManager.Instance.view.parent.removeChild(ChatManager.Instance.view);
         }
         if(value != ChatManager.CHAT_GAMEOVER_STATE)
         {
            if(this._stateArr[value].inputVisible)
            {
               addChild(this._input);
            }
            else if(Boolean(this._input.parent))
            {
               this._input.parent.removeChild(this._input);
            }
         }
         this._input.faceEnabled = this._stateArr[value].inputFaceEnabled;
         this._input.x = this._stateArr[value].inputX;
         this._input.y = this._stateArr[value].inputY;
         ChatManager.Instance.visibleSwitchEnable = this._stateArr[value].inputVisibleSwitchEnabled;
         this._output.isLock = this._stateArr[value].outputIsLock;
         this._output.lockEnable = this._stateArr[value].outputLockEnabled;
         this._output.bg = this._stateArr[value].outputBackground;
         this._output.contentField.chat_system::style = this._stateArr[value].outputContentFieldStyle;
         if(this._stateArr[value].outputChannel != -1)
         {
            this._output.channel = this._stateArr[value].outputChannel;
         }
         this._output.x = this._stateArr[value].outputX;
         this._output.y = this._stateArr[value].outputY;
         if(this._state == ChatManager.CHAT_GAME_STATE)
         {
            this._input.enableGameState = true;
            this._output.enableGameState = true;
            this._output.functionEnabled = false;
         }
         else
         {
            this._output.enableGameState = false;
         }
         this._output.bgVisible = this._stateArr[value].outputBackgroundVisible;
         this._output.updateCurrnetChannel();
      }
      
      public function set state(state:int) : void
      {
         if(this._state == state)
         {
            return;
         }
         if(this._state == ChatManager.CHAT_GAME_STATE)
         {
            this._input.enableGameState = false;
            this._output.enableGameState = false;
         }
         var preState:int = this._state;
         this._state = state;
         if(this._state == ChatManager.CHAT_SEVENDOUBLEGAME_SECENE || this._state == ChatManager.CHAT_ESCORT_SECENE)
         {
            this._output.contentField.contentWidth = ChatOutputField.GAME_WIDTH;
         }
         else
         {
            this._output.contentField.contentWidth = ChatOutputField.NORMAL_WIDTH;
         }
         ChatManager.Instance.setFocus();
         this._input.hidePanel();
         this.updateViewState(this._state);
         this._output.setChannelBtnVisible(!this._output.isLock);
         this._output.setLockBtnTipData(this._output.isLock);
      }
      
      public function set moreButtonState(val:Boolean) : void
      {
         this._output.moreState(val);
      }
      
      private function init() : void
      {
         var info:ChatViewInfo = null;
         var xml:XML = null;
         this._input = ComponentFactory.Instance.creatCustomObject("chat.InputView");
         this._output = ComponentFactory.Instance.creatCustomObject("chat.OutputView");
         this._stateArr = new Vector.<ChatViewInfo>();
         for(var i:int = 0; i <= 32; i++)
         {
            info = new ChatViewInfo();
            xml = ComponentFactory.Instance.getCustomStyle("chatViewInfo.state_" + String(i));
            if(!xml)
            {
               this._stateArr.push(info);
            }
            else
            {
               ObjectUtils.copyPorpertiesByXML(info,xml);
               this._stateArr.push(info);
            }
         }
         addChild(this._output);
         addChild(this._input);
      }
   }
}

