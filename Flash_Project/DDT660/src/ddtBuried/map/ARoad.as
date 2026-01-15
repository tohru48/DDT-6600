package ddtBuried.map
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ARoad extends Sprite
   {
      
      private var startPoint:MovieClip;
      
      private var endPoint:MovieClip;
      
      private var mapArr:Array;
      
      private var w:uint;
      
      private var h:uint;
      
      private var openList:Array = new Array();
      
      private var closeList:Array = new Array();
      
      private var roadArr:Array = new Array();
      
      private var isPath:Boolean;
      
      private var isSearch:Boolean;
      
      public function ARoad()
      {
         super();
      }
      
      public function searchRoad(start:MovieClip, end:MovieClip, map:Array) : Array
      {
         var thisPoint:MovieClip = null;
         this.startPoint = start;
         this.endPoint = end;
         this.mapArr = map;
         this.w = this.mapArr[0].length - 1;
         this.h = this.mapArr.length - 1;
         this.openList.push(this.startPoint);
         while(this.openList.length >= 1)
         {
            thisPoint = this.openList.splice(this.getMinF(),1)[0];
            if(thisPoint == this.endPoint)
            {
               while(thisPoint.father != this.startPoint.father)
               {
                  this.roadArr.push(thisPoint);
                  thisPoint = thisPoint.father;
               }
               return this.roadArr;
            }
            this.closeList.push(thisPoint);
            this.addAroundPoint(thisPoint);
         }
         return this.roadArr;
      }
      
      private function addAroundPoint(thisPoint:MovieClip) : void
      {
         var thisPx:uint = uint(thisPoint.px);
         var thisPy:uint = uint(thisPoint.py);
         if(thisPx > 0 && this.mapArr[thisPy][thisPx - 1].go == 0)
         {
            if(!this.inArr(this.mapArr[thisPy][thisPx - 1],this.closeList))
            {
               if(!this.inArr(this.mapArr[thisPy][thisPx - 1],this.openList))
               {
                  this.setGHF(this.mapArr[thisPy][thisPx - 1],thisPoint,10);
                  this.openList.push(this.mapArr[thisPy][thisPx - 1]);
               }
               else
               {
                  this.checkG(this.mapArr[thisPy][thisPx - 1],thisPoint);
               }
            }
            if(thisPy > 0 && this.mapArr[thisPy - 1][thisPx - 1].go == 0 && this.mapArr[thisPy - 1][thisPx].go == 0)
            {
               if(!this.inArr(this.mapArr[thisPy - 1][thisPx - 1],this.closeList) && !this.inArr(this.mapArr[thisPy - 1][thisPx - 1],this.openList))
               {
                  this.setGHF(this.mapArr[thisPy - 1][thisPx - 1],thisPoint,14);
                  this.openList.push(this.mapArr[thisPy - 1][thisPx - 1]);
               }
            }
            if(thisPy < this.h && this.mapArr[thisPy + 1][thisPx - 1].go == 0 && this.mapArr[thisPy + 1][thisPx].go == 0)
            {
               if(!this.inArr(this.mapArr[thisPy + 1][thisPx - 1],this.closeList) && !this.inArr(this.mapArr[thisPy + 1][thisPx - 1],this.openList))
               {
                  this.setGHF(this.mapArr[thisPy + 1][thisPx - 1],thisPoint,14);
                  this.openList.push(this.mapArr[thisPy + 1][thisPx - 1]);
               }
            }
         }
         if(thisPx < this.w && this.mapArr[thisPy][thisPx + 1].go == 0)
         {
            if(!this.inArr(this.mapArr[thisPy][thisPx + 1],this.closeList))
            {
               if(!this.inArr(this.mapArr[thisPy][thisPx + 1],this.openList))
               {
                  this.setGHF(this.mapArr[thisPy][thisPx + 1],thisPoint,10);
                  this.openList.push(this.mapArr[thisPy][thisPx + 1]);
               }
               else
               {
                  this.checkG(this.mapArr[thisPy][thisPx + 1],thisPoint);
               }
            }
            if(thisPy > 0 && this.mapArr[thisPy - 1][thisPx + 1].go == 0 && this.mapArr[thisPy - 1][thisPx].go == 0)
            {
               if(!this.inArr(this.mapArr[thisPy - 1][thisPx + 1],this.closeList) && !this.inArr(this.mapArr[thisPy - 1][thisPx + 1],this.openList))
               {
                  this.setGHF(this.mapArr[thisPy - 1][thisPx + 1],thisPoint,14);
                  this.openList.push(this.mapArr[thisPy - 1][thisPx + 1]);
               }
            }
            if(thisPy < this.h && this.mapArr[thisPy + 1][thisPx + 1].go == 0 && this.mapArr[thisPy + 1][thisPx].go == 0)
            {
               if(!this.inArr(this.mapArr[thisPy + 1][thisPx + 1],this.closeList) && !this.inArr(this.mapArr[thisPy + 1][thisPx + 1],this.openList))
               {
                  this.setGHF(this.mapArr[thisPy + 1][thisPx + 1],thisPoint,14);
                  this.openList.push(this.mapArr[thisPy + 1][thisPx + 1]);
               }
            }
         }
         if(thisPy > 0 && this.mapArr[thisPy - 1][thisPx].go == 0)
         {
            if(!this.inArr(this.mapArr[thisPy - 1][thisPx],this.closeList))
            {
               if(!this.inArr(this.mapArr[thisPy - 1][thisPx],this.openList))
               {
                  this.setGHF(this.mapArr[thisPy - 1][thisPx],thisPoint,10);
                  this.openList.push(this.mapArr[thisPy - 1][thisPx]);
               }
               else
               {
                  this.checkG(this.mapArr[thisPy - 1][thisPx],thisPoint);
               }
            }
         }
         if(thisPy < this.h && this.mapArr[thisPy + 1][thisPx].go == 0)
         {
            if(!this.inArr(this.mapArr[thisPy + 1][thisPx],this.closeList))
            {
               if(!this.inArr(this.mapArr[thisPy + 1][thisPx],this.openList))
               {
                  this.setGHF(this.mapArr[thisPy + 1][thisPx],thisPoint,10);
                  this.openList.push(this.mapArr[thisPy + 1][thisPx]);
               }
               else
               {
                  this.checkG(this.mapArr[thisPy + 1][thisPx],thisPoint);
               }
            }
         }
      }
      
      private function inArr(obj:MovieClip, arr:Array) : Boolean
      {
         var mc:* = undefined;
         for each(mc in arr)
         {
            if(obj == mc)
            {
               return true;
            }
         }
         return false;
      }
      
      private function setGHF(point:MovieClip, thisPoint:MovieClip, G:*) : void
      {
         if(!thisPoint.G)
         {
            thisPoint.G = 0;
         }
         point.G = thisPoint.G + G;
         point.H = (Math.abs(point.px - this.endPoint.px) + Math.abs(point.py - this.endPoint.py)) * 10;
         point.F = point.H + point.G;
         point.father = thisPoint;
      }
      
      private function checkG(chkPoint:MovieClip, thisPoint:MovieClip) : void
      {
         var newG:* = thisPoint.G + 10;
         if(newG <= chkPoint.G)
         {
            chkPoint.G = newG;
            chkPoint.F = chkPoint.H + newG;
            chkPoint.father = thisPoint;
         }
      }
      
      private function getMinF() : uint
      {
         var rid:uint = 0;
         var mc:* = undefined;
         var tmpF:uint = 100000000;
         var id:uint = 0;
         for each(mc in this.openList)
         {
            if(mc.F < tmpF)
            {
               tmpF = uint(mc.F);
               rid = id;
            }
            id++;
         }
         return rid;
      }
   }
}

