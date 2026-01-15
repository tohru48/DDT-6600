package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   import labyrinth.LabyrinthManager;
   
   public class TransmissionGate extends SimpleObject implements Disposeable, ITipedDisplay
   {
      
      private var _lightColor:ColorTransform;
      
      private var _normalColor:ColorTransform;
      
      protected var _tipData:Object;
      
      protected var _tipDirction:String;
      
      protected var _tipGapV:int;
      
      protected var _tipGapH:int;
      
      protected var _tipStyle:String;
      
      private var _timer:Timer;
      
      public function TransmissionGate(id:int, type:int, model:String, action:String)
      {
         super(id,type,model,action);
         _canCollided = true;
         setCollideRect(-50,-100,50,100);
         getCollideRect();
         this._lightColor = new ColorTransform();
         this._lightColor.redOffset = 0;
         this._lightColor.greenOffset = 145;
         this._lightColor.blueOffset = 239;
         this._normalColor = new ColorTransform();
         mouseChildren = true;
         mouseEnabled = true;
         buttonMode = false;
         this.tipStyle = "ddt.view.tips.OneLineTip";
         this.tipDirctions = "4";
         this.tipGapV = 90;
         this.tipGapH = -20;
         if(LabyrinthManager.Instance.model.currentFloor == 30)
         {
            this.tipData = LanguageMgr.GetTranslation("game.objects.TransmissionGate.tips");
         }
         else
         {
            this.tipData = LanguageMgr.GetTranslation("game.objects.TransmissionGate.tipsII");
         }
         ShowTipManager.Instance.addTip(this);
      }
      
      protected function __timerComplete(event:TimerEvent) : void
      {
         GameInSocketOut.sendGameSkipNext(0);
      }
      
      override protected function creatMovie(model:String) : void
      {
         var moive_class:Class = ModuleLoader.getDefinition(m_model) as Class;
         if(Boolean(moive_class))
         {
            m_movie = new moive_class();
            m_movie.scaleY = 1.7;
            m_movie.scaleX = 1.7;
            m_movie.addEventListener(MouseEvent.MOUSE_OVER,this.__onOver);
            m_movie.addEventListener(MouseEvent.MOUSE_OUT,this.__onOut);
            m_movie.addEventListener(MouseEvent.CLICK,this.__onClick);
            addChild(m_movie);
         }
      }
      
      protected function __onClick(event:MouseEvent) : void
      {
      }
      
      protected function __onOut(event:MouseEvent) : void
      {
         if(Boolean(m_movie) && Boolean(m_movie.transform))
         {
            m_movie.transform.colorTransform = this._normalColor;
         }
      }
      
      protected function __onOver(event:MouseEvent) : void
      {
         if(Boolean(m_movie) && Boolean(m_movie.transform))
         {
            m_movie.transform.colorTransform = this._lightColor;
         }
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         if(Boolean(m_movie))
         {
            m_movie.removeEventListener(MouseEvent.MOUSE_OVER,this.__onOver);
            m_movie.removeEventListener(MouseEvent.MOUSE_OVER,this.__onOut);
         }
         super.dispose();
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(value:Object) : void
      {
         if(this._tipData == value)
         {
            return;
         }
         this._tipData = value;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirction;
      }
      
      public function set tipDirctions(value:String) : void
      {
         if(this._tipDirction == value)
         {
            return;
         }
         this._tipDirction = value;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(value:int) : void
      {
         if(this._tipGapV == value)
         {
            return;
         }
         this._tipGapV = value;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(value:int) : void
      {
         if(this._tipGapH == value)
         {
            return;
         }
         this._tipGapH = value;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(value:String) : void
      {
         if(this._tipStyle == value)
         {
            return;
         }
         this._tipStyle = value;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

