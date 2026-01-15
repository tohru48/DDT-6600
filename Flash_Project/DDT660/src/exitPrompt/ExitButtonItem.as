package exitPrompt
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ExitButtonItem extends Component
   {
      
      private var _bt:BaseButton;
      
      private var _fontBg:Bitmap;
      
      public var fontBgBgUrl:String;
      
      public var coord:String;
      
      private var _light:ScaleBitmapImage;
      
      public function ExitButtonItem()
      {
         super();
         mouseChildren = false;
         buttonMode = true;
         this.initEvent();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         var coordArr:Array = null;
         super.onProppertiesUpdate();
         coordArr = this.coord.split(/,/g);
         if(!this._bt)
         {
            this._bt = ComponentFactory.Instance.creat("ExitPromptFrame.MissionBt");
         }
         if(!this._fontBg)
         {
            this._fontBg = ComponentFactory.Instance.creat(this.fontBgBgUrl);
         }
         this._light = ComponentFactory.Instance.creatComponentByStylename("exit.ExitPromptFrame.light");
         addChild(this._bt);
         addChild(this._fontBg);
         addChild(this._light);
         this._light.visible = false;
         this._fontBg.x = coordArr[0];
         this._fontBg.y = coordArr[1];
         height = this._bt.height;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      private function __mouseOverHandler(evt:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function __mouseOutHandler(evt:MouseEvent) : void
      {
         this._light.visible = false;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeObject(this._bt);
         ObjectUtils.disposeObject(this._fontBg);
         if(Boolean(this._light))
         {
            ObjectUtils.disposeObject(this._light);
            this._light = null;
         }
         this._bt = null;
         this._fontBg = null;
      }
   }
}

