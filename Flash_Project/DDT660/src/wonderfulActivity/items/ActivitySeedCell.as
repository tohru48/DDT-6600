package wonderfulActivity.items
{
   import baglocked.BaglockedManager;
   import calendar.view.goodsExchange.GoodsExchangeCell;
   import calendar.view.goodsExchange.GoodsExchangeInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import wonderfulActivity.event.ActivityEvent;
   
   public class ActivitySeedCell extends GoodsExchangeCell
   {
      
      private var _id:int;
      
      private var _autumnAnimation:MovieClip;
      
      private var _getAwardAnimation:MovieClip;
      
      private var _seedBtn:BaseButton;
      
      private var _getAwardBtn:BaseButton;
      
      private var _midFlag:Boolean;
      
      public function ActivitySeedCell(exchangeInfo:GoodsExchangeInfo, activeType:int = -1, id:int = -1, type:Boolean = true)
      {
         this._id = id;
         super(exchangeInfo,activeType,type,this._id);
      }
      
      public function addSeedBtn() : void
      {
         this._seedBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.seedButton");
         addChild(this._seedBtn);
         this._seedBtn.visible = false;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         this._seedBtn.addEventListener(MouseEvent.CLICK,this.__onSeedBtnClick);
      }
      
      protected function __onSeedBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
      }
      
      protected function __onMouseOver(event:MouseEvent) : void
      {
         this._seedBtn.visible = true;
      }
      
      protected function __onMouseOut(event:MouseEvent) : void
      {
         this._seedBtn.visible = false;
      }
      
      public function addAwardAnimation() : void
      {
         this._midFlag = true;
         if(Boolean(this._autumnAnimation))
         {
            return;
         }
         this._autumnAnimation = ComponentFactory.Instance.creat("asset.activity.midautumnAnimation");
         addChild(this._autumnAnimation);
         this._getAwardAnimation = ComponentFactory.Instance.creat("asset.activity.getAwardAnimation");
         PositionUtils.setPos(this._getAwardAnimation,"ddtcalendar.midAutumnView.getAwardAnimation");
         addChild(this._getAwardAnimation);
         this._getAwardAnimation.stop();
         this._getAwardBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.getAwardBtn");
         addChild(this._getAwardBtn);
         this._getAwardBtn.addEventListener(MouseEvent.CLICK,this.__onGetAwardClick);
      }
      
      public function addFireworkAnimation(level:int) : void
      {
         if(Boolean(this._autumnAnimation))
         {
            return;
         }
         this._autumnAnimation = ComponentFactory.Instance.creat("asset.activity.midautumnAnimation");
         addChild(this._autumnAnimation);
         this._getAwardAnimation = ComponentFactory.Instance.creat("asset.activity.fireworkAnimation" + level);
         PositionUtils.setPos(this._getAwardAnimation,"ddtcalendar.nationalDayView.fireworkPlayPos0");
         addChild(this._getAwardAnimation);
         this._getAwardAnimation.stop();
         this._getAwardBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.midAutumn.getAwardBtn");
         addChild(this._getAwardBtn);
         this._getAwardBtn.addEventListener(MouseEvent.CLICK,this.__onGetAwardClick);
      }
      
      public function removeFireworkAnimation() : void
      {
         if(Boolean(this._autumnAnimation))
         {
            this._autumnAnimation.parent.removeChild(this._autumnAnimation);
            this._autumnAnimation = null;
         }
         if(Boolean(this._getAwardAnimation))
         {
            this._getAwardAnimation.parent.removeChild(this._getAwardAnimation);
            this._getAwardAnimation = null;
         }
         if(Boolean(this._getAwardBtn))
         {
            this._getAwardBtn.removeEventListener(MouseEvent.CLICK,this.__onGetAwardClick);
            this._getAwardBtn.dispose();
            this._getAwardBtn = null;
         }
      }
      
      protected function __onGetAwardClick(event:MouseEvent) : void
      {
         var i:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._getAwardAnimation.gotoAndPlay("play");
         if(this._midFlag)
         {
            SoundManager.instance.play("008");
         }
         else
         {
            SoundManager.instance.play("117");
            for(i = 0; i < 3; i++)
            {
               if(i == this._id)
               {
                  PositionUtils.setPos(this._getAwardAnimation,"ddtcalendar.nationalDayView.fireworkPlayPos" + i);
                  break;
               }
            }
         }
         var evt:ActivityEvent = new ActivityEvent(ActivityEvent.SEND_GOOD);
         evt.id = this._id;
         dispatchEvent(evt);
      }
      
      override public function get needCount() : int
      {
         return haveCount - gooodsExchangeInfo.ItemCount * gooodsExchangeInfo.Num;
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
         this._autumnAnimation = null;
         this._getAwardAnimation = null;
         if(Boolean(this._seedBtn))
         {
            this._seedBtn.removeEventListener(MouseEvent.CLICK,this.__onSeedBtnClick);
            this._seedBtn.dispose();
            this._seedBtn = null;
         }
         if(Boolean(this._getAwardBtn))
         {
            this._getAwardBtn.removeEventListener(MouseEvent.CLICK,this.__onGetAwardClick);
            this._getAwardBtn.dispose();
            this._getAwardBtn = null;
         }
         super.dispose();
      }
   }
}

