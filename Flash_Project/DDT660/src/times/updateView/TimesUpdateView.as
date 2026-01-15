package times.updateView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TimesUpdateView extends Sprite implements Disposeable
   {
      
      private var _bg:MovieClip;
      
      private var _updateContentTip:Bitmap;
      
      private var _updateTimeTip:Bitmap;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _updateTimeTxt:FilterFrameText;
      
      public function TimesUpdateView(param1:Array, param2:Boolean = false)
      {
         var _loc5_:TimesUpdateViewCell = null;
         super();
         if(param2)
         {
            this.graphics.beginFill(8611920);
            this.graphics.drawRect(-5,-46,765,465);
            this.graphics.endFill();
         }
         this._bg = ComponentFactory.Instance.creat("asset.timesUpdate.viewBg");
         this._updateContentTip = ComponentFactory.Instance.creatBitmap("asset.timesUpdate.updateContentTip");
         this._updateTimeTip = ComponentFactory.Instance.creatBitmap("asset.timesUpdate.updateTimeTip");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("timesUpdate.view.contentVBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("timesUpdate.view.contentScrollPanel");
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new TimesUpdateViewCell(param1[_loc4_]);
            this._vbox.addChild(_loc5_);
            _loc4_++;
         }
         this._scrollPanel.setView(this._vbox);
         this._updateTimeTxt = ComponentFactory.Instance.creatComponentByStylename("timesUpdate.view.updateTimeTxt");
         this._updateTimeTxt.text = param1[0].BeginTime.split("T")[0].replace(/-/g,".");
         addChild(this._bg);
         addChild(this._updateContentTip);
         addChild(this._updateTimeTip);
         addChild(this._scrollPanel);
         addChild(this._updateTimeTxt);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._updateContentTip = null;
         this._updateTimeTip = null;
         this._scrollPanel = null;
         this._updateTimeTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

