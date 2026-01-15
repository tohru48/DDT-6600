package ddt.view.caddyII.card
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.CaddyBagView;
   import ddt.view.caddyII.CaddyFrame;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.MoveSprite;
   import ddt.view.caddyII.badLuck.BadLuckView;
   import ddt.view.caddyII.reader.CaddyUpdate;
   import flash.display.DisplayObject;
   
   public class CardSoulBoxFrame extends Frame
   {
      
      private var _view:CardSoulView;
      
      private var _bag:CaddyBagView;
      
      private var _reader:CaddyUpdate;
      
      private var _moveSprite:MoveSprite;
      
      private var _itemInfo:ItemTemplateInfo;
      
      private var _type:int;
      
      public function CardSoulBoxFrame(type:int, itemInfo:ItemTemplateInfo = null)
      {
         super();
         this._type = type;
         this._itemInfo = itemInfo;
         this.initView(this._type);
         this.initEvents();
      }
      
      private function initView(type:int) : void
      {
         escEnable = true;
         CaddyModel.instance.setup(type);
         this._view = ComponentFactory.Instance.creatCustomObject("caddy.CardSoulView");
         this._reader = CaddyModel.instance.readView;
         addToContent(this._reader as DisplayObject);
         addToContent(this._view);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updateInfo);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updateInfo);
      }
      
      private function __updateInfo(e:CrazyTankSocketEvent) : void
      {
         if(this._reader is BadLuckView)
         {
            this._reader.update();
         }
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._view.closeEnble)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.cardSoulBox.dontClose"));
            return;
         }
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      public function setCardType(id:int, place:int) : void
      {
         this._view.setCard(id,place);
      }
      
      public function show() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.view.cardSoulBox.title");
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
         y += CaddyFrame.VerticalOffset;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._view))
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

