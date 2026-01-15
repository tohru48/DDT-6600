package ddt.view.bossbox
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.BossBoxManager;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.Helpers;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AwardsView extends Frame
   {
      
      public static const HAVEBTNCLICK:String = "_haveBtnClick";
      
      private var _timeTip:ScaleFrameImage;
      
      private var _goodsList:Array;
      
      private var _boxType:int;
      
      private var _button:TextButton;
      
      private var list:AwardsGoodsList;
      
      private var GoodsBG:ScaleBitmapImage;
      
      private var _view:MutipleImage;
      
      public function AwardsView()
      {
         super();
         this.initII();
         this.initEvent();
      }
      
      private function initII() : void
      {
         InviteManager.Instance.enabled = false;
         titleText = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
         this.GoodsBG = ComponentFactory.Instance.creat("bossbox.scale9GoodsImage");
         addToContent(this.GoodsBG);
         this._view = ComponentFactory.Instance.creat("bossbox.AwardsAsset");
         addToContent(this._view);
         this._timeTip = ComponentFactory.Instance.creat("bossbox.TipAsset");
         addToContent(this._timeTip);
         this._button = ComponentFactory.Instance.creat("bossbox.BoxGetButton");
         this._button.text = LanguageMgr.GetTranslation("ok");
         addToContent(this._button);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._button.addEventListener(MouseEvent.CLICK,this._click);
      }
      
      private function _click(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(AwardsView.HAVEBTNCLICK));
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      public function set boxType(value:int) : void
      {
         this._boxType = value + 1;
         this._timeTip.setFrame(this._boxType);
         if(this._boxType == 3)
         {
            this.GoodsBG.height = 83;
            this._button.y = 177;
         }
         else if(this._boxType == 4)
         {
            this._button.visible = false;
         }
         else if(this._boxType == 5)
         {
            this.GoodsBG.height = 230;
            this._button.visible = false;
         }
         else
         {
            this.GoodsBG.height = 203;
            this._button.y = 297;
         }
      }
      
      public function get boxType() : int
      {
         return this._boxType;
      }
      
      public function set goodsList(templateIds:Array) : void
      {
         this._goodsList = templateIds;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.show(this._goodsList);
         addChild(this.list);
      }
      
      public function set vipAwardGoodsList(templateIds:Array) : void
      {
         this._goodsList = templateIds;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.showForVipAward(this._goodsList);
         addChild(this.list);
      }
      
      public function set fightLibAwardGoodList(templateids:Array) : void
      {
         this.goodsList = templateids;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.show(this._goodsList);
         addChild(this.list);
      }
      
      public function setCheck() : void
      {
         closeButton.visible = true;
         this._button.enable = false;
         this._timeTip.visible = false;
         var txt:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("bossbox.TheNextTimeText");
         addToContent(txt);
         txt.text = LanguageMgr.GetTranslation("ddt.view.bossbox.AwardsView.TheNextTimeText",this.updateTime());
      }
      
      private function updateTime() : String
      {
         var _timeSum:Number = BossBoxManager.instance.delaySumTime * 1000 + TimeManager.Instance.Now().time;
         var date:Date = new Date(_timeSum);
         var _hours:int = date.hours;
         var _minute:int = date.minutes;
         var str:String = "";
         if(_hours < 10)
         {
            str += "0" + _hours;
         }
         else
         {
            str += _hours;
         }
         str += "da";
         if(_minute < 10)
         {
            str += "0" + _minute;
         }
         else
         {
            str += _minute;
         }
         return str + "dakika";
      }
      
      override public function dispose() : void
      {
         super.dispose();
         InviteManager.Instance.enabled = true;
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(Boolean(this._timeTip))
         {
            ObjectUtils.disposeObject(this._timeTip);
         }
         this._timeTip = null;
         if(Boolean(this._button))
         {
            this._button.removeEventListener(MouseEvent.CLICK,this._click);
            ObjectUtils.disposeObject(this._button);
         }
         this._button = null;
         if(Boolean(this.list))
         {
            ObjectUtils.disposeObject(this.list);
         }
         this.list = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get goodsList() : Array
      {
         return Helpers.clone(this._goodsList) as Array;
      }
   }
}

