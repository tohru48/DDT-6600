package changeColor
{
   import bagAndInfo.cell.BagCell;
   import changeColor.view.ChangeColorFrame;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   
   public class ChangeColorController
   {
      
      public static var _instance:ChangeColorController;
      
      private var _isOneThing:Boolean = false;
      
      private var _changeColorModel:ChangeColorModel;
      
      private var _changeColorFrame:ChangeColorFrame;
      
      public function ChangeColorController()
      {
         super();
      }
      
      public static function get instance() : ChangeColorController
      {
         if(!_instance)
         {
            _instance = new ChangeColorController();
         }
         return _instance;
      }
      
      public function get changeColorModel() : ChangeColorModel
      {
         if(!this._changeColorModel)
         {
            this._changeColorModel = new ChangeColorModel();
         }
         return this._changeColorModel;
      }
      
      public function show() : void
      {
         if(!this._changeColorFrame)
         {
            this._changeColorFrame = ComponentFactory.Instance.creatComponentByStylename("changeColor.ChangeColorFrame");
            this._changeColorFrame.moveEnable = false;
            this._changeColorFrame.show();
            if(this._isOneThing)
            {
               this._changeColorFrame.setFirstItemSelected();
               this._isOneThing = false;
            }
         }
      }
      
      public function addOneThing(cell:BagCell) : void
      {
         this._isOneThing = true;
         this._changeColorModel.setOnlyOneEditableThing(cell.itemInfo);
      }
      
      public function close() : void
      {
         if(Boolean(this._changeColorFrame))
         {
            ObjectUtils.disposeObject(this._changeColorFrame);
            this._changeColorFrame = null;
         }
         if(Boolean(this._changeColorModel))
         {
            this._changeColorModel = null;
         }
      }
   }
}

