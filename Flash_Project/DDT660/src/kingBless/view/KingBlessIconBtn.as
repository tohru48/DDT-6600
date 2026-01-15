package kingBless.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kingBless.KingBlessManager;
   
   public class KingBlessIconBtn extends Component
   {
      
      private var _btn:MovieClip;
      
      public function KingBlessIconBtn()
      {
         super();
         this.mouseChildren = false;
         this._btn = ComponentFactory.Instance.creat("assets.hallIcon.kingBlessIcon");
         this._btn.x = 15;
         this._btn.gotoAndStop(1);
         addChild(this._btn);
         this.refreshCartoonState(null);
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,this.openKingBlessFrame,false,0,true);
         KingBlessManager.instance.addEventListener(KingBlessManager.UPDATE_MAIN_EVENT,this.refreshCartoonState);
      }
      
      private function refreshCartoonState(event:Event) : void
      {
         var tmp:MovieClip = this._btn["cartoon"] as MovieClip;
         var icon:MovieClip = this._btn["icon"] as MovieClip;
         if(Boolean(tmp))
         {
            if(KingBlessManager.instance.openType > 0)
            {
               tmp.gotoAndPlay(1);
               icon.gotoAndPlay(1);
            }
            else
            {
               tmp.gotoAndStop(tmp.totalFrames);
               icon.gotoAndStop(1);
            }
         }
      }
      
      private function openKingBlessFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         KingBlessManager.instance.loadKingBlessModule(KingBlessManager.instance.doOpenKingBlessFrame);
      }
      
      override public function get tipData() : Object
      {
         return KingBlessManager.instance.getRemainTimeTxt();
      }
      
      override public function get height() : Number
      {
         if(Boolean(this._btn))
         {
            return 65;
         }
         return super.height;
      }
      
      override public function dispose() : void
      {
         KingBlessManager.instance.removeEventListener(KingBlessManager.UPDATE_MAIN_EVENT,this.refreshCartoonState);
         this.removeEventListener(MouseEvent.CLICK,this.openKingBlessFrame);
         if(Boolean(this._btn))
         {
            this._btn.gotoAndStop(2);
            if(Boolean(this._btn.parent))
            {
               this._btn.parent.removeChild(this._btn);
            }
            this._btn = null;
         }
         super.dispose();
      }
   }
}

