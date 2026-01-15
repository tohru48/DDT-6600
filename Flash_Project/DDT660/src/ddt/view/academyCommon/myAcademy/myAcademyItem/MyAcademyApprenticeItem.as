package ddt.view.academyCommon.myAcademy.myAcademyItem
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class MyAcademyApprenticeItem extends MyAcademyMasterItem implements Disposeable
   {
      
      public function MyAcademyApprenticeItem()
      {
         super();
      }
      
      override protected function initComponent() : void
      {
         _removeGold = 20000;
         _sexIcon.visible = false;
      }
      
      override protected function __removeClick(event:MouseEvent) : void
      {
         var baseAlerFrame:BaseAlerFrame = null;
         var alerFrame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"));
         if(!getTimerOvertop())
         {
            alertInfo.data = LanguageMgr.GetTranslation("ddt.view.academyCommon.myAcademy.MyAcademyMasterItem.remove",_info.NickName);
            baseAlerFrame = AlertManager.Instance.alert("academySimpleAlert",alertInfo,LayerManager.ALPHA_BLOCKGOUND);
            baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         }
         else
         {
            alertInfo.data = LanguageMgr.GetTranslation("ddt.view.academyCommon.myAcademy.MyAcademyApprenticeItem.removeIII",_info.NickName);
            alerFrame = AlertManager.Instance.alert("academySimpleAlert",alertInfo,LayerManager.ALPHA_BLOCKGOUND);
            alerFrame.addEventListener(FrameEvent.RESPONSE,__alerFrameEvent);
         }
      }
      
      override protected function __frameEvent(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         (event.currentTarget as BaseAlerFrame).dispose();
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.Gold >= 20000)
               {
                  this.submit();
               }
               else
               {
                  alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
                  alert.moveEnable = false;
                  alert.addEventListener(FrameEvent.RESPONSE,__quickBuyResponse);
               }
         }
      }
      
      override protected function submit() : void
      {
         SocketManager.Instance.out.sendAcademyFireApprentice(_info.ID);
      }
   }
}

