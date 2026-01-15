package store.view.fusion
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.IStoreViewBG;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.StrengthDataManager;
   import store.data.PreviewInfoII;
   import store.events.StoreIIEvent;
   import store.view.shortcutBuy.ShortcutBuyFrame;
   import trainer.controller.NewHandQueue;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class StoreIIFusionBG extends Sprite implements IStoreViewBG
   {
      
      private static const ITEMS:Array = [11301,11302,11303,11304,11201,11202,11203,11204];
      
      private static const ZOMM:Number = 0.75;
      
      public static var lastIndexFusion:int = -1;
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _accessoryFrameII:AccessoryFrameII;
      
      private var _fusion_btn:BaseButton;
      
      private var _fusion_btn_shineEffect:IEffect;
      
      private var _fusionHelp:BaseButton;
      
      private var fusionArr:MutipleImage;
      
      private var gold_txt:FilterFrameText;
      
      private var _goldIcon:Image;
      
      private var _goodName:FilterFrameText;
      
      private var _goodRate:FilterFrameText;
      
      private var _autoFusion:Boolean;
      
      private var _autoSelect:Boolean;
      
      private var _autoCheck:SelectedCheckButton;
      
      private var _pointArray:Vector.<Point>;
      
      private var _gold:int = 400;
      
      private var _maxCell:int = 0;
      
      private var _ckAutoSplit:SelectedCheckButton;
      
      private var _isAutoSplit:Boolean = false;
      
      private var _bg:Image;
      
      private var _fusionTitle:Bitmap;
      
      private var _goldTipText:FilterFrameText;
      
      private var _previewPanelBg:Image;
      
      private var _previewNameLabel:FilterFrameText;
      
      private var _previewRateLabel:FilterFrameText;
      
      private var _windowTime:int;
      
      private var _itemsPreview:Array;
      
      private var _alertBand:Boolean = false;
      
      public function StoreIIFusionBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      public static function autoSplitSend(bagtype:int, place:int, tobagType:int, position:String, countNum:int, allMove:Boolean = false, cellParent:IStoreViewBG = null) : void
      {
         var sendParam:Array = getAutoSplitSendParam(position,countNum);
         var index:int = 0;
         var positionEmptyArray:Array = position.split(",");
         if(positionEmptyArray.length == 4)
         {
            if(Boolean(sendParam))
            {
               clearFusion(cellParent);
               for(index = 0; index < sendParam.length; index++)
               {
                  if(sendParam[index] > 0)
                  {
                     SocketManager.Instance.out.sendMoveGoods(bagtype,place,tobagType,index + 1,sendParam[index],allMove);
                  }
               }
            }
         }
         else if(Boolean(sendParam))
         {
            clearFusion(cellParent,positionEmptyArray);
            for(index = 0; index < sendParam.length; index++)
            {
               if(sendParam[index] > 0)
               {
                  SocketManager.Instance.out.sendMoveGoods(bagtype,place,tobagType,positionEmptyArray[index],sendParam[index],allMove);
               }
            }
         }
         lastIndexFusion = -1;
      }
      
      public static function getRemainIndexByEmpty(fusionCount:int, cellParent:IStoreViewBG) : String
      {
         var ds:StoreCell = null;
         var i:int = 0;
         if(fusionCount >= 4)
         {
            return "1,2,3,4";
         }
         var resultStr:String = "";
         var emptyPostion:Array = [];
         if(cellParent is StoreIIFusionBG)
         {
            for(i = 1; i < 5; i++)
            {
               ds = (cellParent as StoreIIFusionBG).area[i];
               if(!ds.info)
               {
                  emptyPostion.push(ds.index);
               }
            }
            switch(fusionCount)
            {
               case 2:
                  resultStr = emptyPostion.concat(findDiff(emptyPostion)).slice(0,fusionCount).splice(",");
                  break;
               case 3:
                  resultStr = emptyPostion.concat(findDiff(emptyPostion)).slice(0,fusionCount).splice(",");
            }
         }
         return resultStr;
      }
      
      private static function findDiff(searchArray:Array) : Array
      {
         var flag:Boolean = false;
         var value:int = 0;
         var resultArray:Array = [];
         for(var index:int = 1; index < 5; index++)
         {
            flag = false;
            for(value = 0; value < searchArray.length; value++)
            {
               if(index == int(searchArray[value]))
               {
                  flag = true;
               }
            }
            if(!flag)
            {
               resultArray.push(index);
            }
         }
         return resultArray;
      }
      
      private static function getAutoSplitSendParam(position:String, countNum:int) : Array
      {
         var remainNum:int = 0;
         var perNum:int = 0;
         var i:int = 0;
         var resultSend:Array = [];
         var posArray:Array = position.split(",");
         if(Boolean(posArray) && countNum >= 1)
         {
            remainNum = countNum % posArray.length;
            perNum = int(countNum / posArray.length);
            for(i = 0; i < posArray.length; i++)
            {
               resultSend.push(perNum + getRemainCellNumber(remainNum--));
            }
         }
         return resultSend;
      }
      
      private static function getRemainCellNumber(remainNum:int) : int
      {
         return remainNum > 0 ? 1 : 0;
      }
      
      private static function clearFusion(cellParent:IStoreViewBG, removePosition:Array = null) : void
      {
         var ds:StoreCell = null;
         var i:int = 0;
         if(!removePosition)
         {
            for(i = 1; i < 5; i++)
            {
               ds = (cellParent as StoreIIFusionBG).area[i];
               if(Boolean(ds.info))
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,ds.index,ds.itemBagType,-1);
               }
            }
            return;
         }
         for(var j:int = 0; j < removePosition.length; j++)
         {
            for(i = 1; i < 5; i++)
            {
               ds = (cellParent as StoreIIFusionBG).area[i];
               if(Boolean(ds.info) && ds.index == int(removePosition[j]))
               {
                  SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,ds.index,ds.itemBagType,-1);
                  break;
               }
            }
         }
      }
      
      public function get isAutoSplit() : Boolean
      {
         return this._isAutoSplit;
      }
      
      private function init() : void
      {
         var i:int = 0;
         var item:StoreCell = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.FusionBg");
         addChild(this._bg);
         this._fusionTitle = ComponentFactory.Instance.creatBitmap("asset.ddtstore.FusionTitle");
         addChild(this._fusionTitle);
         this._previewPanelBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.PreviewPanelBg");
         addChild(this._previewPanelBg);
         this._previewNameLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.PreviewPanelNameLabel");
         this._previewNameLabel.text = LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.PreviewNameLabelText");
         addChild(this._previewNameLabel);
         this._previewRateLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.PreviewPanelRateLabel");
         this._previewRateLabel.text = LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.PreviewRateLabelText");
         addChild(this._previewRateLabel);
         this._items = [];
         this.getCellsPoint();
         for(i = 0; i < 6; i++)
         {
            if(i == 0)
            {
               item = new FusionItemCellII(i);
            }
            else if(i == 5)
            {
               item = new FusionItemCell(i);
               item.scaleX = item.scaleY = ZOMM;
               FusionItemCell(item).mouseEvt = false;
               FusionItemCell(item).bgVisible = false;
            }
            else
            {
               item = new FusionItemCell(i);
            }
            item.x = this._pointArray[i].x;
            item.y = this._pointArray[i].y;
            addChild(item);
            if(i != 5)
            {
               item.addEventListener(Event.CHANGE,this.__itemInfoChange);
            }
            this._items.push(item);
         }
         this._accessoryFrameII = new AccessoryFrameII();
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         this._fusion_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.FusionBtn");
         this._fusion_btn_shineEffect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION,this._fusion_btn,{"color":EffectColorType.GOLD});
         addChild(this._fusion_btn);
         this._fusionHelp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HelpButton");
         addChild(this._fusionHelp);
         this.fusionArr = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.ArrowHeadFusionTip");
         addChild(this.fusionArr);
         this._goldTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.NeedMoneyTipText");
         this._goldTipText.text = LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.NeedMoneyTipText");
         addChild(this._goldTipText);
         this.gold_txt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.NeedMoneyText");
         addChild(this.gold_txt);
         this._goldIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.GoldIcon");
         addChild(this._goldIcon);
         this._goodName = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.PreviewNameText");
         addChild(this._goodName);
         this._goodRate = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.PreviewSucessRateText");
         addChild(this._goodRate);
         this._autoCheck = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIFusionBG.ContinuousFusionCheckButton");
         addChild(this._autoCheck);
         this._ckAutoSplit = ComponentFactory.Instance.creat("ddtstore.StoreIIFusionBG.SellLeftAlerAutoSplitCk");
         this._ckAutoSplit.text = LanguageMgr.GetTranslation("store.fusion.autoSplit");
         addChild(this._ckAutoSplit);
         this._ckAutoSplit.selected = this._isAutoSplit;
         this.hideArr();
         this.hide();
      }
      
      private function initEvent() : void
      {
         this._fusion_btn.addEventListener(MouseEvent.CLICK,this.__fusionClick);
         this._accessoryFrameII.addEventListener(StoreIIEvent.ITEM_CLICK,this.__accessoryItemClick);
         this._fusionHelp.addEventListener(MouseEvent.CLICK,this.__openHelp);
         this._autoCheck.addEventListener(Event.SELECT,this.__selectedChanged);
         this._ckAutoSplit.addEventListener(Event.SELECT,this.__autoSplit);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_FUSION_PREVIEW,this.__upPreview);
         StrengthDataManager.instance.addEventListener(StrengthDataManager.FUSIONFINISH,this.__fusionFinish);
      }
      
      private function removeEvents() : void
      {
         for(var i:int = 0; i < this._items.length; i++)
         {
            this._items[i].removeEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[i].dispose();
         }
         this._fusion_btn.removeEventListener(MouseEvent.CLICK,this.__fusionClick);
         this._accessoryFrameII.removeEventListener(StoreIIEvent.ITEM_CLICK,this.__accessoryItemClick);
         this._fusionHelp.removeEventListener(MouseEvent.CLICK,this.__openHelp);
         this._autoCheck.removeEventListener(Event.SELECT,this.__selectedChanged);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_FUSION_PREVIEW,this.__upPreview);
         StrengthDataManager.instance.removeEventListener(StrengthDataManager.FUSIONFINISH,this.__fusionFinish);
         if(Boolean(this._ckAutoSplit))
         {
            this._ckAutoSplit.removeEventListener(Event.SELECT,this.__autoSplit);
         }
      }
      
      private function userGuide() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_FUSION) && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(350)))
         {
            NewHandQueue.Instance.push(new Step(Step.FUSION_ITEM_TIP,this.exeItemTip,this.preItemTip,this.finItemTip));
         }
      }
      
      private function preItemTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.FUS_ITEM,0,"trainer.fusItemArrowPos","asset.trainer.txtFusItemTip","trainer.fusItemTipPos");
      }
      
      private function exeItemTip() : Boolean
      {
         var fusionType:int = 0;
         var i:int = 0;
         if(this.checkItemEmpty() >= 4)
         {
            fusionType = int(PlayerManager.Instance.Self.StoreBag.items[1].FusionType);
            for(i = 2; i <= 4; i++)
            {
               if(fusionType != PlayerManager.Instance.Self.StoreBag.items[i].FusionType)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      private function finItemTip() : void
      {
         this.disposeUserGuide();
      }
      
      private function disposeUserGuide() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.FUS_ITEM);
         NewHandQueue.Instance.dispose();
      }
      
      private function getCellsPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Vector.<Point>();
         for(var i:int = 0; i < 6; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIFusionBG.Fusionpoint" + i);
            this._pointArray.push(point);
         }
      }
      
      private function __buyBtnClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var quickBuy:ShortcutBuyFrame = ComponentFactory.Instance.creatCustomObject("ddtstore.ShortcutBuyFrame");
         quickBuy.show(ITEMS,true,LanguageMgr.GetTranslation("store.view.fusion.buyFormula"),4);
      }
      
      public function dragDrop(source:BagCell) : void
      {
         var ds:StoreCell = null;
         var i:int = 0;
         if(source == null)
         {
            return;
         }
         if(this._accessoryFrameII.containsItem(source.itemInfo))
         {
            return;
         }
         var info:InventoryItemInfo = source.info as InventoryItemInfo;
         for each(ds in this._items)
         {
            if(ds.info == info)
            {
               ds.info = null;
               source.locked = false;
               return;
            }
         }
         for(i = 1; i < 5; i++)
         {
            ds = this._items[i];
            if(ds is FusionItemCell)
            {
               if(info.getRemainDate() <= 0)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
               }
               else
               {
                  if(!(info.FusionType != 0 && info.FusionRate != 0))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.fusion"));
                     return;
                  }
                  if(this._items[1].info != null && this._items[2].info != null && this._items[3].info != null && this._items[4].info != null)
                  {
                     this.__moveGoods(info,1);
                     return;
                  }
                  if(ds.info == null)
                  {
                     this.__moveGoods(info,ds.index);
                     return;
                  }
               }
            }
         }
      }
      
      private function __moveGoods(info:InventoryItemInfo, index:int) : void
      {
         var _aler:FusionSelectNumAlertFrame = null;
         if(StrengthDataManager.instance.autoFusion)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.fusion.donMoveGoods"));
            return;
         }
         if(info.Count > 1 && !this._isAutoSplit)
         {
            _aler = ComponentFactory.Instance.creat("ddtstore.FusionSelectNumAlertFrame");
            _aler.goodsinfo = info;
            _aler.index = index;
            _aler.show(info.Count);
            _aler.addEventListener(FusionSelectEvent.SELL,this._alerSell);
            _aler.addEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
         }
         else if(info.Count > 1 && this._isAutoSplit)
         {
            autoSplitSend(info.BagType,info.Place,BagInfo.STOREBAG,getRemainIndexByEmpty(info.Count,this),info.Count,true,this);
         }
         else
         {
            SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,index,info.Count,true);
         }
      }
      
      private function _alerSell(e:FusionSelectEvent) : void
      {
         var _aler:FusionSelectNumAlertFrame = e.currentTarget as FusionSelectNumAlertFrame;
         SocketManager.Instance.out.sendMoveGoods(e.info.BagType,e.info.Place,BagInfo.STOREBAG,e.index,e.sellCount,true);
         _aler.removeEventListener(FusionSelectEvent.SELL,this._alerSell);
         _aler.removeEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
         _aler.dispose();
         if(Boolean(_aler) && Boolean(_aler.parent))
         {
            removeChild(_aler);
         }
         _aler = null;
      }
      
      private function _alerNotSell(e:FusionSelectEvent) : void
      {
         var _aler:FusionSelectNumAlertFrame = e.currentTarget as FusionSelectNumAlertFrame;
         _aler.removeEventListener(FusionSelectEvent.SELL,this._alerSell);
         _aler.removeEventListener(FusionSelectEvent.NOTSELL,this._alerNotSell);
         _aler.dispose();
         if(Boolean(_aler) && Boolean(_aler.parent))
         {
            removeChild(_aler);
         }
         _aler = null;
      }
      
      private function _showDontClickTip() : Boolean
      {
         var fusionType:int = 0;
         var len:int = 0;
         var i:int = 0;
         var j:int = 0;
         var stones:int = this.checkItemEmpty();
         if(stones == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.fusion.noEquip"));
            return true;
         }
         if(stones < 4)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.fusion.notEnoughStone"));
            return true;
         }
         if(stones == 4)
         {
            fusionType = int(PlayerManager.Instance.Self.StoreBag.items[1].FusionType);
            len = 5;
            for(i = 2; i < len; i++)
            {
               if(fusionType != PlayerManager.Instance.Self.StoreBag.items[i].FusionType)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.fusion.notSameStone"));
                  return true;
               }
            }
            for(j = 2; j < len; j++)
            {
               if(this._items[1].info.TemplateID != this._items[j].info.TemplateID)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.fusion.notSameLevelStone"));
                  return true;
               }
            }
         }
         return false;
      }
      
      private function showIt() : void
      {
         this.showArr();
      }
      
      public function get area() : Array
      {
         return this._items;
      }
      
      public function refreshData(items:Dictionary) : void
      {
         var place:String = null;
         var itemPlace:int = 0;
         var fusionType:int = 0;
         var len:int = 0;
         var i:int = 0;
         for(place in items)
         {
            itemPlace = int(place);
            if(itemPlace < 5)
            {
               this._items[itemPlace].info = PlayerManager.Instance.Self.StoreBag.items[itemPlace];
            }
            else
            {
               this._accessoryFrameII.setItemInfo(itemPlace,PlayerManager.Instance.Self.StoreBag.items[itemPlace]);
            }
         }
         if(this._items[1].info != null && this._items[2].info != null && this._items[3].info != null && this._items[4].info != null)
         {
            if(this._items[0].info != null)
            {
               SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,FusionItemCellII(this._items[0]).index,FusionItemCellII(this._items[0]).itemBagType,-1);
            }
            this.__previewRequest();
            fusionType = int(PlayerManager.Instance.Self.StoreBag.items[1].FusionType);
            len = 5;
            for(i = 2; i < len; i++)
            {
               if(fusionType != PlayerManager.Instance.Self.StoreBag.items[i].FusionType)
               {
                  this._clearPreview();
               }
            }
         }
         else
         {
            this._clearPreview();
            this.autoFusion = false;
         }
      }
      
      private function __fusionFinish(e:Event) : void
      {
         if(this._items[1].info != null && this._items[2].info != null && this._items[3].info != null && this._items[4].info != null)
         {
            this.__checkAuto();
         }
         else
         {
            this._clearPreview();
            this.autoFusion = false;
         }
      }
      
      private function __checkAuto() : void
      {
         var auto:Function;
         if(this.autoFusion)
         {
            auto = function():void
            {
               checkfunsion();
            };
            this._windowTime = setTimeout(auto,1000);
         }
      }
      
      public function updateData() : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            this._items[i].info = PlayerManager.Instance.Self.StoreBag.items[i];
         }
         for(var j:int = 5; j < 11; j++)
         {
            this._accessoryFrameII.setItemInfo(j,PlayerManager.Instance.Self.StoreBag.items[j + 5]);
         }
      }
      
      public function startShine(cellId:int) : void
      {
         this._items[cellId].startShine();
      }
      
      public function stopShine() : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            this._items[i].stopShine();
         }
      }
      
      private function showArr() : void
      {
         if(this.autoFusion)
         {
            return;
         }
         this.fusionArr.visible = true;
         this._fusion_btn_shineEffect.play();
      }
      
      private function hideArr() : void
      {
         this.fusionArr.visible = false;
         this._fusion_btn_shineEffect.stop();
      }
      
      public function show() : void
      {
         this.visible = true;
         this.updateData();
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            this.userGuide();
         }
      }
      
      public function hide() : void
      {
         this.autoFusion = false;
         this.visible = false;
         this._accessoryFrameII.hide();
         this.disposeUserGuide();
      }
      
      private function __upPreview(evt:CrazyTankSocketEvent) : void
      {
         var isBin:Boolean = false;
         var info:PreviewInfoII = null;
         var info1:PreviewInfoII = null;
         this.hideArr();
         var count:int = evt.pkg.readInt();
         this._itemsPreview = new Array();
         for(var i:int = 0; i < count; i++)
         {
            info = new PreviewInfoII();
            info.data(evt.pkg.readInt(),evt.pkg.readInt());
            info.rate = evt.pkg.readInt();
            this._itemsPreview.push(info);
         }
         isBin = evt.pkg.readBoolean();
         for(var j:int = 0; j < this._itemsPreview.length; j++)
         {
            info1 = this._itemsPreview[j] as PreviewInfoII;
            info1.info.IsBinds = isBin;
         }
         this._showPreview();
         this.showArr();
      }
      
      private function _showPreview() : void
      {
         this._items[5].info = this._itemsPreview[0].info;
         this._goodName.text = String(this._itemsPreview[0].info.Name);
         this._goodRate.text = this._itemsPreview[0].rate <= 5 ? LanguageMgr.GetTranslation("store.fusion.preview.LowRate") : String(this._itemsPreview[0].rate) + "%";
      }
      
      private function _clearPreview() : void
      {
         this._items[5].info = null;
         this._goodName.text = "";
         this._goodRate.text = "0%";
      }
      
      private function __accessoryItemClick(evt:StoreIIEvent) : void
      {
         this.gold_txt.text = String((this.checkItemEmpty() + this._accessoryFrameII.getCount()) * this._gold);
      }
      
      private function __itemInfoChange(evt:Event) : void
      {
         var stones:int = 0;
         stones = this.checkItemEmpty();
         this.gold_txt.text = String((stones + this._accessoryFrameII.getCount()) * this._gold);
         this._clearPreview();
         this.hideArr();
      }
      
      private function checkItemEmpty() : int
      {
         var stones:int = 0;
         if(PlayerManager.Instance.Self.StoreBag.items[1] != null)
         {
            stones++;
         }
         if(PlayerManager.Instance.Self.StoreBag.items[2] != null)
         {
            stones++;
         }
         if(PlayerManager.Instance.Self.StoreBag.items[3] != null)
         {
            stones++;
         }
         if(PlayerManager.Instance.Self.StoreBag.items[4] != null)
         {
            stones++;
         }
         return stones;
      }
      
      private function isAllBinds() : int
      {
         var stones:int = 0;
         if(this._items[1].info != null && Boolean(this._items[1].info.IsBinds))
         {
            stones++;
         }
         if(this._items[2].info != null && Boolean(this._items[2].info.IsBinds))
         {
            stones++;
         }
         if(this._items[3].info != null && Boolean(this._items[3].info.IsBinds))
         {
            stones++;
         }
         if(this._items[4].info != null && Boolean(this._items[4].info.IsBinds))
         {
            stones++;
         }
         return stones;
      }
      
      private function __fusionClick(evt:MouseEvent) : void
      {
         if(evt != null)
         {
            evt.stopImmediatePropagation();
         }
         SoundManager.instance.play("008");
         this._alertBand = false;
         this.checkfunsion();
      }
      
      private function checkfunsion() : void
      {
         var alert:BaseAlerFrame = null;
         var alert1:BaseAlerFrame = null;
         var alert2:BaseAlerFrame = null;
         if(this._showDontClickTip())
         {
            return;
         }
         if(PlayerManager.Instance.Self.Gold < (this._accessoryFrameII.getCount() + 4) * this._gold)
         {
            this.autoFusion = false;
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseV);
            return;
         }
         if(this.isAllBinds() != 0 && this.isAllBinds() != 4 && !this._alertBand)
         {
            alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert1.addEventListener(FrameEvent.RESPONSE,this._response);
            this._alertBand = true;
            return;
         }
         if(this._accessoryFrameII.isBinds && this.isAllBinds() != 4)
         {
            alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert2.addEventListener(FrameEvent.RESPONSE,this._response);
            return;
         }
         this.sendFusionRequest();
      }
      
      private function _responseV(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.okFastPurchaseGold();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = EquipType.GOLD_BOX;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = BaseAlerFrame(e.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._response);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendFusionRequest();
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function testingSXJ() : Boolean
      {
         var b:Boolean = false;
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(EquipType.isRongLing(this._items[i].info))
            {
               b = true;
               break;
            }
         }
         return b;
      }
      
      private function sendFusionRequest() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_FUSION))
         {
            SocketManager.Instance.out.syncWeakStep(Step.GUIDE_FUSION);
         }
         if(this.autoSelect)
         {
            this.autoFusion = true;
            this._fusion_btn.enable = true;
            this.hideArr();
         }
      }
      
      private function __previewRequest() : void
      {
      }
      
      private function __selectedChanged(event:Event) : void
      {
         SoundManager.instance.play("008");
         this.autoSelect = this._autoCheck.selected;
         if(this.autoSelect == false)
         {
            this.autoFusion = false;
         }
      }
      
      private function __autoSplit(e:Event) : void
      {
         SoundManager.instance.play("008");
         this._isAutoSplit = this._ckAutoSplit.selected;
         StoreIIFusionBG.lastIndexFusion = -1;
      }
      
      public function set autoSelect(value:Boolean) : void
      {
         this._autoSelect = value;
      }
      
      public function get autoSelect() : Boolean
      {
         return this._autoSelect;
      }
      
      public function set autoFusion(value:Boolean) : void
      {
         this._autoFusion = value;
         StrengthDataManager.instance.autoFusion = this._autoFusion;
         if(!this._autoFusion)
         {
            this._fusion_btn.enable = true;
            clearTimeout(this._windowTime);
            if(this._items[5].info != null)
            {
               this.showArr();
            }
         }
      }
      
      public function get autoFusion() : Boolean
      {
         return this._autoFusion;
      }
      
      private function __openHelp(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         var helpBd:HelpPrompt = ComponentFactory.Instance.creat("ddtstore.FusionHelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.fusion.StoreIIFusionBG.say");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         EffectManager.Instance.removeEffect(this._fusion_btn_shineEffect);
         StoreIIFusionBG.lastIndexFusion = -1;
         this.removeEvents();
         this.disposeUserGuide();
         clearTimeout(this._windowTime);
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._fusionTitle))
         {
            ObjectUtils.disposeObject(this._fusionTitle);
         }
         this._fusionTitle = null;
         if(Boolean(this._previewPanelBg))
         {
            ObjectUtils.disposeObject(this._previewPanelBg);
         }
         this._previewPanelBg = null;
         if(Boolean(this._previewNameLabel))
         {
            ObjectUtils.disposeObject(this._previewNameLabel);
         }
         this._previewNameLabel = null;
         if(Boolean(this._previewRateLabel))
         {
            ObjectUtils.disposeObject(this._previewRateLabel);
         }
         this._previewRateLabel = null;
         if(Boolean(this._area))
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         if(Boolean(this._accessoryFrameII))
         {
            ObjectUtils.disposeObject(this._accessoryFrameII);
         }
         this._accessoryFrameII = null;
         if(Boolean(this._fusion_btn))
         {
            ObjectUtils.disposeObject(this._fusion_btn);
         }
         this._fusion_btn = null;
         if(Boolean(this._fusionHelp))
         {
            ObjectUtils.disposeObject(this._fusionHelp);
         }
         this._fusionHelp = null;
         if(Boolean(this.fusionArr))
         {
            ObjectUtils.disposeObject(this.fusionArr);
         }
         this.fusionArr = null;
         if(Boolean(this._goldTipText))
         {
            ObjectUtils.disposeObject(this._goldTipText);
         }
         this._goldTipText = null;
         if(Boolean(this.gold_txt))
         {
            ObjectUtils.disposeObject(this.gold_txt);
         }
         this.gold_txt = null;
         if(Boolean(this._goldIcon))
         {
            ObjectUtils.disposeObject(this._goldIcon);
         }
         this._goldIcon = null;
         if(Boolean(this._goodName))
         {
            ObjectUtils.disposeObject(this._goodName);
         }
         this._goodName = null;
         if(Boolean(this._goodRate))
         {
            ObjectUtils.disposeObject(this._goodRate);
         }
         this._goodRate = null;
         if(Boolean(this._autoCheck))
         {
            ObjectUtils.disposeObject(this._autoCheck);
         }
         this._autoCheck = null;
         if(Boolean(this._ckAutoSplit))
         {
            ObjectUtils.disposeObject(this._ckAutoSplit);
            this._ckAutoSplit = null;
         }
         this._pointArray = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

