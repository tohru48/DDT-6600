package farm.viewx
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import farm.FarmModelController;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CountdownView extends Sprite
   {
      
      private var _fastForward:BaseButton;
      
      private var _fieldID:int;
      
      public function CountdownView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._fastForward = ComponentFactory.Instance.creatComponentByStylename("farm.fastForwardBtn");
         addChild(this._fastForward);
      }
      
      public function setCountdown(fieldID:int) : void
      {
         this._fieldID = fieldID;
      }
      
      public function setFastBtnEnable(flag:Boolean) : void
      {
         this._fastForward.visible = flag;
      }
      
      private function initEvent() : void
      {
         this._fastForward.addEventListener(MouseEvent.CLICK,this.__fastBtnClick);
      }
      
      protected function __fastBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.visible = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.farms.fastForwardInfo",FarmModelController.instance.gropPrice),"",LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      protected function __onResponse(event:FrameEvent) : void
      {
         var needMoney:int = 0;
         SoundManager.instance.play("008");
         var isBand:Boolean = (event.target as BaseAlerFrame).isBand;
         (event.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         (event.target as BaseAlerFrame).dispose();
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            needMoney = FarmModelController.instance.gropPrice;
            if(BuriedManager.Instance.checkMoney(isBand,needMoney))
            {
               return;
            }
            SocketManager.Instance.out.fastForwardGrop(isBand,false,this._fieldID);
         }
      }
      
      private function remvoeEvent() : void
      {
         this._fastForward.removeEventListener(MouseEvent.CLICK,this.__fastBtnClick);
      }
      
      public function dispose() : void
      {
         this.remvoeEvent();
         if(Boolean(this._fastForward))
         {
            this._fastForward.dispose();
            this._fastForward = null;
         }
      }
   }
}

