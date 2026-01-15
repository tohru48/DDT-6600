package bagAndInfo
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.bossbox.AwardsView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import game.GameManager;
   import road7th.comm.PackageIn;
   import bagAndInfo.bag.ring.data.RingDataAnalyzer;
   import bagAndInfo.bag.ring.data.RingSystemData;
   import ddt.manager.PlayerManager;
   
   public class BagAndInfoManager extends EventDispatcher
   {
      
      private static var _instance:BagAndInfoManager;
      
      public static var _firstShowBag:Boolean = true;
      
      public var isInBagAndInfoView:Boolean;
      
      public var isTimePack:Boolean;
      
      private var _bagAndGiftFrame:BagAndGiftFrame;
      
      private var _giftFrame:GiftFrame;
      
      private var _frame:BaseAlerFrame;
      
      public var isUpgradePack:Boolean;
      
      private var _observerDictionary:Dictionary;
      
      private var _progress:int = 0;
      
      private var infos:Array;
      
      private var _type:int = 0;
      
      private var _bagtype:int = 0;
      
      public function BagAndInfoManager(sinle:SingletonForce)
      {
         super();
         this._observerDictionary = new Dictionary();
      }
      
      public static function get Instance() : BagAndInfoManager
      {
         if(_instance == null)
         {
            _instance = new BagAndInfoManager(new SingletonForce());
         }
         return _instance;
      }
      
      public function get isShown() : Boolean
      {
         if(!this._bagAndGiftFrame)
         {
            return false;
         }
         return true;
      }
      
      public function getBagAndGiftFrame() : BagAndGiftFrame
      {
         return this._bagAndGiftFrame;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_OPENUP,this.__openPreviewListFrame);
      }
      
      public function showGiftFrame() : void
      {
         this._giftFrame = new GiftFrame();
         this._giftFrame.backStyle = "SimpleFrameBackgound";
         this._giftFrame.titleStyle = "FrameTitleTextStyle";
         this._giftFrame.titleOuterRectPosString = "15,10,5";
         this._giftFrame.closeInnerRectString = "44,19,6,30,14";
         this._giftFrame.closestyle = "core.closebt";
         this._giftFrame.width = 894;
         this._giftFrame.height = 524;
         LayerManager.Instance.addToLayer(this._giftFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function registerOnPreviewFrameCloseHandler($id:String, $func:Function) : void
      {
         if(this._observerDictionary[$id] != null)
         {
            return;
         }
         this._observerDictionary[$id] = $func;
      }
      
      public function unregisterOnPreviewFrameCloseHandler($id:String) : void
      {
         if(this._observerDictionary[$id] != null)
         {
            delete this._observerDictionary[$id];
         }
      }
      
      private function __createBag(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.BAGANDINFO || event.module == UIModuleTypes.DDTBEAD)
         {
            ++this._progress;
         }
         if(this._progress == 2)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            _firstShowBag = false;
            this.showBagAndInfo(this._type,"",this._bagtype);
         }
      }
	  
	  public var RingData:Dictionary;
	  
	  public function getCurrentRingData() : RingSystemData
	  {
		  var _loc1_:RingSystemData = null;
		  //var _loc2_:int = PlayerManager.Instance.Self.RingExp;
		  var _loc2_:int = 1;
		  var _loc3_:int = 1;
		  while(_loc3_ <= RingSystemData.TotalLevel)
		  {
			  if(_loc2_ <= 0)
			  {
				  _loc1_ = this.RingData[1];
				  break;
			  }
			  if(_loc2_ < this.RingData[_loc3_].Exp)
			  {
				  _loc1_ = this.RingData[_loc3_ - 1];
				  break;
			  }
			  if(_loc3_ == RingSystemData.TotalLevel && _loc2_ >= this.RingData[_loc3_].Exp)
			  {
				  _loc1_ = this.RingData[_loc3_];
			  }
			  _loc3_++;
		  }
		  return _loc1_;
	  }
      
      protected function __openPreviewListFrame(evt:CrazyTankSocketEvent) : void
      {
         var info:InventoryItemInfo = null;
         var pkg:PackageIn = evt.pkg;
         pkg.position = 20;
         var itemName:String = pkg.readUTF();
         var cnt:int = int(pkg.readByte());
         this.infos = [];
         while(Boolean(pkg.bytesAvailable))
         {
            info = new InventoryItemInfo();
            info.TemplateID = pkg.readInt();
            info = ItemManager.fill(info);
            info.Count = pkg.readInt();
            info.IsBinds = pkg.readBoolean();
            info.ValidDate = pkg.readInt();
            info.StrengthenLevel = pkg.readInt();
            info.AttackCompose = pkg.readInt();
            info.DefendCompose = pkg.readInt();
            info.AgilityCompose = pkg.readInt();
            info.LuckCompose = pkg.readInt();
            if(EquipType.isMagicStone(info.CategoryID))
            {
               info.Level = info.StrengthenLevel;
               info.Attack = info.AttackCompose;
               info.Defence = info.DefendCompose;
               info.Agility = info.AgilityCompose;
               info.Luck = info.LuckCompose;
               info.Level = info.StrengthenLevel;
               info.MagicAttack = pkg.readInt();
               info.MagicDefence = pkg.readInt();
            }
            else
            {
               pkg.readInt();
               pkg.readInt();
            }
            this.infos.push(info);
         }
         this.showPreviewFrame(itemName,this.infos);
      }
      
      public function showPreviewFrame(itemName:String, infos:Array) : void
      {
         var aView:AwardsView = null;
         var title:FilterFrameText = null;
         aView = new AwardsView();
         aView.goodsList = infos;
         aView.boxType = 4;
         title = ComponentFactory.Instance.creat("bagandinfo.awardsFFT");
         if(this.isUpgradePack)
         {
            this.isUpgradePack = false;
            title.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle2");
            title.x = 30;
         }
         else
         {
            title.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle");
            title.x = 75;
         }
         this._frame = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ItemPreviewListFrame");
         var ai:AlertInfo = new AlertInfo(itemName);
         ai.showCancel = false;
         ai.moveEnable = false;
         this._frame.info = ai;
         this._frame.addToContent(aView);
         this._frame.addToContent(title);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameClose);
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameClose(event:FrameEvent) : void
      {
         var bAFrame:BaseAlerFrame = null;
         var itemList:Array = null;
         var func:* = undefined;
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SoundManager.instance.play("008");
               bAFrame = event.currentTarget as BaseAlerFrame;
               bAFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               itemList = this.infos;
               bAFrame.dispose();
               SocketManager.Instance.out.sendClearStoreBag();
               for each(func in this._observerDictionary)
               {
                  func(itemList);
               }
         }
      }
      
      public function showBagAndInfo(type:int = 0, name:String = "", bagtype:int = 0) : void
      {
         this._type = type;
         this._bagtype = bagtype;
         if(this._bagAndGiftFrame == null)
         {
            if(_firstShowBag)
            {
               this._progress = 0;
               UIModuleSmallLoading.Instance.progress = 0;
               UIModuleSmallLoading.Instance.show();
               UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
               UIModuleLoader.Instance.addUIModlue(UIModuleTypes.BAGANDINFO);
               UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDTBEAD);
            }
            else
            {
               this._bagAndGiftFrame = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame");
               if(GameManager.exploreOver)
               {
                  this._bagAndGiftFrame.show(8,name,bagtype);
               }
               else
               {
                  this._bagAndGiftFrame.show(type,name,bagtype);
               }
               dispatchEvent(new Event(Event.OPEN));
            }
         }
         else
         {
            this._bagAndGiftFrame.show(type,name,bagtype);
            dispatchEvent(new Event(Event.OPEN));
         }
      }
      
      private function __onUIProgress(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.BAGANDINFO)
         {
            UIModuleSmallLoading.Instance.progress = e.loader.progress * 100;
         }
      }
      
      private function __onSmallLoadingClose(e:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      public function hideBagAndInfo() : void
      {
         if(Boolean(this._bagAndGiftFrame))
         {
            this._bagAndGiftFrame.dispose();
            this._bagAndGiftFrame = null;
            dispatchEvent(new Event(Event.CLOSE));
         }
      }
      
      public function hideGiftFrame() : void
      {
         if(Boolean(this._giftFrame))
         {
            this._giftFrame.dispose();
            this._giftFrame = null;
            dispatchEvent(new Event(Event.CLOSE));
         }
      }
      
      public function clearReference() : void
      {
         this._bagAndGiftFrame = null;
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

class SingletonForce
{
   
   public function SingletonForce()
   {
      super();
   }
}
