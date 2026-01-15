package campbattle.view.roleView
{
   import campbattle.CampBattleManager;
   import campbattle.data.RoleData;
   import campbattle.event.MapEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   
   public class CampBattleOtherRole extends CampBattlePlayer
   {
      
      private var _sword:MovieClip;
      
      public function CampBattleOtherRole(playerInfo:RoleData = null, callBack:Function = null)
      {
         super(playerInfo,callBack);
         if(playerInfo.team != CampBattleManager.instance.model.myTeam)
         {
            buttonMode = true;
         }
         this._sword = ComponentFactory.Instance.creat("asset.CampBattle.overEnemySword");
         addChild(this._sword);
         this._sword.visible = false;
      }
      
      override protected function __onMouseOut(event:MouseEvent) : void
      {
         if(Boolean(this._sword))
         {
            this._sword.visible = false;
         }
         Mouse.show();
         removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHander);
         super.__onMouseOut(event);
      }
      
      override protected function __onMouseOver(event:MouseEvent) : void
      {
         if(CampBattleManager.instance.model.myTeam != _playerInfo.team || _playerInfo.stateType == 2)
         {
            if(Boolean(this._sword))
            {
               this._sword.visible = true;
            }
            Mouse.hide();
            addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHander);
            super.__onMouseOver(event);
         }
      }
      
      protected function mouseMoveHander(event:MouseEvent) : void
      {
         if(Boolean(this._sword))
         {
            this._sword.x = mouseX;
            this._sword.y = mouseY;
         }
      }
      
      override protected function __onMouseClick(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         if(_playerInfo.team != CampBattleManager.instance.model.myTeam)
         {
            CampBattleManager.instance.dispatchEvent(new MapEvent(MapEvent.GOTO_FIGHT,[_playerInfo.posX,_playerInfo.posY,_playerInfo.zoneID,_playerInfo.ID]));
         }
         else if(_playerInfo.stateType == 2)
         {
            CampBattleManager.instance.dispatchEvent(new MapEvent(MapEvent.GOTO_FIGHT,[_playerInfo.posX,_playerInfo.posY,_playerInfo.zoneID,_playerInfo.ID]));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._sword);
         this._sword = null;
      }
   }
}

