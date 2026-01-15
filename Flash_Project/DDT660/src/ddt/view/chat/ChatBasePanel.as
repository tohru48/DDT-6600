package ddt.view.chat
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ChatBasePanel extends Sprite
   {
      
      public function ChatBasePanel()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      protected function init() : void
      {
         graphics.beginFill(0,0);
         graphics.drawRect(-3000,-3000,6000,6000);
         graphics.endFill();
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__hideThis);
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__hideThis);
      }
      
      protected function __hideThis(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setVisible = false;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function set setVisible(value:Boolean) : void
      {
         if(visible == true && value == false)
         {
            ShowTipManager.Instance.removeCurrentTip();
         }
         if(value)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,0,false);
         }
         else if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

