package game.view.propContainer
{
   import ddt.events.ItemEvent;
   import ddt.events.LivingEvent;
   import flash.display.Sprite;
   import game.model.LocalPlayer;
   
   public class BaseGamePropBarView extends Sprite
   {
      
      protected var _notExistTip:Sprite;
      
      protected var _itemContainer:ItemContainer;
      
      private var _self:LocalPlayer;
      
      public function BaseGamePropBarView(self:LocalPlayer, count:Number, column:Number, bgvisible:Boolean, ordinal:Boolean, clickable:Boolean, EffectType:String = "")
      {
         super();
         this._self = self;
         this._itemContainer = new ItemContainer(count,column,bgvisible,ordinal,clickable,EffectType);
         addChild(this._itemContainer);
         this._self.addEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChange);
         this._self.addEventListener(LivingEvent.DIE,this.__die);
         this._self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
      }
      
      public function get itemContainer() : ItemContainer
      {
         return this._itemContainer;
      }
      
      public function get self() : LocalPlayer
      {
         return this._self;
      }
      
      public function setClickEnabled(clickAble:Boolean, isGray:Boolean) : void
      {
         this._itemContainer.setState(clickAble,isGray);
      }
      
      public function dispose() : void
      {
         this._self.removeEventListener(LivingEvent.DIE,this.__die);
         this._self.removeEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChange);
         this._self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__changeAttack);
         removeChild(this._itemContainer);
         this._itemContainer.removeEventListener(ItemEvent.ITEM_CLICK,this.__click);
         this._itemContainer.removeEventListener(ItemEvent.ITEM_MOVE,this.__move);
         this._itemContainer.removeEventListener(ItemEvent.ITEM_OUT,this.__out);
         this._itemContainer.removeEventListener(ItemEvent.ITEM_OVER,this.__over);
         this._itemContainer.dispose();
         this._itemContainer = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
            this._itemContainer = null;
         }
      }
      
      private function __changeAttack(event:LivingEvent) : void
      {
         if(this._self.isAttacking && this._self.isLiving && !this._self.LockState)
         {
            this.setClickEnabled(false,false);
         }
      }
      
      private function __die(event:LivingEvent) : void
      {
         this.setClickEnabled(false,false);
      }
      
      protected function __energyChange(event:LivingEvent) : void
      {
         if(this._self.isLiving && !this._self.LockState)
         {
            this._itemContainer.setClickByEnergy(this._self.energy);
         }
         else if(this._self.isLiving && this._self.LockState)
         {
            this.setClickEnabled(false,true);
         }
      }
      
      protected function __move(event:ItemEvent) : void
      {
      }
      
      public function setVisible(index:int, v:Boolean) : void
      {
         this._itemContainer.setVisible(index,v);
      }
      
      protected function __over(event:ItemEvent) : void
      {
      }
      
      protected function __out(event:ItemEvent) : void
      {
      }
      
      protected function __click(event:ItemEvent) : void
      {
      }
      
      public function setLayerMode(mode:int) : void
      {
      }
   }
}

