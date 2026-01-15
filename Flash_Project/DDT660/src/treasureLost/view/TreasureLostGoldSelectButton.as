package treasureLost.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import flash.display.MovieClip;
   
   public class TreasureLostGoldSelectButton extends SimpleBitmapButton
   {
      
      private var _select:Boolean;
      
      private var _selectMc:MovieClip;
      
      public var selectId:int;
      
      public function TreasureLostGoldSelectButton()
      {
         super();
         this._selectMc = ComponentFactory.Instance.creat("treasureLost.goldDiceSelect");
         this._selectMc.x = -3;
         this._selectMc.y = -2;
         addChild(this._selectMc);
         this._selectMc.visible = false;
      }
      
      public function set select(value:Boolean) : void
      {
         this._select = value;
         if(this._select)
         {
            this._selectMc.visible = true;
         }
         else
         {
            this._selectMc.visible = false;
         }
      }
   }
}

