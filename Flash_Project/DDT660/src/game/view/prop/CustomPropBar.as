package game.view.prop
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.FightPropEevnt;
   import ddt.events.LivingEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import entertainmentMode.view.EntertainmentAlertFrame;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.GameManager;
   import game.model.LocalPlayer;
   import game.view.control.FightControlBar;
   import game.view.control.SoulState;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class CustomPropBar extends FightPropBar
   {
      
      private var _selfInfo:SelfInfo;
      
      private var _type:int;
      
      private var _backStyle:String;
      
      private var _localVisible:Boolean = true;
      
      private var _randomBtn:SimpleBitmapButton = ComponentFactory.Instance.creatComponentByStylename("asset.game.custom.random");
      
      public function CustomPropBar(self:LocalPlayer, type:int)
      {
         this._selfInfo = self.playerInfo as SelfInfo;
         this._type = type;
         this._randomBtn.tipData = LanguageMgr.GetTranslation("ddt.entertainmentMode.cost",ServerConfigManager.instance.entertainmentPrice());
         if(RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM && this._type != FightControlBar.SOUL || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM_PK)
         {
            addChild(this._randomBtn);
         }
         super(self);
      }
      
      override protected function addEvent() : void
      {
         var cell:PropCell = null;
         this._selfInfo.FightBag.addEventListener(BagEvent.UPDATE,this.__updateProp);
         _self.addEventListener(LivingEvent.CUSTOMENABLED_CHANGED,this.__customEnabledChanged);
         if(Boolean(this._randomBtn))
         {
            this._randomBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         }
         for each(cell in _cells)
         {
            cell.addEventListener(FightPropEevnt.DELETEPROP,this.__deleteProp);
            cell.addEventListener(FightPropEevnt.USEPROP,this.__useProp);
         }
         if(this._type == FightControlBar.LIVE)
         {
            _self.addEventListener(LivingEvent.ENERGY_CHANGED,__energyChange);
         }
         _self.addEventListener(LivingEvent.PROPENABLED_CHANGED,this.__enabledChanged);
         if(!(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM))
         {
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         }
      }
      
      private function __clickHandler(e:MouseEvent) : void
      {
         var alert:EntertainmentAlertFrame = null;
         if(ServerConfigManager.instance.entertainmentPrice() > PlayerManager.Instance.Self.Money + PlayerManager.Instance.Self.BandMoney)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.entertainmentMode.notEnoughtMoney"));
         }
         else if(PlayerManager.Instance.Self.BandMoney >= ServerConfigManager.instance.entertainmentPrice())
         {
            SocketManager.Instance.out.buyEntertainment();
         }
         else if(SharedManager.Instance.isRefreshSkill)
         {
            SocketManager.Instance.out.buyEntertainment(true);
         }
         else
         {
            alert = ComponentFactory.Instance.creatComponentByStylename("asset.game.entertainment.alertFrame");
            LayerManager.Instance.addToLayer(alert,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         }
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         (evt.target as EntertainmentAlertFrame).removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         (evt.target as EntertainmentAlertFrame).dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.buyEntertainment(true);
         }
      }
      
      private function __psychicChanged(event:LivingEvent) : void
      {
         if(_enabled)
         {
            this.updatePropByPsychic();
         }
      }
      
      private function updatePropByPsychic() : void
      {
         var cell:PropCell = null;
         for each(cell in _cells)
         {
            cell.enabled = cell.info != null && _self.psychic >= cell.info.needPsychic;
         }
      }
      
      override protected function __enabledChanged(event:LivingEvent) : void
      {
         this.enabled = _self.propEnabled && _self.customPropEnabled;
      }
      
      private function __customEnabledChanged(evt:LivingEvent) : void
      {
         this.enabled = _self.customPropEnabled;
      }
      
      private function __deleteProp(event:FightPropEevnt) : void
      {
         var cell:PropCell = event.currentTarget as PropCell;
         GameInSocketOut.sendThrowProp(cell.info.Place);
         SoundManager.instance.play("008");
         StageReferance.stage.focus = null;
      }
      
      private function __updateProp(event:BagEvent) : void
      {
         var i:InventoryItemInfo = null;
         var c:InventoryItemInfo = null;
         var propInfo:PropInfo = null;
         var changes:Dictionary = event.changedSlots;
         for each(i in changes)
         {
            c = this._selfInfo.FightBag.getItemAt(i.Place);
            if(Boolean(c))
            {
               propInfo = new PropInfo(c);
               propInfo.Place = c.Place;
               _cells[i.Place].info = propInfo;
            }
            else
            {
               _cells[i.Place].info = null;
            }
         }
      }
      
      override protected function removeEvent() : void
      {
         var cell:PropCell = null;
         this._selfInfo.FightBag.removeEventListener(BagEvent.UPDATE,this.__updateProp);
         _self.removeEventListener(LivingEvent.CUSTOMENABLED_CHANGED,this.__customEnabledChanged);
         for each(cell in _cells)
         {
            cell.removeEventListener(FightPropEevnt.DELETEPROP,this.__deleteProp);
            cell.removeEventListener(FightPropEevnt.USEPROP,this.__useProp);
         }
         super.removeEvent();
         if(Boolean(this._randomBtn))
         {
            this._randomBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
            if(Boolean(this._randomBtn.parent))
            {
               this._randomBtn.parent.removeChild(this._randomBtn);
            }
            this._randomBtn.dispose();
         }
         this._randomBtn = null;
      }
      
      override protected function drawCells() : void
      {
         var pos:Point = null;
         var cellz:CustomPropCell = new CustomPropCell("z",_mode,this._type);
         pos = ComponentFactory.Instance.creatCustomObject("CustomPropCellPosz");
         cellz.setPossiton(pos.x,pos.y);
         addChild(cellz);
         var cellx:CustomPropCell = new CustomPropCell("x",_mode,this._type);
         pos = ComponentFactory.Instance.creatCustomObject("CustomPropCellPosx");
         cellx.setPossiton(pos.x,pos.y);
         addChild(cellx);
         var cellc:CustomPropCell = new CustomPropCell("c",_mode,this._type);
         pos = ComponentFactory.Instance.creatCustomObject("CustomPropCellPosc");
         cellc.setPossiton(pos.x,pos.y);
         addChild(cellc);
         _cells.push(cellz);
         _cells.push(cellx);
         _cells.push(cellc);
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BATTLE)
         {
            cellz.isLock = true;
            cellx.isLock = true;
            cellc.isLock = true;
         }
         drawLayer();
      }
      
      override protected function __keyDown(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case KeyStroke.VK_Z.getCode():
               _cells[0].useProp();
               break;
            case KeyStroke.VK_X.getCode():
               _cells[1].useProp();
               break;
            case KeyStroke.VK_C.getCode():
               _cells[2].useProp();
         }
      }
      
      private function __useProp(event:FightPropEevnt) : void
      {
         var prop:PropInfo = null;
         var result:String = null;
         var propAnimationName:String = null;
         if(_enabled && this._localVisible)
         {
            prop = PropCell(event.currentTarget).info;
            result = _self.useProp(prop,2);
            if(result == UsePropErrorCode.Done)
            {
               propAnimationName = EquipType.hasPropAnimation(prop.Template);
               if(propAnimationName != null)
               {
                  _self.showEffect(propAnimationName);
               }
            }
            else if(result != UsePropErrorCode.Done && result != UsePropErrorCode.None)
            {
               PropCell(event.currentTarget).isUsed = false;
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + result));
            }
         }
         if(!_enabled)
         {
            PropCell(event.currentTarget).isUsed = false;
         }
      }
      
      override public function enter() : void
      {
         var info:InventoryItemInfo = null;
         var propInfo:PropInfo = null;
         var bag:BagInfo = this._selfInfo.FightBag;
         var len:int = int(_cells.length);
         for(var i:int = 0; i < len; i++)
         {
            info = bag.getItemAt(i);
            if(Boolean(info))
            {
               propInfo = new PropInfo(info);
               propInfo.Place = info.Place;
               _cells[i].info = propInfo;
            }
            else
            {
               _cells[i].info = null;
            }
         }
         this.enabled = _self.customPropEnabled;
         super.enter();
      }
      
      override public function set enabled(val:Boolean) : void
      {
         if(parent is SoulState && RoomManager.Instance.current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM)
         {
            val = false;
         }
         super.enabled = val;
      }
      
      public function set backStyle(val:String) : void
      {
         var back:DisplayObject = null;
         if(this._backStyle != val)
         {
            this._backStyle = val;
            back = _background;
            _background = ComponentFactory.Instance.creat(this._backStyle);
            addChildAt(_background,0);
            ObjectUtils.disposeObject(back);
         }
      }
      
      public function setVisible(val:Boolean) : void
      {
         if(this._localVisible != val)
         {
            this._localVisible = val;
         }
      }
   }
}

