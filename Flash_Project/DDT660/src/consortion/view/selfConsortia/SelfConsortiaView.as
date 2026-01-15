package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SelfConsortiaView extends Sprite implements Disposeable
   {
      
      private var _BG:MovieImage;
      
      private var _infoView:ConsortionInfoView;
      
      private var _memberList:MemberList;
      
      private var _placardAndEvent:PlacardAndEvent;
      
      private var _buildingManager:BuildingManager;
      
      private var _DissolveConsortia:TextButton;
      
      public function SelfConsortiaView()
      {
         super();
      }
      
      public function enterSelfConsortion() : void
      {
         ConsortionModelControl.Instance.getConsortionMember(ConsortionModelControl.Instance.memberListComplete);
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.selfConsortionComplete,1,6,"",-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._DissolveConsortia = ComponentFactory.Instance.creat("DissolveConsortia");
         this._DissolveConsortia.text = LanguageMgr.GetTranslation("dismiss");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("consortion.BG");
         this._infoView = ComponentFactory.Instance.creatCustomObject("consortionInfoView");
         PositionUtils.setPos(this._infoView,"consortion.consortionInfoView.pos");
         this._memberList = ComponentFactory.Instance.creatCustomObject("memberList");
         PositionUtils.setPos(this._memberList,"consortion.memberList.pos");
         this._placardAndEvent = ComponentFactory.Instance.creatCustomObject("placardAndEvent");
         PositionUtils.setPos(this._placardAndEvent,"consortion.placardAndEvent.pos");
         this._buildingManager = ComponentFactory.Instance.creatCustomObject("buildingManager");
         PositionUtils.setPos(this._buildingManager,"consortion.buildingManager.pos");
         addChild(this._BG);
         addChild(this._infoView);
         addChild(this._memberList);
         addChild(this._placardAndEvent);
         addChild(this._buildingManager);
      }
      
      private function initEvent() : void
      {
      }
      
      private function __dissolve(event:MouseEvent) : void
      {
         SocketManager.Instance.out.sendConsortiaDismiss();
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         if(Boolean(this._infoView))
         {
            ObjectUtils.disposeObject(this._infoView);
         }
         if(Boolean(this._memberList))
         {
            ObjectUtils.disposeObject(this._memberList);
         }
         if(Boolean(this._placardAndEvent))
         {
            ObjectUtils.disposeObject(this._placardAndEvent);
         }
         if(Boolean(this._buildingManager))
         {
            ObjectUtils.disposeObject(this._buildingManager);
         }
         if(Boolean(this._DissolveConsortia))
         {
            ObjectUtils.disposeObject(this._DissolveConsortia);
         }
         this._BG = null;
         this._infoView = null;
         this._memberList = null;
         this._placardAndEvent = null;
         this._buildingManager = null;
         this._DissolveConsortia = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

