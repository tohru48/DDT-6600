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
   
   public class ClickDoor extends Sprite implements Disposeable
   {
      
      private var _mc:MovieClip;
      
      public function ClickDoor()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._mc = ComponentFactory.Instance.creat("camp.campBattle.Clickdoor");
         this._mc.stop();
         addChild(this._mc);
         addEventListener(MouseEvent.CLICK,this.clickHander);
         if(CampBattleManager.instance.model.doorIsOpen)
         {
            this._mc.gotoAndStop(2);
            this._mc.mouseChildren = false;
            this._mc.buttonMode = true;
         }
      }
      
      public function doorStatus() : void
      {
         this._mc.gotoAndStop(2);
         this._mc.mouseChildren = false;
         this._mc.buttonMode = true;
      }
      
      private function clickHander(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         SoundManager.instance.playButtonSound();
         CampBattleManager.instance.dispatchEvent(new MapEvent(MapEvent.TO_OTHER_MAP,[x + this._mc.width / 2,y + this._mc.height * 3 / 4]));
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.clickHander);
         if(Boolean(this._mc))
         {
            this._mc.stop();
            while(Boolean(this._mc.numChildren))
            {
               ObjectUtils.disposeObject(this._mc.getChildAt(0));
            }
         }
         ObjectUtils.disposeObject(this._mc);
         this._mc = null;
      }
   }
}

