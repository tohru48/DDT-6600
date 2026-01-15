package effortView.rightView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortRewardInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.PlayerManager;
   import effortView.completeIcon.EffortCompleteIconView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class EffortFullItemView extends Sprite implements Disposeable
   {
      
      public static const ICON_SCALE:Number = 0.76;
      
      public static const POINTVIEW_SCALE:Number = 0.8;
      
      private var _info:EffortInfo;
      
      private var _isSelect:Boolean;
      
      private var _effortIcon:EffortIconView;
      
      private var _achievementPointView:AchievementPointView;
      
      private var _titleText:FilterFrameText;
      
      private var _detailText:FilterFrameText;
      
      private var _dateText:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _effortCompleteIconView:EffortCompleteIconView;
      
      public function EffortFullItemView(info:EffortInfo = null)
      {
         this._info = info;
         super();
         this.init();
      }
      
      private function init() : void
      {
         var pos:Point = null;
         var posII:Point = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.Effort.EffortFullItemBG");
         addChild(this._bg);
         this._titleText = ComponentFactory.Instance.creat("effortView.EffortScaleStrip.EffortFullItemText_01");
         addChild(this._titleText);
         this._detailText = ComponentFactory.Instance.creat("effortView.EffortScaleStrip.EffortFullItemText_02");
         addChild(this._detailText);
         this._dateText = ComponentFactory.Instance.creat("effortView.EffortScaleStrip.EffortFullItemText_03");
         addChild(this._dateText);
         this._effortIcon = new EffortIconView();
         this._effortIcon.x = 5;
         this._effortIcon.y = 8;
         this._effortIcon.scaleX = ICON_SCALE;
         this._effortIcon.scaleY = ICON_SCALE;
         addChild(this._effortIcon);
         this._achievementPointView = new AchievementPointView();
         pos = ComponentFactory.Instance.creatCustomObject("effortView.EffortFullView.EffortIconViewPos_0");
         this._achievementPointView.x = pos.x;
         this._achievementPointView.y = pos.y;
         this._achievementPointView.scaleX = POINTVIEW_SCALE;
         this._achievementPointView.scaleY = POINTVIEW_SCALE;
         addChild(this._achievementPointView);
         this._effortCompleteIconView = new EffortCompleteIconView();
         posII = ComponentFactory.Instance.creatCustomObject("effortView.EffortFullView.EffortIconViewPos_1");
         this._effortCompleteIconView.x = posII.x;
         this._effortCompleteIconView.y = posII.y;
         this._effortCompleteIconView.visible = false;
         addChild(this._effortCompleteIconView);
         this.update();
      }
      
      private function update() : void
      {
         var i:int = 0;
         if(!this._info)
         {
            return;
         }
         this._titleText.text = this.splitTitle();
         this._titleText.x = this._bg.width / 2 - this._titleText.width / 2;
         this._detailText.text = this._info.Detail;
         this._detailText.x = this._bg.width / 2 - this._detailText.width / 2;
         this._effortIcon.iconUrl = String(this._info.picId);
         this._achievementPointView.value = this._info.AchievementPoint;
         var date:Date = new Date();
         if(Boolean(this._info.CompleteStateInfo))
         {
            date = this._info.CompleteStateInfo.CompletedDate;
         }
         if(Boolean(this._info.CompleteStateInfo) && EffortManager.Instance.isSelf)
         {
            this._dateText.text = String(date.fullYear) + "/" + String(date.month + 1) + "/" + String(date.date);
         }
         else
         {
            this._dateText.text = "";
         }
         if(Boolean(this._info.effortRewardArray))
         {
            for(i = 0; i < this._info.effortRewardArray.length; i++)
            {
               if((this._info.effortRewardArray[i] as EffortRewardInfo).RewardType == 1)
               {
                  this._effortCompleteIconView.setInfo(this._info);
                  this._effortCompleteIconView.visible = true;
               }
            }
         }
      }
      
      private function splitTitle() : String
      {
         var strArray:Array = [];
         if(Boolean(this._info))
         {
            strArray = this._info.Title.split("/");
            if(strArray.length > 1 && strArray[1] != "")
            {
               if(PlayerManager.Instance.Self.Sex)
               {
                  return strArray[0];
               }
               return strArray[1];
            }
            return strArray[0];
         }
         return "";
      }
      
      public function dispose() : void
      {
         this._effortIcon.dispose();
         this._effortIcon = null;
         this._achievementPointView.dispose();
         this._achievementPointView = null;
         this._titleText.dispose();
         this._titleText = null;
         this._detailText.dispose();
         this._detailText = null;
         this._dateText.dispose();
         this._dateText = null;
         this._bg.bitmapData.dispose();
         this._bg = null;
         this._effortCompleteIconView.dispose();
         this._effortCompleteIconView = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

