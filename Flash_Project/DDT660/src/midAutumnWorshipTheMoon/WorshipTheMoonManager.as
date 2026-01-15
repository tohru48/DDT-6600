package midAutumnWorshipTheMoon
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.WorshipTheMoonEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import midAutumnWorshipTheMoon.model.WorshipTheMoonAwardsBoxInfo;
   import midAutumnWorshipTheMoon.model.WorshipTheMoonModel;
   import midAutumnWorshipTheMoon.view.WorshipTheMoonEnterButton;
   import midAutumnWorshipTheMoon.view.WorshipTheMoonMainFrame;
   
   public class WorshipTheMoonManager
   {
      
      private static var instance:WorshipTheMoonManager;
      
      private var _mainFrameMidAutumn:WorshipTheMoonMainFrame;
      
      private var _showFrameBtn:WorshipTheMoonEnterButton;
      
      private var _hall:HallStateView;
      
      public var _isOpen:Boolean = false;
      
      public function WorshipTheMoonManager(single:inner)
      {
         super();
      }
      
      public static function getInstance() : WorshipTheMoonManager
      {
         if(!instance)
         {
            instance = new WorshipTheMoonManager(new inner());
         }
         return instance;
      }
      
      public function init(hall:HallStateView = null) : void
      {
         this._hall = hall;
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(WorshipTheMoonEvent.IS_ACTIVITY_OPEN,this.onResultIsActivityOpen);
         SocketManager.Instance.addEventListener(WorshipTheMoonEvent.AWARDS_LIST,this.onResultAwardsList);
         SocketManager.Instance.addEventListener(WorshipTheMoonEvent.FREE_COUNT,this.onResultFreeCounts);
         SocketManager.Instance.addEventListener(WorshipTheMoonEvent.WORSHIP_THE_MOON,this.onResultWorshipTheMoon);
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(WorshipTheMoonEvent.IS_ACTIVITY_OPEN,this.onResultIsActivityOpen);
         SocketManager.Instance.removeEventListener(WorshipTheMoonEvent.AWARDS_LIST,this.onResultAwardsList);
         SocketManager.Instance.removeEventListener(WorshipTheMoonEvent.FREE_COUNT,this.onResultFreeCounts);
         SocketManager.Instance.removeEventListener(WorshipTheMoonEvent.WORSHIP_THE_MOON,this.onResultWorshipTheMoon);
      }
      
      protected function onResultIsActivityOpen(e:WorshipTheMoonEvent) : void
      {
         var bytes:ByteArray = e.data;
         var isOpen:Boolean = bytes.readBoolean();
         this._isOpen = isOpen;
         WorshipTheMoonModel.getInstance().updateIsOpen(isOpen);
         this.worshipTheMoonIcon(this._isOpen);
         if(isOpen)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("worshipTheMoon.chatMsg.open"));
         }
         else if(this._isOpen)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("worshipTheMoon.chatMsg.close"));
         }
      }
      
      public function worshipTheMoonIcon(flag:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.WORSHIPTHEMOON,flag);
      }
      
      public function showFrame() : void
      {
         if(PlayerManager.Instance.Self.Grade < 15)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",15));
            return;
         }
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WORSHIP_THE_MOON);
      }
      
      protected function _loaderCompleteHandle(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.WORSHIP_THE_MOON)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
            UIModuleSmallLoading.Instance.hide();
            this._mainFrameMidAutumn = ComponentFactory.Instance.creatComponentByStylename("worship.mainframe");
            this._mainFrameMidAutumn.model = WorshipTheMoonModel.getInstance();
            WorshipTheMoonModel.getInstance().init(this._mainFrameMidAutumn);
            LayerManager.Instance.addToLayer(this._mainFrameMidAutumn,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this.requireAwardsList();
            this.requireFreeCount();
         }
      }
      
      protected function _loaderErrorHandle(event:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleSmallLoading.Instance.hide();
      }
      
      protected function _loadingCloseHandle(event:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleSmallLoading.Instance.hide();
      }
      
      protected function _loaderProgressHandle(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
      
      protected function onResultAwardsList(e:WorshipTheMoonEvent) : void
      {
         var bytes:ByteArray = e.data;
         var the200ItemID:int = bytes.readInt();
         var count:int = bytes.readInt();
         var list:Vector.<int> = new Vector.<int>();
         while(Boolean(bytes.bytesAvailable))
         {
            list.push(bytes.readInt());
         }
         WorshipTheMoonModel.getInstance().update200TimesGain(the200ItemID);
         WorshipTheMoonModel.getInstance().updateItemsCanGainsIDList(list);
      }
      
      protected function onResultFreeCounts(e:WorshipTheMoonEvent) : void
      {
         var bytes:ByteArray = e.data;
         var freeCount:int = bytes.readInt();
         var counts:int = bytes.readInt();
         var isGained200:int = bytes.readInt();
         var price:int = bytes.readInt();
         WorshipTheMoonModel.getInstance().updateFreeCounts(freeCount);
         WorshipTheMoonModel.getInstance().updateWorshipedCounts(counts);
         WorshipTheMoonModel.getInstance().update200State(isGained200);
         WorshipTheMoonModel.getInstance().updatePrice(price);
      }
      
      protected function onResultWorshipTheMoon(e:WorshipTheMoonEvent) : void
      {
         var bytes:ByteArray = e.data;
         var list:Vector.<WorshipTheMoonAwardsBoxInfo> = new Vector.<WorshipTheMoonAwardsBoxInfo>();
         bytes.readInt();
         while(Boolean(bytes.bytesAvailable))
         {
            list.push(new WorshipTheMoonAwardsBoxInfo(bytes.readInt(),bytes.readInt()));
         }
         WorshipTheMoonModel.getInstance().updateAwardsBoxInfoList(list);
      }
      
      public function requireFreeCount() : void
      {
         GameInSocketOut.sendWorshipTheMoonFreeCount();
      }
      
      public function requireAwardsList() : void
      {
         GameInSocketOut.sendWorshipTheMoonAwardsList();
      }
      
      public function requireWorshipTheMoon(counts:int) : void
      {
         var isBindTickets:Boolean = false;
         if(counts == 1)
         {
            isBindTickets = WorshipTheMoonModel.getInstance().getIsOnceBtnUseBindMoney();
         }
         else
         {
            isBindTickets = WorshipTheMoonModel.getInstance().getIsTensBtnUseBindMoney();
         }
         GameInSocketOut.sendWorshipTheMoon(counts,isBindTickets);
      }
      
      public function requireWorship200AwardBox() : void
      {
         GameInSocketOut.sendGainThe200timesAwardBox();
      }
      
      public function hide() : void
      {
         if(this._mainFrameMidAutumn != null)
         {
            ObjectUtils.disposeObject(this._mainFrameMidAutumn);
            this._mainFrameMidAutumn = null;
         }
         if(this._showFrameBtn != null)
         {
            ObjectUtils.disposeObject(this._showFrameBtn);
            this._showFrameBtn = null;
         }
         WorshipTheMoonModel.getInstance().dispose();
      }
      
      public function disposeMainFrame() : void
      {
         if(this._mainFrameMidAutumn != null)
         {
            ObjectUtils.disposeObject(this._mainFrameMidAutumn);
            this._mainFrameMidAutumn = null;
         }
      }
      
      public function dispose() : void
      {
         this._hall = null;
         if(this._mainFrameMidAutumn != null)
         {
            ObjectUtils.disposeObject(this._mainFrameMidAutumn);
            this._mainFrameMidAutumn = null;
         }
         if(this._showFrameBtn != null)
         {
            ObjectUtils.disposeObject(this._showFrameBtn);
            this._showFrameBtn = null;
         }
         WorshipTheMoonModel.getInstance().dispose();
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
