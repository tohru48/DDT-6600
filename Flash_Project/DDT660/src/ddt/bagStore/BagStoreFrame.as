package ddt.bagStore
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import ddt.data.store.StoreState;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import powerUp.PowerUpMovieManager;
   import store.StoreController;
   import store.forge.ForgeMainView;
   import store.newFusion.FusionNewManager;
   
   public class BagStoreFrame extends Frame
   {
      
      private var _view:Sprite;
      
      private var _controller:StoreController;
      
      private var _bg:Scale9CornerImage;
      
      private var _storeBtn:SelectedButton;
      
      private var _forgeBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _forgeView:ForgeMainView;
      
      private var _index:int;
      
      private var _fightPower:int;
      
      public function BagStoreFrame()
      {
         super();
         titleText = LanguageMgr.GetTranslation("tank.view.store.title");
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("newStore.mainFrame.bg");
         this._storeBtn = ComponentFactory.Instance.creatComponentByStylename("newStore.tabStoreBtn");
         this._forgeBtn = ComponentFactory.Instance.creatComponentByStylename("newStore.tabForgeBtn");
         addToContent(this._storeBtn);
         addToContent(this._forgeBtn);
         addToContent(this._bg);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._storeBtn);
         this._btnGroup.addSelectItem(this._forgeBtn);
         this._btnGroup.selectIndex = 0;
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler,false,0,true);
         this._storeBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         this._forgeBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
      }
      
      private function __changeHandler(event:Event) : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._view.visible = true;
               if(Boolean(this._forgeView))
               {
                  this._forgeView.visible = false;
               }
               break;
            case 1:
               this._view.visible = false;
               if(!this._forgeView)
               {
                  this._forgeView = new ForgeMainView(this._index);
                  PositionUtils.setPos(this._forgeView,"ddtstore.BagStoreViewPos");
                  addToContent(this._forgeView);
               }
               this._forgeView.visible = true;
         }
      }
      
      private function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function set controller(con:StoreController) : void
      {
         this._controller = con;
      }
      
      public function show(type:String, index:int) : void
      {
         this._fightPower = PlayerManager.Instance.Self.FightPower;
         BagStore.instance.isInBagStoreFrame = true;
         this._index = index;
         this._view = this._controller.getView(this.getStoreType(type));
         addToContent(this._view);
         addEventListener(FrameEvent.RESPONSE,this._response);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         if(type != StoreState.CONSORTIASTORE)
         {
            this._controller.startupEvent();
         }
         if(type == BagStore.FORGE_STORE)
         {
            this._btnGroup.selectIndex = 1;
         }
      }
      
      private function getStoreType(type:String) : String
      {
         if(type == BagStore.BAG_STORE)
         {
            if(PlayerManager.Instance.Self.ConsortiaID != 0)
            {
               type = BagStore.CONSORTIA;
            }
            else
            {
               type = BagStore.GENERAL;
            }
         }
         return type;
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            if(!FusionNewManager.instance.isInContinuousFusion)
            {
               this.dispose();
            }
            BagStore.instance.isInBagStoreFrame = false;
            if(this._fightPower < PlayerManager.Instance.Self.FightPower)
            {
               PowerUpMovieManager.powerNum = this._fightPower;
               PowerUpMovieManager.addedPowerNum = PlayerManager.Instance.Self.FightPower - this._fightPower;
               PowerUpMovieManager.Instance.dispatchEvent(new Event(PowerUpMovieManager.POWER_UP));
            }
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._storeBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._forgeBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._controller.shutdownEvent();
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._view = null;
         this._controller = null;
         this._storeBtn = null;
         this._forgeBtn = null;
         this._btnGroup = null;
         this._forgeView = null;
         BagStore.instance.storeOpenAble = false;
         BagStore.instance.closed();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

