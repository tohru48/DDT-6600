package wantstrong.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import wantstrong.WantStrongManager;
   import wantstrong.data.WantStrongModel;
   
   public class WantStrongFrame extends Frame
   {
      
      private var _model:WantStrongModel;
      
      private var _bg:ScaleBitmapImage;
      
      private var _leftBorderbg:ScaleBitmapImage;
      
      private var _rightBg:MutipleImage;
      
      private var _rightbullBg:DisplayObject;
      
      private var _huawen:Bitmap;
      
      private var _wantStrongList:WantStrongList;
      
      private var _state:*;
      
      private var _currentContentView:WantStrongContentView;
      
      public function WantStrongFrame(model:WantStrongModel)
      {
         super();
         this._model = model;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("wantstrong.view.scale9ImageBg");
         addToContent(this._bg);
         this._rightbullBg = ComponentFactory.Instance.creatCustomObject("wangstrong.ActivityListBg");
         addToContent(this._rightbullBg);
         this._huawen = ComponentFactory.Instance.creat("wantstrong.huaweng");
         addToContent(this._huawen);
         this._leftBorderbg = ComponentFactory.Instance.creatComponentByStylename("wantstrong.BG1");
         addToContent(this._leftBorderbg);
         this._rightBg = ComponentFactory.Instance.creatComponentByStylename("wantstrong.BG03");
         addToContent(this._rightBg);
         this._wantStrongList = ComponentFactory.Instance.creatCustomObject("wantstrong.WantStrongList",[this._model]);
         addToContent(this._wantStrongList);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._responseHandle);
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
               WantStrongManager.Instance.close();
               this.dispose();
               break;
            case FrameEvent.CLOSE_CLICK:
               WantStrongManager.Instance.close();
               this.dispose();
         }
      }
      
      public function setInfo(data:* = null, stateChange:Boolean = false) : void
      {
         if(this._state != data || stateChange)
         {
            this._state = data;
            ObjectUtils.disposeObject(this._currentContentView);
            this._currentContentView = null;
            this._currentContentView = ComponentFactory.Instance.creatCustomObject("wantstrong.WantStrongContentView");
            addToContent(this._currentContentView as DisplayObject);
            if(Boolean(this._currentContentView))
            {
               this._currentContentView.setData(data);
            }
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._rightbullBg = null;
         this._huawen = null;
         this._leftBorderbg = null;
         this._rightBg = null;
         this._wantStrongList = null;
         if(Boolean(this._currentContentView))
         {
            ObjectUtils.disposeObject(this._currentContentView);
            this._currentContentView = null;
         }
         super.dispose();
      }
   }
}

