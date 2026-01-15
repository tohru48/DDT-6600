package boguAdventure.cell
{
   import bagAndInfo.cell.BaseCell;
   import boguAdventure.model.BoguAdventureCellInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class BoguAdventureCell extends Sprite implements Disposeable
   {
      
      public static const PLAY_COMPLETE:String = "playcomplete";
      
      private var _cellBg:Bitmap;
      
      private var _info:BoguAdventureCellInfo;
      
      private var _goodsBg:BaseCell;
      
      private var _shine:MovieClip;
      
      private var _lightFilter:ColorMatrixFilter;
      
      private var _isMove:Boolean;
      
      public function BoguAdventureCell()
      {
         super();
         this._cellBg = UICreatShortcut.creatAndAdd("boguAdventure.gameView.CellBg",this);
         this._lightFilter = ComponentFactory.Instance.model.getSet("lightFilter");
         this.buttonMode = true;
         this.graphics.beginFill(0,0.1);
         this.graphics.drawRect(0,0,this.width,this.height);
         this.graphics.endFill();
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.__onMove);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.__onOut);
      }
      
      public function set info(value:BoguAdventureCellInfo) : void
      {
         this._info = value;
         if(this._info.state == BoguAdventureCellInfo.OPEN)
         {
            this.open();
         }
         else
         {
            this.close();
         }
         ObjectUtils.disposeObject(this._goodsBg);
         this._goodsBg = null;
      }
      
      public function get info() : BoguAdventureCellInfo
      {
         return this._info;
      }
      
      public function changeCellBg() : void
      {
         if(Boolean(this._goodsBg))
         {
            this._goodsBg.removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
         ObjectUtils.disposeObject(this._goodsBg);
         this._goodsBg = null;
         if(this._info.result != BoguAdventureCellInfo.MINE && this._info.result != BoguAdventureCellInfo.SPACE)
         {
            this._goodsBg = new BaseCell(new Sprite(),ItemManager.Instance.getTemplateById(this._info.result));
            this._goodsBg.setContentSize(this._cellBg.width,this._cellBg.height);
            this._goodsBg.addEventListener(MouseEvent.CLICK,this.__onClick);
            this._goodsBg.addEventListener(MouseEvent.MOUSE_MOVE,this.__onMove);
            this._goodsBg.addEventListener(MouseEvent.MOUSE_OUT,this.__onOut);
            addChild(this._goodsBg);
         }
      }
      
      private function __onMove(e:MouseEvent) : void
      {
         this.lightFilter = true;
      }
      
      private function __onOut(e:MouseEvent) : void
      {
         this.lightFilter = false;
      }
      
      public function playShineAction() : void
      {
         if(Boolean(this._shine))
         {
            return;
         }
         this._shine = UICreatShortcut.creatAndAdd("boguAdventure.mapView.cellShine",this);
         this._shine.addEventListener(Event.ENTER_FRAME,this.__onPlayComplete);
         this._shine.play();
      }
      
      private function set lightFilter(value:Boolean) : void
      {
         if(this._isMove == value)
         {
            return;
         }
         this._isMove = value;
         this.filters = this._isMove ? [this._lightFilter] : null;
      }
      
      private function __onPlayComplete(e:Event) : void
      {
         if(this._shine.currentFrame == this._shine.totalFrames)
         {
            this._shine.stop();
            this._shine.removeEventListener(Event.ENTER_FRAME,this.__onPlayComplete);
            ObjectUtils.disposeObject(this._shine);
            this._shine = null;
            dispatchEvent(new Event(PLAY_COMPLETE));
         }
      }
      
      private function __onClick(e:MouseEvent) : void
      {
         dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function close() : void
      {
         this._cellBg.visible = true;
      }
      
      public function open() : void
      {
         this._cellBg.visible = false;
      }
      
      override public function get width() : Number
      {
         return 55;
      }
      
      override public function get height() : Number
      {
         return 51;
      }
      
      public function dispose() : void
      {
         this.graphics.clear();
         this._lightFilter = null;
         this.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onMove);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.__onOut);
         if(Boolean(this._shine))
         {
            this._shine.stop();
            this._shine.removeEventListener(Event.ENTER_FRAME,this.__onPlayComplete);
            ObjectUtils.disposeObject(this._shine);
            this._shine = null;
         }
         ObjectUtils.disposeObject(this._cellBg);
         this._cellBg = null;
         if(Boolean(this._goodsBg))
         {
            this._goodsBg.removeEventListener(MouseEvent.CLICK,this.__onClick);
            this._goodsBg.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onMove);
            this._goodsBg.removeEventListener(MouseEvent.MOUSE_OUT,this.__onOut);
         }
         ObjectUtils.disposeObject(this._goodsBg);
         this._goodsBg = null;
      }
   }
}

