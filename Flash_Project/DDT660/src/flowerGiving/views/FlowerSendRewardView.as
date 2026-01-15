package flowerGiving.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flowerGiving.FlowerGivingManager;
   import flowerGiving.components.FlowerSendRewardItem;
   import flowerGiving.events.FlowerGivingEvent;
   import road7th.comm.PackageIn;
   
   public class FlowerSendRewardView extends Sprite implements Disposeable
   {
      
      private var _back:Bitmap;
      
      private var _titleTxt1:FilterFrameText;
      
      private var _titleTxt2:FilterFrameText;
      
      private var _titleTxt3:FilterFrameText;
      
      private var _myFlowerTitleTxt:FilterFrameText;
      
      private var _myFlowerNumTxt:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _listItem:Vector.<FlowerSendRewardItem>;
      
      private var dataArr:Array;
      
      public function FlowerSendRewardView()
      {
         super();
         this.initData();
         this.initView();
         this.addEvents();
      }
      
      private function initData() : void
      {
         this._listItem = new Vector.<FlowerSendRewardItem>();
         this.dataArr = FlowerGivingManager.instance.getDataByRewardMark(6);
         SocketManager.Instance.out.getFlowerRewardStatus();
      }
      
      private function initView() : void
      {
         var item:FlowerSendRewardItem = null;
         this._back = ComponentFactory.Instance.creat("flowerGiving.accumuGivingBack");
         addChild(this._back);
         this._titleTxt1 = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         addChild(this._titleTxt1);
         PositionUtils.setPos(this._titleTxt1,"flowerGiving.sendView.title1Pos");
         this._titleTxt1.text = LanguageMgr.GetTranslation("flowerGiving.sendView.title1Txt");
         this._titleTxt2 = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         addChild(this._titleTxt2);
         PositionUtils.setPos(this._titleTxt2,"flowerGiving.sendView.title2Pos");
         this._titleTxt2.text = LanguageMgr.GetTranslation("flowerGiving.sendView.title2Txt");
         this._titleTxt3 = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         addChild(this._titleTxt3);
         PositionUtils.setPos(this._titleTxt3,"flowerGiving.sendView.title3Pos");
         this._titleTxt3.text = LanguageMgr.GetTranslation("flowerGiving.sendView.title3Txt");
         this._myFlowerTitleTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.myFlowerTitleTxt");
         addChild(this._myFlowerTitleTxt);
         PositionUtils.setPos(this._myFlowerTitleTxt,"flowerGiving.sendView.myFlowerTitlePos");
         this._myFlowerTitleTxt.text = LanguageMgr.GetTranslation("flowerGiving.sendView.myFlowerTitle");
         this._myFlowerNumTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.myFlowerNumTxt");
         addChild(this._myFlowerNumTxt);
         PositionUtils.setPos(this._myFlowerNumTxt,"flowerGiving.sendView.myFlowerNumPos");
         this._myFlowerNumTxt.text = "999";
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("flowerSendView.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("flowerSendView.scrollpanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
         for(var i:int = 0; i <= this.dataArr.length - 1; i++)
         {
            item = new FlowerSendRewardItem(i);
            item.info = this.dataArr[i];
            this._listItem.push(item);
            this._vbox.addChild(item);
         }
         this._scrollPanel.invalidateViewport();
      }
      
      private function addEvents() : void
      {
         SocketManager.Instance.addEventListener(FlowerGivingEvent.REWARD_INFO,this.__updateRewardStatus);
         SocketManager.Instance.addEventListener(FlowerGivingEvent.GET_REWARD,this.__getRewardSuccess);
      }
      
      protected function __getRewardSuccess(event:FlowerGivingEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var isSuccess:Boolean = pkg.readBoolean();
         if(isSuccess)
         {
            SocketManager.Instance.out.getFlowerRewardStatus();
         }
      }
      
      protected function __updateRewardStatus(event:FlowerGivingEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var yesBtnStatus:Boolean = pkg.readBoolean();
         var accBtnStatus:Boolean = pkg.readBoolean();
         var giveFlowerStatus:int = pkg.readInt();
         var myGivingFlower:int = pkg.readInt();
         for(var i:int = 0; i <= this._listItem.length - 1; i++)
         {
            if(myGivingFlower >= (this._listItem[i] as FlowerSendRewardItem).num)
            {
               (this._listItem[i] as FlowerSendRewardItem).setBtnEnable(1);
               if((giveFlowerStatus & 1 << i) != 0)
               {
                  (this._listItem[i] as FlowerSendRewardItem).setBtnEnable(2);
               }
            }
            else
            {
               (this._listItem[i] as FlowerSendRewardItem).setBtnEnable(0);
            }
         }
         this._myFlowerNumTxt.text = myGivingFlower.toString();
      }
      
      private function updateView() : void
      {
         var item:FlowerSendRewardItem = null;
         for(var i:int = 0; i <= this.dataArr.length - 1; i++)
         {
            item = new FlowerSendRewardItem(i);
            this._listItem.push(item);
            this._vbox.addChild(item);
         }
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.REWARD_INFO,this.__updateRewardStatus);
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.GET_REWARD,this.__getRewardSuccess);
      }
      
      public function dispose() : void
      {
         var item:FlowerSendRewardItem = null;
         this.removeEvents();
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         if(Boolean(this._titleTxt1))
         {
            ObjectUtils.disposeObject(this._titleTxt1);
         }
         this._titleTxt1 = null;
         if(Boolean(this._titleTxt2))
         {
            ObjectUtils.disposeObject(this._titleTxt2);
         }
         this._titleTxt2 = null;
         if(Boolean(this._titleTxt3))
         {
            ObjectUtils.disposeObject(this._titleTxt3);
         }
         this._titleTxt3 = null;
         if(Boolean(this._myFlowerTitleTxt))
         {
            ObjectUtils.disposeObject(this._myFlowerTitleTxt);
         }
         this._myFlowerTitleTxt = null;
         if(Boolean(this._myFlowerNumTxt))
         {
            ObjectUtils.disposeObject(this._myFlowerNumTxt);
         }
         this._myFlowerNumTxt = null;
         for each(item in this._listItem)
         {
            ObjectUtils.disposeObject(item);
            item = null;
         }
         this._listItem = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._scrollPanel))
         {
            ObjectUtils.disposeObject(this._scrollPanel);
         }
         this._scrollPanel = null;
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}

