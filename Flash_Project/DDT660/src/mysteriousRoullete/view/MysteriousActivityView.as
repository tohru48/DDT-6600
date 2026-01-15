package mysteriousRoullete.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import mysteriousRoullete.MysteriousManager;
   import mysteriousRoullete.event.MysteriousEvent;
   import wonderfulActivity.views.IRightView;
   
   public class MysteriousActivityView extends Sprite implements IRightView
   {
      
      public static const TYPE_ROULETTE:int = 0;
      
      public static const TYPE_SHOP:int = 1;
      
      private var _content:Sprite;
      
      private var _bg:Bitmap;
      
      private var _view:Sprite;
      
      public var type:int = 0;
      
      public function MysteriousActivityView()
      {
         super();
         MysteriousManager.instance.loadMysteriousRouletteModule(this.init2);
      }
      
      public function init() : void
      {
      }
      
      public function init2() : void
      {
         MysteriousManager.instance.setView(this);
         this._content = new Sprite();
         PositionUtils.setPos(this._content,"mysteriousRoulette.ContentPos");
         this._bg = ComponentFactory.Instance.creat("mysteriousRoulette.BG");
         this._content.addChild(this._bg);
         this.type = MysteriousManager.instance.viewType;
         switch(this.type)
         {
            case TYPE_ROULETTE:
               this._view = new MysteriousRouletteView();
               this._view.addEventListener(MysteriousEvent.CHANG_VIEW,this.changeViewHandler);
               break;
            case TYPE_SHOP:
               this._view = new MysteriousShopView();
         }
         this._content.addChild(this._view);
         addChild(this._content);
      }
      
      private function changeViewHandler(event:MysteriousEvent) : void
      {
         if(!this._view || this.type == event.viewType)
         {
            return;
         }
         this._view.removeEventListener(MysteriousEvent.CHANG_VIEW,this.changeViewHandler);
         ObjectUtils.disposeObject(this._view);
         this._view = null;
         this.type = event.viewType;
         switch(this.type)
         {
            case TYPE_ROULETTE:
               this._view = new MysteriousRouletteView();
               this._view.addEventListener(MysteriousEvent.CHANG_VIEW,this.changeViewHandler);
               break;
            case TYPE_SHOP:
               this._view = new MysteriousShopView();
         }
         this._content.addChild(this._view);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._view))
         {
            this._view.removeEventListener(MysteriousEvent.CHANG_VIEW,this.changeViewHandler);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         MysteriousManager.instance.dispose();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._view))
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      public function get view() : Sprite
      {
         return this._view;
      }
   }
}

