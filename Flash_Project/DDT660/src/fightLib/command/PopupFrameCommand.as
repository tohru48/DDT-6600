package fightLib.command
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import fightLib.view.FightLibAlertView;
   
   public class PopupFrameCommand extends BaseFightLibCommand
   {
      
      private var _frame:FightLibAlertView;
      
      private var _callBack:Function;
      
      private var _okLable:String;
      
      private var _cancelLabel:String;
      
      private var _cancelFunc:Function;
      
      public function PopupFrameCommand(infoString:String, okLabel:String = "", okCallBack:Function = null, cancelLabel:String = "", cancelCallBack:Function = null, showOkBtn:Boolean = true, showCancelBtn:Boolean = false, WeaponArr:Array = null)
      {
         super();
         this._frame = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibAlertView",[infoString,okLabel,this.finish,cancelLabel,cancelCallBack,showOkBtn,showCancelBtn,WeaponArr]);
         this._callBack = okCallBack;
         this._okLable = okLabel;
         this._cancelLabel = cancelLabel;
         this._cancelFunc = cancelCallBack;
      }
      
      override public function excute() : void
      {
         super.excute();
         this._frame.show();
      }
      
      override public function finish() : void
      {
         if(this._callBack != null)
         {
            this._callBack();
         }
         this._frame.hide();
         super.finish();
      }
      
      override public function undo() : void
      {
         this._frame.hide();
         super.undo();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.hide();
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
         this._callBack = null;
         super.dispose();
      }
   }
}

