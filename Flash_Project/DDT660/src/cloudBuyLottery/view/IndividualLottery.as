package cloudBuyLottery.view
{
   import bagAndInfo.cell.BaseCell;
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   
   public class IndividualLottery extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _bg2:Bitmap;
      
      private var _jubaoMC:MovieClip;
      
      private var _helpTxt:FilterFrameText;
      
      private var _juBaoBtn:BaseButton;
      
      private var _numTxt:FilterFrameText;
      
      private var _num:FilterFrameText;
      
      private var _selectSprite:Sprite;
      
      private var _selectedCell:BaseCell;
      
      private var itemInfo:ItemTemplateInfo;
      
      private var tInfo:InventoryItemInfo;
      
      private var flag:Boolean = false;
      
      private var gotoFlag:Boolean = true;
      
      public function IndividualLottery()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg2 = ComponentFactory.Instance.creatBitmap("asset.IndividualLottery.BG");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("IndividualLottery.BG");
         this._jubaoMC = ClassUtils.CreatInstance("asset.IndividualLottery.jubaoMC") as MovieClip;
         PositionUtils.setPos(this._jubaoMC,"IndividualLottery.jubaoMC");
         this._helpTxt = ComponentFactory.Instance.creatComponentByStylename("IndividualLottery.helpTxt");
         this._helpTxt.htmlText = LanguageMgr.GetTranslation("IndividualLottery.helpHtmlTxt",500);
         this._juBaoBtn = ComponentFactory.Instance.creat("IndividualLottery.jubaoBtn");
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("IndividualLottery.numTxt");
         this._numTxt.text = LanguageMgr.GetTranslation("IndividualLottery.numTxt.LG");
         this._num = ComponentFactory.Instance.creatComponentByStylename("IndividualLottery.num");
         this._num.text = CloudBuyLotteryManager.Instance.model.remainTimes.toString();
         addToContent(this._bg2);
         addToContent(this._bg);
         addToContent(this._jubaoMC);
         addToContent(this._helpTxt);
         addToContent(this._juBaoBtn);
         addToContent(this._numTxt);
         addToContent(this._num);
         var size:Point = ComponentFactory.Instance.creatCustomObject("IndividualLottery.selectCellSize");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,size.x,size.y);
         shape.graphics.endFill();
         this._selectSprite = ComponentFactory.Instance.creatCustomObject("IndividualLottery.selectSprite");
         this._selectedCell = new BaseCell(shape);
         this._selectedCell.x = this._selectedCell.width / -2;
         this._selectedCell.y = this._selectedCell.height / -2;
         this._selectedCell.visible = false;
         this._selectSprite.addChild(this._selectedCell);
         addToContent(this._selectSprite);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         this._juBaoBtn.addEventListener(MouseEvent.CLICK,this.__onClick);
         CloudBuyLotteryManager.Instance.addEventListener(CloudBuyLotteryManager.INDIVIDUAL,this.__updateInfo);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         CloudBuyLotteryManager.Instance.removeEventListener(CloudBuyLotteryManager.INDIVIDUAL,this.__updateInfo);
      }
      
      private function __updateInfo(e:Event) : void
      {
         if(CloudBuyLotteryManager.Instance.model.isGetReward)
         {
            this._num.text = CloudBuyLotteryManager.Instance.model.remainTimes.toString();
            this.updateData(CloudBuyLotteryManager.Instance.model.luckDrawId);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IndividualLottery.getRewardTip"));
            addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            this.btnIsClick(true);
         }
      }
      
      private function updateData(id:int) : void
      {
         this.itemInfo = ItemManager.Instance.getTemplateById(id) as ItemTemplateInfo;
         this.tInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(this.tInfo,this.itemInfo);
         this.flag = true;
      }
      
      private function __onClick(evt:MouseEvent) : void
      {
         if(int(this._num.text) > 0)
         {
            this.btnIsClick(false);
            removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
            SocketManager.Instance.out.sendLuckDrawGo();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IndividualLottery.NumNOTip"));
         }
      }
      
      private function __onEnterFrame(evt:Event) : void
      {
         if(this.flag)
         {
            if(this.gotoFlag)
            {
               this.gotoFlag = false;
               this._jubaoMC.gotoAndPlay(41);
               this._selectedCell.info = this.tInfo;
            }
            if(this._jubaoMC.currentFrame >= 65)
            {
               this.flag = false;
               this._selectedCell.visible = true;
               this.creatTweenMagnify();
            }
         }
      }
      
      private function btnIsClick(flag:Boolean) : void
      {
         if(flag)
         {
            this._juBaoBtn.enable = true;
            this._juBaoBtn.mouseChildren = true;
            this._juBaoBtn.mouseEnabled = true;
         }
         else
         {
            this._juBaoBtn.enable = false;
            this._juBaoBtn.mouseChildren = false;
            this._juBaoBtn.mouseEnabled = false;
         }
      }
      
      private function creatTweenMagnify(duration:Number = 1, scale:Number = 1.5, repeat:int = -1, yoyo:Boolean = true, delay:int = 1100) : void
      {
         TweenMax.to(this._selectSprite,duration,{
            "scaleX":scale,
            "scaleY":scale,
            "repeat":repeat,
            "yoyo":yoyo,
            "ease":Elastic.easeOut
         });
         setTimeout(this._timeOut,delay);
      }
      
      private function _timeOut() : void
      {
         this._clear();
      }
      
      private function _clear() : void
      {
         this.gotoFlag = true;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IndividualLottery.GoodsName",this.tInfo.Name));
         TweenMax.killTweensOf(this._selectSprite);
         if(Boolean(this._selectedCell))
         {
            this._selectedCell.visible = false;
         }
         if(Boolean(this._selectSprite))
         {
            this._selectSprite.scaleY = 1;
            this._selectSprite.scaleX = 1;
         }
         setTimeout(this.showJuBaoBtn,1500);
      }
      
      private function showJuBaoBtn() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.btnIsClick(true);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

