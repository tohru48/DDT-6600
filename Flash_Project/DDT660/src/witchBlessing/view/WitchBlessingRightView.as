package witchBlessing.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import witchBlessing.WitchBlessingManager;
   import witchBlessing.data.WitchBlessingPackageInfo;
   
   public class WitchBlessingRightView extends Sprite implements Disposeable
   {
      
      private var blessingLV:int = 1;
      
      private var _rightViewMidBg:Bitmap;
      
      private var _rightViewSmallBg:Bitmap;
      
      private var _noBlessing:Bitmap;
      
      private var _AwardsView:Sprite = new Sprite();
      
      private var _awardsTxt:FilterFrameText;
      
      private var _awardsTxt1:FilterFrameText;
      
      private var _awardsTxt2:FilterFrameText;
      
      private var _nextTimeTxt:FilterFrameText;
      
      private var propertyArr1:Array = ["defense","agility","recovery","magicAttack"];
      
      private var propertyArr2:Array = ["attact","luck","damage","magicDefence"];
      
      private var property1:Array = [50,50,20,50];
      
      private var property2:Array = [50,50,30,50];
      
      private var _getAwardsBtn:BaseButton;
      
      private var _getDoubleAwardsBtn:BaseButton;
      
      private var cdTime:int = 0;
      
      private var _timer:Timer;
      
      private var canGetAwardsFlag:Boolean = false;
      
      private var awardsNum:int;
      
      private var allNum:int;
      
      private var doubleMoney:int = 0;
      
      private var sec:int;
      
      private var min:int;
      
      private var hour:int;
      
      private var str:String;
      
      public function WitchBlessingRightView(type:int, num:int = 0, money:int = 0)
      {
         this.blessingLV = type;
         this.allNum = num;
         this.doubleMoney = money;
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var tempNum:int = 0;
         var txtArr:Array = null;
         var i:int = 0;
         var txt:FilterFrameText = null;
         var ii:int = 0;
         addChild(this._AwardsView);
         PositionUtils.setPos(this._AwardsView,"witchBlessing.AwardsViewPos");
         this._getAwardsBtn = ComponentFactory.Instance.creat("witchBlessing.getAwardsBtn");
         this._getAwardsBtn.enable = false;
         this._getDoubleAwardsBtn = ComponentFactory.Instance.creat("witchBlessing.getDoubleAwardsBtn");
         this._getDoubleAwardsBtn.enable = false;
         this._noBlessing = ComponentFactory.Instance.creat("asset.witchBlessing.noBlessing");
         addChild(this._noBlessing);
         addChild(this._getAwardsBtn);
         addChild(this._getDoubleAwardsBtn);
         this._nextTimeTxt = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.nextTimeTxt");
         this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.nextTimeTxt");
         addChild(this._nextTimeTxt);
         this._awardsTxt1 = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.awardsTxt");
         this._awardsTxt1.text = LanguageMgr.GetTranslation("witchBlessing.view.awardsTxt1",3,3);
         addChild(this._awardsTxt1);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         if(this.blessingLV > 1)
         {
            this._rightViewMidBg = ComponentFactory.Instance.creat("asset.witchBlessing.rightViewMidBg");
            addChild(this._rightViewMidBg);
            this._awardsTxt = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.awardsTxt");
            this._awardsTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.awardsTxt2");
            addChild(this._awardsTxt);
            PositionUtils.setPos(this._awardsTxt,"witchBlessing.AwardsTxt2Pos");
            txtArr = [];
            for(i = 1; i < 5; i++)
            {
               txt = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.propertyTxt");
               PositionUtils.setPos(txt,"witchBlessing.propertyTxtPos");
               txtArr.push(txt);
               txt.text = LanguageMgr.GetTranslation("tank.view.personalinfoII." + this.propertyArr1[i - 1]) + "+" + this.property1[i - 1];
               if(i != 1)
               {
                  txt.x += tempNum;
               }
               tempNum += txt.width + 20;
               addChild(txt);
            }
            if(this.blessingLV > 2)
            {
               this._rightViewSmallBg = ComponentFactory.Instance.creat("asset.witchBlessing.rightViewSmallBg");
               addChild(this._rightViewSmallBg);
               this._awardsTxt2 = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.awardsTxt");
               this._awardsTxt2.text = LanguageMgr.GetTranslation("witchBlessing.view.awardsTxt3");
               addChild(this._awardsTxt2);
               PositionUtils.setPos(this._awardsTxt2,"witchBlessing.AwardsTxt3Pos");
               tempNum = 0;
               for(ii = 1; ii < 5; ii++)
               {
                  txtArr[ii - 1].text = LanguageMgr.GetTranslation("tank.view.personalinfoII." + this.propertyArr2[ii - 1]) + "+" + this.property2[ii - 1];
                  PositionUtils.setPos(txtArr[ii - 1],"witchBlessing.propertyTxtPos");
                  if(i != 1)
                  {
                     txtArr[ii - 1].x += tempNum;
                  }
                  tempNum += txtArr[ii - 1].width + 20;
               }
            }
         }
         this.initAwards();
      }
      
      private function initEvent() : void
      {
         this._getAwardsBtn.addEventListener(MouseEvent.CLICK,this.getAwardsFunc);
         this._getDoubleAwardsBtn.addEventListener(MouseEvent.CLICK,this.getDoubleAwardsFunc);
      }
      
      private function getAwardsFunc(ee:MouseEvent) : void
      {
         SocketManager.Instance.out.sendWitchGetAwards(this.blessingLV);
      }
      
      private function getDoubleAwardsFunc(ee:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         var alert1:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < this.doubleMoney)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("witchBlessing.view.haveNoMoney"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,1);
            alert.addEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         }
         else
         {
            alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("witchBlessing.view.doubleGetAwardsMoney",this.doubleMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,1);
            alert1.addEventListener(FrameEvent.RESPONSE,this.__getDoubleAwards);
         }
      }
      
      private function __getDoubleAwards(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         alert.disposeChildren = true;
         alert.dispose();
         alert = null;
         if(e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendWitchGetAwards(this.blessingLV,true);
         }
      }
      
      private function __onNoMoneyResponse(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         alert.disposeChildren = true;
         alert.dispose();
         alert = null;
         if(e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __timer(e:TimerEvent) : void
      {
         this.timeCountingFunc();
         this.cdTime -= 1000;
      }
      
      private function timeCountingFunc() : void
      {
         if(this.cdTime <= 0)
         {
            this._timer.stop();
            if(this.awardsNum > 0 && this.blessingLV <= WitchBlessingManager.Instance.frame.nowLv)
            {
               this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.canGetAwardsTxt");
               this.isCanGetAwards(true);
               this.cannotBlessing(true);
            }
            else
            {
               if(this.blessingLV > WitchBlessingManager.Instance.frame.nowLv)
               {
                  this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.notEnoughLv");
                  this.cannotBlessing(false);
               }
               else
               {
                  this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.noAwardsTxt");
                  this.cannotBlessing(true);
               }
               this.isCanGetAwards(false);
            }
         }
         else
         {
            if(this.awardsNum == 0)
            {
               this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.noAwardsTxt");
               if(this.blessingLV > WitchBlessingManager.Instance.frame.nowLv)
               {
                  this.cannotBlessing(false);
               }
               else
               {
                  this.cannotBlessing(true);
               }
            }
            else if(this.blessingLV > WitchBlessingManager.Instance.frame.nowLv)
            {
               this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.notEnoughLv");
               this.cannotBlessing(false);
            }
            else
            {
               this.sec = int(this.cdTime / 1000);
               this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.nextTimeTxt",this.transSecond(this.sec));
               this.cannotBlessing(true);
            }
            this.isCanGetAwards(false);
         }
      }
      
      public function cannotBlessing(val:Boolean) : void
      {
         this._noBlessing.visible = !val;
      }
      
      private function isCanGetAwards(val:Boolean) : void
      {
         if(this.canGetAwardsFlag == val)
         {
            return;
         }
         if(val)
         {
            this._getAwardsBtn.enable = true;
            this._getDoubleAwardsBtn.enable = true;
         }
         else
         {
            this._getAwardsBtn.enable = false;
            this._getDoubleAwardsBtn.enable = false;
         }
         this.canGetAwardsFlag = val;
      }
      
      private function transSecond(num:Number) : String
      {
         var hour:int = Math.floor(num / 3600);
         var min:int = Math.floor((num - hour * 3600) / 60);
         var sec:int = num - hour * 3600 - min * 60;
         if(hour > 0)
         {
            this.str = hour + "" + LanguageMgr.GetTranslation("hour") + min + LanguageMgr.GetTranslation("minute");
         }
         else if(min > 0)
         {
            this.str = min + "" + LanguageMgr.GetTranslation("minute") + sec + "" + LanguageMgr.GetTranslation("second");
         }
         else
         {
            this.str = sec + "" + LanguageMgr.GetTranslation("second");
         }
         return this.str;
      }
      
      public function flushCDTime(sec:int) : void
      {
         this.cdTime = sec;
         if(this.cdTime > 0 && !this._timer.running)
         {
            this._timer.start();
         }
         this.timeCountingFunc();
      }
      
      public function flushGetAwardsTimes(num:int) : void
      {
         this.awardsNum = this.allNum - num;
         this._awardsTxt1.text = LanguageMgr.GetTranslation("witchBlessing.view.awardsTxt1",this.allNum,this.awardsNum);
      }
      
      private function initAwards() : void
      {
         var info:WitchBlessingPackageInfo = null;
         var itemInfo:ItemTemplateInfo = null;
         var bg:Bitmap = null;
         var cell:BagCell = null;
         var awardsArr:Array = WitchBlessingManager.Instance.model.itemInfoList;
         var tempNum:int = 340 / (awardsArr[this.blessingLV - 1].length - 1);
         for(var i:int = 0; i < awardsArr[this.blessingLV - 1].length; i++)
         {
            info = awardsArr[this.blessingLV - 1][i] as WitchBlessingPackageInfo;
            itemInfo = ItemManager.Instance.getTemplateById(info.TemplateID) as ItemTemplateInfo;
            bg = ComponentFactory.Instance.creatBitmap("asset.witchBlessing.sugerBox");
            cell = new BagCell(i,itemInfo,false,bg,false);
            cell.setContentSize(62,62);
            cell.PicPos = new Point(3,3);
            cell.setCount(info.Count);
            cell.x = i * tempNum;
            this._AwardsView.addChild(cell);
         }
      }
      
      public function dispose() : void
      {
         this._timer.stop();
         this._timer = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._rightViewMidBg))
         {
            this._rightViewMidBg = null;
         }
         if(Boolean(this._rightViewSmallBg))
         {
            this._rightViewSmallBg = null;
         }
         if(Boolean(this._noBlessing))
         {
            this._noBlessing = null;
         }
         if(Boolean(this._AwardsView))
         {
            this._AwardsView = null;
         }
         if(Boolean(this._awardsTxt))
         {
            this._awardsTxt = null;
         }
         if(Boolean(this._awardsTxt1))
         {
            this._awardsTxt1 = null;
         }
         if(Boolean(this._awardsTxt2))
         {
            this._awardsTxt2 = null;
         }
         if(Boolean(this._nextTimeTxt))
         {
            this._nextTimeTxt = null;
         }
      }
   }
}

