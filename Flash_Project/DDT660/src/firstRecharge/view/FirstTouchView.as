package firstRecharge.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import firstRecharge.FirstRechargeManger;
   import firstRecharge.info.RechargeData;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class FirstTouchView extends Frame implements Disposeable
   {
      
      private var _treeImage:ScaleBitmapImage;
      
      private var _treeImage2:ScaleBitmapImage;
      
      private var _word:Bitmap;
      
      private var _worldtitle:Bitmap;
      
      private var _child:Bitmap;
      
      private var _back:MutipleImage;
      
      private var _btn:SimpleBitmapButton;
      
      private var _goodsContentList:Vector.<BagCell>;
      
      private var _line:Bitmap;
      
      private var _cartoonList:Vector.<MovieClip>;
      
      private var _rechargeMoneyTotalText:GradientText;
      
      private var _rechargeGiftBagValueText1:GradientText;
      
      private var _rechargeGiftBagValueText2:GradientText;
      
      private var _wordDirept:FilterFrameText;
      
      private var _wordDirept2:FilterFrameText;
      
      private var _wordDirept3:FilterFrameText;
      
      private var _wordDirept4:FilterFrameText;
      
      private var _endTimeTxt:FilterFrameText;
      
      private var _daojishiTxt:Bitmap;
      
      public function FirstTouchView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            ObjectUtils.disposeObject(this);
         }
      }
      
      private function initView() : void
      {
         var j:int = 0;
         var gItem:BagCell = null;
         var pic:ScaleBitmapImage = null;
         var length:int = 0;
         var mc:MovieClip = null;
         var mc1:MovieClip = null;
         this._goodsContentList = new Vector.<BagCell>();
         this._treeImage = ComponentFactory.Instance.creatComponentByStylename("fristRecharge.scale9cornerImageTree");
         addToContent(this._treeImage);
         this._treeImage2 = ComponentFactory.Instance.creatComponentByStylename("accumulationView.rightBottomBgImg");
         addToContent(this._treeImage2);
         this._back = ComponentFactory.Instance.creatComponentByStylename("firstRecharge.SignedAwardBack");
         addToContent(this._back);
         this._wordDirept = ComponentFactory.Instance.creatComponentByStylename("firstRecharge.wordDireptText");
         this._wordDirept.text = "Değerli Oyuncular,\nEtkinlik süresince eklemeli yükleme \nmiktarınız                          ulaştığında";
         addToContent(this._wordDirept);
         this._rechargeMoneyTotalText = ComponentFactory.Instance.creatComponentByStylename("fristRecharge.rechargeMoneyTotalText");
         addToContent(this._rechargeMoneyTotalText);
         this._rechargeMoneyTotalText.x = 98;
         this._rechargeMoneyTotalText.y = 93;
         this._rechargeMoneyTotalText.text = FirstRechargeManger.Instance.rechargeMoneyTotal + "Kupon";
         this._rechargeGiftBagValueText1 = ComponentFactory.Instance.creatComponentByStylename("fristRecharge.rechargeMoneyTotalText1");
         addToContent(this._rechargeGiftBagValueText1);
         this._rechargeGiftBagValueText1.x = 27;
         this._rechargeGiftBagValueText1.y = 112;
         this._rechargeGiftBagValueText1.text = FirstRechargeManger.Instance.rechargeGiftBagValue + "Kupon";
         this._wordDirept2 = ComponentFactory.Instance.creatComponentByStylename("firstRecharge.wordDireptText");
         this._wordDirept2.text = "değerinde büyük bir hediye paketi \nelde edeceksiniz.";
         this._wordDirept2.x = this._rechargeGiftBagValueText1.x + this._rechargeGiftBagValueText1.width;
         this._wordDirept2.y = this._rechargeGiftBagValueText1.y + 2;
         addToContent(this._wordDirept2);
         this._wordDirept3 = ComponentFactory.Instance.creatComponentByStylename("firstRecharge.wordDireptText");
         this._wordDirept3.text = "";
         this._wordDirept3.x = this._rechargeGiftBagValueText1.x + this._rechargeGiftBagValueText1.width;
         this._wordDirept3.y = this._rechargeGiftBagValueText1.y + 3;
         addToContent(this._wordDirept3);
         this._wordDirept4 = ComponentFactory.Instance.creatComponentByStylename("firstRecharge.wordDireptText");
         this._wordDirept4.text = "Hediye sadece bir kez gönderilecektir, \nhediyenizi almaya geliniz.";
         PositionUtils.setPos(this._wordDirept4,"firstRecharge.wordDireptText2Pos3");
         addToContent(this._wordDirept4);
         this._worldtitle = ComponentFactory.Instance.creatBitmap("fristRecharge.libao.title");
         addToContent(this._worldtitle);
         this._rechargeGiftBagValueText2 = ComponentFactory.Instance.creatComponentByStylename("fristRecharge.rechargeGiftBagValueText2");
         addToContent(this._rechargeGiftBagValueText2);
         this._rechargeGiftBagValueText2.text = FirstRechargeManger.Instance.rechargeGiftBagValue + "Kupon";
         titleText = "Ödenmiş Hediye";
         this._cartoonList = new Vector.<MovieClip>(2);
         for(j = 0; j < 7; j++)
         {
            gItem = new BagCell(j);
            pic = ComponentFactory.Instance.creatComponentByStylename("recharge.ItemBg");
            pic.x = j * (gItem.width + 8) + 60;
            pic.y = 254;
            gItem.x = pic.x + 2;
            gItem.y = pic.y + 2;
            addToContent(pic);
            addToContent(gItem);
            gItem.setBgVisible(false);
            this._goodsContentList.push(gItem);
            length = int(FirstRechargeManger.Instance.getGoodsList_haiwai().length);
            if(length > 1)
            {
               if(j == 0 || j == 1)
               {
                  mc = ComponentFactory.Instance.creat("firstRecharge.cartoon");
                  mc.mouseChildren = false;
                  mc.mouseEnabled = false;
                  mc.x = pic.x - 21;
                  mc.y = pic.y - 36;
                  addToContent(mc);
                  this._cartoonList[j] = mc;
               }
            }
            else if(j == 0)
            {
               mc1 = ComponentFactory.Instance.creat("firstRecharge.cartoon");
               mc1.mouseChildren = false;
               mc1.mouseEnabled = false;
               mc1.x = pic.x - 21;
               mc1.y = pic.y - 36;
               addToContent(mc1);
               this._cartoonList[j] = mc1;
            }
         }
         this._child = ComponentFactory.Instance.creatBitmap("fristRecharge.child");
         addToContent(this._child);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("accumulationView.ftxtBtn");
         addToContent(this._btn);
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHander);
         this._endTimeTxt = ComponentFactory.Instance.creatComponentByStylename("firstRecharge.timePlayTxt");
         addToContent(this._endTimeTxt);
         this._daojishiTxt = ComponentFactory.Instance.creatBitmap("fristRecharge.downtimes");
         addToContent(this._daojishiTxt);
         this.refreshTimePlayTxt();
      }
      
      public function setGoodsList(list:Vector.<RechargeData>) : void
      {
         var len:int = int(list.length);
         var count:int = 0;
         for(var i:int = 0; i < len; i++)
         {
            if(count >= 7)
            {
               return;
            }
            if(Boolean(list[i]))
            {
               this._goodsContentList[i].info = FirstRechargeManger.Instance.setGoods(list[i]);
               this._goodsContentList[i].setCount(list[i].RewardItemCount);
            }
            count++;
         }
      }
      
      protected function clickHander(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LeavePageManager.leaveToFillPath();
      }
      
      private function changeStringToDate(string:String) : Date
      {
         var array:Array = null;
         var firstPart:Array = null;
         var secondPart:Array = null;
         var date:Date = null;
         if(string == "" || string == null)
         {
            return null;
         }
         array = string.split(" ");
         firstPart = array[0].split("-");
         secondPart = array[1].split(":");
         return new Date(firstPart[0],firstPart[1] - 1,firstPart[2],secondPart[0],secondPart[1],secondPart[2]);
      }
      
      private function refreshTimePlayTxt() : void
      {
         var timeTxtStr:String = null;
         var str:String = FirstRechargeManger.Instance.rechargeEndTime;
         var date:Date = this.changeStringToDate(str);
         var endTimestamp:Number = Number(date.getTime());
         var nowdate:Date = TimeManager.Instance.Now();
         var nowTimestamp:Number = Number(nowdate.getTime());
         var differ:Number = endTimestamp - nowTimestamp;
         differ = differ < 0 ? 0 : differ;
         var count:int = 0;
         if(differ / TimeManager.DAY_TICKS > 1)
         {
            count = differ / TimeManager.DAY_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("day");
         }
         else if(differ / TimeManager.HOUR_TICKS > 1)
         {
            count = differ / TimeManager.HOUR_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("hour");
         }
         else if(differ / TimeManager.Minute_TICKS > 1)
         {
            count = differ / TimeManager.Minute_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("minute");
         }
         else
         {
            count = differ / TimeManager.Second_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("second");
         }
         this._endTimeTxt.text = LanguageMgr.GetTranslation("newChickenBox1.timePlayTxt",timeTxtStr);
         if(count <= 0)
         {
            this._endTimeTxt.text = "Bitiş Olaylar";
         }
      }
      
      override public function dispose() : void
      {
         var mc:MovieClip = null;
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.clickHander);
         }
         for each(mc in this._cartoonList)
         {
            if(Boolean(mc))
            {
               mc.gotoAndStop(1);
            }
         }
         this._cartoonList = null;
         super.dispose();
      }
   }
}

