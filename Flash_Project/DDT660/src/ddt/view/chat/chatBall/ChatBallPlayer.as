package ddt.view.chat.chatBall
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class ChatBallPlayer extends ChatBallBase
   {
      
      private var _currentPaopaoType:int = 0;
      
      private var _field2:ChatBallTextAreaBuff;
      
      public function ChatBallPlayer()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         _field = new ChatBallTextAreaPlayer();
         this._field2 = new ChatBallTextAreaBuff();
      }
      
      override protected function get field() : ChatBallTextAreaBase
      {
         if(this._currentPaopaoType != 9)
         {
            return _field;
         }
         return this._field2;
      }
      
      override public function setText(s:String, paopaoType:int = 0) : void
      {
         clear();
         if(paopaoType == 9)
         {
            _popupTimer = new Timer(2700,1);
         }
         else
         {
            _popupTimer = new Timer(4000,1);
         }
         if(this._currentPaopaoType != paopaoType || paopaoMC == null)
         {
            this._currentPaopaoType = paopaoType;
            this.newPaopao();
         }
         var temp:int = this.globalToLocal(new Point(500,10)).x;
         this.field.x = temp < 0 ? 0 : temp;
         this.field.text = s;
         fitSize(this.field);
         this.show();
      }
      
      override public function show() : void
      {
         super.show();
         beginPopDelay();
      }
      
      override public function hide() : void
      {
         super.hide();
         if(Boolean(this.field) && Boolean(this.field.parent))
         {
            this.field.parent.removeChild(this.field);
         }
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
      }
      
      private function newPaopao() : void
      {
         if(Boolean(paopao))
         {
            removeChild(paopao);
         }
         if(this._currentPaopaoType == 9)
         {
            paopaoMC = ComponentFactory.Instance.creat("SpecificBall001");
         }
         else
         {
            paopaoMC = ComponentFactory.Instance.creat("ChatBall1600" + String(this._currentPaopaoType));
         }
         _chatballBackground = new ChatBallBackground(paopaoMC);
         addChild(paopao);
      }
      
      override public function dispose() : void
      {
         this._field2.dispose();
         super.dispose();
      }
   }
}

