package gypsyShop.npcBehavior
{
   import com.pickgliss.ui.core.Component;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import hall.HallStateView;
   
   public class GypsyNPCBhvr implements IGypsyNPCBehavior
   {
      
      private var _hall:HallStateView;
      
      private var _container:Sprite;
      
      private var _hotArea:Component;
      
      private var _gypsyNPC:MovieClip;
      
      public function GypsyNPCBhvr(container:Sprite)
      {
         super();
         this._container = container;
      }
      
      public function show() : void
      {
         if(this._container != null && this._hotArea != null)
         {
            if(this._gypsyNPC == null)
            {
               this._gypsyNPC = this._container["gypsy"];
            }
            this._gypsyNPC.visible = true;
            this._gypsyNPC.play();
            this._container.addChild(this._gypsyNPC);
            this._hotArea.visible = true;
            this._hotArea.mouseEnabled = true;
            this._hotArea.buttonMode = this._hotArea.mouseChildren = this._hotArea.mouseEnabled = true;
            if(Boolean(this._hall))
            {
               this._hall.setNPCBtnEnable(this._hotArea as Component,true);
            }
            return;
         }
      }
      
      public function hide() : void
      {
         if(this._gypsyNPC == null)
         {
            this._gypsyNPC = this._container["gypsy"];
         }
         this._gypsyNPC.visible = false;
         this._gypsyNPC.stop();
         this._gypsyNPC = null;
         if(this._hotArea != null)
         {
            this._hotArea.visible = false;
            this._hotArea.buttonMode = this._hotArea.mouseChildren = this._hotArea.mouseEnabled = false;
         }
         if(Boolean(this._hall))
         {
            this._hall.setNPCBtnEnable(this._hotArea as Component,false);
         }
      }
      
      public function dispose() : void
      {
         if(this._gypsyNPC != null)
         {
            this._gypsyNPC = null;
         }
         this._container = null;
         this._hall = null;
      }
      
      public function set container(value:Sprite) : void
      {
         this._container = value;
      }
      
      public function set hotArea(value:InteractiveObject) : void
      {
         this._hotArea = value as Component;
      }
      
      public function set hall(value:HallStateView) : void
      {
         this._hall = value;
      }
   }
}

