package ddt.view.chat
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class ChatBugleView extends Sprite
   {
      
      private static var _instance:ChatBugleView;
      
      private static const BIG_BUGLE:uint = 1;
      
      private static const SMALL_BUGLE:uint = 2;
      
      private static const ADMIN_NOTICE:uint = 3;
      
      private static const DEFY_AFFICHE:uint = 3;
      
      private static const CROSS_BUGLE:uint = 4;
      
      private static const CROSS_NOTICE:uint = 5;
      
      private static const MOVE_STEP:uint = 3;
      
      private var _showTimer:Timer;
      
      private var _bugleList:Array;
      
      private var _currentBugle:String;
      
      private var _currentBugleType:int;
      
      private var _currentBigBugleType:int;
      
      private var _buggleTypeMc:ScaleFrameImage;
      
      private var _bg:Bitmap;
      
      private var _contentTxt:FilterFrameText;
      
      private var _animationTxt:FilterFrameText;
      
      private var _bigBugleAnimations:Vector.<MovieClip>;
      
      private var _fieldRect:Rectangle;
      
      public function ChatBugleView()
      {
         super();
      }
      
      public static function get instance() : ChatBugleView
      {
         if(_instance == null)
         {
            _instance = new ChatBugleView();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._bigBugleAnimations = new Vector.<MovieClip>(6);
         this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.BugleViewBg");
         this._buggleTypeMc = ComponentFactory.Instance.creatComponentByStylename("chat.BugleViewType");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleViewText");
         this._animationTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleAnimationText");
         PositionUtils.setPos(this,"chat.BugleViewPos");
         this._showTimer = new Timer(3000);
         this._bugleList = [];
         this._currentBugleType = -1;
         addChild(this._bg);
         addChild(this._buggleTypeMc);
         addChild(this._contentTxt);
         mouseChildren = false;
         mouseEnabled = false;
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._showTimer.addEventListener(TimerEvent.TIMER,this.__showTimer);
         ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__onAddChat);
      }
      
      private function __onAddChat(event:ChatEvent) : void
      {
         var offset:int = 0;
         var i:Object = null;
         var ItemID:Number = NaN;
         var TemplateID:int = 0;
         var info:ItemTemplateInfo = null;
         var index:uint = 0;
         if(ChatManager.Instance.state == ChatManager.CHAT_WEDDINGROOM_STATE || ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW || ChatManager.Instance.state == ChatManager.CHAT_TRAINER_STATE || ChatManager.Instance.state == ChatManager.CHAT_LITTLEGAME || ChatManager.Instance.isInGame || ChatManager.Instance.state == ChatManager.CHAT_CONSORTIABATTLE_SCENE)
         {
            return;
         }
         var o:ChatData = event.data as ChatData;
         var result:String = "";
         var leftPattern:RegExp = /&lt;/g;
         var rightPattern:RegExp = /&gt;/g;
         var chatMsg:String = o.msg.replace(leftPattern,"<").replace(rightPattern,">");
         chatMsg = Helpers.deCodeString(chatMsg);
         if(Boolean(o.link))
         {
            offset = 0;
            o.link.sortOn("index");
            for each(i in o.link)
            {
               ItemID = Number(i.ItemID);
               TemplateID = int(i.TemplateID);
               info = ItemManager.Instance.getTemplateById(TemplateID);
               index = i.index + offset;
               if(info == null)
               {
                  if(TemplateID == 0)
                  {
                     chatMsg = chatMsg.substring(0,index) + "[" + LanguageMgr.GetTranslation("tank.view.card.chatLinkText0") + "]" + chatMsg.substring(index);
                     offset += LanguageMgr.GetTranslation("tank.view.card.chatLinkText0").length;
                  }
                  else
                  {
                     chatMsg = chatMsg.substring(0,index) + "[" + String(TemplateID) + LanguageMgr.GetTranslation("tank.view.card.chatLinkText") + "]" + chatMsg.substring(index);
                     offset += (String(TemplateID) + LanguageMgr.GetTranslation("tank.view.card.chatLinkText")).length;
                  }
               }
               else
               {
                  chatMsg = chatMsg.substring(0,index) + "[" + info.Name + "]" + chatMsg.substring(index);
                  offset += info.Name.length;
               }
            }
         }
         var BugleType:int = int(BIG_BUGLE);
         var BigBugleType:int = int(ChatData.B_BUGGLE_TYPE_NORMAL);
         if(o.channel == ChatInputView.SMALL_BUGLE)
         {
            BugleType = int(SMALL_BUGLE);
            result = "[" + o.sender + LanguageMgr.GetTranslation("tank.view.common.BuggleView.small") + chatMsg;
         }
         else if(o.channel == ChatInputView.BIG_BUGLE)
         {
            BugleType = int(BIG_BUGLE);
            if(o.bigBuggleType != ChatData.B_BUGGLE_TYPE_NORMAL)
            {
               BigBugleType = int(o.bigBuggleType);
               result = "[" + o.sender + "]:" + chatMsg;
            }
            else
            {
               BigBugleType = int(ChatData.B_BUGGLE_TYPE_NORMAL);
               result = "[" + o.sender + LanguageMgr.GetTranslation("tank.view.common.BuggleView.big") + chatMsg;
            }
         }
         else if(o.channel == ChatInputView.CROSS_BUGLE)
         {
            BugleType = int(CROSS_BUGLE);
            result = "[" + o.sender + LanguageMgr.GetTranslation("tank.view.common.BuggleView.cross") + chatMsg;
         }
         else if(o.channel == ChatInputView.CROSS_NOTICE)
         {
            BugleType = int(ADMIN_NOTICE);
            result = chatMsg;
         }
         else if(o.channel == ChatInputView.DEFY_AFFICHE)
         {
            BugleType = int(DEFY_AFFICHE);
            result = chatMsg;
         }
         else
         {
            if(!(o.channel == ChatInputView.SYS_NOTICE || o.channel == ChatInputView.SYS_TIP))
            {
               return;
            }
            if(!(o.type == 1 || o.type == 3 || o.type == 9 || o.type == 20 || o.type == 21))
            {
               return;
            }
            BugleType = int(ADMIN_NOTICE);
            result = chatMsg;
         }
         this._bugleList.push(new ChatBugleData(result,BugleType,BigBugleType));
         this.checkPlay();
      }
      
      private function checkShowTimer() : void
      {
         this._showTimer.stop();
         this._showTimer.reset();
         this.hide();
         this._showTimer.start();
      }
      
      private function __showTimer(evt:TimerEvent) : void
      {
         this._showTimer.stop();
         this._showTimer.reset();
         this.hide();
      }
      
      private function checkPlay() : void
      {
         var bugleData:ChatBugleData = null;
         var _currentBugle:String = null;
         if(PlayerManager.Instance.Self.Grade > 1)
         {
            if(this._bugleList.length > 0)
            {
               bugleData = this._bugleList.splice(0,1)[0];
               _currentBugle = bugleData.content;
               this._currentBugleType = bugleData.BugleType;
               this._currentBigBugleType = bugleData.subBugleType;
               if(Boolean(this._animationTxt.parent))
               {
                  this._animationTxt.parent.removeChild(this._animationTxt);
               }
               this.removeAllBuggleAnimations();
               this._buggleTypeMc.setFrame(this._currentBugleType);
               addChild(this._bg);
               addChild(this._buggleTypeMc);
               addChild(this._contentTxt);
               if(this._currentBugleType == BIG_BUGLE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.BIG_BUGLE);
                  if(this._currentBigBugleType != ChatData.B_BUGGLE_TYPE_NORMAL)
                  {
                     if(Boolean(this._contentTxt.parent))
                     {
                        this._contentTxt.parent.removeChild(this._contentTxt);
                     }
                     if(Boolean(this._buggleTypeMc.parent))
                     {
                        this._buggleTypeMc.parent.removeChild(this._buggleTypeMc);
                     }
                     if(Boolean(this._bg.parent))
                     {
                        this._bg.parent.removeChild(this._bg);
                     }
                     this._animationTxt.textColor = ChatFormats.getColorByBigBuggleType(this._currentBigBugleType - 1);
                     if(this._bigBugleAnimations[this._currentBigBugleType - 1] == null)
                     {
                        this._bigBugleAnimations[this._currentBigBugleType - 1] = ComponentFactory.Instance.creat("chat.BugleAnimation_" + (this._currentBigBugleType - 1).toString());
                        PositionUtils.setPos(this._bigBugleAnimations[this._currentBigBugleType - 1],"chat.BugleAnimationPos_" + (this._currentBigBugleType - 1).toString());
                     }
                     this._animationTxt.x = this._bigBugleAnimations[this._currentBigBugleType - 1].x;
                     this._animationTxt.y = this._bigBugleAnimations[this._currentBigBugleType - 1].y;
                     this._bigBugleAnimations[this._currentBigBugleType - 1].play();
                     addChild(this._bigBugleAnimations[this._currentBigBugleType - 1]);
                     addChild(this._animationTxt);
                     this._animationTxt.text = _currentBugle;
                     this.checkShowTimer();
                     this.show();
                     return;
                  }
               }
               else if(this._currentBugleType == SMALL_BUGLE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.SMALL_BUGLE);
               }
               else if(this._currentBugleType == ADMIN_NOTICE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.ADMIN_NOTICE);
               }
               else if(this._currentBugleType == DEFY_AFFICHE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.DEFY_AFFICHE);
               }
               else if(this._currentBugleType == CROSS_BUGLE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.CROSS_BUGLE);
               }
               else if(this._currentBugleType == CROSS_NOTICE)
               {
                  this._contentTxt.textColor = ChatFormats.getColorByChannel(ChatInputView.CROSS_NOTICE);
               }
               this._contentTxt.text = _currentBugle;
               this.checkShowTimer();
               this.show();
            }
            else
            {
               this.hide();
            }
         }
      }
      
      public function show() : void
      {
         if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.SHOP || StateManager.currentStateType == StateType.HOT_SPRING_ROOM && ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_ROOM_VIEW)
         {
            return;
         }
         if(StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.LODING_TRAINER)
         {
            return;
         }
         if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
         {
            return;
         }
         this.updatePos();
         if(this._currentBugleType == ADMIN_NOTICE)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,0,false);
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
            y += 30;
            this.visible = true;
            TweenLite.to(this,0.25,{"y":y - 30});
            return;
         }
         if(SharedManager.Instance.showTopMessageBar)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,0,false);
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
            y += 30;
            this.visible = true;
            TweenLite.to(this,0.25,{"y":y - 30});
         }
         else
         {
            this.hide();
         }
      }
      
      public function updatePos() : void
      {
         x = 9;
         y = 12;
      }
      
      private function removeAllBuggleAnimations() : void
      {
         for(var i:int = 0; i < this._bigBugleAnimations.length; i++)
         {
            if(Boolean(this._bigBugleAnimations[i]))
            {
               if(Boolean(this._bigBugleAnimations[i].parent))
               {
                  this._bigBugleAnimations[i].parent.removeChild(this._bigBugleAnimations[i]);
               }
               this._bigBugleAnimations[i].stop();
            }
         }
      }
      
      public function hide() : void
      {
         TweenLite.to(this,0.5,{
            "y":y - 60,
            "onComplete":this.removeView
         });
      }
      
      private function removeView() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this.removeAllBuggleAnimations();
         if(Boolean(this._animationTxt.parent))
         {
            this._animationTxt.parent.removeChild(this._animationTxt);
         }
         y += 60;
      }
   }
}

class ChatBugleData
{
   
   public var content:String;
   
   public var BugleType:int;
   
   public var subBugleType:int;
   
   public function ChatBugleData(c:String, t:int, st:int)
   {
      super();
      this.content = c;
      this.BugleType = t;
      this.subBugleType = st;
   }
}
