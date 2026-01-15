package game.view.smallMap
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.MissionInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.animations.DragMapAnimation;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.objects.GamePlayer;
   import game.view.map.MapView;
   import phy.object.SmallObject;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class SmallMapView extends Sprite implements Disposeable
   {
      
      private static const NUMBERS_ARR:Array = ["tank.game.smallmap.ShineNumber1","tank.game.smallmap.ShineNumber2","tank.game.smallmap.ShineNumber3","tank.game.smallmap.ShineNumber4","tank.game.smallmap.ShineNumber5","tank.game.smallmap.ShineNumber6","tank.game.smallmap.ShineNumber7","tank.game.smallmap.ShineNumber8","tank.game.smallmap.ShineNumber9"];
      
      public static var MAX_WIDTH:int = 165;
      
      public static var MIN_WIDTH:int = 120;
      
      public static const HARD_LEVEL:Array = [LanguageMgr.GetTranslation("tank.game.smallmap.simple"),LanguageMgr.GetTranslation("tank.game.smallmap.normal"),LanguageMgr.GetTranslation("tank.game.smallmap.difficulty"),LanguageMgr.GetTranslation("tank.game.smallmap.hero"),LanguageMgr.GetTranslation("ddt.dungeonRoom.level4")];
      
      public static const HARD_LEVEL1:Array = [LanguageMgr.GetTranslation("tank.game.smallmap.simple1"),LanguageMgr.GetTranslation("tank.game.smallmap.normal1"),LanguageMgr.GetTranslation("tank.game.smallmap.difficulty1"),LanguageMgr.GetTranslation("tank.game.smallmap.difficulty2")];
      
      public static const STAR_HARD_LEVEL:Array = LanguageMgr.GetTranslation("cryptBoss.setFrame.hardLevelTxt").split(",");
      
      private var _screen:Sprite;
      
      private var _foreMap:Sprite;
      
      private var _thingLayer:Sprite;
      
      private var _mapBorder:Sprite;
      
      private var _hardTxt:FilterFrameText;
      
      private var _line:Sprite;
      
      private var _smallMapContainerBg:Sprite;
      
      private var _mask:Shape;
      
      private var _foreMapMask:Shape;
      
      private var _changeScale:Number = 0.2;
      
      private var _locked:Boolean;
      
      private var _allowDrag:Boolean = true;
      
      private var _split:Sprite;
      
      private var _texts:Array;
      
      private var _screenMask:Sprite;
      
      private var _processer:ThingProcesser;
      
      private var _drawMatrix:Matrix = new Matrix();
      
      private var _lineRef:BitmapData;
      
      private var _foreground:Shape;
      
      private var _dragScreen:Sprite;
      
      private var _titleBar:SmallMapTitleBar;
      
      private var _Screen_X:int;
      
      private var _Screen_Y:int;
      
      private var _mapBmp:Bitmap;
      
      private var _mapDeadBmp:Bitmap;
      
      private var _rateX:Number;
      
      private var _map:MapView;
      
      private var _rateY:Number;
      
      private var _missionInfo:MissionInfo;
      
      private var _w:int;
      
      private var _h:int;
      
      private var _groundShape:Sprite;
      
      private var _beadShape:Shape;
      
      private var _startDrag:Boolean = false;
      
      private var _wRatio:Number;
      
      private var _hRatio:Number;
      
      private var _child:Dictionary = new Dictionary();
      
      private var _update:Boolean;
      
      private var _allLivings:DictionaryData;
      
      private var _collideRect:Rectangle = new Rectangle(-45,-30,100,80);
      
      private var _drawRoute:Sprite;
      
      public function SmallMapView(map:MapView, info:MissionInfo)
      {
         super();
         this._map = map;
         this._missionInfo = info;
         this._processer = new ThingProcesser();
         this.initView();
         this.initEvent();
      }
      
      public function set locked(value:Boolean) : void
      {
         this._locked = value;
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set allowDrag(value:Boolean) : void
      {
         this._allowDrag = value;
         if(!this._allowDrag)
         {
            this.__mouseUp(null);
         }
         this._screen.mouseChildren = this._screen.mouseEnabled = this._allowDrag;
      }
      
      public function get rateX() : Number
      {
         return this._rateX;
      }
      
      public function get rateY() : Number
      {
         return this._rateY;
      }
      
      public function get smallMapW() : Number
      {
         return this._mask.width;
      }
      
      public function get smallMapH() : Number
      {
         return this._mask.height;
      }
      
      public function setHardLevel(value:int, type:int = 0) : void
      {
         if(type == 0)
         {
            this._titleBar.title = HARD_LEVEL[value];
         }
         else
         {
            this._titleBar.title = HARD_LEVEL1[value];
         }
      }
      
      public function setBarrier(val:int, max:int) : void
      {
         this._titleBar.setBarrier(val,max);
      }
      
      private function initView() : void
      {
         this._drawMatrix.a = this._drawMatrix.d = 96 / this._map.bound.height;
         this._w = this._drawMatrix.a * this._map.bound.width;
         this._h = this._drawMatrix.d * this._map.bound.height;
         if(this._w > 240)
         {
            this._w = 240;
            this._drawMatrix.a = this._drawMatrix.d = 240 / this._map.bound.width;
            this._h = this._drawMatrix.d * this._map.bound.height;
         }
         else
         {
            this._drawMatrix.a = this._drawMatrix.d = 104 / this._map.bound.height;
            this._w = this._drawMatrix.a * this._map.bound.width;
            this._h = this._drawMatrix.d * this._map.bound.height;
            if(this._w > 240)
            {
               this._w = 240;
               this._drawMatrix.a = this._drawMatrix.d = 240 / this._map.bound.width;
               this._h = this._drawMatrix.d * this._map.bound.height;
            }
         }
         if(PathManager.dottelineEnable)
         {
            this._w = 120;
            this._h = 100;
            this._wRatio = 1 - int(Math.random() * 5) / 10;
            this._hRatio = 1 - int(Math.random() * 5) / 10;
            this._drawMatrix.d = this._h / this._map.bound.height;
            this._drawMatrix.a = this._w / this._map.bound.width;
         }
         this._groundShape = new Sprite();
         addChild(this._groundShape);
         this._beadShape = new Shape();
         addChild(this._beadShape);
         if(!PathManager.smallMapAlpha())
         {
            this._screen = new DragScreen(StageReferance.stageWidth * this._drawMatrix.a,StageReferance.stageHeight * this._drawMatrix.d - 4);
         }
         else
         {
            this._screen = new DragScreen(StageReferance.stageWidth * this._drawMatrix.a,StageReferance.stageHeight * this._drawMatrix.d);
         }
         if(PathManager.dottelineEnable)
         {
            this._screen = new DragScreen(StageReferance.stageWidth * this._drawMatrix.a * this._wRatio,StageReferance.stageHeight * this._drawMatrix.d * this._hRatio);
         }
         addChild(this._screen);
         this._thingLayer = new Sprite();
         this._thingLayer.mouseChildren = this._thingLayer.mouseEnabled = false;
         addChild(this._thingLayer);
         this._foreground = new Shape();
         addChild(this._foreground);
         this._titleBar = new SmallMapTitleBar(this._missionInfo);
         this._titleBar.width = this._w;
         this._titleBar.y = -this._titleBar.height + 1;
         y = this._titleBar.height;
         if(RoomManager.Instance.current.canShowTitle())
         {
            if(!RoomManager.Instance.isTransnationalFight())
            {
               this._titleBar.title = HARD_LEVEL[RoomManager.Instance.current.hardLevel];
            }
            if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BATTLE)
            {
               this._titleBar.title = LanguageMgr.GetTranslation("ddt.game.consortiaBattle.txt");
            }
            else if(RoomManager.Instance.current.type == RoomInfo.RING_STATION)
            {
               this._titleBar.title = LanguageMgr.GetTranslation("ddt.ringstation.titleInfo");
            }
            else if(RoomManager.Instance.current.type == RoomInfo.CRYPTBOSS_ROOM)
            {
               this._titleBar.title = STAR_HARD_LEVEL[RoomManager.Instance.current.hardLevel];
            }
            else
            {
               this._titleBar.title = HARD_LEVEL[RoomManager.Instance.current.hardLevel];
            }
         }
         addChild(this._titleBar);
         this._lineRef = ComponentFactory.Instance.creatBitmapData("asset.game.lineAsset");
         this._allLivings = GameManager.Instance.Current.livings;
         this.drawBackground();
         this.drawForeground();
         this.updateSpliter();
         this._drawRoute = new Sprite();
         addChild(this._drawRoute);
      }
      
      public function get __StartDrag() : Boolean
      {
         return this._startDrag;
      }
      
      private function drawBackground() : void
      {
         var g:Graphics = graphics;
         g.clear();
         g.beginBitmapFill(this._lineRef);
         g.drawRect(0,0,this._w,this._h);
         g.endFill();
         this._thingLayer.scrollRect = new Rectangle(0,0,this._w,this._h);
         g = this._thingLayer.graphics;
         g.clear();
         g.beginFill(0,0);
         g.drawRect(0,0,this._w,this._h);
         g.endFill();
      }
      
      private function drawForeground() : void
      {
         var pen:Graphics = null;
         if(PathManager.smallMapBorderEnable())
         {
            pen = this._foreground.graphics;
            pen.clear();
            pen.lineStyle(1,6710886);
            pen.beginFill(0,0);
            pen.drawRect(0,0,this._w,this._h);
            pen.endFill();
         }
      }
      
      public function get foreMap() : Sprite
      {
         return this;
      }
      
      private function initViewAsset() : void
      {
      }
      
      private function updateSpliter() : void
      {
         var round:MovieClip = null;
         if(this._split == null)
         {
            return;
         }
         while(this._split.numChildren > 0)
         {
            this._split.removeChildAt(0);
         }
         this._texts = [];
         var perW:Number = this._screen.width / 10;
         this._split.graphics.clear();
         this._split.graphics.lineStyle(1,16777215,1);
         for(var i:int = 1; i < 10; i++)
         {
            this._split.graphics.moveTo(perW * i,0);
            this._split.graphics.lineTo(perW * i,this._screen.height);
            round = ClassUtils.CreatInstance(NUMBERS_ARR[i - 1]);
            round.x = perW * i;
            round.y = (this._screen.height - round.height) / 2;
            round.stop();
            this._split.addChild(round);
            this._texts.push(round);
         }
         this._split.graphics.endFill();
      }
      
      public function ShineText(value:int) : void
      {
         this.large();
         this.drawMask();
         for(var i:int = 0; i < value; i++)
         {
            setTimeout(this.shineText,i * 1500,i);
         }
      }
      
      private function drawMask() : void
      {
         var bounds:Rectangle = null;
         var hole:Sprite = null;
         if(this._screenMask == null)
         {
            bounds = getBounds(parent);
            this._screenMask = new Sprite();
            this._screenMask.graphics.beginFill(0,0.8);
            this._screenMask.graphics.drawRect(0,0,StageReferance.stageWidth,StageReferance.stageHeight);
            this._screenMask.graphics.endFill();
            this._screenMask.blendMode = BlendMode.LAYER;
            hole = new Sprite();
            hole.graphics.beginFill(0,1);
            hole.graphics.drawRect(0,0,bounds.width,bounds.height);
            hole.graphics.endFill();
            hole.x = this.x;
            hole.y = bounds.top;
            hole.blendMode = BlendMode.ERASE;
            this._screenMask.addChild(hole);
         }
         LayerManager.Instance.addToLayer(this._screenMask,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      private function clearMask() : void
      {
         if(Boolean(this._screenMask) && Boolean(this._screenMask.parent))
         {
            this._screenMask.parent.removeChild(this._screenMask);
         }
      }
      
      private function large() : void
      {
         scaleY = 3;
         scaleX = 3;
         x = StageReferance.stageWidth - width >> 1;
         y = StageReferance.stageHeight - height >> 1;
      }
      
      public function restore() : void
      {
         scaleY = 1;
         scaleX = 1;
         x = StageReferance.stageWidth - width - 1;
         y = this._titleBar.height;
         this.clearMask();
      }
      
      public function restoreText() : void
      {
         var round:MovieClip = null;
         for each(round in this._texts)
         {
            round.gotoAndStop(1);
         }
      }
      
      private function shineText(i:int) : void
      {
         this.restoreText();
         if(this._split == null)
         {
            this._split = new Sprite();
            this._split.mouseEnabled = false;
            this._split.mouseChildren = false;
            addChild(this._split);
            this.updateSpliter();
         }
         if(i > 4)
         {
            (this._texts[4] as MovieClip).play();
         }
         else
         {
            (this._texts[i] as MovieClip).play();
         }
      }
      
      public function showSpliter() : void
      {
         if(this._split == null)
         {
            this._split = new Sprite();
            this._split.mouseEnabled = false;
            this._split.mouseChildren = false;
            addChild(this._split);
            this.updateSpliter();
         }
         this._split.visible = true;
      }
      
      public function hideSpliter() : void
      {
         if(this._split != null)
         {
            this._split.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         this._groundShape.addEventListener(MouseEvent.MOUSE_DOWN,this.__click);
         this._screen.addEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
      }
      
      private function removeEvents() : void
      {
         this._groundShape.removeEventListener(MouseEvent.MOUSE_DOWN,this.__click);
         this._screen.removeEventListener(MouseEvent.MOUSE_DOWN,this.__mouseDown);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
      }
      
      private function __mouseDown(evt:MouseEvent) : void
      {
         this._Screen_X = this._screen.x;
         this._Screen_Y = this._screen.y;
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         var dragBounds:Rectangle = getBounds(this);
         dragBounds.top = 0;
         dragBounds.right -= this._screen.width;
         dragBounds.bottom -= this._screen.height;
         this._screen.startDrag(false,dragBounds);
         this._startDrag = true;
      }
      
      private function __mouseUp(evt:MouseEvent) : void
      {
         this._startDrag = false;
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__mouseUp);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.__mouseMove);
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         this._screen.stopDrag();
      }
      
      public function get screen() : Sprite
      {
         return this._screen;
      }
      
      public function get screenX() : int
      {
         return this._Screen_X;
      }
      
      public function get screenY() : int
      {
         return this._Screen_Y;
      }
      
      private function __mouseMove(evt:MouseEvent) : void
      {
      }
      
      private function __onEnterFrame(evt:Event) : void
      {
         var tx:Number = NaN;
         var ty:Number = NaN;
         if(this._startDrag)
         {
            tx = (this._screen.x + this._screen.width / 2) / this._drawMatrix.a;
            ty = (this._screen.y + this._screen.height / 2) / this._drawMatrix.d;
            if(PathManager.dottelineEnable)
            {
               tx = (this._screen.x + this._screen.width / this._wRatio / 2) / this._drawMatrix.a;
               ty = (this._screen.y + this._screen.height / this._hRatio / 2) / this._drawMatrix.d;
            }
            this._map.animateSet.addAnimation(new DragMapAnimation(tx,ty,true));
            if(Boolean(this._split))
            {
               this._split.x = this._screen.x;
               this._split.y = this._screen.y;
            }
         }
      }
      
      public function update() : void
      {
         this.draw(true);
         this.drawDead(true);
         this.updateSpliter();
         if(this._split != null)
         {
            this._split.x = this._screen.x;
            this._split.y = this._screen.y;
         }
      }
      
      private function drawDead(mustDraw:Boolean = false) : void
      {
         if(!this._map.mapChanged && !mustDraw)
         {
            return;
         }
         if(!this._map.stone)
         {
            return;
         }
         var pen:Graphics = this._beadShape.graphics;
         pen.clear();
         pen.beginBitmapFill(this._map.stone.bitmapData,this._drawMatrix,false,true);
         pen.drawRect(0,0,this._w,this._h);
         pen.endFill();
      }
      
      public function draw(mustDraw:Boolean = false) : void
      {
         if(!this._map.mapChanged && !mustDraw)
         {
            return;
         }
         var pen:Graphics = this._groundShape.graphics;
         pen.clear();
         if(!this._map.ground)
         {
            pen.beginFill(0,0);
         }
         else
         {
            pen.beginBitmapFill(this._map.ground.bitmapData,this._drawMatrix,false,true);
         }
         pen.drawRect(0,0,this._w,this._h);
         pen.endFill();
      }
      
      public function setScreenPos(posX:Number, posY:Number) : void
      {
         var newX:Number = NaN;
         var newY:Number = NaN;
         var bounds:Rectangle = null;
         if(!this._locked && !this._startDrag)
         {
            newX = Math.abs(posX * this._drawMatrix.a);
            newY = Math.abs(posY * this._drawMatrix.d);
            bounds = this._screen.getBounds(this);
            if(PathManager.dottelineEnable)
            {
               newX = Math.abs(posX * this._drawMatrix.a / this._wRatio);
               newY = Math.abs(posY * this._drawMatrix.d / this._hRatio);
            }
            if(newX + this._screen.width >= this._w)
            {
               this._screen.x = this._w - this._screen.width;
            }
            else if(newX < 0)
            {
               this._screen.x = 0;
            }
            else
            {
               this._screen.x = newX;
            }
            if(newY + this._screen.height >= this._h)
            {
               this._screen.y = this._h - this._screen.height;
            }
            else if(newY < 0)
            {
               this._screen.y = 0;
            }
            else
            {
               this._screen.y = newY;
            }
            if(this._split != null)
            {
               this._split.x = this._screen.x;
               this._split.y = this._screen.y;
            }
         }
      }
      
      public function addObj(object:SmallObject) : void
      {
         if(!object.onProcess)
         {
            this.addAnimation(object);
         }
         this._thingLayer.addChild(object);
      }
      
      public function removeObj(object:SmallObject) : void
      {
         if(object.parent == this._thingLayer)
         {
            this._thingLayer.removeChild(object);
            if(object.onProcess)
            {
               this.removeAnimation(object);
            }
         }
      }
      
      public function updatePos(object:SmallObject, pos:Point) : void
      {
         if(object == null)
         {
            return;
         }
         object.x = pos.x * this._drawMatrix.a;
         object.y = pos.y * this._drawMatrix.d;
         this._thingLayer.addChild(object);
      }
      
      public function addAnimation(object:SmallObject) : void
      {
         this._processer.addThing(object);
      }
      
      public function removeAnimation(object:SmallObject) : void
      {
         this._processer.removeThing(object);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._missionInfo = null;
         if(Boolean(this._titleBar))
         {
            ObjectUtils.disposeObject(this._titleBar);
            this._titleBar = null;
         }
         if(Boolean(this._mapBmp))
         {
            if(Boolean(this._mapBmp.parent))
            {
               this._mapBmp.parent.removeChild(this._mapBmp);
            }
            if(Boolean(this._mapBmp.bitmapData))
            {
               this._mapBmp.bitmapData.dispose();
            }
         }
         this._mapBmp = null;
         if(Boolean(this._mapDeadBmp))
         {
            if(Boolean(this._mapDeadBmp.parent))
            {
               this._mapDeadBmp.parent.removeChild(this._mapDeadBmp);
            }
            if(Boolean(this._mapDeadBmp.bitmapData))
            {
               this._mapDeadBmp.bitmapData.dispose();
            }
         }
         this._mapDeadBmp = null;
         if(Boolean(this._line))
         {
            ObjectUtils.disposeAllChildren(this._line);
            if(Boolean(this._line.parent))
            {
               this._line.parent.removeChild(this._line);
            }
            this._line = null;
         }
         if(Boolean(this._screen))
         {
            ObjectUtils.disposeAllChildren(this._screen);
            if(Boolean(this._screen.parent))
            {
               this._screen.parent.removeChild(this._screen);
            }
            this._screen = null;
         }
         if(Boolean(this._smallMapContainerBg))
         {
            ObjectUtils.disposeAllChildren(this._smallMapContainerBg);
            if(Boolean(this._smallMapContainerBg.parent))
            {
               this._smallMapContainerBg.parent.removeChild(this._smallMapContainerBg);
            }
            this._smallMapContainerBg = null;
         }
         if(Boolean(this._split))
         {
            ObjectUtils.disposeAllChildren(this._split);
            if(Boolean(this._split))
            {
               this._split.parent.removeChild(this._split);
            }
            this._split = null;
         }
         if(Boolean(this._mapBorder))
         {
            ObjectUtils.disposeAllChildren(this._mapBorder);
            if(Boolean(this._mapBorder.parent))
            {
               this._mapBorder.parent.removeChild(this._mapBorder);
            }
            this._mapBorder = null;
         }
         if(Boolean(this._map.parent))
         {
            this._map.parent.removeChild(this._map);
         }
         this._map = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._lineRef))
         {
            this._lineRef.dispose();
            this._lineRef = null;
         }
         this._processer.dispose();
         this._processer = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function __largeMap(event:MouseEvent) : void
      {
         this._changeScale = 0.2;
         var oldRateX:Number = this._rateX;
         var oldRateY:Number = this._rateY;
         this.update();
         this.updateChildPos(oldRateX,oldRateY);
         SoundManager.instance.play("008");
      }
      
      private function __smallMap(event:MouseEvent) : void
      {
         this._changeScale = -0.2;
         var oldRateX:Number = this._rateX;
         var oldRateY:Number = this._rateY;
         this.update();
         this.updateChildPos(oldRateX,oldRateY);
         SoundManager.instance.play("008");
      }
      
      private function updateChildPos(oldRateX:Number, oldRateY:Number) : void
      {
         var c:Sprite = null;
         for each(c in this._child)
         {
            c.x = c.x / oldRateX * this._rateX;
            c.y = c.y / oldRateY * this._rateY;
         }
      }
      
      private function __click(event:MouseEvent) : void
      {
         if(!this._locked && this._allowDrag)
         {
            this._map.animateSet.addAnimation(new DragMapAnimation(event.localX / this._drawMatrix.a,event.localY / this._drawMatrix.d));
         }
      }
      
      private function __enterFrame(event:Event) : void
      {
         var tx:Number = (this._screen.x + this._screen.width / 2) / this._rateX;
         var ty:Number = (this._screen.y + this._screen.height / 2) / this._rateY;
         if(this._split != null)
         {
            this._split.x = this._screen.x;
            this._split.y = this._screen.y;
         }
         this._map.animateSet.addAnimation(new DragMapAnimation(tx,ty,true));
      }
      
      public function moveToPlayer() : void
      {
         var player:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
         var tx:Number = player.pos.x;
         var ty:Number = (this._screen.y + this._screen.height / 2) / this._drawMatrix.d;
         this._map.animateSet.addAnimation(new DragMapAnimation(tx,ty,true));
      }
      
      public function get titleBar() : SmallMapTitleBar
      {
         return this._titleBar;
      }
      
      public function set enableExit(b:Boolean) : void
      {
         this._titleBar.enableExit = b;
      }
      
      public function drawRouteLine(id:int) : void
      {
         var liv:Living = null;
         this._drawRoute.graphics.clear();
         for each(liv in this._allLivings)
         {
            liv.currentSelectId = id;
         }
         if(id < 0)
         {
            return;
         }
         var player:Player = GameManager.Instance.Current.findPlayer(id);
         if(!player)
         {
            return;
         }
         var data:Vector.<Point> = player.route;
         if(!data || data.length == 0)
         {
            return;
         }
         var enemyLiving:GamePlayer = this._map.getPhysical(id) as GamePlayer;
         this._collideRect.x = enemyLiving.pos.x * this._drawMatrix.a - 50 * this._drawMatrix.a;
         this._collideRect.y = enemyLiving.pos.y * this._drawMatrix.d - 50 * this._drawMatrix.d;
         this._drawRoute.graphics.lineStyle(1,16711680,1);
         var length:int = int(data.length);
         for(var i:int = 0; i < length - 1; i++)
         {
            this.drawDashed(this._drawRoute.graphics,data[i],data[i + 1],8,5);
         }
      }
      
      private function drawDashed(graphics:Graphics, beginPoint:Point, endPoint:Point, width:Number, grap:Number) : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         if(!graphics || !beginPoint || !endPoint || width <= 0 || grap <= 0)
         {
            return;
         }
         var Ox:Number = beginPoint.x * this._drawMatrix.a;
         var Oy:Number = beginPoint.y * this._drawMatrix.d;
         var radian:Number = Math.atan2(endPoint.y * this._drawMatrix.d - Oy,endPoint.x * this._drawMatrix.a - Ox);
         var currLen:Number = 0;
         while(currLen <= 0.5)
         {
            if(this._collideRect.contains(x,y))
            {
               return;
            }
            x = Ox + Math.cos(radian) * currLen;
            y = Oy + Math.sin(radian) * currLen;
            graphics.moveTo(x,y);
            currLen += width;
            if(currLen > 0.5)
            {
               currLen = 0.5;
            }
            x = Ox + Math.cos(radian) * currLen;
            y = Oy + Math.sin(radian) * currLen;
            graphics.lineTo(x,y);
            currLen += grap;
         }
      }
   }
}

import com.pickgliss.toplevel.StageReferance;
import flash.events.Event;
import flash.utils.getTimer;
import phy.object.SmallObject;

class ThingProcesser
{
   
   private var _objectList:Vector.<SmallObject> = new Vector.<SmallObject>();
   
   private var _startuped:Boolean = false;
   
   private var _lastTime:int = 0;
   
   public function ThingProcesser()
   {
      super();
   }
   
   public function addThing(object:SmallObject) : void
   {
      if(!object.onProcess)
      {
         this._objectList.push(object);
         object.onProcess = true;
         this.startup();
      }
   }
   
   public function removeThing(object:SmallObject) : void
   {
      if(!object.onProcess)
      {
         return;
      }
      var len:int = int(this._objectList.length);
      for(var i:int = 0; i < len; i++)
      {
         if(this._objectList[i] == object)
         {
            this._objectList.splice(i,1);
            object.onProcess = false;
            if(this._objectList.length <= 0)
            {
               this.shutdown();
            }
            return;
         }
      }
   }
   
   public function startup() : void
   {
      if(!this._startuped)
      {
         this._lastTime = getTimer();
         StageReferance.stage.addEventListener(Event.ENTER_FRAME,this.__onFrame);
         this._startuped = true;
      }
   }
   
   private function __onFrame(evt:Event) : void
   {
      var object:SmallObject = null;
      var now:int = getTimer();
      var frameRate:int = now - this._lastTime;
      var testStart:int = getTimer();
      for each(object in this._objectList)
      {
         object.onFrame(frameRate);
      }
      this._lastTime = now;
   }
   
   public function shutdown() : void
   {
      if(this._startuped)
      {
         this._lastTime = 0;
         StageReferance.stage.removeEventListener(Event.ENTER_FRAME,this.__onFrame);
         this._startuped = false;
      }
   }
   
   public function dispose() : void
   {
      this.shutdown();
      var object:SmallObject = this._objectList.shift();
      while(object != null)
      {
         object.onProcess = false;
         object = this._objectList.shift();
      }
      this._objectList = null;
   }
}
