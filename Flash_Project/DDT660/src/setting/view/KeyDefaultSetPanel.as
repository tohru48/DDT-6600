package setting.view
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class KeyDefaultSetPanel extends Sprite
   {
      
      private var _bg:Bitmap;
      
      private var alphaClickArea:Sprite;
      
      private var _icon:Array;
      
      public var selectedItemID:int = 0;
      
      public function KeyDefaultSetPanel()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var temp:ItemTemplateInfo = null;
         var icon:KeySetItem = null;
         var topLeft:Point = ComponentFactory.Instance.creatCustomObject("ddtsetting.KeySet.KeyTL");
         var rect:Point = ComponentFactory.Instance.creatCustomObject("ddtsetting.KeySet.KeyRect");
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.__removeToStage);
         this.alphaClickArea = new Sprite();
         this._bg = ComponentFactory.Instance.creatBitmap("ddtsetting.keyset.BGAsset");
         addChild(this._bg);
         this._icon = [];
         var sets:Array = SharedManager.KEY_SET_ABLE;
         for(var i:int = 0; i < sets.length; i++)
         {
            temp = ItemManager.Instance.getTemplateById(sets[i]);
            if(Boolean(temp))
            {
               icon = new KeySetItem(sets[i],0,sets[i],PropItemView.createView(temp.Pic,40,40));
               icon.addEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
               icon.x = topLeft.x + (i < 4 ? i * rect.x : (i - 4) * rect.x);
               icon.y = topLeft.y + (i < 4 ? 0 : Math.floor(i / 4) * rect.y);
               icon.setClick(true,false,true);
               icon.width = 40;
               icon.height = 40;
               icon.setBackgroundVisible(false);
               addChild(icon);
               this._icon.push(icon);
            }
         }
      }
      
      private function __addToStage(e:Event) : void
      {
         this.alphaClickArea.graphics.beginFill(16711935,0);
         this.alphaClickArea.graphics.drawRect(-3000,-3000,6000,6000);
         addChildAt(this.alphaClickArea,0);
         this.alphaClickArea.addEventListener(MouseEvent.CLICK,this.clickHide);
      }
      
      private function __removeToStage(e:Event) : void
      {
         this.alphaClickArea.graphics.clear();
         this.alphaClickArea.removeEventListener(MouseEvent.CLICK,this.clickHide);
      }
      
      private function clickHide(e:MouseEvent) : void
      {
         this.hide();
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function dispose() : void
      {
         var icon:KeySetItem = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.__removeToStage);
         while(this._icon.length > 0)
         {
            icon = this._icon.shift() as KeySetItem;
            if(Boolean(icon))
            {
               icon.removeEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
               icon.dispose();
            }
            icon = null;
         }
         this._icon = null;
         if(Boolean(this.alphaClickArea))
         {
            this.alphaClickArea.removeEventListener(MouseEvent.CLICK,this.clickHide);
            this.alphaClickArea.graphics.clear();
            if(Boolean(this.alphaClickArea.parent))
            {
               this.alphaClickArea.parent.removeChild(this.alphaClickArea);
            }
         }
         this.alphaClickArea = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function onItemClick(e:ItemEvent) : void
      {
         SoundManager.instance.play("008");
         this.selectedItemID = e.index;
         this.hide();
         dispatchEvent(new Event(Event.SELECT));
      }
   }
}

