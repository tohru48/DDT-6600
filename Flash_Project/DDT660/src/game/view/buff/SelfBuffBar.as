package game.view.buff
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import game.GameManager;
   import game.model.Living;
   import game.view.SpringArrowView;
   import game.view.propertyWaterBuff.PropertyWaterBuffBar;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class SelfBuffBar extends Sprite implements Disposeable
   {
      
      private var _buffCells:Vector.<BuffCell> = new Vector.<BuffCell>();
      
      private var _back:Bitmap;
      
      private var _living:Living;
      
      private var _container:DisplayObjectContainer;
      
      private var _gameArrow:SpringArrowView;
      
      private var _kingblessIcon:Image;
      
      private var _trueWidth:Number;
      
      private var _propertyWaterBuffBar:PropertyWaterBuffBar;
      
      private var _propertyWaterBuffBarVisible:Boolean;
      
      public function SelfBuffBar(container:DisplayObjectContainer, gameArrow:SpringArrowView)
      {
         super();
         this._gameArrow = gameArrow;
         this._container = container;
      }
      
      public function dispose() : void
      {
         this._kingblessIcon = null;
         if(Boolean(this._living))
         {
            this._living.removeEventListener(LivingEvent.BUFF_CHANGED,this.__updateCell);
         }
         var cell:BuffCell = this._buffCells.shift();
         while(Boolean(cell))
         {
            ObjectUtils.disposeObject(cell);
            cell = this._buffCells.shift();
         }
         this._buffCells = null;
         ObjectUtils.disposeObject(this._propertyWaterBuffBar);
         this._propertyWaterBuffBar = null;
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         this._gameArrow = null;
         this._container = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function __updateCell(event:LivingEvent) : void
      {
         var cell:BuffCell = null;
         var i:int = 0;
         var j:int = 0;
         this.clearBuff();
         var localBuffLen:int = this._living == null ? 0 : int(this._living.localBuffs.length);
         var petBuffLen:int = this._living == null ? 0 : int(this._living.petBuffs.length);
         if(Boolean(this._kingblessIcon))
         {
            PositionUtils.setPos(this._kingblessIcon,"game.kingbless.addPropertyBuffIconPos2");
         }
         this._trueWidth = 0;
         if(localBuffLen + petBuffLen > 0 && Boolean(this._buffCells))
         {
            if(localBuffLen > 0)
            {
               if(!this._back)
               {
                  this._back = ComponentFactory.Instance.creatBitmap("asset.game.selfBuff.back");
                  addChild(this._back);
               }
               this._trueWidth = this._back.width;
            }
            else if(Boolean(this._back))
            {
               if(Boolean(this._back))
               {
                  ObjectUtils.disposeObject(this._back);
               }
               this._back = null;
            }
            for(i = 0; i < localBuffLen; i++)
            {
               if(i + 1 > this._buffCells.length)
               {
                  cell = new BuffCell(null,null,false,true);
                  this._buffCells.push(cell);
               }
               else
               {
                  cell = this._buffCells[i];
               }
               cell.x = i % 10 * 36 + 8;
               cell.y = -Math.floor(i / 10) * 36 + 6;
               addChild(cell);
               cell.setInfo(this._living.localBuffs[i]);
               cell.height = 32;
               cell.width = 32;
            }
            for(j = 0; j < petBuffLen; j++)
            {
               if(j + 1 + localBuffLen > this._buffCells.length)
               {
                  cell = new BuffCell(null,null,false,true);
                  this._buffCells.push(cell);
               }
               else
               {
                  cell = this._buffCells[j + localBuffLen];
               }
               if(localBuffLen > 0)
               {
                  cell.x = (j + localBuffLen > 3 ? j + localBuffLen : j + 3) % 10 * 36 + 15;
               }
               else
               {
                  cell.x = (j + localBuffLen) % 10 * 36;
               }
               cell.y = -Math.floor((j + localBuffLen) / 10) * 36 + 6;
               cell.setInfo(this._living.petBuffs[j]);
               addChild(cell);
               this._trueWidth = cell.x + 32;
            }
            if(parent == null && GameManager.Instance.Current.mapIndex != 1405)
            {
               if(this._container.contains(this._gameArrow))
               {
                  this._container.addChildAt(this,this._container.getChildIndex(this._gameArrow));
               }
               else
               {
                  this._container.addChild(this);
               }
            }
         }
         else if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._kingblessIcon))
         {
            this._kingblessIcon.x += this._trueWidth == 0 ? 4 : this._trueWidth + 4;
         }
         this.createPropertyWaterBuffBar();
      }
      
      private function createPropertyWaterBuffBar() : void
      {
         if(PropertyWaterBuffBar.getPropertyWaterBuffList(PlayerManager.Instance.Self.buffInfo).length > 0 && RoomManager.Instance.current.type != RoomInfo.FIGHTGROUND_ROOM)
         {
            if(!this._propertyWaterBuffBar)
            {
               this._propertyWaterBuffBar = new PropertyWaterBuffBar();
               PositionUtils.setPos(this._propertyWaterBuffBar,"game.view.propertyWaterBuff.PropertyWaterBuffBarPos");
               this._propertyWaterBuffBar.visible = this._propertyWaterBuffBarVisible;
               addChild(this._propertyWaterBuffBar);
            }
            if(Boolean(this._kingblessIcon))
            {
               this._propertyWaterBuffBar.x = this._trueWidth + this._kingblessIcon.width + 6;
            }
            else
            {
               this._propertyWaterBuffBar.x = this._trueWidth == 0 ? 6 : this._trueWidth + 6;
            }
            if(parent == null && GameManager.Instance.Current.mapIndex != 1405)
            {
               if(this._container.contains(this._gameArrow))
               {
                  this._container.addChildAt(this,this._container.getChildIndex(this._gameArrow));
               }
               else
               {
                  this._container.addChild(this);
               }
            }
         }
      }
      
      public function drawBuff(living:Living, kingblessIcon:Image) : void
      {
         this._kingblessIcon = kingblessIcon;
         if(Boolean(this._living))
         {
            this._living.removeEventListener(LivingEvent.BUFF_CHANGED,this.__updateCell);
         }
         this._living = living;
         if(Boolean(this._living))
         {
            this._living.addEventListener(LivingEvent.BUFF_CHANGED,this.__updateCell);
         }
         this.__updateCell(null);
      }
      
      public function get right() : Number
      {
         var petBuffLen:int = 0;
         var len:int = 0;
         var localBuffLen:int = 0;
         var petBuffLen1:int = 0;
         var len1:int = 0;
         if(this._living == null || this._living.localBuffs.length == 0)
         {
            petBuffLen = this._living == null ? 0 : int(this._living.petBuffs.length);
            len = petBuffLen > 8 ? 8 : petBuffLen;
            return x + len * 44 + 40;
         }
         localBuffLen = this._living == null ? 0 : int(this._living.localBuffs.length);
         petBuffLen1 = this._living == null ? 0 : int(this._living.petBuffs.length);
         len1 = localBuffLen + petBuffLen1 > 8 ? 8 : localBuffLen + petBuffLen1;
         return x + len1 * 44 + 40;
      }
      
      public function set propertyWaterBuffBarVisible(value:Boolean) : void
      {
         this._propertyWaterBuffBarVisible = value;
         if(Boolean(this._propertyWaterBuffBar))
         {
            this._propertyWaterBuffBar.visible = this._propertyWaterBuffBarVisible;
         }
      }
      
      private function clearBuff() : void
      {
         var cell:BuffCell = null;
         for each(cell in this._buffCells)
         {
            cell.clearSelf();
         }
         ObjectUtils.disposeObject(this._back);
         this._back = null;
      }
   }
}

