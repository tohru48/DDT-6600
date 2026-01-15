package equipretrieve.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   
   public class RetrieveHelpFrame extends BaseAlerFrame
   {
      
      private var _BG:MovieClip;
      
      private var _helpBg:Scale9CornerImage;
      
      private var _alertInfo:AlertInfo;
      
      public function RetrieveHelpFrame()
      {
         super();
         this.setView();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.equipretrieve.helpTip"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("close"),true,false);
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         info.escEnable = true;
         this._helpBg = ComponentFactory.Instance.creatComponentByStylename("ddtequipretrieve.help.BG1");
         this._BG = ClassUtils.CreatInstance("equipretrieve.helpInfoBg");
         this._BG.x = 60;
         this._BG.y = 75;
         addToContent(this._helpBg);
         addToContent(this._BG);
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

