package farm.view.compose.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import farm.view.compose.event.SelectComposeItemEvent;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ComposeSelectItem extends Sprite implements Disposeable
   {
      
      private var _nameTxt:FilterFrameText;
      
      private var _bgImg:Bitmap;
      
      private var _id:int;
      
      public function ComposeSelectItem()
      {
         super();
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._bgImg = ComponentFactory.Instance.creat("asset.farmHouse.selectComposeitemBg");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("farmHouse.text.composeSelect");
         addChild(this._nameTxt);
         addChildAt(this._bgImg,0);
         this._bgImg.alpha = 0;
         this._bgImg.width = 80;
         this._bgImg.y = -2;
         this._bgImg.x = -2;
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function __mouseOver(event:MouseEvent) : void
      {
         this._bgImg.alpha = 1;
      }
      
      private function __mouseOut(event:MouseEvent) : void
      {
         this._bgImg.alpha = 0;
      }
      
      private function __click(e:MouseEvent) : void
      {
         dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.ITEM_CLICK,this._id));
      }
      
      public function set info(food:FoodComposeListTemplateInfo) : void
      {
         var itemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(food.FoodID);
         if(Boolean(itemInfo))
         {
            this._nameTxt.text = itemInfo.Name;
            this._id = food.FoodID;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bgImg);
         this._bgImg = null;
         if(Boolean(this._nameTxt) && Boolean(this._nameTxt.parent))
         {
            this._nameTxt.parent.removeChild(this._nameTxt);
            this._nameTxt = null;
         }
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
   }
}

