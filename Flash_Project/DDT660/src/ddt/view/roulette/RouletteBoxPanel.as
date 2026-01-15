package ddt.view.roulette
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   
   public class RouletteBoxPanel extends Frame
   {
      
      private var _view:RouletteView;
      
      private var _templateIDList:Array;
      
      private var _keyCount:int;
      
      private var _oldBjYYVolNum:int;
      
      private var _oldYxYYVolNum:int;
      
      public function RouletteBoxPanel()
      {
         super();
         this.initII();
      }
      
      private function initII() : void
      {
         var info:BoxGoodsTempInfo = null;
         this._templateIDList = new Array();
         for(var i:int = 0; i < 18; i++)
         {
            info = new BoxGoodsTempInfo();
            info.TemplateId = 11013;
            info.IsBind = true;
            info.ItemCount = 2;
            info.ItemValid = 7;
            this._templateIDList.push(info);
         }
         this._keyCount = 10;
         escEnable = true;
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._oldBjYYVolNum = SharedManager.Instance.musicVolumn;
         this._oldYxYYVolNum = SharedManager.Instance.soundVolumn;
         SharedManager.Instance.musicVolumn = 0;
         SharedManager.Instance.soundVolumn = 80;
         SharedManager.Instance.changed();
      }
      
      private function _response(evt:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            if(!this._view.isCanClose && this._view.selectNumber < 8)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.rouletteview.quit"));
            }
            else
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.rouletteview.close"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this._responseII);
            }
         }
      }
      
      private function _responseII(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         evt.currentTarget.removeEventListener(FrameEvent.RESPONSE,this._responseII);
         ObjectUtils.disposeObject(evt.target);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.dispose();
         }
      }
      
      public function set templateIDList(arr:Array) : void
      {
         this._templateIDList = arr;
      }
      
      public function set keyCount(value:int) : void
      {
         this._keyCount = value;
      }
      
      public function show() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.view.rouletteView.title");
         this._view = ComponentFactory.Instance.creat("ddt.view.roulette.RouletteView",[this._templateIDList]);
         this._view.keyCount = this._keyCount;
         addToContent(this._view);
      }
      
      override public function dispose() : void
      {
         SharedManager.Instance.musicVolumn = this._oldBjYYVolNum;
         SharedManager.Instance.soundVolumn = this._oldYxYYVolNum;
         SharedManager.Instance.changed();
         removeEventListener(FrameEvent.RESPONSE,this._response);
         super.dispose();
         this._view = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

