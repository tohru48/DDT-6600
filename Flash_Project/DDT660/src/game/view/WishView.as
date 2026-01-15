package game.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.LivingEvent;
   import ddt.events.SharedEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   import game.model.LocalPlayer;
   
   public class WishView extends Sprite implements Disposeable
   {
      
      public static const WISH_CLICK:String = "wishClick";
      
      private const MOVE_DISTANCE:int = 150;
      
      private var _wishButtom:BaseButton;
      
      private var _timesRecording:Number;
      
      private var _text:FilterFrameText;
      
      private var _self:LocalPlayer;
      
      private var _level:int;
      
      private var _isFirstWish:Boolean;
      
      private var _textBg:ScaleBitmapImage;
      
      private var _panelBtn:SelectedButton;
      
      private var _useReduceEnerge:int;
      
      private var _freeTimes:int;
      
      public function WishView(info:LocalPlayer, pop:Boolean)
      {
         var level:int = 0;
         super();
         this._self = info;
         this._level = this._self.playerInfo.Grade;
         this._timesRecording = 1;
         this._isFirstWish = SharedManager.Instance.isFirstWish;
         this._wishButtom = ComponentFactory.Instance.creatComponentByStylename("wishView.wishBtn");
         this._wishButtom.enable = false;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            level = PlayerManager.Instance.Self.VIPLevel;
            this._useReduceEnerge = int(ServerConfigManager.instance.VIPPayAimEnergy[level - 1]);
         }
         else
         {
            this._useReduceEnerge = ServerConfigManager.instance.PayAimEnergy;
         }
         this._wishButtom.tipData = LanguageMgr.GetTranslation("ddt.games.wishofdd",this._useReduceEnerge);
         addChild(this._wishButtom);
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("core.wishView.bg");
         addChild(this._textBg);
         this._panelBtn = ComponentFactory.Instance.creatComponentByStylename("core.wishView.panelBtn");
         this._panelBtn.tipData = LanguageMgr.GetTranslation("ddt.games.wishofdd",this._useReduceEnerge);
         addChild(this._panelBtn);
         this._text = ComponentFactory.Instance.creatComponentByStylename("wishView.spandTicket");
         this.freeTimes = GameManager.Instance.Current.selfGamePlayer.wishFreeTime;
         addChild(this._text);
         this.addEvent();
         this.initPosition(pop);
         this.stateInit();
      }
      
      protected function addEvent() : void
      {
         this._wishButtom.addEventListener(MouseEvent.CLICK,this.__wishBtnClick);
         this._panelBtn.addEventListener(MouseEvent.CLICK,this.__movePanle);
         this._self.addEventListener(LivingEvent.ENERGY_CHANGED,this.__ennergChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
      }
      
      private function stateInit() : void
      {
         if(this._self.isLiving)
         {
            if((PlayerManager.Instance.Self.Money > this.needMoney || this.freeTimes > 0) && this._self.energy > this._useReduceEnerge)
            {
               this._wishButtom.enable = true;
               this._text.setFrame(1);
            }
            else
            {
               this._wishButtom.enable = false;
               this._text.setFrame(2);
            }
         }
      }
      
      protected function __transparentChanged(SharedEvent:Event) : void
      {
         if(Boolean(parent))
         {
            if(SharedManager.Instance.propTransparent)
            {
               alpha = 0.5;
            }
            else
            {
               alpha = 1;
            }
         }
      }
      
      private function __movePanle(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._panelBtn.selected)
         {
            TweenMax.to(this,0.5,{
               "x":-this.MOVE_DISTANCE,
               "ease":Elastic.easeOut
            });
         }
         else
         {
            TweenMax.to(this,0.5,{
               "x":0,
               "ease":Elastic.easeOut
            });
         }
         SharedManager.Instance.isWishPop = this._panelBtn.selected;
         SharedManager.Instance.save();
      }
      
      protected function removeEvent() : void
      {
         this._wishButtom.removeEventListener(MouseEvent.CLICK,this.__wishBtnClick);
         this._panelBtn.removeEventListener(MouseEvent.CLICK,this.__movePanle);
         this._self.removeEventListener(LivingEvent.ENERGY_CHANGED,this.__ennergChange);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PLAYER_CHANGE,this.__playerChange);
         SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
      }
      
      public function get freeTimes() : int
      {
         return this._freeTimes;
      }
      
      public function set freeTimes(value:int) : void
      {
         this._freeTimes = value;
         if(this._freeTimes > 0)
         {
            this._text.text = LanguageMgr.GetTranslation("ddt.games.spandFreeTimes",this._freeTimes);
         }
         else
         {
            this._text.text = LanguageMgr.GetTranslation("ddt.games.spandTicket",this.needMoney);
         }
      }
      
      private function __playerChange(event:CrazyTankSocketEvent) : void
      {
         this.stateInit();
      }
      
      private function __ennergChange(event:LivingEvent) : void
      {
         if(this._wishButtom.enable)
         {
            this.stateInit();
         }
      }
      
      protected function get needMoney() : Number
      {
         return int(0.1 * this._level * Math.pow(2,this._timesRecording - 1)) + 2;
      }
      
      protected function __wishBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._isFirstWish)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.games.FirstWish"));
            SharedManager.Instance.isFirstWish = false;
            SharedManager.Instance.save();
         }
         if(this._timesRecording >= 10 && PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
         }
         else if(this._self.isLiving && this._self.isAttacking)
         {
            SocketManager.Instance.out.sendWish();
            if(this._freeTimes <= 0)
            {
               ++this._timesRecording;
            }
            this._wishButtom.enable = false;
            this._self.energy -= this._useReduceEnerge;
            dispatchEvent(new Event("wishClick"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.games.cannotuse"));
         }
      }
      
      private function initPosition(isPop:Boolean) : void
      {
         if(isPop)
         {
            this.x = -this.MOVE_DISTANCE;
            this._panelBtn.selected = true;
         }
         else
         {
            this._panelBtn.selected = false;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._wishButtom))
         {
            ObjectUtils.disposeObject(this._wishButtom);
            this._wishButtom = null;
         }
         if(Boolean(this._text))
         {
            ObjectUtils.disposeObject(this._text);
            this._text = null;
         }
      }
   }
}

