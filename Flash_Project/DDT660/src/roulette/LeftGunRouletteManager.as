package roulette
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import wonderfulActivity.items.LuckPanView;
   
   public class LeftGunRouletteManager extends EventDispatcher
   {
      
      private static var _instance:LeftGunRouletteManager = null;
      
      private static const TYPE_ROULETTE:int = 1;
      
      private static const TYPEI_ISOPEN:int = 1;
      
      private static const MAX_LENGTH:int = 20;
      
      private var _rouletteView:RouletteFrame;
      
      public var reward:String;
      
      public var gCount:int;
      
      private var _alertAward:BaseAlerFrame;
      
      private var _helpPage:HelpFrame;
      
      private var _helpBg:MutipleImage;
      
      private var _maxTicket:FilterFrameText;
      
      public var IsOpen:Boolean;
      
      public var ArrNum:Array;
      
      public var isFrist:Boolean = false;
      
      private var _isvisible:Boolean = true;
      
      private var isShow:Boolean;
      
      private var _content:Sprite;
      
      public function LeftGunRouletteManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : LeftGunRouletteManager
      {
         if(_instance == null)
         {
            _instance = new LeftGunRouletteManager();
         }
         return _instance;
      }
      
      public function init() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LEFT_GUN_ROULETTE,this.__openRoulett);
      }
      
      private function __openRoulett(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var typeI:int = 0;
         var count:int = 0;
         var result:String = null;
         var i:int = 0;
         var num:int = 0;
         pkg = event.pkg;
         var type:int = pkg.readInt();
         switch(type)
         {
            case TYPE_ROULETTE:
               typeI = pkg.readInt();
               switch(typeI)
               {
                  case TYPEI_ISOPEN:
                     this.IsOpen = pkg.readBoolean();
                     if(this.IsOpen)
                     {
                        this.isFrist = true;
                        count = pkg.readInt();
                        result = pkg.readUTF();
                        dispatchEvent(new RouletteFrameEvent(RouletteFrameEvent.LEFTGUN_ENABLE));
                        if(count <= 0 && result == "0")
                        {
                           this.reward = result;
                           this._isvisible = false;
                           return;
                        }
                        this.gCount = count;
                        this.reward = result;
                        this._isvisible = true;
                        this.ArrNum = new Array();
                        for(i = 0; i < MAX_LENGTH; i++)
                        {
                           num = pkg.readInt();
                           this.ArrNum.push(num);
                        }
                        this.showGunButton();
                     }
                     else
                     {
                        this.hideGunButton();
                     }
               }
         }
      }
      
      public function showGunButton() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LEFTGUNROULETTE,true);
      }
      
      public function hideGunButton() : void
      {
         SoundManager.instance.playMusic("062");
         this.removeGunBtn();
         if(Boolean(this._alertAward))
         {
            this._alertAward.removeEventListener(FrameEvent.RESPONSE,this.__goRenewal);
            this._alertAward.dispose();
            this._alertAward = null;
         }
         if(Boolean(this._rouletteView))
         {
            this._rouletteView.removeEventListener(RouletteFrameEvent.ROULETTE_VISIBLE,this.__isVisible);
            this._rouletteView.removeEventListener(RouletteFrameEvent.BUTTON_CLICK,this.__buttonClick);
            this._rouletteView.dispose();
            this._rouletteView = null;
         }
         if(Boolean(this._helpBg))
         {
            ObjectUtils.disposeObject(this._helpBg);
            this._helpBg = null;
         }
         if(Boolean(this._maxTicket))
         {
            ObjectUtils.disposeObject(this._maxTicket);
            this._maxTicket = null;
         }
         if(Boolean(this._helpPage))
         {
            ObjectUtils.disposeObject(this._helpPage);
            this._helpPage = null;
         }
      }
      
      private function removeGunBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LEFTGUNROULETTE,false);
      }
      
      public function showTurnplate() : void
      {
         var _view:LuckPanView = null;
         if(this._isvisible)
         {
            SoundManager.instance.playMusic("140");
            _view = new LuckPanView();
            _view.init();
            _view.x = -227;
            HallIconManager.instance.showCommonFrame(_view,"wonderfulActivityManager.btnTxt5");
         }
         else
         {
            this.showTipFrame(this.reward);
         }
      }
      
      private function showTipFrame(reward:String) : void
      {
         var msg:String = LanguageMgr.GetTranslation("tank.roulette.tipInfo",reward);
         this._alertAward = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._alertAward.moveEnable = false;
         this._alertAward.addEventListener(FrameEvent.RESPONSE,this.__goRenewal);
      }
      
      public function showhelpFrame() : void
      {
         this._helpBg = ComponentFactory.Instance.creatComponentByStylename("roulette.helpConent.bg");
         this._maxTicket = ComponentFactory.Instance.creatComponentByStylename("roulette.helpConent.ticketText");
         this._maxTicket.text = ServerConfigManager.instance.RouletteMaxTicket;
         this._helpPage = ComponentFactory.Instance.creat("roulette.helpFrame");
         this._helpPage.setView(this._helpBg);
         this._helpPage.setView(this._maxTicket);
         this._helpPage.titleText = LanguageMgr.GetTranslation("tank.roulette.helpView.tltle");
         LayerManager.Instance.addToLayer(this._helpPage,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
      }
      
      private function getReward(str:String) : String
      {
         var reward:String = null;
         var num:Array = str.split(".");
         var num1:int = int(num[0]);
         var num2:int = int(num[1]);
         var num3:int = num1 - 1;
         if(num3 == 0)
         {
            reward = num2 + "0" + "%";
         }
         else
         {
            reward = num3.toString() + num2.toString() + "0" + "%";
         }
         return reward;
      }
      
      public function createFrame(p:Sprite = null) : void
      {
         this._content = p;
         if(!this.isShow)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ROULETTE);
         }
         else
         {
            if(this._rouletteView == null)
            {
               this._rouletteView = new RouletteFrame();
            }
            this._rouletteView.addEventListener(RouletteFrameEvent.ROULETTE_VISIBLE,this.__isVisible);
            this._rouletteView.addEventListener(RouletteFrameEvent.BUTTON_CLICK,this.__buttonClick);
            if(Boolean(p))
            {
               p.addChild(this._rouletteView);
            }
            else
            {
               LayerManager.Instance.addToLayer(this._rouletteView,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
            }
            PositionUtils.setPos(this._rouletteView,"asset.rouletteFramePos");
         }
      }
      
      public function setRouletteFramenull() : void
      {
         this._rouletteView = null;
      }
      
      private function __onSmallLoadingClose(e:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      private function __onUIComplete(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.ROULETTE)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            this.isShow = true;
            this.createFrame(this._content);
         }
      }
      
      private function __onUIProgress(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.ROULETTE)
         {
            UIModuleSmallLoading.Instance.progress = e.loader.progress * 100;
         }
      }
      
      private function __goRenewal(evt:FrameEvent) : void
      {
         if(Boolean(this._alertAward))
         {
            this._alertAward.removeEventListener(FrameEvent.RESPONSE,this.__goRenewal);
         }
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               LeavePageManager.leaveToFillPath();
         }
         this._alertAward.dispose();
         if(Boolean(this._alertAward.parent))
         {
            this._alertAward.parent.removeChild(this._alertAward);
         }
         this._alertAward = null;
      }
      
      private function __isVisible(event:RouletteFrameEvent) : void
      {
         this._isvisible = false;
         this.reward = event.reward;
      }
      
      private function __buttonClick(event:RouletteFrameEvent) : void
      {
         this.showTipFrame(this.reward);
      }
      
      public function onGunBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.showTurnplate();
      }
   }
}

