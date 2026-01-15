package latentEnergy
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import store.HelpFrame;
   
   public class LatentEnergyMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _replaceBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      protected var _bagPanel:ScrollPanel;
      
      private var _bagList:LatentEnergyBagListView;
      
      private var _proBagList:LatentEnergyBagListView;
      
      private var _leftDrapSprite:LatentEnergyLeftDragSprite;
      
      private var _rightDrapSprite:LatentEnergyRightDragSprite;
      
      private var _itemPlace:int;
      
      private var _itemCell:LatentEnergyItemCell;
      
      private var _equipCell:LatentEnergyEquipCell;
      
      private var _moreLessIconMcList:Vector.<MovieClip>;
      
      private var _leftProTxtList:Vector.<FilterFrameText>;
      
      private var _rightProTxtList:Vector.<FilterFrameText>;
      
      private var _noProTxt:String;
      
      private var _delayIndex:int;
      
      private var _equipBagInfo:BagInfo;
      
      private var _isDispose:Boolean = false;
      
      public function LatentEnergyMainView()
      {
         super();
         this.mouseEnabled = false;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LATENT_ENERGY);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.LATENT_ENERGY)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.LATENT_ENERGY)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.initThis();
         }
      }
      
      private function initThis() : void
      {
         this.initView();
         this.initEvent();
         this.createAcceptDragSprite();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.latentEnergyFrame.bg");
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("latentEnergyFrame.openBtn");
         this._openBtn.enable = false;
         this._replaceBtn = ComponentFactory.Instance.creatComponentByStylename("latentEnergyFrame.replaceBtn");
         this._replaceBtn.enable = false;
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("latentEnergyFrame.helpBtn");
         this._bagList = new LatentEnergyBagListView(BagInfo.EQUIPBAG,7,21,true);
         this._bagPanel = ComponentFactory.Instance.creat("ddtstore.LatentEnergyBagListView.BagScrollPanel");
         addChild(this._bagPanel);
         this._bagPanel.setView(this._bagList);
         this._bagPanel.invalidateViewport();
         this.refreshBagList();
         this._proBagList = new LatentEnergyBagListView(BagInfo.PROPBAG,7,21);
         PositionUtils.setPos(this._proBagList,"latentEnergyFrame.proBagListPos");
         this._proBagList.setData(LatentEnergyManager.instance.getLatentEnergyItemData());
         this._equipCell = new LatentEnergyEquipCell(0,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         this._equipCell.BGVisible = false;
         PositionUtils.setPos(this._equipCell,"latentEnergyFrame.equipCellPos");
         this._itemCell = new LatentEnergyItemCell(this._itemPlace,null,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         PositionUtils.setPos(this._itemCell,"latentEnergyFrame.itemCellPos");
         this._itemCell.BGVisible = false;
         addChild(this._bg);
         addChild(this._openBtn);
         addChild(this._replaceBtn);
         addChild(this._helpBtn);
         addChild(this._proBagList);
         addChild(this._equipCell);
         addChild(this._itemCell);
         this.createTxtView();
      }
      
      private function refreshBagList() : void
      {
         this._equipBagInfo = LatentEnergyManager.instance.getCanLatentEnergyData();
         this._bagList.setData(this._equipBagInfo);
      }
      
      private function createTxtView() : void
      {
         var tmpTxt:FilterFrameText = null;
         var tmpTxt2:FilterFrameText = null;
         var tmpMc:MovieClip = null;
         this._noProTxt = LanguageMgr.GetTranslation("ddt.latentEnergy.oldProNoTxt");
         this._leftProTxtList = new Vector.<FilterFrameText>(4);
         this._rightProTxtList = new Vector.<FilterFrameText>(4);
         this._moreLessIconMcList = new Vector.<MovieClip>(4);
         for(var i:int = 1; i <= 4; i++)
         {
            tmpTxt = ComponentFactory.Instance.creatComponentByStylename("latentEnergyFrame.leftProTxt");
            PositionUtils.setPos(tmpTxt,"latentEnergyFrame.leftProTxtPos" + i);
            tmpTxt.visible = false;
            addChild(tmpTxt);
            this._leftProTxtList[i - 1] = tmpTxt;
            tmpTxt2 = ComponentFactory.Instance.creatComponentByStylename("latentEnergyFrame.rightProTxt");
            PositionUtils.setPos(tmpTxt2,"latentEnergyFrame.rightProTxtPos" + i);
            tmpTxt2.visible = false;
            addChild(tmpTxt2);
            this._rightProTxtList[i - 1] = tmpTxt2;
            tmpMc = ComponentFactory.Instance.creat("asset.latentEnergyFrame.moreLessIcon");
            PositionUtils.setPos(tmpMc,"latentEnergyFrame.moreLessIconPos" + i);
            tmpMc.gotoAndStop(3);
            addChild(tmpMc);
            this._moreLessIconMcList[i - 1] = tmpMc;
         }
      }
      
      public function set itemPlace(place:int) : void
      {
         this._itemPlace = place;
         var itemInfo:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.items[this._itemPlace] as InventoryItemInfo;
         this._itemCell = new LatentEnergyItemCell(this._itemPlace,itemInfo,true,new Bitmap(new BitmapData(60,60,true,0)),false);
         PositionUtils.setPos(this._itemCell,"latentEnergyFrame.itemCellPos");
         this._itemCell.BGVisible = false;
         addChild(this._itemCell);
         this._equipCell.latentEnergyItemId = itemInfo.TemplateID;
      }
      
      private function createAcceptDragSprite() : void
      {
         this._leftDrapSprite = new LatentEnergyLeftDragSprite();
         this._leftDrapSprite.mouseEnabled = false;
         this._leftDrapSprite.mouseChildren = false;
         this._leftDrapSprite.graphics.beginFill(0,0);
         this._leftDrapSprite.graphics.drawRect(0,0,347,404);
         this._leftDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._leftDrapSprite,"latentEnergyFrame.leftDrapSpritePos");
         addChild(this._leftDrapSprite);
         this._rightDrapSprite = new LatentEnergyRightDragSprite();
         this._rightDrapSprite.mouseEnabled = false;
         this._rightDrapSprite.mouseChildren = false;
         this._rightDrapSprite.graphics.beginFill(0,0);
         this._rightDrapSprite.graphics.drawRect(0,0,374,407);
         this._rightDrapSprite.graphics.endFill();
         PositionUtils.setPos(this._rightDrapSprite,"latentEnergyFrame.rightDrapSpritePos");
         addChild(this._rightDrapSprite);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.showHelpFrame,false,0,true);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.openHandler,false,0,true);
         this._replaceBtn.addEventListener(MouseEvent.CLICK,this.replaceHandler,false,0,true);
         this._bagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._bagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._equipCell.addEventListener(Event.CHANGE,this.equipChangeHandler,false,0,true);
         this._proBagList.addEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler,false,0,true);
         this._proBagList.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick,false,0,true);
         this._itemCell.addEventListener(Event.CHANGE,this.itemChangeHandler,false,0,true);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_CHANGE,this.equipInfoChangeHandler);
      }
      
      private function bagInfoChangeHandler(event:BagEvent) : void
      {
         var changeItemInfo:InventoryItemInfo = null;
         var tmp:InventoryItemInfo = null;
         var tmp2:BagInfo = null;
         var changedSlots:Dictionary = event.changedSlots;
         var _loc6_:int = 0;
         var _loc7_:* = changedSlots;
         for each(tmp in _loc7_)
         {
            changeItemInfo = tmp;
         }
         if(Boolean(changeItemInfo) && !PlayerManager.Instance.Self.Bag.items[changeItemInfo.Place])
         {
            if(Boolean(this._equipCell.info) && (this._equipCell.info as InventoryItemInfo).Place == changeItemInfo.Place)
            {
               this._equipCell.info = null;
            }
            else
            {
               this.refreshBagList();
            }
         }
         else
         {
            tmp2 = LatentEnergyManager.instance.getCanLatentEnergyData();
            if(tmp2.items.length != this._equipBagInfo.items.length)
            {
               this._equipBagInfo = tmp2;
               this._bagList.setData(this._equipBagInfo);
            }
         }
      }
      
      private function equipInfoChangeHandler(event:Event) : void
      {
         this.refreshCurProView();
         this.refreshNewProView();
      }
      
      private function propInfoChangeHandler(event:BagEvent) : void
      {
         var changeItemInfo:InventoryItemInfo = null;
         var tmp:InventoryItemInfo = null;
         var tmpItemInfo:InventoryItemInfo = null;
         var changedSlots:Dictionary = event.changedSlots;
         var _loc6_:int = 0;
         var _loc7_:* = changedSlots;
         for each(tmp in _loc7_)
         {
            changeItemInfo = tmp;
         }
         if(Boolean(changeItemInfo) && !PlayerManager.Instance.Self.PropBag.items[changeItemInfo.Place])
         {
            if(Boolean(this._itemCell.info) && (this._itemCell.info as InventoryItemInfo).Place == changeItemInfo.Place)
            {
               this._itemCell.info = null;
            }
            else
            {
               this._proBagList.setData(LatentEnergyManager.instance.getLatentEnergyItemData());
            }
         }
         else
         {
            if(!this._itemCell || !this._itemCell.info)
            {
               return;
            }
            tmpItemInfo = this._itemCell.info as InventoryItemInfo;
            if(!PlayerManager.Instance.Self.PropBag.items[tmpItemInfo.Place])
            {
               this._itemCell.info = null;
            }
            else
            {
               this._itemCell.setCount(tmpItemInfo.Count);
            }
         }
      }
      
      private function openHandler(event:MouseEvent) : void
      {
         var confirmFrame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!this._equipCell.info)
         {
            return;
         }
         if(!this._itemCell.info)
         {
            return;
         }
         if((this._itemCell.info as InventoryItemInfo).Count <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.latentEnergy.noEnoughItem"));
            return;
         }
         if(!(this._equipCell.info as InventoryItemInfo).IsBinds)
         {
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.latentEnergy.bindTipTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm,false,0,true);
         }
         else
         {
            this.doOpenHandler();
         }
      }
      
      private function doOpenHandler() : void
      {
         var equipInfo:InventoryItemInfo = this._equipCell.info as InventoryItemInfo;
         var itemInfo:InventoryItemInfo = this._itemCell.info as InventoryItemInfo;
         SocketManager.Instance.out.sendLatentEnergy(1,equipInfo.BagType,equipInfo.Place,itemInfo.BagType,itemInfo.Place);
         this._openBtn.enable = false;
         this._delayIndex = setTimeout(this.openBtnEnableHandler,1000);
      }
      
      private function __confirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.doOpenHandler();
         }
      }
      
      private function openBtnEnableHandler() : void
      {
         if(this._equipCell && this._openBtn && Boolean(this._itemCell))
         {
            if(Boolean(this._equipCell.info) && Boolean(this._itemCell.info))
            {
               this._openBtn.enable = true;
            }
            else
            {
               this._openBtn.enable = false;
            }
         }
      }
      
      private function replaceHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._equipCell.info)
         {
            return;
         }
         if(!(this._equipCell.info as InventoryItemInfo).isHasLatenetEnergyNew)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.latentEnergy.noNewProperty"));
            this._replaceBtn.enable = false;
            return;
         }
         var equipInfo:InventoryItemInfo = this._equipCell.info as InventoryItemInfo;
         SocketManager.Instance.out.sendLatentEnergy(2,equipInfo.BagType,equipInfo.Place);
      }
      
      private function itemChangeHandler(event:Event) : void
      {
         if(Boolean(this._itemCell.info))
         {
            this._equipCell.latentEnergyItemId = this._itemCell.info.TemplateID;
         }
         else
         {
            this._equipCell.latentEnergyItemId = 0;
         }
         this.equipChangeHandler(null);
      }
      
      private function equipChangeHandler(event:Event) : void
      {
         var i:int = 0;
         if(Boolean(this._equipCell.info))
         {
            this.refreshCurProView();
            this.refreshNewProView();
         }
         else
         {
            this._replaceBtn.enable = false;
            for(i = 0; i < 4; i++)
            {
               this._leftProTxtList[i].visible = false;
               this._rightProTxtList[i].visible = false;
               this._moreLessIconMcList[i].gotoAndStop(3);
            }
         }
         if(Boolean(this._equipCell.info) && Boolean(this._itemCell.info))
         {
            this._openBtn.enable = true;
         }
         else
         {
            this._openBtn.enable = false;
         }
      }
      
      private function refreshCurProView() : void
      {
         var tmpValueArray:Array = null;
         var k:int = 0;
         var i:int = 0;
         if(!this._equipCell.info)
         {
            return;
         }
         var tmpItemInfo:InventoryItemInfo = this._equipCell.info as InventoryItemInfo;
         if(tmpItemInfo.isHasLatentEnergy)
         {
            tmpValueArray = tmpItemInfo.latentEnergyCurList;
            for(k = 0; k < 4; k++)
            {
               this._leftProTxtList[k].text = tmpValueArray[k];
               this._leftProTxtList[k].visible = true;
            }
         }
         else
         {
            for(i = 0; i < 4; i++)
            {
               this._leftProTxtList[i].text = this._noProTxt;
               this._leftProTxtList[i].visible = true;
            }
         }
      }
      
      private function refreshNewProView() : void
      {
         var tmpValueArray:Array = null;
         var tmpCurValueArray:Array = null;
         var k:int = 0;
         var i:int = 0;
         if(!this._equipCell.info)
         {
            return;
         }
         var tmpItemInfo:InventoryItemInfo = this._equipCell.info as InventoryItemInfo;
         if(tmpItemInfo.isHasLatenetEnergyNew)
         {
            this._replaceBtn.enable = true;
            tmpValueArray = tmpItemInfo.latentEnergyNewList;
            tmpCurValueArray = tmpItemInfo.latentEnergyCurList;
            for(k = 0; k < 4; k++)
            {
               this._rightProTxtList[k].text = tmpValueArray[k];
               this._rightProTxtList[k].visible = true;
               if(int(tmpValueArray[k]) > int(tmpCurValueArray[k]))
               {
                  this._moreLessIconMcList[k].gotoAndStop(1);
               }
               else if(int(tmpValueArray[k]) == int(tmpCurValueArray[k]))
               {
                  this._moreLessIconMcList[k].gotoAndStop(3);
               }
               else if(int(tmpValueArray[k]) < int(tmpCurValueArray[k]))
               {
                  this._moreLessIconMcList[k].gotoAndStop(2);
               }
            }
         }
         else
         {
            this._replaceBtn.enable = false;
            for(i = 0; i < 4; i++)
            {
               this._rightProTxtList[i].visible = false;
               this._moreLessIconMcList[i].gotoAndStop(3);
            }
         }
      }
      
      protected function __cellDoubleClick(evt:CellEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmpStr:String = "";
         if(evt.target == this._proBagList)
         {
            tmpStr = LatentEnergyManager.ITEM_MOVE;
         }
         else
         {
            tmpStr = LatentEnergyManager.EQUIP_MOVE;
         }
         var event:LatentEnergyEvent = new LatentEnergyEvent(tmpStr);
         var cell:BagCell = evt.data as BagCell;
         event.info = cell.info as InventoryItemInfo;
         event.moveType = 1;
         LatentEnergyManager.instance.dispatchEvent(event);
      }
      
      private function cellClickHandler(event:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var cell:BagCell = event.data as BagCell;
         cell.dragStart();
      }
      
      private function showHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("latentEnergy.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("latentEnergy.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.latentEnergy.helpTitle");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(value)
         {
            if(!this._isDispose)
            {
               this.refreshListData();
               PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
               PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
            }
         }
         else
         {
            this.clearCellInfo();
            PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         }
      }
      
      public function clearCellInfo() : void
      {
         if(Boolean(this._equipCell))
         {
            this._equipCell.clearInfo();
         }
         if(Boolean(this._itemCell))
         {
            this._itemCell.clearInfo();
         }
      }
      
      public function refreshListData() : void
      {
         if(Boolean(this._bagList))
         {
            this.refreshBagList();
         }
         if(Boolean(this._proBagList))
         {
            this._proBagList.setData(LatentEnergyManager.instance.getLatentEnergyItemData());
         }
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.showHelpFrame);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.openHandler);
         this._replaceBtn.removeEventListener(MouseEvent.CLICK,this.replaceHandler);
         this._bagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._bagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._equipCell.removeEventListener(Event.CHANGE,this.equipChangeHandler);
         this._proBagList.removeEventListener(CellEvent.ITEM_CLICK,this.cellClickHandler);
         this._proBagList.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         this._itemCell.removeEventListener(Event.CHANGE,this.itemChangeHandler);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.propInfoChangeHandler);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.bagInfoChangeHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_CHANGE,this.equipInfoChangeHandler);
      }
      
      public function dispose() : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         this.removeEvent();
         clearTimeout(this._delayIndex);
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._openBtn = null;
         this._replaceBtn = null;
         this._helpBtn = null;
         this._bagList = null;
         this._proBagList = null;
         this._leftDrapSprite = null;
         this._rightDrapSprite = null;
         this._itemCell = null;
         this._equipCell = null;
         this._moreLessIconMcList = null;
         this._leftProTxtList = null;
         this._rightProTxtList = null;
         this._noProTxt = null;
         this._equipBagInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._isDispose = true;
      }
   }
}

