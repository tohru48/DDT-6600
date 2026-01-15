package lightRoad.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import lightRoad.Item.GiftItem;
   import lightRoad.data.LightRoadPackageType;
   import lightRoad.info.LightCartoonInfo;
   import lightRoad.info.LightGiftInfo;
   import lightRoad.manager.LightRoadManager;
   
   public class MainFrame extends Frame
   {
      
      private var _helpBtn:BaseButton;
      
      private var _Bg:Bitmap;
      
      private var _giftItem:Vector.<GiftItem>;
      
      private var _ThingsBox:Sprite;
      
      private var _dayShowText:FilterFrameText;
      
      private var _mC12:MovieClip;
      
      private var _mC34:MovieClip;
      
      private var _mC56:MovieClip;
      
      private var _mC78:MovieClip;
      
      private var _mC89:MovieClip;
      
      private var _mC1011:MovieClip;
      
      private var _mC1213:MovieClip;
      
      private var _mC17:MovieClip;
      
      private var _cartoon:Vector.<LightCartoonInfo>;
      
      public function MainFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initText();
         this.upFrameDataShow();
      }
      
      private function initView() : void
      {
         this._Bg = ComponentFactory.Instance.creatBitmap("asset.lightroad.swf.backGround.png");
         this._helpBtn = ComponentFactory.Instance.creat("lightroad.help.btn");
         this._dayShowText = ComponentFactory.Instance.creatComponentByStylename("lightRoad.gift.DayTxt");
         addToContent(this._Bg);
         this._ThingsBox = new Sprite();
         addToContent(this._ThingsBox);
         addToContent(this._helpBtn);
         addToContent(this._dayShowText);
      }
      
      private function initText() : void
      {
         titleText = LanguageMgr.GetTranslation("lightRoad.MainFrame.TitleText");
      }
      
      private function upDayShowText() : void
      {
         this._dayShowText.text = LanguageMgr.GetTranslation("lightRoad.MainFrame.DayText") + " " + LightRoadManager.instance.model.ActivityStartTime + " - " + LightRoadManager.instance.model.ActivityEndTime;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__createHelpFrame);
         LightRoadManager.instance.addEventListener(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,this.__dealWhithLightRoadEvent);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__createHelpFrame);
         LightRoadManager.instance.removeEventListener(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,this.__dealWhithLightRoadEvent);
      }
      
      private function __dealWhithLightRoadEvent(e:CrazyTankSocketEvent) : void
      {
         var cmd:int = e._cmd;
         switch(cmd)
         {
            case LightRoadPackageType.UPMAINFRAMEDATA:
               this.upFrameDataShow();
         }
      }
      
      private function upFrameDataShow() : void
      {
         this.checkCartoon();
         this.initGiftItem();
         this.upDayShowText();
      }
      
      private function checkCartoon() : void
      {
         this.removeAllCartoon();
         var i:int = 0;
         var len1:int = 0;
         var j:int = 0;
         var len2:int = 0;
         var addCartoon:Boolean = false;
         var space:int = 0;
         len1 = int(LightRoadManager.instance.model.pointGroup.length);
         for(i = 0; i < len1; i++)
         {
            len2 = int(LightRoadManager.instance.model.pointGroup[i][1].length);
            space = LightRoadManager.instance.model.pointGroup[i][0] - 1;
            if(LightRoadManager.instance.model.thingsType[space] == 0)
            {
               addCartoon = true;
               for(j = 0; j < len2; j++)
               {
                  space = LightRoadManager.instance.model.pointGroup[i][1][j] - 1;
                  if(LightRoadManager.instance.model.thingsType[space] == 0)
                  {
                     addCartoon = false;
                     break;
                  }
               }
               if(addCartoon)
               {
                  this.createCartoon(String(LightRoadManager.instance.model.pointGroup[i][0]));
               }
            }
         }
      }
      
      private function createCartoon(type:String) : void
      {
         if(this._cartoon == null)
         {
            this._cartoon = new Vector.<LightCartoonInfo>();
         }
         var temp:LightCartoonInfo = new LightCartoonInfo(type);
         this._cartoon.push(temp);
         addToContent(temp.MC);
      }
      
      private function removeAllCartoon() : void
      {
         var temp:LightCartoonInfo = null;
         if(Boolean(this._cartoon))
         {
            while(Boolean(this._cartoon.length))
            {
               temp = this._cartoon[0] as LightCartoonInfo;
               temp.dispose();
               this._cartoon.shift();
            }
         }
      }
      
      private function initGiftItem() : void
      {
         var i:int = 0;
         var tempInfo:LightGiftInfo = null;
         var item:GiftItem = null;
         var len:int = 0;
         i = 0;
         if(this._giftItem == null)
         {
            this._giftItem = new Vector.<GiftItem>();
            len = int(LightRoadManager.instance.model.thingsArray.length);
            i = 0;
            while(true)
            {
               if(i < len)
               {
                  if(LightRoadManager.instance.model.thingsArray[i] != undefined)
                  {
                     continue;
                  }
               }
               item = new GiftItem(i);
               item.x = LightRoadManager.instance.model.thingsXYArray[i][0];
               item.y = LightRoadManager.instance.model.thingsXYArray[i][1];
               tempInfo = LightRoadManager.instance.model.thingsArray[i] as LightGiftInfo;
               item.initItemCell(tempInfo);
               this._giftItem.push(item);
               this._ThingsBox.addChild(item);
               i++;
            }
         }
         else
         {
            len = int(this._giftItem.length);
            for(i = 0; i < len; i++)
            {
               this._giftItem[i].upData();
            }
         }
      }
      
      private function removeGiftItem() : void
      {
         while(Boolean(this._giftItem.length))
         {
            ObjectUtils.disposeObject(this._giftItem[0]);
            this._giftItem.shift();
         }
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,null,LightRoadPackageType.CLOSEMAINFRAME));
         }
      }
      
      private function __createHelpFrame(evt:MouseEvent) : void
      {
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,null,LightRoadPackageType.OPENHELPRAME));
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeGiftItem();
         this.removeAllCartoon();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         this._ThingsBox = null;
         this._Bg = null;
         this._helpBtn = null;
      }
   }
}

