package store.view.embed
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.ShortcutBuyEvent;
   import ddt.events.StoreEmbedEvent;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import store.HelpFrame;
   import store.HelpPrompt;
   import store.IStoreViewBG;
   import store.StoneCell;
   import store.StoreCell;
   import store.StoreDragInArea;
   import store.data.StoreModel;
   import store.events.EmbedBackoutEvent;
   import store.events.EmbedEvent;
   import store.events.StoreIIEvent;
   
   public class StoreEmbedBG extends Sprite implements IStoreViewBG
   {
      
      public static const EMBED_BACKOUT_MONEY:Number = 500;
      
      public static const FIVE:int = 5;
      
      public static const SIX:int = 6;
      
      private var _items:Array;
      
      private var _area:StoreDragInArea;
      
      private var _stoneCells:Vector.<EmbedStoneCell>;
      
      private var _embedItemCell:EmbedItemCell;
      
      private var _quick:QuickBuyFrame;
      
      private var _embedBackoutDownItem:TextButton;
      
      private var _openFiveHoleBtn:MultipleButton;
      
      private var _openSixHoleBtn:MultipleButton;
      
      private var _embedStoneCell:EmbedStoneCell;
      
      private var _embedBackoutMouseIcon:ScaleFrameImage;
      
      private var _help:BaseButton;
      
      private var _embedBackoutBtn:EmbedBackoutButton;
      
      private var _bg:Image;
      
      private var _equipmentCellText:FilterFrameText;
      
      private var _currentHolePlace:int;
      
      private var _templateID:int;
      
      private var _pointArray:Vector.<Point>;
      
      private var _drill:InventoryItemInfo;
      
      private var _embedTxt:Bitmap;
      
      private var _hole5ExpBar:HoleExpBar;
      
      private var _hole6ExpBar:HoleExpBar;
      
      private var _stoneInfo:InventoryItemInfo;
      
      private var _openHoleNumber:int = 0;
      
      private var _drillPlace:int = 0;
      
      private var _itemPlace:int = 0;
      
      private var _drillID:int;
      
      private var _isEmbedBreak:Boolean = false;
      
      public function StoreEmbedBG()
      {
         super();
         this.init();
         this.initEvents();
      }
      
      public function holeLvUp(hole:int) : void
      {
         this._stoneCells[hole].holeLvUp();
      }
      
      private function init() : void
      {
         var stoneCell:EmbedStoneCell = null;
         this._embedTxt = ComponentFactory.Instance.creatBitmap("asset.ddtstore.embedTxt");
         PositionUtils.setPos(this._embedTxt,"asset.ddtstore.embedTxtPos");
         addChild(this._embedTxt);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreEmbedBG.EquipmentCellBg");
         addChild(this._bg);
         this._equipmentCellText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreEmbedBG.EquipmentCellText");
         this._equipmentCellText.text = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText");
         addChild(this._equipmentCellText);
         this._help = ComponentFactory.Instance.creatComponentByStylename("ddtstore.HelpButton");
         addChild(this._help);
         this._embedBackoutBtn = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedBackoutButton");
         this._embedBackoutBtn.text = LanguageMgr.GetTranslation("store.Embed.BackoutText");
         addChild(this._embedBackoutBtn);
         this._embedBackoutDownItem = ComponentFactory.Instance.creatComponentByStylename("ddttore.StoreEmbedBG.EmbedBackoutDownBtn");
         this._embedBackoutDownItem.text = LanguageMgr.GetTranslation("store.Embed.BackoutDownText");
         this._openFiveHoleBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreEmbedBG.EmbedOpenHoleFive");
         this._openFiveHoleBtn.text = LanguageMgr.GetTranslation("store.Embed.OpenHoleText");
         this._openSixHoleBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreEmbedBG.EmbedOpenHoleSix");
         this._openSixHoleBtn.text = LanguageMgr.GetTranslation("store.Embed.OpenHoleText");
         this._openFiveHoleBtn.transparentEnable = this._openSixHoleBtn.transparentEnable = true;
         this._openFiveHoleBtn.visible = this._openSixHoleBtn.visible = false;
         addChild(this._openFiveHoleBtn);
         addChild(this._openSixHoleBtn);
         this._hole5ExpBar = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.Hole5ExpBar");
         addChild(this._hole5ExpBar);
         this._hole6ExpBar = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.Hole6ExpBar");
         addChild(this._hole6ExpBar);
         this._items = [];
         this._stoneCells = new Vector.<EmbedStoneCell>();
         this.getCellsPoint();
         this._embedItemCell = new EmbedItemCell(0);
         this._embedItemCell.x = this._pointArray[0].x;
         this._embedItemCell.y = this._pointArray[0].y;
         addChild(this._embedItemCell);
         this._items.push(this._embedItemCell);
         this._area = new StoreDragInArea(this._items);
         addChildAt(this._area,0);
         for(var i:int = 1; i < 7; i++)
         {
            stoneCell = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.EmbedStoneCell",[i,-1]);
            stoneCell.x = this._pointArray[i].x;
            stoneCell.y = this._pointArray[i].y;
            addChild(stoneCell);
            stoneCell.mouseChildren = false;
            stoneCell.addEventListener(EmbedEvent.EMBED,this.__embed);
            stoneCell.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT,this.__EmbedBackout);
            stoneCell.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OVER,this.__EmbedBackoutDownItemOver);
            stoneCell.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OUT,this.__EmbedBackoutDownItemOut);
            stoneCell.addEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_DOWN,this.__EmbedBackoutDownItemDown);
            this._stoneCells.push(stoneCell);
         }
         this.hide();
      }
      
      private function initEvents() : void
      {
         this._embedItemCell.addEventListener(Event.CHANGE,this.__itemInfoChange);
         this._embedItemCell.addEventListener(StoreEmbedEvent.ItemChang,this.__itemChange);
         this._help.addEventListener(MouseEvent.CLICK,this.__openHelp);
         this._embedBackoutBtn.addEventListener(MouseEvent.CLICK,this.__embedBackoutBtnClick);
         this._openFiveHoleBtn.addEventListener(MouseEvent.CLICK,this._openFiveHoleClick);
         this._openSixHoleBtn.addEventListener(MouseEvent.CLICK,this._openSixHoleClick);
      }
      
      private function __itemChange(evt:StoreEmbedEvent) : void
      {
         if(this._stoneCells[FIVE - 1].hasDrill())
         {
         }
         if(this._stoneCells[SIX - 1].hasDrill())
         {
         }
      }
      
      private function getCellsPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Vector.<Point>();
         for(var i:int = 0; i < 7; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreEmbedBG.Embedpoint" + i);
            this._pointArray.push(point);
         }
      }
      
      private function __embedBackoutBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         this._embedBackoutBtn.mouseEnabled = false;
         this._embedBackoutBtn.isAction = true;
         this._embedBackoutMouseIcon = ComponentFactory.Instance.creatComponentByStylename("ddttore.StoreEmbedBG.embedBackoutMouseIcon");
         this._embedBackoutMouseIcon.setFrame(1);
         DragManager.startDrag(this._embedBackoutBtn,this._embedBackoutBtn,this._embedBackoutMouseIcon,evt.stageX,evt.stageY,DragEffect.MOVE,false,true);
      }
      
      private function __itemInfoChange(evt:Event) : void
      {
         for(var i:int = 0; i < this._stoneCells.length; i++)
         {
            this._stoneCells[i].close();
            this._openSixHoleBtn.visible = false;
            this._openFiveHoleBtn.visible = false;
         }
         if(this._embedItemCell.info != null)
         {
            this.initHoleType();
            this.updateHoles();
            dispatchEvent(new StoreIIEvent(StoreIIEvent.EMBED_INFORCHANGE));
         }
      }
      
      private function initHoleType() : void
      {
         var info:InventoryItemInfo = this._embedItemCell.itemInfo;
         var arr:Array = info.Hole.split("|");
         for(var j:int = 0; j < this._stoneCells.length; j++)
         {
            this._stoneCells[j].StoneType = arr[j].split(",")[1];
         }
      }
      
      private function updateHoles() : void
      {
         var info:InventoryItemInfo = this._embedItemCell.itemInfo;
         var tmpArr:Array = info.Hole.split("|");
         for(var i:int = 0; i < tmpArr.length; i++)
         {
            if((info.StrengthenLevel >= int(String(tmpArr[i]).split(",")[0]) || info["Hole" + (i + 1)] >= 0) && i < 4)
            {
               this._stoneCells[i].open();
               this._stoneCells[i].tipDerial = true;
               if(info["Hole" + (i + 1)] != 0)
               {
                  this._stoneCells[i].info = ItemManager.Instance.getTemplateById(info["Hole" + (i + 1)]);
                  this._stoneCells[i].tipDerial = false;
               }
            }
            else
            {
               this._stoneCells[i].close();
               this._stoneCells[i].tipDerial = false;
            }
         }
         this.updateOpenFiveSixHole(info);
      }
      
      private function updateOpenFiveSixHole(info:InventoryItemInfo) : void
      {
         info = this._embedItemCell.itemInfo;
         var arr:Array = info.Hole.split("|");
         if(info.Hole5Level > 0 || info.Hole5 > 0)
         {
            this._stoneCells[FIVE - 1].open();
            this._stoneCells[FIVE - 1].info = ItemManager.Instance.getTemplateById(info.Hole5);
         }
         if(info.Hole6Level > 0 || info.Hole6 > 0)
         {
            this._stoneCells[SIX - 1].open();
            this._stoneCells[SIX - 1].info = ItemManager.Instance.getTemplateById(info.Hole6);
         }
         this._hole5ExpBar.visible = this._openFiveHoleBtn.visible = info.Hole5Level < StoreModel.getHoleMaxOpLv() && this._embedItemCell.info != null;
         this._hole6ExpBar.visible = this._openSixHoleBtn.visible = info.Hole6Level < StoreModel.getHoleMaxOpLv() && this._embedItemCell.info != null;
      }
      
      private function confirmIsBindWhenOpenHole() : void
      {
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this.__confireIsBindWhenOpenHoleResponse);
      }
      
      private function __confireIsBindWhenOpenHoleResponse(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__confireIsBindWhenOpenHoleResponse);
         alert.dispose();
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.sendOpenHole(this._itemPlace,this._openHoleNumber,this._drill.TemplateID);
         }
      }
      
      private function getDrillByLevel(level:int) : InventoryItemInfo
      {
         var item:InventoryItemInfo = null;
         var items:DictionaryData = PlayerManager.Instance.Self.PropBag.items;
         for each(item in items)
         {
            if(EquipType.isDrill(item) && item.Level == level + 1)
            {
               return item;
            }
         }
         return null;
      }
      
      private function _openFiveHoleClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var item:InventoryItemInfo = InventoryItemInfo(this._embedItemCell.info);
         if(item.Hole5Level >= StoreModel.getHoleMaxOpLv())
         {
            return;
         }
         this._drill = this.getDrillByLevel(InventoryItemInfo(PlayerManager.Instance.Self.StoreBag.items[0]).Hole5Level);
         if(this._drill == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.Embed.OpenHole.NoDrill",InventoryItemInfo(PlayerManager.Instance.Self.StoreBag.items[0]).Hole5Level + 1));
         }
         else
         {
            this._openHoleNumber = FIVE;
            if(!item.IsBinds && this._drill.IsBinds)
            {
               this.confirmIsBindWhenOpenHole();
            }
            else
            {
               this.sendOpenHole(this._itemPlace,this._openHoleNumber,this._drill.TemplateID);
            }
         }
      }
      
      private function _openSixHoleClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var item:InventoryItemInfo = InventoryItemInfo(this._embedItemCell.info);
         if(item.Hole6Level >= StoreModel.getHoleMaxOpLv())
         {
            return;
         }
         this._drill = this.getDrillByLevel(InventoryItemInfo(PlayerManager.Instance.Self.StoreBag.items[0]).Hole6Level);
         if(this._drill == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.Embed.OpenHole.NoDrill",InventoryItemInfo(PlayerManager.Instance.Self.StoreBag.items[0]).Hole6Level + 1));
         }
         else
         {
            this._openHoleNumber = SIX;
            if(!item.IsBinds && this._drill.IsBinds)
            {
               this.confirmIsBindWhenOpenHole();
            }
            else
            {
               this.sendOpenHole(this._itemPlace,this._openHoleNumber,this._drill.TemplateID);
            }
         }
      }
      
      public function openHoleSucces(place:int, stoneBag:int, count:int) : void
      {
         SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,place,stoneBag,-1,count,true);
      }
      
      private function _showAlert() : void
      {
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this._responseVI);
      }
      
      private function sendOpenHole(itemPlace:int, number:int, drill:int) : void
      {
         SocketManager.Instance.out.sendItemOpenFiveSixHole(itemPlace,number,drill);
         this._drill = null;
      }
      
      private function getOpenHoleStone() : InventoryItemInfo
      {
         var skyInfo:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.SKY_OPENHOLE_STONE);
         var gndInfo:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.GND_OPENHOLE_STONE);
         return skyInfo != null ? skyInfo : gndInfo;
      }
      
      private function _responseVI(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseVI);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      public function dragDrop(source:BagCell) : void
      {
         var ds:StoreCell = null;
         var i:int = 0;
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
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
                        return;
                     }
                  }
               }
               else if(ds is EmbedItemCell)
               {
                  for(i = 1; i < 7; i++)
                  {
                     if(info.CategoryID == EquipType.HEAD || info.CategoryID == EquipType.CLOTH || info.CategoryID == EquipType.ARM)
                     {
                        this.__itemChange(null);
                        SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,ds.index,1);
                        return;
                     }
                  }
               }
            }
         }
      }
      
      private function __embed(evt:EmbedEvent) : void
      {
         var alert:BaseAlerFrame = null;
         evt.stopImmediatePropagation();
         this._currentHolePlace = evt.CellID;
         if(!this._embedItemCell.itemInfo.IsBinds && this._stoneCells[this._currentHolePlace - 1].itemInfo.IsBinds)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.StoreIIComposeBG.use"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this._responseIII);
         }
         else
         {
            this.__embed2();
         }
      }
      
      private function _responseIII(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this._responseIII);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendEmbed();
         }
         else
         {
            this.cancelEmbed1();
         }
         ObjectUtils.disposeObject(evt.target);
      }
      
      private function cancelEmbed1() : void
      {
         this.updateHoles();
      }
      
      private function __embed2() : void
      {
         if(this._embedItemCell.itemInfo["Hole" + this._currentHolePlace] == 0)
         {
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.Embed.EmbedAlertFrame.EmbedTipText"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _responseII(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(evt.currentTarget);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendEmbed();
         }
         else
         {
            this.updateHoles();
         }
      }
      
      private function __EmbedBackout(evt:EmbedBackoutEvent) : void
      {
         this._currentHolePlace = evt.CellID;
         this._templateID = evt.TemplateID;
         this.__EmbedBackoutFrame(evt);
      }
      
      private function __EmbedBackoutFrame(evt:Event) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         if(Boolean(this._embedStoneCell) && evt.type == MouseEvent.CLICK)
         {
            this._embedStoneCell.closeTip(evt as MouseEvent);
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.Embed.EmbedAlertFrame.TipText",EMBED_BACKOUT_MONEY),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._embedBackoutMouseIcon))
         {
            ObjectUtils.disposeObject(this._embedBackoutMouseIcon);
            this._embedBackoutMouseIcon = null;
         }
      }
      
      private function _response(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(evt.target);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.sendEmbedBackout();
         }
         else
         {
            this.updateHoles();
            stage.focus = this;
         }
      }
      
      private function __EmbedBackoutDownItemOver(evt:EmbedBackoutEvent) : void
      {
         evt.stopImmediatePropagation();
         this._currentHolePlace = evt.CellID;
         this._templateID = evt.TemplateID;
         if(!this._embedBackoutBtn.isAction && !contains(this._embedBackoutDownItem))
         {
            this._embedStoneCell = evt.target as EmbedStoneCell;
            this._embedBackoutDownItem.x = evt.target.x;
            this._embedBackoutDownItem.y = evt.target.y + evt.target.height + 8;
            addChild(this._embedBackoutDownItem);
            this._embedBackoutDownItem.addEventListener(MouseEvent.CLICK,this.__EmbedBackoutFrame);
            this._embedBackoutDownItem.addEventListener(MouseEvent.MOUSE_OVER,this.__EmbedShowTip);
            this._embedBackoutDownItem.addEventListener(MouseEvent.MOUSE_OUT,this.__EmbedBackoutDownItemOutGo);
         }
      }
      
      private function __EmbedShowTip(evt:MouseEvent) : void
      {
         if(Boolean(this._embedStoneCell))
         {
            this._embedStoneCell.showTip(evt);
         }
      }
      
      private function __EmbedBackoutDownItemDown(evt:EmbedBackoutEvent) : void
      {
         if(Boolean(this._embedBackoutMouseIcon))
         {
            this._embedBackoutMouseIcon.setFrame(2);
         }
      }
      
      private function __EmbedBackoutDownItemOut(evt:EmbedBackoutEvent) : void
      {
         if(Boolean(this._embedBackoutDownItem) && (mouseY >= this._embedBackoutDownItem.y && mouseY <= this._embedBackoutDownItem.y + this._embedBackoutDownItem.height && (mouseX >= this._embedBackoutDownItem.x && mouseX <= this._embedBackoutDownItem.x + this._embedBackoutDownItem.width)))
         {
            return;
         }
         this.__EmbedBackoutDownItemOutGo(evt);
      }
      
      private function __EmbedBackoutDownItemOutGo(evt:Event) : void
      {
         if(this._embedBackoutBtn != null && !this._embedBackoutBtn.isAction && this._embedBackoutDownItem && contains(this._embedBackoutDownItem))
         {
            if(this._embedStoneCell && evt != null && evt.type == MouseEvent.MOUSE_OUT)
            {
               this._embedStoneCell.closeTip(evt as MouseEvent);
            }
            this._embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OVER,this.__EmbedShowTip);
            this._embedBackoutDownItem.removeEventListener(MouseEvent.CLICK,this.__EmbedBackoutFrame);
            this._embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OUT,this.__EmbedBackoutDownItemOutGo);
            removeChild(this._embedBackoutDownItem);
         }
      }
      
      public function refreshData(items:Dictionary) : void
      {
         this._stoneCells[FIVE - 1].close();
         this._stoneCells[SIX - 1].close();
         this._embedItemCell.info = PlayerManager.Instance.Self.StoreBag.items[0];
         if(this._embedItemCell.info == null)
         {
            this._hole6ExpBar.visible = false;
            this._hole5ExpBar.visible = false;
         }
      }
      
      public function sendEmbed() : void
      {
         var alert:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.Gold < ServerConfigManager.instance.storeMustinlaygold)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseV);
            return;
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
         else
         {
            this.cancelFastPurchaseGold();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         this._quick = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         this._quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         this._quick.itemID = EquipType.GOLD_BOX;
         this._quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
         this._quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK,this.__shortCutBuyMoneyOkHandler);
         this._quick.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_CANCEL,this.__shortCutBuyMoneyCancelHandler);
         this._quick.addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
         LayerManager.Instance.addToLayer(this._quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function cancelQuickBuy() : void
      {
         this.updateHoles();
      }
      
      private function removeFromStageHandler(event:Event) : void
      {
         BagStore.instance.reduceTipPanelNumber();
      }
      
      private function __shortCutBuyHandler(evt:ShortcutBuyEvent) : void
      {
         evt.stopImmediatePropagation();
         this.__embed2();
      }
      
      private function __shortCutBuyMoneyOkHandler(evt:ShortcutBuyEvent) : void
      {
         evt.stopImmediatePropagation();
         this.updateHoles();
      }
      
      private function __shortCutBuyMoneyCancelHandler(evt:ShortcutBuyEvent) : void
      {
         evt.stopImmediatePropagation();
         this.updateHoles();
      }
      
      private function cancelFastPurchaseGold() : void
      {
         this.updateHoles();
      }
      
      public function sendEmbedBackout() : void
      {
         var alert:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.Money < EMBED_BACKOUT_MONEY)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            alert.addEventListener(FrameEvent.RESPONSE,this._responseIV);
            return;
         }
         this.__EmbedBackoutDownItemOutGo(null);
         SocketManager.Instance.out.sendItemEmbedBackout(this._currentHolePlace,this._templateID);
      }
      
      private function _responseIV(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseIV);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         this.cancelEmbed1();
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function cancelEmbedBackout() : void
      {
      }
      
      private function removeEvents() : void
      {
         for(var i:int = 1; i < 7; i++)
         {
            this._stoneCells[i - 1].removeEventListener(EmbedEvent.EMBED,this.__embed);
            this._stoneCells[i - 1].removeEventListener(EmbedBackoutEvent.EMBED_BACKOUT,this.__EmbedBackout);
            this._stoneCells[i - 1].removeEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OVER,this.__EmbedBackoutDownItemOver);
            this._stoneCells[i - 1].removeEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_OUT,this.__EmbedBackoutDownItemOut);
            this._stoneCells[i - 1].removeEventListener(EmbedBackoutEvent.EMBED_BACKOUT_DOWNITEM_DOWN,this.__EmbedBackoutDownItemDown);
         }
         this._embedItemCell.removeEventListener(Event.CHANGE,this.__itemInfoChange);
         this._embedItemCell.removeEventListener(StoreEmbedEvent.ItemChang,this.__itemChange);
         this._help.removeEventListener(MouseEvent.CLICK,this.__openHelp);
         this._embedBackoutBtn.removeEventListener(MouseEvent.CLICK,this.__embedBackoutBtnClick);
         this._openFiveHoleBtn.removeEventListener(MouseEvent.CLICK,this._openFiveHoleClick);
         this._openSixHoleBtn.removeEventListener(MouseEvent.CLICK,this._openSixHoleClick);
      }
      
      public function updateData() : void
      {
      }
      
      public function get area() : Array
      {
         return this._items;
      }
      
      public function startShine() : void
      {
         this._embedItemCell.startShine();
      }
      
      public function stoneStartShine(type:int, target:InventoryItemInfo) : void
      {
         var holeState:int = 0;
         var str:String = null;
         var tmpArr:Array = null;
         if(PlayerManager.Instance.Self.StoreBag.items[0] == null)
         {
            return;
         }
         var info:InventoryItemInfo = this._embedItemCell.itemInfo;
         var strHoleList:Array = info.Hole.split("|");
         for(var i:int = 0; i < this._stoneCells.length; i++)
         {
            holeState = int(info["Hole" + (i + 1)]);
            if(i < 4)
            {
               str = String(strHoleList[i]);
               tmpArr = str.split(",");
               if(info["Hole" + (i + 1)] >= 0 && (this._stoneCells[i] as EmbedStoneCell).StoneType == type)
               {
                  this._stoneCells[i].startShine();
               }
            }
            else if((this._stoneCells[i] as EmbedStoneCell).StoneType == type && info["Hole" + (i + 1) + "Level"] > 0)
            {
               this._stoneCells[i].startShine();
            }
         }
      }
      
      public function stopShine() : void
      {
         var item:EmbedStoneCell = null;
         this._embedItemCell.stopShine();
         for each(item in this._stoneCells)
         {
            item.stopShine();
         }
      }
      
      public function show() : void
      {
         this.visible = true;
         this.refreshData(null);
      }
      
      public function hide() : void
      {
         this.visible = false;
         for(var i:int = 1; i < 7; i++)
         {
            this._stoneCells[i - 1].close();
         }
      }
      
      private function __openHelp(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         var helpBd:HelpPrompt = ComponentFactory.Instance.creat("ddtstore.EmbedHelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("tank.view.store.matteHelp.title");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._items = null;
         this._embedStoneCell = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._equipmentCellText))
         {
            ObjectUtils.disposeObject(this._equipmentCellText);
         }
         this._equipmentCellText = null;
         if(Boolean(this._area))
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         if(Boolean(this._embedItemCell))
         {
            ObjectUtils.disposeObject(this._embedItemCell);
         }
         this._embedItemCell = null;
         if(Boolean(this._embedBackoutBtn))
         {
            ObjectUtils.disposeObject(this._embedBackoutBtn);
         }
         this._embedBackoutBtn = null;
         if(Boolean(this._help))
         {
            ObjectUtils.disposeObject(this._help);
         }
         this._help = null;
         if(Boolean(this._openFiveHoleBtn))
         {
            ObjectUtils.disposeObject(this._openFiveHoleBtn);
         }
         this._openFiveHoleBtn = null;
         if(Boolean(this._openSixHoleBtn))
         {
            ObjectUtils.disposeObject(this._openSixHoleBtn);
         }
         this._openSixHoleBtn = null;
         if(Boolean(this._hole5ExpBar))
         {
            ObjectUtils.disposeObject(this._hole5ExpBar);
         }
         this._hole5ExpBar = null;
         if(Boolean(this._hole6ExpBar))
         {
            ObjectUtils.disposeObject(this._hole6ExpBar);
         }
         this._hole6ExpBar = null;
         if(Boolean(this._embedBackoutDownItem))
         {
            this._embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OVER,this.__EmbedShowTip);
            this._embedBackoutDownItem.removeEventListener(MouseEvent.CLICK,this.__EmbedBackoutFrame);
            this._embedBackoutDownItem.removeEventListener(MouseEvent.MOUSE_OUT,this.__EmbedBackoutDownItemOutGo);
            ObjectUtils.disposeObject(this._embedBackoutDownItem);
         }
         this._embedBackoutDownItem = null;
         if(Boolean(this._embedBackoutMouseIcon))
         {
            ObjectUtils.disposeObject(this._embedBackoutMouseIcon);
         }
         this._embedBackoutMouseIcon = null;
         for(var i:int = 1; i < 7; i++)
         {
            ObjectUtils.disposeObject(this._stoneCells[i - 1]);
            this._stoneCells[i - 1] = null;
         }
         this._stoneCells = null;
         this._pointArray = null;
         if(Boolean(this._quick))
         {
            this._quick.removeEventListener(ShortcutBuyEvent.SHORTCUT_BUY,this.__shortCutBuyHandler);
            this._quick.removeEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_OK,this.__shortCutBuyMoneyOkHandler);
            this._quick.removeEventListener(ShortcutBuyEvent.SHORTCUT_BUY_MONEY_CANCEL,this.__shortCutBuyMoneyCancelHandler);
            this._quick.removeEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageHandler);
            if(Boolean(this._quick.parent))
            {
               this._quick.parent.removeChild(this._quick);
            }
         }
         this._quick = null;
         if(Boolean(this._embedTxt))
         {
            ObjectUtils.disposeObject(this._embedTxt);
         }
         this._embedTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

