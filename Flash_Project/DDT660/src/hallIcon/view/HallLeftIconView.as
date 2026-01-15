package hallIcon.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import hallIcon.event.HallIconEvent;
   import hallIcon.info.HallIconInfo;
   import kingBless.KingBlessManager;
   import vip.VipController;
   
   public class HallLeftIconView extends Sprite implements Disposeable
   {
      
      private var _iconVBox:VBox;
      
      private var _expblessedIcon:Component;
      
      private var _vipLvlIcon:MovieClip;
      
      private var _kingBlessIcon:Component;
      
      public function HallLeftIconView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._iconVBox = new VBox();
         this._iconVBox.spacing = 5;
         addChild(this._iconVBox);
         this.updateExpblessedIcon();
         this.updateVipLvlIcon();
         this.updateKingBlessIcon();
      }
      
      private function initEvent() : void
      {
         HallIconManager.instance.model.addEventListener(HallIconEvent.UPDATE_LEFTICON_VIEW,this.__updateLeftIconView);
      }
      
      private function addChildBox($child:DisplayObject) : void
      {
         this._iconVBox.addChild($child);
         this._iconVBox.arrange();
      }
      
      private function updateExpblessedIcon() : void
      {
         if(HallIconManager.instance.model.expblessedIsOpen)
         {
            if(this._expblessedIcon == null)
            {
               this._expblessedIcon = this.createComponentIcon("assets.hallIcon.expblessedIcon");
               this._expblessedIcon.buttonMode = true;
               this.addChildBox(this._expblessedIcon);
            }
            this._expblessedIcon.tipData = LanguageMgr.GetTranslation("ddt.HallStateView.expValue",HallIconManager.instance.model.expblessedValue);
         }
         else
         {
            this.removeExpblessedIcon();
         }
      }
      
      private function __updateLeftIconView(evt:HallIconEvent) : void
      {
         var hallIconInfo:HallIconInfo = evt.data as HallIconInfo;
         switch(hallIconInfo.icontype)
         {
            case HallIconType.EXPBLESSED:
               this.updateExpblessedIcon();
               break;
            case HallIconType.VIPLVL:
               this.updateVipLvlIcon();
         }
      }
      
      private function updateVipLvlIcon() : void
      {
         if(HallIconManager.instance.model.vipLvlIsOpen)
         {
            if(this._vipLvlIcon == null)
            {
               this._vipLvlIcon = ClassUtils.CreatInstance("assets.hallIcon.VIPLvlIcon");
               this._vipLvlIcon.buttonMode = true;
               this._vipLvlIcon.addEventListener(MouseEvent.CLICK,this.__vipLvlIconClickHandler);
               this.addChildBox(this._vipLvlIcon);
            }
         }
         else
         {
            this.removeVipLvlIcon();
         }
      }
      
      private function __vipLvlIconClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipController.instance.show();
      }
      
      private function updateKingBlessIcon() : void
      {
         if(HallIconManager.instance.model.kingBlessIsOpen)
         {
            if(this._kingBlessIcon == null)
            {
               this._kingBlessIcon = this.createComponentIcon("assets.hallIcon.kingBlessIcon");
               this._kingBlessIcon.buttonMode = true;
               this._kingBlessIcon.addEventListener(MouseEvent.CLICK,this.__kingBlessIconClickHandler);
               this.addChildBox(this._kingBlessIcon);
            }
            this._kingBlessIcon.tipStyle = "ddt.view.tips.KingBlessTip";
            this._kingBlessIcon.tipData = KingBlessManager.instance.getRemainTimeTxt();
         }
         else
         {
            this.removeKingBlessIcon();
         }
      }
      
      private function __kingBlessIconClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         KingBlessManager.instance.loadKingBlessModule(KingBlessManager.instance.doOpenKingBlessFrame);
      }
      
      private function createComponentIcon($iconString:String) : Component
      {
         var tempComponent:Component = null;
         tempComponent = new Component();
         tempComponent.tipStyle = "ddt.view.tips.OneLineTip";
         tempComponent.tipDirctions = "7,3,6";
         tempComponent.addChild(ComponentFactory.Instance.creat($iconString));
         tempComponent.width = 70;
         tempComponent.height = 70;
         return tempComponent;
      }
      
      private function removeEvent() : void
      {
         HallIconManager.instance.model.removeEventListener(HallIconEvent.UPDATE_LEFTICON_VIEW,this.__updateLeftIconView);
      }
      
      private function removeVipLvlIcon() : void
      {
         if(Boolean(this._vipLvlIcon))
         {
            this._vipLvlIcon.removeEventListener(MouseEvent.CLICK,this.__vipLvlIconClickHandler);
            this._vipLvlIcon.stop();
            ObjectUtils.disposeObject(this._vipLvlIcon);
            this._vipLvlIcon = null;
         }
      }
      
      private function removeExpblessedIcon() : void
      {
         if(Boolean(this._expblessedIcon))
         {
            ObjectUtils.disposeAllChildren(this._expblessedIcon);
            ObjectUtils.disposeObject(this._expblessedIcon);
            this._expblessedIcon = null;
         }
      }
      
      private function removeKingBlessIcon() : void
      {
         if(Boolean(this._kingBlessIcon))
         {
            this._kingBlessIcon.removeEventListener(MouseEvent.CLICK,this.__kingBlessIconClickHandler);
            ObjectUtils.disposeAllChildren(this._kingBlessIcon);
            ObjectUtils.disposeObject(this._kingBlessIcon);
            this._kingBlessIcon = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeExpblessedIcon();
         this.removeVipLvlIcon();
         this.removeKingBlessIcon();
         if(Boolean(this._iconVBox))
         {
            ObjectUtils.disposeAllChildren(this._iconVBox);
            ObjectUtils.disposeObject(this._iconVBox);
            this._iconVBox = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

