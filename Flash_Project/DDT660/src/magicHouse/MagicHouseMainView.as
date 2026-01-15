package magicHouse
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import magicHouse.magicCollection.MagicHouseCollectionMainView;
   import magicHouse.treasureHouse.MagicHouseTreasureHouseView;
   
   public class MagicHouseMainView extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _collectionBtn:SelectedButton;
      
      private var _treasureBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _collectionView:MagicHouseCollectionMainView;
      
      private var _treasureView:MagicHouseTreasureHouseView;
      
      public function MagicHouseMainView()
      {
         super();
         titleText = LanguageMgr.GetTranslation("magichouse.mainview.frametitletext");
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         MagicHouseManager.instance.initServerConfig();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("magicHouse.mainViewFrame.bg");
         addToContent(this._bg);
         this._collectionBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.mainViewFrame.collectionBtn");
         addToContent(this._collectionBtn);
         this._treasureBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.mainViewFrame.treasureBtn");
         addToContent(this._treasureBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._collectionBtn);
         this._btnGroup.addSelectItem(this._treasureBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
      }
      
      private function __response(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __changeHandler(e:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._showCollectionView();
               break;
            case 1:
               this._showTreasureView();
         }
      }
      
      private function _showCollectionView() : void
      {
         if(!this._collectionView)
         {
            this._collectionView = ComponentFactory.Instance.creatCustomObject("magicHouse.magicHouseCollectionMainView");
            addToContent(this._collectionView);
         }
         this._collectionView.visible = true;
         if(Boolean(this._treasureView))
         {
            this._treasureView.visible = false;
         }
         MagicHouseManager.instance.selectEquipFromBag();
         MagicHouseManager.instance.dispatchEvent(new Event("MAGICHOUSE_UPDATA"));
      }
      
      private function _showTreasureView() : void
      {
         if(!this._treasureView)
         {
            this._treasureView = ComponentFactory.Instance.creatCustomObject("magicHouse.magicHouseTreasureHouseView");
            addToContent(this._treasureView);
         }
         this._treasureView.info = PlayerManager.Instance.Self;
         this._treasureView.visible = true;
         if(Boolean(this._collectionView))
         {
            this._collectionView.visible = false;
         }
      }
      
      public function show(view:int = 0) : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this._btnGroup.selectIndex = view;
      }
      
      public function close() : void
      {
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._collectionBtn))
         {
            ObjectUtils.disposeObject(this._collectionBtn);
         }
         this._collectionBtn = null;
         if(Boolean(this._treasureBtn))
         {
            ObjectUtils.disposeObject(this._treasureBtn);
         }
         this._treasureBtn = null;
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._collectionView))
         {
            ObjectUtils.disposeObject(this._collectionView);
         }
         this._collectionView = null;
         if(Boolean(this._treasureView))
         {
            ObjectUtils.disposeObject(this._treasureView);
         }
         this._treasureView = null;
         super.dispose();
      }
   }
}

