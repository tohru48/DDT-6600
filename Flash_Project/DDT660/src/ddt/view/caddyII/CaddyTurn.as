package ddt.view.caddyII
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Elastic;
   import com.greensock.easing.Linear;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.media.Video;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import road7th.utils.MovieClipWrapper;
   
   public class CaddyTurn extends Sprite implements Disposeable
   {
      
      public static const TURN_COMPLETE:String = "caddy_turn_complete";
      
      public static const TIMER_DELAY:int = 100;
      
      private var _turnSprite:Sprite;
      
      private var _selectSprite:Sprite;
      
      private var _selectedCell:BaseCell;
      
      private var _cellNow:BaseCell;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _cells:Vector.<BaseCell>;
      
      private var _templateIDList:Vector.<int>;
      
      private var _timer:Timer;
      
      private var _showCellAble:Boolean = false;
      
      private var _cellNumber:int = 0;
      
      private var _movie:MovieClip;
      
      private var _turnStartFrame:int;
      
      private var _showItemFrame:int;
      
      private var _turnEndFrame:int;
      
      private var _itemsScale:Number = 0.9;
      
      private var _getMovie:MovieClipWrapper;
      
      private var _box:ItemTemplateInfo;
      
      private var _caddyType:int = CaddyModel.CADDY_TYPE;
      
      public function CaddyTurn(txt:FilterFrameText)
      {
         super();
         this.init(txt);
         this.initEvents();
      }
      
      public function setCaddyType(val:int) : void
      {
         if(this._caddyType != val)
         {
            this._caddyType = val;
            this.configMovie();
         }
      }
      
      private function configMovie() : void
      {
         var movie:MovieClip = this._movie;
         if(this._caddyType == CaddyModel.Gold_Caddy)
         {
            this._movie = ComponentFactory.Instance.creat("ddt.view.caddyII.Gold_videoAsset");
         }
         else if(this._caddyType == CaddyModel.Silver_Caddy)
         {
            this._movie = ComponentFactory.Instance.creat("ddt.view.caddyII.Silver_videoAsset");
         }
         else
         {
            this._movie = ComponentFactory.Instance.creat("ddt.view.caddyII.videoAsset");
         }
         for(var i:int = 0; i < this._movie.currentLabels.length; i++)
         {
            if(this._movie.currentLabels[i].name == "turn")
            {
               this._turnStartFrame = this._movie.currentLabels[i].frame;
            }
            else if(this._movie.currentLabels[i].name == "showItems")
            {
               this._showItemFrame = this._movie.currentLabels[i].frame;
            }
            else if(this._movie.currentLabels[i].name == "turnEnd")
            {
               this._turnEndFrame = this._movie.currentLabels[i].frame;
            }
         }
         PositionUtils.setPos(this._movie,"caddy.moviePos");
         addChildAt(this._movie,0);
         if(Boolean(movie) && movie != this._movie)
         {
            movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
            this.disposeMovie(movie);
            ObjectUtils.disposeObject(movie);
         }
      }
      
      private function init(txt:FilterFrameText) : void
      {
         this.configMovie();
         this._getMovie = new MovieClipWrapper(ComponentFactory.Instance.creatCustomObject("MovieGet"));
         this._getMovie.stop();
         addChild(this._getMovie.movie);
         this._turnSprite = ComponentFactory.Instance.creatCustomObject("caddy.turnSprite");
         addChild(this._turnSprite);
         this._goodsNameTxt = txt;
         var size:Point = ComponentFactory.Instance.creatCustomObject("caddy.selectCellSize");
         var shape:Shape = new Shape();
         shape.graphics.beginFill(16777215,0);
         shape.graphics.drawRect(0,0,size.x,size.y);
         shape.graphics.endFill();
         this._selectSprite = ComponentFactory.Instance.creatCustomObject("caddy.turnSprite");
         this._selectedCell = new BaseCell(shape);
         this._selectedCell.x = this._selectedCell.width / -2;
         this._selectedCell.y = this._selectedCell.height / -2;
         this._selectSprite.addChild(this._selectedCell);
         addChild(this._selectSprite);
         this._timer = new Timer(TIMER_DELAY);
         this._timer.stop();
         this._cells = new Vector.<BaseCell>();
      }
      
      private function initEvents() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this._oneComplete);
      }
      
      private function removeEvens() : void
      {
         this._movie.removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._timer.removeEventListener(TimerEvent.TIMER,this._oneComplete);
         this._getMovie.removeEventListener(Event.COMPLETE,this.__getMovieComplete);
      }
      
      private function createCells() : void
      {
         var ran:int = 0;
         var i:int = 0;
         var cell:BaseCell = null;
         var selectedCell:BaseCell = null;
         this._cells = new Vector.<BaseCell>();
         ran = Math.floor(Math.random() * this._templateIDList.length);
         for(i = 0; i < this._templateIDList.length; i++)
         {
            cell = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.caddy.caddyCellBG"));
            cell.info = ItemManager.Instance.getTemplateById(this._templateIDList[i]);
            cell.x = cell.width / -2;
            cell.y = cell.height / -2;
            this._turnSprite.addChild(cell);
            cell.visible = false;
            if(i == ran)
            {
               selectedCell = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.caddy.caddyCellBG"));
               selectedCell.info = this._selectedGoodsInfo;
               selectedCell.x = selectedCell.width / -2;
               selectedCell.y = selectedCell.height / -2;
               this._turnSprite.addChild(selectedCell);
               this._cells.push(selectedCell);
               selectedCell.visible = false;
            }
            this._cells.push(cell);
         }
         this._turnSprite.scaleX = this._itemsScale;
         this._turnSprite.scaleY = this._itemsScale;
      }
      
      private function _oneComplete(evt:TimerEvent) : void
      {
         this._cells[this._cellNumber].visible = this._showCellAble ? true : false;
         if(this._cellNow == null)
         {
            this._cellNow = this._cells[this._cellNumber];
         }
         else
         {
            this._cellNow.visible = false;
            this._cellNow = this._cells[this._cellNumber];
         }
         ++this._cellNumber;
         if(this._cellNumber >= this._cells.length)
         {
            this._cellNumber = 0;
         }
         this._goodsNameTxt.text = this._cellNow.info.Name;
      }
      
      private function _timeOut() : void
      {
         this._clear();
         dispatchEvent(new Event(TURN_COMPLETE));
      }
      
      public function again() : void
      {
         this._movie.gotoAndPlay(1);
      }
      
      private function turn() : void
      {
         if(this._box.TemplateID == EquipType.CADDY)
         {
            TweenLite.to(this._turnSprite,2.5,{
               "rotationX":-360 * 5,
               "ease":Linear.easeNone
            });
         }
         else
         {
            TweenLite.to(this._turnSprite,3.5,{
               "rotationX":-360 * 5,
               "ease":Linear.easeNone
            });
         }
      }
      
      private function creatTweenMagnify(duration:Number = 1, scale:Number = 1.5, repeat:int = -1, yoyo:Boolean = true, delay:int = 1100) : void
      {
         if(this._caddyType == CaddyModel.Gold_Caddy)
         {
            TweenMax.to(this._selectSprite,duration,{
               "scaleX":scale,
               "scaleY":scale,
               "repeat":repeat,
               "yoyo":yoyo
            });
         }
         else
         {
            TweenMax.to(this._selectSprite,duration,{
               "scaleX":scale,
               "scaleY":scale,
               "repeat":repeat,
               "yoyo":yoyo,
               "ease":Elastic.easeOut
            });
            setTimeout(this._timeOut,delay);
         }
      }
      
      private function _clear() : void
      {
         var cell:BaseCell = null;
         this._selectedGoodsInfo = null;
         this._templateIDList = null;
         for each(cell in this._cells)
         {
            ObjectUtils.disposeObject(cell);
         }
         this._cells = null;
         TweenMax.killTweensOf(this._selectSprite);
         if(Boolean(this._selectedCell))
         {
            this._selectedCell.visible = false;
         }
         if(Boolean(this._selectSprite))
         {
            this._selectSprite.scaleX = this._selectSprite.scaleY = 1;
         }
         if(Boolean(this._goodsNameTxt))
         {
            this._goodsNameTxt.text = "";
         }
      }
      
      public function setTurnInfo(info:InventoryItemInfo, list:Vector.<int>) : void
      {
         this._selectedGoodsInfo = info;
         this._templateIDList = list;
         this.createCells();
      }
      
      public function start(box:ItemTemplateInfo) : void
      {
         this._box = box;
         if(this._box.TemplateID == EquipType.CADDY)
         {
            SoundManager.instance.play("155");
         }
         else
         {
            SoundManager.instance.play("137");
         }
         this._movie.addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         this._movie.gotoAndPlay(this._turnEndFrame);
         this._timer.stop();
      }
      
      private function __frameHandler(event:Event) : void
      {
         if(this._movie.currentFrame == this._showItemFrame)
         {
            this._showCellAble = true;
            this.turn();
         }
         else if(this._movie.currentFrame == this._turnEndFrame)
         {
            this._movie.gotoAndStop(this._turnEndFrame + 1);
            this._timer.stop();
            this._turnSprite.visible = false;
            this._selectedCell.info = this._selectedGoodsInfo;
            this._selectedCell.visible = true;
            TweenLite.killDelayedCallsTo(this._turnSprite);
            this._turnSprite.rotationX = 0;
            this._turnSprite.scaleX = 1;
            this._turnSprite.scaleY = 1;
            if(this._caddyType == CaddyModel.Gold_Caddy)
            {
               this._getMovie.movie.visible = true;
               this._getMovie.gotoAndPlay(1);
               this._getMovie.addEventListener(Event.COMPLETE,this.__getMovieComplete);
               TweenMax.to(this._selectSprite,0.5,{
                  "scaleX":2,
                  "scaleY":2,
                  "onComplete":this.getTweenComplete
               });
            }
            else
            {
               this._goodsNameTxt.text = this._selectedCell.info.Name;
               this.creatTweenMagnify();
            }
         }
      }
      
      private function getTweenComplete() : void
      {
         this._goodsNameTxt.text = this._selectedCell.info.Name;
         this._selectSprite.scaleY = 1.8;
         this._selectSprite.scaleX = 1.8;
         this.creatTweenMagnify(1,2,-1,true,3500);
      }
      
      private function __getMovieComplete(event:Event) : void
      {
         this._getMovie.removeEventListener(Event.COMPLETE,this.__getMovieComplete);
         this._getMovie.movie.visible = false;
         this._timeOut();
      }
      
      private function showItems() : void
      {
         this._timer.reset();
         this._timer.start();
      }
      
      private function disposeMovie(target:DisplayObjectContainer) : void
      {
         var len:int = 0;
         var i:int = 0;
         var child:DisplayObject = null;
         if(target != null)
         {
            if(target is MovieClip)
            {
               MovieClip(target).gotoAndStop(1);
            }
            len = target.numChildren;
            for(i = 0; i < len; i++)
            {
               child = target.getChildAt(i);
               if(child is Video)
               {
                  Video(child).clear();
               }
            }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvens();
         if(Boolean(this._turnSprite))
         {
            ObjectUtils.disposeObject(this._turnSprite);
         }
         this._turnSprite = null;
         if(Boolean(this._selectSprite))
         {
            ObjectUtils.disposeObject(this._selectSprite);
         }
         this._selectSprite = null;
         if(Boolean(this._selectedCell))
         {
            ObjectUtils.disposeObject(this._selectedCell);
         }
         this._selectedCell = null;
         if(Boolean(this._cellNow))
         {
            ObjectUtils.disposeObject(this._cellNow);
         }
         this._cellNow = null;
         if(Boolean(this._movie))
         {
            this.disposeMovie(this._movie);
         }
         ObjectUtils.disposeObject(this._movie);
         this._movie = null;
         if(Boolean(this._getMovie))
         {
            ObjectUtils.disposeObject(this._getMovie);
         }
         this._getMovie = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer = null;
         }
         var i:int = 0;
         while(Boolean(this._cells) && i < this._cells.length)
         {
            ObjectUtils.disposeObject(this._cells[i]);
            i++;
         }
         this._cells = null;
         this._goodsNameTxt = null;
         this._selectedGoodsInfo = null;
         this._templateIDList = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

