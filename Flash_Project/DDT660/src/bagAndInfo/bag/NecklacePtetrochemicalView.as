package bagAndInfo.bag
{
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.PersonalInfoCell;
   import bagAndInfo.info.NecklaceLevelProgress;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import store.data.StoreEquipExperience;
   
   public class NecklacePtetrochemicalView extends BaseAlerFrame
   {
      
      private var _bg:Bitmap;
      
      private var _levelText:FilterFrameText;
      
      private var _currentLevel:FilterFrameText;
      
      private var _nextLevel:FilterFrameText;
      
      private var _numText:FilterFrameText;
      
      private var _expText:FilterFrameText;
      
      private var _progress:NecklaceLevelProgress;
      
      private var _stoneCell:PersonalInfoCell;
      
      private var _stoneInfo:InventoryItemInfo;
      
      private var _minNum:int = 1;
      
      private var _maxNum:int = 999;
      
      private var _num:int;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _lastCreatTime:int = 0;
      
      public function NecklacePtetrochemicalView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         SocketManager.Instance.out.necklaceStrength(0,0,1);
         info = new AlertInfo(LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.title"),"","");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.bagAndInfo.bag.NecklacePtetrochemicalView.bg");
         addToContent(this._bg);
         this._levelText = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.NecklacePtetrochemicalView.levelText");
         addToContent(this._levelText);
         this._currentLevel = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.NecklacePtetrochemicalView.currentLevel");
         addToContent(this._currentLevel);
         this._nextLevel = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.NecklacePtetrochemicalView.nextLevel");
         addToContent(this._nextLevel);
         this._numText = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.NecklacePtetrochemicalView.numText");
         this._numText.restrict = "0-9";
         this._numText.maxChars = 5;
         addToContent(this._numText);
         this._expText = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.NecklacePtetrochemicalView.expText");
         addToContent(this._expText);
         this._progress = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.necklaceLevelProgress");
         addToContent(this._progress);
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.NecklacePtetrochemicalView.maxBtn");
         addToContent(this._maxBtn);
         this._progress.setProgress(20,100);
         this._stoneInfo = new InventoryItemInfo();
         this._stoneInfo.TemplateID = EquipType.NECKLACE_PTETROCHEM_STONE;
         this._stoneInfo = ItemManager.fill(this._stoneInfo);
         this._stoneInfo.isShowBind = false;
         this._stoneCell = CellFactory.instance.createPersonalInfoCell(0,this._stoneInfo) as PersonalInfoCell;
         this._stoneCell.setContentSize(55,55);
         this._stoneCell.setCount(0);
         PositionUtils.setPos(this._stoneCell,"bagAndInfo.bag.NecklacePtetrochemicalView.cellPos");
         addToContent(this._stoneCell);
         this._num = 1;
         this._numText.text = "1";
         var Count:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(EquipType.NECKLACE_PTETROCHEM_STONE);
         if(Boolean(this._stoneInfo))
         {
            this._stoneCell.setCount(Count);
         }
         this.initEvent();
         this.updateView();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdate);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateInfo);
         addEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         this._numText.addEventListener(Event.CHANGE,this.__onInput);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.__onMax);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).removeEventListener(BagEvent.UPDATE,this.__onBagUpdate);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateInfo);
         removeEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         this._numText.removeEventListener(Event.CHANGE,this.__onInput);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.__onMax);
      }
      
      protected function __onMax(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var Count:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(EquipType.NECKLACE_PTETROCHEM_STONE);
         if(Boolean(this._stoneInfo))
         {
            this._numText.text = String(Count);
            this._num = Count;
         }
      }
      
      protected function __updateInfo(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["necklaceExp"]) || Boolean(event.changedProperties["necklaceExpAdd"]))
         {
            this.updateView();
         }
      }
      
      protected function __onInput(event:Event) : void
      {
         this.number = int(this._numText.text);
      }
      
      protected function __onFrameEvent(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SoundManager.instance.playButtonSound();
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(getTimer() - this._lastCreatTime > 1000)
            {
               this._lastCreatTime = getTimer();
               this._stoneInfo = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemByTemplateId(EquipType.NECKLACE_PTETROCHEM_STONE);
               if(this.isStrength())
               {
                  SocketManager.Instance.out.necklaceStrength(this._num,this._stoneInfo.Place);
               }
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            }
         }
      }
      
      private function isStrength() : Boolean
      {
         if(!this._stoneInfo || this._num == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.Warning"));
            return false;
         }
         return true;
      }
      
      protected function __onBagUpdate(event:BagEvent) : void
      {
         var Count:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(EquipType.NECKLACE_PTETROCHEM_STONE);
         if(Boolean(this._stoneInfo))
         {
            this._stoneCell.setCount(Count);
         }
         else
         {
            this._stoneCell.setCount(0);
            this._numText.text = "1";
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function set number(value:int) : void
      {
         var Count:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(EquipType.NECKLACE_PTETROCHEM_STONE);
         if(value < this._minNum)
         {
            value = this._minNum;
         }
         else if(value > this._maxNum)
         {
            value = this._maxNum;
         }
         if(value > Count)
         {
            value = Count;
         }
         this._num = value;
         this.updateView();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateView() : void
      {
         var nextNecklaceStrengthPlus:int = 0;
         var necklaceExp:int = PlayerManager.Instance.Self.necklaceExp;
         var necklaceExpAdd:int = PlayerManager.Instance.Self.necklaceExpAdd;
         var necklaceLevel:int = PlayerManager.Instance.Self.necklaceLevel;
         this._numText.text = this._num.toString();
         this._expText.text = String(necklaceExpAdd);
         this._levelText.text = "Lv. " + necklaceLevel.toString();
         var necklaceStrengthPlus:int = StoreEquipExperience.getNecklaceStrengthPlus(necklaceLevel);
         this._currentLevel.text = LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.info",necklaceStrengthPlus);
         if(necklaceLevel < StoreEquipExperience.NECKLACE_MAX_LEVEL)
         {
            nextNecklaceStrengthPlus = StoreEquipExperience.getNecklaceStrengthPlus(necklaceLevel + 1);
            this._nextLevel.text = LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.info",nextNecklaceStrengthPlus);
         }
         else
         {
            this._nextLevel.text = LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.infoII");
         }
         if(necklaceLevel < StoreEquipExperience.NECKLACE_MAX_LEVEL)
         {
            this._progress.setProgress(StoreEquipExperience.getNecklaceCurrentlevelExp(necklaceExp),StoreEquipExperience.getNecklaceCurrentlevelMaxExp(necklaceLevel));
         }
         else
         {
            this._progress.setProgress(1,1);
         }
         var Count:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(EquipType.NECKLACE_PTETROCHEM_STONE);
         if(this._num > Count)
         {
            if(Boolean(this._stoneInfo))
            {
               this._numText.text = String(Count);
               this._num = Count;
            }
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._levelText);
         this._levelText = null;
         ObjectUtils.disposeObject(this._currentLevel);
         this._currentLevel = null;
         ObjectUtils.disposeObject(this._nextLevel);
         this._nextLevel = null;
         ObjectUtils.disposeObject(this._numText);
         this._numText = null;
         ObjectUtils.disposeObject(this._expText);
         this._expText = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._stoneCell);
         this._stoneCell = null;
         ObjectUtils.disposeObject(this._maxBtn);
         this._maxBtn = null;
         super.dispose();
      }
   }
}

