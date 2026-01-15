package vip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class VIPPrivilegeFrame extends Frame
   {
      
      private var _bg:Image;
      
      private var _view:Sprite;
      
      private var _currentViewIndex:int = -1;
      
      private var _growthRules:SelectedButton;
      
      private var _levelPrivilege:SelectedButton;
      
      private var _giftContent:SelectedButton;
      
      private var _selectedBtnGroup:SelectedButtonGroup;
      
      private var _openVipBtn:BaseButton;
      
      public function VIPPrivilegeFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._selectedBtnGroup.removeEventListener(Event.CHANGE,this.__onSelectedBtnChanged);
         this._openVipBtn.removeEventListener(MouseEvent.CLICK,this.__onOpenVipBtnClick);
      }
      
      protected function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function initView() : void
      {
         this.titleText = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.VipPrivilegeTxt");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("vip.VipPrivilegeFrameBg");
         this._growthRules = ComponentFactory.Instance.creatComponentByStylename("vip.vipPrivilegeFrame.GrowthRulesBtn");
         this._levelPrivilege = ComponentFactory.Instance.creatComponentByStylename("vip.vipPrivilegeFrame.LevelPrivilegeBtn");
         this._giftContent = ComponentFactory.Instance.creatComponentByStylename("vip.vipPrivilegeFrame.giftContentBtn");
         this._giftContent.visible = false;
         addToContent(this._bg);
         addToContent(this._growthRules);
         addToContent(this._levelPrivilege);
         addToContent(this._giftContent);
         this._selectedBtnGroup = new SelectedButtonGroup();
         this._selectedBtnGroup.addSelectItem(this._growthRules);
         this._selectedBtnGroup.addSelectItem(this._levelPrivilege);
         this._selectedBtnGroup.addSelectItem(this._giftContent);
         this._selectedBtnGroup.addEventListener(Event.CHANGE,this.__onSelectedBtnChanged);
         this._selectedBtnGroup.selectIndex = 0;
         if(!PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPExp <= 0)
         {
            this._openVipBtn = ComponentFactory.Instance.creatComponentByStylename("vip.VIPPrivilegeFrame.OpenVipBtn");
         }
         else
         {
            this._openVipBtn = ComponentFactory.Instance.creatComponentByStylename("vip.VIPPrivilegeFrame.RenewalVipBtn");
         }
         this._openVipBtn.addEventListener(MouseEvent.CLICK,this.__onOpenVipBtnClick);
         addToContent(this._openVipBtn);
      }
      
      protected function __onOpenVipBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      protected function __onSelectedBtnChanged(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.updateView(this._selectedBtnGroup.selectIndex);
      }
      
      private function updateView(index:int) : void
      {
         if(index == this._currentViewIndex)
         {
            return;
         }
         if(Boolean(this._view))
         {
            Disposeable(this._view).dispose();
         }
         this._currentViewIndex = index;
         switch(index)
         {
            case 0:
               this._view = new GrowthRuleView();
               break;
            case 1:
               this._view = new LevelPrivilegeView();
               break;
            case 2:
               this._view = new GiftContentView();
         }
         addToContent(this._view);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._view))
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         if(Boolean(this._growthRules))
         {
            ObjectUtils.disposeObject(this._growthRules);
         }
         if(Boolean(this._levelPrivilege))
         {
            ObjectUtils.disposeObject(this._levelPrivilege);
         }
         if(Boolean(this._giftContent))
         {
            ObjectUtils.disposeObject(this._giftContent);
         }
         if(Boolean(this._openVipBtn))
         {
            ObjectUtils.disposeObject(this._openVipBtn);
         }
         if(Boolean(this._selectedBtnGroup))
         {
            this._selectedBtnGroup.dispose();
         }
         this._bg = null;
         this._growthRules = null;
         this._levelPrivilege = null;
         this._giftContent = null;
         this._openVipBtn = null;
         super.dispose();
      }
   }
}

