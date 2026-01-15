package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.view.item.PetSmallItem;
   
   public class PetMoveScroll extends Sprite implements Disposeable
   {
      
      public static const PET_MOVE:String = "PetMove";
      
      private var itemContainer:HBox;
      
      private const SPACE:int = 5;
      
      private const SHOW_PET_COUNT:int = 5;
      
      private var _currentShowIndex:int = 0;
      
      private var _isMove:Boolean = false;
      
      private var _petsImgVec:Vector.<PetSmallItem>;
      
      public var currentPet:PetSmallItem;
      
      private var _leftBtn:SimpleBitmapButton;
      
      private var _rightBtn:SimpleBitmapButton;
      
      private var _petBg:Sprite;
      
      private var _petBg2:DisplayObject;
      
      private var _petBg0:DisplayObject;
      
      private var _infoPlayer:PlayerInfo;
      
      private var _selectedIndex:int = -1;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      public function PetMoveScroll()
      {
         super();
         this._petsImgVec = new Vector.<PetSmallItem>();
         this.initView();
         this.initEvent();
      }
      
      public function set infoPlayer(value:PlayerInfo) : void
      {
         this._infoPlayer = value;
         if(!this._infoPlayer)
         {
            return;
         }
         this.upCells(this._currentPage);
         this.updateSelect();
      }
      
      public function refreshPetInfo(updateInfo:PetInfo, opType:int = 0) : void
      {
         if(opType == 0 || opType == 1)
         {
            this._infoPlayer.pets[updateInfo.Place] = updateInfo;
         }
         this.upCells(this._currentPage);
         if(opType == 2)
         {
            this.removePetPageUpdate();
         }
         this.updateSelect();
      }
      
      private function removePetPageUpdate() : void
      {
         var petSmallItem:PetSmallItem = null;
         var count:int = 0;
         for each(petSmallItem in this._petsImgVec)
         {
            if(Boolean(petSmallItem.info))
            {
               count++;
            }
         }
         if(count == 0)
         {
            this._currentPage = this._currentPage - 1 < 0 ? 0 : this._currentPage - 1;
            this._totlePage = this._infoPlayer.pets.length % 5 == 0 ? int(this._infoPlayer.pets.length / 5 - 1) : int(this._infoPlayer.pets.length / 5);
            this.upCells(this._currentPage);
         }
      }
      
      private function initView() : void
      {
         var cell:PetSmallItem = null;
         this._petBg0 = ComponentFactory.Instance.creat("petsBag.petMoveScroll.bottomBg0");
         addChild(this._petBg0);
         this._petBg2 = ComponentFactory.Instance.creat("petsBag.petMoveScroll.bottomBg");
         addChild(this._petBg2);
         this._petBg = ComponentFactory.Instance.creat("petsBag.sprite.moveScroll");
         addChild(this._petBg);
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.left");
         this._leftBtn.transparentEnable = true;
         addChild(this._leftBtn);
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.right");
         addChild(this._rightBtn);
         this.itemContainer = ComponentFactory.Instance.creatComponentByStylename("petsBag.petItemContainer");
         addChild(this.itemContainer);
         this.itemContainer.strictSize = 74;
         for(var i:int = 0; i < this.SHOW_PET_COUNT; i++)
         {
            cell = new PetSmallItem();
            this._petsImgVec.push(this.itemContainer.addChild(cell));
         }
      }
      
      private function initEvent() : void
      {
         var petItem:PetSmallItem = null;
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__left);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__right);
         for each(petItem in this._petsImgVec)
         {
            petItem.addEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      private function __onClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var item:PetSmallItem = event.currentTarget as PetSmallItem;
         if(Boolean(item.info))
         {
            PetBagController.instance().petModel.currentPetInfo = item.info;
            this._selectedIndex = this._petsImgVec.indexOf(item);
         }
      }
      
      public function updateSelect() : void
      {
         var petItem:PetSmallItem = null;
         var _info:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         for each(petItem in this._petsImgVec)
         {
            if(Boolean(petItem.info))
            {
               petItem.selected = Boolean(_info) && _info.ID == petItem.info.ID;
               if(petItem.selected)
               {
                  this._selectedIndex = this._petsImgVec.indexOf(petItem);
               }
            }
         }
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.__left);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.__right);
      }
      
      private function __left(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._totlePage = this._infoPlayer.pets.length % 5 == 0 ? int(this._infoPlayer.pets.length / 5 - 1) : int(this._infoPlayer.pets.length / 5);
         this._currentPage = this._currentPage - 1 < 0 ? 0 : this._currentPage - 1;
         this.upCells(this._currentPage);
      }
      
      private function __right(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._totlePage = this._infoPlayer.pets.length % 5 == 0 ? int(this._infoPlayer.pets.length / 5 - 1) : int(this._infoPlayer.pets.length / 5);
         this._currentPage = this._currentPage + 1 > this._totlePage ? this._totlePage : this._currentPage + 1;
         this.upCells(this._currentPage);
      }
      
      private function upCells(page:int = 0) : void
      {
         this._currentPage = page;
         var start:int = page * 5;
         for(var i:int = 0; i < 5; i++)
         {
            if(Boolean(this._infoPlayer.pets[i + start]))
            {
               this._petsImgVec[i].info = this._infoPlayer.pets[i + start];
            }
            else
            {
               this._petsImgVec[i].info = null;
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this.currentPet))
         {
            ObjectUtils.disposeObject(this.currentPet);
            this.currentPet = null;
         }
         if(Boolean(this._leftBtn))
         {
            ObjectUtils.disposeObject(this._leftBtn);
            this._leftBtn = null;
         }
         if(Boolean(this._rightBtn))
         {
            ObjectUtils.disposeObject(this._rightBtn);
            this._rightBtn = null;
         }
         if(Boolean(this._petBg))
         {
            ObjectUtils.disposeObject(this._petBg);
            this._petBg = null;
         }
         if(Boolean(this._petBg2))
         {
            ObjectUtils.disposeObject(this._petBg2);
            this._petBg2 = null;
         }
         if(Boolean(this._petBg0))
         {
            ObjectUtils.disposeObject(this._petBg0);
            this._petBg0 = null;
         }
         this._infoPlayer = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

