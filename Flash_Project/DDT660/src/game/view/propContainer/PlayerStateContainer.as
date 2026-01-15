package game.view.propContainer
{
   import bagAndInfo.bag.ItemCellView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.events.LivingEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import game.model.TurnedLiving;
   import horse.HorseManager;
   import horse.data.HorseSkillVo;
   import pet.date.PetSkillTemplateInfo;
   
   public class PlayerStateContainer extends SimpleTileList
   {
      
      private var _info:TurnedLiving;
      
      public function PlayerStateContainer(column:Number = 10)
      {
         super(column);
         hSpace = 6;
         vSpace = 4;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function get info() : TurnedLiving
      {
         return this._info;
      }
      
      public function set info(value:TurnedLiving) : void
      {
         if(this._info == value)
         {
            return;
         }
         if(Boolean(this._info))
         {
            this._info.removeEventListener(LivingEvent.ADD_STATE,this.__addingState);
            this._info.removeEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
            this._info.removeEventListener(LivingEvent.HORSE_SKILL_USE,this.__useSkillHandler);
         }
         this._info = value;
         if(Boolean(this._info))
         {
            this._info.addEventListener(LivingEvent.ADD_STATE,this.__addingState);
            this._info.addEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
            this._info.addEventListener(LivingEvent.HORSE_SKILL_USE,this.__useSkillHandler);
         }
      }
      
      private function __addingState(event:LivingEvent) : void
      {
         var temp:InventoryItemInfo = null;
         var dis:DisplayObject = null;
         var special:Bitmap = null;
         if(visible == false)
         {
            visible = true;
         }
         if(!this._info.isLiving)
         {
            visible = false;
            return;
         }
         if(event.value > 0)
         {
            temp = new InventoryItemInfo();
            temp.TemplateID = event.value;
            ItemManager.fill(temp);
            if(temp.CategoryID != EquipType.OFFHAND && temp.CategoryID != EquipType.TEMP_OFFHAND)
            {
               addChild(new ItemCellView(0,PropItemView.createView(temp.Pic,40,40)));
            }
            else
            {
               dis = PlayerManager.Instance.getDeputyWeaponIconByBg(temp,1);
               addChild(new ItemCellView(0,dis));
            }
         }
         else if(event.value == -1)
         {
            special = ComponentFactory.Instance.creatBitmap("game.crazyTank.view.specialKillAsset");
            special.width = 40;
            special.height = 40;
            addChild(new ItemCellView(0,special));
         }
         else if(event.value == -2)
         {
            addChild(new ItemCellView(0,PropItemView.createView(event.paras[0],40,40)));
         }
         else if(event.value == 0)
         {
            addChild(new ItemCellView(0,PropItemView.createView("wish",40,40)));
         }
      }
      
      protected function __useSkillHandler(event:LivingEvent) : void
      {
         var horseSkillVo:HorseSkillVo = HorseManager.instance.getHorseSkillInfoById(event.paras[0]);
         if(Boolean(horseSkillVo) && horseSkillVo.Pic != "-1")
         {
            addChild(new ItemCellView(0,PropItemView.createView(horseSkillVo.Pic,40,40)));
         }
      }
      
      private function __usePetSkill(event:LivingEvent) : void
      {
         visible = true;
         if(!this._info.isLiving)
         {
            visible = false;
            return;
         }
         var skill:PetSkillTemplateInfo = PetSkillManager.getSkillByID(event.value);
         if(Boolean(skill) && skill.isActiveSkill)
         {
            addChild(new ItemCellView(0,new BitmapLoaderProxy(PathManager.solveSkillPicUrl(skill.Pic),new Rectangle(0,0,40,40))));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

