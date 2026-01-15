package AvatarCollection.view
{
   import AvatarCollection.AvatarCollectionManager;
   import AvatarCollection.data.AvatarCollectionUnitVo;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AvatarCollectionTimeView extends Sprite implements Disposeable
   {
      
      private var _txt:FilterFrameText;
      
      private var _btn:SimpleBitmapButton;
      
      private var _timer:Timer;
      
      private var _data:AvatarCollectionUnitVo;
      
      private var _needHonor:int;
      
      public function AvatarCollectionTimeView()
      {
         super();
         this.x = 295;
         this.y = 391;
         this.initView();
         this.initEvent();
         this.initTimer();
         this.setDefaultView();
      }
      
      private function initView() : void
      {
         this._txt = ComponentFactory.Instance.creatComponentByStylename("avatarColl.timeView.txt");
         this._btn = ComponentFactory.Instance.creatComponentByStylename("avatarColl.timeView.btn");
         addChild(this._txt);
         addChild(this._btn);
      }
      
      private function initEvent() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AvatarCollectionManager.instance.skipFlag = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var count:int = PlayerManager.Instance.Self.myHonor / this._needHonor;
         var alert:AvatarCollectionDelayConfirmFrame = ComponentFactory.Instance.creatComponentByStylename("avatarColl.delayConfirmFrame");
         alert.show(this._needHonor,count);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onConfirmResponse);
         LayerManager.Instance.addToLayer(alert,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __onConfirmResponse(event:FrameEvent) : void
      {
         var tmpValue:int = 0;
         SoundManager.instance.play("008");
         var alert:AvatarCollectionDelayConfirmFrame = event.currentTarget as AvatarCollectionDelayConfirmFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onConfirmResponse);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            tmpValue = alert.selectValue;
            if(PlayerManager.Instance.Self.myHonor < this._needHonor * tmpValue)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.delayConfirmFrame.noEnoughHonor"));
            }
            else
            {
               SocketManager.Instance.out.sendAvatarCollectionDelayTime(this._data.id,tmpValue);
            }
         }
         alert.dispose();
      }
      
      private function initTimer() : void
      {
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         this.refreshTimePlayTxt();
      }
      
      public function refreshView(data:AvatarCollectionUnitVo) : void
      {
         this._data = data;
         if(!this._data)
         {
            this.setDefaultView();
            this._timer.stop();
            return;
         }
         var totalCount:int = int(this._data.totalItemList.length);
         var activityCount:int = this._data.totalActivityItemCount;
         if(activityCount < totalCount / 2)
         {
            this.setDefaultView();
            this._timer.stop();
            this._needHonor = 99999999;
            return;
         }
         if(activityCount == totalCount)
         {
            this._needHonor = this._data.needHonor * 2;
         }
         else
         {
            this._needHonor = this._data.needHonor;
         }
         this._btn.enable = true;
         this.refreshTimePlayTxt();
         this._timer.start();
      }
      
      private function refreshTimePlayTxt() : void
      {
         var timeTxtStr:String = null;
         var endTimestamp:Number = Number(this._data.endTime.getTime());
         var nowTimestamp:Number = Number(TimeManager.Instance.Now().getTime());
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
         this._txt.text = LanguageMgr.GetTranslation("avatarCollection.timeView.txt") + timeTxtStr;
      }
      
      private function setDefaultView() : void
      {
         this._txt.text = LanguageMgr.GetTranslation("avatarCollection.timeView.txt") + 0 + LanguageMgr.GetTranslation("day");
         this._btn.enable = false;
      }
      
      private function removeEvent() : void
      {
         this._btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         ObjectUtils.disposeAllChildren(this);
         this._txt = null;
         this._btn = null;
         this._timer = null;
         this._data = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

