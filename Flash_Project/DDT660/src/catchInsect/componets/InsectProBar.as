package catchInsect.componets
{
   import catchInsect.event.InsectEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.FightPropEevnt;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.model.LocalPlayer;
   import game.view.prop.CustomPropCell;
   import game.view.prop.FightPropBar;
   import game.view.prop.PropCell;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import trainer.data.Step;
   
   public class InsectProBar extends FightPropBar
   {
      
      private var _selfInfo:SelfInfo;
      
      private var _type:int;
      
      private var _backStyle:String;
      
      private var _localVisible:Boolean = true;
      
      private var _lock0:Boolean;
      
      private var _lock1:Boolean;
      
      private var _ballTips:Bitmap;
      
      private var _netTips:Bitmap;
      
      public function InsectProBar(self:LocalPlayer, type:int)
      {
         this._selfInfo = self.playerInfo as SelfInfo;
         this._type = type;
         super(self);
      }
      
      override protected function addEvent() : void
      {
         var cell:PropCell = null;
         this._selfInfo.PropBag.addEventListener(BagEvent.UPDATE,this.__updateProp);
         for each(cell in _cells)
         {
            cell.addEventListener(FightPropEevnt.USEPROP,this.__useProp);
         }
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
      }
      
      private function __updateProp(event:BagEvent) : void
      {
         var changes:Dictionary = event.changedSlots;
         var count:int = this._selfInfo.PropBag.getItemCountByTemplateId(10615);
         (_cells[0] as CustomPropCell).setCount(count);
         this._lock0 = count <= 0;
         _cells[0].enabled = true;
         _cells[0].enabled = !this._lock0;
         var count2:int = this._selfInfo.PropBag.getItemCountByTemplateId(10616);
         (_cells[1] as CustomPropCell).setCount(count2);
         this._lock1 = count2 <= 0;
         _cells[1].enabled = true;
         _cells[1].enabled = !this._lock1;
         if(!PlayerManager.Instance.Self.isCatchInsectGuideFinish(Step.INSECT_NET_USE))
         {
            this._netTips = ComponentFactory.Instance.creat("catchInsect.useNetTips");
            LayerManager.Instance.addToLayer(this._netTips,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.NONE_BLOCKGOUND,false);
         }
         super.enter();
      }
      
      override protected function removeEvent() : void
      {
         var cell:PropCell = null;
         this._selfInfo.PropBag.removeEventListener(BagEvent.UPDATE,this.__updateProp);
         for each(cell in _cells)
         {
            cell.removeEventListener(FightPropEevnt.USEPROP,this.__useProp);
         }
         super.removeEvent();
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
         drawLayer();
      }
      
      override protected function __keyDown(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case KeyStroke.VK_Z.getCode():
               if(_cells[0].enabled)
               {
                  _cells[0].useProp();
               }
               break;
            case KeyStroke.VK_X.getCode():
               if(_cells[1].enabled)
               {
                  _cells[1].useProp();
               }
               break;
            case KeyStroke.VK_C.getCode():
               _cells[2].useProp();
         }
      }
      
      private function __useProp(event:FightPropEevnt) : void
      {
         var prop:PropInfo = null;
         var temp:InventoryItemInfo = null;
         var result:String = null;
         var propAnimationName:String = null;
         if(_enabled && this._localVisible && PropCell(event.currentTarget).enabled)
         {
            prop = PropCell(event.currentTarget).info;
            temp = this._selfInfo.FightBag.getItemByTemplateId(prop.Template.TemplateID);
            if(!temp)
            {
               return;
            }
            prop.Place = temp.Place;
            result = _self.useProp(prop,2);
            if(result == UsePropErrorCode.Done)
            {
               if(PropCell(event.currentTarget) == _cells[0])
               {
                  ObjectUtils.disposeObject(this._ballTips);
                  this._ballTips = null;
               }
               else if(PropCell(event.currentTarget) == _cells[1])
               {
                  if(!PlayerManager.Instance.Self.isCatchInsectGuideFinish(Step.INSECT_NET_USE))
                  {
                     ObjectUtils.disposeObject(this._netTips);
                     this._netTips = null;
                     SocketManager.Instance.out.syncWeakStep(Step.INSECT_NET_USE);
                     this._ballTips = ComponentFactory.Instance.creat("catchInsect.useBallTips");
                     LayerManager.Instance.addToLayer(this._ballTips,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.NONE_BLOCKGOUND,false);
                  }
               }
               dispatchEvent(new InsectEvent(InsectEvent.USE_PROP));
               enabled = false;
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
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = 10615;
         ItemManager.fill(info);
         var item:ItemTemplateInfo = info as ItemTemplateInfo;
         var prop:PropInfo = new PropInfo(item);
         prop.Place = 0;
         var count:int = this._selfInfo.PropBag.getItemCountByTemplateId(10615);
         _cells[0].info = prop;
         (_cells[0] as CustomPropCell).setCount(count);
         this._lock0 = count <= 0;
         _cells[0].enabled = true;
         _cells[0].enabled = !this._lock0;
         var info2:InventoryItemInfo = new InventoryItemInfo();
         info2.TemplateID = 10616;
         ItemManager.fill(info2);
         var item2:ItemTemplateInfo = info2 as ItemTemplateInfo;
         var prop2:PropInfo = new PropInfo(item2);
         prop2.Place = 1;
         var count2:int = this._selfInfo.PropBag.getItemCountByTemplateId(10616);
         _cells[1].info = prop2;
         (_cells[1] as CustomPropCell).setCount(count2);
         this._lock1 = count2 <= 0;
         _cells[1].enabled = true;
         _cells[1].enabled = !this._lock1;
         super.enter();
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
      
      public function setEnable(value:Boolean) : void
      {
         enabled = value;
         if(this._lock0)
         {
            _cells[0].enabled = false;
         }
         if(this._lock1)
         {
            _cells[1].enabled = false;
         }
      }
      
      override public function leaving() : void
      {
         ObjectUtils.disposeObject(this._netTips);
         this._netTips = null;
         ObjectUtils.disposeObject(this._ballTips);
         this._ballTips = null;
         super.leaving();
      }
      
      public function showBallTips() : void
      {
         if(PlayerManager.Instance.Self.isCatchInsectGuideFinish(Step.INSECT_NET_USE))
         {
            this._ballTips = ComponentFactory.Instance.creat("catchInsect.useBallTips");
            LayerManager.Instance.addToLayer(this._ballTips,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.NONE_BLOCKGOUND,false);
         }
      }
   }
}

