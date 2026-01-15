package game.view.prop
{
   import com.greensock.TweenLite;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.FightPropMode;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.LivingEvent;
   import ddt.events.SharedEvent;
   import ddt.manager.DragManager;
   import ddt.manager.InGameCursor;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class RightPropBar extends FightPropBar
   {
      
      private var _startPos:Point;
      
      private var _mouseHolded:Boolean = false;
      
      private var _elasped:int = 0;
      
      private var _last:int = 0;
      
      private var _container:DisplayObjectContainer;
      
      private var _localVisible:Boolean = true;
      
      private var _tweenComplete:Boolean = true;
      
      private var cell:PropCell;
      
      private var _tempPlace:int;
      
      public function RightPropBar(self:LocalPlayer, container:DisplayObjectContainer)
      {
         this._container = container;
         super(self);
         this.setItems();
      }
      
      public function setup(container:DisplayObjectContainer) : void
      {
         this._container = container;
         var _info:RoomInfo = RoomManager.Instance.current;
         this._container.addChild(this);
         if(_mode == FightPropMode.VERTICAL)
         {
            x = _background.width;
            if(SharedManager.Instance.propTransparent)
            {
               TweenLite.to(this,0.3,{
                  "x":0,
                  "alpha":0.5
               });
            }
            else
            {
               TweenLite.to(this,0.3,{
                  "x":0,
                  "alpha":1
               });
            }
         }
         else
         {
            y = 102;
            if(SharedManager.Instance.propTransparent)
            {
               TweenLite.to(this,0.3,{
                  "y":0,
                  "alpha":0.5
               });
            }
            else
            {
               TweenLite.to(this,0.3,{
                  "y":0,
                  "alpha":1
               });
            }
         }
      }
      
      private function setItems() : void
      {
         var propId:String = null;
         var info:PropInfo = null;
         var items:Array = null;
         var i:InventoryItemInfo = null;
         var hasItem:Boolean = false;
         var propAllProp:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.T_ALL_PROP,true,true);
         var _sets:Object = SharedManager.Instance.GameKeySets;
         for(propId in _sets)
         {
            if(int(propId) == 9)
            {
               break;
            }
            info = new PropInfo(ItemManager.Instance.getTemplateById(_sets[propId]));
            if(Boolean(propAllProp) || PlayerManager.Instance.Self.hasBuff(BuffInfo.FREE))
            {
               if(Boolean(propAllProp))
               {
                  info.Place = propAllProp.Place;
               }
               else
               {
                  info.Place = -1;
               }
               info.Count = -1;
               _cells[int(propId) - 1].info = info;
               hasItem = true;
            }
            else
            {
               items = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(_sets[propId]);
               if(items.length > 0)
               {
                  info.Place = items[0].Place;
                  for each(i in items)
                  {
                     info.Count += i.Count;
                  }
                  _cells[int(propId) - 1].info = info;
                  hasItem = true;
               }
               else
               {
                  _cells[int(propId) - 1].info = info;
               }
            }
         }
         if(hasItem)
         {
            this.updatePropByEnergy();
         }
      }
      
      override protected function updatePropByEnergy() : void
      {
         var cell:PropCell = null;
         var info:PropInfo = null;
         for each(cell in _cells)
         {
            if(Boolean(cell.info))
            {
               info = cell.info;
               if(Boolean(info))
               {
                  if(_self.energy < info.needEnergy)
                  {
                     cell.enabled = false;
                     this.clearArrowByProp(info,false,true);
                  }
                  else if(!_self.twoKillEnabled && (cell.info.TemplateID == EquipType.ADD_TWO_ATTACK || cell.info.TemplateID == EquipType.ADD_ONE_ATTACK || cell.info.TemplateID == EquipType.THREEKILL))
                  {
                     cell.enabled = false;
                  }
                  else if(cell.info.TemplateID == EquipType.THREEKILL)
                  {
                     cell.enabled = _self.threeKillEnabled;
                  }
                  else
                  {
                     cell.enabled = true;
                  }
               }
            }
         }
      }
      
      private function clearArrowByProp(prop:PropInfo, isTip:Boolean = true, energy:Boolean = false) : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         switch(prop.TemplateID)
         {
            case 10002:
               this.clearArr(ArrowType.TIP_ONE,isTip);
               break;
            case 10003:
               this.clearArr(ArrowType.TIP_THREE,isTip);
               if(!energy)
               {
                  this.clearArr(ArrowType.TIP_POWER,isTip);
               }
               break;
            case 10008:
               this.clearArr(ArrowType.TIP_TEN_PERCENT,isTip);
         }
      }
      
      private function clearArr(type:int, isTip:Boolean) : void
      {
         if(NewHandContainer.Instance.hasArrow(type))
         {
            NewHandContainer.Instance.clearArrowByID(type);
            if(isTip)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.view.propContainer.ItemContainer.energy"));
            }
         }
      }
      
      override protected function __itemClicked(event:MouseEvent) : void
      {
         var cell:PropCell = null;
         var result:String = null;
         if(!this._localVisible)
         {
            return;
         }
         if(_enabled)
         {
            if(_self.isUsedPetSkillWithNoItem)
            {
               return;
            }
            _self.isUsedItem = true;
            cell = event.currentTarget as PropCell;
            if(!cell.enabled)
            {
               return;
            }
            SoundManager.instance.play("008");
            result = _self.useProp(cell.info,1);
            if(result != UsePropErrorCode.Done && result != UsePropErrorCode.None)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + result));
            }
            else if(result == UsePropErrorCode.Done)
            {
               this.clearArrowByProp(cell.info);
            }
            super.__itemClicked(event);
            StageReferance.stage.focus = null;
         }
      }
      
      override protected function addEvent() : void
      {
         var cell:PropCell = null;
         for each(cell in _cells)
         {
            cell.addEventListener(MouseEvent.CLICK,this.__itemClicked);
            cell.addEventListener(MouseEvent.MOUSE_DOWN,this.__DownItemHandler);
         }
         _self.addEventListener(LivingEvent.THREEKILL_CHANGED,this.__threeKillChanged);
         _self.addEventListener(LivingEvent.RIGHTENABLED_CHANGED,this.__rightEnabledChanged);
         _self.addEventListener(LivingEvent.SHOOT,this.__shoot);
         _self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
         _self.addEventListener(LocalPlayer.SET_ENABLE,this.__setEnable);
         SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         super.addEvent();
      }
      
      private function __setEnable(event:Event) : void
      {
         var cell:PropCell = null;
         for each(cell in _cells)
         {
            if(cell.info.TemplateID == EquipType.ADD_TWO_ATTACK)
            {
               cell.enabled = false;
            }
            if(cell.info.TemplateID == EquipType.THREEKILL)
            {
               cell.enabled = false;
            }
            if(cell.info.TemplateID == EquipType.ADD_ONE_ATTACK)
            {
               cell.enabled = false;
            }
         }
      }
      
      protected function __transparentChanged(SharedEvent:Event) : void
      {
         if(this._tweenComplete && Boolean(parent))
         {
            if(SharedManager.Instance.propTransparent)
            {
               alpha = 0.5;
            }
            else
            {
               alpha = 1;
            }
         }
      }
      
      private function __attackingChanged(evt:LivingEvent) : void
      {
         if(_self.isAttacking && parent == null && this._localVisible)
         {
            TweenLite.killTweensOf(this,true);
            this._container.addChild(this);
            if(_mode == FightPropMode.VERTICAL)
            {
               alpha = 0;
               x = _background.width;
               if(SharedManager.Instance.propTransparent)
               {
                  TweenLite.to(this,0.3,{
                     "x":0,
                     "alpha":0.5,
                     "onComplete":this.showComplete
                  });
               }
               else
               {
                  TweenLite.to(this,0.3,{
                     "x":0,
                     "alpha":1,
                     "onComplete":this.showComplete
                  });
               }
               this._tweenComplete = false;
            }
            else
            {
               if(SharedManager.Instance.propTransparent)
               {
                  alpha = 0.5;
               }
               else
               {
                  alpha = 1;
               }
               x = 0;
               TweenLite.to(this,0.3,{"x":0});
            }
         }
         else if(!_self.isAttacking)
         {
            if(PlayerManager.Instance.Self.Grade > 15)
            {
               if(Boolean(parent))
               {
                  this.hide();
               }
            }
         }
      }
      
      private function showComplete() : void
      {
         this._tweenComplete = true;
      }
      
      private function hide() : void
      {
         TweenLite.killTweensOf(this.cell);
         DragManager.__upDrag(null);
         InGameCursor.show();
         this._tweenComplete = false;
         TweenLite.to(this,0.3,{
            "alpha":0,
            "onComplete":this.hideComplete
         });
      }
      
      private function hideComplete() : void
      {
         this._tweenComplete = true;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function __shoot(evt:LivingEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade > 15)
         {
            if(Boolean(parent))
            {
               TweenLite.killTweensOf(this,true);
               this.hide();
            }
         }
      }
      
      override protected function __enabledChanged(event:LivingEvent) : void
      {
         enabled = _self.propEnabled && _self.rightPropEnabled;
      }
      
      private function __rightEnabledChanged(evt:LivingEvent) : void
      {
         enabled = _self.propEnabled && _self.rightPropEnabled;
      }
      
      private function __threeKillChanged(evt:LivingEvent) : void
      {
         var cell:PropCell = null;
         for each(cell in _cells)
         {
            if(cell.info.TemplateID == EquipType.THREEKILL)
            {
               cell.enabled = _self.threeKillEnabled;
            }
         }
      }
      
      override protected function __keyDown(event:KeyboardEvent) : void
      {
         if(!_enabled || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM_PK || RoomManager.Instance.current.type == RoomInfo.TREASURELOST_ROOM || GameManager.Instance.Current.mapIndex == 1405)
         {
            return;
         }
         switch(event.keyCode)
         {
            case KeyStroke.VK_1.getCode():
            case KeyStroke.VK_NUMPAD_1.getCode():
               _cells[0].useProp();
               break;
            case KeyStroke.VK_2.getCode():
            case KeyStroke.VK_NUMPAD_2.getCode():
               _cells[1].useProp();
               break;
            case KeyStroke.VK_3.getCode():
            case KeyStroke.VK_NUMPAD_3.getCode():
               _cells[2].useProp();
               break;
            case KeyStroke.VK_4.getCode():
            case KeyStroke.VK_NUMPAD_4.getCode():
               _cells[3].useProp();
               break;
            case KeyStroke.VK_5.getCode():
            case KeyStroke.VK_NUMPAD_5.getCode():
               _cells[4].useProp();
               break;
            case KeyStroke.VK_6.getCode():
            case KeyStroke.VK_NUMPAD_6.getCode():
               _cells[5].useProp();
               break;
            case KeyStroke.VK_7.getCode():
            case KeyStroke.VK_NUMPAD_7.getCode():
               _cells[6].useProp();
               break;
            case KeyStroke.VK_8.getCode():
            case KeyStroke.VK_NUMPAD_8.getCode():
               _cells[7].useProp();
         }
      }
      
      override protected function configUI() : void
      {
         _background = ComponentFactory.Instance.creatComponentByStylename("RightPropBack");
         addChild(_background);
         super.configUI();
      }
      
      override protected function drawCells() : void
      {
         var cell:PropCell = null;
         for(var i:int = 0; i < 8; i++)
         {
            cell = new PropCell(String(i + 1),_mode,true);
            cell.addEventListener(MouseEvent.CLICK,this.__itemClicked);
            cell.addEventListener(MouseEvent.MOUSE_DOWN,this.__DownItemHandler);
            addChild(cell);
            _cells.push(cell);
         }
         this.drawLayer();
      }
      
      private function __DownItemHandler(evt:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_TEN_PERSENT) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THREE_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TWO_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THIRTY_OPEN) && this._tweenComplete == true)
         {
            this.cell = evt.currentTarget as PropCell;
            this._tempPlace = _cells.indexOf(this.cell) + 1;
            this._container.addEventListener(MouseEvent.MOUSE_UP,this.__UpItemHandler);
            TweenLite.to(this.cell,0.5,{"onComplete":this.OnCellComplete});
         }
      }
      
      private function OnCellComplete() : void
      {
         KeyboardManager.getInstance().isStopDispatching = true;
         this.cell.dragStart();
      }
      
      private function __UpItemHandler(evt:MouseEvent) : void
      {
         TweenLite.killTweensOf(this.cell);
         this._container.removeEventListener(MouseEvent.MOUSE_UP,this.__UpItemHandler);
      }
      
      override public function dispose() : void
      {
         if(Boolean(_background))
         {
            ObjectUtils.disposeObject(_background);
            _background = null;
         }
         super.dispose();
      }
      
      override protected function removeEvent() : void
      {
         var cell:PropCell = null;
         for each(cell in _cells)
         {
            cell.removeEventListener(MouseEvent.CLICK,this.__itemClicked);
            cell.removeEventListener(MouseEvent.MOUSE_DOWN,this.__DownItemHandler);
         }
         _self.removeEventListener(LivingEvent.THREEKILL_CHANGED,this.__threeKillChanged);
         _self.removeEventListener(LivingEvent.RIGHTENABLED_CHANGED,this.__rightEnabledChanged);
         _self.removeEventListener(LivingEvent.SHOOT,this.__shoot);
         _self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
         _self.removeEventListener(LocalPlayer.SET_ENABLE,this.__setEnable);
         SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         super.removeEvent();
      }
      
      override protected function drawLayer() : void
      {
         var x:int = 0;
         var y:int = 0;
         this._startPos = ComponentFactory.Instance.creatCustomObject("RightPropPos" + _mode);
         var len:int = int(_cells.length);
         for(var i:int = 0; i < len; i++)
         {
            if(_mode == FightPropMode.VERTICAL)
            {
               x = this._startPos.x + 5;
               y = this._startPos.y + 6 + i * (36 + 3);
            }
            else
            {
               x = this._startPos.x + 6 + i * (36 + 3);
               y = this._startPos.y + 5;
            }
            _cells[i].setPossiton(x,y);
            _cells[i].setMode(_mode);
            if(_inited)
            {
               TweenLite.to(_cells[i],0.05 * (len - i),{
                  "x":x,
                  "y":y
               });
            }
            else
            {
               _cells[i].x = x;
               _cells[i].y = y;
            }
         }
         DisplayUtils.setFrame(_background,_mode);
         PositionUtils.setPos(_background,this._startPos);
      }
      
      override public function enter() : void
      {
         super.enter();
      }
      
      public function get mode() : int
      {
         return _mode;
      }
      
      public function setPropVisible(idx:int, v:Boolean) : void
      {
         var cell:PropCell = null;
         if(idx < _cells.length)
         {
            _cells[idx].setVisible(v);
            if(v)
            {
               if(!_cells[idx].parent)
               {
                  addChild(_cells[idx]);
               }
            }
            else if(Boolean(_cells[idx].parent))
            {
               _cells[idx].parent.removeChild(_cells[idx]);
            }
         }
         for each(cell in _cells)
         {
            if(cell.localVisible)
            {
               this.setVisible(true);
               return;
            }
         }
         this.setVisible(false);
      }
      
      public function setVisible(val:Boolean) : void
      {
         if(this._localVisible != val)
         {
            this._localVisible = val;
            if(this._localVisible)
            {
               if(_self.isAttacking && parent == null)
               {
                  this._container.addChild(this);
               }
            }
            else if(Boolean(parent))
            {
               parent.removeChild(this);
            }
         }
      }
      
      public function hidePropBar() : void
      {
         this.visible = false;
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      public function showPropBar() : void
      {
         this.visible = true;
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
   }
}

