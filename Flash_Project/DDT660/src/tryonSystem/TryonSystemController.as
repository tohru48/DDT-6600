package tryonSystem
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class TryonSystemController
   {
      
      private static var _instance:TryonSystemController;
      
      private var _view:Frame;
      
      private var _modelDic:Dictionary;
      
      private var _sumbmintFunDic:Dictionary;
      
      private var _cancelFunDic:Dictionary;
      
      public function TryonSystemController()
      {
         super();
         this._modelDic = new Dictionary();
         this._sumbmintFunDic = new Dictionary();
         this._cancelFunDic = new Dictionary();
      }
      
      public static function get Instance() : TryonSystemController
      {
         if(_instance == null)
         {
            _instance = new TryonSystemController();
         }
         return _instance;
      }
      
      public function getModelByView(view:Frame) : TryonModel
      {
         this._view = view;
         return this._modelDic[view];
      }
      
      public function get view() : Frame
      {
         return this._view;
      }
      
      public function show(items:Array, submitFun:Function = null, cancelFun:Function = null) : void
      {
         var model:TryonModel = new TryonModel(items);
         var sumFun:Function = submitFun;
         var canFun:Function = cancelFun;
         if(EquipType.isAvatar(InventoryItemInfo(items[0]).CategoryID))
         {
            this._view = ComponentFactory.Instance.creatComponentByStylename("tryonSystem.tryonFrame") as TryonPanelFrame;
            this._modelDic[this._view] = model;
            TryonPanelFrame(this._view).controller = this;
         }
         else
         {
            this._view = ComponentFactory.Instance.creatComponentByStylename("tryonSystem.ChoosePanelFrame") as ChooseFrame;
            this._modelDic[this._view] = model;
            ChooseFrame(this._view).controller = this;
         }
         if(sumFun != null)
         {
            this._sumbmintFunDic[this._view] = sumFun;
         }
         if(canFun != null)
         {
            this._cancelFunDic[this._view] = canFun;
         }
         this._view.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._view.addEventListener(Event.REMOVED_FROM_STAGE,this.__onRemoved);
         LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
      }
      
      private function __onRemoved(event:Event) : void
      {
         var model:TryonModel = null;
         if(Boolean(this._modelDic[this._view]))
         {
            model = this._modelDic[this._view];
            model.dispose();
            model = null;
            delete this._modelDic[this._view];
         }
         if(Boolean(this._view))
         {
            this._view.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         if(Boolean(this._view))
         {
            this._view.removeEventListener(Event.REMOVED_FROM_STAGE,this.__onRemoved);
         }
         if(Boolean(this._sumbmintFunDic[this._view]))
         {
            this._sumbmintFunDic[this._view] = null;
         }
         if(Boolean(this._cancelFunDic[this._view]))
         {
            this._cancelFunDic[this._view] = null;
         }
         this._view = null;
      }
      
      private function __onResponse(event:FrameEvent) : void
      {
         var model:TryonModel = null;
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._cancelFunDic[this._view] != null)
               {
                  this._cancelFunDic[this._view]();
               }
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(!(this._modelDic[this._view] as TryonModel).selectedItem)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.tryonSystem.tryon"));
                  return;
               }
               if(this._sumbmintFunDic[this._view] != null)
               {
                  this._sumbmintFunDic[this._view]((this._modelDic[this._view] as TryonModel).selectedItem);
               }
               break;
         }
         if(Boolean(this._modelDic[this._view]))
         {
            model = this._modelDic[this._view];
            model.dispose();
            model = null;
            delete this._modelDic[this._view];
         }
         if(Boolean(this._view))
         {
            this._view.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
         if(Boolean(this._view))
         {
            this._view.removeEventListener(Event.REMOVED_FROM_STAGE,this.__onRemoved);
         }
         if(Boolean(this._view))
         {
            this._view.dispose();
         }
         if(Boolean(this._sumbmintFunDic[this._view]))
         {
            this._sumbmintFunDic[this._view] = null;
            delete this._sumbmintFunDic[this._view];
         }
         if(Boolean(this._cancelFunDic[this._view]))
         {
            this._cancelFunDic[this._view] = null;
            delete this._cancelFunDic[this._view];
         }
         this._view = null;
      }
   }
}

