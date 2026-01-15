package hall.tasktrack
{
   import com.greensock.TweenLite;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class HallTaskTrackMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _bg2:Bitmap;
      
      private var _taskBtn:SimpleBitmapButton;
      
      private var _moveInBtn:SimpleBitmapButton;
      
      private var _moveOutBtn:SimpleBitmapButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _curTaskBtn:SelectedButton;
      
      private var _canGetBtn:SelectedButton;
      
      private var _listView:HallTaskTrackListView;
      
      private var _canGetListView:HallTaskCanGetListView;
      
      private var _taskTrackEffectMovie:MovieClip;
      
      public function HallTaskTrackMainView(npcBtn:BaseButton)
      {
         super();
         this.x = 803;
         this.y = 250;
         UIModuleLoader.Instance.addUIModlue(UIModuleTypes.QUEST);
         this.initView(npcBtn);
         this.initEvent();
         this.setInOutVisible(true);
         this._btnGroup.selectIndex = 0;
         this.judgeSelectShow(null);
      }
      
      private function judgeSelectShow(event:Event) : void
      {
         if(this._listView.isEmpty() && !this._canGetListView.isEmpty())
         {
            this._btnGroup.selectIndex = 1;
         }
         else if(!this._listView.isEmpty() && this._canGetListView.isEmpty())
         {
            this._btnGroup.selectIndex = 0;
         }
         else if(this._listView.isEmpty() && this._canGetListView.isEmpty())
         {
            this._btnGroup.selectIndex = 0;
         }
      }
      
      private function initView(npcBtn:BaseButton) : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.taskTrack.viewBg");
         this._bg2 = ComponentFactory.Instance.creatBitmap("asset.hall.taskTrack.viewBg2");
         this._bg.visible = false;
         this._bg2.visible = false;
         this._taskBtn = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.taskOpenBtn");
         this._taskTrackEffectMovie = ComponentFactory.Instance.creat("asset.hall.taskTrackEffectMovie");
         this._taskTrackEffectMovie.mouseChildren = false;
         this._taskTrackEffectMovie.mouseEnabled = false;
         this._taskTrackEffectMovie.x = 4;
         this._taskTrackEffectMovie.y = -2;
         this.showTaskEffect(TaskManager.instance.isTaskHightLight);
         this._moveInBtn = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.moveInBtn");
         this._moveOutBtn = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.moveOutBtn");
         this._curTaskBtn = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.curTaskBtn");
         this._canGetBtn = ComponentFactory.Instance.creatComponentByStylename("hall.taskTrack.canGetBtn");
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._curTaskBtn);
         this._btnGroup.addSelectItem(this._canGetBtn);
         this._listView = new HallTaskTrackListView();
         this._listView.visible = false;
         this._canGetListView = new HallTaskCanGetListView(npcBtn);
         this._canGetListView.visible = false;
         addChild(this._bg);
         addChild(this._bg2);
         addChild(this._taskBtn);
         this._taskBtn.addChild(this._taskTrackEffectMovie);
         addChild(this._moveInBtn);
         addChild(this._moveOutBtn);
         addChild(this._curTaskBtn);
         addChild(this._canGetBtn);
         addChild(this._listView);
         addChild(this._canGetListView);
      }
      
      private function initEvent() : void
      {
         this._taskBtn.addEventListener(MouseEvent.CLICK,this.taskClickHandler,false,0,true);
         this._moveInBtn.addEventListener(MouseEvent.CLICK,this.moveInClickHandler,false,0,true);
         this._moveOutBtn.addEventListener(MouseEvent.CLICK,this.moveOutClickHandler,false,0,true);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler,false,0,true);
         this._curTaskBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         this._canGetBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         this._listView.addEventListener(Event.CHANGE,this.judgeSelectShow,false,0,true);
         this._canGetListView.addEventListener(Event.CHANGE,this.judgeSelectShow,false,0,true);
         TaskManager.instance.addEventListener(TaskManager.SHOW_TASK_HIGHTLIGHT,this.__showTaskHightLight);
         TaskManager.instance.addEventListener(TaskManager.HIDE_TASK_HIGHTLIGHT,this.__hideTaskHightLight);
      }
      
      private function __changeHandler(event:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._listView.visible = true;
               this._canGetListView.visible = false;
               this._bg.visible = true;
               this._bg2.visible = false;
               break;
            case 1:
               this._listView.visible = false;
               this._canGetListView.visible = true;
               this._bg.visible = false;
               this._bg2.visible = true;
         }
      }
      
      private function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function taskClickHandler(event:MouseEvent) : void
      {
         TaskManager.instance.switchVisible();
      }
      
      private function moveOutClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(false);
         TweenLite.to(this,0.5,{"x":1002});
      }
      
      private function setInOutVisible(isOut:Boolean) : void
      {
         this._moveOutBtn.visible = isOut;
         this._moveInBtn.visible = !isOut;
      }
      
      private function moveInClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(true);
         TweenLite.to(this,0.5,{"x":801});
      }
      
      protected function __showTaskHightLight(event:Event) : void
      {
         this.showTaskEffect(true);
      }
      
      protected function __hideTaskHightLight(event:Event) : void
      {
         this.showTaskEffect(false);
      }
      
      private function showTaskEffect(show:Boolean) : void
      {
         if(show)
         {
            this._taskTrackEffectMovie.play();
            this._taskTrackEffectMovie.visible = true;
         }
         else
         {
            this._taskTrackEffectMovie.stop();
            this._taskTrackEffectMovie.visible = false;
         }
      }
      
      private function removeEvent() : void
      {
         this._taskBtn.removeEventListener(MouseEvent.CLICK,this.taskClickHandler);
         this._moveInBtn.removeEventListener(MouseEvent.CLICK,this.moveInClickHandler);
         this._moveOutBtn.removeEventListener(MouseEvent.CLICK,this.moveOutClickHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._curTaskBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._canGetBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._listView.removeEventListener(Event.CHANGE,this.judgeSelectShow);
         this._canGetListView.removeEventListener(Event.CHANGE,this.judgeSelectShow);
         TaskManager.instance.removeEventListener(TaskManager.SHOW_TASK_HIGHTLIGHT,this.__showTaskHightLight);
         TaskManager.instance.removeEventListener(TaskManager.HIDE_TASK_HIGHTLIGHT,this.__hideTaskHightLight);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._bg2 = null;
         this._taskBtn = null;
         this._moveInBtn = null;
         this._moveOutBtn = null;
         this._btnGroup = null;
         this._curTaskBtn = null;
         this._canGetBtn = null;
         this._listView = null;
         this._canGetListView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

