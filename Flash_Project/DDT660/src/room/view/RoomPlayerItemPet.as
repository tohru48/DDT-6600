package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   
   public class RoomPlayerItemPet extends Sprite implements Disposeable
   {
      
      private var _petLevel:FilterFrameText;
      
      private var _petInfo:PetInfo;
      
      private var _headPetWidth:Number;
      
      private var _headPetHight:Number;
      
      private var _excursion:Number = 3;
      
      private var _icons:Dictionary;
      
      public function RoomPlayerItemPet(w:Number = 0, h:Number = 0)
      {
         super();
         this._headPetWidth = w;
         this._headPetHight = h;
         this._icons = new Dictionary();
         this._petLevel = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.playerItem.petLevelTxt");
         addChild(this._petLevel);
      }
      
      private function createPetIcon() : void
      {
         var petIcon:BitmapLoaderProxy = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagController.instance().getPicStrByLv(this._petInfo)),null,true);
         petIcon.addEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__iconLoadingFinish);
         this._icons[this._petInfo.ID] = petIcon;
      }
      
      public function updateView(value:PetInfo) : void
      {
         this._petInfo = value;
         this.iconvisible();
         if(Boolean(this._petInfo))
         {
            if(Boolean(this._icons[this._petInfo.ID]))
            {
               this._icons[this._petInfo.ID].visible = true;
            }
            else
            {
               this.createPetIcon();
            }
            this._petLevel.text = "LV:" + this._petInfo.Level;
         }
         else
         {
            this._petLevel.text = "";
         }
      }
      
      private function iconvisible() : void
      {
         var petIcon:BitmapLoaderProxy = null;
         for each(petIcon in this._icons)
         {
            if(Boolean(petIcon))
            {
               petIcon.visible = false;
            }
         }
      }
      
      private function __iconLoadingFinish(e:Event) : void
      {
         var petIcon:BitmapLoaderProxy = null;
         petIcon = e.target as BitmapLoaderProxy;
         petIcon.removeEventListener(BitmapLoaderProxy.LOADING_FINISH,this.__iconLoadingFinish);
         petIcon.scaleX = 0.7;
         petIcon.scaleY = 0.7;
         petIcon.x = (this._headPetWidth - petIcon.width) / 2 + this._excursion;
         petIcon.y = (this._headPetHight - petIcon.height) / 2;
         addChildAt(petIcon,0);
         this._petLevel.x = petIcon.x + (petIcon.width - this._petLevel.width) / 2;
         this._petLevel.y = this._headPetHight - this._petLevel.height;
      }
      
      public function dispose() : void
      {
         var petIcon:BitmapLoaderProxy = null;
         if(Boolean(this._petLevel))
         {
            ObjectUtils.disposeObject(this._petLevel);
         }
         this._petLevel = null;
         for each(petIcon in this._icons)
         {
            if(Boolean(petIcon))
            {
               ObjectUtils.disposeObject(petIcon);
            }
            petIcon = null;
         }
         this._icons = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

