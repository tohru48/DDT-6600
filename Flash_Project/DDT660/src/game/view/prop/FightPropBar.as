package game.view.prop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.events.LivingEvent;
   import ddt.manager.SharedManager;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import game.GameManager;
   import game.model.LocalPlayer;
   import org.aswing.KeyboardManager;
   
   public class FightPropBar extends Sprite implements Disposeable
   {
      
      protected var _mode:int = SharedManager.Instance.propLayerMode;
      
      protected var _cells:Vector.<PropCell> = new Vector.<PropCell>();
      
      protected var _props:Vector.<PropInfo> = new Vector.<PropInfo>();
      
      protected var _self:LocalPlayer;
      
      protected var _background:DisplayObject;
      
      protected var _enabled:Boolean = true;
      
      protected var _inited:Boolean = false;
      
      public function FightPropBar(self:LocalPlayer)
      {
         super();
         this._self = self;
         this.configUI();
         this.addEvent();
         this._inited = true;
      }
      
      public function enter() : void
      {
         this.addEvent();
         this.enabled = this._self.propEnabled;
      }
      
      public function leaving() : void
      {
         this.removeEvent();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      protected function configUI() : void
      {
         this.drawCells();
      }
      
      protected function addEvent() : void
      {
         this._self.addEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChange);
         this._self.addEventListener(LivingEvent.PROPENABLED_CHANGED,this.__enabledChanged);
         if(!(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM))
         {
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         }
      }
      
      protected function __enabledChanged(event:LivingEvent) : void
      {
         this.enabled = this._self.propEnabled;
      }
      
      protected function __keyDown(event:KeyboardEvent) : void
      {
      }
      
      protected function __die(event:LivingEvent) : void
      {
      }
      
      protected function __changeAttack(event:LivingEvent) : void
      {
      }
      
      protected function __energyChange(event:LivingEvent) : void
      {
         if(this._enabled)
         {
            this.updatePropByEnergy();
         }
      }
      
      protected function updatePropByEnergy() : void
      {
         var cell:PropCell = null;
         var info:PropInfo = null;
         for each(cell in this._cells)
         {
            if(Boolean(cell.info))
            {
               info = cell.info;
               if(Boolean(info))
               {
                  if(this._self.energy < info.needEnergy)
                  {
                     cell.enabled = false;
                  }
                  else if(cell.info.TemplateID == EquipType.PASS_BALL)
                  {
                     cell.enabled = this._self.passBallEnabled;
                  }
                  else
                  {
                     cell.enabled = true;
                  }
               }
            }
         }
      }
      
      protected function removeEvent() : void
      {
         this._self.removeEventListener(LivingEvent.ENERGY_CHANGED,this.__energyChange);
         this._self.removeEventListener(LivingEvent.PROPENABLED_CHANGED,this.__enabledChanged);
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      protected function drawLayer() : void
      {
      }
      
      protected function clearCells() : void
      {
         var cell:PropCell = null;
         for each(cell in this._cells)
         {
            cell.info = null;
         }
      }
      
      protected function drawCells() : void
      {
      }
      
      protected function __itemClicked(event:MouseEvent) : void
      {
         StageReferance.stage.focus = null;
      }
      
      public function setMode(mode:int) : void
      {
         if(this._mode != mode)
         {
            this._mode = mode;
            this.drawLayer();
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(val:Boolean) : void
      {
         var cell:PropCell = null;
         if(this._enabled != val)
         {
            this._enabled = val;
            if(this._enabled)
            {
               filters = null;
               this.updatePropByEnergy();
            }
            else
            {
               filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
            }
            for each(cell in this._cells)
            {
               cell.enabled = this._enabled;
            }
         }
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         this.removeEvent();
         if(Boolean(this._cells))
         {
            for(i = 0; i < this._cells.length; i++)
            {
               this._cells[i].dispose();
               this._cells[i] = null;
            }
         }
         this._cells = null;
         if(Boolean(this._background))
         {
            ObjectUtils.disposeObject(this._background);
         }
         this._background = null;
         this._self = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

