package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import store.HelpFrame;
   
   public class ConsBatHelpBtn extends Sprite implements Disposeable
   {
      
      private var _btn:SimpleBitmapButton;
      
      public function ConsBatHelpBtn()
      {
         super();
         this._btn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.HelpButton");
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("consortiaBattle.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("consortiaBattle.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

