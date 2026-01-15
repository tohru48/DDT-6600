package room.view.smallMapInfoPanel
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.view.chooseMap.ChallengeChooseMapView;
   
   public class ChallengeRoomSmallMapInfoPanel extends MatchRoomSmallMapInfoPanel implements Disposeable
   {
      
      private var _titleLoader:DisplayLoader;
      
      private var _titleIconContainer:Sprite;
      
      public function ChallengeRoomSmallMapInfoPanel()
      {
         super();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this._titleIconContainer);
         _info.selfRoomPlayer.removeEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__update);
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      override public function set info(value:RoomInfo) : void
      {
         super.info = value;
         if(Boolean(_info))
         {
            _info.selfRoomPlayer.addEventListener(RoomPlayerEvent.IS_HOST_CHANGE,this.__update);
         }
         if(Boolean(_info) && _info.selfRoomPlayer.isHost)
         {
            buttonMode = true;
            addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         else
         {
            buttonMode = true;
            removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
         this.__update();
      }
      
      public function shine() : void
      {
      }
      
      public function stopShine() : void
      {
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._titleIconContainer = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.challenge.chooseMap.titleSprite");
         _timeType.setFrame(2);
         addChild(this._titleIconContainer);
         this._titleIconContainer.visible = false;
         buttonMode = true;
      }
      
      override protected function __onClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("045");
         var mapChooser:ChallengeChooseMapView = new ChallengeChooseMapView();
         mapChooser.show();
      }
      
      private function __update(evt:RoomPlayerEvent = null) : void
      {
         if(_info.selfRoomPlayer.isHost)
         {
            addEventListener(MouseEvent.CLICK,this.__onClick);
         }
         else
         {
            removeEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      override protected function updateView() : void
      {
         this._titleIconContainer.visible = _info.mapId != 0;
         super.updateView();
         if(Boolean(this._titleLoader))
         {
            this._titleLoader = null;
         }
         this._titleLoader = LoadResourceManager.Instance.createLoader(this.titlePath(),BaseLoader.BITMAP_LOADER);
         this._titleLoader.addEventListener(LoaderEvent.COMPLETE,this.__titleCompleteHandler);
         LoadResourceManager.Instance.startLoad(this._titleLoader);
      }
      
      private function __titleCompleteHandler(evt:LoaderEvent) : void
      {
         ObjectUtils.disposeAllChildren(this._titleIconContainer);
         if(evt.loader.isSuccess)
         {
            evt.loader.removeEventListener(LoaderEvent.COMPLETE,this.__titleCompleteHandler);
            this._titleIconContainer.addChild(evt.loader.content as Bitmap);
         }
      }
      
      private function titlePath() : String
      {
         if(Boolean(_info) && _info.mapId > 0)
         {
            return PathManager.SITE_MAIN + "image/map/" + _info.mapId.toString() + "/icon.png";
         }
         return PathManager.SITE_MAIN + "image/map/0/icon.png";
      }
   }
}

