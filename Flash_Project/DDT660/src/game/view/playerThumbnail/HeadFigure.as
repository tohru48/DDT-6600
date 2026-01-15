package game.view.playerThumbnail
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import game.model.Living;
   import game.model.Player;
   import game.model.SimpleBoss;
   
   public class HeadFigure extends Sprite implements Disposeable
   {
      
      private var _head:Bitmap;
      
      private var _info:Player;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _living:Living;
      
      private var _defaultFace:BitmapData;
      
      private var _isGray:Boolean = false;
      
      public function HeadFigure($width:Number, $height:Number, Obj:Object = null)
      {
         super();
         this._defaultFace = ComponentFactory.Instance.creatBitmapData("game.player.gameCharacter");
         if(Obj is Player)
         {
            this._info = Obj as Player;
            if(Boolean(this._info) && Boolean(this._info.character))
            {
               this._info.character.addEventListener(Event.COMPLETE,this.bitmapChange);
            }
         }
         else
         {
            this._living = Obj as Living;
            this._living.addEventListener(Event.COMPLETE,this.bitmapChange);
         }
         this._width = $width;
         this._height = $height;
         this.initFigure();
         this.width = $width;
         this.height = $height;
      }
      
      private function initFigure() : void
      {
         if(Boolean(this._living))
         {
            this._head = new Bitmap(this._living.thumbnail.clone(),"auto",true);
            addChild(this._head);
         }
         else if(this._info && this._info.character && Boolean(this._info.character.characterBitmapdata))
         {
            this.drawHead(this._info.character.characterBitmapdata);
            addChild(this._head);
         }
         else if(this._info && this._info.character && !this._info.character.characterBitmapdata)
         {
            this.drawHead(this._defaultFace);
            addChild(this._head);
         }
      }
      
      private function bitmapChange(e:Event) : void
      {
         if(!this._info || !this._info.character)
         {
            return;
         }
         this.drawHead(this._info.character.characterBitmapdata);
         if(this._isGray)
         {
            this.gray();
         }
      }
      
      private function drawHead(source:BitmapData) : void
      {
         if(source == null)
         {
            return;
         }
         if(Boolean(this._head))
         {
            if(Boolean(this._head.parent))
            {
               this._head.parent.removeChild(this._head);
            }
            this._head.bitmapData.dispose();
            this._head = null;
         }
         this._head = new Bitmap(new BitmapData(this._width,this._height,true,0),PixelSnapping.AUTO,true);
         var rect:Rectangle = this.getHeadRect();
         var mt:Matrix = new Matrix();
         mt.identity();
         mt.scale(this._width / rect.width,this._height / rect.height);
         mt.translate(-rect.x * (this._width / rect.width),-rect.y * (this._height / rect.height));
         this._head.bitmapData.draw(source,mt);
         addChild(this._head);
      }
      
      private function getHeadRect() : Rectangle
      {
         if(this._info == null)
         {
            if(this._living is SimpleBoss)
            {
               return new Rectangle(0,0,300,300);
            }
            return new Rectangle(-2,-2,80,80);
         }
         if(this._info.playerInfo.getSuitsType() == 1)
         {
            return new Rectangle(21,12,167,165);
         }
         return new Rectangle(16,58,170,170);
      }
      
      public function gray() : void
      {
         if(Boolean(this._head))
         {
            this._head.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
         this._isGray = true;
      }
      
      public function reset() : void
      {
         if(Boolean(this._head))
         {
            this._head.filters = null;
         }
         this._isGray = false;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._info))
         {
            if(Boolean(this._info.character))
            {
               this._info.character.removeEventListener(Event.COMPLETE,this.bitmapChange);
            }
         }
         if(Boolean(this._head))
         {
            if(Boolean(this._head.parent))
            {
               this._head.parent.removeChild(this._head);
            }
            this._head.bitmapData.dispose();
            this._head = null;
         }
         this._living = null;
         this._head = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

