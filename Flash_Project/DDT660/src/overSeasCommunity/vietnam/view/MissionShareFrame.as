package overSeasCommunity.vietnam.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import room.RoomManager;
   
   public class MissionShareFrame extends BaseAlerFrame
   {
      
      private var _alertInfo:AlertInfo;
      
      private var _bossImage:Image;
      
      private var _descTxt:FilterFrameText;
      
      public function MissionShareFrame()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("community.MissionShareFrame.titleText");
         this._alertInfo.moveEnable = true;
         info = this._alertInfo;
         this.escEnable = true;
         this._bossImage = ComponentFactory.Instance.creat("community.MissionShareFrame.boss");
         addToContent(this._bossImage);
         this._descTxt = ComponentFactory.Instance.creat("community.MissionShareFrame.destTxt");
         this._descTxt.text = LanguageMgr.GetTranslation("community.mission.boss.desc");
         addToContent(this._descTxt);
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.confirmSubmit();
               this.dispose();
         }
      }
      
      private function get mapId() : int
      {
         return Boolean(RoomManager.Instance.current) ? RoomManager.Instance.current.mapId : 1;
      }
      
      private function confirmSubmit() : void
      {
         var message:String = LanguageMgr.GetTranslation("community.mission.boss.message");
         var desc:String = LanguageMgr.GetTranslation("community.mission.boss.desc");
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

