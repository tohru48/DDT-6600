package worldboss.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   
   public class WorldBossBuffIcon extends Sprite implements Disposeable
   {
      
      private var _moneyBtn:SimpleBitmapButton;
      
      private var _buffIcon:WorldBossBuffItem;
      
      public function WorldBossBuffIcon()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var addInjureBuffMoney:int = WorldBossManager.Instance.bossInfo.addInjureBuffMoney;
         var addInjureValue:int = WorldBossManager.Instance.bossInfo.addInjureValue;
         this._moneyBtn = ComponentFactory.Instance.creat("worldbossRoom.money.buffBtn");
         this._moneyBtn.tipData = LanguageMgr.GetTranslation("worldboss.money.buffBtn.tip",addInjureBuffMoney,addInjureValue);
         this._buffIcon = new WorldBossBuffItem();
         PositionUtils.setPos(this._buffIcon,"worldboss.RoomView.BuffIconPos");
         addChild(this._moneyBtn);
         addChild(this._buffIcon);
      }
      
      private function addEvent() : void
      {
         this._moneyBtn.addEventListener(MouseEvent.CLICK,this.buyBuff);
      }
      
      private function buyBuff(event:MouseEvent) : void
      {
         var tag:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SoundManager.instance.playButtonSound();
         if(event.currentTarget == this._moneyBtn)
         {
            tag = 1;
         }
         else
         {
            tag = 2;
         }
         if(tag == 1 && SharedManager.Instance.isWorldBossBuyBuff)
         {
            WorldBossManager.Instance.buyNewBuff(tag,SharedManager.Instance.isWorldBossBuyBuffFull);
            return;
         }
         if(tag == 2 && SharedManager.Instance.isWorldBossBindBuyBuff)
         {
            WorldBossManager.Instance.buyNewBuff(tag,SharedManager.Instance.isWorldBossBindBuyBuffFull);
            return;
         }
         var alert:WorldBossBuyBuffConfirmFrame = ComponentFactory.Instance.creatComponentByStylename("worldboss.buyBuff.confirmFrame");
         alert.show(tag);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:WorldBossBuyBuffConfirmFrame = evt.currentTarget as WorldBossBuyBuffConfirmFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._moneyBtn))
         {
            this._moneyBtn.removeEventListener(MouseEvent.CLICK,this.buyBuff);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
         this._moneyBtn = null;
         this._buffIcon = null;
      }
   }
}

