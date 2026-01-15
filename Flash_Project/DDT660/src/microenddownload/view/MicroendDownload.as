package microenddownload.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LeavePageManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import microenddownload.MicroendDownloadAwardsManager;
   
   public class MicroendDownload extends Frame implements Disposeable
   {
      
      private var _btn:SimpleBitmapButton;
      
      private var _ttlOfBtn:Bitmap;
      
      private var _treeImage:ScaleBitmapImage;
      
      private var _treeImage2:Scale9CornerImage;
      
      private var _back:Bitmap;
      
      private var _bagCellList:Vector.<BagCell>;
      
      public function MicroendDownload()
      {
         super();
         this.initEvent();
         this.initView();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         SoundManager.instance.play("008");
         ObjectUtils.disposeObject(this);
      }
      
      private function initView() : void
      {
         var i:int = 0;
         this._treeImage = ComponentFactory.Instance.creatComponentByStylename("microendDownload.scale9cornerImageTree");
         addToContent(this._treeImage);
         this._treeImage2 = ComponentFactory.Instance.creatComponentByStylename("microendDownload.scale9cornerImageTree2");
         addToContent(this._treeImage2);
         this._back = ComponentFactory.Instance.creatBitmap("microend.detail");
         addToContent(this._back);
         titleText = "登录器礼包";
         this._bagCellList = new Vector.<BagCell>();
         var awardsInfoList:Vector.<ItemTemplateInfo> = MicroendDownloadAwardsManager.getInstance().getAwardsDetail();
         for(i = 0; i < awardsInfoList.length; i++)
         {
            this._bagCellList[i] = new BagCell(0,awardsInfoList[i]);
            this._bagCellList[i].setCount(MicroendDownloadAwardsManager.getInstance().getCount(i));
            this._bagCellList[i].x = 58 + i * 60;
            this._bagCellList[i].y = 256;
            addToContent(this._bagCellList[i]);
         }
         this._btn = ComponentFactory.Instance.creatComponentByStylename("microendDownload.ftxtBtn");
         addToContent(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.onMouseClicked);
      }
      
      protected function onMouseClicked(me:MouseEvent) : void
      {
         LeavePageManager.leaveToMicroendDownloadPath();
         this.close();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._ttlOfBtn);
         this._ttlOfBtn = null;
         ObjectUtils.disposeObject(this._treeImage);
         this._treeImage = null;
         ObjectUtils.disposeObject(this._treeImage2);
         this._treeImage2 = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         for(var i:int = 0; i < this._bagCellList.length; i++)
         {
            this._bagCellList[i].dispose();
            ObjectUtils.disposeObject(this._bagCellList.pop());
         }
         this._bagCellList.length = 0;
         this._bagCellList = null;
         super.dispose();
      }
   }
}

