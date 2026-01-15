package flowerGiving.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flowerGiving.components.FlowerSendRecordItem;
   
   public class FlowerSendRecordFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _infoArr:Array;
      
      public function FlowerSendRecordFrame(infoArr:Array)
      {
         this._infoArr = infoArr;
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var item:FlowerSendRecordItem = null;
         this._bg = ComponentFactory.Instance.creat("flowerGiving.flowerSendRecordFrame.bg");
         addToContent(this._bg);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendRecordFrame.vBox");
         addToContent(this._vbox);
         for(var i:int = 0; i < this._infoArr.length; i++)
         {
            item = new FlowerSendRecordItem(i);
            if(Boolean(this._infoArr[i]))
            {
               item.setData(this._infoArr[i]);
            }
            this._vbox.addChild(item);
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._responseHandle);
      }
      
      protected function _responseHandle(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._responseHandle);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         super.dispose();
      }
   }
}

