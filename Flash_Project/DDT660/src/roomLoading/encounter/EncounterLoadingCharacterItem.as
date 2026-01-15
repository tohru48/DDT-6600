package roomLoading.encounter
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import room.events.RoomPlayerEvent;
   import room.model.RoomPlayer;
   import roomLoading.view.RoomLoadingCharacterItem;
   
   public class EncounterLoadingCharacterItem extends RoomLoadingCharacterItem
   {
      
      protected var _nameBG:Bitmap;
      
      protected var _sexIcon:ScaleFrameImage;
      
      protected var _bubble:MovieClip;
      
      protected var _arrow:ScaleFrameImage;
      
      public function EncounterLoadingCharacterItem($info:RoomPlayer)
      {
         super($info);
      }
      
      override protected function init() : void
      {
         if(_info.team == RoomPlayer.BLUE_TEAM)
         {
            _perecentageTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemPercentageBlueTxt");
         }
         else
         {
            _perecentageTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemPercentageRedTxt");
         }
         _perecentageTxt.text = "0%";
         _info.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,__onProgress);
         _info.character.scaleX = _info.playerInfo.Sex ? 1 : -1;
         _info.character.stopAnimation();
         _info.character.setShowLight(false);
         _info.character.showWing = false;
         _info.character.showGun = false;
         addChild(_info.character);
         addChild(_perecentageTxt);
         this._sexIcon = UICreatShortcut.creatAndAdd("roomLoading.encounter.EncounterLoadingCharacterItem.sexIcon",this);
         this._sexIcon.setFrame(info.playerInfo.Sex ? 2 : 1);
         this._bubble = UICreatShortcut.creatAndAdd("roomLoading.EncounterLoadingView.select",this);
         this._bubble.visible = PlayerManager.Instance.Self.Sex != info.playerInfo.Sex;
         this._arrow = UICreatShortcut.creatAndAdd("roomLoading.EncounterLoadingView.arrow",this);
         this._arrow.visible = false;
         if(info.playerInfo.Sex)
         {
            this._arrow.setFrame(2);
         }
         else
         {
            this._arrow.setFrame(1);
            PositionUtils.setPos(this._arrow,"roomLoading.EncounterLoadingView.arrowPos2");
         }
         _iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.roomLoadingPlayerItem.iconContainer");
         this.initIcons();
      }
      
      override protected function initIcons() : void
      {
         super.initIcons();
         _levelIcon.parent.removeChild(_levelIcon);
      }
      
      protected function __onClick(event:MouseEvent) : void
      {
         this._arrow.rotation += 4;
      }
      
      public function set selectObject(type:int) : void
      {
         this._arrow.visible = true;
         switch(type)
         {
            case 1:
               break;
            case 2:
               if(info.playerInfo.Sex)
               {
                  this._arrow.rotation = 16;
               }
               else
               {
                  this._arrow.rotation = -20;
               }
               break;
            case 3:
               if(info.playerInfo.Sex)
               {
                  this._arrow.rotation = -12;
               }
               else
               {
                  this._arrow.rotation = 12;
               }
         }
      }
      
      public function set arrowVisible(value:Boolean) : void
      {
         this._arrow.visible = value;
         this._bubble.visible = false;
      }
      
      public function set bubbleVisible(value:Boolean) : void
      {
         this._bubble.visible = value;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._nameBG);
         this._nameBG = null;
         ObjectUtils.disposeObject(this._sexIcon);
         this._sexIcon = null;
         ObjectUtils.disposeObject(this._bubble);
         this._bubble = null;
         ObjectUtils.disposeObject(this._arrow);
         this._arrow = null;
         super.dispose();
      }
   }
}

