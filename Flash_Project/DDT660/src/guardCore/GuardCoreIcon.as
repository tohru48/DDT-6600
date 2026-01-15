package guardCore
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import guardCore.data.GuardCoreInfo;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class GuardCoreIcon extends Component
   {
       
      
      private var _info:GuardCoreInfo;
      
      private var _icon:Bitmap;
      
      private var _player:PlayerInfo;
      
      public function GuardCoreIcon()
      {
         super();
      }
      
      public function setup(param1:PlayerInfo, param2:Boolean = true) : void
      {
         if(this._player)
         {
            this._player.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onGuardChange);
            this.removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
         this._player = param1;
         this._player.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onGuardChange);
         this._info = GuardCoreManager.instance.getGuardCoreInfoByID(this._player.guardCoreID);
         if(this._player.isSelf && param2)
         {
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         else
         {
            this.buttonMode = false;
         }
         this.updateIcon();
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         GuardCoreManager.instance.EnterStart();
         this.checkGuide();
      }
      
      private function checkGuide() : void
      {
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.GUARD_CORE))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.GUARD_CORE);
            SocketManager.Instance.out.syncWeakStep(Step.GUARD_CORE);
         }
      }
      
      private function __onGuardChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["GuardCoreID"])
         {
            this._info = GuardCoreManager.instance.getGuardCoreInfoByID(param1.target.guardCoreID);
            this.updateIcon();
         }
      }
      
      private function updateIcon() : void
      {
         if(this._info)
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
            this._icon = ComponentFactory.Instance.creatBitmap("asset.ddtcorei.guardCoreIcon" + this._info.Type);
            addChild(this._icon);
            _changedPropeties = new Dictionary();
            tipData = this._info.Name;
         }
         else
         {
            tipData = LanguageMgr.GetTranslation("guardCore.tipsError");
         }
      }
      
      override public function dispose() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.__onClick);
         this._player.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onGuardChange);
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         this._info = null;
         this._player = null;
         super.dispose();
      }
   }
}
