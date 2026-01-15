package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import game.view.smallMap.SmallLiving;
   import phy.object.PhysicalObj;
   import phy.object.PhysicsLayer;
   import phy.object.SmallObject;
   import road.game.resource.ActionMovie;
   
   public class SimpleObject extends PhysicalObj
   {
      
      protected var m_model:String;
      
      protected var m_action:String;
      
      protected var m_movie:MovieClip;
      
      protected var actionMapping:Dictionary;
      
      private var _smallMapView:SmallObject;
      
      private var _isBottom:Boolean;
      
      private var _shouldReCreate:Boolean = false;
      
      public function SimpleObject(id:int, type:int, model:String, action:String, isBottom:Boolean = false)
      {
         super(id,type);
         this.actionMapping = new Dictionary();
         mouseChildren = false;
         mouseEnabled = false;
         scrollRect = null;
         this.m_model = model;
         this.m_action = action;
         this._isBottom = isBottom;
         this.creatMovie(this.m_model);
         this.playAction(this.m_action);
         this.initSmallMapView();
      }
      
      override public function get layer() : int
      {
         if(this._isBottom)
         {
            return PhysicsLayer.AppointBottom;
         }
         return PhysicsLayer.SimpleObject;
      }
      
      public function createMovieAfterLoadComplete() : void
      {
         this.creatMovie(this.m_model);
      }
      
      public function get shouldReCreate() : Boolean
      {
         return this._shouldReCreate;
      }
      
      public function set shouldReCreate(value:Boolean) : void
      {
         this._shouldReCreate = value;
      }
      
      protected function creatMovie(model:String) : void
      {
         var moive_class:Class = null;
         if(ModuleLoader.hasDefinition(this.m_model))
         {
            this.shouldReCreate = false;
            moive_class = ModuleLoader.getDefinition(this.m_model) as Class;
            if(Boolean(moive_class))
            {
               this.m_movie = new moive_class();
               addChild(this.m_movie);
            }
         }
         else
         {
            this.shouldReCreate = true;
         }
      }
      
      protected function initSmallMapView() : void
      {
         if(layerType == 0)
         {
            this._smallMapView = new SmallLiving();
            this._smallMapView.visible = false;
         }
      }
      
      override public function get smallView() : SmallObject
      {
         return this._smallMapView;
      }
      
      public function playAction(action:String) : void
      {
         var s:FrameLabel = null;
         if(Boolean(this.actionMapping[action]))
         {
            action = this.actionMapping[action];
         }
         if(this.m_movie is ActionMovie)
         {
            if(action != "")
            {
               this.m_movie.gotoAndPlay(action);
            }
            return;
         }
         if(Boolean(this.m_movie))
         {
            if(action is String)
            {
               for each(s in this.m_movie.currentLabels)
               {
                  if(s.name == action)
                  {
                     this.m_movie.gotoAndPlay(action);
                  }
               }
            }
         }
         if(action == "1" || action == "2")
         {
            if(Boolean(this.m_movie))
            {
               this.m_movie.gotoAndPlay(action);
            }
         }
         if(this._smallMapView != null)
         {
            this._smallMapView.visible = action == "2";
         }
      }
      
      override public function collidedByObject(obj:PhysicalObj) : void
      {
         this.playAction("pick");
      }
      
      override public function setActionMapping(source:String, target:String) : void
      {
         if(this.m_movie is ActionMovie)
         {
            (this.m_movie as ActionMovie).setActionMapping(source,target);
            return;
         }
         this.actionMapping[source] = target;
      }
      
      override public function dispose() : void
      {
         var soundControl:SoundTransform = new SoundTransform();
         soundControl.volume = 0;
         if(Boolean(this.m_movie))
         {
            this.m_movie.stop();
            this.m_movie.soundTransform = soundControl;
         }
         super.dispose();
         if(Boolean(this.m_movie) && Boolean(this.m_movie.parent))
         {
            removeChild(this.m_movie);
         }
         this.m_movie = null;
         if(Boolean(this._smallMapView))
         {
            this._smallMapView.dispose();
            this._smallMapView = null;
         }
      }
      
      public function get movie() : MovieClip
      {
         return this.m_movie;
      }
   }
}

