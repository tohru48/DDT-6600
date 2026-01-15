package midAutumnWorshipTheMoon.view
{
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import hall.HallStateView;
   import midAutumnWorshipTheMoon.WorshipTheMoonManager;
   
   public class WorshipTheMoonEnterButton extends SimpleBitmapButton
   {
      
      private var _hall:HallStateView;
      
      public function WorshipTheMoonEnterButton()
      {
         super();
         this.buttonMode = true;
         this.useHandCursor = true;
      }
      
      public function show() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function hide() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(me:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade >= 15)
         {
            WorshipTheMoonManager.getInstance().showFrame();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worshipTheMoon.higherGradeNeeded"),0,true,1);
         }
      }
      
      public function set hall(value:HallStateView) : void
      {
         this._hall = value;
      }
      
      override public function dispose() : void
      {
         this.hide();
         this._hall = null;
         super.dispose();
      }
   }
}

