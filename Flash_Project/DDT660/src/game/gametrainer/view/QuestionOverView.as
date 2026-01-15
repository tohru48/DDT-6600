package game.gametrainer.view
{
   import com.pickgliss.ui.controls.Frame;
   import ddt.manager.SoundManager;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import game.gametrainer.TrainerEvent;
   import org.aswing.KeyboardManager;
   
   public class QuestionOverView extends Frame
   {
      
      public function QuestionOverView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this.moveEnable = false;
         this.dispatchEvent(new TrainerEvent(TrainerEvent.CLOSE_FRAME));
      }
      
      public function set gotoAndStopTip(frame:int) : void
      {
      }
      
      private function __okFunction() : void
      {
         SoundManager.instance.play("008");
         this.dispatchEvent(new TrainerEvent(TrainerEvent.CLOSE_FRAME));
      }
      
      protected function __onKeyDownd(e:KeyboardEvent) : void
      {
         KeyboardManager.getInstance().reset();
         if(e.keyCode != Keyboard.ESCAPE)
         {
            return;
         }
         e.stopImmediatePropagation();
         this.dispatchEvent(new TrainerEvent(TrainerEvent.CLOSE_FRAME));
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

