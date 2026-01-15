package fightLib.command
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import fightLib.view.FightLibAlertView;
   
   public class PopUpFrameWaitCommand extends WaittingCommand
   {
      
      private var _frame:FightLibAlertView;
      
      public function PopUpFrameWaitCommand(infoString:String, $finishFun:Function, okLabel:String = "", okFun:Function = null, cancelLabel:String = "", cancelFun:Function = null, showOkBtn:Boolean = true, showCancelBtn:Boolean = false)
      {
         super($finishFun);
         this._frame = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibAlertView",[infoString,okLabel,this.finish,cancelLabel,cancelFun,showOkBtn,showCancelBtn]);
      }
      
      override public function excute() : void
      {
         this._frame.show();
         super.excute();
      }
      
      override public function undo() : void
      {
         this._frame.hide();
         super.undo();
      }
      
      override public function finish() : void
      {
         super.finish();
         this._frame.hide();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
         super.dispose();
      }
   }
}

