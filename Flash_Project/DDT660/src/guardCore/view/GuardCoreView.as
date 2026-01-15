package guardCore.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.Experience;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import guardCore.GuardCoreManager;
   import guardCore.data.GuardCoreInfo;
   import guardCore.data.GuardCoreLevelInfo;
   
   public class GuardCoreView extends Frame
   {
       
      
      private var _bg:Bitmap;
      
      private var _upgradeBtn:SimpleBitmapButton;
      
      private var _guardImg:Bitmap;
      
      private var _guardContainer:Sprite;
      
      private var _needGold:FilterFrameText;
      
      private var _needExp:FilterFrameText;
      
      private var _needGuard:FilterFrameText;
      
      private var _gold:FilterFrameText;
      
      private var _exp:FilterFrameText;
      
      private var _guard:FilterFrameText;
      
      private var _level:FilterFrameText;
      
      private var _itemList:Vector.<GuardCoreItem>;
      
      private var _itemContainer:Sprite;
      
      private var _btnHelp:BaseButton;
      
      private var _clickTime:int;
      
      public function GuardCoreView()
      {
         super();
         this.initEvent();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.guardCore.bg");
         this._upgradeBtn = ComponentFactory.Instance.creatComponentByStylename("guardCore.upgradeBtn");
         this._needGold = ComponentFactory.Instance.creatComponentByStylename("guardCore.needText");
         PositionUtils.setPos(this._needGold,"guardCore.needGoldPos");
         this._needExp = ComponentFactory.Instance.creatComponentByStylename("guardCore.needText");
         PositionUtils.setPos(this._needExp,"guardCore.needExpPos");
         this._needGuard = ComponentFactory.Instance.creatComponentByStylename("guardCore.needText");
         PositionUtils.setPos(this._needGuard,"guardCore.needGuardPos");
         this._gold = ComponentFactory.Instance.creatComponentByStylename("guardCore.haveText");
         PositionUtils.setPos(this._gold,"guardCore.goldPos");
         this._exp = ComponentFactory.Instance.creatComponentByStylename("guardCore.haveText");
         PositionUtils.setPos(this._exp,"guardCore.expPos");
         this._guard = ComponentFactory.Instance.creatComponentByStylename("guardCore.haveText");
         PositionUtils.setPos(this._guard,"guardCore.guardPos");
         this._level = ComponentFactory.Instance.creatComponentByStylename("guardCore.guardLevelText");
         this.initItem();
         this._guardContainer = new Sprite();
         PositionUtils.setPos(this._guardContainer,"guardCore.guardIconPos");
         super.init();
         this._btnHelp = HelpFrameUtils.Instance.simpleHelpButton(this,"core.helpButtonSmall",{
            "x":468,
            "y":5
         },LanguageMgr.GetTranslation("store.view.HelpButtonText"),"asset.guardCore.help",408,488);
         titleText = LanguageMgr.GetTranslation("guardCore.title");
         this.updateView();
         this.updateGuardIcon();
      }
      
      private function initItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:GuardCoreItem = null;
         this._itemList = new Vector.<GuardCoreItem>(8);
         this._itemContainer = new Sprite();
         PositionUtils.setPos(this._itemContainer,"guardCore.containerPos");
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new GuardCoreItem(_loc1_ + 1);
            this._itemList[_loc1_] = _loc2_;
            _loc2_.x = int(_loc1_ % 4) * 106;
            _loc2_.y = int(_loc1_ / 4) * 112;
            this._itemContainer.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      private function updateView() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.guardCoreGrade + 1;
         var _loc2_:GuardCoreLevelInfo = GuardCoreManager.instance.getGuardLevelInfo(_loc1_);
         var _loc3_:int = PlayerManager.Instance.Self.Gold;
         var _loc4_:int = PlayerManager.Instance.Self.GP - Experience.expericence[PlayerManager.Instance.Self.Grade - 1];
         var _loc5_:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(EquipType.GUARD_CORE);
         this._gold.text = this.countToString(_loc3_);
         this._exp.text = this.countToString(_loc4_);
         this._guard.text = _loc5_.toString();
         if(_loc2_ == null)
         {
            this._needGold.text = "0";
            this._needExp.text = "0";
            this._needGuard.text = "0";
            this._upgradeBtn.enable = false;
         }
         else
         {
            this._needGold.text = this.countToString(_loc2_.Gold);
            this._needExp.text = this.countToString(_loc2_.Exp);
            this._needGuard.text = _loc2_.Guard.toString();
            this._needGold.setFrame(_loc3_ >= _loc2_.Gold ? int(1) : int(2));
            this._needExp.setFrame(_loc4_ >= _loc2_.Exp ? int(1) : int(2));
            this._needGuard.setFrame(_loc5_ >= _loc2_.Guard ? int(1) : int(2));
         }
         this._level.text = PlayerManager.Instance.Self.guardCoreGrade.toString();
      }
      
      private function countToString(param1:int) : String
      {
         return param1.toString();
      }
      
      private function updateGuardIcon() : void
      {
         ObjectUtils.disposeObject(this._guardImg);
         var _loc1_:GuardCoreInfo = GuardCoreManager.instance.getSelfGuardCoreInfo();
         this._guardImg = ComponentFactory.Instance.creatBitmap("asset.guardCore.icon" + _loc1_.Type);
         this._guardImg.scaleX = this._guardImg.scaleY = 0.8;
         this._guardContainer.addChild(this._guardImg);
      }
      
      private function checkEquipGuardCore() : void
      {
         var _loc1_:GuardCoreInfo = GuardCoreManager.instance.getSelfGuardCoreInfo();
         var _loc2_:GuardCoreInfo = GuardCoreManager.instance.getGuardCoreInfoBySkillGrade(_loc1_.SkillGrade + 1,_loc1_.Type);
         if(_loc2_ && PlayerManager.Instance.Self.guardCoreGrade >= _loc2_.GuardGrade)
         {
            SocketManager.Instance.out.sendGuardCoreEquip(_loc2_.ID);
         }
      }
      
      private function updateItemTipsData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemList.length)
         {
            this._itemList[_loc1_].updateTipsData();
            _loc1_++;
         }
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addToContent(this._bg);
         addToContent(this._upgradeBtn);
         addToContent(this._needGold);
         addToContent(this._needExp);
         addToContent(this._needGuard);
         addToContent(this._gold);
         addToContent(this._exp);
         addToContent(this._guard);
         addToContent(this._level);
         addToContent(this._itemContainer);
         addToContent(this._guardContainer);
      }
      
      private function __onClickUpgrade(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(getTimer() - this._clickTime < 2000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("carnival.clickTip"));
         }
         this._clickTime = getTimer();
         if(this.isUpgrade())
         {
            SocketManager.Instance.out.sendGuardCoreLevelUp();
         }
      }
      
      private function isUpgrade() : Boolean
      {
         var _loc1_:int = PlayerManager.Instance.Self.guardCoreGrade + 1;
         var _loc2_:GuardCoreLevelInfo = GuardCoreManager.instance.getGuardLevelInfo(_loc1_);
         if(_loc2_ == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guardCore.maxTips"));
            return false;
         }
         if(PlayerManager.Instance.Self.Gold < _loc2_.Gold)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guardCore.notGold"));
            return false;
         }
         var _loc3_:int = PlayerManager.Instance.Self.GP - Experience.expericence[PlayerManager.Instance.Self.Grade - 1];
         if(_loc3_ < _loc2_.Exp)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guardCore.notExp"));
            return false;
         }
         var _loc4_:int = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(EquipType.GUARD_CORE);
         if(_loc4_ < _loc2_.Guard)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guardCore.notGuard"));
            return false;
         }
         return true;
      }
      
      private function __onGuardChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["GuardCoreGrade"])
         {
            this.updateView();
            this.updateItemTipsData();
            this.checkEquipGuardCore();
         }
         if(param1.changedProperties["GuardCoreID"])
         {
            this.updateGuardIcon();
         }
      }
      
      override protected function onResponse(param1:int) : void
      {
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onGuardChange);
         this._upgradeBtn.addEventListener(MouseEvent.CLICK,this.__onClickUpgrade);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onGuardChange);
         this._upgradeBtn.removeEventListener(MouseEvent.CLICK,this.__onClickUpgrade);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this._itemContainer);
         ObjectUtils.disposeObject(this._btnHelp);
         ObjectUtils.disposeObject(this._guardImg);
         super.dispose();
         this._btnHelp = null;
         this._bg = null;
         this._upgradeBtn = null;
         this._needGold = null;
         this._needExp = null;
         this._needGuard = null;
         this._gold = null;
         this._exp = null;
         this._guard = null;
         this._level = null;
         this._itemContainer = null;
         this._itemList = null;
         this._guardImg = null;
      }
   }
}
