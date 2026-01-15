package ddt.view.sceneCharacter
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SceneCharacterSynthesis
   {
      
      private var _sceneCharacterSet:SceneCharacterSet;
      
      private var _frameBitmap:Vector.<Bitmap> = new Vector.<Bitmap>();
      
      private var _callBack:Function;
      
      public function SceneCharacterSynthesis(sceneCharacterSet:SceneCharacterSet, callBack:Function)
      {
         super();
         this._sceneCharacterSet = sceneCharacterSet;
         this._callBack = callBack;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.characterSynthesis();
      }
      
      private function characterSynthesis() : void
      {
         var sceneCharacterItem:SceneCharacterItem = null;
         var sceneCharacterItemGroup:SceneCharacterItem = null;
         var bmp:BitmapData = null;
         var i:int = 0;
         var bmp2:BitmapData = null;
         var row:int = 0;
         var cellCount:int = 0;
         var j:int = 0;
         var sourcePoint:Point = null;
         var matrix:Matrix = new Matrix();
         var point:Point = new Point(0,0);
         var rectangle:Rectangle = new Rectangle();
         for each(sceneCharacterItem in this._sceneCharacterSet.dataSet)
         {
            if(sceneCharacterItem.isRepeat)
            {
               bmp = new BitmapData(sceneCharacterItem.source.width * sceneCharacterItem.repeatNumber,sceneCharacterItem.source.height,true,0);
               for(i = 0; i < sceneCharacterItem.repeatNumber; i++)
               {
                  matrix.tx = sceneCharacterItem.source.width * i;
                  bmp.draw(sceneCharacterItem.source,matrix);
               }
               sceneCharacterItem.source.dispose();
               sceneCharacterItem.source = null;
               sceneCharacterItem.source = new BitmapData(bmp.width,bmp.height,true,0);
               sceneCharacterItem.source.draw(bmp);
               bmp.dispose();
               bmp = null;
            }
            if(Boolean(sceneCharacterItem.points) && sceneCharacterItem.points.length > 0)
            {
               bmp2 = new BitmapData(sceneCharacterItem.source.width,sceneCharacterItem.source.height,true,0);
               bmp2.draw(sceneCharacterItem.source);
               sceneCharacterItem.source.dispose();
               sceneCharacterItem.source = null;
               sceneCharacterItem.source = new BitmapData(bmp2.width,bmp2.height,true,0);
               rectangle.width = sceneCharacterItem.cellWitdh;
               rectangle.height = sceneCharacterItem.cellHeight;
               for(row = 0; row < sceneCharacterItem.rowNumber; row++)
               {
                  cellCount = sceneCharacterItem.isRepeat ? sceneCharacterItem.repeatNumber : sceneCharacterItem.rowCellNumber;
                  for(j = 0; j < cellCount; j++)
                  {
                     sourcePoint = sceneCharacterItem.points[row * cellCount + j];
                     if(Boolean(sourcePoint))
                     {
                        point.x = sceneCharacterItem.cellWitdh * j + sourcePoint.x;
                        point.y = sceneCharacterItem.cellHeight * row + sourcePoint.y;
                        rectangle.x = sceneCharacterItem.cellWitdh * j;
                        rectangle.y = sceneCharacterItem.cellHeight * row;
                        sceneCharacterItem.source.copyPixels(bmp2,rectangle,point);
                     }
                     else
                     {
                        point.x = rectangle.x = sceneCharacterItem.cellWitdh * j;
                        point.y = rectangle.y = sceneCharacterItem.cellHeight * row;
                        sceneCharacterItem.source.copyPixels(bmp2,rectangle,point);
                     }
                  }
               }
               bmp2.dispose();
               bmp2 = null;
            }
         }
         for each(sceneCharacterItemGroup in this._sceneCharacterSet.dataSet)
         {
            this.characterGroupDraw(sceneCharacterItemGroup);
         }
         this.characterDraw();
      }
      
      private function characterGroupDraw(sceneCharacterItem:SceneCharacterItem) : void
      {
         for(var i:int = 0; i < this._sceneCharacterSet.dataSet.length; i++)
         {
            if(sceneCharacterItem.groupType == this._sceneCharacterSet.dataSet[i].groupType && this._sceneCharacterSet.dataSet[i].type != sceneCharacterItem.type)
            {
               sceneCharacterItem.source.draw(this._sceneCharacterSet.dataSet[i].source);
               sceneCharacterItem.rowNumber = this._sceneCharacterSet.dataSet[i].rowNumber > sceneCharacterItem.rowNumber ? this._sceneCharacterSet.dataSet[i].rowNumber : sceneCharacterItem.rowNumber;
               sceneCharacterItem.rowCellNumber = this._sceneCharacterSet.dataSet[i].rowCellNumber > sceneCharacterItem.rowCellNumber ? this._sceneCharacterSet.dataSet[i].rowCellNumber : sceneCharacterItem.rowCellNumber;
               this._sceneCharacterSet.dataSet.splice(this._sceneCharacterSet.dataSet.indexOf(this._sceneCharacterSet.dataSet[i]),1);
               i--;
            }
         }
      }
      
      private function characterDraw() : void
      {
         var bmp:BitmapData = null;
         var sceneCharacterItem:SceneCharacterItem = null;
         var row:int = 0;
         var i:int = 0;
         for each(sceneCharacterItem in this._sceneCharacterSet.dataSet)
         {
            for(row = 0; row < sceneCharacterItem.rowNumber; row++)
            {
               for(i = 0; i < sceneCharacterItem.rowCellNumber; i++)
               {
                  bmp = new BitmapData(sceneCharacterItem.cellWitdh,sceneCharacterItem.cellHeight,true,0);
                  bmp.copyPixels(sceneCharacterItem.source,new Rectangle(i * sceneCharacterItem.cellWitdh,sceneCharacterItem.cellHeight * row,sceneCharacterItem.cellWitdh,sceneCharacterItem.cellHeight),new Point(0,0));
                  this._frameBitmap.push(new Bitmap(bmp));
               }
            }
         }
         if(this._callBack != null)
         {
            this._callBack(this._frameBitmap);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._sceneCharacterSet))
         {
            this._sceneCharacterSet.dispose();
         }
         this._sceneCharacterSet = null;
         while(Boolean(this._frameBitmap) && this._frameBitmap.length > 0)
         {
            this._frameBitmap[0].bitmapData.dispose();
            this._frameBitmap[0].bitmapData = null;
            this._frameBitmap.shift();
         }
         this._frameBitmap = null;
         this._callBack = null;
      }
   }
}

