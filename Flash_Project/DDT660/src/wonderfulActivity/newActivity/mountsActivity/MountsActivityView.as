package wonderfulActivity.newActivity.mountsActivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import wonderfulActivity.views.IRightView;
   
   public class MountsActivityView extends Sprite implements IRightView
   {
      
      private var _title:FilterFrameText;
      
      private var _describe:FilterFrameText;
      
      private var _timeFromTo:FilterFrameText;
      
      private var _ttlRequirement:Bitmap;
      
      private var _ttlAward:Bitmap;
      
      private var _ttlState:Bitmap;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _view:VBox;
      
      private var _compFactory:ComponentFactory;
      
      public function MountsActivityView()
      {
         super();
         this._compFactory = ComponentFactory.Instance;
      }
      
      public function init() : void
      {
         this._title = this._compFactory.creat("");
         addChild(this._title);
         this._describe = this._compFactory.creat("");
         addChild(this._describe);
         this._timeFromTo = this._compFactory.creat("");
         addChild(this._timeFromTo);
         this._ttlRequirement = this._compFactory.creat("");
         this._ttlAward = this._compFactory.creat("");
         this._ttlState = this._compFactory.creat("");
         this._scrollPanel = new ScrollPanel();
         addChild(this._scrollPanel);
         this._view = new VBox();
         this._scrollPanel.addChild(this._view);
      }
      
      public function dispose() : void
      {
         this._title.dispose();
         this._describe.dispose();
         this._timeFromTo.dispose();
         this._ttlRequirement = null;
         this._ttlAward = null;
         this._ttlState = null;
         this._scrollPanel.removeChild(this._view);
         this._scrollPanel.dispose();
         while(this._view.numChildren > 0)
         {
            this._view.removeChildAt(0);
         }
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
   }
}

