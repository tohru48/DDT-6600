package campbattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CampStateHideBtn extends Sprite
   {
      
      private var _mc:MovieClip;
      
      private var _isHide:Boolean = true;
      
      public function CampStateHideBtn()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._mc = ComponentFactory.Instance.creat("asset.worldBoss.hideBtn");
         this._mc.buttonMode = true;
         addChild(this._mc);
         this._mc.mc.gotoAndStop(2);
         this._mc.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
      }
      
      public function get isHide() : Boolean
      {
         return this._isHide;
      }
      
      private function mouseClickHander(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         if(!this._isHide)
         {
            this._isHide = true;
            this._mc.mc.gotoAndStop(2);
         }
         else
         {
            this._isHide = false;
            this._mc.mc.gotoAndStop(1);
         }
      }
      
      public function dispose() : void
      {
         this._mc.removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
         ObjectUtils.disposeObject(this._mc);
         this._mc = null;
      }
   }
}

