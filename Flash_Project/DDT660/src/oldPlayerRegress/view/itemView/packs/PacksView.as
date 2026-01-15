package oldPlayerRegress.view.itemView.packs
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   
   public class PacksView extends Frame
   {
      
      private var _titleBg:Bitmap;
      
      private var _packTitle:ScaleFrameImage;
      
      private var _titleBgII:Bitmap;
      
      private var _openPacks:ScaleFrameImage;
      
      private var _bottomBtnBg:ScaleBitmapImage;
      
      private var _getAwardBtn:BaseButton;
      
      private var _packsBg:ScaleBitmapImage;
      
      private var _packsSelect:ScaleFrameImage;
      
      private var _btnArray:Array;
      
      private var _recvArray:Array;
      
      private var _packsGiftView:PacksGiftView;
      
      private var _pakcsGiftData:Array;
      
      private var _clickID:int = 0;
      
      private var _dayNum:int = 0;
      
      private var _pageID:int = 0;
      
      private var _numID:int = 0;
      
      public function PacksView()
      {
         super();
         SocketManager.Instance.out.sendRegressPkg();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REGRESS_PACKS,this.__getPacksInfo);
      }
      
      private function __getPacksInfo(event:CrazyTankSocketEvent) : void
      {
         var l:int = 0;
         var isRecv:int = 0;
         var len:int = 0;
         var j:int = 0;
         var propsNum:int = 0;
         var giftDataVector:Vector.<GiftData> = null;
         var k:int = 0;
         var curID:int = 0;
         var giftData:GiftData = null;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REGRESS_PACKS,this.__getPacksInfo);
         this.removeVariable();
         var pkg:PackageIn = event.pkg;
         this._dayNum = pkg.readInt();
         var length:int = pkg.readInt();
         length = 6;
         this._pageID = int((this._dayNum - 1) / length);
         this._numID = (this._dayNum - 1) % length;
         this._init();
         for(var i:int = 0; i < 15; i++)
         {
            isRecv = pkg.readByte();
            if(i < this._pageID * 6)
            {
               len = pkg.readInt();
               for(j = 0; j < len; j++)
               {
                  pkg.readInt();
                  pkg.readInt();
               }
            }
            else
            {
               if(isRecv != 0)
               {
                  curID = i % 6;
                  this._recvArray[curID].visible = true;
                  this._btnArray[curID].removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
                  (this._btnArray[curID] as BaseButton).mouseEnabled = false;
               }
               propsNum = pkg.readInt();
               giftDataVector = new Vector.<GiftData>();
               for(k = 0; k < propsNum; k++)
               {
                  giftData = new GiftData();
                  giftData.giftID = pkg.readInt();
                  giftData.giftCount = pkg.readInt();
                  giftDataVector.push(giftData);
               }
               this._pakcsGiftData.push(giftDataVector);
            }
         }
         this._packsGiftView = new PacksGiftView();
         PositionUtils.setPos(this._packsGiftView,"regress.pakcs.gift.pos");
         addToContent(this._packsGiftView);
         for(l = 0; l <= this._numID; l++)
         {
            if(this._btnArray[l].mouseEnabled == true)
            {
               this._packsSelect.visible = true;
               this._packsSelect.x = this._btnArray[l].x;
               this._packsSelect.y = this._btnArray[l].y;
               this._clickID = this._pageID * 6 + l;
               this._getAwardBtn.enable = true;
               this._packsGiftView.removeGiftChild();
               this._packsGiftView.getGiftData = this._pakcsGiftData[l];
               this._packsGiftView.setGiftInfo();
               break;
            }
            if(l == this._numID)
            {
               this._getAwardBtn.enable = false;
               this._packsGiftView.removeGiftChild();
               if(this._numID + 1 < this._btnArray.length)
               {
                  this._clickID = this._numID + 1;
                  this._packsSelect.visible = true;
                  this._packsSelect.x = this._btnArray[this._clickID].x;
                  this._packsSelect.y = this._btnArray[this._clickID].y;
                  this._packsGiftView.getGiftData = this._pakcsGiftData[this._clickID];
                  this._packsGiftView.setGiftInfo();
               }
            }
         }
      }
      
      private function _init() : void
      {
         this.initData();
         this.initView();
         this.initEvent();
      }
      
      private function initData() : void
      {
         this._pakcsGiftData = new Array();
         this._btnArray = new Array(new BaseButton(),new BaseButton(),new BaseButton(),new BaseButton(),new BaseButton(),new BaseButton());
         this._recvArray = new Array(new ScaleFrameImage(),new ScaleFrameImage(),new ScaleFrameImage(),new ScaleFrameImage(),new ScaleFrameImage(),new ScaleFrameImage());
      }
      
      private function initView() : void
      {
         this._titleBg = ComponentFactory.Instance.creat("asset.regress.titleBg");
         this._packTitle = ComponentFactory.Instance.creatComponentByStylename("regress.packTitle");
         this._titleBgII = ComponentFactory.Instance.creat("asset.regress.titleBg");
         PositionUtils.setPos(this._titleBgII,"regress.packs.titleII.pos");
         this._openPacks = ComponentFactory.Instance.creatComponentByStylename("regress.openPacks");
         this._bottomBtnBg = ComponentFactory.Instance.creatComponentByStylename("regress.bottomBgImg");
         this._packsBg = ComponentFactory.Instance.creatComponentByStylename("regress.packsBg");
         this._getAwardBtn = ComponentFactory.Instance.creat("regress.getAward");
         this._getAwardBtn.enable = false;
         if(this._dayNum > 12)
         {
            this._btnArray.length = 3;
         }
         for(var i:int = 0; i < this._btnArray.length; i++)
         {
            this._btnArray[i] = ComponentFactory.Instance.creatComponentByStylename("regress.giftAward" + String(i + 1));
            addToContent(this._btnArray[i]);
            this._recvArray[i] = ComponentFactory.Instance.creatComponentByStylename("regress.packsReceived");
            this._recvArray[i].x = this._btnArray[i].x + 77;
            this._recvArray[i].y = this._btnArray[i].y - 4;
            addToContent(this._recvArray[i]);
         }
         this._packsSelect = ComponentFactory.Instance.creatComponentByStylename("regress.packsSelected");
         addToContent(this._titleBg);
         addToContent(this._packTitle);
         addToContent(this._titleBgII);
         addToContent(this._openPacks);
         addToContent(this._bottomBtnBg);
         addToContent(this._packsBg);
         addToContent(this._getAwardBtn);
         addToContent(this._packsSelect);
      }
      
      private function initEvent() : void
      {
         for(var i:int = 0; i < this._btnArray.length; i++)
         {
            this._btnArray[i].addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         }
         this._getAwardBtn.addEventListener(MouseEvent.CLICK,this.__onGetAwardClick);
      }
      
      protected function __onGetAwardClick(event:MouseEvent) : void
      {
         SocketManager.Instance.out.sendRegressGetAwardPkg(this._clickID);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REGRESS_PACKS,this.__getPacksInfo);
      }
      
      private function __onBtnClick(event:MouseEvent) : void
      {
         var i:int = 0;
         this._packsSelect.visible = true;
         for(i = 0; i < this._btnArray.length; i++)
         {
            if(this._btnArray[i] == event.currentTarget)
            {
               SoundManager.instance.playButtonSound();
               this._clickID = this._pageID * 6 + i;
               this._getAwardBtn.enable = true;
               if(Boolean(this._recvArray[i].visible) || i > this._numID)
               {
                  this._getAwardBtn.enable = false;
               }
               this._packsSelect.x = this._btnArray[i].x;
               this._packsSelect.y = this._btnArray[i].y;
               this._packsGiftView.removeGiftChild();
               this._packsGiftView.getGiftData = this._pakcsGiftData[i];
               this._packsGiftView.setGiftInfo();
               break;
            }
         }
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      private function removeEvent() : void
      {
         var i:int = 0;
         if(Boolean(this._btnArray))
         {
            for(i = 0; i < this._btnArray.length; i++)
            {
               this._btnArray[i].removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeVariable();
      }
      
      private function removeVariable() : void
      {
         var i:int = 0;
         this._clickID = 0;
         this._dayNum = 0;
         if(Boolean(this._titleBg))
         {
            this._titleBg = null;
         }
         if(Boolean(this._packTitle))
         {
            this._packTitle.dispose();
            this._packTitle = null;
         }
         if(Boolean(this._titleBgII))
         {
            this._titleBgII = null;
         }
         if(Boolean(this._openPacks))
         {
            this._openPacks.dispose();
            this._openPacks = null;
         }
         if(Boolean(this._bottomBtnBg))
         {
            this._bottomBtnBg.dispose();
            this._bottomBtnBg = null;
         }
         if(Boolean(this._getAwardBtn))
         {
            this._getAwardBtn.dispose();
            this._getAwardBtn = null;
         }
         if(Boolean(this._packsBg))
         {
            this._packsBg.dispose();
            this._packsBg = null;
         }
         if(Boolean(this._packsSelect))
         {
            this._packsSelect.dispose();
            this._packsSelect = null;
         }
         if(Boolean(this._packsGiftView))
         {
            this._packsGiftView.dispose();
            this._packsGiftView = null;
         }
         if(Boolean(this._pakcsGiftData))
         {
            for(i = 0; i < this._pakcsGiftData.length; i++)
            {
               this._pakcsGiftData[i] = null;
            }
            this._pakcsGiftData.length = 0;
         }
         this.removeArray(this._btnArray);
         this.removeArray(this._recvArray);
      }
      
      private function removeArray(array:Array) : void
      {
         var i:int = 0;
         if(Boolean(array))
         {
            for(i = 0; i < array.length; i++)
            {
               if(Boolean(array[i]))
               {
                  array[i].dispose();
                  array[i] = null;
               }
            }
            array.length = 0;
         }
      }
   }
}

