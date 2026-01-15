package consortionBattle.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsBatExitBtn extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _moveOutBtn:SimpleBitmapButton;
      
      private var _moveInBtn:SimpleBitmapButton;
      
      private var _returnBtn:SimpleBitmapButton;
      
      public function ConsBatExitBtn()
      {
         super();
         this.x = 909;
         this.y = 513;
         this.initView();
         this.initEvent();
         this.setInOutVisible(true);
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortiaBattle.returnBtn.bg");
         this._moveOutBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.moveOutBtn");
         this._moveInBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.moveInBtn");
         this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.returnBtn");
         addChild(this._bg);
         addChild(this._moveOutBtn);
         addChild(this._moveInBtn);
         addChild(this._returnBtn);
      }
      
      private function initEvent() : void
      {
         this._moveOutBtn.addEventListener(MouseEvent.CLICK,this.outHandler,false,0,true);
         this._moveInBtn.addEventListener(MouseEvent.CLICK,this.inHandler,false,0,true);
         this._returnBtn.addEventListener(MouseEvent.CLICK,this.exitHandler,false,0,true);
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(false);
         TweenLite.to(this,0.5,{"x":966});
      }
      
      private function setInOutVisible(isOut:Boolean) : void
      {
         this._moveOutBtn.visible = isOut;
         this._moveInBtn.visible = !isOut;
      }
      
      private function inHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(true);
         TweenLite.to(this,0.5,{"x":909});
      }
      
      private function exitHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortiaBattle.leavePromptTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__exitConfirm,false,0,true);
      }
      
      private function __exitConfirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__exitConfirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(StateManager.currentStateType == StateType.CONSORTIA_BATTLE_SCENE)
            {
               SocketManager.Instance.out.sendConsBatExit();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.notReturn"));
            }
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._moveOutBtn))
         {
            this._moveOutBtn.removeEventListener(MouseEvent.CLICK,this.outHandler);
         }
         if(Boolean(this._moveInBtn))
         {
            this._moveInBtn.removeEventListener(MouseEvent.CLICK,this.inHandler);
         }
         if(Boolean(this._returnBtn))
         {
            this._returnBtn.removeEventListener(MouseEvent.CLICK,this.exitHandler);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._moveOutBtn = null;
         this._moveInBtn = null;
         this._returnBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

