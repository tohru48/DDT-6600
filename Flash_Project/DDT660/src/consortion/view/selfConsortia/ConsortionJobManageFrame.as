package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaDutyInfo;
   import consortion.event.ConsortionEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class ConsortionJobManageFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _textBG:ScaleBitmapImage;
      
      private var _cancel:TextButton;
      
      private var _list:VBox;
      
      private var _items:Vector.<JobManageItem>;
      
      private var _jobManager:FilterFrameText;
      
      private var _limits:FilterFrameText;
      
      private var _textArea:FilterFrameText;
      
      private var _dottedline:MutipleImage;
      
      public function ConsortionJobManageFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaRightsFrame.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.bg");
         this._dottedline = ComponentFactory.Instance.creatComponentByStylename("consortion.dottedline");
         this._textBG = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionJobManageFrame.textAreaBG");
         this._jobManager = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManageText");
         this._jobManager.text = LanguageMgr.GetTranslation("consortion.ConsortionJobManageFrame.jobManageText");
         this._limits = ComponentFactory.Instance.creatComponentByStylename("consortion.limitsText");
         this._limits.text = LanguageMgr.GetTranslation("consortion.ConsortionJobManageFrame.limitsText");
         this._textArea = ComponentFactory.Instance.creatComponentByStylename("ConsortionJobManageFrame.limitsText");
         this._list = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.list");
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("consortion.jobManage.cancel");
         addToContent(this._bg);
         addToContent(this._dottedline);
         addToContent(this._textBG);
         addToContent(this._jobManager);
         addToContent(this._limits);
         addToContent(this._textArea);
         addToContent(this._list);
         addToContent(this._cancel);
         this._cancel.text = LanguageMgr.GetTranslation("close");
         this._items = new Vector.<JobManageItem>(5);
         this.setDataList(ConsortionModelControl.Instance.model.dutyList);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__cancelHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.DUTY_LIST_CHANGE,this.__dutyListChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__cancelHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.DUTY_LIST_CHANGE,this.__dutyListChange);
         for(var i:int = 0; i < 5; i++)
         {
            if(Boolean(this._items[i]))
            {
               this._items[i].removeEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            }
         }
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __cancelHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __dutyListChange(event:ConsortionEvent) : void
      {
         this.setDataList(ConsortionModelControl.Instance.model.dutyList);
      }
      
      private function setDataList(list:Vector.<ConsortiaDutyInfo>) : void
      {
         var i:int = 0;
         this.clearList();
         if(Boolean(list))
         {
            for(i = 0; i < list.length; i++)
            {
               this._items[i] = new JobManageItem();
               this._items[i].dutyInfo = list[i];
               this._items[i].name = String(i);
               this._items[i].addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
               this._list.addChild(this._items[i]);
            }
         }
         this._textArea.text = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text");
      }
      
      private function clearList() : void
      {
         this._list.disposeAllChildren();
         for(var i:int = 0; i < 5; i++)
         {
            this._items[i] = null;
         }
      }
      
      private function __itemClickHandler(event:MouseEvent) : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            if(event.currentTarget != this._items[i])
            {
               this._items[i].selected = false;
               this._items[i].editable = false;
            }
            else
            {
               this._items[i].selected = true;
               this._textArea.text = this.setText(i + 1);
            }
         }
      }
      
      private function setText(type:int) : String
      {
         var str:String = "";
         switch(type)
         {
            case 1:
               str = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text1");
               break;
            case 2:
               str = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text2");
               break;
            case 3:
               str = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text3");
               break;
            case 4:
               str = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text4");
               break;
            case 5:
               str = LanguageMgr.GetTranslation("tank.ConsortionJobManageFrame.limitsText.text4");
         }
         return str;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearList();
         super.dispose();
         this._bg = null;
         this._dottedline = null;
         this._textBG = null;
         this._jobManager = null;
         this._limits = null;
         this._textArea = null;
         this._cancel = null;
         this._list = null;
         this._items = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

