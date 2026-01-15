package wonderfulActivity.newActivity.returnActivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import road7th.utils.DateUtils;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.views.IRightView;
   
   public class ReturnActivityView extends Sprite implements IRightView
   {
      
      private var _goldLine:Bitmap;
      
      private var _tittle:Bitmap;
      
      private var _goldStone:Bitmap;
      
      private var _back:Bitmap;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _downBack:Bitmap;
      
      private var _limitTime:Bitmap;
      
      private var _downTxt:FilterFrameText;
      
      private var _timerTxt:FilterFrameText;
      
      private var _helpIcon:ScaleBitmapImage;
      
      private var _rightItemList:Vector.<ReturnListItem>;
      
      private var type:int;
      
      private var actId:String;
      
      private var nowDate:Date;
      
      private var endDate:Date;
      
      private var _xmlData:GmActivityInfo;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusArr:Array;
      
      public function ReturnActivityView(type:int, actId:String)
      {
         this.type = type;
         this.actId = actId;
         super();
      }
      
      public function init() : void
      {
         this.initData();
         this.initView();
         this.initTimer();
      }
      
      private function initData() : void
      {
         this._rightItemList = new Vector.<ReturnListItem>();
         this._xmlData = WonderfulActivityManager.Instance.getActivityDataById(this.actId);
         this._giftInfoDic = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).giftInfoDic;
         this._statusArr = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).statusArr;
      }
      
      private function initView() : void
      {
         this._goldLine = ComponentFactory.Instance.creat("wonderfulactivity.libao.goldLine");
         addChild(this._goldLine);
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.fame.back");
         addChild(this._back);
         this._goldStone = ComponentFactory.Instance.creat("wonderfulactivity.libao.gold");
         addChild(this._goldStone);
         this._downBack = ComponentFactory.Instance.creat("wonderfulactivity.right.back");
         addChild(this._downBack);
         this._downTxt = ComponentFactory.Instance.creat("wonderfulactivity.right.desTxt");
         addChild(this._downTxt);
         if(this.type == 0)
         {
            this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.rechargeTille1");
            this._downTxt.text = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt7",this._statusArr[0].statusValue);
         }
         else
         {
            this._helpIcon = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.helpImg");
            this._helpIcon.tipData = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt8_tip");
            addChild(this._helpIcon);
            this._tittle = ComponentFactory.Instance.creat("wonderfulactivity.rechargeTille2");
            this._downTxt.text = LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt8",this._statusArr[0].statusValue);
         }
         addChild(this._tittle);
         this._limitTime = ComponentFactory.Instance.creat("wonderfulactivity.limit");
         addChild(this._limitTime);
         this._timerTxt = ComponentFactory.Instance.creat("wonderfulactivity.right.timeTxt");
         addChild(this._timerTxt);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.scrollpanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
         this.initItem();
      }
      
      private function initItem() : void
      {
         var item:ReturnListItem = null;
         if(!this._xmlData)
         {
            return;
         }
         var arr:Array = this._xmlData.giftbagArray;
         for(var i:int = 0; i <= arr.length - 1; i++)
         {
            item = new ReturnListItem(i % 2,this.actId);
            item.setData(this._xmlData.desc,arr[i]);
            this._rightItemList.push(item);
            this._vbox.addChild(item);
         }
         this._scrollPanel.invalidateViewport();
         this.refresh();
      }
      
      public function refresh() : void
      {
         this._giftInfoDic = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).giftInfoDic;
         for(var i:int = 0; i <= this._rightItemList.length - 1; i++)
         {
            (this._rightItemList[i] as ReturnListItem).setStatus(this._statusArr[0].statusValue,this._giftInfoDic);
         }
      }
      
      private function initTimer() : void
      {
         if(!this._xmlData)
         {
            return;
         }
         this.endDate = DateUtils.getDateByStr(this._xmlData.endTime);
         this.returnTimerHander();
         WonderfulActivityManager.Instance.addTimerFun("returnActivity",this.returnTimerHander);
      }
      
      private function returnTimerHander() : void
      {
         this.nowDate = TimeManager.Instance.Now();
         var str:String = WonderfulActivityManager.Instance.getTimeDiff(this.endDate,this.nowDate);
         if(Boolean(this._timerTxt))
         {
            this._timerTxt.text = str;
         }
         if(str == "0")
         {
            this.dispose();
            WonderfulActivityManager.Instance.delTimerFun("returnActivity");
            WonderfulActivityManager.Instance.currView = "-1";
         }
      }
      
      public function dispose() : void
      {
         WonderfulActivityManager.Instance.delTimerFun("returnActivity");
         ObjectUtils.disposeObject(this._goldLine);
         this._goldLine = null;
         ObjectUtils.disposeObject(this._tittle);
         this._tittle = null;
         ObjectUtils.disposeObject(this._goldStone);
         this._goldStone = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._downBack);
         this._downBack = null;
         ObjectUtils.disposeObject(this._limitTime);
         this._limitTime = null;
         ObjectUtils.disposeObject(this._downTxt);
         this._downTxt = null;
         ObjectUtils.disposeObject(this._timerTxt);
         this._timerTxt = null;
         ObjectUtils.disposeObject(this._helpIcon);
         this._helpIcon = null;
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
   }
}

