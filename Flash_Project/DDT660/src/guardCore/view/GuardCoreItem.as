package guardCore.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import guardCore.GuardCoreManager;
   import guardCore.data.GuardCoreInfo;
   
   public class GuardCoreItem extends Sprite implements Disposeable
   {
       
      
      private var _icon:Bitmap;
      
      private var _guardBtn:TextButton;
      
      private var _info:GuardCoreInfo;
      
      private var _type:int;
      
      private var _tips:Component;
      
      private var _frameFilter:Array;
      
      private var _clickTime:int;
      
      public function GuardCoreItem(param1:int)
      {
         super();
         this._type = param1;
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._frameFilter = ComponentFactory.Instance.creatFrameFilters(ComponentSetting.SIMPLE_BITMAP_BUTTON_FILTER);
         this._icon = ComponentFactory.Instance.creatBitmap("asset.guardCore.icon" + this._type);
         this._icon.scaleX = this._icon.scaleY = 0.8;
         addChild(this._icon);
         this._guardBtn = ComponentFactory.Instance.creatComponentByStylename("guardCore.itemBtn");
         this._guardBtn.text = LanguageMgr.GetTranslation("guardCore.title");
         addChild(this._guardBtn);
         this._tips = ComponentFactory.Instance.creatComponentByStylename("guardCore.itemTips");
         this._tips.graphics.beginFill(0,0);
         this._tips.graphics.drawRect(0,0,this._icon.width,this._icon.height);
         this._tips.graphics.endFill();
         this._tips.width = this._icon.width;
         this._tips.height = this._icon.height;
         addChild(this._tips);
         this.updateView();
         this.updateTipsData();
      }
      
      public function updateTipsData() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.Grade;
         var _loc2_:int = PlayerManager.Instance.Self.guardCoreGrade;
         this._tips.tipData = {
            "type":this._type,
            "grade":_loc1_,
            "guardGrade":_loc2_
         };
      }
      
      private function updateView() : void
      {
         if(GuardCoreManager.instance.getGuardCoreIsOpen(PlayerManager.Instance.Self.Grade,this._type))
         {
            this._icon.filters = this._frameFilter[0];
            this._guardBtn.visible = true;
         }
         else
         {
            this._icon.filters = this._frameFilter[3];
            this._guardBtn.visible = false;
         }
      }
      
      private function __onGuardBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(getTimer() - this._clickTime < 2000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.poultry.wakefeedLimitTxt"));
         }
         this._clickTime = getTimer();
         var _loc2_:GuardCoreInfo = GuardCoreManager.instance.getGuardCoreInfo(PlayerManager.Instance.Self.guardCoreGrade,this._type);
         if(PlayerManager.Instance.Self.guardCoreID == _loc2_.ID)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("guardCore.notEquip"));
         }
         else
         {
            SocketManager.Instance.out.sendGuardCoreEquip(_loc2_.ID);
         }
      }
      
      private function initEvent() : void
      {
         this._guardBtn.addEventListener(MouseEvent.CLICK,this.__onGuardBtn);
      }
      
      private function removeEvent() : void
      {
         this._guardBtn.removeEventListener(MouseEvent.CLICK,this.__onGuardBtn);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._info = null;
         this._icon = null;
         this._tips = null;
      }
   }
}
