package farm.viewx
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.PNGHitAreaFactory;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.modelx.FieldVO;
   import farm.view.compose.event.SelectComposeItemEvent;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import trainer.data.ArrowType;
   
   public class FarmFieldBlock extends Sprite implements Disposeable, IAcceptDrag
   {
      
      private var _fieldId:int;
      
      private var _info:FieldVO;
      
      private var _picPath:String;
      
      private var _field:ScaleFrameImage;
      
      private var _flag:SimpleBitmapButton;
      
      private var _hitArea:Sprite;
      
      private var _loadingasset:MovieClip;
      
      private var _loader:DisplayLoader;
      
      private var _type:int = -1;
      
      private var _plant:BaseButton;
      
      private var _countdown:CountdownView;
      
      public function FarmFieldBlock(id:int)
      {
         super();
         this._fieldId = id;
         this.initView();
         this.initEvent();
      }
      
      public function set flag(value:Boolean) : void
      {
         if(value)
         {
            if(this._flag == null)
            {
               this._flag = ComponentFactory.Instance.creatComponentByStylename("farm.flag");
               this._flag.addEventListener(MouseEvent.CLICK,this.__flagClickHandler);
               addChild(this._flag);
            }
         }
         else
         {
            if(Boolean(this._flag))
            {
               ObjectUtils.disposeObject(this._flag);
            }
            this._flag = null;
         }
      }
      
      public function get info() : FieldVO
      {
         return this._info;
      }
      
      public function set info(info:FieldVO) : void
      {
         if(this._info != info)
         {
            this._type = -1;
         }
         this._info = info;
         if(Boolean(this._info))
         {
            if(this._info.isDig)
            {
               this._field.setFrame(1);
               this.addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
               this.addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
               this.addEventListener(MouseEvent.CLICK,this.__onMouseClick);
               if(Boolean(this._flag))
               {
                  ObjectUtils.disposeObject(this._flag);
               }
               this._flag = null;
            }
            else
            {
               this._field.setFrame(2);
            }
            if(this._info.seedID != 0)
            {
               this.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
               this._picPath = ItemManager.Instance.getTemplateById(this._info.seedID).Pic;
               this.loadIcon(this._info.plantGrownPhase);
               this.upTips();
            }
            else
            {
               this._type = -1;
               if(Boolean(this._plant))
               {
                  this._plant.visible = false;
               }
            }
         }
         else
         {
            this._type = -1;
            this._field.setFrame(2);
            if(Boolean(this._flag))
            {
               ObjectUtils.disposeObject(this._flag);
            }
            this._flag = null;
            this._plant.visible = false;
         }
      }
      
      protected function __onMouseClick(event:MouseEvent) : void
      {
         this.dispatchEvent(new FarmEvent(FarmEvent.FIELDBLOCK_CLICK));
      }
      
      private function upTips() : void
      {
         var name:String = null;
         var str:String = null;
         if(Boolean(this._info) && this._info.seedID != 0)
         {
            name = ItemManager.Instance.getTemplateById(this.info.seedID).Name;
            str = "";
            if(this._info.plantGrownPhase == 2)
            {
               str = LanguageMgr.GetTranslation("ddt.farm.goods.grown",this._info.gainCount,ItemManager.Instance.getTemplateById(this._info.seedID).Property2);
            }
            else if(this._info.realNeedTime > 0)
            {
               if(this._info.realNeedTime / 60 == 0)
               {
                  str = LanguageMgr.GetTranslation("ddt.farm.goods.mini",this._info.realNeedTime % 60);
               }
               else
               {
                  str = LanguageMgr.GetTranslation("ddt.farm.goods.houer",int(this._info.realNeedTime / 60),this._info.realNeedTime % 60);
               }
               this._countdown.setCountdown(this._info.fieldID);
            }
            else
            {
               str = LanguageMgr.GetTranslation("ddt.farm.goods.houer",0,0);
            }
            if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID && this._info.realNeedTime > 0)
            {
               this._countdown.setFastBtnEnable(true);
            }
            else
            {
               this._countdown.setFastBtnEnable(false);
            }
            this._plant.tipData = LanguageMgr.GetTranslation("ddt.farm.goods.name",name,str);
         }
      }
      
      private function initEvent() : void
      {
      }
      
      public function setBeginHelper(seedID:int) : void
      {
         this._picPath = ItemManager.Instance.getTemplateById(seedID).Pic;
         this.loadIcon(0);
         this._plant.tipData = LanguageMgr.GetTranslation("ddt.farms.fieldBlockSeedTips");
      }
      
      private function __onMouseOver(evt:MouseEvent) : void
      {
         if(Boolean(this._info))
         {
            filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
      }
      
      private function __onMouseOut(evt:MouseEvent) : void
      {
         filters = [];
      }
      
      private function initView() : void
      {
         this._field = ComponentFactory.Instance.creatComponentByStylename("farm.fieldbg");
         addChild(this._field);
         this._hitArea = PNGHitAreaFactory.drawHitArea(DisplayUtils.getDisplayBitmapData(this._field));
         hitArea = this._hitArea;
         this._hitArea.alpha = 0;
         addChild(this._hitArea);
         this._plant = ComponentFactory.Instance.creatComponentByStylename("farm.plant");
         addChild(this._plant);
         this._plant.visible = false;
         this._plant.addEventListener(MouseEvent.CLICK,this.__plantClickHandler);
         FarmModelController.instance.addEventListener(FarmEvent.FRUSH_FIELD,this.__frush);
         FarmModelController.instance.addEventListener(FarmEvent.ACCELERATE_FIELD,this.__accelerate);
         this._countdown = new CountdownView();
         PositionUtils.setPos(this._countdown,"assets.farm.countdownPos");
         addChild(this._countdown);
         this._countdown.visible = false;
      }
      
      protected function __accelerate(event:Event) : void
      {
         if(FarmModelController.instance.model.matureId == this._fieldId)
         {
            this.upTips();
         }
      }
      
      protected function __frush(event:Event) : void
      {
         this.upTips();
      }
      
      private function __plantClickHandler(event:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.isFarmHelper && PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
         {
            return;
         }
         if(this._info.plantGrownPhase == 2)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            FarmModelController.instance.getHarvest(this._info.fieldID);
            this.petFarmGuilde();
            FarmModelController.instance.updateFriendListStolen();
         }
         else
         {
            event.stopImmediatePropagation();
            this._countdown.visible = true;
            stage.addEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      protected function __onClick(event:MouseEvent) : void
      {
         if(Boolean(this._countdown))
         {
            SoundManager.instance.play("008");
            this._countdown.visible = false;
            stage.removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      private function petFarmGuilde() : void
      {
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK5))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.GAINS);
         }
      }
      
      private function loadIcon(type:int) : void
      {
         if(this._type == type)
         {
            return;
         }
         this._type = type;
         this._loadingasset = ComponentFactory.Instance.creat("bagAndInfo.cell.BaseCellLoadingAsset");
         PositionUtils.setPos(this._loadingasset,"farm.farmFieldBlock.pos");
         addChild(this._loadingasset);
         if(Boolean(this._loader))
         {
            this._loader = null;
         }
         if(Boolean(this._plant))
         {
            ObjectUtils.disposeObject(this._plant);
            this._plant = null;
         }
         if(!this._plant)
         {
            this._plant = ComponentFactory.Instance.creatComponentByStylename("farm.plant");
            addChildAt(this._plant,this.numChildren - 2);
            this._plant.addEventListener(MouseEvent.CLICK,this.__plantClickHandler);
         }
         this._loader = LoadResourceManager.Instance.createLoader(PathManager.solveFieldPlantPath(this._picPath,type),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         LoadResourceManager.Instance.startLoad(this._loader);
      }
      
      private function __complete(event:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         if(this._loader.isSuccess)
         {
            this._plant.backgound = this._loader.content as Bitmap;
            this._plant.visible = true;
            if(Boolean(this._loadingasset))
            {
               ObjectUtils.disposeObject(this._loadingasset);
            }
            this._loadingasset = null;
         }
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         var seedInfo:InventoryItemInfo = null;
         var type:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(effect.source is FarmKillCropCell)
         {
            if(Boolean(this._info) && this._info.seedID != 0)
            {
               dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.KILLCROP_SHOW,this._info));
            }
            else
            {
               DragManager.acceptDrag(this);
            }
         }
         else
         {
            seedInfo = effect.data as InventoryItemInfo;
            if(Boolean(seedInfo))
            {
               if(this._info && this._info.seedID == 0 && this._info.isDig && seedInfo.CategoryID == EquipType.SEED && seedInfo.Count > 0)
               {
                  FarmModelController.instance.sowSeed(this._fieldId,seedInfo.TemplateID);
                  if(seedInfo.Count == 1)
                  {
                     return;
                  }
               }
               else if(this._info && this._info.seedID != 0 && seedInfo.CategoryID == EquipType.MANURE && seedInfo.Count > 0)
               {
                  type = 0;
                  FarmModelController.instance.accelerateField(type,this._fieldId,seedInfo.TemplateID);
                  if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK4))
                  {
                     PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.USE_FERTILLZER);
                  }
                  if(seedInfo.Count == 1)
                  {
                     return;
                  }
               }
               DragManager.acceptDrag(this);
            }
         }
      }
      
      private function __flagClickHandler(event:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.isFarmHelper)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farms.fieldBlockSeedTips"));
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         FarmModelController.instance.openPayFieldFrame(this._fieldId);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._info) && this._info.isDig)
         {
            this.removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         }
         if(Boolean(this._info) && this._info.isDig)
         {
            this.removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         }
         if(Boolean(this._info) && this._info.isDig)
         {
            this.removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         }
         this._info = null;
         this._loader = null;
         FarmModelController.instance.removeEventListener(FarmEvent.FRUSH_FIELD,this.__frush);
         FarmModelController.instance.removeEventListener(FarmEvent.ACCELERATE_FIELD,this.__accelerate);
         if(Boolean(this._flag))
         {
            this._flag.removeEventListener(MouseEvent.CLICK,this.__flagClickHandler);
         }
         this._plant.removeEventListener(MouseEvent.CLICK,this.__plantClickHandler);
         if(Boolean(this._plant))
         {
            ObjectUtils.disposeObject(this._plant);
         }
         this._plant = null;
         if(Boolean(this._field))
         {
            ObjectUtils.disposeObject(this._field);
         }
         this._field = null;
         if(Boolean(this._flag))
         {
            ObjectUtils.disposeObject(this._flag);
         }
         this._flag = null;
         if(Boolean(this._hitArea))
         {
            ObjectUtils.disposeObject(this._hitArea);
         }
         this._hitArea = null;
         if(Boolean(this._loadingasset))
         {
            ObjectUtils.disposeObject(this._loadingasset);
         }
         this._loadingasset = null;
         if(Boolean(this._countdown))
         {
            this._countdown.dispose();
            this._countdown = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

