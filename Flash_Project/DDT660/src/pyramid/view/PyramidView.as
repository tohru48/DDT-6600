package pyramid.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.AddPublicTipManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import pyramid.PyramidManager;
   import pyramid.event.PyramidEvent;
   
   public class PyramidView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _leftView:PyramidLeftView;
      
      private var _returnBtn:PyramidReturnBar;
      
      private var _helpView:PyramidHelpView;
      
      private var _shopView:PyramidShopView;
      
      private var _activeTimeTitle:FilterFrameText;
      
      private var _activeTimeTxt:FilterFrameText;
      
      public function PyramidView()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      private function initView() : void
      {
         AddPublicTipManager.Instance.type = AddPublicTipManager.JINZITA;
         this._bg = ComponentFactory.Instance.creatBitmap("assets.pyramid.bg");
         this._leftView = ComponentFactory.Instance.creatCustomObject("pyramid.view.leftView");
         this._shopView = ComponentFactory.Instance.creatCustomObject("pyramid.view.shopView");
         this._helpView = ComponentFactory.Instance.creatCustomObject("pyramid.view.helpView");
         this._returnBtn = ComponentFactory.Instance.creat("asset.pyramid.returnMenu");
         this._activeTimeTitle = ComponentFactory.Instance.creatComponentByStylename("pyramid.view.activeTimeTitle");
         this._activeTimeTitle.text = LanguageMgr.GetTranslation("ddt.pyramid.activeTimeTitle");
         this._activeTimeTxt = ComponentFactory.Instance.creatComponentByStylename("pyramid.view.activeTimeTxt");
         addChild(this._bg);
         addChild(this._leftView);
         addChild(this._shopView);
         addChild(this._helpView);
         addChild(this._returnBtn);
         addChild(this._activeTimeTitle);
         addChild(this._activeTimeTxt);
      }
      
      private function initData() : void
      {
         this._activeTimeTxt.text = PyramidManager.instance.model.activityTime;
      }
      
      private function initEvent() : void
      {
         PyramidManager.instance.addEventListener(PyramidEvent.RETURN_PYRAMID,this.__onReturn);
      }
      
      private function __onReturn(event:PyramidEvent) : void
      {
         SoundManager.instance.play("008");
         StateManager.setState(StateType.MAIN);
      }
      
      private function removeEvent() : void
      {
         PyramidManager.instance.removeEventListener(PyramidEvent.RETURN_PYRAMID,this.__onReturn);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         AddPublicTipManager.Instance.type = 0;
         ObjectUtils.disposeObject(this._returnBtn);
         this._returnBtn = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._leftView);
         this._leftView = null;
         ObjectUtils.disposeObject(this._helpView);
         this._helpView = null;
         ObjectUtils.disposeObject(this._shopView);
         this._shopView = null;
         ObjectUtils.disposeObject(this._activeTimeTitle);
         this._activeTimeTitle = null;
         ObjectUtils.disposeObject(this._activeTimeTxt);
         this._activeTimeTxt = null;
         PyramidManager.instance.movieLock = false;
         PyramidManager.instance.clearFrame();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

