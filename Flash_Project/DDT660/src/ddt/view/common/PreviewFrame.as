package ddt.view.common
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   
   public class PreviewFrame extends BaseAlerFrame implements Disposeable
   {
      
      private var _previewBitmap:DisplayObject;
      
      private var _scroll:ScrollPanel;
      
      private var _titleTxt:String;
      
      private var _previewBitmapStyle:String;
      
      private var _scrollStyle:String;
      
      private var _submitFunction:Function;
      
      private var _submitEnable:Boolean;
      
      private var _previewBmp:Bitmap;
      
      public function PreviewFrame()
      {
         super();
      }
      
      public function setStyle(titleTxt:String, previewBitmapStyle:String, scrollStyle:String, submitFunction:Function = null, submitEnable:Boolean = true, previewBitmap:Bitmap = null) : void
      {
         this._titleTxt = titleTxt;
         this._previewBitmapStyle = previewBitmapStyle;
         this._scrollStyle = scrollStyle;
         this._submitFunction = submitFunction;
         this._submitEnable = submitEnable;
         this._previewBmp = previewBitmap;
         this.initContent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function initContent() : void
      {
         if(this._previewBitmapStyle != "")
         {
            this._previewBitmap = ComponentFactory.Instance.creat(this._previewBitmapStyle);
         }
         else
         {
            this._previewBitmap = this._previewBmp;
         }
         this._scroll = ComponentFactory.Instance.creatComponentByStylename(this._scrollStyle);
         var alertInfo:AlertInfo = new AlertInfo(this._titleTxt,LanguageMgr.GetTranslation("ok"));
         alertInfo.autoDispose = false;
         alertInfo.moveEnable = false;
         alertInfo.showCancel = false;
         alertInfo.bottomGap = 8;
         alertInfo.submitLabel = LanguageMgr.GetTranslation("ok");
         alertInfo.customPos = ComponentFactory.Instance.creatCustomObject("academyCommon.myAcademy.framebuttonPos");
         info = alertInfo;
         this.submitButtonEnable = this._submitEnable;
         this._scroll.setView(this._previewBitmap);
         addToContent(this._scroll);
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
      }
      
      private function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._submitFunction != null && this._submitEnable)
               {
                  this._submitFunction();
               }
               this.dispose();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._previewBmp = null;
         if(Boolean(this._previewBitmap) && Boolean(this._previewBitmap.parent))
         {
            this._previewBitmap.parent.removeChild(this._previewBitmap);
         }
         if(Boolean(this._previewBitmap))
         {
            ObjectUtils.disposeObject(this._previewBitmap);
            this._previewBitmap = null;
         }
         if(Boolean(this._scroll))
         {
            this._scroll.dispose();
         }
         this._scroll = null;
      }
   }
}

