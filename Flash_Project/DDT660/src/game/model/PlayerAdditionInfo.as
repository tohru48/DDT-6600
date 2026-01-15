package game.model
{
   public class PlayerAdditionInfo
   {
      
      private var _auncherExperienceAddition:Number = 1;
      
      private var _gmExperienceAdditionType:Number = 1;
      
      private var _gmOfferAddition:Number = 1;
      
      private var _auncherOfferAddition:Number = 1;
      
      private var _gmRichesAddition:Number = 1;
      
      private var _auncherRichesAddition:Number = 1;
      
      public function PlayerAdditionInfo()
      {
         super();
      }
      
      public function get AuncherExperienceAddition() : Number
      {
         return this._auncherExperienceAddition;
      }
      
      public function set AuncherExperienceAddition(val:Number) : void
      {
         this._auncherExperienceAddition = val;
      }
      
      public function get GMExperienceAdditionType() : Number
      {
         return this._gmExperienceAdditionType;
      }
      
      public function set GMExperienceAdditionType(val:Number) : void
      {
         this._gmExperienceAdditionType = val;
      }
      
      public function get GMOfferAddition() : Number
      {
         return this._gmOfferAddition;
      }
      
      public function set GMOfferAddition(val:Number) : void
      {
         this._gmOfferAddition = val;
      }
      
      public function get AuncherOfferAddition() : Number
      {
         return this._auncherOfferAddition;
      }
      
      public function set AuncherOfferAddition(val:Number) : void
      {
         this._auncherOfferAddition = val;
      }
      
      public function get GMRichesAddition() : Number
      {
         return this._gmRichesAddition;
      }
      
      public function set GMRichesAddition(val:Number) : void
      {
         this._gmRichesAddition = val;
      }
      
      public function get AuncherRichesAddition() : Number
      {
         return this._auncherRichesAddition;
      }
      
      public function set AuncherRichesAddition(val:Number) : void
      {
         this._auncherRichesAddition = val;
      }
      
      public function resetAddition() : void
      {
         this._auncherExperienceAddition = 1;
         this._gmExperienceAdditionType = 1;
         this._gmOfferAddition = 1;
         this._auncherOfferAddition = 1;
         this._gmRichesAddition = 1;
         this._auncherRichesAddition = 1;
      }
   }
}

