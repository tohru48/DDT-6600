package DDPlay
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import com.greensock.easing.Linear;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class DDPlayView extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _boguTypePoints:Array;
      
      private var _sixBogu1:MovieClip;
      
      private var _sixBogu2:MovieClip;
      
      private var _sixBogu3:MovieClip;
      
      private var _boguMaskSp1:MovieClip;
      
      private var _boguMaskSp2:MovieClip;
      
      private var _boguMaskSp3:MovieClip;
      
      private var _boguMask1:MovieClip;
      
      private var _boguMask2:MovieClip;
      
      private var _boguMask3:MovieClip;
      
      private var _tripleMc:MovieClip;
      
      private var _fivefoldMc:MovieClip;
      
      private var _tenfoldMc:MovieClip;
      
      private var _triple:Bitmap;
      
      private var _fivefold:Bitmap;
      
      private var _tenfold:Bitmap;
      
      private var _lights:MovieClip;
      
      private var _shine1:MovieClip;
      
      private var _shine2:MovieClip;
      
      private var _shine3:MovieClip;
      
      private var _titleLight:MovieClip;
      
      private var _finallyLight:MovieClip;
      
      private var _finallyFireWork:MovieClip;
      
      private var _upBtn:SimpleBitmapButton;
      
      private var _stopUpBtn:SimpleBitmapButton;
      
      private var _selectedTxt:SelectedCheckButton;
      
      private var _exchangeBtn:BaseButton;
      
      private var timer:Timer = new Timer(5000);
      
      private var _explameTxt:FilterFrameText;
      
      private var _coinsTxt:FilterFrameText;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _exchangeFrame:DDPlayExchangeFrame;
      
      private var isPlaying:Boolean;
      
      private var _multiple:int;
      
      private var tw1:TweenLite;
      
      private var tw2:TweenLite;
      
      private var tw3:TweenLite;
      
      private const fastest:Number = 0.3;
      
      private const startSpeed:Number = 0.4;
      
      private const tempSpeed:Number = 0.05;
      
      private var fastestLast1:int = 3;
      
      private var fastestLast2:int = 5;
      
      private var fastestLast3:int = 8;
      
      private var tSpeed1:Number = 0.4;
      
      private var tSpeed2:Number = 0.4;
      
      private var tSpeed3:Number = 0.4;
      
      public function DDPlayView()
      {
         super();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function initView() : void
      {
         InviteManager.Instance.enabled = false;
         this._boguTypePoints = new Array();
         PositionUtils.setPos(this._boguTypePoints[0] = new Point(),"DDPlay.view.2Bogu2");
         PositionUtils.setPos(this._boguTypePoints[1] = new Point(),"DDPlay.view.1Bogu1");
         PositionUtils.setPos(this._boguTypePoints[2] = new Point(),"DDPlay.view.2Bogu1");
         PositionUtils.setPos(this._boguTypePoints[3] = new Point(),"DDPlay.view.3Bogu1");
         this._bg = ComponentFactory.Instance.creat("DDPlay.view.bg");
         this._sixBogu1 = ClassUtils.CreatInstance("DDPlay.view.sixBoguMc");
         this._sixBogu2 = ClassUtils.CreatInstance("DDPlay.view.sixBoguMc");
         this._sixBogu3 = ClassUtils.CreatInstance("DDPlay.view.sixBoguMc");
         this._boguMask1 = ClassUtils.CreatInstance("DDPlay.view.mask");
         this._boguMask2 = ClassUtils.CreatInstance("DDPlay.view.mask");
         this._boguMask3 = ClassUtils.CreatInstance("DDPlay.view.mask");
         this._boguMaskSp1 = ClassUtils.CreatInstance("DDPlay.view.mask");
         this._boguMaskSp2 = ClassUtils.CreatInstance("DDPlay.view.mask");
         this._boguMaskSp3 = ClassUtils.CreatInstance("DDPlay.view.mask");
         this._upBtn = ComponentFactory.Instance.creatComponentByStylename("DDPlay.view.upBtn");
         this._stopUpBtn = ComponentFactory.Instance.creatComponentByStylename("DDPlay.view.stopUpBtn");
         this._exchangeBtn = ComponentFactory.Instance.creatComponentByStylename("DDPlay.view.exchangeBaseBtn");
         this._selectedTxt = ComponentFactory.Instance.creat("DDPlay.view.SelectedCheckButton");
         this._explameTxt = ComponentFactory.Instance.creatComponentByStylename("DDPlay.view.explameTxt");
         this._coinsTxt = ComponentFactory.Instance.creatComponentByStylename("DDPlay.view.coinsTxt");
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("DDPlay.view.scoreTxt");
         this._explameTxt.htmlText = LanguageMgr.GetTranslation("tank.ddPlay.view.explame");
         this._scoreTxt.text = DDPlayManaer.Instance.DDPlayScore.toString();
         this._coinsTxt.text = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.DDPLAY_COIN).toString();
         this._tripleMc = ClassUtils.CreatInstance("DDPlay.view.tripleMc");
         this._fivefoldMc = ClassUtils.CreatInstance("DDPlay.view.fiveFoldMc");
         this._tenfoldMc = ClassUtils.CreatInstance("DDPlay.view.tenFoldMc");
         this._triple = ComponentFactory.Instance.creatBitmap("DDPlay.view.triple");
         this._fivefold = ComponentFactory.Instance.creatBitmap("DDPlay.view.fiveFold");
         this._tenfold = ComponentFactory.Instance.creatBitmap("DDPlay.view.tenFold");
         this._lights = ClassUtils.CreatInstance("DDPlay.view.bulbsMc");
         this._shine1 = ClassUtils.CreatInstance("DDPlay.view.boguYellowShineMc");
         this._shine2 = ClassUtils.CreatInstance("DDPlay.view.boguYellowShineMc");
         this._shine3 = ClassUtils.CreatInstance("DDPlay.view.boguYellowShineMc");
         this._titleLight = ClassUtils.CreatInstance("DDPlay.view.lightMc");
         this._finallyLight = ClassUtils.CreatInstance("DDPlay.view.lastMc");
         this._finallyFireWork = ClassUtils.CreatInstance("DDPlay.view.fireWorkMc");
         addToContent(this._bg);
         addToContent(this._sixBogu1);
         this._sixBogu1.mask = this._boguMaskSp1;
         this._sixBogu1.y = this._boguTypePoints[1].y;
         addToContent(this._boguMaskSp1);
         addToContent(this._sixBogu2);
         this._sixBogu2.mask = this._boguMaskSp2;
         this._sixBogu2.y = this._boguTypePoints[2].y;
         addToContent(this._boguMaskSp2);
         addToContent(this._sixBogu3);
         this._sixBogu3.mask = this._boguMaskSp3;
         this._sixBogu3.y = this._boguTypePoints[3].y;
         addToContent(this._boguMaskSp3);
         addToContent(this._explameTxt);
         addToContent(this._coinsTxt);
         addToContent(this._scoreTxt);
         PositionUtils.setPos(this._sixBogu1,"DDPlay.view.sixBogu1");
         PositionUtils.setPos(this._sixBogu2,"DDPlay.view.sixBogu2");
         PositionUtils.setPos(this._sixBogu3,"DDPlay.view.sixBogu3");
         PositionUtils.setPos(this._boguMaskSp1,"DDPlay.view.maskPos1");
         PositionUtils.setPos(this._boguMaskSp2,"DDPlay.view.maskPos2");
         PositionUtils.setPos(this._boguMaskSp3,"DDPlay.view.maskPos3");
         addToContent(this._boguMask1);
         addToContent(this._boguMask2);
         addToContent(this._boguMask3);
         PositionUtils.setPos(this._boguMask1,"DDPlay.view.maskPos1");
         PositionUtils.setPos(this._boguMask2,"DDPlay.view.maskPos2");
         PositionUtils.setPos(this._boguMask3,"DDPlay.view.maskPos3");
         addToContent(this._triple);
         addToContent(this._fivefold);
         addToContent(this._tenfold);
         addToContent(this._tripleMc);
         addToContent(this._fivefoldMc);
         addToContent(this._tenfoldMc);
         this._tripleMc.visible = this._fivefoldMc.visible = this._tenfoldMc.visible = false;
         addToContent(this._lights);
         addToContent(this._shine1);
         addToContent(this._shine2);
         addToContent(this._shine3);
         this._shine1.gotoAndStop(1);
         this._shine2.gotoAndStop(1);
         this._shine3.gotoAndStop(1);
         this._shine1.visible = this._shine2.visible = this._shine3.visible = false;
         addToContent(this._titleLight);
         PositionUtils.setPos(this._tripleMc,"DDPlay.view.tripleMc");
         PositionUtils.setPos(this._fivefoldMc,"DDPlay.view.fivefoldMc");
         PositionUtils.setPos(this._tenfoldMc,"DDPlay.view.temfoldMc");
         PositionUtils.setPos(this._lights,"DDPlay.view.lights");
         PositionUtils.setPos(this._shine1,"DDPlay.view.shine1");
         PositionUtils.setPos(this._shine2,"DDPlay.view.shine2");
         PositionUtils.setPos(this._shine3,"DDPlay.view.shine3");
         PositionUtils.setPos(this._titleLight,"DDPlay.view.titlelight");
         PositionUtils.setPos(this._finallyLight,"DDPlay.view.finallyLight");
         PositionUtils.setPos(this._finallyFireWork,"DDPlay.view.finallyLight");
         addToContent(this._upBtn);
         addToContent(this._stopUpBtn);
         addToContent(this._selectedTxt);
         addToContent(this._exchangeBtn);
         this._stopUpBtn.visible = false;
         addToContent(this._finallyLight);
         this._finallyLight.visible = false;
         addToContent(this._finallyFireWork);
         this._finallyFireWork.visible = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._upBtn.addEventListener(MouseEvent.CLICK,this.doUpHonor,false,0,true);
         this._stopUpBtn.addEventListener(MouseEvent.CLICK,this.stopDoUpHonor,false,0,true);
         this._selectedTxt.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._exchangeBtn.addEventListener(MouseEvent.CLICK,this.__scoreExchange);
         this.timer.addEventListener(TimerEvent.TIMER,this._timerHandler);
         DDPlayManaer.Instance.addEventListener(CrazyTankSocketEvent.DDPLAY_ENTER,this.__updateScore);
         DDPlayManaer.Instance.addEventListener(CrazyTankSocketEvent.DDPLAY_START,this.__start);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._bagUpdate);
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.DDPlayEnter();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._upBtn.removeEventListener(MouseEvent.CLICK,this.doUpHonor);
         this._stopUpBtn.removeEventListener(MouseEvent.CLICK,this.stopDoUpHonor);
         this._selectedTxt.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._exchangeBtn.removeEventListener(MouseEvent.CLICK,this.__scoreExchange);
         this.timer.removeEventListener(TimerEvent.TIMER,this._timerHandler);
         DDPlayManaer.Instance.removeEventListener(CrazyTankSocketEvent.DDPLAY_ENTER,this.__updateScore);
         DDPlayManaer.Instance.removeEventListener(CrazyTankSocketEvent.DDPLAY_START,this.__start);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this._bagUpdate);
      }
      
      private function __updateScore(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         DDPlayManaer.Instance.DDPlayScore = pkg.readInt();
         this._scoreTxt.text = DDPlayManaer.Instance.DDPlayScore.toString();
         this._coinsTxt.text = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.DDPLAY_COIN).toString();
         DDPlayManaer.Instance.dispatchEvent(new Event(DDPlayManaer.UPDATE_SCORE));
      }
      
      private function __start(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         this._multiple = pkg.readInt();
         DDPlayManaer.Instance.DDPlayScore = pkg.readInt();
         this.refreshShow();
      }
      
      private function _timerHandler(e:TimerEvent) : void
      {
         if(DDPlayManaer.Instance.isOpen == false)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.ddPlay.end"));
            return;
         }
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.DDPLAY_COIN) < 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.ddPlay.view.LeBiNotEnough"));
            this.timer.stop();
            this._stopUpBtn.visible = false;
            this._upBtn.enable = true;
            this._selectedTxt.enable = true;
            this.isPlaying = false;
            return;
         }
         this.isPlaying = true;
         SocketManager.Instance.out.DDPlayStart();
      }
      
      private function __response(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            if(this._upBtn.enable == false)
            {
               return;
            }
            dispatchEvent(new Event(Event.CLOSE));
            this.dispose();
         }
      }
      
      private function _bagUpdate(e:BagEvent) : void
      {
         this._coinsTxt.text = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.DDPLAY_COIN).toString();
      }
      
      private function __scoreExchange(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(DDPlayManaer.Instance.isOpen == false)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.ddPlay.end"));
            return;
         }
         if(this._upBtn.enable == false)
         {
            return;
         }
         this._exchangeFrame = ComponentFactory.Instance.creatComponentByStylename("DDPlay.exchange.frame");
         LayerManager.Instance.addToLayer(this._exchangeFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function doUpHonor(event:MouseEvent) : void
      {
         var quick:DDPlayQuickBuy = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(DDPlayManaer.Instance.isOpen == false)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.ddPlay.end"));
            return;
         }
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.DDPLAY_COIN) < 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.ddPlay.view.LeBiNotEnough"));
            quick = ComponentFactory.Instance.creatCustomObject("DDPlay.quickBuyCoins.frame");
            quick.show(0);
            return;
         }
         if(this._selectedTxt.selected)
         {
            this._stopUpBtn.visible = true;
            this.timer.reset();
            this.timer.start();
         }
         this._upBtn.enable = false;
         this._selectedTxt.enable = false;
         this.isPlaying = true;
         SocketManager.Instance.out.DDPlayStart();
      }
      
      private function stopDoUpHonor(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.timer.stop();
         this._stopUpBtn.visible = false;
         if(this.isPlaying == false)
         {
            this._upBtn.enable = true;
            this._selectedTxt.enable = true;
         }
      }
      
      private function __checkBoxClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function refreshShow() : void
      {
         var lm:int = 0;
         var a1:int = 0;
         var a2:int = 0;
         var a3:int = 0;
         var b1:int = 0;
         var b2:int = 0;
         var b3:int = 0;
         lm = this._multiple;
         switch(lm)
         {
            case 3:
               this.startLottery(1,1,1);
               break;
            case 5:
               this.startLottery(2,2,2);
               break;
            case 10:
               this.startLottery(3,3,3);
               break;
            case 2:
               a1 = Math.ceil(Math.random() * 3);
               a2 = Math.ceil(Math.random() * 3);
               a3 = Math.ceil(Math.random() * 3);
               if(a1 == a2 && a2 == a3)
               {
                  if(a2 == 1)
                  {
                     a2 = 2;
                  }
                  else if(a2 == 2)
                  {
                     a2 = 3;
                  }
                  else
                  {
                     a2 = 1;
                  }
               }
               if(a1 != a2 && a1 != a3 && a2 != a3)
               {
                  a1 = a2;
               }
               this.startLottery(a1,a2,a3);
               break;
            default:
               b1 = Math.ceil(Math.random() * 3);
               b2 = Math.ceil(Math.random() * 3);
               b3 = Math.ceil(Math.random() * 3);
               if(b1 == b2)
               {
                  if(b2 == 1)
                  {
                     b2 = 2;
                  }
                  else if(b2 == 2)
                  {
                     b2 = 3;
                  }
                  else
                  {
                     b2 = 1;
                  }
               }
               if(b3 == b2 || b3 == b1)
               {
                  if(b1 + b2 == 3)
                  {
                     b3 = 3;
                  }
                  else if(b1 + b2 == 4)
                  {
                     b3 = 2;
                  }
                  else
                  {
                     b3 = 1;
                  }
               }
               this.startLottery(b1,b2,b3);
         }
      }
      
      private function startLottery(bg1:int = 1, bg2:int = 2, bg3:int = 3) : void
      {
         this.reSetBogu();
         this.tw1 = TweenLite.to(this._sixBogu1,(this._sixBogu1.y - this._boguTypePoints[2].y) / 375,{
            "y":this._boguTypePoints[2].y,
            "ease":Linear.easeNone,
            "onComplete":this._sixBogu1Com,
            "onCompleteParams":[bg1]
         });
         this.tw2 = TweenLite.to(this._sixBogu2,(this._sixBogu2.y - this._boguTypePoints[2].y) / 375,{
            "y":this._boguTypePoints[2].y,
            "ease":Linear.easeNone,
            "onComplete":this._sixBogu2Com,
            "onCompleteParams":[bg2]
         });
         this.tw3 = TweenLite.to(this._sixBogu3,(this._sixBogu3.y - this._boguTypePoints[2].y) / 375,{
            "y":this._boguTypePoints[2].y,
            "ease":Linear.easeNone,
            "onComplete":this._sixBogu3Com,
            "onCompleteParams":[bg3]
         });
      }
      
      private function reSetBogu() : void
      {
         this.fastestLast1 = 3;
         this.fastestLast2 = 5;
         this.fastestLast3 = 8;
         this.tSpeed1 = this.startSpeed;
         this.tSpeed2 = this.startSpeed;
         this.tSpeed3 = this.startSpeed;
         this._tripleMc.visible = this._fivefoldMc.visible = this._tenfoldMc.visible = this._shine1.visible = this._shine2.visible = this._shine3.visible = this._finallyLight.visible = this._finallyFireWork.visible = false;
         this._shine1.gotoAndStop(1);
         this._shine2.gotoAndStop(1);
         this._shine3.gotoAndStop(1);
      }
      
      private function _sixBogu1Com(bg:int) : void
      {
         this.tw1.kill();
         this._sixBogu1.y = this._boguTypePoints[0].y;
         this.tSpeed1 = Number(this.tSpeed1.toFixed(3));
         if(this.fastestLast1 > 0 && this.tSpeed1 > this.fastest)
         {
            this.tSpeed1 -= this.tempSpeed;
         }
         else if(this.fastestLast1 > 0 && this.tSpeed1 == this.fastest)
         {
            --this.fastestLast1;
            this._sixBogu1.gotoAndStop(2);
         }
         else if(this.tSpeed1 < this.startSpeed)
         {
            this.tSpeed1 += this.tempSpeed;
            this._sixBogu1.gotoAndStop(1);
         }
         this.tSpeed1 = Number(this.tSpeed1.toFixed(3));
         if(this.fastestLast1 == 0 && this.tSpeed1 == this.startSpeed)
         {
            this.tw1 = TweenLite.to(this._sixBogu1,this.tSpeed1 + 0.1,{
               "y":this._boguTypePoints[bg].y,
               "ease":Back.easeOut
            });
         }
         else
         {
            this.tw1 = TweenLite.to(this._sixBogu1,this.tSpeed1,{
               "y":this._boguTypePoints[2].y,
               "ease":Linear.easeNone,
               "onComplete":this._sixBogu1Com,
               "onCompleteParams":[bg]
            });
         }
      }
      
      private function _sixBogu2Com(bg:int) : void
      {
         this.tw2.kill();
         this._sixBogu2.y = this._boguTypePoints[0].y;
         this.tSpeed2 = Number(this.tSpeed2.toFixed(3));
         if(this.fastestLast2 > 0 && this.tSpeed2 > this.fastest)
         {
            this.tSpeed2 -= this.tempSpeed;
         }
         else if(this.fastestLast2 > 0 && this.tSpeed2 == this.fastest)
         {
            --this.fastestLast2;
            this._sixBogu2.gotoAndStop(2);
         }
         else if(this.tSpeed2 < this.startSpeed)
         {
            this.tSpeed2 += this.tempSpeed;
            this._sixBogu2.gotoAndStop(1);
         }
         this.tSpeed2 = Number(this.tSpeed2.toFixed(3));
         if(this.fastestLast2 == 0 && this.tSpeed2 == this.startSpeed)
         {
            this.tw2 = TweenLite.to(this._sixBogu2,this.tSpeed2 + 0.1,{
               "y":this._boguTypePoints[bg].y,
               "ease":Back.easeOut
            });
         }
         else
         {
            this.tw2 = TweenLite.to(this._sixBogu2,this.tSpeed2,{
               "y":this._boguTypePoints[2].y,
               "ease":Linear.easeNone,
               "onComplete":this._sixBogu2Com,
               "onCompleteParams":[bg]
            });
         }
      }
      
      private function _sixBogu3Com(bg:int) : void
      {
         this.tw3.kill();
         this._sixBogu3.y = this._boguTypePoints[0].y;
         this.tSpeed3 = Number(this.tSpeed3.toFixed(3));
         if(this.fastestLast3 > 0 && this.tSpeed3 > this.fastest)
         {
            this.tSpeed3 -= this.tempSpeed;
         }
         else if(this.fastestLast3 > 0 && this.tSpeed3 == this.fastest)
         {
            --this.fastestLast3;
            this._sixBogu3.gotoAndStop(2);
         }
         else if(this.tSpeed3 < this.startSpeed)
         {
            this.tSpeed3 += this.tempSpeed;
            this._sixBogu3.gotoAndStop(1);
         }
         this.tSpeed3 = Number(this.tSpeed3.toFixed(3));
         if(this.fastestLast3 == 0 && this.tSpeed3 == this.startSpeed)
         {
            this.tw3 = TweenLite.to(this._sixBogu3,this.tSpeed3 + 0.1,{
               "y":this._boguTypePoints[bg].y,
               "ease":Back.easeOut,
               "onComplete":this.__lotteryCom
            });
         }
         else
         {
            this.tw3 = TweenLite.to(this._sixBogu3,this.tSpeed3,{
               "y":this._boguTypePoints[2].y,
               "ease":Linear.easeNone,
               "onComplete":this._sixBogu3Com,
               "onCompleteParams":[bg]
            });
         }
      }
      
      private function __lotteryCom() : void
      {
         this._finallyLight.visible = true;
         if(this._sixBogu1.y == this._sixBogu2.y)
         {
            this._shine1.visible = this._shine2.visible = true;
            this._shine1.gotoAndPlay(1);
            this._shine2.gotoAndPlay(1);
         }
         if(this._sixBogu1.y == this._sixBogu3.y)
         {
            this._shine1.visible = this._shine3.visible = true;
            this._shine1.gotoAndPlay(1);
            this._shine3.gotoAndPlay(1);
         }
         if(this._sixBogu2.y == this._sixBogu3.y)
         {
            this._shine2.visible = this._shine3.visible = true;
            this._shine2.gotoAndPlay(1);
            this._shine3.gotoAndPlay(1);
         }
         var lm:int = this._multiple;
         if(lm > 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.ddPlay.view.getMoney",lm));
            ChatManager.Instance.sysChatLinkYellow(LanguageMgr.GetTranslation("tank.ddPlay.view.getMoney",lm));
         }
         switch(lm)
         {
            case 3:
               this._tripleMc.visible = true;
               break;
            case 5:
               this._fivefoldMc.visible = true;
               break;
            case 10:
               this._tenfoldMc.visible = true;
               this._finallyFireWork.visible = true;
         }
         if(this._stopUpBtn.visible == false)
         {
            this._upBtn.enable = true;
            this._selectedTxt.enable = true;
         }
         this.isPlaying = false;
         this._scoreTxt.text = DDPlayManaer.Instance.DDPlayScore.toString();
         this._coinsTxt.text = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.DDPLAY_COIN).toString();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         InviteManager.Instance.enabled = true;
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._sixBogu1);
         this._sixBogu1 = null;
         ObjectUtils.disposeObject(this._sixBogu2);
         this._sixBogu2 = null;
         ObjectUtils.disposeObject(this._sixBogu3);
         this._sixBogu3 = null;
         ObjectUtils.disposeObject(this._boguMaskSp1);
         this._boguMaskSp1 = null;
         ObjectUtils.disposeObject(this._boguMaskSp2);
         this._boguMaskSp2 = null;
         ObjectUtils.disposeObject(this._boguMaskSp3);
         this._boguMaskSp3 = null;
         ObjectUtils.disposeObject(this._boguMask1);
         this._boguMask1 = null;
         ObjectUtils.disposeObject(this._boguMask2);
         this._boguMask2 = null;
         ObjectUtils.disposeObject(this._boguMask3);
         this._boguMask3 = null;
         ObjectUtils.disposeObject(this._tripleMc);
         this._tripleMc = null;
         ObjectUtils.disposeObject(this._fivefoldMc);
         this._fivefoldMc = null;
         ObjectUtils.disposeObject(this._tenfoldMc);
         this._tenfoldMc = null;
         ObjectUtils.disposeObject(this._triple);
         this._triple = null;
         ObjectUtils.disposeObject(this._fivefold);
         this._fivefold = null;
         ObjectUtils.disposeObject(this._tenfold);
         this._tenfold = null;
         ObjectUtils.disposeObject(this._lights);
         this._lights = null;
         ObjectUtils.disposeObject(this._shine1);
         this._shine1 = null;
         ObjectUtils.disposeObject(this._shine2);
         this._shine2 = null;
         ObjectUtils.disposeObject(this._shine3);
         this._shine3 = null;
         ObjectUtils.disposeObject(this._titleLight);
         this._titleLight = null;
         ObjectUtils.disposeObject(this._finallyLight);
         this._finallyLight = null;
         ObjectUtils.disposeObject(this._finallyFireWork);
         this._finallyFireWork = null;
         ObjectUtils.disposeObject(this._upBtn);
         this._upBtn = null;
         ObjectUtils.disposeObject(this._stopUpBtn);
         this._stopUpBtn = null;
         ObjectUtils.disposeObject(this._selectedTxt);
         this._selectedTxt = null;
         ObjectUtils.disposeObject(this._exchangeBtn);
         this._exchangeBtn = null;
         ObjectUtils.disposeObject(this._explameTxt);
         this._explameTxt = null;
         ObjectUtils.disposeObject(this._coinsTxt);
         this._coinsTxt = null;
         ObjectUtils.disposeObject(this._coinsTxt);
         this._coinsTxt = null;
         ObjectUtils.disposeObject(this._exchangeFrame);
         this._exchangeFrame = null;
         super.dispose();
      }
   }
}

