package wonderfulActivity.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.event.WonderfulActivityEvent;
   
   public class ActivityLeftView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _unitList:Vector.<ActivityLeftUnitView>;
      
      private var tempArray:Array;
      
      private var _rightFun:Function;
      
      private var selectedUnitIndex:int;
      
      private var _isNewServerExist:Boolean = false;
      
      public function ActivityLeftView()
      {
         super();
         this.initView();
         this.selectedUnitIndex = -1;
      }
      
      public function setRightView(fun:Function) : void
      {
         this._rightFun = fun;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("wonderful.leftview.BG");
         addChild(this._bg);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderful.leftview.vbox");
         this._unitList = new Vector.<ActivityLeftUnitView>();
         addChild(this._vbox);
      }
      
      public function addUnitByType(arr:Array, type:int) : void
      {
         var leftUnit:ActivityLeftUnitView = this.getLeftUnitView(type);
         if(leftUnit == null)
         {
            leftUnit = new ActivityLeftUnitView(type);
            leftUnit.addEventListener(WonderfulActivityEvent.SELECTED_CHANGE,this.refreshView);
            this._vbox.addChild(leftUnit);
            this._unitList.push(leftUnit);
         }
         this.setBgHeight(leftUnit);
         leftUnit.setData(arr,this._rightFun);
         this._vbox.refreshChildPos();
      }
      
      private function setBgHeight(leftUnit:ActivityLeftUnitView) : void
      {
         if(this.isNewServerExist)
         {
            leftUnit.bg.height = 300;
            leftUnit.list.height = 280;
         }
         else
         {
            leftUnit.bg.height = 360;
            leftUnit.list.height = 340;
         }
      }
      
      public function checkNewServerExist() : void
      {
         var leftUnit:ActivityLeftUnitView = this.getLeftUnitView(3);
         if(!leftUnit)
         {
            return;
         }
         for(var i:int = 0; i < this._vbox.numChildren; i++)
         {
            if(this._vbox.getChildAt(i) == leftUnit)
            {
               this._vbox.removeChildAt(i);
               this._unitList[i].removeEventListener(WonderfulActivityEvent.SELECTED_CHANGE,this.refreshView);
               this._unitList.splice(this._unitList.indexOf(this._unitList[i]),1);
               ObjectUtils.disposeObject(leftUnit);
               leftUnit = null;
               break;
            }
         }
         this._vbox.refreshChildPos();
      }
      
      public function extendUnitView() : void
      {
         var k:int = 0;
         var i:int = 0;
         var tmp:int = 0;
         if(this.selectedUnitIndex < 0)
         {
            if(WonderfulActivityManager.Instance.isSkipFromHall)
            {
               k = 0;
               while(true)
               {
                  if(k <= this._unitList.length - 1)
                  {
                     if(!(this._unitList[k].type == WonderfulActivityManager.Instance.leftUnitViewType && this._unitList[k].getModelSize() > 0))
                     {
                        continue;
                     }
                     tmp = k;
                  }
                  tmp = 2;
                  k++;
               }
            }
            else
            {
               for(i = 0; i <= this._unitList.length - 1; i++)
               {
                  if(this._unitList[i].getModelSize() > 0)
                  {
                     tmp = i;
                     break;
                  }
               }
            }
         }
         else
         {
            if(this.selectedUnitIndex > this._unitList.length - 1)
            {
               this.selectedUnitIndex = 0;
            }
            tmp = this.selectedUnitIndex;
         }
         (this._unitList[tmp] as ActivityLeftUnitView).extendSelecteTheFirst();
         for(var j:int = 0; j <= this._unitList.length - 1; j++)
         {
            if(j != tmp)
            {
               (this._unitList[j] as ActivityLeftUnitView).unextendHandler();
            }
         }
         this._vbox.refreshChildPos();
      }
      
      private function getLeftUnitView(type:int) : ActivityLeftUnitView
      {
         for(var i:int = 0; i <= this._unitList.length - 1; i++)
         {
            if(type == this._unitList[i].type)
            {
               return this._unitList[i];
            }
         }
         return null;
      }
      
      private function refreshView(event:WonderfulActivityEvent) : void
      {
         var selectedUnit:ActivityLeftUnitView = event.target as ActivityLeftUnitView;
         for(var i:int = 0; i <= this._unitList.length - 1; i++)
         {
            if(this._unitList[i] == selectedUnit)
            {
               this.selectedUnitIndex = i;
            }
            else
            {
               this._unitList[i].unextendHandler();
            }
         }
         this._vbox.arrange();
      }
      
      private function removeEvent() : void
      {
         for(var i:int = 0; i <= this._unitList.length - 1; i++)
         {
            this._unitList[i].removeEventListener(WonderfulActivityEvent.SELECTED_CHANGE,this.refreshView);
         }
      }
      
      public function dispose() : void
      {
         var view:ActivityLeftUnitView = null;
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
         if(Boolean(this._unitList))
         {
            for each(view in this._unitList)
            {
               ObjectUtils.disposeObject(view);
               view = null;
            }
         }
         this._unitList = null;
      }
      
      public function get isNewServerExist() : Boolean
      {
         return this._isNewServerExist;
      }
      
      public function set isNewServerExist(value:Boolean) : void
      {
         this._isNewServerExist = value;
      }
   }
}

