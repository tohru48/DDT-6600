package pet.sprite
{
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import pet.date.PetInfo;
   
   public class PetSpriteModel extends EventDispatcher
   {
      
      public static const CURRENT_PET_CHANGED:String = "currentPetChanged";
      
      public static const HUNGER_CHANGED:String = "hungerChanged";
      
      public static const GP_CHANGED:String = "gpChanged";
      
      private var _currentPet:PetInfo;
      
      private var _petSwitcher:Boolean = true;
      
      public function PetSpriteModel(target:IEventDispatcher = null)
      {
         super(target);
         this.initEvents();
      }
      
      public function get petSwitcher() : Boolean
      {
         return this._petSwitcher;
      }
      
      public function set petSwitcher(value:Boolean) : void
      {
         this._petSwitcher = value;
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updatePet);
      }
      
      protected function __updatePet(event:PlayerPropertyEvent) : void
      {
         if(event.changedProperties[SelfInfo.PET] != null)
         {
            return;
         }
         if(this._currentPet != PlayerManager.Instance.Self.currentPet)
         {
            this.currentPet = PlayerManager.Instance.Self.currentPet;
         }
      }
      
      public function set currentPet(val:PetInfo) : void
      {
         if(val == this._currentPet)
         {
            return;
         }
         this._currentPet = val;
         dispatchEvent(new Event(CURRENT_PET_CHANGED));
      }
      
      private function __gpChanged() : void
      {
         dispatchEvent(new Event(GP_CHANGED));
      }
      
      protected function __hungerChanged(event:Event) : void
      {
         dispatchEvent(new Event(HUNGER_CHANGED));
      }
      
      public function get currentPet() : PetInfo
      {
         return this._currentPet;
      }
   }
}

