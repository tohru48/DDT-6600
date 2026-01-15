package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   import pet.date.PetSkill;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.controller.PetBagController;
   import petsBag.event.PetItemEvent;
   import petsBag.view.item.SkillItem;
   import trainer.data.ArrowType;
   
   public class PetSkillPnl extends Sprite implements Disposeable
   {
      
      private var _petSkill:SimpleTileList;
      
      private var _petSkillScroll:ScrollPanel;
      
      private var _isWatch:Boolean = false;
      
      private var _itemInfoVec:Array;
      
      private var _itemViewVec:Vector.<SkillItem>;
      
      public function PetSkillPnl(isWatch:Boolean)
      {
         this._isWatch = isWatch;
         super();
         this._itemInfoVec = [];
         this._itemViewVec = new Vector.<SkillItem>();
         this.creatView();
      }
      
      private function creatView() : void
      {
         if(!this._isWatch)
         {
            this._petSkillScroll = ComponentFactory.Instance.creatComponentByStylename("petsBag.scrollPanel.petSkillPnl");
            addChild(this._petSkillScroll);
            this._petSkill = ComponentFactory.Instance.creatCustomObject("petsBag.simpleTileList.petSkill",[4]);
            this._petSkillScroll.setView(this._petSkill);
         }
         else
         {
            this._petSkillScroll = ComponentFactory.Instance.creatComponentByStylename("petsBag.scrollPanel.petSkillPnlWatch");
            addChild(this._petSkillScroll);
            this._petSkill = ComponentFactory.Instance.creatCustomObject("petsBag.simpleTileList.petSkill",[7]);
            this._petSkillScroll.setView(this._petSkill);
         }
      }
      
      public function set itemInfo(petSkillAll:Array) : void
      {
         this._itemInfoVec = petSkillAll;
         this._itemInfoVec.sortOn("ID",Array.NUMERIC);
         this.update();
      }
      
      public function update() : void
      {
         this.removeItems();
         this.creatItems();
      }
      
      protected function creatItems() : void
      {
         var cell:SkillItem = null;
         var itemInfo:PetSkillTemplateInfo = null;
         var i:int = 0;
         var count:int = 8;
         for each(itemInfo in this._itemInfoVec)
         {
            if(Boolean(itemInfo))
            {
               cell = new SkillItem(itemInfo,i++,true,this._isWatch);
               cell.DoubleClickEnabled = true;
               cell.iconPos = new Point(2.5,2.5);
               this._petSkill.addChild(cell);
               this._itemViewVec.push(cell);
            }
         }
         count = this._isWatch ? 14 : 8;
         while(i < count)
         {
            cell = new SkillItem(null,i++,true,this._isWatch);
            cell.iconPos = new Point(3,3);
            cell.mouseChildren = false;
            cell.mouseEnabled = false;
            this._petSkill.addChild(cell);
            this._itemViewVec.push(cell);
         }
         if(!this._isWatch)
         {
            this.initEvent();
         }
      }
      
      public function set scrollVisble(value:Boolean) : void
      {
         this._petSkillScroll.vScrollbar.visible = value;
      }
      
      private function removeItems() : void
      {
         var item:SkillItem = null;
         this.removeEvent();
         for each(item in this._itemViewVec)
         {
            if(Boolean(item))
            {
               ObjectUtils.disposeObject(item);
               item = null;
            }
         }
         this._itemViewVec.splice(0,this._itemViewVec.length);
      }
      
      private function initEvent() : void
      {
         for(var index:int = 0; index < this._itemViewVec.length; index++)
         {
            this._itemViewVec[index].addEventListener(PetItemEvent.ITEM_CLICK,this.__skillItemClick);
         }
      }
      
      private function removeEvent() : void
      {
         for(var index:int = 0; index < this._itemViewVec.length; index++)
         {
            this._itemViewVec[index].removeEventListener(PetItemEvent.ITEM_CLICK,this.__skillItemClick);
         }
      }
      
      private function __skillItemClick(e:PetItemEvent) : void
      {
         if(this._isWatch)
         {
            return;
         }
         var currentSkillInfo:PetSkill = (e.data as SkillItem).info as PetSkill;
         if(Boolean(currentSkillInfo) && Boolean(PetBagController.instance().petModel.currentPetInfo))
         {
            SocketManager.Instance.out.sendEquipPetSkill(PetBagController.instance().petModel.currentPetInfo.Place,currentSkillInfo.ID,PetBagController.instance().getEquipdSkillIndex());
            if(PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.CHOOSE_PET_SKILL] > 0)
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CHOOSE_PET_SKILL);
               PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.CHOOSE_PET_SKILL] = 0;
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeItems();
         ObjectUtils.disposeObject(this._petSkill);
         this._petSkill = null;
         ObjectUtils.disposeObject(this._petSkillScroll);
         this._petSkillScroll = null;
         this._itemInfoVec = null;
         this._itemViewVec = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

