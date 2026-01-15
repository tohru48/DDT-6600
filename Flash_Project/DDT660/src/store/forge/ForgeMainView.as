package store.forge
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import enchant.view.EnchantMainView;
   import equipretrieve.RetrieveController;
   import equipretrieve.RetrieveFrame;
   import equipretrieve.RetrieveModel;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import gemstone.GemstoneFrame;
   import gemstone.GemstoneManager;
   import latentEnergy.LatentEnergyMainView;
   import store.forge.wishBead.WishBeadMainView;
   
   public class ForgeMainView extends Sprite implements Disposeable
   {
      
      private var _tabVbox:VBox;
      
      private var _tabSBG:SelectedButtonGroup;
      
      private var _tabSBList:Vector.<SelectedButton>;
      
      private var _bg:MovieClip;
      
      private var _rightBgView:ForgeRightBgView;
      
      private var _latentEnergyView:LatentEnergyMainView;
      
      private var _wishBeadView:WishBeadMainView;
      
      private var _retrieveView:RetrieveFrame;
      
      private var _gemstoneFrame:GemstoneFrame;
      
      private var _enchantFrame:EnchantMainView;
      
      private var _initIndex:int = 0;
      
      public function ForgeMainView(index:int)
      {
         super();
         this._initIndex = index;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FORGE_MAIN);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.FORGE_MAIN)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.FORGE_MAIN)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.initView();
            this.initEvent();
            this._tabSBG.selectIndex = this._initIndex;
         }
      }
      
      private function initView() : void
      {
         var tmp:SelectedButton = null;
         var contentBg:DisplayObject = ComponentFactory.Instance.creatCustomObject("ddtstore.BagStoreFrame.ContentBg");
         addChild(contentBg);
         contentBg.height = 425;
         this._bg = ComponentFactory.Instance.creat("asset.forgeMainView.leftBg");
         PositionUtils.setPos(this._bg,"forgeMainView.leftBgPos");
         this._bg.gotoAndStop(1);
         addChild(this._bg);
         this._rightBgView = new ForgeRightBgView();
         PositionUtils.setPos(this._rightBgView,"forgeMainView.rightBgViewPos");
         addChild(this._rightBgView);
         this._tabVbox = ComponentFactory.Instance.creatComponentByStylename("forgeMainView.tabVBox");
         this._tabSBList = new Vector.<SelectedButton>();
         this._tabSBG = new SelectedButtonGroup();
         for(var i:int = 0; i < 5; i++)
         {
            tmp = ComponentFactory.Instance.creatComponentByStylename("forgeMainView.tabSelectedButton" + i);
            tmp.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
            this._tabVbox.addChild(tmp);
            this._tabSBG.addSelectItem(tmp);
            this._tabSBList.push(tmp);
         }
         addChild(this._tabVbox);
      }
      
      private function initEvent() : void
      {
         this._tabSBG.addEventListener(Event.CHANGE,this.changeHandler,false,0,true);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._tabSBList.indexOf(event.currentTarget as SelectedButton) == 3 && PlayerManager.Instance.Self.Grade < 30)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gemstone.limitLevel.tipTxt"));
            event.stopImmediatePropagation();
         }
      }
      
      private function changeHandler(event:Event) : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
         this._tabVbox.arrange();
         if(Boolean(this._latentEnergyView))
         {
            this._latentEnergyView.visible = false;
         }
         if(Boolean(this._wishBeadView))
         {
            this._wishBeadView.visible = false;
         }
         if(Boolean(this._retrieveView))
         {
            this._retrieveView.visible = false;
         }
         if(Boolean(this._gemstoneFrame))
         {
            this._gemstoneFrame.visible = false;
         }
         if(Boolean(this._enchantFrame))
         {
            this._enchantFrame.visible = false;
         }
         switch(this._tabSBG.selectIndex)
         {
            case 0:
               if(!this._latentEnergyView)
               {
                  this._latentEnergyView = new LatentEnergyMainView();
                  PositionUtils.setPos(this._latentEnergyView,"forgeMainView.latentEnergyViewPos");
                  addChild(this._latentEnergyView);
               }
               this._latentEnergyView.visible = true;
               this._rightBgView.showStoreBagViewText("forgeMainView.latentEnergy.equipTipTxt","forgeMainView.latentEnergy.itemTipTxt");
               this._rightBgView.visible = true;
               this._bg.gotoAndStop(1);
               break;
            case 1:
               if(!this._wishBeadView)
               {
                  this._wishBeadView = new WishBeadMainView();
                  PositionUtils.setPos(this._wishBeadView,"forgeMainView.latentEnergyViewPos");
                  addChild(this._wishBeadView);
               }
               this._wishBeadView.visible = true;
               this._rightBgView.showStoreBagViewText("forgeMainView.wishBead.equipTipTxt","forgeMainView.wishBead.itemTipTxt");
               this._rightBgView.visible = true;
               this._bg.gotoAndStop(1);
               break;
            case 2:
               ObjectUtils.disposeObject(this._enchantFrame);
               this._enchantFrame = null;
               if(!this._retrieveView)
               {
                  RetrieveModel.Instance.start(PlayerManager.Instance.Self);
                  this._retrieveView = ComponentFactory.Instance.creatCustomObject("retrieve.retrieveFrame");
                  RetrieveController.Instance.startView(this._retrieveView);
                  addChild(this._retrieveView);
               }
               this._retrieveView.visible = true;
               this._retrieveView.clearItemCell();
               this._rightBgView.showStoreBagViewText("retrieveFrame.retrieve.equipTipTxt","retrieveFrame.retrieve.itemTipTxt");
               this._rightBgView.visible = true;
               this._bg.gotoAndStop(1);
               break;
            case 3:
               if(!this._gemstoneFrame)
               {
                  this._gemstoneFrame = new GemstoneFrame();
                  PositionUtils.setPos(this._gemstoneFrame,"forgeMainView.gemstoneFramePos");
                  addChild(this._gemstoneFrame);
                  GemstoneManager.Instance.initFrame(this._gemstoneFrame);
               }
               this._gemstoneFrame.visible = true;
               this._rightBgView.visible = false;
               this._bg.gotoAndStop(2);
               break;
            case 4:
               ObjectUtils.disposeObject(this._retrieveView);
               this._retrieveView = null;
               if(!this._enchantFrame)
               {
                  this._enchantFrame = new EnchantMainView();
                  PositionUtils.setPos(this._enchantFrame,"forgeMainView.latentEnergyViewPos");
                  addChild(this._enchantFrame);
               }
               this._enchantFrame.visible = true;
               this._rightBgView.showStoreBagViewText("forgeMainView.enchant.equipTipTxt","forgeMainView.latentEnergy.itemTipTxt");
               this._rightBgView.visible = true;
               this._bg.gotoAndStop(1);
         }
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(visible)
         {
            if(Boolean(this._latentEnergyView))
            {
               this._latentEnergyView.clearCellInfo();
               this._latentEnergyView.refreshListData();
            }
            if(Boolean(this._wishBeadView))
            {
               this._wishBeadView.clearCellInfo();
               this._wishBeadView.refreshListData();
            }
            if(Boolean(this._retrieveView))
            {
               this._retrieveView.clearItemCell();
            }
            if(Boolean(this._tabSBG))
            {
               this.changeHandler(null);
            }
            if(Boolean(this._enchantFrame))
            {
               this._enchantFrame.addUpdateStoreEvent();
            }
         }
         else
         {
            if(Boolean(this._enchantFrame))
            {
               this._enchantFrame.removeUpdateStoreEvent();
            }
            ObjectUtils.disposeObject(this._retrieveView);
            this._retrieveView = null;
         }
      }
      
      private function removeEvent() : void
      {
         this._tabSBG.removeEventListener(Event.CHANGE,this.changeHandler);
      }
      
      public function dispose() : void
      {
         var tmp:SelectedButton = null;
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         this.removeEvent();
         for each(tmp in this._tabSBList)
         {
            tmp.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
         ObjectUtils.disposeAllChildren(this);
         this._tabVbox = null;
         this._tabSBG = null;
         this._tabSBList = null;
         this._bg = null;
         this._rightBgView = null;
         this._latentEnergyView = null;
         this._wishBeadView = null;
         this._retrieveView = null;
         this._gemstoneFrame = null;
         this._enchantFrame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

