package farm.viewx
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import shop.manager.ShopBuyManager;
   import trainer.data.ArrowType;
   
   public class ManureOrSeedSelectedView extends Sprite implements Disposeable
   {
      
      public static const SEED:int = 1;
      
      public static const MANURE:int = 2;
      
      public static const manureIdArr:Array = [333101,333102,333103,333104];
      
      private var manureVec:Array;
      
      private var _manureSelectViewBg:ScaleBitmapImage;
      
      private var _title:ScaleFrameImage;
      
      private var _preBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _hBox:HBox;
      
      private var _cells:Vector.<FarmCell>;
      
      private var _type:int;
      
      private var _cellInfos:Array;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      private var _currentCell:FarmCell;
      
      private var _currentImg:Bitmap;
      
      public function ManureOrSeedSelectedView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set viewType(value:int) : void
      {
         this._type = value;
         this.cellInfos();
         this.upCells(0);
         visible = true;
         this._title.setFrame(this._type);
         if(this._type == SEED)
         {
            if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK4))
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CLICK_SEEDING_BTN);
               PetBagController.instance().showPetFarmGuildArrow(ArrowType.CHOOSE_SEED,0,"farmTrainer.selectSeedArrowPos","asset.farmTrainer.selectSeed","farmTrainer.selectSeedTipPos",this);
            }
         }
      }
      
      private function initEvent() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__onClose);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         PlayerManager.Instance.Self.getBag(BagInfo.FARM).addEventListener(BagEvent.UPDATE,this.__bagUpdate);
      }
      
      private function removeEvent() : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__onClose);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__onPageBtnClick);
         PlayerManager.Instance.Self.getBag(BagInfo.FARM).removeEventListener(BagEvent.UPDATE,this.__bagUpdate);
      }
      
      private function initView() : void
      {
         var inv:InventoryItemInfo = null;
         this._manureSelectViewBg = ComponentFactory.Instance.creatComponentByStylename("farm.manureselectViewBg");
         this._title = ComponentFactory.Instance.creatComponentByStylename("farm.selectedView.title");
         this._title.setFrame(this._type);
         this._preBtn = ComponentFactory.Instance.creat("farm.btnPrePage1");
         this._nextBtn = ComponentFactory.Instance.creat("farm.btnNextPage1");
         this._closeBtn = ComponentFactory.Instance.creat("farm.seedselectcloseBtn");
         this._hBox = ComponentFactory.Instance.creat("farm.cropBox");
         addChild(this._manureSelectViewBg);
         addChild(this._title);
         addChild(this._preBtn);
         addChild(this._nextBtn);
         addChild(this._closeBtn);
         addChild(this._hBox);
         this._cells = new Vector.<FarmCell>(4);
         for(var i:int = 0; i < 4; i++)
         {
            this._cells[i] = new FarmCell();
            this._cells[i].addEventListener(MouseEvent.CLICK,this.__clickHandler);
            this._hBox.addChild(this._cells[i]);
         }
         this.manureVec = new Array();
         for(var n:int = 0; n < manureIdArr.length; n++)
         {
            inv = new InventoryItemInfo();
            inv.TemplateID = manureIdArr[n];
            ObjectUtils.copyProperties(inv,ItemManager.Instance.getTemplateById(inv.TemplateID));
            this.manureVec.push(inv);
         }
      }
      
      private function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.visible = false;
         this._currentCell = event.currentTarget as FarmCell;
         if(this._currentCell.itemInfo.Count != 0)
         {
            this._currentCell.dragStart();
            if(this._type == SEED)
            {
               if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK4))
               {
                  PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CHOOSE_SEED);
                  PetBagController.instance().showPetFarmGuildArrow(ArrowType.SEEDING,-150,"farmTrainer.seedFieldArrowPos","asset.farmTrainer.seedField","farmTrainer.seedFieldTipPos");
               }
            }
            else if(this._type == MANURE)
            {
               if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK4))
               {
                  PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CHOOSE_FERTILLZER);
                  PetBagController.instance().showPetFarmGuildArrow(ArrowType.USE_FERTILLZER,-150,"farmTrainer.useFertilizerArrowPos","asset.farmTrainer.useFertilizer","farmTrainer.useFertilizerTipPos");
               }
            }
         }
         else
         {
            ShopBuyManager.Instance.buyFarmShop(this._currentCell.itemInfo.TemplateID);
         }
      }
      
      private function __bagUpdate(event:BagEvent) : void
      {
         this.cellInfos();
         this.upCells(this._currentPage);
      }
      
      private function __onClose(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         visible = false;
         PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CHOOSE_SEED);
         PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CHOOSE_FERTILLZER);
      }
      
      private function __onPageBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(e.currentTarget)
         {
            case this._preBtn:
               this._currentPage = this._currentPage - 1 < 0 ? 0 : this._currentPage - 1;
               break;
            case this._nextBtn:
               this._currentPage = this._currentPage + 1 > this._totlePage ? this._totlePage : this._currentPage + 1;
         }
         this.upCells(this._currentPage);
      }
      
      private function cellInfos() : void
      {
         var i:int = 0;
         var n:int = 0;
         var tempInfos:Array = this._type == SEED ? PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.SEED) : PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.MANURE);
         if(this._type == MANURE)
         {
            for(i = 0; i < this.manureVec.length; i++)
            {
               this.manureVec[i].Count = 0;
               for(n = 0; n < tempInfos.length; n++)
               {
                  if(tempInfos[n].TemplateID == this.manureVec[i].TemplateID)
                  {
                     ObjectUtils.copyProperties(this.manureVec[i],tempInfos[n]);
                     break;
                  }
               }
            }
            this._cellInfos = this.manureVec;
         }
         else
         {
            tempInfos.sortOn("TemplateID",Array.NUMERIC);
            this._cellInfos = tempInfos;
         }
         this._totlePage = this._cellInfos.length % 4 == 0 ? int(this._cellInfos.length / 4 - 1) : int(this._cellInfos.length / 4);
      }
      
      private function upCells(page:int = 0) : void
      {
         this._currentPage = page;
         var start:int = page * 4;
         for(var i:int = 0; i < 4; i++)
         {
            if(Boolean(this._cellInfos[i + start]))
            {
               this._cells[i].itemInfo = this._cellInfos[i + start];
               if(this._cells[i].itemInfo.Count > 0)
               {
                  this._cells[i].visible = true;
               }
               else
               {
                  this._cells[i].visible = false;
               }
            }
            else
            {
               this._cells[i].visible = false;
            }
         }
      }
      
      private function compareFun(x:int, y:int) : Number
      {
         if(x < y)
         {
            return 1;
         }
         if(x > y)
         {
            return -1;
         }
         return 0;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         for(var i:int = 0; i < 4; i++)
         {
            if(Boolean(this._cells[i]))
            {
               ObjectUtils.disposeObject(this._cells[i]);
               this._cells[i].removeEventListener(MouseEvent.CLICK,this.__clickHandler);
            }
            this._cells[i] = null;
         }
         this._cells = null;
         if(Boolean(this._manureSelectViewBg))
         {
            ObjectUtils.disposeObject(this._manureSelectViewBg);
         }
         this._manureSelectViewBg = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._preBtn))
         {
            ObjectUtils.disposeObject(this._preBtn);
         }
         this._preBtn = null;
         if(Boolean(this._nextBtn))
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         if(Boolean(this._closeBtn))
         {
            ObjectUtils.disposeObject(this._closeBtn);
         }
         this._closeBtn = null;
         if(Boolean(this._hBox))
         {
            ObjectUtils.disposeObject(this._hBox);
         }
         this._hBox = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

