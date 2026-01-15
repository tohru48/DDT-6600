package hall
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StatisticManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class SaveFileWidow extends Frame
   {
      
      private var _okBtn:TextButton;
      
      private var _novice:Bitmap;
      
      private var _npc:Image;
      
      public function SaveFileWidow()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tips");
         this._novice = ComponentFactory.Instance.creatBitmap("asset.hallSaveFile.noviceBG");
         this._npc = ComponentFactory.Instance.creatComponentByStylename("hall.womenNPC");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("saveFile.okBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("consortion.takeIn.agreeBtn.text");
         addToContent(this._novice);
         addToContent(this._npc);
         addToContent(this._okBtn);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._okBtn.addEventListener(MouseEvent.CLICK,this._okClick);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this._okClick);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
            this.sendStatInfo("no");
         }
      }
      
      private function _okClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
         LoaderSavingManager.cacheAble = true;
         LoaderSavingManager.saveFilesToLocal();
         this.sendStatInfo("yes");
      }
      
      private function sendStatInfo(status:String) : void
      {
         if(PathManager.solveParterId() == null)
         {
            return;
         }
         StatisticManager.Instance().startAction(StatisticManager.SAVEFILE,status);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         super.dispose();
         if(Boolean(this._novice))
         {
            ObjectUtils.disposeObject(this._novice);
         }
         this._novice = null;
         if(Boolean(this._npc))
         {
            ObjectUtils.disposeObject(this._npc);
         }
         this._npc = null;
         if(Boolean(this._okBtn))
         {
            ObjectUtils.disposeObject(this._okBtn);
         }
         this._okBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

