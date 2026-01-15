package petsBag.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.event.PetItemEvent;
   import petsBag.view.item.SkillItem;
   import road7th.data.DictionaryEvent;
   
   public class PetGameSkillPnl extends Sprite implements Disposeable
   {
      
      public static var LvVSLockArray:Array = [20,40,60];
      
      private var _bg:DisplayObject;
      
      private var _items:Vector.<SkillItem>;
      
      private var _pet:PetInfo;
      
      public function PetGameSkillPnl($pet:PetInfo = null)
      {
         super();
         this._items = new Vector.<SkillItem>();
         this.initView();
         this.initEvent();
         this.pet = $pet;
      }
      
      private function initView() : void
      {
         var item:SkillItem = null;
         var point:Point = null;
         this._bg = ComponentFactory.Instance.creat("assets.petsBag.gameSkillPnl");
         addChild(this._bg);
         for(var i:int = 0; i < 5; i++)
         {
            item = new SkillItem(null,i,false);
            point = ComponentFactory.Instance.creatCustomObject("petsBag.gameSkillPnl.point" + i);
            item.x = point.x;
            item.y = point.y;
            addChild(item);
            this._items.push(item);
         }
      }
      
      private function initEvent() : void
      {
         for(var index:int = 0; index < this._items.length; index++)
         {
            this._items[index].addEventListener(MouseEvent.CLICK,this.__skillItemClick);
         }
         PetBagController.instance().petModel.addEventListener(Event.CHANGE,this.__onChange);
      }
      
      private function __onChange(event:Event) : void
      {
         this.pet = PetBagController.instance().petModel.currentPetInfo;
      }
      
      private function removeEvent() : void
      {
         for(var index:int = 0; index < this._items.length; index++)
         {
            this._items[index].removeEventListener(PetItemEvent.ITEM_CLICK,this.__skillItemClick);
         }
         PetBagController.instance().petModel.removeEventListener(Event.CHANGE,this.__onChange);
         if(Boolean(this._pet))
         {
            this._pet.equipdSkills.removeEventListener(DictionaryEvent.UPDATE,this.__onUpdate);
         }
      }
      
      private function __skillItemClick(e:MouseEvent) : void
      {
         var showStr:String = null;
         var currentSkillItem:SkillItem = e.currentTarget as SkillItem;
         if(Boolean(currentSkillItem))
         {
            if(currentSkillItem.skillID == -1)
            {
               if(currentSkillItem.index != 4)
               {
                  showStr = "";
                  switch(currentSkillItem.index)
                  {
                     case 1:
                        showStr = PetconfigAnalyzer.PetCofnig.skillOpenLevel[0];
                        break;
                     case 2:
                        showStr = PetconfigAnalyzer.PetCofnig.skillOpenLevel[1];
                        break;
                     case 3:
                        showStr = PetconfigAnalyzer.PetCofnig.skillOpenLevel[2];
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petsBag.LevAction",showStr));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petsBag.VipAction"));
               }
               return;
            }
            SocketManager.Instance.out.sendEquipPetSkill(PetBagController.instance().petModel.currentPetInfo.Place,0,currentSkillItem.index);
         }
      }
      
      protected function __onAlertResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         switch(evt.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(Boolean(PetBagController.instance().petModel.currentPetInfo))
               {
                  SocketManager.Instance.out.sendPaySkill(PetBagController.instance().petModel.currentPetInfo.Place);
               }
         }
         alert.dispose();
      }
      
      public function set pet(value:PetInfo) : void
      {
         var item:SkillItem = null;
         var i:int = 0;
         this._pet = value;
         for each(item in this._items)
         {
            item.skillID = -1;
         }
         if(Boolean(this._pet))
         {
            for(i = 0; i < this._pet.equipdSkills.length; i++)
            {
               this._items[i].skillID = this._pet.equipdSkills[i];
            }
         }
      }
      
      private function __onUpdate(event:DictionaryEvent) : void
      {
         for(var i:int = 0; i < this._pet.equipdSkills.length; i++)
         {
            this._items[i].skillID = this._pet.equipdSkills[i];
         }
      }
      
      private function lockByIndex(index:int) : void
      {
         if(index < 1 || index > 5)
         {
            return;
         }
         this._items[index - 1].isLock = true;
         if(Boolean(PetBagController.instance().petModel.currentPetInfo) && PetBagController.instance().petModel.currentPetInfo.PaySkillCount > 0)
         {
            this._items[index - 1].isLock = false;
         }
      }
      
      public function get UnLockItemIndex() : int
      {
         var item:SkillItem = null;
         var flag:Boolean = true;
         for each(item in this._items)
         {
            if(!item.isLock && !item.info)
            {
               flag = false;
               return item.index;
            }
         }
         if(flag)
         {
            return 0;
         }
         return 0;
      }
      
      public function dispose() : void
      {
         var item:SkillItem = null;
         this.removeEvent();
         for each(item in this._items)
         {
            if(Boolean(item))
            {
               ObjectUtils.disposeObject(item);
               item = null;
            }
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         this._pet = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

