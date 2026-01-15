package ddt.states
{
   import com.greensock.TweenLite;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.QQtipsManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import pet.sprite.PetSpriteController;
   import trainer.view.NewHandContainer;
   
   public class BaseStateView extends Sprite
   {
      
      private var _prepared:Boolean;
      
      private var _container:Sprite;
      
      private var _timer:Timer;
      
      private var _size:int = 60;
      
      private var _completed:int = 0;
      
      private var _shapes:Vector.<DisplayObject>;
      
      private var _oldStageWidth:int;
      
      public function BaseStateView()
      {
         super();
         this._container = new Sprite();
      }
      
      public function get prepared() : Boolean
      {
         return this._prepared;
      }
      
      public function check(type:String) : Boolean
      {
         return true;
      }
      
      public function prepare() : void
      {
         this._prepared = true;
      }
      
      public function enter(prev:BaseStateView, data:Object = null) : void
      {
         if(this.getType() != StateType.ROOM_LOADING && !StartupResourceLoader.firstEnterHall)
         {
            SoundManager.instance.playMusic("062",true,false);
         }
         QQtipsManager.instance.checkStateView(this.getType());
         this.playEnterMovie();
         PetSpriteController.Instance.showPetSprite(true,false);
      }
      
      private function playEnterMovie() : void
      {
         this._completed = 0;
         if(this._shapes == null || StageReferance.stageWidth != this._oldStageWidth)
         {
            this.createShapes();
            this._oldStageWidth = StageReferance.stageWidth;
         }
         this.rebackInitState();
         this._container.visible = true;
         LayerManager.Instance.addToLayer(this._container,LayerManager.STAGE_TOP_LAYER,false,0,true);
         this._timer = new Timer(20);
         this._timer.addEventListener(TimerEvent.TIMER,this.__tick);
         this._timer.start();
      }
      
      private function createShapes() : void
      {
         var w:int = 0;
         var h:int = 0;
         var i:int = 0;
         var bitmap:Bitmap = null;
         var src:BitmapData = new BitmapData(this._size,this._size,false,0);
         if(Boolean(this._shapes))
         {
            for(i = 0; i < this._shapes.length; i++)
            {
               ObjectUtils.disposeObject(this._shapes[i]);
               this._shapes[i] = null;
            }
            this._shapes = null;
         }
         this._shapes = new Vector.<DisplayObject>();
         do
         {
            h = 0;
            do
            {
               bitmap = new Bitmap(src);
               this._shapes.push(bitmap);
               h += this._size;
            }
            while(h < StageReferance.stageHeight);
            
            w += this._size;
         }
         while(w < StageReferance.stageWidth);
         
      }
      
      private function rebackInitState() : void
      {
         var h:int = 0;
         var i:int = 0;
         var w:int = 0;
         h = 0;
         i = 0;
         do
         {
            h = 0;
            do
            {
               this._shapes[i].width = this._size;
               this._shapes[i].height = this._size;
               this._shapes[i].x = w;
               this._shapes[i].y = h;
               this._shapes[i].alpha = 1;
               this._container.addChild(this._shapes[i]);
               h += this._size;
               i++;
            }
            while(h < StageReferance.stageHeight);
            
            w += this._size;
         }
         while(w < StageReferance.stageWidth);
         
      }
      
      private function __tick(evt:TimerEvent) : void
      {
         var h:int = 0;
         var half:int = 0;
         var i:int = 0;
         var shape:DisplayObject = null;
         var idx:int = this._timer.currentCount - 1;
         if(idx >= 0)
         {
            if(this._size * idx < StageReferance.stageWidth)
            {
               h = Math.floor(StageReferance.stageHeight / this._size);
               half = this._size >> 1;
               for(i = 0; i < h; i++)
               {
                  shape = this._shapes[i + h * idx];
                  TweenLite.to(shape,0.7,{
                     "x":shape.x + half,
                     "y":shape.y + half,
                     "width":0,
                     "height":0,
                     "alpha":0,
                     "onComplete":this.shapeTweenComplete
                  });
               }
            }
            else
            {
               this._timer.stop();
               this._timer.removeEventListener(TimerEvent.TIMER,this.__tick);
            }
         }
      }
      
      private function shapeTweenComplete() : void
      {
         ++this._completed;
         if(this._completed >= this._shapes.length)
         {
            this._container.visible = false;
         }
      }
      
      public function addedToStage() : void
      {
      }
      
      public function leaving(next:BaseStateView) : void
      {
         NewHandContainer.Instance.clearArrowByID(-1);
         PetSpriteController.Instance.hidePetSprite(true,false);
      }
      
      public function checkDispose(stateType:String) : void
      {
         var stateCreater:StateCreater = new StateCreater();
         var moduleArr:Array = stateCreater.getNeededUIModuleByType(stateType).split(",");
         stateCreater = null;
         moduleArr = null;
      }
      
      public function removedFromStage() : void
      {
      }
      
      public function getView() : DisplayObject
      {
         return this;
      }
      
      public function getType() : String
      {
         return StateType.DEAFULT;
      }
      
      public function getBackType() : String
      {
         return "";
      }
      
      public function goBack() : Boolean
      {
         return false;
      }
      
      public function fadingComplete() : void
      {
      }
      
      public function dispose() : void
      {
      }
      
      public function refresh() : void
      {
         this.playEnterMovie();
      }
   }
}

