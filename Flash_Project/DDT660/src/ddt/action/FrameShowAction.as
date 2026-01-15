package ddt.action
{
   import com.pickgliss.action.BaseAction;
   
   public class FrameShowAction extends BaseAction
   {
      
      private var _frame:Object;
      
      private var _showFun:Function;
      
      public function FrameShowAction(frame:Object, showFun:Function = null, timeOut:uint = 0)
      {
         this._frame = frame;
         this._showFun = showFun;
         super(timeOut);
      }
      
      override public function act() : void
      {
         if(this._showFun is Function)
         {
            this._showFun();
         }
         else
         {
            this._frame.show();
         }
         super.act();
      }
   }
}

