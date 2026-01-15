package rescue.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.FightPropMode;
   import ddt.data.PropInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.view.prop.WeaponPropCell;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   
   public class RescuePropBar extends Sprite implements Disposeable
   {
      
      private var _background:Bitmap;
      
      private var _cellf:WeaponPropCell;
      
      private var _cellr:WeaponPropCell;
      
      public function RescuePropBar()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var pos:Point = null;
         this._background = ComponentFactory.Instance.creatBitmap("asset.game.prop.WeaponBack");
         addChild(this._background);
         this._cellf = new WeaponPropCell("f",FightPropMode.VERTICAL);
         pos = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPosf");
         this._cellf.setPossiton(pos.x,pos.y);
         addChild(this._cellf);
         this._cellr = new WeaponPropCell("r",FightPropMode.VERTICAL);
         pos = ComponentFactory.Instance.creatCustomObject("WeaponPropCellPosr");
         this._cellr.setPossiton(pos.x,pos.y);
         addChild(this._cellr);
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = EquipType.WishKingBlessing;
         ItemManager.fill(info);
         this._cellr.info = new PropInfo(info);
         this._cellr.setCount(0);
         this._cellr.enabled = true;
      }
      
      private function initEvents() : void
      {
         KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         this._cellr.addEventListener(MouseEvent.CLICK,this.__cellrClick);
      }
      
      protected function __cellrClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._cellr.enabled)
         {
            SocketManager.Instance.out.useRescueKingBless();
            this._cellr.enabled = false;
         }
      }
      
      protected function __keyDown(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case KeyStroke.VK_F.getCode():
               this.doNothing();
               break;
            case KeyStroke.VK_R.getCode():
               if(this._cellr.enabled)
               {
                  SocketManager.Instance.out.useRescueKingBless();
                  this._cellr.enabled = false;
               }
         }
      }
      
      private function doNothing() : void
      {
      }
      
      public function setKingBlessEnable() : void
      {
         this._cellr.enabled = true;
      }
      
      public function setKingBlessCount(count:int) : void
      {
         this._cellr.setCount(count);
      }
      
      private function removeEvents() : void
      {
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         this._cellr.removeEventListener(MouseEvent.CLICK,this.__cellrClick);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._background);
         this._background = null;
         ObjectUtils.disposeObject(this._cellf);
         this._cellf = null;
         ObjectUtils.disposeObject(this._cellr);
         this._cellr = null;
      }
   }
}

