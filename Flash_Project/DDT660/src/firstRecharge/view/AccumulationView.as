package firstRecharge.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LeavePageManager;
   import ddt.manager.SoundManager;
   import firstRecharge.items.FTextButton;
   import firstRecharge.items.PicItem;
   import firstRecharge.items.String8;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class AccumulationView extends Frame implements Disposeable
   {
      
      private var _treeImage:ScaleBitmapImage;
      
      private var _treeImage2:Scale9CornerImage;
      
      private var _pricePic:Bitmap;
      
      private var _picBack:Bitmap;
      
      private var _barBack:Bitmap;
      
      private var _libaoTxt:Bitmap;
      
      private var _daojishiTxt:Bitmap;
      
      private var _itemList:Vector.<PicItem>;
      
      private var _goodsContentList:Vector.<BagCell>;
      
      private var _selcetedBitMap:Bitmap;
      
      private var _iconStrList:Array = ["fristRecharge.level1","fristRecharge.level2","fristRecharge.level3","fristRecharge.level4","fristRecharge.level5","fristRecharge.level6"];
      
      private var _iconTxtStrList:Array = ["充值500点券","充值1000点券","充值2000点券","充值5000点券","充值10000点券","充值50000点券"];
      
      private var _txt1:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _txt3:FilterFrameText;
      
      private var _txt4:FilterFrameText;
      
      private var _txt5:FilterFrameText;
      
      private var _txt6:FilterFrameText;
      
      private var _txt7:FilterFrameText;
      
      private var _btn:FTextButton;
      
      private var _fengeLine:Bitmap;
      
      private var _goldLine:Bitmap;
      
      private var str8:String8;
      
      public function AccumulationView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         addEventListener(MouseEvent.CLICK,this.mouseClickHander);
      }
      
      private function uinitEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
         this._btn.removeEventListener(MouseEvent.CLICK,this.clickHander);
      }
      
      protected function _response(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var item:PicItem = null;
         var gItem:BagCell = null;
         this._itemList = new Vector.<PicItem>();
         this._goodsContentList = new Vector.<BagCell>();
         this._treeImage = ComponentFactory.Instance.creatComponentByStylename("accumulationView.scale9cornerImageTree");
         addToContent(this._treeImage);
         this._treeImage2 = ComponentFactory.Instance.creatComponentByStylename("accumulationView.scale9cornerImageTree2");
         addToContent(this._treeImage2);
         this._picBack = ComponentFactory.Instance.creatBitmap("fristRecharge.pic.back");
         addToContent(this._picBack);
         this._barBack = ComponentFactory.Instance.creatBitmap("fristRecharge.bar.back");
         addToContent(this._barBack);
         this._libaoTxt = ComponentFactory.Instance.creatBitmap("fristRecharge.libao.giftList");
         addToContent(this._libaoTxt);
         this._pricePic = ComponentFactory.Instance.creatBitmap("fristRecharge.libao.price");
         addToContent(this._pricePic);
         this._daojishiTxt = ComponentFactory.Instance.creatBitmap("fristRecharge.downtimes");
         addToContent(this._daojishiTxt);
         this._txt2 = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.txt2");
         this._txt2.text = "还要充值                 点券，您就能领取价值              点卷的礼包了！";
         addToContent(this._txt2);
         this._txt4 = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.txt4");
         this._txt4.text = "倒计时天数";
         addToContent(this._txt4);
         this._txt6 = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.txt6");
         this._txt6.text = "500";
         addToContent(this._txt6);
         this._txt7 = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.txt7");
         this._txt7.text = "8888";
         addToContent(this._txt7);
         this.str8 = new String8();
         this.str8.setNum("1234");
         addToContent(this.str8);
         titleText = "充值奖励";
         for(i = 0; i < 6; i++)
         {
            item = new PicItem();
            if(i == 0)
            {
               item.x = 25;
            }
            else
            {
               item.x = i * (item.width + 1) + 40;
            }
            item.y = 57;
            item.id = i;
            item.setTxtStr(this._iconTxtStrList[i]);
            item.addIcon(this._iconStrList[i]);
            addToContent(item);
            this._itemList.push(item);
         }
         for(var j:int = 0; j < 8; j++)
         {
            gItem = new BagCell(j);
            gItem.x = j * (gItem.width + 8) + 160;
            gItem.y = 233;
            addToContent(gItem);
            this._goodsContentList.push(gItem);
         }
         this._selcetedBitMap = ComponentFactory.Instance.creatBitmap("fristRecharge.selected");
         addToContent(this._selcetedBitMap);
         this._btn = new FTextButton("accumulationView.ftxtBtn","firstrecharge.txt5");
         this._btn.x = 300;
         this._btn.y = 390;
         this._btn.setTxt("前去充值");
         addToContent(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHander);
         this._fengeLine = ComponentFactory.Instance.creat("fristRecharge.libao.fengeLine");
         addToContent(this._fengeLine);
         this._goldLine = ComponentFactory.Instance.creat("fristRecharge.libao.gold");
         addToContent(this._goldLine);
      }
      
      protected function clickHander(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LeavePageManager.leaveToFillPath();
      }
      
      protected function mouseClickHander(event:MouseEvent) : void
      {
         if(event.target is PicItem)
         {
            switch(event.target.id)
            {
               case 0:
                  this.str8.setNum("288");
                  break;
               case 1:
                  this.str8.setNum("1788");
                  break;
               case 2:
                  this.str8.setNum("2298");
                  break;
               case 3:
                  this.str8.setNum("5268");
                  break;
               case 4:
                  this.str8.setNum("7288");
                  break;
               case 5:
                  this.str8.setNum("8888");
            }
            this._selcetedBitMap.x = event.target.x - 2;
            this._selcetedBitMap.y = event.target.y - 4;
         }
      }
      
      override public function dispose() : void
      {
         this.uinitEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

