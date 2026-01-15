package farm.viewx.newPet
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.geom.Point;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.view.item.SkillItem;
   
   public class NewPetSkillPanel extends Sprite implements Disposeable
   {
      
      private var _petSkill:SimpleTileList;
      
      private var _petSkillScroll:ScrollPanel;
      
      private var _itemInfoVec:Array;
      
      private var _itemViewVec:Vector.<PetSkillItem>;
      
      public function NewPetSkillPanel()
      {
         super();
         this._itemInfoVec = [];
         this._itemViewVec = new Vector.<PetSkillItem>();
         this.creatView();
      }
      
      private function creatView() : void
      {
         this._petSkillScroll = ComponentFactory.Instance.creatComponentByStylename("farm.scrollPanel.petSkillPnl");
         addChild(this._petSkillScroll);
         this._petSkill = ComponentFactory.Instance.creatCustomObject("farm.simpleTileList.petSkill",[4]);
         this._petSkillScroll.setView(this._petSkill);
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
         var cell:PetSkillItem = null;
         var itemInfo:PetSkillTemplateInfo = null;
         var i:int = 0;
         var count:int = 8;
         for each(itemInfo in this._itemInfoVec)
         {
            if(Boolean(itemInfo))
            {
               cell = new PetSkillItem(itemInfo,i++);
               cell.DoubleClickEnabled = true;
               cell.iconPos = new Point(2.5,2.5);
               this._petSkill.addChild(cell);
               this._itemViewVec.push(cell);
            }
         }
         count = 8;
         while(i < count)
         {
            cell = new PetSkillItem(null,i++);
            cell.iconPos = new Point(3,3);
            cell.mouseChildren = false;
            cell.mouseEnabled = false;
            this._petSkill.addChild(cell);
            this._itemViewVec.push(cell);
         }
      }
      
      public function set scrollVisble(value:Boolean) : void
      {
         this._petSkillScroll.vScrollbar.visible = value;
      }
      
      private function removeItems() : void
      {
         var item:SkillItem = null;
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
      
      public function dispose() : void
      {
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

