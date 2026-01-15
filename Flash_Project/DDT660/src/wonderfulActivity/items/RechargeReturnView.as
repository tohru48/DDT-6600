package wonderfulActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityTypeData;
   import wonderfulActivity.data.CanGetData;
   import wonderfulActivity.views.IRightView;
   
   public class RechargeReturnView extends Sprite implements IRightView
   {
      
      private var _goldLine:Bitmap;
      
      private var _tittle:Bitmap;
      
      private var _goldStone:Bitmap;
      
      private var _back:Bitmap;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _downBack:Bitmap;
      
      private var _limitTime:Bitmap;
      
      private var _type:int;
      
      private var _downTxt:FilterFrameText;
      
      private var _list:Vector.<ActivityTypeData>;
      
      private var _listRightItem:Vector.<RightListItem>;
      
      private var _timerTxt:FilterFrameText;
      
      private var _helpIcon:ScaleBitmapImage;
      
      private var _data:ActivityTypeData;
      
      private var startData:Date;
      
      private var endData:Date;
      
      private var nowdate:Date;
      
      private var _stateList:Vector.<CanGetData>;
      
      private var _isTimerOver:Boolean = false;
      
      public function RechargeReturnView(type:int = 0, data:ActivityTypeData = null)
      {
         super();
         this._type = type;
         this._data = data;
         this._stateList = WonderfulActivityManager.Instance._stateList;
      }
      
      public function setState(type:int, id:int) : void
      {
         var i:int = 0;
         var len:int = int(this._listRightItem.length);
         for(i = 0; i < len; i++)
         {
            if(this._listRightItem[i].getItemID() == id)
            {
               if(type > 0)
               {
                  this._listRightItem[i].initBtnState(1,type);
                  this._listRightItem[i].setBtnTxt(type);
               }
               else if(type == -1)
               {
                  this._listRightItem[i].initBtnState();
                  this.applyGray(this._listRightItem[i].getBtn());
               }
               else
               {
                  this._listRightItem[i].initBtnState(0);
                  this.applyGray(this._listRightItem[i].getBtn());
                  this._listRightItem[i].getBtn().mouseEnabled = false;
                  this._listRightItem[i].getBtn().mouseChildren = false;
               }
               break;
            }
         }
      }
      
      public function init() : void
      {
         var xiaofei:int = 0;
         this._goldLine = ComponentFactory.Instance.creat("wonderfulactivity.libao.goldLine");
         addChild(this._goldLine);
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.fame.back");
         addChild(this._back);
         this._goldStone = ComponentFactory.Instance.creat("wonderfulactivity.libao.gold");
         addChild(this._goldStone);
         this._downBack = ComponentFactory.Instance.creat("wonderfulactivity.right.back");
         addChild(this._downBack);
         this._timerTxt = ComponentFactory.Instance.creat("wonderfulactivity.right.timeTxt");
         addChild(this._timerTxt);
         this._downTxt = ComponentFactory.Instance.creat("wonderfulactivity.right.desTxt");
         addChild(this._downTxt);
         if(this._type == 1)
         {
            this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.rechargeTille1");
            this._list = WonderfulActivityManager.Instance.activityRechargeList;
            this._downTxt.text = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt7",WonderfulActivityManager.Instance.chongZhiScore);
         }
         else
         {
            this._helpIcon = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.helpImg");
            this._helpIcon.tipData = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt8_tip");
            addChild(this._helpIcon);
            this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.rechargeTille2");
            this._list = WonderfulActivityManager.Instance.activityExpList;
            xiaofei = WonderfulActivityManager.Instance.xiaoFeiScore;
            this._downTxt.text = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt8",WonderfulActivityManager.Instance.xiaoFeiScore);
         }
         addChild(this._tittle);
         this._limitTime = ComponentFactory.Instance.creat("wonderfulactivity.limit");
         addChild(this._limitTime);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.scrollpanel");
         this._scrollPanel.setView(this._vbox);
         this._scrollPanel.invalidateViewport();
         addChild(this._scrollPanel);
         this._listRightItem = new Vector.<RightListItem>();
         this.initItem();
         this.initTimer();
      }
      
      private function applyGray(child:DisplayObject) : void
      {
         var matrix:Array = new Array();
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0.3086,0.6094,0.082,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         this.applyFilter(child,matrix);
      }
      
      private function applyFilter(child:DisplayObject, matrix:Array) : void
      {
         var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
         var filters:Array = new Array();
         filters.push(filter);
         child.filters = filters;
      }
      
      private function initTimer() : void
      {
         this.startData = this._data.StartTime;
         this.endData = this._data.EndTime;
         this.rechargeTimerHander();
         WonderfulActivityManager.Instance.addTimerFun("recharge",this.rechargeTimerHander);
      }
      
      private function rechargeTimerHander() : void
      {
         this.nowdate = TimeManager.Instance.Now();
         var str:String = WonderfulActivityManager.Instance.getTimeDiff(this.endData,this.nowdate);
         this._timerTxt.text = str;
         if(str == "0")
         {
            this.dispose();
            WonderfulActivityManager.Instance.delTimerFun("recharge");
            SocketManager.Instance.out.sendWonderfulActivity(0,-1);
            WonderfulActivityManager.Instance.currView = "-1";
         }
      }
      
      private function initItem() : void
      {
         var j:int = 0;
         var type:int = 0;
         var item:RightListItem = null;
         var len:int = int(this._list.length);
         for(var i:int = 0; i < len; i++)
         {
            for(j = 0; j < this._stateList.length; j++)
            {
               if(this._list[i].ID == this._stateList[j].id)
               {
                  type = i % 2;
                  item = new RightListItem(type,this._list[i]);
                  if(this._stateList[j].num == 0)
                  {
                     item.initBtnState(0);
                     this.applyGray(item.getBtn());
                     item.getBtn().mouseEnabled = false;
                  }
                  else if(this._stateList[j].num == -1)
                  {
                     item.initBtnState();
                     this.applyGray(item.getBtn());
                     item.getBtn().mouseEnabled = false;
                  }
                  else if(this._stateList[j].num >= 1)
                  {
                     item.initBtnState(1,this._stateList[j].num);
                     item.setBtnTxt(this._stateList[j].num);
                  }
                  this._listRightItem.push(item);
                  this._vbox.addChild(item);
                  break;
               }
            }
         }
         this._scrollPanel.invalidateViewport();
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         WonderfulActivityManager.Instance.delTimerFun("recharge");
         while(Boolean(this.numChildren))
         {
            ObjectUtils.disposeObject(this.getChildAt(0));
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}

