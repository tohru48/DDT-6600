package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PetExperience;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   
   public class PetFoodNumberSelectFrame extends BaseAlerFrame
   {
      
      private var _foodInfo:InventoryItemInfo;
      
      private var _alertInfo:AlertInfo;
      
      private var _petInfo:PetInfo;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _text:FilterFrameText;
      
      private var _needFoodText:FilterFrameText;
      
      private var maxFood:int = 0;
      
      private var neededFoodAmount:int;
      
      public function PetFoodNumberSelectFrame()
      {
         super();
         this.initView();
      }
      
      public function set petInfo(val:PetInfo) : void
      {
         this._petInfo = val;
      }
      
      public function set foodInfo(val:InventoryItemInfo) : void
      {
         this._foodInfo = val;
      }
      
      public function get foodInfo() : InventoryItemInfo
      {
         return this._foodInfo;
      }
      
      public function get amount() : int
      {
         return this._numberSelecter.currentValue;
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.pets.foodAmountSelect"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._text = ComponentFactory.Instance.creatComponentByStylename("petsBag.PetFoodNumberSelectFrame.Text");
         this._text.text = LanguageMgr.GetTranslation("ddt.pets.foodAmountTipText");
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         this._numberSelecter.addEventListener(Event.CHANGE,this.__seleterChange);
         PositionUtils.setPos(this._numberSelecter,"petsBag.PetFoodNumberSelectFrame.numberSelecterPos");
         this._needFoodText = ComponentFactory.Instance.creatComponentByStylename("petsBag.PetFoodNumberSelectFrame.NeedFoodText");
         PositionUtils.setPos(this._needFoodText,"petsBag.PetFoodNumberSelectFrame.needFoodTextPos");
         this._needFoodText.visible = false;
         addToContent(this._text);
         addToContent(this._numberSelecter);
         addToContent(this._needFoodText);
      }
      
      private function __seleterChange(event:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function show(max:int, min:int = 1) : void
      {
         var limitNum:int = 0;
         var level:int = 0;
         var upgradeNeeded:int = 0;
         var addHunger:int = 0;
         var currentPet:PetInfo = null;
         var petLevel:int = 0;
         var playerLevel:int = 0;
         if(this._foodInfo.Count >= max)
         {
            limitNum = max;
         }
         else
         {
            limitNum = this._foodInfo.Count;
         }
         this._numberSelecter.valueLimit = min + "," + limitNum;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         if(Boolean(this._petInfo))
         {
            level = PetExperience.getLevelByGP(this._petInfo.GP);
            upgradeNeeded = PetExperience.expericence[level] - this._petInfo.GP;
            this.neededFoodAmount = int(Math.ceil(upgradeNeeded / Number(this._foodInfo.Property2)));
            addHunger = int(this._foodInfo.Property1);
            currentPet = PetBagController.instance().petModel.currentPetInfo;
            petLevel = currentPet.Level;
            playerLevel = PlayerManager.Instance.Self.Grade;
            if(petLevel == playerLevel || petLevel == 60)
            {
               this._needFoodText.htmlText = LanguageMgr.GetTranslation("ddt.pets.hungerNeedFoodAmount",max);
               this._needFoodText.visible = true;
               if(this._foodInfo.Count >= max)
               {
                  this._numberSelecter.currentValue = max;
               }
               else
               {
                  this._numberSelecter.currentValue = this._foodInfo.Count;
               }
               this._numberSelecter.validate();
            }
            else
            {
               this._needFoodText.htmlText = LanguageMgr.GetTranslation("ddt.pets.upgradeNeedFoodAmount",this.neededFoodAmount);
               this._needFoodText.visible = true;
               this._numberSelecter.currentValue = this.neededFoodAmount;
               this._numberSelecter.validate();
            }
         }
      }
      
      private function needMaxFood(hunger:int, addHunger:int) : int
      {
         var maxFood:int = 0;
         var limitHunger:int = PetconfigAnalyzer.PetCofnig.MaxHunger - hunger;
         return int(Math.ceil(limitHunger / Number(addHunger)));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._numberSelecter.removeEventListener(Event.CHANGE,this.__seleterChange);
         this.removeView();
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._numberSelecter);
         this._numberSelecter = null;
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         ObjectUtils.disposeObject(this._needFoodText);
         this._needFoodText = null;
      }
   }
}

