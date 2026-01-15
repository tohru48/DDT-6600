package store.view.strength
{
   import bagAndInfo.cell.BagCell;
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
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.BuyItemButton;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import store.HelpFrame;
   import store.IStoreViewBG;
   import store.ShowSuccessExp;
   import store.StoneCell;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.data.StoreEquipExperience;
   import store.view.ConsortiaRateManager;
   import trainer.controller.NewHandQueue;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import vip.VipController;
   
   public class StoreIIStrengthBG extends Sprite implements IStoreViewBG
   {
      
      public static const WEAPONUPGRADESPLAY:String = "weaponUpgradesPlay";
      
      private var _area:StoreDragInArea;
      
      private var _items:Array;
      
      private var _strength_btn:BaseButton;
      
      private var _strength_btn_shineEffect:IEffect;
      
      private var _strengHelp:BaseButton;
      
      private var _bg:MutipleImage;
      
      private var _gold_txt:FilterFrameText;
      
      private var _pointArray:Vector.<Point>;
      
      private var _strthShine:MovieImage;
      
      private var _startStrthTip:MutipleImage;
      
      private var _consortiaSmith:MySmithLevel;
      
      private var _strengthStoneCellBg1:Bitmap;
      
      private var _strengthStoneText1:FilterFrameText;
      
      private var _strengthenEquipmentCellBg:Image;
      
      private var _strengthenEquipmentCellText:FilterFrameText;
      
      private var _isInjectSelect:SelectedCheckButton;
      
      private var _progressLevel:StoreStrengthProgress;
      
      private var _lastStrengthTime:int = 0;
      
      private var _showSuccessExp:ShowSuccessExp;
      
      private var _starMovie:MovieClip;
      
      private var _weaponUpgrades:MovieClip;
      
      private var _sBuyStrengthStoneCell:BuyItemButton;
      
      private var _strengthEquipmentTxt:Bitmap;
      
      private var _vipDiscountTxt:FilterFrameText;
      
      private var _vipDiscountBg:Image;
      
      private var _vipDiscountIcon:Image;
      
      private var _aler:StrengthSelectNumAlertFrame;
      
      public function StoreIIStrengthBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var item:StoreCell = null;
         this._vipDiscountBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.VipDiscountBg");
         this._vipDiscountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.VipDiscountTxt");
         this._vipDiscountTxt.text = LanguageMgr.GetTranslation("store.Strength.VipDiscountDesc");
         this._vipDiscountIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.VipDiscountIcon");
         addChild(this._vipDiscountBg);
         addChild(this._vipDiscountIcon);
         addChild(this._vipDiscountTxt);
         this._strengthEquipmentTxt = ComponentFactory.Instance.creatBitmap("asset.ddtstore.strengthenEquipmentTxt");
         PositionUtils.setPos(this._strengthEquipmentTxt,"asset.ddtstore.strengthenEquipmentTxtPos");
         addChild(this._strengthEquipmentTxt);
         this._strengthStoneCellBg1 = ComponentFactory.Instance.creatBitmap("asset.ddtstore.GoodPanel");
         PositionUtils.setPos(this._strengthStoneCellBg1,"ddtstore.StoreIIStrengthBG.StrengthCellBg1Point");
         addChild(this._strengthStoneCellBg1);
         this._strengthStoneText1 = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.GoodCellText");
         this._strengthStoneText1.text = LanguageMgr.GetTranslation("store.Strength.GoodPanelText.StrengthStone");
         PositionUtils.setPos(this._strengthStoneText1,"ddtstore.StoreIIStrengthBG.StrengthStoneText1Point");
         addChild(this._strengthStoneText1);
         this._strengthenEquipmentCellBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.stoneCellBg");
         PositionUtils.setPos(this._strengthenEquipmentCellBg,"ddtstore.StoreIIStrengthBG.EquipmentCellBgPos");
         addChild(this._strengthenEquipmentCellBg);
         this._strengthenEquipmentCellText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellText");
         this._strengthenEquipmentCellText.text = LanguageMgr.GetTranslation("store.Strength.StrengthenCurrentEquipmentCellText");
         PositionUtils.setPos(this._strengthenEquipmentCellText,"ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellTextPos");
         addChild(this._strengthenEquipmentCellText);
         this._items = new Array();
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         this._strength_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.StrengthenBtn");
         addChild(this._strength_btn);
         this._strength_btn_shineEffect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION,this._strength_btn,{"color":EffectColorType.GOLD});
         this._startStrthTip = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.ArrowHeadTip");
         addChild(this._startStrthTip);
         this._strengHelp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HelpButton");
         addChild(this._strengHelp);
         this._isInjectSelect = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrength.isInjectSelect");
         addChild(this._isInjectSelect);
         this._progressLevel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreStrengthProgress");
         this._progressLevel.tipStyle = "ddt.view.tips.OneLineTip";
         this._progressLevel.tipDirctions = "3,7,6";
         this._progressLevel.tipGapV = 4;
         addChild(this._progressLevel);
         this._progressLevel.addEventListener(WEAPONUPGRADESPLAY,this.weaponUpgradesPlay);
         this.getCellsPoint();
         for(var i:int = 0; i < this._pointArray.length; i++)
         {
            switch(i)
            {
               case 0:
                  item = new StrengthStone([StoneType.STRENGTH,StoneType.STRENGTH_1],i);
                  break;
               case 1:
                  item = new StreangthItemCell(i);
                  break;
            }
            item.addEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[i] = item;
            item.x = this._pointArray[i].x;
            item.y = this._pointArray[i].y;
            addChild(item);
         }
         this._consortiaSmith = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.MySmithLevel");
         addChild(this._consortiaSmith);
         this._sBuyStrengthStoneCell = ComponentFactory.Instance.creat("ddtstore.StoreIIStrengthBG.StoneBuyBtn");
         this._sBuyStrengthStoneCell.setup(EquipType.STRENGTH_STONE_NEW,1,true);
         this._sBuyStrengthStoneCell.text = LanguageMgr.GetTranslation("store.Strength.BuyButtonText");
         this._sBuyStrengthStoneCell.tipData = null;
         this._sBuyStrengthStoneCell.tipStyle = null;
         addChild(this._sBuyStrengthStoneCell);
         this.hide();
         this.hideArr();
         this._showSuccessExp = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.ShowSuccessExp");
         this._showSuccessExp.showVIPRate();
         var strI:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.StrengthenStonStripExp");
         var strIII:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.ConsortiaAddStripExp");
         var strVIP:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.VIPAddStripExp");
         var strIV:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.AllNumStrip");
         if(PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            strIII = LanguageMgr.GetTranslation("tank.view.store.consortiaRateI");
         }
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            strVIP = LanguageMgr.GetTranslation("store.StoreIIComposeBG.NoVIPAddStrip");
         }
         this._showSuccessExp.showAllTips(strI,strIII,strIV);
         this._showSuccessExp.showVIPTip(strVIP);
         addChild(this._showSuccessExp);
      }
      
      private function initEvent() : void
      {
         this._isInjectSelect.addEventListener(MouseEvent.CLICK,this.__isInjectSelectClick);
         this._strength_btn.addEventListener(MouseEvent.CLICK,this.__strengthClick);
         this._strengHelp.addEventListener(MouseEvent.CLICK,this.__openHelp);
         ConsortiaRateManager.instance.addEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._consortiaLoadComplete);
      }
      
      private function removeEvents() : void
      {
         this._isInjectSelect.removeEventListener(MouseEvent.CLICK,this.__isInjectSelectClick);
         this._strength_btn.removeEventListener(MouseEvent.CLICK,this.__strengthClick);
         this._strengHelp.removeEventListener(MouseEvent.CLICK,this.__openHelp);
         ConsortiaRateManager.instance.removeEventListener(ConsortiaRateManager.CHANGE_CONSORTIA,this._consortiaLoadComplete);
         this._items[0].removeEventListener(Event.CHANGE,this.__itemInfoChange);
         this._items[1].removeEventListener(Event.CHANGE,this.__itemInfoChange);
         this._progressLevel.removeEventListener(WEAPONUPGRADESPLAY,this.weaponUpgradesPlay);
      }
      
      private function userGuide() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_STRENGTH) && PlayerManager.Instance.Self.Grade >= 5)
         {
            NewHandQueue.Instance.push(new Step(Step.STRENGTH_WEAPON_TIP,this.exeWeaponTip,this.preWeaponTip,this.finWeaponTip));
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CLOTHES_WEAPON_TIP) && PlayerManager.Instance.Self.Grade >= 10 && TaskManager.instance.isAvailable(TaskManager.instance.getQuestByID(564)))
         {
            NewHandQueue.Instance.push(new Step(Step.CLOTHES_WEAPON_TIP,this.exeWeaponTip,this.preClothesTip,this.finWeaponTip));
         }
      }
      
      private function preWeaponTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,0,"trainer.strWeaponArrowPos","asset.trainer.txtWeaponTip","trainer.strWeaponTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
      }
      
      private function preClothesTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.STR_CLOTHES,0,"trainer.strClothesArrowPos","asset.trainer.txtWeaponTip","trainer.strClothesTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
      }
      
      private function exeWeaponTip() : Boolean
      {
         return this._items[1].info;
      }
      
      private function finWeaponTip() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_STRENGTH) && PlayerManager.Instance.Self.Grade >= 5 && !this.exeStoneTip())
         {
            NewHandQueue.Instance.push(new Step(Step.STRENGTH_STONE_TIP,this.exeStoneTip,this.preStoneTip,this.finStoneTip));
         }
      }
      
      private function preStoneTip() : void
      {
         NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON,0,"trainer.strStoneArrowPos","asset.trainer.txtStoneTip","trainer.strStoneTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
      }
      
      private function exeStoneTip() : Boolean
      {
         return this._items[0].info;
      }
      
      private function finStoneTip() : void
      {
         this.disposeUserGuide();
      }
      
      private function disposeUserGuide() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
         NewHandQueue.Instance.dispose();
      }
      
      private function getCellsPoint() : void
      {
         this._pointArray = new Vector.<Point>();
         var point:Point = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.Strengthpoint0");
         this._pointArray.push(point);
         var point2:Point = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.Strengthpoint1");
         this._pointArray.push(point2);
      }
      
      public function get isAutoStrength() : Boolean
      {
         return this._isInjectSelect.selected;
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      public function get area() : Array
      {
         return this._items;
      }
      
      private function updateProgress(info:InventoryItemInfo) : void
      {
         if(Boolean(info))
         {
            if(Boolean(StoreEquipExperience.expericence))
            {
               this._progressLevel.setProgress(info);
            }
         }
      }
      
      private function isAdaptToItem(info:InventoryItemInfo) : Boolean
      {
         if(this._items[1].info == null)
         {
            return true;
         }
         if(this._items[1].info.RefineryLevel > 0)
         {
            if(info.Property1 == "35")
            {
               return true;
            }
            return false;
         }
         if(info.Property1 == "35")
         {
            return false;
         }
         return true;
      }
      
      private function isAdaptToStone(info:InventoryItemInfo) : Boolean
      {
         if(this._items[0].info != null && this._items[0].info.Property1 != info.Property1)
         {
            return false;
         }
         return true;
      }
      
      private function itemIsAdaptToStone(info:InventoryItemInfo) : Boolean
      {
         if(info.RefineryLevel > 0)
         {
            if(this._items[0].info != null && this._items[0].info.Property1 != "35")
            {
               return false;
            }
            return true;
         }
         if(this._items[0].info != null && this._items[0].info.Property1 == "35")
         {
            return false;
         }
         return true;
      }
      
      private function showNumAlert(info:InventoryItemInfo, index:int) : void
      {
         this._aler = ComponentFactory.Instance.creat("ddtstore.StrengthSelectNumAlertFrame");
         this._aler.addExeFunction(this.sellFunction,this.notSellFunction);
         this._aler.goodsinfo = info;
         this._aler.index = index;
         this._aler.show(info.Count);
      }
      
      private function sellFunction(_nowNum:int, goodsinfo:InventoryItemInfo, index:int) : void
      {
         SocketManager.Instance.out.sendMoveGoods(goodsinfo.BagType,goodsinfo.Place,BagInfo.STOREBAG,index,_nowNum,true);
         if(Boolean(this._aler))
         {
            this._aler.dispose();
         }
         if(Boolean(this._aler) && Boolean(this._aler.parent))
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function notSellFunction() : void
      {
         if(Boolean(this._aler))
         {
            this._aler.dispose();
         }
         if(Boolean(this._aler) && Boolean(this._aler.parent))
         {
            removeChild(this._aler);
         }
         this._aler = null;
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
                        if(this.isAdaptToStone(info))
                        {
                           if(info.Count == 1)
                           {
                              SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1,true);
                           }
                           else
                           {
                              this.showNumAlert(info,ds.index);
                           }
                           return;
                        }
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                     }
                  }
               }
               else if(ds is StreangthItemCell)
               {
                  if(info.getRemainDate() <= 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                  }
                  else
                  {
                     if(info.StrengthenLevel >= PathManager.solveStrengthMax())
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
                        return;
                     }
                     if(source.info.CanStrengthen)
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
                        StreangthItemCell(this._items[1]).actionState = true;
                        return;
                     }
                  }
               }
            }
         }
         if(EquipType.isStrengthStone(info))
         {
            for each(ds in this._items)
            {
               if(ds is StoneCell && (ds as StoneCell).types.indexOf(info.Property1) > -1 && info.CategoryID == 11)
               {
                  if(this.isAdaptToStone(info))
                  {
                     if(info.Count == 1)
                     {
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1,true);
                     }
                     else
                     {
                        this.showNumAlert(info,ds.index);
                     }
                     return;
                  }
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
               }
            }
         }
      }
      
      private function _responseII(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         evt.currentTarget.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function showArr() : void
      {
         this._startStrthTip.visible = true;
         this._strength_btn_shineEffect.play();
      }
      
      private function hideArr() : void
      {
         this._startStrthTip.visible = false;
         this._strength_btn_shineEffect.stop();
      }
      
      public function refreshData(items:Dictionary) : void
      {
         var place:String = null;
         var itemPlace:int = 0;
         for(place in items)
         {
            itemPlace = int(place);
            if(this._items.hasOwnProperty(itemPlace))
            {
               this._items[itemPlace].info = PlayerManager.Instance.Self.StoreBag.items[itemPlace];
            }
         }
      }
      
      public function updateData() : void
      {
         if(Boolean(PlayerManager.Instance.Self.StoreBag.items[0]) && this.isAdaptToStone(PlayerManager.Instance.Self.StoreBag.items[0]))
         {
            this._items[0].info = PlayerManager.Instance.Self.StoreBag.items[0];
         }
         else
         {
            this._items[0].info = null;
         }
         if(Boolean(PlayerManager.Instance.Self.StoreBag.items[1]) && EquipType.isStrengthStone(PlayerManager.Instance.Self.StoreBag.items[1]))
         {
            this._items[1].info = PlayerManager.Instance.Self.StoreBag.items[1];
         }
         else
         {
            this._items[1].info = null;
         }
      }
      
      public function startShine(cellId:int) : void
      {
         if(cellId < 2)
         {
            this._items[cellId].startShine();
         }
      }
      
      public function stopShine() : void
      {
         this._items[0].stopShine();
         this._items[1].stopShine();
      }
      
      public function show() : void
      {
         if(Boolean(this._items))
         {
            this._items[0].addEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[1].addEventListener(Event.CHANGE,this.__itemInfoChange);
         }
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
         if(Boolean(this._items))
         {
            this._items[0].removeEventListener(Event.CHANGE,this.__itemInfoChange);
            this._items[1].removeEventListener(Event.CHANGE,this.__itemInfoChange);
         }
      }
      
      private function __isInjectSelectClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __strengthClick(evt:MouseEvent) : void
      {
         var alert1:BaseAlerFrame = null;
         evt.stopImmediatePropagation();
         SoundManager.instance.play("008");
         if(this._showDontClickTip())
         {
            return;
         }
         if(this._items[1].info != null)
         {
            if(this._items[1].itemInfo.StrengthenLevel >= PathManager.solveStrengthMax())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
               return;
            }
         }
         if(this.checkTipBindType())
         {
            alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert1.moveEnable = false;
            alert1.info.enableHtml = true;
            alert1.info.mutiline = true;
            alert1.addEventListener(FrameEvent.RESPONSE,this._bingResponse);
         }
         else if(!this._progressLevel.getStarVisible())
         {
            this.sendSocket();
         }
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
      
      private function _bingResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this._bingResponse);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendSocket();
         }
         ObjectUtils.disposeObject(evt.target);
      }
      
      private function sendSocket() : void
      {
         if(!this.checkLevel())
         {
            return;
         }
         var consortiaState:Boolean = false;
         var rate:int = ConsortiaRateManager.instance.rate;
         if(PlayerManager.Instance.Self.ConsortiaID != 0 && rate > 0)
         {
            consortiaState = true;
         }
         var time:int = getTimer();
         if(time - this._lastStrengthTime > 1200)
         {
            SocketManager.Instance.out.sendItemStrength(consortiaState,this._isInjectSelect.selected);
            this._lastStrengthTime = time;
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUIDE_STRENGTH))
            {
               SocketManager.Instance.out.syncWeakStep(Step.GUIDE_STRENGTH);
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
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
         return false;
      }
      
      private function checkLevel() : Boolean
      {
         var item:StreangthItemCell = this._items[1] as StreangthItemCell;
         var info:InventoryItemInfo = item.info as InventoryItemInfo;
         if(Boolean(info) && info.StrengthenLevel >= PathManager.solveStrengthMax())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
            return false;
         }
         return true;
      }
      
      private function __itemInfoChange(evt:Event) : void
      {
         var itemCell:StreangthItemCell = null;
         var info:InventoryItemInfo = null;
         if(evt.currentTarget is StreangthItemCell)
         {
            itemCell = evt.currentTarget as StreangthItemCell;
            info = itemCell.info as InventoryItemInfo;
            if(Boolean(info))
            {
               if(StreangthItemCell(this._items[1]).actionState)
               {
                  this._progressLevel.initProgress(info);
                  StreangthItemCell(this._items[1]).actionState = false;
                  if(Boolean(this._starMovie))
                  {
                     this.removeStarMovie();
                  }
                  if(Boolean(this._weaponUpgrades))
                  {
                     this.removeWeaponUpgradesMovie();
                  }
               }
               else
               {
                  this.updateProgress(info);
               }
            }
            else
            {
               this._progressLevel.resetProgress();
            }
            dispatchEvent(new Event(Event.CHANGE));
         }
         this.getCountExpI();
         if(this._items[0].info == null)
         {
            this._items[1].stoneType = "";
            this._items[0].stoneType = "";
         }
         if(this._items[1].info == null)
         {
            this._items[0].itemType = -1;
         }
         else
         {
            this._items[0].itemType = this._items[1].info.RefineryLevel;
         }
         if(this._items[1].info == null || this._items[0].info == null || this._items[1].itemInfo.StrengthenLevel >= 9)
         {
            this.hideArr();
            return;
         }
         this.showArr();
      }
      
      private function _showDontClickTip() : Boolean
      {
         if(this._items[1].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.strength.dontStrengthI"));
            return true;
         }
         if(this._items[0].info == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.strength.dontStrengthII"));
            return true;
         }
         return false;
      }
      
      private function getCountExpI() : void
      {
         var tempExpI:Number = 0;
         var tempExpIII:Number = 0;
         var tempExpIV:Number = 0;
         var tempExpVip:Number = 0;
         if(this._items[0].info != null)
         {
            tempExpI += this._items[0].info.Property2;
         }
         if(ConsortiaRateManager.instance.rate > 0)
         {
            tempExpIII = ConsortiaRateManager.instance.getConsortiaStrengthenEx(PlayerManager.Instance.Self.consortiaInfo.SmithLevel) / 100 * tempExpI;
         }
         if(PlayerManager.Instance.Self.IsVIP)
         {
            tempExpVip = VipController.instance.getVIPStrengthenEx(PlayerManager.Instance.Self.VIPLevel) / 100 * tempExpI;
         }
         tempExpIV = tempExpI + tempExpIII + tempExpVip;
         this._showSuccessExp.showAllNum(tempExpI,tempExpIII,tempExpVip,tempExpIV);
      }
      
      public function consortiaRate() : void
      {
         ConsortiaRateManager.instance.reset();
      }
      
      private function _consortiaLoadComplete(e:Event) : void
      {
         this.getCountExpI();
      }
      
      public function getStrengthItemCellInfo() : InventoryItemInfo
      {
         return (this._items[1] as StreangthItemCell).itemInfo;
      }
      
      private function __openHelp(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("ddtstore.StrengthHelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.StoreIIStrengthBG.say");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function starMoviePlay() : void
      {
         if(!this._starMovie)
         {
            this._starMovie = ClassUtils.CreatInstance("accet.strength.starMovie");
         }
         this._starMovie.gotoAndPlay(1);
         this._starMovie.addEventListener(Event.ENTER_FRAME,this.__starMovieFrame);
         PositionUtils.setPos(this._starMovie,"ddtstore.StoreIIStrengthBG.starMoviePoint");
         addChild(this._starMovie);
      }
      
      private function __starMovieFrame(e:Event) : void
      {
         if(Boolean(this._starMovie))
         {
            if(this._starMovie.currentFrame == this._starMovie.totalFrames)
            {
               this.removeStarMovie();
            }
         }
      }
      
      private function removeStarMovie() : void
      {
         if(this._starMovie.hasEventListener(Event.ENTER_FRAME))
         {
            this._starMovie.removeEventListener(Event.ENTER_FRAME,this.__starMovieFrame);
         }
         if(this.contains(this._starMovie))
         {
            this.removeChild(this._starMovie);
         }
      }
      
      private function weaponUpgradesPlay(e:Event) : void
      {
         if(!this._weaponUpgrades)
         {
            this._weaponUpgrades = ClassUtils.CreatInstance("asset.strength.weaponUpgrades");
         }
         this._weaponUpgrades.gotoAndPlay(1);
         this._weaponUpgrades.addEventListener(Event.ENTER_FRAME,this.__weaponUpgradesFrame);
         PositionUtils.setPos(this._weaponUpgrades,"ddtstore.StoreIIStrengthBG.weaponUpgradesPoint");
         addChild(this._weaponUpgrades);
         this.dispatchEvent(new Event(WEAPONUPGRADESPLAY));
      }
      
      private function __weaponUpgradesFrame(e:Event) : void
      {
         if(Boolean(this._weaponUpgrades))
         {
            if(this._weaponUpgrades.currentFrame == this._weaponUpgrades.totalFrames)
            {
               this.removeWeaponUpgradesMovie();
            }
         }
      }
      
      private function removeWeaponUpgradesMovie() : void
      {
         if(this._weaponUpgrades.hasEventListener(Event.ENTER_FRAME))
         {
            this._weaponUpgrades.removeEventListener(Event.ENTER_FRAME,this.__weaponUpgradesFrame);
         }
         if(this.contains(this._weaponUpgrades))
         {
            this.removeChild(this._weaponUpgrades);
         }
      }
      
      public function dispose() : void
      {
         var item:Object = null;
         this.removeEvents();
         this.disposeUserGuide();
         if(Boolean(this._area))
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         for each(item in this._items)
         {
            item.dispose();
         }
         this._items = null;
         EffectManager.Instance.removeEffect(this._strength_btn_shineEffect);
         ObjectUtils.disposeObject(this._strengthStoneCellBg1);
         this._strengthStoneCellBg1 = null;
         if(Boolean(this._strengthStoneText1))
         {
            this._strengthStoneText1.dispose();
            this._strengthStoneText1 = null;
         }
         ObjectUtils.disposeObject(this._strengthenEquipmentCellBg);
         this._strengthenEquipmentCellBg = null;
         ObjectUtils.disposeObject(this._strengthenEquipmentCellText);
         this._strengthenEquipmentCellText = null;
         this._pointArray = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._strength_btn))
         {
            ObjectUtils.disposeObject(this._strength_btn);
         }
         this._strength_btn = null;
         if(Boolean(this._strthShine))
         {
            ObjectUtils.disposeObject(this._strthShine);
         }
         this._strthShine = null;
         if(Boolean(this._startStrthTip))
         {
            ObjectUtils.disposeObject(this._startStrthTip);
         }
         this._startStrthTip = null;
         if(Boolean(this._strengHelp))
         {
            ObjectUtils.disposeObject(this._strengHelp);
         }
         this._strengHelp = null;
         if(Boolean(this._showSuccessExp))
         {
            ObjectUtils.disposeObject(this._showSuccessExp);
         }
         this._showSuccessExp = null;
         if(Boolean(this._consortiaSmith))
         {
            ObjectUtils.disposeObject(this._consortiaSmith);
         }
         this._consortiaSmith = null;
         if(Boolean(this._gold_txt))
         {
            ObjectUtils.disposeObject(this._gold_txt);
         }
         this._gold_txt = null;
         if(Boolean(this._progressLevel))
         {
            ObjectUtils.disposeObject(this._progressLevel);
         }
         this._progressLevel = null;
         if(Boolean(this._isInjectSelect))
         {
            ObjectUtils.disposeObject(this._isInjectSelect);
         }
         this._isInjectSelect = null;
         if(Boolean(this._aler))
         {
            ObjectUtils.disposeObject(this._aler);
         }
         this._aler = null;
         ObjectUtils.disposeObject(this._vipDiscountBg);
         this._vipDiscountBg = null;
         ObjectUtils.disposeObject(this._vipDiscountIcon);
         this._vipDiscountIcon = null;
         ObjectUtils.disposeObject(this._vipDiscountTxt);
         this._vipDiscountTxt = null;
         if(Boolean(this._starMovie))
         {
            if(this._starMovie.hasEventListener(Event.ENTER_FRAME))
            {
               this._starMovie.removeEventListener(Event.ENTER_FRAME,this.__starMovieFrame);
            }
            ObjectUtils.disposeObject(this._starMovie);
            this._starMovie = null;
         }
         if(Boolean(this._weaponUpgrades))
         {
            if(this._weaponUpgrades.hasEventListener(Event.ENTER_FRAME))
            {
               this._weaponUpgrades.removeEventListener(Event.ENTER_FRAME,this.__weaponUpgradesFrame);
            }
            ObjectUtils.disposeObject(this._weaponUpgrades);
            this._weaponUpgrades = null;
         }
         if(Boolean(this._sBuyStrengthStoneCell))
         {
            ObjectUtils.disposeObject(this._sBuyStrengthStoneCell);
         }
         this._sBuyStrengthStoneCell = null;
         if(Boolean(this._strengthEquipmentTxt))
         {
            ObjectUtils.disposeObject(this._strengthEquipmentTxt);
         }
         this._strengthEquipmentTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

