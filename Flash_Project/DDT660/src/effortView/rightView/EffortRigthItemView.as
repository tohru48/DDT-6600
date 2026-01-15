package effortView.rightView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortQualificationInfo;
   import ddt.data.effort.EffortRewardInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.EffortManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import effortView.completeIcon.EffortCompleteIconView;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import road7th.data.DictionaryData;
   
   public class EffortRigthItemView extends Sprite implements Disposeable, IListCell
   {
      
      public static const EFFORT_ICON_POS:int = 5;
      
      public static const SCALESTRIP_POS_OFSET:int = 10;
      
      public static const MAX_HEIGHT:int = 110;
      
      public static const MIN_HEIGHT:int = 90;
      
      public static const BG03_MAX_HEIGHT_OFSET:int = 3;
      
      public static const HONOR_POS_OFSET:int = 3;
      
      protected var _info:EffortInfo;
      
      protected var _completeNextEffortArray:Array;
      
      protected var _isSelect:Boolean;
      
      protected var _scaleStrip:EffortScaleStrip;
      
      protected var _bg_01:ScaleBitmapImage;
      
      protected var _bg_02:ScaleBitmapImage;
      
      protected var _bg_03:ScaleBitmapImage;
      
      protected var _effortIcon:EffortIconView;
      
      protected var _maxHeight:int;
      
      protected var _minHeight:int;
      
      protected var _achievementPointView:AchievementPointView;
      
      protected var _title:FilterFrameText;
      
      protected var _titleII:FilterFrameText;
      
      protected var _detail:FilterFrameText;
      
      protected var _detailII:FilterFrameText;
      
      protected var _honor:TextField;
      
      protected var _honorII:TextField;
      
      protected var _date:FilterFrameText;
      
      protected var _iconContent:HBox;
      
      protected var _iconArray:Array;
      
      public function EffortRigthItemView()
      {
         super();
         this.init();
         this.initText();
         this.initEvent();
      }
      
      protected function init() : void
      {
         var icon:EffortCompleteIconView = null;
         this._bg_01 = ComponentFactory.Instance.creat("effortView.EffortRigthItemView.rightItemBg_01");
         addChild(this._bg_01);
         this._effortIcon = new EffortIconView();
         this._effortIcon.x = EFFORT_ICON_POS;
         this._effortIcon.y = EFFORT_ICON_POS;
         addChild(this._effortIcon);
         this._achievementPointView = new AchievementPointView();
         var pos:Point = ComponentFactory.Instance.creatCustomObject("effortView.EffortRigthItemView.achievementPointViewPos");
         this._achievementPointView.x = pos.x;
         this._achievementPointView.y = pos.y;
         addChild(this._achievementPointView);
         this._bg_02 = ComponentFactory.Instance.creat("effortView.EffortRigthItemView.rightItemBg_02");
         addChild(this._bg_02);
         this._bg_03 = ComponentFactory.Instance.creat("effortView.EffortRigthItemView.rightItemBg_03");
         addChild(this._bg_03);
         this._scaleStrip = new EffortScaleStrip(0);
         this._scaleStrip.setButtonMode(false);
         this._scaleStrip.x = this._bg_01.width / 2 - this._scaleStrip.width / 2 + SCALESTRIP_POS_OFSET;
         this._scaleStrip.y = this._bg_01.height - this._scaleStrip.height + SCALESTRIP_POS_OFSET;
         this._scaleStrip.visible = false;
         addChild(this._scaleStrip);
         this.buttonMode = true;
         this._iconContent = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortCompleteIconView.iconHBox");
         addChild(this._iconContent);
         this._iconArray = [];
         for(var i:int = 0; i < 7; i++)
         {
            icon = new EffortCompleteIconView();
            icon.visible = false;
            this._iconArray.push(icon);
            this._iconContent.addChild(icon);
         }
      }
      
      protected function updateScaleStrip() : void
      {
         var i:EffortQualificationInfo = null;
         if(!this._info.CanHide || this._info.CompleteStateInfo || !EffortManager.Instance.isSelf)
         {
            this._scaleStrip.visible = false;
            return;
         }
         if(this._info.EffortQualificationList.length > 1)
         {
            return;
         }
         var totalValue:int = 0;
         for each(i in this._info.EffortQualificationList)
         {
            totalValue = i.Condiction_Para2;
         }
         this._scaleStrip.setInfo(totalValue);
         this._scaleStrip.currentVlaue = this.getQualificationValue(this._info.EffortQualificationList);
      }
      
      protected function initMaxHeight() : void
      {
         if(EffortManager.Instance.isSelf)
         {
            if(this._info && this._info.CompleteStateInfo && this._info.IsOther)
            {
               this._info.maxHeight = MAX_HEIGHT;
            }
            else if(Boolean(this._info))
            {
               this._info.maxHeight = MIN_HEIGHT;
            }
         }
         else if(this._info && EffortManager.Instance.tempEffortIsComplete(this._info.ID) && this._info.IsOther)
         {
            this._info.maxHeight = MAX_HEIGHT;
         }
         else if(Boolean(this._info))
         {
            this._info.maxHeight = MIN_HEIGHT;
         }
      }
      
      protected function initText() : void
      {
         this._title = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortRigthItemView.EffortRigthItemText_01");
         addChild(this._title);
         this._titleII = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortRigthItemView.EffortRigthItemText_02");
         addChild(this._titleII);
         this._detail = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortRigthItemView.EffortRigthItemText_03");
         addChild(this._detail);
         this._detailII = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortRigthItemView.EffortRigthItemText_04");
         addChild(this._detailII);
         this._honor = ComponentFactory.Instance.creatCustomObject("EffortRigthItemView.EffortRigthItemText_05I");
         this._honor.defaultTextFormat = ComponentFactory.Instance.model.getSet("EffortRightItemTextTF_01");
         addChild(this._honor);
         this._honorII = ComponentFactory.Instance.creatCustomObject("EffortRigthItemView.EffortRigthItemText_06I");
         this._honorII.defaultTextFormat = ComponentFactory.Instance.model.getSet("EffortRightItemTextTF_02");
         addChild(this._honorII);
         this._honor.styleSheet = this._honorII.styleSheet = ChatFormats.styleSheet;
         this._honor.filters = this._honorII.filters = [ComponentFactory.Instance.model.getSet("GF_7")];
         this._honor.selectable = this._honorII.selectable = false;
         this._date = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortRigthItemView.EffortRigthItemText_07");
         addChild(this._date);
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__rigthItemOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__rigthItemOut);
         this._honor.addEventListener(TextEvent.LINK,this.__onTextClicked);
         this._honorII.addEventListener(TextEvent.LINK,this.__onTextClicked);
      }
      
      protected function __rigthItemOut(event:Event) : void
      {
         if(!this._info.isSelect)
         {
            this.setSelectState(true);
            this._bg_03.visible = false;
         }
      }
      
      protected function __rigthItemOver(event:Event) : void
      {
         this.setSelectState(false);
         this._bg_03.visible = true;
      }
      
      private function __onTextClicked(e:TextEvent) : void
      {
         var tipPos:Point = null;
         var props:Array = null;
         var itemInfo:ItemTemplateInfo = null;
         SoundManager.instance.play("008");
         var data:Object = {};
         var allProperties:Array = e.text.split("|");
         for(var i:int = 0; i < allProperties.length; i++)
         {
            if(Boolean(allProperties[i].indexOf(":")))
            {
               props = allProperties[i].split(":");
               data[props[0]] = props[1];
            }
         }
         if(int(data.clicktype) == ChatFormats.CLICK_GOODS)
         {
            tipPos = this._honor.localToGlobal(new Point(this._honor.mouseX,this._honor.mouseY));
            itemInfo = ItemManager.Instance.getTemplateById(data.templeteIDorItemID);
            itemInfo.BindType = data.isBind == "true" ? 0 : 1;
            this._showLinkGoodsInfo(itemInfo,tipPos);
         }
      }
      
      private function _showLinkGoodsInfo(info:ItemTemplateInfo, tipPos:Point) : void
      {
         var event:CaddyEvent = new CaddyEvent(EffortRightHonorView.GOODSCLICK);
         event.itemTemplateInfo = info;
         event.point = tipPos;
         dispatchEvent(event);
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__rigthItemOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__rigthItemOut);
         this._honor.removeEventListener(TextEvent.LINK,this.__onTextClicked);
         this._honorII.removeEventListener(TextEvent.LINK,this.__onTextClicked);
         if(Boolean(this._scaleStrip))
         {
            this._scaleStrip.dispose();
         }
         this._scaleStrip = null;
         if(Boolean(this._bg_01))
         {
            this._bg_01.dispose();
         }
         this._bg_01 = null;
         if(Boolean(this._bg_02))
         {
            this._bg_02.dispose();
         }
         this._bg_02 = null;
         if(Boolean(this._bg_03))
         {
            this._bg_03.dispose();
         }
         this._bg_03 = null;
         if(Boolean(this._effortIcon))
         {
            this._effortIcon.dispose();
         }
         this._effortIcon = null;
         if(Boolean(this._achievementPointView))
         {
            this._achievementPointView.dispose();
         }
         this._achievementPointView = null;
         if(Boolean(this._title))
         {
            this._title.dispose();
         }
         this._title = null;
         if(Boolean(this._titleII))
         {
            this._titleII.dispose();
         }
         this._titleII = null;
         if(Boolean(this._detail))
         {
            this._detail.dispose();
         }
         this._detail = null;
         if(Boolean(this._detailII))
         {
            this._detailII.dispose();
         }
         this._detailII = null;
         if(Boolean(this._honor))
         {
            ObjectUtils.disposeObject(this._honor);
         }
         this._honor = null;
         if(Boolean(this._honorII))
         {
            ObjectUtils.disposeObject(this._honorII);
         }
         this._honorII = null;
         if(Boolean(this._date))
         {
            this._date.dispose();
         }
         this._date = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
      }
      
      protected function updateSize() : void
      {
         if(this._info.isSelect)
         {
            this._bg_01.height = this._info.maxHeight;
            this._bg_02.height = this._info.maxHeight;
            this._bg_03.height = this._info.maxHeight - BG03_MAX_HEIGHT_OFSET;
         }
         else
         {
            this._bg_01.height = this._info.minHeight;
            this._bg_02.height = this._info.minHeight;
            this._bg_03.height = this._info.minHeight - BG03_MAX_HEIGHT_OFSET;
         }
         this.updateDisplayObjectPos();
      }
      
      protected function update() : void
      {
         this.initMaxHeight();
         this.updateSelectState();
         this.updateComponent();
         this.updateDisplayObjectPos();
         this.updateCompleteNextEffortIcon();
      }
      
      protected function updateCompleteNextEffortIcon() : void
      {
         if(EffortManager.Instance.isSelf)
         {
            this.updateSelfCompleteNextEffortIcon();
         }
         else
         {
            this.updateOtherCompleteNextEffortIcon();
         }
         this._iconContent.y = this._bg_01.x + this._bg_01.height - this._iconContent.height - 8;
      }
      
      private function updateSelfCompleteNextEffortIcon() : void
      {
         var j:int = 0;
         var i:int = 0;
         var k:int = 0;
         if(this._info.isSelect)
         {
            for(j = 0; j < 7; j++)
            {
               (this._iconArray[j] as EffortCompleteIconView).visible = false;
            }
            if(!this._info.IsOther)
            {
               return;
            }
            this._completeNextEffortArray = [];
            this._completeNextEffortArray = EffortManager.Instance.getCompleteNextEffort(EffortManager.Instance.getTopEffort(this._info));
            if(!this._completeNextEffortArray[0])
            {
               return;
            }
            for(i = 0; i < this._completeNextEffortArray.length; i++)
            {
               (this._iconArray[i] as EffortCompleteIconView).setInfo(this._completeNextEffortArray[i]);
               (this._iconArray[i] as EffortCompleteIconView).visible = true;
            }
         }
         else
         {
            for(k = 0; k < 7; k++)
            {
               (this._iconArray[k] as EffortCompleteIconView).visible = false;
            }
         }
      }
      
      private function updateOtherCompleteNextEffortIcon() : void
      {
         var j:int = 0;
         var i:int = 0;
         var k:int = 0;
         if(this._info.isSelect)
         {
            for(j = 0; j < 7; j++)
            {
               (this._iconArray[j] as EffortCompleteIconView).visible = false;
            }
            if(!this._info.IsOther)
            {
               return;
            }
            this._completeNextEffortArray = [];
            this._completeNextEffortArray = EffortManager.Instance.getTempCompleteNextEffort(EffortManager.Instance.getTempTopEffort(this._info));
            if(!this._completeNextEffortArray[0])
            {
               return;
            }
            for(i = 0; i < this._completeNextEffortArray.length; i++)
            {
               (this._iconArray[i] as EffortCompleteIconView).setInfo(this._completeNextEffortArray[i]);
               (this._iconArray[i] as EffortCompleteIconView).visible = true;
            }
         }
         else
         {
            for(k = 0; k < 7; k++)
            {
               (this._iconArray[k] as EffortCompleteIconView).visible = false;
            }
         }
      }
      
      protected function updateComponent() : void
      {
         this._title.text = this._titleII.text = EffortManager.Instance.splitTitle(this._info.Title);
         this._detail.text = this._detailII.text = this._info.Detail;
         var date:Date = new Date();
         if(Boolean(this._info.CompleteStateInfo))
         {
            date = this._info.CompleteStateInfo.CompletedDate;
         }
         if(Boolean(this._info.CompleteStateInfo) && EffortManager.Instance.isSelf)
         {
            this._date.text = String(date.fullYear) + "/" + String(date.month + 1) + "/" + String(date.date);
         }
         else
         {
            this._date.text = "";
         }
         this._effortIcon.iconUrl = String(this._info.picId);
         this._achievementPointView.value = this._info.AchievementPoint;
         this.updateScaleStrip();
      }
      
      protected function updateSelectState() : void
      {
         if(this._info.isSelect)
         {
            this.setSelectState(false);
            this._bg_01.height = this._info.maxHeight;
            this._bg_02.height = this._info.maxHeight;
            this._bg_03.height = this._info.maxHeight - BG03_MAX_HEIGHT_OFSET;
            if(this._scaleStrip && this._info.CanHide && !this._info.CompleteStateInfo && EffortManager.Instance.isSelf)
            {
               this._scaleStrip.visible = true;
            }
            this._bg_03.visible = true;
         }
         else
         {
            this.setSelectState(true);
            this._bg_01.height = this._info.minHeight;
            this._bg_02.height = this._info.minHeight;
            this._bg_03.height = this._info.minHeight - BG03_MAX_HEIGHT_OFSET;
            if(this._scaleStrip && this._info.CanHide && EffortManager.Instance.isSelf)
            {
               this._scaleStrip.visible = false;
            }
            this._bg_03.visible = false;
         }
      }
      
      protected function updateDisplayObjectPos() : void
      {
         if(Boolean(this._scaleStrip))
         {
            if(this._honor.text == "")
            {
               this._scaleStrip.y = this._bg_01.height - this._scaleStrip.height + HONOR_POS_OFSET;
            }
            else
            {
               this._scaleStrip.y = this._bg_01.height - this._scaleStrip.height - this._honor.height + SCALESTRIP_POS_OFSET;
               this._honor.y = this._bg_01.height - this._honor.height - HONOR_POS_OFSET;
               this._honorII.y = this._honor.y;
            }
         }
      }
      
      protected function honorName() : void
      {
         var data:ChatData = null;
         var i:int = 0;
         var resultHtmlText:String = null;
         var id:int = 0;
         var itemInfo:ItemTemplateInfo = null;
         var goods:String = null;
         if(Boolean(this._info) && Boolean(this._info.effortRewardArray))
         {
            data = new ChatData();
            for(i = 0; i < this._info.effortRewardArray.length; i++)
            {
               if((this._info.effortRewardArray[i] as EffortRewardInfo).RewardType == 1)
               {
                  data.htmlMessage = LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorName") + EffortManager.Instance.splitTitle((this._info.effortRewardArray[i] as EffortRewardInfo).RewardPara) + LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameII");
               }
               else if((this._info.effortRewardArray[i] as EffortRewardInfo).RewardType == 3)
               {
                  data.htmlMessage += LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameIII");
                  id = int(EffortManager.Instance.splitTitle((this._info.effortRewardArray[i] as EffortRewardInfo).RewardPara));
                  itemInfo = ItemManager.Instance.getTemplateById(id);
                  goods = ChatFormats.creatGoodTag("[" + itemInfo.Name + "]",ChatFormats.CLICK_GOODS,itemInfo.TemplateID,itemInfo.Quality,true,data);
                  data.htmlMessage += goods;
               }
            }
            resultHtmlText = "";
            resultHtmlText += Helpers.deCodeString(data.htmlMessage);
            this._honor.htmlText = "<a>" + resultHtmlText + "</a>";
            this._honorII.htmlText = "<a>" + resultHtmlText + "</a>";
         }
         else
         {
            this._honor.text = "";
            this._honorII.text = "";
            this._honor.visible = true;
            this._honor.visible = true;
         }
      }
      
      protected function getQualificationValue(dic:DictionaryData) : int
      {
         var info:EffortQualificationInfo = null;
         var _loc3_:int = 0;
         var _loc4_:* = dic;
         for each(info in _loc4_)
         {
            if(info.Condiction_Para2 > info.para2_currentValue)
            {
               return info.para2_currentValue;
            }
            return info.Condiction_Para2;
         }
         return 0;
      }
      
      protected function setSelectState(value:Boolean) : void
      {
         if(EffortManager.Instance.isSelf)
         {
            if(value)
            {
               if(!this._info.CompleteStateInfo)
               {
                  this.setTextVisible(false);
                  this._bg_02.visible = true;
               }
               else
               {
                  this.setTextVisible(true);
                  this._bg_02.visible = false;
               }
            }
            else if(!this._info.CompleteStateInfo)
            {
               this.setTextVisible(false);
               this._bg_02.visible = true;
            }
            else
            {
               this.setTextVisible(true);
               this._bg_02.visible = false;
            }
         }
         else if(value)
         {
            if(!EffortManager.Instance.tempEffortIsComplete(this._info.ID))
            {
               this.setTextVisible(false);
               this._bg_02.visible = true;
            }
            else
            {
               this.setTextVisible(true);
               this._bg_02.visible = false;
            }
         }
         else if(!EffortManager.Instance.tempEffortIsComplete(this._info.ID))
         {
            this.setTextVisible(false);
            this._bg_02.visible = true;
         }
         else
         {
            this.setTextVisible(true);
            this._bg_02.visible = false;
         }
      }
      
      protected function setTextVisible(value:Boolean) : void
      {
         this._title.visible = value;
         this._detail.visible = value;
         this._honor.visible = value;
         this._titleII.visible = !value;
         this._detailII.visible = !value;
         this._honorII.visible = !value;
         if(this._honor.htmlText == "")
         {
            this._honor.visible = false;
         }
         if(this._honorII.htmlText == "")
         {
            this._honorII.visible = false;
         }
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(value:*) : void
      {
         this._info = value;
         this.update();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

