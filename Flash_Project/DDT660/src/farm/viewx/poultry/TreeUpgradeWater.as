package farm.viewx.poultry
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TreeUpgradeWater extends Sprite implements Disposeable
   {
      
      private var _levelNum:int;
      
      private var _title:Bitmap;
      
      private var _level:FilterFrameText;
      
      private var _loadingBg:Bitmap;
      
      private var _loading:MovieClip;
      
      private var _exp:FilterFrameText;
      
      private var _checkBox:SelectedCheckButton;
      
      private var _waterBtn:BaseButton;
      
      private var _currentExp:Number;
      
      private var _totalExp:Number;
      
      private var _loveNum:int;
      
      private var _frameIndex:int;
      
      private var _isUpgrade:Boolean;
      
      public function TreeUpgradeWater()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._title = ComponentFactory.Instance.creat("asset.farm.treeUpgrade.water");
         addChild(this._title);
         this._level = ComponentFactory.Instance.creatComponentByStylename("farm.tree.levelTxt2");
         addChild(this._level);
         this._loadingBg = ComponentFactory.Instance.creat("asset.farm.treeUpgrade.loadingBg");
         addChild(this._loadingBg);
         this._loading = ComponentFactory.Instance.creat("asset.farm.treeUpgrade.waterLoading");
         PositionUtils.setPos(this._loading,"farm.treeUpgrade.waterLoading");
         addChild(this._loading);
         this._loading.stop();
         this._exp = ComponentFactory.Instance.creatComponentByStylename("farm.tree.treeExpTxt");
         addChild(this._exp);
         this._checkBox = ComponentFactory.Instance.creatComponentByStylename("farm.tree.checkBox");
         addChild(this._checkBox);
         this._checkBox.text = LanguageMgr.GetTranslation("farm.tree.upgradeWater.checkBoxText");
         this._waterBtn = ComponentFactory.Instance.creatComponentByStylename("farm.treeUpgradeView.waterBtn");
         this._waterBtn.tipData = LanguageMgr.GetTranslation("farm.tree.upgradeWaterBtn.tipsText");
         addChild(this._waterBtn);
      }
      
      private function initEvent() : void
      {
         this._waterBtn.addEventListener(MouseEvent.CLICK,this.__onWaterBtnClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FARM_WATER,this.__onWater);
      }
      
      protected function __onWater(event:CrazyTankSocketEvent) : void
      {
         if(this._checkBox.selected || this._frameIndex == 105)
         {
            this.setLoadingFrame();
         }
         else
         {
            this._loading.gotoAndStop(this._frameIndex);
            this._loading.loading.gotoAndStop(this._frameIndex);
            SocketManager.Instance.out.initFarmTree();
         }
      }
      
      protected function __onWaterBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._waterBtn.enable = false;
         var num:int = 1;
         var needNum:int = this._totalExp - this._currentExp;
         if(this._loveNum > 0)
         {
            if(this._checkBox.selected)
            {
               num = Math.min(this._loveNum,needNum);
            }
            this.frameIndex = (this._currentExp + 1) * 105 / this._totalExp;
            if(this._checkBox.selected && this._loveNum >= needNum)
            {
               this._isUpgrade = true;
               this.frameIndex = 105;
            }
            SocketManager.Instance.out.farmWater(num);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.farmTree.waterNotNeedTipsTxt"));
         }
      }
      
      public function setLevelNum(level:int) : void
      {
         this._levelNum = level;
         this._level.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardEquipView.levelText") + this._levelNum;
      }
      
      public function setExp(currentExp:Number, totalExp:Number) : void
      {
         this._currentExp = currentExp;
         this._totalExp = totalExp;
         this._exp.text = this._currentExp + "/" + this._totalExp;
         this._waterBtn.enable = this._levelNum < 50;
         this.frameIndex = this._currentExp * 105 / this._totalExp;
         this._loading.gotoAndStop(this._frameIndex);
         this._loading.loading.gotoAndStop(this._frameIndex);
      }
      
      public function setLoveNum(value:int) : void
      {
         this._loveNum = value;
      }
      
      private function setLoadingFrame() : void
      {
         FarmModelController.instance.dispatchEvent(new FarmEvent(FarmEvent.FARMPOULTRY_UPGRADING,[true]));
         this._loading.gotoAndPlay(this._loading.currentFrame);
         this._loading.loading.gotoAndPlay(this._loading.currentFrame);
         addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      protected function __onEnterFrame(event:Event) : void
      {
         if(this._frameIndex < 105 && this._loading.currentFrame >= this._frameIndex || this._loading.currentFrame == this._loading.totalFrames)
         {
            FarmModelController.instance.dispatchEvent(new FarmEvent(FarmEvent.FARMPOULTRY_UPGRADING,[false]));
            if(this._frameIndex < 105 && this._loading.currentFrame >= this._frameIndex)
            {
               this._loading.gotoAndStop(this._frameIndex);
               this._loading.loading.gotoAndStop(this._frameIndex);
            }
            removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
            SocketManager.Instance.out.initFarmTree();
            if(this._isUpgrade)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.farmUpgrade.waterUpgrade",this._levelNum + 1));
            }
         }
      }
      
      private function set frameIndex(value:int) : void
      {
         if(value == 0)
         {
            this._loading.visible = false;
            this._frameIndex = 1;
         }
         else
         {
            this._loading.visible = true;
            this._frameIndex = value;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FARM_WATER,this.__onWater);
         if(Boolean(this._waterBtn))
         {
            this._waterBtn.removeEventListener(MouseEvent.CLICK,this.__onWaterBtnClick);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._title))
         {
            this._title.bitmapData.dispose();
            this._title = null;
         }
         if(Boolean(this._loadingBg))
         {
            this._loadingBg.bitmapData.dispose();
            this._loadingBg = null;
         }
         if(Boolean(this._level))
         {
            this._level.dispose();
            this._level = null;
         }
         if(Boolean(this._exp))
         {
            this._exp.dispose();
            this._exp = null;
         }
         if(Boolean(this._checkBox))
         {
            this._checkBox.dispose();
            this._checkBox = null;
         }
         if(Boolean(this._loading))
         {
            this._loading.gotoAndStop(1);
            ObjectUtils.disposeAllChildren(this._loading);
            this._loading = null;
         }
         if(Boolean(this._waterBtn))
         {
            this._waterBtn.dispose();
            this._waterBtn = null;
         }
      }
   }
}

