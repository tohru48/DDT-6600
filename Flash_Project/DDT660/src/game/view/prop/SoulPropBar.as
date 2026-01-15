package game.view.prop
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.events.LivingEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.model.LocalPlayer;
   import trainer.data.Step;
   
   public class SoulPropBar extends FightPropBar
   {
      
      protected var _soulCells:Vector.<SoulPropCell> = new Vector.<SoulPropCell>();
      
      private var _propDatas:Array;
      
      private var _back:DisplayObject;
      
      private var _msgShape:DisplayObject;
      
      private var _lockScreen:DisplayObject;
      
      public function SoulPropBar(self:LocalPlayer)
      {
         super(self);
      }
      
      override protected function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmap("asset.game.prop.SoulBack");
         addChild(this._back);
         this._lockScreen = ComponentFactory.Instance.creatBitmap("asset.game.PsychicBar.LockScreen");
         addChild(this._lockScreen);
         super.configUI();
      }
      
      override protected function addEvent() : void
      {
         _self.addEventListener(LivingEvent.PSYCHIC_CHANGED,this.__psychicChanged);
         _self.addEventListener(LivingEvent.SOUL_PROP_ENABEL_CHANGED,this.__enableChanged);
      }
      
      override protected function removeEvent() : void
      {
         var cell:SoulPropCell = null;
         _self.removeEventListener(LivingEvent.PSYCHIC_CHANGED,this.__psychicChanged);
         _self.removeEventListener(LivingEvent.SOUL_PROP_ENABEL_CHANGED,this.__enableChanged);
         for each(cell in this._soulCells)
         {
            cell.removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
      }
      
      override public function enter() : void
      {
         this.setProps();
         this.updatePropByPsychic();
         super.enter();
      }
      
      private function __psychicChanged(event:LivingEvent) : void
      {
         if(_enabled)
         {
            this.updatePropByPsychic();
         }
      }
      
      private function __enableChanged(event:LivingEvent) : void
      {
         enabled = _self.soulPropEnabled;
         if(_enabled)
         {
            this.updatePropByPsychic();
         }
      }
      
      private function showHelpMsg() : void
      {
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GHOST_FIRST) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GHOSTPROP_FIRST))
         {
            if(this._msgShape == null)
            {
               this._msgShape = ComponentFactory.Instance.creatBitmap("asset.game.ghost.msg2");
               this._msgShape.y = -this._msgShape.height;
               addChild(this._msgShape);
            }
            SocketManager.Instance.out.syncWeakStep(Step.GHOSTPROP_FIRST);
         }
      }
      
      private function updatePropByPsychic() : void
      {
         var cell:PropCell = null;
         for each(cell in this._soulCells)
         {
            if(cell.info != null && _self.psychic >= cell.info.needPsychic)
            {
               cell.enabled = true;
               this.showHelpMsg();
            }
            else
            {
               cell.enabled = false;
            }
         }
      }
      
      override protected function drawCells() : void
      {
         var _x:int = 0;
         var _y:int = 0;
         var cell:SoulPropCell = null;
         var count:int = 0;
         var offset:Point = new Point(4,4);
         while(count < 12)
         {
            cell = new SoulPropCell();
            cell.addEventListener(MouseEvent.CLICK,this.__itemClicked);
            _x = count % 6 * (cell.width + 1) + 3.5;
            if(count >= 6)
            {
               _y = cell.height + 2;
            }
            cell.setPossiton(_x + offset.x,_y + offset.y);
            addChild(cell);
            this._soulCells.push(cell);
            count++;
         }
      }
      
      override protected function __itemClicked(event:MouseEvent) : void
      {
         var cell:SoulPropCell = null;
         var result:String = null;
         if(_enabled)
         {
            if(Boolean(this._msgShape))
            {
               ObjectUtils.disposeObject(this._msgShape);
               this._msgShape = null;
            }
            cell = event.currentTarget as SoulPropCell;
            SoundManager.instance.play("008");
            result = _self.useProp(cell.info,1);
            if(result != UsePropErrorCode.Done && result != UsePropErrorCode.None)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + result));
            }
            super.__itemClicked(event);
         }
      }
      
      public function setProps() : void
      {
         var i:int = 0;
         var info:PropInfo = null;
         for(i = 0; i < this._propDatas.length; i++)
         {
            info = new PropInfo(ItemManager.Instance.getTemplateById(this._propDatas[i]));
            info.Place = -1;
            this._soulCells[i].info = info;
            this._soulCells[i].enabled = false;
         }
      }
      
      public function set props(val:String) : void
      {
         this._propDatas = val.split(",");
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._lockScreen);
         this._lockScreen = null;
      }
   }
}

