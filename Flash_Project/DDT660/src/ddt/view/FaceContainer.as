package ddt.view
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class FaceContainer extends Sprite
   {
      
      private var _face:MovieClip;
      
      private var _oldScale:int;
      
      private var _isActingExpression:Boolean;
      
      private var _nickName:TextField;
      
      private var _expressionID:int;
      
      public function FaceContainer(topLayer:Boolean = false)
      {
         super();
         this.init();
      }
      
      public function get nickName() : TextField
      {
         return this._nickName;
      }
      
      public function get expressionID() : int
      {
         return this._expressionID;
      }
      
      public function set isShowNickName(value:Boolean) : void
      {
         if(value && this._face != null)
         {
            this._nickName.y = this._face.y - 20 - this._face.height / 2;
            this._nickName.x = -this._face.width / 2;
            this._nickName.visible = true;
         }
         else
         {
            this._nickName.y = 0;
            this._nickName.x = 0;
            this._nickName.visible = false;
         }
      }
      
      public function get isActingExpression() : Boolean
      {
         return this._isActingExpression;
      }
      
      public function setNickName(str:String) : void
      {
         if(str == null)
         {
            return;
         }
         this._nickName.text = str + ":";
         this.addChild(this._nickName);
         this._nickName.visible = false;
      }
      
      private function init() : void
      {
         var tf:TextFormat = new TextFormat();
         tf.color = "0xff0000";
         this._nickName = new TextField();
         this._nickName.defaultTextFormat = tf;
      }
      
      private function __timerComplete(evt:TimerEvent) : void
      {
         this.clearFace();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function clearFace() : void
      {
         if(this._face != null)
         {
            if(Boolean(this._face.parent))
            {
               this._face.stop();
               this._face.parent.removeChild(this._face);
            }
            this._face.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this._face = null;
            this._nickName.visible = false;
         }
      }
      
      public function setFace(id:int) : void
      {
         if(this._oldScale == 0)
         {
            this._oldScale = scaleX;
         }
         this.clearFace();
         this._face = FaceSource.getFaceById(id);
         this._expressionID = id;
         if(this._face != null)
         {
            this._isActingExpression = true;
            if(id == 42)
            {
               this.scaleX = 1;
               this._face.scaleX = 1;
            }
            else
            {
               scaleX = this._oldScale;
            }
            this._face.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
            addChild(this._face);
         }
      }
      
      public function doClearFace() : void
      {
         this._isActingExpression = false;
         this.clearFace();
      }
      
      private function __enterFrame(event:Event) : void
      {
         if(this._face.currentFrame >= this._face.totalFrames)
         {
            this._isActingExpression = false;
            this.clearFace();
         }
      }
      
      public function dispose() : void
      {
         this.clearFace();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

