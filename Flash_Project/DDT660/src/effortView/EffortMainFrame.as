package effortView
{
   import bagAndInfo.info.PlayerInfoEffortHonorView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.EffortManager;
   import effortView.leftView.EffortTaskView;
   import effortView.rightView.EffortPullComboBox;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class EffortMainFrame extends Sprite implements Disposeable
   {
      
      private var _effortPannelView:EffortPannelView;
      
      private var _controller:EffortController;
      
      private var _effortTaskView:EffortTaskView;
      
      private var _effortPullComboBox:EffortPullComboBox;
      
      private var _playerInfoEffortHonorView:PlayerInfoEffortHonorView;
      
      private var _comboBoxBg:Bitmap;
      
      public function EffortMainFrame()
      {
         super();
         this.initContent();
         this.initEvent();
      }
      
      private function initContent() : void
      {
         var pos2:Point = null;
         var pos3:Point = null;
         var pos:Point = null;
         this._controller = new EffortController();
         this._controller.isSelf = EffortManager.Instance.isSelf;
         this._controller.currentViewType = 0;
         this._effortPannelView = new EffortPannelView(this._controller);
         addChild(this._effortPannelView);
         this._effortPullComboBox = new EffortPullComboBox(this._controller);
         addChild(this._effortPullComboBox);
         this._comboBoxBg = ComponentFactory.Instance.creatBitmap("asset.Effort.comboBoxBg");
         if(EffortManager.Instance.isSelf)
         {
            this._effortPullComboBox.visible = false;
            this._playerInfoEffortHonorView = new PlayerInfoEffortHonorView();
            pos3 = ComponentFactory.Instance.creatCustomObject("effortView.EffortMainFrame.EffortHonorViewPos");
            this._playerInfoEffortHonorView.x = pos3.x;
            this._playerInfoEffortHonorView.y = pos3.y;
            addChild(this._playerInfoEffortHonorView);
         }
         else
         {
            this._effortPullComboBox.visible = false;
            this._comboBoxBg.visible = false;
         }
         if(EffortManager.Instance.isSelf)
         {
            this._effortTaskView = new EffortTaskView();
            pos = ComponentFactory.Instance.creatCustomObject("effortView.EffortTaskView.EffortTaskViewPos");
            this._effortTaskView.x = pos.x;
            this._effortTaskView.y = pos.y;
            addChild(this._effortTaskView);
         }
         pos2 = ComponentFactory.Instance.creatCustomObject("effortView.EffortView.EffortViewPos");
         this.x = pos2.x;
         this.y = pos2.y;
      }
      
      private function initEvent() : void
      {
         this._controller.addEventListener(Event.CHANGE,this.__rightChange);
      }
      
      private function __rightChange(evt:Event) : void
      {
         if(this._controller.currentRightViewType == 0)
         {
            if(!EffortManager.Instance.isSelf)
            {
               this._comboBoxBg.visible = false;
            }
            if(Boolean(this._effortPullComboBox))
            {
               this._effortPullComboBox.visible = false;
            }
            if(Boolean(this._playerInfoEffortHonorView))
            {
               this._playerInfoEffortHonorView.visible = true;
            }
         }
         else
         {
            if(Boolean(this._comboBoxBg))
            {
               this._comboBoxBg.visible = true;
            }
            if(Boolean(this._effortPullComboBox))
            {
               this._effortPullComboBox.visible = true;
            }
            if(Boolean(this._playerInfoEffortHonorView))
            {
               this._playerInfoEffortHonorView.visible = false;
            }
         }
      }
      
      public function dispose() : void
      {
         this._controller.removeEventListener(Event.CHANGE,this.__rightChange);
         if(Boolean(this._comboBoxBg))
         {
            ObjectUtils.disposeObject(this._comboBoxBg);
            this._comboBoxBg = null;
         }
         if(Boolean(this._effortPannelView) && Boolean(this._effortPannelView.parent))
         {
            this._effortPannelView.parent.removeChild(this._effortPannelView);
            this._effortPannelView.dispose();
            this._effortPannelView = null;
         }
         if(Boolean(this._effortTaskView) && Boolean(this._effortTaskView.parent))
         {
            this._effortTaskView.parent.removeChild(this._effortTaskView);
            this._effortTaskView.dispose();
            this._effortTaskView = null;
         }
         if(Boolean(this._effortPullComboBox) && Boolean(this._effortPullComboBox.parent))
         {
            this._effortPullComboBox.parent.removeChild(this._effortPullComboBox);
            this._effortPullComboBox.dispose();
            this._effortPullComboBox = null;
         }
         if(Boolean(this._playerInfoEffortHonorView))
         {
            this._playerInfoEffortHonorView.dispose();
            this._playerInfoEffortHonorView = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

