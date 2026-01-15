package quest.cmd
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import trainer.data.Step;
   import trainer.view.BaseExplainFrame;
   import trainer.view.ExplainPowerThree;
   
   public class Cmd_ThreeAndPower_PickUpAndEnable
   {
      
      private var toolForPick:MovieClip;
      
      private var _picked:Boolean = false;
      
      private var flyAwayMC:MovieClip;
      
      private var explainPowerThree:ExplainPowerThree;
      
      public function Cmd_ThreeAndPower_PickUpAndEnable()
      {
         super();
      }
      
      public function excute(questID:int) : void
      {
         if(questID == 560)
         {
            this.closeTaskView();
            this.enableThreeAndPower();
            this.pickUpThreeAndPower();
         }
      }
      
      private function closeTaskView() : void
      {
         TaskManager.instance.MainFrame.dispose();
      }
      
      private function enableThreeAndPower() : void
      {
         SocketManager.Instance.out.syncWeakStep(Step.POWER_OPEN);
         SocketManager.Instance.out.syncWeakStep(Step.THREE_OPEN);
      }
      
      private function pickUpThreeAndPower() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TRAINER + "3");
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TRAINER + "3")
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TRAINER + "3")
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.creatToolForPick("asset.trainer.getPowerThreeAsset");
         }
      }
      
      private function creatToolForPick(style:String) : void
      {
         this.toolForPick = ClassUtils.CreatInstance(style) as MovieClip;
         this.toolForPick.buttonMode = true;
         this.toolForPick.addEventListener(MouseEvent.CLICK,this.__pickTool);
         PositionUtils.setPos(this.toolForPick,"trainer3.pickup.point");
         this.toolForPick.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this.toolForPick.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         LayerManager.Instance.addToLayer(this.toolForPick,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         SoundManager.instance.play("156");
      }
      
      private function __pickTool(event:MouseEvent) : void
      {
         this._picked = true;
         SoundManager.instance.play("008");
         SoundManager.instance.play("157");
         this.disposeToolForPick();
         this.flyAwayMC = ClassUtils.CreatInstance("asset.trainer.getPowerThreeMove");
         this.flyAwayMC.stop();
         this.flyAwayMC.addEventListener(Event.ENTER_FRAME,this.onEF);
         LayerManager.Instance.addToLayer(this.flyAwayMC,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         this.flyAwayMC.play();
      }
      
      private function onEF(e:Event) : void
      {
         if(this.flyAwayMC.currentFrame == this.flyAwayMC.totalFrames)
         {
            this.flyAwayMC.removeEventListener(Event.ENTER_FRAME,this.onEF);
            this.PickUpAnimationSuccess();
         }
         else if(this.flyAwayMC.currentFrame == this.flyAwayMC.totalFrames - 8)
         {
            this.showConfirm();
         }
      }
      
      protected function showConfirm() : void
      {
         this.explainPowerThree = ComponentFactory.Instance.creatCustomObject("trainer.ExplainPowerThree");
         this.explainPowerThree.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
         this.explainPowerThree.show();
      }
      
      protected function PickUpAnimationSuccess() : void
      {
         ObjectUtils.disposeObject(this.flyAwayMC);
         this.flyAwayMC = null;
      }
      
      protected function __explainEnter(e:Event) : void
      {
         this.explainPowerThree.removeEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
         this.explainPowerThree.dispose();
         this.explainPowerThree = null;
      }
      
      private function disposeToolForPick() : void
      {
         ObjectUtils.disposeObject(this.toolForPick);
         this.toolForPick.removeEventListener(MouseEvent.CLICK,this.__pickTool);
         this.toolForPick.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this.toolForPick.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         this.toolForPick = null;
         this._picked = false;
      }
      
      private function __outHandler(event:MouseEvent) : void
      {
         this.toolForPick.filters = null;
      }
      
      private function __overHandler(event:MouseEvent) : void
      {
         this.toolForPick.filters = [new GlowFilter(16737792,1,30,30,2)];
      }
   }
}

