package ddt.view.roulette
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   
   public class RouletteView extends Sprite implements Disposeable
   {
      
      public static const GLINT_ALL_GOODSTYPE:int = 4;
      
      public static const SELECTGOODS_SUM:int = 8;
      
      public static const GLINT_ONE_TIME:int = 3100;
      
      public static const GLINT_ALL_TIME:int = 7500;
      
      private var _keyCount:int = 0;
      
      private var _turnControl:TurnControl;
      
      private var _startButton:BaseButton;
      
      private var _buyKeyButton:BaseButton;
      
      private var _pointArray:Array;
      
      private var _selectNumber:int = 0;
      
      private var _needKeyCount:Array = [0,2,3,4,5,6,7,8,0];
      
      private var _goodsList:Vector.<RouletteGoodsCell>;
      
      private var _templateIDList:Array;
      
      private var _selectGoodsList:Vector.<RouletteGoodsCell>;
      
      private var _selectGoogsNumber:int = 0;
      
      private var _turnSlectedNumber:int = 0;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _selectedGoodsNumberInTemplateIDList:int = 0;
      
      private var _isTurn:Boolean = false;
      
      private var _isCanClose:Boolean = true;
      
      private var _isLoadSucceed:Boolean = false;
      
      private var _winTimeOut:uint = 1;
      
      private var _glintView:RouletteGlintView;
      
      private var _selectedItemType:int;
      
      private var _selectedCount:int;
      
      private var _selectedCellBox:HBox;
      
      private var _keyConutText:FilterFrameText;
      
      private var _selectNumberText:FilterFrameText;
      
      private var _needKeyText:FilterFrameText;
      
      public function RouletteView(templateIDList:Array)
      {
         super();
         this._templateIDList = templateIDList;
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var i:int = 0;
         var bg:Bitmap = null;
         var cell:RouletteGoodsCell = null;
         var goodsInfo:BoxGoodsTempInfo = null;
         var info:InventoryItemInfo = null;
         var bgII:Bitmap = null;
         var selectCell:RouletteGoodsCell = null;
         this._turnControl = new TurnControl();
         this._goodsList = new Vector.<RouletteGoodsCell>();
         this._selectGoodsList = new Vector.<RouletteGoodsCell>();
         var _bg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.awardSystem.roulette.RouletteBG");
         addChild(_bg);
         this._keyConutText = ComponentFactory.Instance.creat("roulette.RouletteStyleI");
         this._selectNumberText = ComponentFactory.Instance.creat("roulette.RouletteStyleII");
         this._needKeyText = ComponentFactory.Instance.creat("roulette.RouletteStyleIII");
         addChild(this._keyConutText);
         addChild(this._selectNumberText);
         addChild(this._needKeyText);
         this.getAllGoodsPoint();
         for(i = 0; i <= 17; i++)
         {
            bg = ComponentFactory.Instance.creatBitmap("asset.awardSystem.roulette.CellBGAsset");
            cell = new RouletteGoodsCell(bg,10,32);
            cell.x = this._pointArray[i].x;
            cell.y = this._pointArray[i].y;
            cell.selected = true;
            cell.cellBG = false;
            addChild(cell);
            goodsInfo = this._templateIDList[i] as BoxGoodsTempInfo;
            info = this.getTemplateInfo(goodsInfo.TemplateId) as InventoryItemInfo;
            info.IsBinds = goodsInfo.IsBind;
            info.ValidDate = goodsInfo.ItemValid;
            info.IsJudge = true;
            cell.info = info;
            cell.count = goodsInfo.ItemCount;
            this._goodsList.push(cell);
         }
         this._selectedCellBox = ComponentFactory.Instance.creat("roulette.SeletedHBox");
         this._selectedCellBox.beginChanges();
         for(var j:int = 0; j < SELECTGOODS_SUM; j++)
         {
            bgII = ComponentFactory.Instance.creatBitmap("asset.awardSystem.roulette.SelectCellBGAsset");
            selectCell = new RouletteGoodsCell(bgII,4,26);
            selectCell.selected = false;
            selectCell.cellBG = false;
            this._selectGoodsList.push(selectCell);
            this._selectedCellBox.addChild(selectCell);
         }
         this._selectedCellBox.commitChanges();
         addChild(this._selectedCellBox);
         this.selectNumber = 0;
         this._startButton = ComponentFactory.Instance.creat("roulette.StartTurnButton");
         addChild(this._startButton);
         this._buyKeyButton = ComponentFactory.Instance.creat("roulette.BuyKeyButton");
         addChild(this._buyKeyButton);
         this._glintView = new RouletteGlintView(this._pointArray);
         addChild(this._glintView);
         this._turnControl.turnPlateII(this._goodsList);
         this._turnControl.autoMove = false;
      }
      
      private function getAllGoodsPoint() : void
      {
         var point:Point = null;
         this._pointArray = new Array();
         for(var i:int = 0; i < 18; i++)
         {
            point = ComponentFactory.Instance.creatCustomObject("roulette.point" + i);
            this._pointArray.push(point);
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_GET_ITEM,this._getItem);
         RouletteManager.instance.addEventListener(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE,this._keyUpdate);
         this._turnControl.addEventListener(TurnControl.TURNCOMPLETE,this._turnComplete);
         this._startButton.addEventListener(MouseEvent.CLICK,this._turnClick);
         this._buyKeyButton.addEventListener(MouseEvent.CLICK,this._buyKeyClick);
      }
      
      private function _getItem(e:CrazyTankSocketEvent) : void
      {
         var templateID:int = 0;
         var itemType:int = 0;
         var pkg:PackageIn = e.pkg;
         var btlifeBoo:Boolean = pkg.readBoolean();
         var count:int = pkg.readInt();
         if(btlifeBoo)
         {
            templateID = pkg.readInt();
            itemType = pkg.readInt();
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
            this._selectedGoodsNumberInTemplateIDList = this._findSelectedGoodsNumberInTemplateIDList(templateID,this._selectedCount);
            if(this.turnSlectedNumber == -1)
            {
               this.isTurn = false;
            }
            else
            {
               this._startTurn();
               this._isCanClose = false;
            }
         }
         else
         {
            this.isTurn = false;
         }
      }
      
      private function _turnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.needKeyCount <= this.keyCount && !this.isTurn)
         {
            this.isTurn = true;
            SocketManager.Instance.out.sendStartTurn();
         }
         else if(this.needKeyCount > this.keyCount)
         {
            RouletteManager.instance.showBuyRouletteKey(this._needKeyCount[this._selectNumber],EquipType.ROULETTE_KEY);
         }
      }
      
      private function _startTurn() : void
      {
         this._startButton.enable = false;
         this._turnControl.turnPlate(this._goodsList,this.turnSlectedNumber);
      }
      
      private function _buyKeyClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var i:int = this._needKeyCount[this._selectNumber] == 0 ? 1 : int(this._needKeyCount[this._selectNumber]);
         RouletteManager.instance.showBuyRouletteKey(i,EquipType.ROULETTE_KEY);
      }
      
      private function _keyUpdate(e:RouletteEvent) : void
      {
         this.keyCount = e.keyCount;
      }
      
      private function _turnComplete(e:Event) : void
      {
         this._startButton.enable = true;
         this._goodsList[this.turnSlectedNumber].selected = false;
         this._winTimeOut = setTimeout(this._updateTurnList,GLINT_ONE_TIME);
         this._glintView.showOneCell(this._selectedGoodsNumberInTemplateIDList,GLINT_ONE_TIME);
         SoundManager.instance.play("126");
      }
      
      private function _updateTurnList() : void
      {
         this._moveToSelctView();
         SoundManager.instance.play("125");
         this._isCanClose = true;
         if(this._selectedItemType >= GLINT_ALL_GOODSTYPE)
         {
            this._glintView.showTwoStep(GLINT_ALL_TIME);
            SoundManager.instance.play("063");
            this._glintView.addEventListener(RouletteGlintView.BIGGLINTCOMPLETE,this._bigGlintComplete);
         }
         else
         {
            ++this.selectNumber;
            this.isTurn = this._selectNumber >= SELECTGOODS_SUM ? true : false;
         }
      }
      
      private function _bigGlintComplete(e:Event) : void
      {
         this._glintView.removeEventListener(RouletteGlintView.BIGGLINTCOMPLETE,this._bigGlintComplete);
         ++this.selectNumber;
         this.isTurn = this._selectNumber >= SELECTGOODS_SUM ? true : false;
         SoundManager.instance.stop("063");
      }
      
      private function _moveToSelctView() : void
      {
         var stop:Bitmap = ComponentFactory.Instance.creat("asset.awardSystem.roulette.StopAsset");
         stop.x = this._goodsList[this.turnSlectedNumber].x - 1;
         stop.y = this._goodsList[this.turnSlectedNumber].y - 1;
         addChild(stop);
         this._goodsList[this.turnSlectedNumber].visible = false;
         var cell:RouletteGoodsCell = this._goodsList.splice(this.turnSlectedNumber,1)[0] as RouletteGoodsCell;
         if(this.selectNumber < SELECTGOODS_SUM)
         {
            this._selectGoodsList[this.selectNumber].info = this._selectedGoodsInfo;
            this._selectGoodsList[this.selectNumber].count = this._selectedCount;
            this._selectGoodsList[this.selectNumber].cellBG = true;
            cell.dispose();
         }
      }
      
      private function _findCellByItemID(itemId:int, _count:int) : int
      {
         for(var i:int = 0; i < this._goodsList.length; i++)
         {
            if(this._goodsList[i].info.TemplateID == itemId && this._goodsList[i].count == _count)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function _findSelectedGoodsNumberInTemplateIDList(itemId:int, _count:int) : int
      {
         for(var i:int = 0; i < this._templateIDList.length; i++)
         {
            if(this._templateIDList[i].TemplateId == itemId && this._templateIDList[i].ItemCount == _count)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function _finish() : void
      {
         SocketManager.Instance.out.sendFinishRoulette();
      }
      
      public function set keyCount(value:int) : void
      {
         this._keyCount = value;
         this._keyConutText.text = String(this._keyCount);
      }
      
      public function get keyCount() : int
      {
         return this._keyCount;
      }
      
      public function set selectNumber(value:int) : void
      {
         this._selectNumber = value;
         this._selectNumberText.text = String(8 - this._selectNumber);
         this._needKeyText.text = String(this._needKeyCount[this._selectNumber]);
         if(this._selectNumber == 8)
         {
            this._startButton.enable = false;
         }
      }
      
      private function get needKeyCount() : int
      {
         return this._needKeyCount[this._selectNumber];
      }
      
      public function get selectNumber() : int
      {
         return this._selectNumber;
      }
      
      public function set turnSlectedNumber(value:int) : void
      {
         this._turnSlectedNumber = value;
      }
      
      public function get turnSlectedNumber() : int
      {
         return this._turnSlectedNumber;
      }
      
      public function set isTurn(value:Boolean) : void
      {
         this._isTurn = value;
         if(this._isTurn)
         {
            this._buyKeyButton.enable = false;
         }
         else
         {
            this._buyKeyButton.enable = true;
         }
      }
      
      public function get isTurn() : Boolean
      {
         return this._isTurn;
      }
      
      public function get isCanClose() : Boolean
      {
         return this._isCanClose;
      }
      
      private function getTemplateInfo(id:int) : InventoryItemInfo
      {
         var itemInfo:InventoryItemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = id;
         ItemManager.fill(itemInfo);
         return itemInfo;
      }
      
      public function dispose() : void
      {
         RouletteManager.instance.removeEventListener(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE,this._keyUpdate);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_GET_ITEM,this._getItem);
         this._turnControl.removeEventListener(TurnControl.TURNCOMPLETE,this._turnComplete);
         this._startButton.removeEventListener(MouseEvent.CLICK,this._turnClick);
         this._buyKeyButton.removeEventListener(MouseEvent.CLICK,this._buyKeyClick);
         this._selectedGoodsInfo = null;
         if(Boolean(this._turnControl))
         {
            this._turnControl.dispose();
            this._turnControl = null;
         }
         if(Boolean(this._glintView))
         {
            this._glintView.removeEventListener(RouletteGlintView.BIGGLINTCOMPLETE,this._bigGlintComplete);
            this._glintView.dispose();
            this._glintView = null;
         }
         this._finish();
         this._templateIDList.splice(0,this._templateIDList.length);
         clearTimeout(this._winTimeOut);
         for(var i:int = 0; i < this._goodsList.length; i++)
         {
            this._goodsList[i].dispose();
         }
         for(var j:int = 0; j < this._selectGoodsList.length; j++)
         {
            this._selectGoodsList[j].dispose();
         }
         if(Boolean(this._startButton))
         {
            ObjectUtils.disposeObject(this._startButton);
         }
         this._startButton = null;
         if(Boolean(this._buyKeyButton))
         {
            ObjectUtils.disposeObject(this._buyKeyButton);
         }
         this._buyKeyButton = null;
         if(Boolean(this._keyConutText))
         {
            ObjectUtils.disposeObject(this._keyConutText);
         }
         this._keyConutText = null;
         if(Boolean(this._selectNumberText))
         {
            ObjectUtils.disposeObject(this._selectNumberText);
         }
         this._selectNumberText = null;
         if(Boolean(this._needKeyText))
         {
            ObjectUtils.disposeObject(this._needKeyText);
         }
         this._needKeyText = null;
         if(Boolean(this._selectedCellBox))
         {
            ObjectUtils.disposeObject(this._selectedCellBox);
         }
         this._selectedCellBox = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

