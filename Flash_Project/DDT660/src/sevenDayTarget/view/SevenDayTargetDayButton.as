package sevenDayTarget.view
{
   import com.pickgliss.ui.controls.BaseButton;
   import flash.events.MouseEvent;
   
   public class SevenDayTargetDayButton extends BaseButton
   {
      
      public function SevenDayTargetDayButton()
      {
         super();
      }
      
      override protected function addEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,__onMouseRollover);
         addEventListener(MouseEvent.ROLL_OUT,__onMouseRollout);
      }
   }
}

