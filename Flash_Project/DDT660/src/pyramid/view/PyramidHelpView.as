package pyramid.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class PyramidHelpView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _panel:ScrollPanel;
      
      private var _list:VBox;
      
      private var _descripTxt:FilterFrameText;
      
      public function PyramidHelpView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("assets.pyramid.helpViewBg");
         addChild(this._bg);
         this._descripTxt = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.helpViewScriptTxt");
         this._descripTxt.text = LanguageMgr.GetTranslation("ddt.pyramid.helpViewScriptTxt");
         this._list = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.helpViewVBox");
         this._list.addChild(this._descripTxt);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.helpViewScrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         addChild(this._panel);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._descripTxt);
         this._descripTxt = null;
         ObjectUtils.disposeAllChildren(this._list);
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeAllChildren(this._panel);
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

