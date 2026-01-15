package ddt.view.chat
{
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import com.pickgliss.utils.StringUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.FilterWordManager;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public final class ChatModel extends EventDispatcher
   {
      
      private static const OVERCOUNT:int = 200;
      
      private var _clubChats:Array;
      
      private var _currentChats:Array;
      
      private var _privateChats:Array;
      
      private var _resentChats:Array;
      
      private var _linkInfoMap:Dictionary;
      
      private var _customFastReply:Vector.<String>;
      
      public function ChatModel()
      {
         super();
         this.reset();
      }
      
      public function addChat(data:ChatData) : void
      {
         this.tryAddToCurrentChats(data);
         this.tryAddToRecent(data);
         this.tryAddToClubChats(data);
         this.tryAddToPrivateChats(data);
         dispatchEvent(new ChatEvent(ChatEvent.ADD_CHAT,data));
      }
      
      public function get customFastReply() : Vector.<String>
      {
         return this._customFastReply;
      }
      
      public function addLink(key:String, info:ItemTemplateInfo) : void
      {
         this._linkInfoMap[key] = info;
      }
      
      public function getLink(itemIDLv:String) : ItemTemplateInfo
      {
         return this._linkInfoMap[itemIDLv];
      }
      
      public function addCardGrooveLink(key:String, info:GrooveInfo) : void
      {
         this._linkInfoMap[key] = info;
      }
      
      public function getCardGrooveLink(itemIDLv:String) : GrooveInfo
      {
         return this._linkInfoMap[itemIDLv];
      }
      
      public function addCardInfoLink(key:String, info:CardInfo) : void
      {
         this._linkInfoMap[key] = info;
      }
      
      public function getCardInfoLink(itemIDLv:String) : CardInfo
      {
         return this._linkInfoMap[itemIDLv];
      }
      
      public function removeAllLink() : void
      {
         this._linkInfoMap = new Dictionary();
      }
      
      public function getChatsByOutputChannel(channel:int, offset:int, count:int) : Object
      {
         offset = offset < 0 ? 0 : offset;
         var list:Array = [];
         if(channel == ChatOutputView.CHAT_OUPUT_CURRENT)
         {
            list = this._currentChats;
         }
         else if(channel == ChatOutputView.CHAT_OUPUT_CLUB)
         {
            list = this._clubChats;
         }
         else if(channel == ChatOutputView.CHAT_OUPUT_PRIVATE)
         {
            list = this._privateChats;
         }
         if(list.length <= count)
         {
            return {
               "offset":0,
               "result":list
            };
         }
         if(list.length <= count + offset)
         {
            return {
               "offset":list.length - count,
               "result":list.slice(0,count)
            };
         }
         return {
            "offset":offset,
            "result":list.slice(list.length - count - offset,list.length - offset)
         };
      }
      
      public function getInputInOutputChannel(inputChannel:int, outputChannel:int) : Boolean
      {
         if(outputChannel == ChatOutputView.CHAT_OUPUT_CLUB)
         {
            switch(inputChannel)
            {
               case ChatInputView.CONSORTIA:
               case ChatInputView.SYS_NOTICE:
               case ChatInputView.SYS_TIP:
               case ChatInputView.BIG_BUGLE:
               case ChatInputView.SMALL_BUGLE:
               case ChatInputView.DEFY_AFFICHE:
               case ChatInputView.CROSS_NOTICE:
                  return true;
               case ChatInputView.CROSS_BUGLE:
                  return true;
            }
         }
         else if(outputChannel == ChatOutputView.CHAT_OUPUT_PRIVATE)
         {
            switch(inputChannel)
            {
               case ChatInputView.PRIVATE:
               case ChatInputView.SYS_NOTICE:
               case ChatInputView.SYS_TIP:
               case ChatInputView.BIG_BUGLE:
               case ChatInputView.SMALL_BUGLE:
               case ChatInputView.DEFY_AFFICHE:
               case ChatInputView.CROSS_NOTICE:
                  return true;
               case ChatInputView.CROSS_BUGLE:
                  return true;
            }
         }
         else if(outputChannel == ChatOutputView.CHAT_OUPUT_CURRENT)
         {
            return true;
         }
         return false;
      }
      
      public function reset() : void
      {
         this._currentChats = [];
         this._clubChats = [];
         this._privateChats = [];
         this._resentChats = [];
         this._customFastReply = new Vector.<String>();
         this._linkInfoMap = new Dictionary();
      }
      
      public function get clubChats() : Array
      {
         return this._clubChats;
      }
      
      public function get currentChats() : Array
      {
         return this._currentChats;
      }
      
      public function get privateChats() : Array
      {
         return this._privateChats;
      }
      
      public function get resentChats() : Array
      {
         return this._resentChats;
      }
      
      public function getRowsByOutputChangel(channel:int) : int
      {
         return channel == ChatOutputView.CHAT_OUPUT_CURRENT ? int(this._currentChats.length) : (channel == ChatOutputView.CHAT_OUPUT_CLUB ? int(this._clubChats.length) : int(this._privateChats.length));
      }
      
      private function checkOverCount(chatDatas:Array) : void
      {
         if(chatDatas.length > OVERCOUNT)
         {
            chatDatas.shift();
         }
      }
      
      private function tryAddToClubChats(data:ChatData) : void
      {
         if(this.getInputInOutputChannel(data.channel,ChatOutputView.CHAT_OUPUT_CLUB))
         {
            this._clubChats.push(data);
         }
         this.checkOverCount(this._clubChats);
      }
      
      private function tryAddToCurrentChats(chats:ChatData) : void
      {
         this._currentChats.push(chats);
         this.checkOverCount(this._currentChats);
      }
      
      private function tryAddToPrivateChats(data:ChatData) : void
      {
         if(this.getInputInOutputChannel(data.channel,ChatOutputView.CHAT_OUPUT_PRIVATE))
         {
            this._privateChats.push(data);
            if(PlayerManager.Instance.Self.playerState.AutoReply != "" && !StringUtils.isEmpty(data.sender) && data.receiver == PlayerManager.Instance.Self.NickName && data.isAutoReply == false)
            {
               ChatManager.Instance.sendPrivateMessage(data.sender,FilterWordManager.filterWrod(PlayerManager.Instance.Self.playerState.AutoReply),data.senderID,true);
            }
         }
         this.checkOverCount(this._privateChats);
      }
      
      private function tryAddToRecent(data:ChatData) : void
      {
         if(data.sender == PlayerManager.Instance.Self.NickName)
         {
            this._resentChats.push(data);
         }
         this.checkOverCount(this._resentChats);
      }
   }
}

