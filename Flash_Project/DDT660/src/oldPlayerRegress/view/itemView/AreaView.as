package oldPlayerRegress.view.itemView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import oldPlayerRegress.data.RegressData;
   import road7th.comm.PackageIn;
   
   public class AreaView extends Frame
   {
      
      private var _titleBg:Bitmap;
      
      private var _bottomBtnBg:ScaleBitmapImage;
      
      private var _titleImg:ScaleFrameImage;
      
      private var _areaInfo:FilterFrameText;
      
      private var _areaInfoItem:FilterFrameText;
      
      private var _caption:FilterFrameText;
      
      private var _getMoney:FilterFrameText;
      
      private var _getLenvel:FilterFrameText;
      
      private var _applyBtn:SimpleBitmapButton;
      
      public function AreaView()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._titleBg = ComponentFactory.Instance.creat("asset.regress.titleBg");
         this._titleImg = ComponentFactory.Instance.creatComponentByStylename("regress.areaTitleImg");
         this._bottomBtnBg = ComponentFactory.Instance.creatComponentByStylename("regress.bottomBgImg");
         this._areaInfo = ComponentFactory.Instance.creatComponentByStylename("regress.Description");
         this._areaInfo.text = LanguageMgr.GetTranslation("ddt.regress.areaView.areaInfo");
         PositionUtils.setPos(this._areaInfo,"regress.area.areaInfo.pos");
         this._areaInfoItem = ComponentFactory.Instance.creatComponentByStylename("regress.Description");
         this._areaInfoItem.text = LanguageMgr.GetTranslation("ddt.regress.areaView.areaInfoItem");
         PositionUtils.setPos(this._areaInfoItem,"regress.area.areaInfoItem.pos");
         this._caption = ComponentFactory.Instance.creatComponentByStylename("regress.areaCaption");
         this._caption.text = LanguageMgr.GetTranslation("ddt.regress.areaView.caption");
         this._getMoney = ComponentFactory.Instance.creatComponentByStylename("regress.getDemand");
         this._getMoney.text = "199900kupon";
         PositionUtils.setPos(this._getMoney,"regress.area.getMoney.pos");
         this._getLenvel = ComponentFactory.Instance.creatComponentByStylename("regress.getDemand");
         this._getLenvel.text = "8Hediye";
         PositionUtils.setPos(this._getLenvel,"regress.area.getLevel.pos");
         this._applyBtn = ComponentFactory.Instance.creatComponentByStylename("regress.applyBtn");
         this._applyBtn.enable = false;
         if(RegressData.isApplyEnable)
         {
            this._applyBtn.enable = true;
         }
         addToContent(this._titleBg);
         addToContent(this._bottomBtnBg);
         addToContent(this._titleImg);
         addToContent(this._areaInfo);
         addToContent(this._areaInfoItem);
         addToContent(this._caption);
         addToContent(this._getMoney);
         addToContent(this._getLenvel);
         addToContent(this._applyBtn);
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      private function initEvent() : void
      {
         this._applyBtn.addEventListener(MouseEvent.CLICK,this.__onMouseClickApply);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REGRESS_APPLYPACKS,this.__onApplyPacks);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REGRESS_APPLY_ENABLE,this.__onApplyEnable);
      }
      
      protected function __onMouseClickApply(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         SocketManager.Instance.out.sendRegressApllyPacks();
      }
      
      protected function __onApplyPacks(event:CrazyTankSocketEvent) : void
      {
         var num:int = 0;
         var pkg:PackageIn = event.pkg;
         if(pkg.bytesAvailable > 0)
         {
            num = pkg.readInt();
            if(num == 1)
            {
               RegressData.isApplyEnable = false;
               this._applyBtn.enable = false;
            }
         }
      }
      
      protected function __onApplyEnable(event:CrazyTankSocketEvent) : void
      {
         var num:int = 0;
         var pkg:PackageIn = event.pkg;
         if(pkg.bytesAvailable > 0)
         {
            num = pkg.readInt();
            if(num == 1)
            {
               RegressData.isApplyEnable = false;
               this._applyBtn.enable = false;
            }
            else
            {
               RegressData.isApplyEnable = true;
               this._applyBtn.enable = true;
            }
         }
      }
      
      private function removeEvent() : void
      {
         this._applyBtn.removeEventListener(MouseEvent.CLICK,this.__onMouseClickApply);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REGRESS_APPLYPACKS,this.__onApplyPacks);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REGRESS_APPLY_ENABLE,this.__onApplyEnable);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._titleBg))
         {
            this._titleBg = null;
         }
         if(Boolean(this._bottomBtnBg))
         {
            this._bottomBtnBg.dispose();
            this._bottomBtnBg = null;
         }
         if(Boolean(this._titleImg))
         {
            this._titleImg.dispose();
            this._titleImg = null;
         }
         if(Boolean(this._areaInfo))
         {
            this._areaInfo.dispose();
            this._areaInfo = null;
         }
         if(Boolean(this._areaInfoItem))
         {
            this._areaInfoItem.dispose();
            this._areaInfoItem = null;
         }
         if(Boolean(this._caption))
         {
            this._caption.dispose();
            this._caption = null;
         }
         if(Boolean(this._getMoney))
         {
            this._getMoney.dispose();
            this._getMoney = null;
         }
         if(Boolean(this._getLenvel))
         {
            this._getLenvel.dispose();
            this._getLenvel = null;
         }
         if(Boolean(this._applyBtn))
         {
            this._applyBtn.dispose();
            this._applyBtn = null;
         }
      }
   }
}

