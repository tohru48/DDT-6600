package game.objects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class AnimationObject extends Sprite
   {
      
      private var _id:int;
      
      private var _linkName:String;
      
      private var _animation:MovieClip;
      
      public function AnimationObject(id:int, linkName:String)
      {
         super();
         this._id = id;
         this._linkName = linkName;
         this.initView();
      }
      
      private function initView() : void
      {
         this._animation = ComponentFactory.Instance.creat(this._linkName);
         addChild(this._animation);
      }
      
      public function dispose() : void
      {
         this._id = -1;
         if(Boolean(this._animation))
         {
            this._animation = null;
         }
      }
      
      public function get Id() : int
      {
         return this._id;
      }
   }
}

