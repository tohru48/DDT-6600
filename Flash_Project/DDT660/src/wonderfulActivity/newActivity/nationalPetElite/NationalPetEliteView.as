package wonderfulActivity.newActivity.nationalPetElite
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Sprite;
   import wonderfulActivity.data.ActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class NationalPetEliteView extends Sprite implements IRightView
   {
      
      private var _title:FilterFrameText;
      
      private var _describe:FilterFrameText;
      
      private var _timeFromTo:FilterFrameText;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _data:ActivityTypeData;
      
      private var _compFactory:ComponentFactory;
      
      public function NationalPetEliteView(data:ActivityTypeData = null)
      {
         super();
         this._data = data;
         this._compFactory = ComponentFactory.Instance;
      }
      
      public function init() : void
      {
         this._title = this._compFactory.creat("");
      }
      
      public function dispose() : void
      {
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

