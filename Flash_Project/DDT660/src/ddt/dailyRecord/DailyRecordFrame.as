package ddt.dailyRecord
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class DailyRecordFrame extends Frame
   {
      
      private var _titleImg:Bitmap;
      
      private var _bg:MutipleImage;
      
      private var _vbox:VBox;
      
      private var _list:ScrollPanel;
      
      public function DailyRecordFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.dailyRecord.title");
         this._titleImg = ComponentFactory.Instance.creatBitmap("asset.core.dailyRecord.titleImg");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("dailyRecord.bg");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("dailyRecord.vbox");
         this._list = ComponentFactory.Instance.creatComponentByStylename("dailyRecord.panel");
         addToContent(this._titleImg);
         addToContent(this._bg);
         addToContent(this._list);
         this._list.setView(this._vbox);
         this.setData(DailyRecordControl.Instance.recordList);
      }
      
      private function setData(list:Vector.<DailiyRecordInfo>) : void
      {
         var item:DailyRecordItem = null;
         var count:int = 0;
         ObjectUtils.disposeAllChildren(this._vbox);
         for(var i:int = 0; i < list.length; i++)
         {
            if((list[i] as DailiyRecordInfo).type == 8)
            {
               count++;
            }
            else
            {
               item = new DailyRecordItem();
               this._vbox.addChild(item);
               item.setData(i - count,list[i]);
            }
         }
         this._list.invalidateViewport();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         DailyRecordControl.Instance.addEventListener(DailyRecordControl.RECORDLIST_IS_READY,this.__dataIsOk);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         DailyRecordControl.Instance.removeEventListener(DailyRecordControl.RECORDLIST_IS_READY,this.__dataIsOk);
      }
      
      private function __dataIsOk(event:Event) : void
      {
         this.setData(DailyRecordControl.Instance.recordList);
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         if(Boolean(this._titleImg))
         {
            ObjectUtils.disposeObject(this._titleImg);
         }
         this._titleImg = null;
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
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

