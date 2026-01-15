package newVersionGuide
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.OpitionEnum;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class NewVersionGuideTipView extends Sprite implements Disposeable
   {
      
      private var _bg:MovieClip;
      
      private var _contentBit:Bitmap;
      
      private var _btn:TextButton;
      
      private var _completeGuideFunc:Function;
      
      private var _type:int;
      
      public function NewVersionGuideTipView(type:int, completeGuideFunc:Function = null)
      {
         super();
         this._type = type;
         this._completeGuideFunc = completeGuideFunc;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("hall.newVersionGuide.tipBg");
         addChild(this._bg);
         this._contentBit = ComponentFactory.Instance.creat("hall.newVersionGuide.tip" + this._type);
         addChild(this._contentBit);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("newVersionGuide.btn");
         this._btn.text = LanguageMgr.GetTranslation("ok");
         addChild(this._btn);
      }
      
      private function initEvent() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      protected function __clickHandler(event:MouseEvent) : void
      {
         if(this._type == 1)
         {
            this.dispose();
            NewVersionGuideManager.instance.startGuide();
         }
         else
         {
            this.dispose();
            PlayerManager.Instance.Self.OptionOnOff = OpitionEnum.setOpitionState(true,OpitionEnum.IsShowNewVersionGuide);
            SocketManager.Instance.out.sendOpition(PlayerManager.Instance.Self.OptionOnOff);
            this._completeGuideFunc();
            NewVersionGuideManager.instance.dispatchEvent(new NewVersionGuideEvent(NewVersionGuideEvent.GUIDECOMPLETE));
         }
      }
      
      private function removeEvent() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._contentBit);
         this._contentBit = null;
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

