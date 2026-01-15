package farm.viewx
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.*;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import farm.view.compose.event.SelectComposeItemEvent;
   import flash.display.Sprite;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import trainer.data.ArrowType;
   
   public class FarmFieldsView extends Sprite implements Disposeable
   {
      
      private var _fields:Vector.<FarmFieldBlock>;
      
      private var _configmPnl:ConfirmKillCropAlertFrame;
      
      public function FarmFieldsView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         FarmModelController.instance.addEventListener(FarmEvent.FIELDS_INFO_READY,this.__fieldInfoReady);
         FarmModelController.instance.addEventListener(FarmEvent.HAS_SEEDING,this.__hasSeeding);
         FarmModelController.instance.addEventListener(FarmEvent.FRUSH_FIELD,this.__frushField);
         FarmModelController.instance.addEventListener(FarmEvent.GAIN_FIELD,this.__gainField);
         FarmModelController.instance.addEventListener(FarmEvent.ACCELERATE_FIELD,this.__accelerateField);
         FarmModelController.instance.addEventListener(FarmEvent.HELPER_SWITCH_FIELD,this.__helperSwitchHandler);
         FarmModelController.instance.addEventListener(FarmEvent.HELPER_KEY_FIELD,this.__helperKeyHandler);
         FarmModelController.instance.addEventListener(FarmEvent.KILLCROP_FIELD,this.__onKillcropField);
         FarmModelController.instance.addEventListener(FarmEvent.BEGIN_HELPER,this.__setFields);
         FarmModelController.instance.addEventListener(FarmEvent.STOP_HELPER,this.__frushField);
      }
      
      private function remvoeEvent() : void
      {
         FarmModelController.instance.removeEventListener(FarmEvent.FIELDS_INFO_READY,this.__fieldInfoReady);
         FarmModelController.instance.removeEventListener(FarmEvent.HAS_SEEDING,this.__hasSeeding);
         FarmModelController.instance.removeEventListener(FarmEvent.FRUSH_FIELD,this.__frushField);
         FarmModelController.instance.removeEventListener(FarmEvent.GAIN_FIELD,this.__gainField);
         FarmModelController.instance.removeEventListener(FarmEvent.ACCELERATE_FIELD,this.__accelerateField);
         FarmModelController.instance.removeEventListener(FarmEvent.HELPER_SWITCH_FIELD,this.__helperSwitchHandler);
         FarmModelController.instance.removeEventListener(FarmEvent.HELPER_KEY_FIELD,this.__helperKeyHandler);
         FarmModelController.instance.removeEventListener(FarmEvent.KILLCROP_FIELD,this.__onKillcropField);
         FarmModelController.instance.removeEventListener(FarmEvent.BEGIN_HELPER,this.__setFields);
         FarmModelController.instance.removeEventListener(FarmEvent.STOP_HELPER,this.__frushField);
      }
      
      private function initView() : void
      {
         var field:FarmFieldBlock = null;
         this._fields = new Vector.<FarmFieldBlock>(16);
         for(var i:int = 0; i < 16; i++)
         {
            field = new FarmFieldBlock(i);
            PositionUtils.setPos(field,"farm.fieldsView.fieldPos" + i);
            field.addEventListener(SelectComposeItemEvent.KILLCROP_SHOW,this.__showComfigKillCrop);
            addChild(field);
            this._fields[i] = field;
         }
         this.__fieldInfoReady(null);
      }
      
      private function __setFields(event:FarmEvent) : void
      {
         this.setFieldByHelper();
      }
      
      public function setFieldByHelper() : void
      {
         var nowDate:int = 0;
         if(PlayerManager.Instance.Self.ID != FarmModelController.instance.model.currentFarmerId)
         {
            return;
         }
         if(!PlayerManager.Instance.Self.isFarmHelper)
         {
            return;
         }
         var fieldsInfo:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         for(var m:int = 0; m < FarmModelController.instance.model.fieldsInfo.length; m++)
         {
            nowDate = (new Date().getTime() - fieldsInfo[m].payTime.getTime()) / (1000 * 60 * 60);
            if(fieldsInfo[m].fieldValidDate > nowDate || fieldsInfo[m].fieldValidDate == -1)
            {
               this._fields[m].setBeginHelper(FarmModelController.instance.model.helperArray[1]);
            }
         }
      }
      
      protected function __fieldInfoReady(event:FarmEvent) : void
      {
         this.upFields();
         this.upFlagPlace();
         this.setFieldByHelper();
      }
      
      private function __hasSeeding(event:FarmEvent) : void
      {
         for(var i:int = 0; i < 16; i++)
         {
            if(this._fields[i].info.fieldID == FarmModelController.instance.model.seedingFieldInfo.fieldID)
            {
               this._fields[i].info = FarmModelController.instance.model.seedingFieldInfo;
               if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK4))
               {
                  PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.SEEDING);
               }
               break;
            }
         }
         this.autoHelperHandler(FarmModelController.instance.model.seedingFieldInfo);
      }
      
      private function __frushField(event:FarmEvent) : void
      {
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            this.upFields();
            this.upFlagPlace();
            this.setFieldByHelper();
         }
      }
      
      private function __gainField(event:FarmEvent) : void
      {
         var field:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.gainFieldId);
         for(var i:int = 0; i < 16; i++)
         {
            if(this._fields[i].info.fieldID == FarmModelController.instance.model.gainFieldId)
            {
               this._fields[i].info = field;
               this.upFlagPlace();
               break;
            }
         }
         if(field.isAutomatic)
         {
            this.autoHelperHandler(field);
         }
      }
      
      private function __accelerateField(event:FarmEvent) : void
      {
         var field:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.matureId);
         for(var i:int = 0; i < 16; i++)
         {
            if(this._fields[i].info.fieldID == FarmModelController.instance.model.matureId)
            {
               this._fields[i].info = field;
               break;
            }
         }
         this.autoHelperHandler(field);
      }
      
      private function __helperSwitchHandler(event:FarmEvent) : void
      {
         for(var i:int = 0; i < 16; i++)
         {
            if(this._fields[i].info.fieldID == FarmModelController.instance.model.isAutoId)
            {
               this._fields[i].info = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.isAutoId);
               return;
            }
         }
      }
      
      private function __helperKeyHandler(event:FarmEvent) : void
      {
         var fieldId:int = 0;
         var arr:Array = FarmModelController.instance.model.batchFieldIDArray;
         for each(fieldId in arr)
         {
            this._fields[fieldId].info = FarmModelController.instance.model.getfieldInfoById(fieldId);
         }
      }
      
      private function __onKillcropField(event:FarmEvent) : void
      {
         var field:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.killCropId);
         for(var i:int = 0; i < 16; i++)
         {
            if(this._fields[i].info.fieldID == FarmModelController.instance.model.killCropId)
            {
               this._fields[i].info = field;
               return;
            }
         }
      }
      
      private function upFields() : void
      {
         var id:int = 0;
         var placeArr:Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
         var fieldsInfo:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         for(var i:int = 0; i < fieldsInfo.length; i++)
         {
            id = fieldsInfo[i].fieldID;
            if(Boolean(this._fields[id]))
            {
               this._fields[id].info = fieldsInfo[i];
               this.autoHelperHandler(this._fields[id].info);
               placeArr.splice(placeArr.indexOf(id),1);
            }
         }
         for(var n:int = 0; n < placeArr.length; n++)
         {
            this._fields[placeArr[n]].info = null;
         }
      }
      
      private function upFlagPlace() : void
      {
         var fieldsInfo:Vector.<FieldVO> = null;
         var i:int = 0;
         var n:int = 0;
         var j:int = 0;
         var placeArr:Array = [8,9,10,11,12,13,14,15];
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            fieldsInfo = FarmModelController.instance.model.fieldsInfo;
            for(i = 0; i < fieldsInfo.length; i++)
            {
               if(fieldsInfo[i].fieldID >= 8 && (fieldsInfo[i].isDig || fieldsInfo[i].seedID != 0))
               {
                  placeArr.splice(placeArr.indexOf(fieldsInfo[i].fieldID),1);
                  this._fields[fieldsInfo[i].fieldID].flag = false;
               }
            }
            for(n = 0; n < placeArr.length; n++)
            {
               if(n == 0)
               {
                  this._fields[placeArr[n]].flag = true;
               }
               else
               {
                  this._fields[placeArr[n]].flag = false;
               }
            }
         }
         else
         {
            for(j = 0; j < placeArr.length; j++)
            {
               this._fields[placeArr[j]].flag = false;
            }
         }
      }
      
      private function __showComfigKillCrop(e:SelectComposeItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var field:FieldVO = e.data as FieldVO;
         this._configmPnl = ComponentFactory.Instance.creatComponentByStylename("farm.confirmKillCropAlertFrame");
         this._configmPnl.cropName(ItemManager.Instance.getTemplateById(field.seedID).Name,field.isAutomatic);
         this._configmPnl.fieldId = field.fieldID;
         this._configmPnl.addEventListener(SelectComposeItemEvent.KILLCROP_CLICK,this.__killCropClick);
         LayerManager.Instance.addToLayer(this._configmPnl,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __killCropClick(e:SelectComposeItemEvent) : void
      {
         var fieldID:int = e.data as int;
         if(fieldID != -1)
         {
            FarmModelController.instance.killCrop(fieldID);
         }
         if(Boolean(this._configmPnl))
         {
            this._configmPnl.removeEventListener(SelectComposeItemEvent.KILLCROP_CLICK,this.__killCropClick);
         }
         this.dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.KILLCROP_ICON));
      }
      
      public function autoHelperHandler(_info:FieldVO) : void
      {
         var seedInfo:InventoryItemInfo = null;
         var type:int = 0;
         var fertilizerInfo:InventoryItemInfo = null;
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID && _info && _info.isAutomatic)
         {
            if(_info.seedID == 0 && _info.isDig && _info.autoSeedID != 0)
            {
               seedInfo = FarmModelController.instance.model.findItemInfo(EquipType.SEED,_info.autoSeedID);
               if(Boolean(seedInfo))
               {
                  if(seedInfo.CategoryID == EquipType.SEED && seedInfo.Count > 0)
                  {
                     if(seedInfo.Count == 1)
                     {
                        return;
                     }
                  }
               }
            }
            if(_info.seedID != 0 && _info.autoFertilizerID != 0 && _info.AccelerateTime == 0)
            {
               type = 1;
               fertilizerInfo = FarmModelController.instance.model.findItemInfo(EquipType.MANURE,_info.autoFertilizerID);
               if(Boolean(fertilizerInfo))
               {
                  if(fertilizerInfo.CategoryID == EquipType.MANURE && fertilizerInfo.Count > 0)
                  {
                     FarmModelController.instance.accelerateField(type,_info.fieldID,_info.autoFertilizerID);
                     if(fertilizerInfo.Count == 1)
                     {
                        return;
                     }
                  }
               }
            }
            if(_info.plantGrownPhase == 2)
            {
               FarmModelController.instance.getHarvest(_info.fieldID);
            }
         }
      }
      
      public function dispose() : void
      {
         for(var i:int = 0; i < 16; i++)
         {
            if(Boolean(this._fields[i]))
            {
               this._fields[i].removeEventListener(SelectComposeItemEvent.KILLCROP_SHOW,this.__showComfigKillCrop);
               ObjectUtils.disposeObject(this._fields[i]);
               this._fields[i] = null;
            }
         }
         this.remvoeEvent();
         this._fields = null;
         if(Boolean(this._configmPnl))
         {
            ObjectUtils.disposeObject(this._configmPnl);
         }
         this._configmPnl = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get fields() : Vector.<FarmFieldBlock>
      {
         return this._fields;
      }
   }
}

