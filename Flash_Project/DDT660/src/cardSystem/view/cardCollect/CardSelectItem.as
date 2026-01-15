package cardSystem.view.cardCollect
{
   import cardSystem.CardEvent;
   import cardSystem.data.SetsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CardSelectItem extends Sprite implements Disposeable
   {
      
      private var _nameTxt:FilterFrameText;
      
      private var _bgImg:Bitmap;
      
      private var _id:String;
      
      public function CardSelectItem()
      {
         super();
         this.init();
         this.initEvents();
      }
      
      private function init() : void
      {
         this._bgImg = ComponentFactory.Instance.creat("asset.chat.FriendListItemBg2");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("cardSystem.CardNameTxt");
         addChild(this._nameTxt);
         addChildAt(this._bgImg,0);
         this._bgImg.alpha = 0;
         this._bgImg.width = 140;
         this._bgImg.y = -2;
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
         var obj:Object = new Object();
         obj.id = this._id;
         var evt:CardEvent = new CardEvent(CardEvent.SELECT_CARDS,obj);
         dispatchEvent(evt);
      }
      
      public function set info(goods:SetsInfo) : void
      {
         this._nameTxt.text = goods.name;
         this._id = goods.ID;
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

