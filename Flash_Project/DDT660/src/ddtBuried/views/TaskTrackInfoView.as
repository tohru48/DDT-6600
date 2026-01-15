package ddtBuried.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TaskTrackInfoView extends Sprite
   {
      
      private var _treasure:ScaleFrameImage;
      
      private var _taskTitle:FilterFrameText;
      
      private var _taskInfo:FilterFrameText;
      
      private var _taskBtn:BaseButton;
      
      private var _func:Function;
      
      public function TaskTrackInfoView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.taskTitle = ComponentFactory.Instance.creatComponentByStylename("ddtburied.taskTitle");
         addChild(this.taskTitle);
         this.taskInfo = ComponentFactory.Instance.creatComponentByStylename("ddtburied.taskInfo");
         addChild(this.taskInfo);
         this._taskBtn = ComponentFactory.Instance.creatComponentByStylename("ddtburied.taskInfoBtn");
         addChild(this._taskBtn);
         this._treasure = ComponentFactory.Instance.creatComponentByStylename("ddtburied.treasure");
         addChild(this._treasure);
      }
      
      private function initEvent() : void
      {
         this._taskBtn.addEventListener(MouseEvent.CLICK,this.__textClickHandle);
      }
      
      protected function __textClickHandle(event:MouseEvent) : void
      {
         if(this.func != null)
         {
            this.func();
         }
      }
      
      private function removeEvent() : void
      {
         this._taskBtn.removeEventListener(MouseEvent.CLICK,this.__textClickHandle);
      }
      
      public function taskBtnRect() : void
      {
         this._taskBtn.width = this.taskInfo.width;
         this._taskBtn.height = this.taskInfo.height;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this.taskTitle))
         {
            this.taskTitle.dispose();
            this.taskTitle = null;
         }
         if(Boolean(this.taskInfo))
         {
            this.taskInfo.dispose();
            this.taskInfo = null;
         }
         if(Boolean(this._taskBtn))
         {
            this._taskBtn.dispose();
            this._taskBtn = null;
         }
         if(Boolean(this._treasure))
         {
            this._treasure.dispose();
            this._treasure = null;
         }
         if(this.func != null)
         {
            this.func = null;
         }
      }
      
      public function get taskTitle() : FilterFrameText
      {
         return this._taskTitle;
      }
      
      public function set taskTitle(value:FilterFrameText) : void
      {
         this._taskTitle = value;
      }
      
      public function get taskInfo() : FilterFrameText
      {
         return this._taskInfo;
      }
      
      public function set taskInfo(value:FilterFrameText) : void
      {
         this._taskInfo = value;
      }
      
      public function get func() : Function
      {
         return this._func;
      }
      
      public function set func(value:Function) : void
      {
         this._func = value;
      }
   }
}

