package equipretrieve
{
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import store.StoreCell;
   
   public class RetrieveModel
   {
      
      private static var _instance:RetrieveModel;
      
      public static const EmailX:int = 776;
      
      public static const EmailY:int = 572;
      
      private var _CellsInfoArr:Array;
      
      private var _resultCell:Object;
      
      public var isFull:Boolean = false;
      
      private var _equipmentBag:BagInfo;
      
      public function RetrieveModel()
      {
         super();
      }
      
      public static function get Instance() : RetrieveModel
      {
         if(_instance == null)
         {
            _instance = new RetrieveModel();
         }
         return _instance;
      }
      
      public function start(_info:SelfInfo) : void
      {
         this._CellsInfoArr = new Array();
         this._CellsInfoArr = [null,null,null,null,null];
         this._equipmentBag = _info.Bag;
      }
      
      public function get equipmentBag() : BagInfo
      {
         return this._equipmentBag;
      }
      
      public function setSaveCells(cell:StoreCell, i:int) : void
      {
         if(this._CellsInfoArr[i] == null)
         {
            this._CellsInfoArr[i] = new Object();
         }
         this._CellsInfoArr[i].info = cell.info;
         this._CellsInfoArr[i].oldx = cell.x;
         this._CellsInfoArr[i].oldy = cell.y;
      }
      
      public function setSaveInfo(info:InventoryItemInfo, i:int) : void
      {
         this._CellsInfoArr[i].info = info;
      }
      
      public function setSavePlaceType(info:InventoryItemInfo, i:int) : void
      {
         if(info.BagType == BagInfo.EQUIPBAG || info.BagType == BagInfo.PROPBAG)
         {
            this._CellsInfoArr[i].Place = info.Place;
            this._CellsInfoArr[i].BagType = info.BagType;
         }
      }
      
      public function getSaveCells(i:int) : Object
      {
         if(Boolean(this._CellsInfoArr[i].info))
         {
            this._CellsInfoArr[i].info.Count = 1;
         }
         return this._CellsInfoArr[i];
      }
      
      public function setresultCell(obj:Object) : void
      {
         if(this._resultCell == null)
         {
            this._resultCell = new Object();
         }
         this._resultCell.point = obj.point;
         this._resultCell.place = int(obj.place);
         this._resultCell.bagType = int(obj.bagType);
         this._resultCell.cell = obj.cell;
      }
      
      public function getresultCell() : Object
      {
         return this._resultCell;
      }
      
      public function replay() : void
      {
         this._CellsInfoArr = new Array();
         this._resultCell = new Object();
      }
   }
}

