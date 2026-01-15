package texpSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class TexpInfoTipArea extends Sprite implements Disposeable
   {
      
      private var _tip:TexpInfoTip;
      
      private var _info:PlayerInfo;
      
      public function TexpInfoTipArea()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.__over);
         addEventListener(MouseEvent.ROLL_OUT,this.__out);
         var size:Point = ComponentFactory.Instance.creatCustomObject("texpSystem.texpInfoTipArea.size");
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,size.x,size.y);
         graphics.endFill();
         this._tip = new TexpInfoTip();
      }
      
      public function set info(value:PlayerInfo) : void
      {
         if(!value)
         {
            return;
         }
         this._info = value;
         this._tip.tipData = this._info;
      }
      
      private function __over(evt:MouseEvent) : void
      {
         var pos:Point = null;
         if(!this._tip.parent && Boolean(this._info))
         {
            pos = localToGlobal(new Point(0,0));
            this._tip.x = pos.x;
            this._tip.y = pos.y + width;
            LayerManager.Instance.addToLayer(this._tip,LayerManager.GAME_TOP_LAYER);
         }
      }
      
      private function __out(evt:MouseEvent) : void
      {
         if(Boolean(this._tip.parent))
         {
            this._tip.parent.removeChild(this._tip);
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__over);
         removeEventListener(MouseEvent.ROLL_OUT,this.__out);
         ObjectUtils.disposeObject(this._tip);
         this._tip = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

