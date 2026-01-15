package newOpenGuide
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class NewOpenGuideRightView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _promptTxt:FilterFrameText;
      
      private var _iconMc:MovieClip;
      
      private var _isDispose:Boolean = false;
      
      public function NewOpenGuideRightView()
      {
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.newOpenGuide.rightViewBg");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("newOpenGuideRightView.titleTxt");
         this._promptTxt = ComponentFactory.Instance.creatComponentByStylename("newOpenGuideRightView.promptTxt");
         this._iconMc = ComponentFactory.Instance.creat("asset.newOpenGuide.iconMc");
         this._iconMc.x = 1;
         this._iconMc.y = 0;
         this._iconMc.gotoAndStop(this._iconMc.totalFrames);
         addChild(this._bg);
         addChild(this._titleTxt);
         addChild(this._promptTxt);
         addChild(this._iconMc);
         this.refreshView();
      }
      
      public function refreshView() : void
      {
         var tmpArray:Array = null;
         if(this._isDispose)
         {
            return;
         }
         tmpArray = NewOpenGuideManager.instance.getTitleStrIndexByLevel(PlayerManager.Instance.Self.Grade + 1);
         if(tmpArray[0] > 0)
         {
            this.visible = true;
            this._titleTxt.text = tmpArray[1];
            this._promptTxt.text = LanguageMgr.GetTranslation("newOpenGuide.openPromptStr",tmpArray[2]);
            this._iconMc.gotoAndStop(tmpArray[0]);
         }
         else
         {
            this.visible = false;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._titleTxt = null;
         this._promptTxt = null;
         this._iconMc = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._isDispose = true;
      }
   }
}

