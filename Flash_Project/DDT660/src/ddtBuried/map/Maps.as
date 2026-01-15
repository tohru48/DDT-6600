package ddtBuried.map
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import ddtBuried.role.BuriedPlayer;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   
   public class Maps extends Sprite
   {
      
      private var w:uint;
      
      private var h:uint;
      
      private var wh:uint;
      
      private var goo:Number;
      
      private var map:Sprite;
      
      private var mapArr:Array;
      
      private var roadMen:MovieClip;
      
      private var roadList:Array;
      
      private var roadTimer:Timer;
      
      private var timer_i:uint = 0;
      
      private var mapDataArray:Array;
      
      private var role:BuriedPlayer;
      
      public function Maps($arr:Array, $w:int, $h:int)
      {
         super();
         this.w = $w;
         this.h = $h;
         this.wh = 55;
         this.mapDataArray = $arr;
         this.init();
      }
      
      private function init() : void
      {
         this.goo = 0.3;
         this.createMaps();
         this.roadMens();
         this.roadTimer = new Timer(300,0);
      }
      
      public function startMove(xpos:int, ypos:int) : void
      {
         var _ARoad:ARoad = null;
         var mc:* = undefined;
         var endX:int = xpos;
         var endY:int = ypos;
         var endPoint:* = this.mapArr[endY][endX];
         if(endPoint.go == 0)
         {
            if(Boolean(this.roadList))
            {
               for each(mc in this.roadList)
               {
                  mc.alpha = 1;
               }
               this.roadList = [];
            }
            this.roadTimer.stop();
            this.roadMen.px = Math.floor(this.roadMen.x / this.wh);
            this.roadMen.py = Math.floor(this.roadMen.y / this.wh);
            _ARoad = new ARoad();
            this.roadList = _ARoad.searchRoad(this.roadMen,endPoint,this.mapArr);
            if(this.roadList.length > 0)
            {
               this.MC_play(this.roadList);
            }
         }
      }
      
      private function MC_play(roadList:Array) : void
      {
         var mc:* = undefined;
         roadList.reverse();
         this.roadTimer.stop();
         this.timer_i = 0;
         this.roadTimer.addEventListener(TimerEvent.TIMER,this.goMap);
         this.roadTimer.start();
         for each(mc in roadList)
         {
            mc.alpha = 0.3;
         }
      }
      
      private function goMap(evt:TimerEvent) : void
      {
         var tmpMC:MovieClip = null;
         tmpMC = this.roadList[this.timer_i];
         this.roadMen.x = tmpMC.x;
         this.roadMen.y = tmpMC.y;
         tmpMC.alpha = 1;
         ++this.timer_i;
         if(this.timer_i >= this.roadList.length)
         {
            this.roadTimer.stop();
            if(BuriedManager.Instance.isOver)
            {
               BuriedManager.Instance.isOver = false;
               BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.MAPOVER));
            }
            else
            {
               BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.WALKOVER));
            }
         }
      }
      
      private function createMaps() : void
      {
         var x:uint = 0;
         var mapPoint:uint = 0;
         var point:MovieClip = null;
         this.mapArr = new Array();
         this.map = new Sprite();
         this.map.x = this.wh;
         this.map.y = this.wh;
         addChild(this.map);
         for(var y:uint = 0; y < this.h; y++)
         {
            this.mapArr.push(new Array());
            for(x = 0; x < this.w; x++)
            {
               mapPoint = uint(this.mapDataArray[y][x]);
               point = this.drawRect(mapPoint);
               this.mapArr[y].push(point);
               this.mapArr[y][x].px = x;
               this.mapArr[y][x].py = y;
               this.mapArr[y][x].go = mapPoint;
               this.mapArr[y][x].x = x * this.wh;
               this.mapArr[y][x].y = y * this.wh;
               this.map.addChild(this.mapArr[y][x]);
            }
         }
         this.map.rotationX = -30;
         this.map.scaleX = 1.4;
         this.map.scaleY = 0.8;
      }
      
      private function clearMaps() : void
      {
         var x:uint = 0;
         var mc:MovieClip = null;
         for(var y:uint = 0; y < this.h; y++)
         {
            for(x = 0; x < this.w; x++)
            {
               mc = this.mapArr[y][x];
               while(Boolean(mc.numChildren))
               {
                  ObjectUtils.disposeObject(mc.removeChildAt(0));
               }
               ObjectUtils.disposeObject(this.mapArr[y][x]);
            }
         }
      }
      
      public function getMapArray() : Array
      {
         return this.mapArr;
      }
      
      private function keyDowns(evt:KeyboardEvent) : void
      {
         var _key:int = int(evt.keyCode);
         if(_key == Keyboard.SPACE)
         {
            removeChild(this.map);
            this.mapArr = [];
            this.createMaps();
            this.roadMens();
            this.roadTimer.stop();
         }
      }
      
      private function drawRect(mapPoint:uint) : MovieClip
      {
         var bitMap:Bitmap = null;
         var _tmp:MovieClip = new MovieClip();
         switch(mapPoint)
         {
            case 0:
               bitMap = ComponentFactory.Instance.creat("buried.shaizi.mapItemBack");
               bitMap.smoothing = true;
               bitMap.width = 56;
               bitMap.height = 56;
               _tmp.addChild(bitMap);
               return _tmp;
            case 1:
               return _tmp;
            default:
               return _tmp;
         }
      }
      
      private function roleCallback(role:BuriedPlayer, isLoadSucceed:Boolean) : void
      {
         if(!role)
         {
            return;
         }
         role.sceneCharacterStateType = "natural";
         role.update();
      }
      
      private function roadMens() : void
      {
         this.roadMen = this.drawRect(2);
         var _tmpx:uint = Math.round(Math.random() * (this.w - 1));
         var _tmpy:uint = Math.round(Math.random() * (this.h - 1));
         this.map.addChild(this.roadMen);
      }
      
      public function setRoadMan(px:int, py:int) : void
      {
         this.roadMen.px = px;
         this.roadMen.py = py;
         this.roadMen.x = px * this.wh;
         this.roadMen.y = py * this.wh;
         this.mapArr[py][px].go = 0;
      }
      
      public function dispose() : void
      {
         this.clearMaps();
         this.mapArr = [];
         this.roadTimer.stop();
         this.roadTimer.removeEventListener(TimerEvent.TIMER,this.goMap);
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this.roadTimer = null;
      }
   }
}

