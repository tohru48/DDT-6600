package escort.view
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import store.HelpFrame;
   
   public class EscortHelpBtn extends Sprite implements Disposeable
   {
      
      private var _btn:SimpleBitmapButton;
      
      public function EscortHelpBtn(isInGame:Boolean = true)
      {
         super();
         if(isInGame)
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("escort.HelpButton");
         }
         else
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("escort.HelpButtonShort");
         }
         addChild(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadIconCompleteHandler);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.SEVEN_DOUBLE_ICON);
      }
      
      private function loadIconCompleteHandler(event:UIModuleEvent) : void
      {
         var helpBd:DisplayObject = null;
         var helpPage:HelpFrame = null;
         if(event.module == UIModuleTypes.SEVEN_DOUBLE_ICON)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadIconCompleteHandler);
            helpBd = ComponentFactory.Instance.creat("escort.HelpPrompt");
            helpPage = ComponentFactory.Instance.creat("escort.HelpFrame");
            helpPage.setView(helpBd);
            helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
            helpPage.changeSubmitButtonY(29);
            LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
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

