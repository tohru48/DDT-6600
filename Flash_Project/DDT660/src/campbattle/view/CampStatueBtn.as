package campbattle.view
{
   import campbattle.CampBattleManager;
   import campbattle.event.MapEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CampStatueBtn extends Sprite implements Disposeable
   {
      
      private var _mc:MovieClip;
      
      public var _arrowMc:MovieClip;
      
      public function CampStatueBtn()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._mc = ComponentFactory.Instance.creat("camp.campBattle.ClickItem");
         this._mc.buttonMode = true;
         this._mc.stop();
         addChild(this._mc);
         this._arrowMc = this._mc.arrowmc;
         this._mc.addEventListener(MouseEvent.CLICK,this.clickHander);
         this._mc.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHander);
         this._mc.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHander);
      }
      
      private function mouseOutHander(event:MouseEvent) : void
      {
         this._mc.gotoAndStop(1);
      }
      
      private function mouseOverHander(event:MouseEvent) : void
      {
         this._mc.gotoAndStop(2);
      }
      
      private function clickHander(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         SoundManager.instance.playButtonSound();
         if(!CampBattleManager.instance.model.isCapture)
         {
            CampBattleManager.instance.dispatchEvent(new MapEvent(MapEvent.CAPTURE_STATUE,[1469,1000]));
         }
         else
         {
            CampBattleManager.instance.dispatchEvent(new MapEvent(MapEvent.STATUE_GOTO_FIGHT,[1469,1000]));
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._mc))
         {
            this._mc.removeEventListener(MouseEvent.CLICK,this.clickHander);
            this._mc.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHander);
            this._mc.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHander);
            this._mc.stop();
            while(Boolean(this._mc.numChildren))
            {
               ObjectUtils.disposeObject(this._mc.getChildAt(0));
            }
         }
         ObjectUtils.disposeObject(this._mc);
         this._mc = null;
         if(Boolean(this._arrowMc))
         {
            this._arrowMc.stop();
            while(Boolean(this._arrowMc.numChildren))
            {
               ObjectUtils.disposeObject(this._arrowMc.getChildAt(0));
            }
         }
         ObjectUtils.disposeObject(this._arrowMc);
         this._arrowMc = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

