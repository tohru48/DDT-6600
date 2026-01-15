package drgnBoat.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class DrgnBoatNPCpaopao extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _direction:int;
      
      public function DrgnBoatNPCpaopao(direction:int = 0)
      {
         super();
         this._direction = direction;
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._txt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.paopaoTxt");
         switch(this._direction)
         {
            case 0:
               this.x = 0;
               this.y = -180;
               this._bg = ComponentFactory.Instance.creat("drgnBoat.paopaoR");
               break;
            case 1:
               this.x = -380;
               this.y = -180;
               this._bg = ComponentFactory.Instance.creat("drgnBoat.paopaoL");
               PositionUtils.setPos(this._txt,"drgnBoat.paopaoPos");
         }
         addChild(this._bg);
         addChild(this._txt);
      }
      
      private function initEvents() : void
      {
      }
      
      public function setTxt(str:String) : void
      {
         this._txt.text = str;
         setTimeout(this.paopaoComplete,2000);
      }
      
      private function paopaoComplete() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function removeEvents() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._txt);
         this._txt = null;
      }
   }
}

