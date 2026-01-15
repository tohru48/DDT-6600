package setting.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.ItemEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class KeySetFrame extends BaseAlerFrame
   {
      
      private var _list:HBox;
      
      private var _defaultSetPalel:KeyDefaultSetPanel;
      
      private var _currentSet:KeySetItem;
      
      private var _tempSets:Dictionary;
      
      private var numberAccect:Bitmap;
      
      private var _submit:TextButton;
      
      private var _cancel:TextButton;
      
      private var _imageRectString:String;
      
      public function KeySetFrame()
      {
         super();
         titleText = LanguageMgr.GetTranslation("tank.view.bagII.KeySetFrame.titleText");
         this.initContent();
         this.addEvent();
         this.escEnable = true;
      }
      
      private function initContent() : void
      {
         var strpop:String = null;
         this.numberAccect = ComponentFactory.Instance.creatBitmap("ddtsetting.keyset.numAsset");
         this._list = ComponentFactory.Instance.creatComponentByStylename("keySetHBox");
         this._tempSets = new Dictionary();
         for(strpop in SharedManager.Instance.GameKeySets)
         {
            this._tempSets[strpop] = SharedManager.Instance.GameKeySets[strpop];
         }
         this._submit = ComponentFactory.Instance.creatComponentByStylename("setting.KeySet.SubmitButton");
         this._submit.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
         addToContent(this._submit);
         this._cancel = ComponentFactory.Instance.creatComponentByStylename("setting.KeySet.CancelButton");
         this._cancel.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
         addToContent(this._cancel);
         this.creatCell();
         addToContent(this._list);
         addToContent(this.numberAccect);
         this._defaultSetPalel = new KeyDefaultSetPanel();
         this._defaultSetPalel.visible = false;
         this._defaultSetPalel.addEventListener(Event.SELECT,this.onItemSelected);
         this._defaultSetPalel.addEventListener(Event.REMOVED_FROM_STAGE,this.__ondefaultSetRemove);
         if(this._imageRectString != null)
         {
            MutipleImage(_backgound).imageRectString = this._imageRectString;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._submit.addEventListener(MouseEvent.CLICK,this.__onSubmit);
         this._cancel.addEventListener(MouseEvent.CLICK,this.__onCancel);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._submit.removeEventListener(MouseEvent.CLICK,this.__onSubmit);
         this._cancel.removeEventListener(MouseEvent.CLICK,this.__onCancel);
      }
      
      private function __onSubmit(evt:MouseEvent) : void
      {
         dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
      }
      
      private function __onCancel(evt:MouseEvent) : void
      {
         dispatchEvent(new FrameEvent(FrameEvent.ESC_CLICK));
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.cancelClick();
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.okClick();
         }
      }
      
      private function okClick() : void
      {
         var strpop:String = null;
         for(strpop in this._tempSets)
         {
            SharedManager.Instance.GameKeySets[strpop] = this._tempSets[strpop];
         }
         SharedManager.Instance.save();
      }
      
      private function onItemClick(e:ItemEvent) : void
      {
         e.stopImmediatePropagation();
         SoundManager.instance.play("008");
         this._currentSet = e.currentTarget as KeySetItem;
         if(Boolean(this._defaultSetPalel.parent))
         {
            removeChild(this._defaultSetPalel);
         }
         this._defaultSetPalel.visible = true;
         this._currentSet.glow = true;
         this._defaultSetPalel.x = e.currentTarget.x + 2;
         this._defaultSetPalel.y = this._list.y - this._defaultSetPalel.height;
         addChild(this._defaultSetPalel);
      }
      
      private function cancelClick() : void
      {
         var strpop:String = null;
         this._tempSets = new Dictionary();
         for(strpop in SharedManager.Instance.GameKeySets)
         {
            this._tempSets[strpop] = SharedManager.Instance.GameKeySets[strpop];
         }
         this.clearItemList();
      }
      
      private function __ondefaultSetRemove(e:Event) : void
      {
         if(Boolean(this._currentSet))
         {
            this._currentSet.glow = false;
         }
      }
      
      private function creatCell() : void
      {
         var i:String = null;
         var temp:ItemTemplateInfo = null;
         var icon:KeySetItem = null;
         this.clearItemList();
         for(i in this._tempSets)
         {
            temp = ItemManager.Instance.getTemplateById(this._tempSets[i]);
            if(i == "9")
            {
               return;
            }
            if(Boolean(temp))
            {
               icon = new KeySetItem(int(i),int(i),this._tempSets[i],PropItemView.createView(temp.Pic,40,40));
               icon.addEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
               icon.setClick(true,false,true);
               this._list.addChild(icon);
            }
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         StageReferance.stage.focus = this;
      }
      
      private function clearItemList(delReference:Boolean = false) : void
      {
         var i:int = 0;
         var icon:KeySetItem = null;
         if(Boolean(this._list))
         {
            for(i = 0; i < this._list.numChildren; i++)
            {
               icon = KeySetItem(this._list.getChildAt(i));
               icon.removeEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
               icon.dispose();
               icon = null;
            }
            ObjectUtils.disposeAllChildren(this._list);
            if(delReference)
            {
               if(Boolean(this._list.parent))
               {
                  this._list.parent.removeChild(this._list);
               }
               this._list = null;
            }
         }
      }
      
      public function close() : void
      {
         this._defaultSetPalel.hide();
         this.removeEvent();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function onItemSelected(e:Event) : void
      {
         if(Boolean(stage))
         {
            stage.focus = this;
         }
         var temp:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._defaultSetPalel.selectedItemID);
         this._currentSet.setItem(PropItemView.createView(temp.Pic,40,40),false);
         this._currentSet.propID = this._defaultSetPalel.selectedItemID;
         this._tempSets[this._currentSet.index] = this._defaultSetPalel.selectedItemID;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearItemList(true);
         this._defaultSetPalel.removeEventListener(Event.SELECT,this.onItemSelected);
         this._defaultSetPalel.removeEventListener(Event.REMOVED_FROM_STAGE,this.__ondefaultSetRemove);
         this._defaultSetPalel.dispose();
         this._defaultSetPalel = null;
         ObjectUtils.disposeObject(this.numberAccect);
         this.numberAccect = null;
         ObjectUtils.disposeObject(this._submit);
         this._submit = null;
         ObjectUtils.disposeObject(this._cancel);
         this._cancel = null;
         if(Boolean(this._currentSet))
         {
            this._currentSet.removeEventListener(ItemEvent.ITEM_CLICK,this.onItemClick);
            this._currentSet.dispose();
            this._currentSet = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         super.dispose();
      }
      
      public function set imageRectString(val:String) : void
      {
         this._imageRectString = val;
         if(Boolean(_backgound))
         {
            MutipleImage(_backgound).imageRectString = this._imageRectString;
         }
      }
      
      public function get imageRectString() : String
      {
         return this._imageRectString;
      }
   }
}

