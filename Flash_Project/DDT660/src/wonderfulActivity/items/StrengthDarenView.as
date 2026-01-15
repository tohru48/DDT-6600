package wonderfulActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.views.IRightView;
   
   public class StrengthDarenView extends Sprite implements IRightView
   {
      
      private var _back:Bitmap;
      
      private var _activityTimeTxt:FilterFrameText;
      
      private var _activityInfo:GmActivityInfo;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusArr:Array;
      
      private var _strengthGradeArr:Array;
      
      private var _listStrengthItem:Vector.<StrengthDarenItem>;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      public function StrengthDarenView()
      {
         super();
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function init() : void
      {
         this.initView();
         this.initData();
         this.initViewWithData();
      }
      
      private function initViewWithData() : void
      {
         var item:StrengthDarenItem = null;
         if(!this._activityInfo)
         {
            return;
         }
         var timeArr:Array = [this._activityInfo.beginTime.split(" ")[0],this._activityInfo.endTime.split(" ")[0]];
         this._activityTimeTxt.text = timeArr[0] + "-" + timeArr[1];
         for(var i:int = 0; i < this._activityInfo.giftbagArray.length; i++)
         {
            item = new StrengthDarenItem(i % 2,this._activityInfo.activityId,this._activityInfo.giftbagArray[i],this._giftInfoDic[this._activityInfo.giftbagArray[i].giftbagId],this._statusArr);
            this._listStrengthItem.push(item);
            this._vbox.addChild(item);
         }
         this._scrollPanel.invalidateViewport();
      }
      
      private function initData() : void
      {
         var item:GmActivityInfo = null;
         var i:int = 0;
         var j:int = 0;
         this._strengthGradeArr = new Array();
         this._listStrengthItem = new Vector.<StrengthDarenItem>();
         for each(item in WonderfulActivityManager.Instance.activityData)
         {
            if(item.activityType == WonderfulActivityTypeData.STRENGTHEN_ACTIVITY && item.activityChildType == WonderfulActivityTypeData.STRENGTHEN_DAREN)
            {
               this._activityInfo = item;
               if(Boolean(WonderfulActivityManager.Instance.activityInitData[item.activityId]))
               {
                  this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[item.activityId]["giftInfoDic"];
                  this._statusArr = WonderfulActivityManager.Instance.activityInitData[item.activityId]["statusArr"];
               }
               for(i = 0; i < item.giftbagArray.length; i++)
               {
                  for(j = 0; j < item.giftbagArray[i].giftConditionArr.length; j++)
                  {
                     if(item.giftbagArray[i].giftConditionArr[j].conditionIndex == 0)
                     {
                        this._strengthGradeArr.push(item.giftbagArray[i].giftConditionArr[j].conditionValue);
                     }
                  }
               }
            }
         }
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.strength.back");
         addChild(this._back);
         this._activityTimeTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.activetimeTxt");
         addChild(this._activityTimeTxt);
         PositionUtils.setPos(this._activityTimeTxt,"wonderful.strengthdaren.activetime.pos");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.scrollpanel");
         this._vbox.spacing = 3;
         PositionUtils.setPos(this._scrollPanel,"wonderful.scrollPanel.pos");
         this._scrollPanel.height = 285;
         this._scrollPanel.setView(this._vbox);
         this._scrollPanel.invalidateViewport();
         addChild(this._scrollPanel);
      }
      
      public function setData(val:* = null) : void
      {
      }
      
      public function dispose() : void
      {
         for(var i:int = 0; i < this._listStrengthItem.length; i++)
         {
            ObjectUtils.disposeObject(this._listStrengthItem[i]);
            this._listStrengthItem[i] = null;
         }
         this._listStrengthItem = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
            this._vbox = null;
         }
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._activityTimeTxt);
         this._activityTimeTxt = null;
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}

