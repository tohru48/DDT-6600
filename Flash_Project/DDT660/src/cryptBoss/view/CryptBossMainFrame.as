package cryptBoss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import cryptBoss.CryptBossManager;
   import cryptBoss.data.CryptBossItemInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   import store.HelpFrame;
   
   public class CryptBossMainFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _itemVec:Vector.<CryptBossItem>;
      
      private var _vipNumber:FilterFrameText;
      
      public function CryptBossMainFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("cryptBoss.frame.titleTxt");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("cryptBoss.helpBtn");
         addToContent(this._helpBtn);
         this._bg = ComponentFactory.Instance.creat("asset.cryptBoss.bg");
         addToContent(this._bg);
         this._vipNumber = ComponentFactory.Instance.creatComponentByStylename("CryptBossMainFrame.vipNumberTxt");
         var vipArr:Array = ServerConfigManager.instance.localVIPRewardCryptCount;
         var vipNum:int = int(vipArr[int(PlayerManager.Instance.Self.VIPLevel) - 1]);
         if(PlayerManager.Instance.Self.IsVIP && vipNum > 0)
         {
            this._vipNumber.text = LanguageMgr.GetTranslation("CryptBossMainFrame.vipNumberTxtLG",String(vipNum));
            addToContent(this._vipNumber);
         }
         this.updateView();
      }
      
      public function updateView() : void
      {
         var itemInfo:CryptBossItemInfo = null;
         var item:CryptBossItem = null;
         var bossItem:CryptBossItem = null;
         if(this._itemVec != null)
         {
            for each(item in this._itemVec)
            {
               ObjectUtils.disposeObject(item);
               item = null;
            }
            this._itemVec = null;
         }
         this._itemVec = new Vector.<CryptBossItem>();
         for each(itemInfo in CryptBossManager.instance.openWeekDaysDic)
         {
            bossItem = new CryptBossItem(itemInfo);
            this._itemVec.push(bossItem);
            addToContent(bossItem);
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpBtnClick);
      }
      
      protected function __helpBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("cryptBoss.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("cryptBoss.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.changeSubmitButtonX(10);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.ringstation.helpTitle");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      protected function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            CryptBossManager.instance.RoomType = 0;
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._itemVec = null;
         this._helpBtn = null;
         super.dispose();
      }
   }
}

