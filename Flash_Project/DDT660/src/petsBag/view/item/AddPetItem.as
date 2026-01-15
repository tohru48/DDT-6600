package petsBag.view.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   
   public class AddPetItem extends Component
   {
      
      protected var _bg:DisplayObject;
      
      protected var _info:PetInfo;
      
      protected var _petIcon:PetSmallIcon;
      
      protected var _icon:Bitmap;
      
      protected var _star:StarBar;
      
      public function AddPetItem(info:PetInfo)
      {
         super();
         this._info = info;
         this.initView();
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("assets.bag.petPnlBg");
         addChild(this._bg);
         if(Boolean(this._info))
         {
            this._petIcon = new PetSmallIcon(PetBagController.instance().getPicStrByLv(this._info));
            this._petIcon.addEventListener(Event.COMPLETE,this.__petIconLoadComplete);
            this._petIcon.startLoad();
            this._star = ComponentFactory.Instance.creat("bagAndInfo.starBar.petStar");
            addChild(this._star);
            this._star.starNum(this._info.StarLevel,"assets.bag.star");
         }
      }
      
      protected function __petIconLoadComplete(event:Event) : void
      {
         this._petIcon.removeEventListener(Event.COMPLETE,this.__petIconLoadComplete);
         this._icon = this._petIcon.icon;
         if(Boolean(this._icon))
         {
            PositionUtils.setPos(this._icon,"farm.bagAndInfo.iconPos");
            addChild(this._icon);
            this._icon.width = AdoptItem.ADOPT_PET_ITEM_WIDTH;
            this._icon.height = AdoptItem.ADOPT_PET_ITEM_WIDTH;
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._star))
         {
            ObjectUtils.disposeObject(this._star);
            this._star = null;
         }
         if(Boolean(this._icon))
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
         if(Boolean(this._petIcon))
         {
            ObjectUtils.disposeObject(this._petIcon);
            this._petIcon = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         this._info = null;
         super.dispose();
      }
   }
}

