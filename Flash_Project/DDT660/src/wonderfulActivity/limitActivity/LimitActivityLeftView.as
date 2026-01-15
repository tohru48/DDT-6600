package wonderfulActivity.limitActivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityCellVo;
   import wonderfulActivity.event.WonderfulActivityEvent;
   
   public class LimitActivityLeftView extends Sprite implements Disposeable
   {
      
      private var _bg:MovieClip;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _vbox:VBox;
      
      private var _unitDic:Dictionary;
      
      private var _rightFun:Function;
      
      private var selectedUnitId:String = "";
      
      public function LimitActivityLeftView()
      {
         super();
         this.initView();
      }
      
      public function setRightView(fun:Function) : void
      {
         this._rightFun = fun;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("wonderful.limitActivity.LargeBackgroundBg");
         addChild(this._bg);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderful.limitActivity.leftScrollpanel");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.vbox");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
         this._scrollPanel.invalidateViewport();
         this._unitDic = new Dictionary();
      }
      
      public function setData(arr:Array) : void
      {
         var vo:ActivityCellVo = null;
         var leftUnit:LimitActivityLeftUnit = null;
         var canGetReward:Boolean = false;
         for(var i:int = 0; i < arr.length; i++)
         {
            vo = arr[i] as ActivityCellVo;
            leftUnit = this._unitDic[vo.id];
            if(leftUnit == null)
            {
               leftUnit = new LimitActivityLeftUnit(vo.id,vo.activityName);
               leftUnit.addEventListener(WonderfulActivityEvent.SELECTED_CHANGE,this.refreshView);
               this._vbox.addChild(leftUnit);
               this._unitDic[vo.id] = leftUnit;
            }
            canGetReward = Boolean(WonderfulActivityManager.Instance.stateDic[vo.viewType]);
            leftUnit.showCanGetReward(canGetReward);
         }
         if(this.selectedUnitId == "" && arr.length > 0)
         {
            this.selectedUnitId = arr[0].id;
            if(this._rightFun != null)
            {
               this._rightFun(this.selectedUnitId);
               if(Boolean(this._unitDic[this.selectedUnitId]))
               {
                  this._unitDic[this.selectedUnitId].selected = true;
               }
            }
         }
         this._vbox.refreshChildPos();
         this._scrollPanel.invalidateViewport();
         if(WonderfulActivityManager.Instance.selectId != "" && Boolean(this._unitDic[WonderfulActivityManager.Instance.selectId]))
         {
            (this._unitDic[WonderfulActivityManager.Instance.selectId] as LimitActivityLeftUnit).dispatchEvent(new WonderfulActivityEvent(WonderfulActivityEvent.SELECTED_CHANGE));
            WonderfulActivityManager.Instance.selectId = "";
         }
      }
      
      private function refreshView(event:WonderfulActivityEvent) : void
      {
         var obj:LimitActivityLeftUnit = null;
         var selectedUnit:LimitActivityLeftUnit = null;
         for each(obj in this._unitDic)
         {
            obj.selected = false;
         }
         selectedUnit = event.target as LimitActivityLeftUnit;
         selectedUnit.selected = true;
         this.selectedUnitId = selectedUnit.id;
         if(this._rightFun != null)
         {
            this._rightFun(this.selectedUnitId);
         }
         this._vbox.arrange();
         this._scrollPanel.invalidateViewport();
      }
      
      private function removeEvent() : void
      {
         var obj:LimitActivityLeftUnit = null;
         for each(obj in this._unitDic)
         {
            obj.removeEventListener(WonderfulActivityEvent.SELECTED_CHANGE,this.refreshView);
         }
      }
      
      public function dispose() : void
      {
         var view:LimitActivityLeftUnit = null;
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.stop();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._scrollPanel))
         {
            ObjectUtils.disposeAllChildren(this._scrollPanel);
            ObjectUtils.disposeObject(this._scrollPanel);
            this._scrollPanel = null;
         }
         if(Boolean(this._unitDic))
         {
            for each(view in this._unitDic)
            {
               ObjectUtils.disposeObject(view);
               view = null;
            }
         }
         this._unitDic = null;
      }
   }
}

