package ddt.view.sceneCharacter
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class SceneCharacterItem
   {
      
      private var _type:String;
      
      private var _groupType:String;
      
      private var _sortOrder:int;
      
      private var _source:BitmapData;
      
      private var _points:Vector.<Point>;
      
      private var _cellWitdh:Number;
      
      private var _cellHeight:Number;
      
      private var _rowNumber:int;
      
      private var _rowCellNumber:int;
      
      private var _isRepeat:Boolean;
      
      private var _repeatNumber:int;
      
      public function SceneCharacterItem(type:String, groupType:String, source:BitmapData, rowNumber:int, rowCellNumber:int, cellWitdh:Number, cellHeight:Number, sortOrder:int = 0, points:Vector.<Point> = null, isRepeat:Boolean = false, repeatNumber:int = 0)
      {
         super();
         this._type = type;
         this._groupType = groupType;
         this._source = source;
         this._rowNumber = rowNumber;
         this._rowCellNumber = rowCellNumber;
         this._cellWitdh = cellWitdh;
         this._cellHeight = cellHeight;
         this._points = points;
         this._sortOrder = sortOrder;
         this._isRepeat = isRepeat;
         this._repeatNumber = repeatNumber;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get groupType() : String
      {
         return this._groupType;
      }
      
      public function get source() : BitmapData
      {
         return this._source;
      }
      
      public function set source(value:BitmapData) : void
      {
         this._source = value;
      }
      
      public function get points() : Vector.<Point>
      {
         return this._points;
      }
      
      public function get cellWitdh() : Number
      {
         return this._cellWitdh;
      }
      
      public function get cellHeight() : Number
      {
         return this._cellHeight;
      }
      
      public function get rowNumber() : int
      {
         return this._rowNumber;
      }
      
      public function set rowNumber(value:int) : void
      {
         this._rowNumber = value;
      }
      
      public function get rowCellNumber() : int
      {
         return this._rowCellNumber;
      }
      
      public function set rowCellNumber(value:int) : void
      {
         this._rowCellNumber = value;
      }
      
      public function get sortOrder() : int
      {
         return this._sortOrder;
      }
      
      public function get isRepeat() : Boolean
      {
         return this._isRepeat;
      }
      
      public function get repeatNumber() : int
      {
         return this._repeatNumber;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._source))
         {
            this._source.dispose();
         }
         this._source = null;
         while(Boolean(this._points) && this._points.length > 0)
         {
            this._points.shift();
         }
         this._points = null;
      }
   }
}

