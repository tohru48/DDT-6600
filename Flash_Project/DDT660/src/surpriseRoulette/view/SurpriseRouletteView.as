package surpriseRoulette.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.AddPublicTipManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.roulette.RouletteEvent;
   import ddt.view.tips.LaterEquipmentGoodView;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import surpriseRoulette.manager.SurpriseRouletteTurn;
   
   public class SurpriseRouletteView extends Sprite implements Disposeable
   {
      
      public static const GLINT_ALL_GOODSTYPE:int = 5;
      
      public static const MAX_SELECTED:int = 8;
      
      private static const NUM:int = 18;
      
      public static const GLINT_ONE_TIME:int = 3000;
      
      private var _turnControl:SurpriseRouletteTurn;
      
      private var _bg:Bitmap;
      
      private var _bg1:Bitmap;
      
      private var _btnBuy:BaseButton;
      
      private var _btnStart:BaseButton;
      
      private var _btnClose:BaseButton;
      
      private var _tileSelected:SimpleTileList;
      
      private var _txtKeyCount:FilterFrameText;
      
      private var _txtNeedKey:FilterFrameText;
      
      private var _mcGreen:MovieClip;
      
      private var _mcBig:MovieClip;
      
      private var _pos:Array;
      
      private var _turnCount:int;
      
      private var _keyCount:int;
      
      private var _needKeyCount:Array;
      
      private var _isTurn:Boolean;
      
      private var _canClose:Boolean;
      
      private var _selectedItemType:int;
      
      private var _turnSlectedNumber:int = 0;
      
      private var _selectedCount:int;
      
      private var _list:Vector.<SurpriseRouletteCell>;
      
      private var _selectedList:Vector.<SurpriseRouletteCell>;
      
      private var _tidList:Array;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _musicVolumn:int;
      
      public function SurpriseRouletteView(tidList:Array)
      {
         super();
         this._tidList = tidList;
         this.init();
         this.initEvent();
      }
      
      public function get turnCount() : int
      {
         return this._turnCount;
      }
      
      public function set turnCount(value:int) : void
      {
         this._turnCount = value;
         this._txtNeedKey.text = this.needKeyCount.toString();
      }
      
      public function set keyCount(value:int) : void
      {
         this._keyCount = value;
         this._txtKeyCount.text = this._keyCount.toString();
      }
      
      public function get keyCount() : int
      {
         return this._keyCount;
      }
      
      public function get needKeyCount() : int
      {
         return this._needKeyCount[this.turnCount];
      }
      
      public function get isTurn() : Boolean
      {
         return this._isTurn;
      }
      
      public function set isTurn(b:Boolean) : void
      {
         this._isTurn = b;
         if(b)
         {
            this._btnStart.enable = false;
            this._btnBuy.enable = false;
         }
         else
         {
            this._btnStart.enable = true;
            this._btnBuy.enable = true;
         }
      }
      
      public function set turnSlectedNumber(value:int) : void
      {
         this._turnSlectedNumber = value;
      }
      
      public function get turnSlectedNumber() : int
      {
         return this._turnSlectedNumber;
      }
      
      public function get canClose() : Boolean
      {
         return this._canClose;
      }
      
      private function init() : void
      {
         var j:int = 0;
         var p:Point = null;
         var bg:Bitmap = null;
         var cell:SurpriseRouletteCell = null;
         var goodsInfo:BoxGoodsTempInfo = null;
         var info:InventoryItemInfo = null;
         var bg1:Bitmap = null;
         var scell:SurpriseRouletteCell = null;
         AddPublicTipManager.Instance.type = AddPublicTipManager.SHENMILUNPAN;
         LaterEquipmentGoodView.isShow = false;
         this._musicVolumn = SharedManager.Instance.musicVolumn;
         SharedManager.Instance.musicVolumn = 0;
         SharedManager.Instance.changed();
         this._turnControl = new SurpriseRouletteTurn();
         this._pos = [];
         this._canClose = true;
         this._needKeyCount = [0,2,3,4,5,6,7,8,0];
         this._list = new Vector.<SurpriseRouletteCell>();
         this._selectedList = new Vector.<SurpriseRouletteCell>();
         for(var i:int = 0; i < NUM; i++)
         {
            p = ComponentFactory.Instance.creatCustomObject("surpriseRoulette.pos" + i);
            this._pos.push(p);
         }
         this._bg = ComponentFactory.Instance.creatBitmap("asset.awardSystem.surpriseRoulette.bg");
         this._mcGreen = ClassUtils.CreatInstance("asset.awardSystem.surpriseRoulette.green");
         this._mcGreen.stop();
         PositionUtils.setPos(this._mcGreen,"surpriseRoulette.posGreen");
         this._bg1 = ComponentFactory.Instance.creatBitmap("asset.awardSystem.surpriseRoulette.bg1");
         this._btnStart = ComponentFactory.Instance.creatComponentByStylename("surpriseRoulette.start");
         this._btnBuy = ComponentFactory.Instance.creatComponentByStylename("surpriseRoulette.buy");
         this._btnClose = ComponentFactory.Instance.creatComponentByStylename("surpriseRoulette.close");
         this._txtKeyCount = ComponentFactory.Instance.creatComponentByStylename("surpriseRoulette.txtKeyCount");
         this._txtNeedKey = ComponentFactory.Instance.creatComponentByStylename("surpriseRoulette.txtNeedKey");
         this._mcBig = ClassUtils.CreatInstance("asset.awardSystem.surpriseRoulette.mcBig");
         this._mcBig.gotoAndStop(1);
         this._mcBig.mouseEnabled = false;
         this._mcBig.mouseChildren = false;
         PositionUtils.setPos(this._mcBig,"surpriseRoulette.posBig");
         addChild(this._bg);
         addChild(this._mcGreen);
         addChild(this._bg1);
         addChild(this._btnStart);
         addChild(this._btnBuy);
         addChild(this._btnClose);
         addChild(this._txtKeyCount);
         addChild(this._txtNeedKey);
         for(j = 0; j < NUM; j++)
         {
            bg = ComponentFactory.Instance.creatBitmap("asset.awardSystem.surpriseRoulette.cellBg");
            cell = new SurpriseRouletteCell(bg,-19,1);
            cell.x = this._pos[j].x;
            cell.y = this._pos[j].y;
            addChild(cell);
            goodsInfo = this._tidList[j] as BoxGoodsTempInfo;
            info = this.getTemplateInfo(goodsInfo.TemplateId) as InventoryItemInfo;
            info.IsBinds = goodsInfo.IsBind;
            info.ValidDate = goodsInfo.ItemValid;
            info.IsJudge = true;
            cell.info = info;
            cell.count = goodsInfo.ItemCount;
            this._list.push(cell);
         }
         var rect:Rectangle = ComponentFactory.Instance.creatCustomObject("surpriseRoulette.rect");
         this._tileSelected = new SimpleTileList(4);
         this._tileSelected.hSpace = rect.width;
         this._tileSelected.vSpace = rect.height;
         this._tileSelected.x = rect.x;
         this._tileSelected.y = rect.y;
         for(var k:int = 0; k < MAX_SELECTED; k++)
         {
            bg1 = ComponentFactory.Instance.creatBitmap("asset.awardSystem.surpriseRoulette.selectedCellBg");
            scell = new SurpriseRouletteCell(bg1,-19,1);
            scell.count = 0;
            this._tileSelected.addChild(scell);
            this._selectedList.push(scell);
         }
         addChild(this._tileSelected);
         this.turnCount = 0;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_GET_ITEM,this.__getItem);
         RouletteManager.instance.addEventListener(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE,this.__keyUpdate);
         this._turnControl.addEventListener(SurpriseRouletteTurn.COMPLETE,this.__turnComplete);
         this._btnStart.addEventListener(MouseEvent.CLICK,this._startClick);
         this._btnBuy.addEventListener(MouseEvent.CLICK,this._buyClick);
         this._btnClose.addEventListener(MouseEvent.CLICK,this._closeClick);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_GET_ITEM,this.__getItem);
         RouletteManager.instance.removeEventListener(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE,this.__keyUpdate);
         this._turnControl.removeEventListener(SurpriseRouletteTurn.COMPLETE,this.__turnComplete);
         this._btnStart.removeEventListener(MouseEvent.CLICK,this._startClick);
         this._btnBuy.removeEventListener(MouseEvent.CLICK,this._buyClick);
         this._btnClose.removeEventListener(MouseEvent.CLICK,this._closeClick);
      }
      
      private function __getItem(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var bool:Boolean = pkg.readBoolean();
         var count:int = pkg.readInt();
         var templateID:int = pkg.readInt();
         var itemType:int = pkg.readInt();
         this._selectedGoodsInfo = this.getTemplateInfo(templateID) as InventoryItemInfo;
         this._selectedGoodsInfo.StrengthenLevel = pkg.readInt();
         this._selectedGoodsInfo.AttackCompose = pkg.readInt();
         this._selectedGoodsInfo.DefendCompose = pkg.readInt();
         this._selectedGoodsInfo.LuckCompose = pkg.readInt();
         this._selectedGoodsInfo.AgilityCompose = pkg.readInt();
         this._selectedGoodsInfo.IsBinds = pkg.readBoolean();
         this._selectedGoodsInfo.ValidDate = pkg.readInt();
         this._selectedCount = pkg.readByte();
         this._selectedGoodsInfo.IsJudge = true;
         this._selectedItemType = itemType;
         this.turnSlectedNumber = this._findCellByItemID(templateID,this._selectedCount);
         if(this.turnSlectedNumber == -1)
         {
            this.isTurn = false;
         }
         else
         {
            this._turnControl.turnPlate(this._list,this.turnSlectedNumber);
            this._canClose = false;
         }
      }
      
      private function __keyUpdate(evt:RouletteEvent) : void
      {
         this.keyCount = evt.keyCount;
      }
      
      private function __turnComplete(e:Event) : void
      {
         SoundManager.instance.play("126");
         this._mcGreen.stop();
         addChild(this._mcBig);
         this._mcBig.play();
         setTimeout(this.updateTurnList,GLINT_ONE_TIME);
      }
      
      private function updateTurnList() : void
      {
         if(Boolean(this._mcBig.parent))
         {
            removeChild(this._mcBig);
            this._mcBig.gotoAndStop(1);
         }
         var m:MovieClip = ClassUtils.CreatInstance("asset.awardSystem.surpriseRoulette.mcGetItem");
         m.x = this._tileSelected.x + this._selectedList[this.turnCount].x;
         m.y = this._tileSelected.y + this._selectedList[this.turnCount].y;
         var mc:MovieClipWrapper = new MovieClipWrapper(m,true,true);
         addChild(mc.movie);
         this._moveToSelctView();
         SoundManager.instance.play("125");
         this._canClose = true;
         ++this.turnCount;
         if(this._selectedItemType >= GLINT_ALL_GOODSTYPE)
         {
            SoundManager.instance.play("063");
         }
         this.isTurn = this.turnCount >= MAX_SELECTED ? true : false;
      }
      
      private function _moveToSelctView() : void
      {
         var stop:Bitmap = ComponentFactory.Instance.creat("asset.awardSystem.roulette.StopAsset");
         stop.width = stop.height = this._list[this.turnSlectedNumber].width;
         stop.smoothing = true;
         stop.x = this._list[this.turnSlectedNumber].x - this._list[this.turnSlectedNumber].width / 2;
         stop.y = this._list[this.turnSlectedNumber].y - this._list[this.turnSlectedNumber].width / 2;
         addChild(stop);
         this._list[this.turnSlectedNumber].visible = false;
         var cell:SurpriseRouletteCell = this._list.splice(this.turnSlectedNumber,1)[0] as SurpriseRouletteCell;
         if(this.turnCount < MAX_SELECTED)
         {
            this._selectedList[this.turnCount].info = this._selectedGoodsInfo;
            this._selectedList[this.turnCount].count = this._selectedCount;
            cell.dispose();
         }
      }
      
      private function _startClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this.isTurn)
         {
            if(this.needKeyCount <= this.keyCount)
            {
               this.isTurn = true;
               SocketManager.Instance.out.sendStartTurn();
               this._mcGreen.play();
            }
            else
            {
               RouletteManager.instance.showBuyRouletteKey(this._needKeyCount[this.turnCount],EquipType.SURPRISE_ROULETTE_KEY);
            }
         }
      }
      
      private function _buyClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var i:int = this._needKeyCount[this.turnCount] == 0 ? 1 : int(this._needKeyCount[this.turnCount]);
         RouletteManager.instance.showBuyRouletteKey(i,EquipType.SURPRISE_ROULETTE_KEY);
      }
      
      private function _closeClick(evt:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(!this._canClose && this._turnCount < MAX_SELECTED)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.rouletteview.quit"));
         }
         else
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.rouletteview.close"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this._response);
         }
      }
      
      private function _response(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(evt.target);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.dispose();
         }
      }
      
      private function getTemplateInfo(id:int) : InventoryItemInfo
      {
         var itemInfo:InventoryItemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = id;
         ItemManager.fill(itemInfo);
         return itemInfo;
      }
      
      private function _findCellByItemID(itemId:int, _count:int) : int
      {
         for(var i:int = 0; i < this._list.length; i++)
         {
            if(this._list[i].info.TemplateID == itemId && this._list[i].count == _count)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function _findSelectedGoodsNumberInTemplateIDList(itemId:int, _count:int) : int
      {
         for(var i:int = 0; i < this._tidList.length; i++)
         {
            if(this._tidList[i].TemplateId == itemId && this._tidList[i].ItemCount == _count)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function dispose() : void
      {
         AddPublicTipManager.Instance.type = 0;
         SharedManager.Instance.musicVolumn = this._musicVolumn;
         SharedManager.Instance.changed();
         SocketManager.Instance.out.sendFinishRoulette();
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._turnControl))
         {
            this._turnControl.dispose();
            this._turnControl = null;
         }
         this._bg = null;
         this._bg1 = null;
         this._btnStart = null;
         this._btnBuy = null;
         this._btnClose = null;
         this._txtKeyCount = null;
         this._txtNeedKey = null;
         this._pos = null;
         this._needKeyCount = null;
         this._mcBig = null;
         this._mcGreen = null;
         this._tileSelected = null;
         this._list = null;
         this._selectedList = null;
         this._selectedGoodsInfo = null;
         this._tidList.splice(0,this._tidList.length);
         this._tidList = null;
         LaterEquipmentGoodView.isShow = true;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

