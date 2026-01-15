package game.motions
{
   import flash.geom.Point;
   
   public class BaseMotionFunc implements IMotionFunction
   {
      
      protected var _initial:Point;
      
      protected var _final:Point;
      
      protected var _result:Object;
      
      protected var _lifetime:int;
      
      protected var _isPlaying:Boolean;
      
      public function BaseMotionFunc(paramsObject:Object)
      {
         super();
         this._lifetime = 0;
         this._initial = new Point(0,0);
         if(Boolean(paramsObject.initial))
         {
            this._initial = paramsObject.initial;
         }
         this._final = new Point(0,0);
         if(Boolean(paramsObject.final))
         {
            this._final = paramsObject.final;
         }
      }
      
      public function getVectorByTime(t:int) : Object
      {
         return null;
      }
      
      public function getResult() : Object
      {
         if(!this._isPlaying)
         {
            return null;
         }
         return null;
      }
   }
}

