package store.view.embed
{
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.ITransformableTipedDisplay;
   
   public class MultipleButton extends TextButton implements ITransformableTipedDisplay
   {
      
      public var P_tipWidth:String = "tipWidth";
      
      public var P_tipHeight:String = "tipHeight";
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      public function MultipleButton()
      {
         super();
      }
      
      public function get tipWidth() : int
      {
         return this._tipWidth;
      }
      
      public function set tipWidth(value:int) : void
      {
         if(this._tipWidth == value)
         {
            return;
         }
         this._tipWidth = value;
         onPropertiesChanged(this.P_tipWidth);
      }
      
      public function get tipHeight() : int
      {
         return this._tipHeight;
      }
      
      public function set tipHeight(value:int) : void
      {
         if(this._tipHeight == value)
         {
            return;
         }
         this._tipHeight = value;
         onPropertiesChanged(this.P_tipHeight);
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(Boolean(_changedPropeties[P_tipDirction]) || Boolean(_changedPropeties[P_tipGap]) || Boolean(_changedPropeties[P_tipStyle]) || Boolean(_changedPropeties[P_tipData]) || Boolean(_changedPropeties[this.P_tipWidth]) || Boolean(_changedPropeties[this.P_tipHeight]))
         {
            ShowTipManager.Instance.addTip(this);
         }
      }
   }
}

