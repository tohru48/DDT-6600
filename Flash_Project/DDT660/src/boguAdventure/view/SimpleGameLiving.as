package boguAdventure.view
{
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.view.chat.chatBall.ChatBallBase;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import game.model.GameNeedMovieInfo;
   import road.game.resource.ActionMovie;
   
   public class SimpleGameLiving extends Sprite implements Disposeable
   {
      
      protected var _actionMovie:ActionMovie;
      
      protected var _chatballview:ChatBallBase;
      
      protected var _originalHeight:Number;
      
      protected var _originalWidth:Number;
      
      protected var _movieInfo:GameNeedMovieInfo;
      
      private var _scale:Number;
      
      private var _dir:int;
      
      public function SimpleGameLiving()
      {
         super();
         this._actionMovie = ComponentFactory.Instance.creat("game.living.defaultSimpleBossLiving");
         addChild(this._actionMovie);
         this.initChatball();
      }
      
      public function set gameNeedMovieInfo(value:String) : void
      {
         this._movieInfo = ComponentFactory.Instance.creatCustomObject(value);
         this._movieInfo.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         this._movieInfo.startLoad();
      }
      
      private function __onComplete(e:LoaderEvent) : void
      {
         this._movieInfo.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         this.initMovie();
      }
      
      protected function initMovie() : void
      {
         var movieClass:Class = null;
         if(ModuleLoader.hasDefinition(this._movieInfo.classPath))
         {
            movieClass = ModuleLoader.getDefinition(this._movieInfo.classPath) as Class;
            if(Boolean(this._actionMovie))
            {
               this._actionMovie.dispose();
            }
            this._actionMovie = null;
            this._actionMovie = new movieClass();
            this._actionMovie.mouseEnabled = false;
            this._actionMovie.mouseChildren = false;
            this._actionMovie.scrollRect = null;
            this._actionMovie.doAction("stand");
            this.dir = this._dir;
            this._actionMovie.scaleY = this._scale;
            addChild(this._actionMovie);
            this._originalHeight = this._actionMovie.height;
            this._originalWidth = this._actionMovie.width;
            return;
         }
         throw new Error("simpleGameLiving initMovie()::找不到 actionMovieName : " + this._movieInfo.classPath + "请检查资源加载路径:" + this._movieInfo.path);
      }
      
      protected function initChatball() : void
      {
         this._chatballview = new ChatBallPlayer();
         this._originalHeight = this._actionMovie.height;
         this._originalWidth = this._actionMovie.width;
         this._chatballview.addEventListener(Event.COMPLETE,this.onChatBallComplete);
      }
      
      public function doAction(actionType:*) : void
      {
         if(this._actionMovie != null)
         {
            this._actionMovie.doAction(actionType);
         }
      }
      
      public function set dir(value:int) : void
      {
         this._dir = value;
         if(value > 0)
         {
            this._actionMovie.scaleX = Math.abs(this._scale) * -1;
         }
         else
         {
            this._actionMovie.scaleX = Math.abs(this._scale);
         }
      }
      
      public function set actionScale(value:Number) : void
      {
         this._scale = value;
         this._actionMovie.scaleX = this._scale;
         this._actionMovie.scaleY = this._scale;
      }
      
      public function say(data:String, type:int = 0) : void
      {
         this._chatballview.x = 0;
         this._chatballview.y = 0;
         addChild(this._chatballview);
         this._chatballview.setText(data,type);
         this.fitChatBallPos();
      }
      
      protected function fitChatBallPos() : void
      {
         this._chatballview.x = this.popPos.x;
         this._chatballview.y = this.popPos.y;
         this._chatballview.directionX = this._actionMovie.scaleX;
         if(Boolean(this.popDir))
         {
            this._chatballview.directionY = this.popDir.y - this._chatballview.y;
         }
      }
      
      protected function get popPos() : Point
      {
         if(Boolean(this._actionMovie["popupPos"]))
         {
            return new Point(this._actionMovie["popupPos"].x,this._actionMovie["popupPos"].y);
         }
         return new Point(-(this._originalWidth * 0.4) * this._actionMovie.scaleX,-(this._originalHeight * 0.8) * this._actionMovie.scaleY);
      }
      
      protected function get popDir() : Point
      {
         if(Boolean(this._actionMovie["popupDir"]))
         {
            return new Point(this._actionMovie["popupDir"].x,this._actionMovie["popupDir"].y);
         }
         return this.popPos;
      }
      
      protected function onChatBallComplete(evt:Event) : void
      {
         if(Boolean(this._chatballview) && Boolean(this._chatballview.parent))
         {
            this._chatballview.parent.removeChild(this._chatballview);
         }
      }
      
      public function dispose() : void
      {
         this._chatballview.removeEventListener(Event.COMPLETE,this.onChatBallComplete);
         if(Boolean(this._chatballview) && Boolean(this._chatballview.parent))
         {
            this._chatballview.parent.removeChild(this._chatballview);
         }
         if(Boolean(this._actionMovie))
         {
            this._actionMovie.dispose();
            this._actionMovie = null;
         }
         this._movieInfo = null;
      }
   }
}

