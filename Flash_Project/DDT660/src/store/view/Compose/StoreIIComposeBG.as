package store.view.Compose
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
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.view.common.BuyItemButton;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.IStoreViewBG;
   import store.ShowSuccessRate;
   import store.StoneCell;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.view.ConsortiaRateManager;
   import store.view.StoneCellFrame;
   import store.view.shortcutBuy.ShortcutBuyFrame;
   import store.view.strength.MySmithLevel;
   import trainer.controller.NewHandQueue;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class StoreIIComposeBG extends Sprite implements IStoreViewBG
   {
      
      private static const ITEMS:Array = [11004,11008,11012,11016];
      
      public static const COMPOSE_TOP:int = 50;
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _bg:MutipleImage;
      
      private var _luckyStoneCell:StoneCellFrame;
      
      private var _strengthStoneCell:StoneCellFrame;
      
      private var _equipmentCell:StoneCellFrame;
      
      private var _compose_btn:BaseButton;
      
      private var _compose_btn_shineEffect:IEffect;
      
      private var _composeHelp:BaseButton;
      
      private var cpsArr:MutipleImage;
      
      private var _cBuyluckyBtn:BuyItemButton;
      
      private var _buyStoneBtn:TextButton;
      
      private var _composeTitle:Bitmap;
      
      private var _pointArray:Vector.<Point>;
      
      private var _showSuccessRate:ShowSuccessRate;
      
      private var _consortiaSmith:MySmithLevel;
      
      public var composeRate:Array = [0.8,0.5,0.3,0.1,0.05];
      
      public function StoreIIComposeBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var i:int = 0;
         var item:StoreCell = null;
         this._items = new Array();
         this._composeTitle = ComponentFactory.Instance.creatBitmap("asset.ddtstore.ComposeTitle");
         addChild(this._composeTitle);
         this._luckyStoneCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.LuckySymbolCell");
         this._luckyStoneCell.label = LanguageMgr.GetTranslation("store.Strength.GoodPanelText.LuckySymbol");
         addChild(this._luckyStoneCell);
         this._strengthStoneCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.StrengthenStoneCell");
         this._strengthStoneCell.label = LanguageMgr.GetTranslation("store.Compose.ComposeStone");
         addChild(this._strengthStoneCell);
         this._equipmentCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.EquipmentCell");
         this._equipmentCell.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
         addChild(this._equipmentCell);
         this._compose_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.ComposeBtn");
         this._compose_btn_shineEffect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION,this._compose_btn,{"color":EffectColorType.GOLD});
         addChild(this._compose_btn);
         this._composeHelp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HelpButton");
         addChild(this._composeHelp);
         this.cpsArr = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ArrowHeadComposeTip");
         addChild(this.cpsArr);
         this._cBuyluckyBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.BuyLuckyComposeBtn");
         this._cBuyluckyBtn.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
         this._cBuyluckyBtn.setup(EquipType.LUCKY,2,true);
         addChild(this._cBuyluckyBtn);
         this._buyStoneBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.BuyComposeStoneBtn");
         this._buyStoneBtn.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
         addChild(this._buyStoneBtn);
         this._consortiaSmith = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.MySmithLevel");
         addChild(this._consortiaSmith);
         this.getCellsPoint();
         for(i = 0; i < 3; i++)
         {
            if(i == 0)
            {
               item = new ComposeStoneCell([StoneType.LUCKY],i);
            }
            else if(i == 1)
            {
               item = new ComposeItemCell(i);
            }
            else if(i == 2)
            {
               item = new ComposeStoneCell([StoneType.COMPOSE],i);
            }
            item.x = this._pointArray[i].x;
            item.y = this._pointArray[i].y;
            item.addEventListener(Event.CHANGE,this.__itemInfoChange);
            addChild(item);
            this._items.push(item);
         }
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         this.hide();
         this.hideArr();
         this._showSuccessRate = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.ShowSuccessRate");
         var strI:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.ComposeStonStrip");
         var strII:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.LuckSignStrip");
         var strIII:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.ConsortiaAddStrip");
         var strIV:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.noVIPAllNumStrip");
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            strIII = LanguageMgr.GetTranslation("tank.view.store.consortiaRateI");
         }
         this._showSuccessRate.showAllTips(strI,strII,strIII,strIV);
         addChild(this._showSuccessRate);
      }
      
      private function getCellsPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Vector.<Point>();
         for(var i:int = 0; i < 3; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.Composepoint" + i);
            this._pointArray.push(point);
         }
      }
      
      public function dragDrop(source:BagCell) : void
      {
         var ds:StoreCell = null;
         if(source == null)
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
         for each(ds in this._items)
         {
            if(Boolean(ds))
            {
               if(ds is StoneCell)
               {
                  if(ds.info == null)
                  {
                     if((ds as StoneCell).types.indexOf(info.Property1) > -1 && info.CategoryID == 11)
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,info.Count,true);
                        return;
                     }
                  }
               }
               else if(ds is ComposeItemCell)
               {
                  if(info.getRemainDate() <= 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                  }
                  else
                  {
                     if(info.AgilityCompose == COMPOSE_TOP && info.DefendCompose == COMPOSE_TOP && info.AttackCompose == COMPOSE_TOP && info.LuckCompose == COMPOSE_TOP)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.ComposeItemCell.up"));
                        return;
                     }
                     if(source.info.CanCompose)
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,info.Count,true);
                        return;
                     }
                  }
               }
            }
         }
         if(EquipType.isComposeStone(info) || info.CategoryID == 11 && info.Property1 == StoneType.SOULSYMBOL || info.CategoryID == 11 && info.Property1 == StoneType.LUCKY)
         {
            for each(ds in this._items)
            {
               if(ds is StoneCell && (ds as StoneCell).types.indexOf(info.Property1) > -1 && info.CategoryID == 11)
               {
                  SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,info.Count,true);
                  return;
               }
            }
         }
      }
      
      public function startShine(cellId:int) : void
      {
         if(cellId != 3)
         {
            this._items[cellId].startShine();
         }
      }
      
      public function refreshData(items:Dictionary) : void
      {
         var place:String = null;
         var itemPlace:int = 0;
         for(place in items)
         {
            itemPlace = int(place);
            if(itemPlace < this._items.length)
            {
               this._items[itemPlace].info = PlayerManager.Instance.Self.StoreBag.items[itemPlace];
            }
         }
      }
      
      public function updateData() : void
      {
         for(var i:int = 0; i < 3; i++)
         {
            this._items[i].info = PlayerManager.Instance.Self.StoreBag.items[i];
         }
      }
      
      public function stopShine() : void
      {
         for(var i:int = 0; i < 3; i++)
         {
            this._items[i].stopShine();
         }
      }
      
      private function initEvent() : void
      {
         this._compose_btn.addEventListener(MouseEvent.CLICK,this.__composeClick);
         this._composeHelp.addEventListener(MouseEvent.CLICK,this.__openHelp);
         this._buyStoneBtn.addEventListener(MouseEvent.CLICK,this.__buyStone);
         ConsortiaRateManager.instance.addEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._consortiaLoadComplete);
      }
      
      private function userGuide() : void
      {
         var tmpInfo:QuestInfo = null;
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_COMPOSE))
         {
            tmpInfo = TaskManager.instance.getQuestByID(566);
            if(TaskManager.instance.isAvailableQuest(tmpInfo,true) && !tmpInfo.isCompleted)
            {
               NewHandQueue.Instance.push(new Step(Step.COMPOSE_WEAPON_TIP,this.exeWeaponTip,this.preWeaponTip,this.finWeaponTip));
               NewHandQueue.Instance.push(new Step(Step.COMPOSE_STONE_TIP,this.exeStoneTip,this.preStoneTip,this.finStoneTip));
            }
         }
      }
      
      private function preWeaponTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.COM_WEAPON,0,"trainer.comWeaponArrowPos","asset.trainer.txtWeaponTip","trainer.comWeaponTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
      }
      
      private function exeWeaponTip() : Boolean
      {
         return this._items[1].info;
      }
      
      private function finWeaponTip() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.COM_WEAPON);
      }
      
      private function preStoneTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.COM_WEAPON,45,"trainer.comStoneArrowPos","asset.trainer.txtComStoneTip","trainer.comStoneTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
      }
      
      private function exeStoneTip() : Boolean
      {
         return this._items[2].info;
      }
      
      private function finStoneTip() : void
      {
         this.disposeUserGuide();
      }
      
      private function disposeUserGuide() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.COM_WEAPON);
         NewHandQueue.Instance.dispose();
      }
      
      private function __buyStone(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var quickBuy:ShortcutBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortcutBuyFrame");
         quickBuy.show(ITEMS,false,LanguageMgr.GetTranslation("store.view.Compose.buyCompose"),2);
      }
      
      private function showArr() : void
      {
         this.cpsArr.visible = true;
         this._compose_btn_shineEffect.play();
      }
      
      private function hideArr() : void
      {
         this.cpsArr.visible = false;
         this._compose_btn_shineEffect.stop();
      }
      
      public function get area() : Array
      {
         return this._items;
      }
      
      private function __composeClick(evt:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         evt.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(this._showDontClickTip())
         {
            return;
         }
         if(this.checkTipBindType())
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
         }
         else
         {
            this.hideArr();
            this.sendSocket();
         }
      }
      
      private function _responseV(evt:FrameEvent) : void
      {
         var _quick:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseV);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            _quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _quick.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function _responseI(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = BaseAlerFrame(e.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendSocket();
         }
         ObjectUtils.disposeObject(e.target);
      }
      
      private function sendSocket() : void
      {
         var consortiaState:Boolean = false;
         if(PlayerManager.Instance.Self.ConsortiaID != 0 && ConsortiaRateManager.instance.rate > 0)
         {
            consortiaState = true;
         }
         SocketManager.Instance.out.sendItemCompose(consortiaState);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_COMPOSE))
         {
            SocketManager.Instance.out.syncWeakStep(Step.GUIDE_COMPOSE);
         }
      }
      
      private function checkTipBindType() : Boolean
      {
         if(Boolean(this._items[1].itemInfo) && Boolean(this._items[1].itemInfo.IsBinds))
         {
            return false;
         }
         if(Boolean(this._items[0].itemInfo) && Boolean(this._items[0].itemInfo.IsBinds))
         {
            return true;
         }
         if(Boolean(this._items[2].itemInfo) && Boolean(this._items[2].itemInfo.IsBinds))
         {
            return true;
         }
         return false;
      }
      
      private function __itemInfoChange(evt:Event) : void
      {
         if(this.getCountRate() > 0)
         {
         }
         this.getCountRateI();
         if(this._items[1].info == null || this._items[2].info == null)
         {
            this.hideArr();
         }
         else
         {
            this.showArr();
         }
      }
      
      private function _showDontClickTip() : Boolean
      {
         if(this._items[1].info == null && this._items[2].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.compose.dontCompose"));
            return true;
         }
         if(this._items[1].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.compose.dontComposeI"));
            return true;
         }
         if(this._items[2].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.compose.dontComposeII"));
            return true;
         }
         return false;
      }
      
      private function getCountRate() : Number
      {
         var rate:Number = 0;
         if(this._items[1] == null || this._items[1].info == null)
         {
            return rate;
         }
         if(this._items[2] != null && this._items[2].info != null)
         {
            rate = this.composeRate[this._items[2].info.Quality - 1] * 100;
         }
         if(rate > 0 && this._items[0] != null && this._items[0].info != null)
         {
            rate = (1 + this._items[0].info.Property2 / 100) * rate;
         }
         rate *= 1 + 0.1 * ConsortiaRateManager.instance.rate;
         rate = Math.floor(rate * 10) / 10;
         return rate > 100 ? 100 : rate;
      }
      
      private function getCountRateI() : void
      {
         var tempRateI:Number = 0;
         var tempRateII:Number = 0;
         var tempRateIII:Number = 0;
         var tempRateIV:Number = 0;
         if(this._items[1] == null || this._items[1].info == null)
         {
            this._showSuccessRate.showAllNum(tempRateI,tempRateII,tempRateIII,tempRateIV);
            return;
         }
         if(this._items[2] != null && this._items[2].info != null)
         {
            tempRateI = this.composeRate[this._items[2].info.Quality - 1] * 100;
         }
         if(tempRateI > 0 && this._items[0] != null && this._items[0].info != null)
         {
            tempRateII = this._items[0].info.Property2 / 100 * tempRateI;
         }
         tempRateIII = tempRateI * (0.1 * ConsortiaRateManager.instance.rate);
         tempRateIV = tempRateI + tempRateII + tempRateIII;
         tempRateI = Math.floor(tempRateI * 10) / 10;
         tempRateII = Math.floor(tempRateII * 10) / 10;
         tempRateIII = Math.floor(tempRateIII * 10) / 10;
         tempRateIV = Math.floor(tempRateIV * 10) / 10;
         tempRateI = tempRateI > 100 ? 100 : tempRateI;
         tempRateII = tempRateII > 100 ? 100 : tempRateII;
         tempRateIII = tempRateIII > 100 ? 100 : tempRateIII;
         tempRateIV = tempRateIV > 100 ? 100 : tempRateIV;
         this._showSuccessRate.showAllNum(tempRateI,tempRateII,tempRateIII,tempRateIV);
      }
      
      public function consortiaRate() : void
      {
         ConsortiaRateManager.instance.reset();
      }
      
      private function _consortiaLoadComplete(e:Event) : void
      {
         this.__itemInfoChange(null);
      }
      
      public function show() : void
      {
         this.visible = true;
         this._consortiaLoadComplete(null);
         this.consortiaRate();
         this.updateData();
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            this.userGuide();
         }
      }
      
      public function hide() : void
      {
         this.visible = false;
         this.disposeUserGuide();
         this.hideArr();
      }
      
      private function __openHelp(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         var helpBd:HelpPrompt = ComponentFactory.Instance.creat("ddtstore.ComposeHelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.StoreIIComposeBG.say");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this.disposeUserGuide();
         for(var i:int = 0; i < this._items.length; i++)
         {
            this._items[i].removeEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[i].dispose();
            this._items[i] = null;
         }
         this._items = null;
         this._compose_btn.removeEventListener(MouseEvent.CLICK,this.__composeClick);
         this._composeHelp.removeEventListener(MouseEvent.CLICK,this.__openHelp);
         ConsortiaRateManager.instance.removeEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._consortiaLoadComplete);
         EffectManager.Instance.removeEffect(this._compose_btn_shineEffect);
         if(Boolean(this._area))
         {
            this._area.dispose();
         }
         this._area = null;
         this._pointArray = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._luckyStoneCell))
         {
            ObjectUtils.disposeObject(this._luckyStoneCell);
         }
         this._luckyStoneCell = null;
         if(Boolean(this._strengthStoneCell))
         {
            ObjectUtils.disposeObject(this._strengthStoneCell);
         }
         this._strengthStoneCell = null;
         if(Boolean(this._compose_btn))
         {
            ObjectUtils.disposeObject(this._compose_btn);
         }
         this._compose_btn = null;
         if(Boolean(this._composeHelp))
         {
            ObjectUtils.disposeObject(this._composeHelp);
         }
         this._composeHelp = null;
         if(Boolean(this.cpsArr))
         {
            ObjectUtils.disposeObject(this.cpsArr);
         }
         this.cpsArr = null;
         if(Boolean(this._cBuyluckyBtn))
         {
            ObjectUtils.disposeObject(this._cBuyluckyBtn);
         }
         this._cBuyluckyBtn = null;
         if(Boolean(this._buyStoneBtn))
         {
            ObjectUtils.disposeObject(this._buyStoneBtn);
         }
         this._buyStoneBtn = null;
         if(Boolean(this._consortiaSmith))
         {
            ObjectUtils.disposeObject(this._consortiaSmith);
         }
         this._consortiaSmith = null;
         if(Boolean(this._consortiaSmith))
         {
            ObjectUtils.disposeObject(this._consortiaSmith);
         }
         this._consortiaSmith = null;
         if(Boolean(this._showSuccessRate))
         {
            ObjectUtils.disposeObject(this._showSuccessRate);
         }
         this._showSuccessRate = null;
         if(Boolean(this._equipmentCell))
         {
            ObjectUtils.disposeObject(this._equipmentCell);
         }
         this._equipmentCell = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

