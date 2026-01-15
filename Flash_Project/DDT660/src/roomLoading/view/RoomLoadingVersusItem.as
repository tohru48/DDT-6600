package roomLoading.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class RoomLoadingVersusItem extends Sprite implements Disposeable
   {
      
      private var _gameType:Bitmap;
      
      private var _gameTypeBg:Bitmap;
      
      private var _versusMc:DisplayObject;
      
      private var _gameMode:int;
      
      private var _glowFilter:GlowFilter;
      
      public function RoomLoadingVersusItem($gameMode:int)
      {
         super();
         this._gameMode = $gameMode;
         this.init();
      }
      
      private function init() : void
      {
         this._glowFilter = new GlowFilter();
         this._versusMc = ComponentFactory.Instance.creat("asset.roomloading.versus");
         this._gameTypeBg = ComponentFactory.Instance.creatBitmap("asset.roomloading.gameTypeBg");
         PositionUtils.setPos(this._versusMc,"asset.roomLoading.VersusAnimationPos");
         PositionUtils.setPos(this._gameTypeBg,"asset.roomLoading.GameTypeBgPos");
         addChild(this._versusMc);
         addChild(this._gameTypeBg);
         this.createGameModeTxt();
         TweenMax.from(this._gameType,1,{
            "alpha":0,
            "delay":1
         });
         TweenMax.from(this._gameTypeBg,1,{
            "alpha":0,
            "delay":1
         });
      }
      
      private function addEffect() : void
      {
         TweenMax.to(this._glowFilter,0.45,{
            "startAt":{
               "blurX":0,
               "blurY":0,
               "color":16763904,
               "strength":0
            },
            "blurX":5,
            "blurY":5,
            "color":16737792,
            "strength":0.6,
            "yoyo":true,
            "repeat":-1,
            "ease":Sine.easeOut,
            "onUpdate":this.updateFilter
         });
      }
      
      private function updateFilter() : void
      {
         this._gameType.filters = [this._glowFilter];
      }
      
      private function createGameModeTxt() : void
      {
         if(this._gameMode == 7)
         {
            if(RoomManager.Instance.current.type == RoomInfo.CRYPTBOSS_ROOM)
            {
               this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_41");
            }
         }
         if(!this._gameType)
         {
            switch(this._gameMode)
            {
               case 0:
               case 4:
               case 9:
               case 11:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_0");
                  break;
               case 1:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_1");
                  break;
               case 2:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_2");
                  break;
               case 7:
               case 10:
               case 30:
               case 50:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_7");
                  break;
               case 8:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_8");
                  break;
               case 12:
               case 13:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_12");
                  break;
               case 15:
               case 16:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_14");
                  break;
               case 17:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_17");
                  break;
               case 21:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_21");
                  break;
               case 22:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_22");
                  break;
               case GameManager.CAMP_BATTLE_MODEL_PVE:
               case GameManager.CAMP_BATTLE_MODEL_PVP:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_24");
                  break;
               case 25:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_7");
                  break;
               case GameManager.RING_STATION_MODEL:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_26");
                  break;
               case GameManager.CHRISTMAS_MODEL:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_40");
                  break;
               case GameManager.CATCH_BEAST_MODEL:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_7");
                  break;
               case RoomInfo.TREASURELOST_ROOM:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_7");
                  break;
               case GameManager.BOMB_KING_FIRST_MODEL:
               case GameManager.BOMB_KING_FINAL_MODEL:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_3");
                  break;
               case GameManager.RESCUE_MODEL:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_43");
                  break;
               case GameManager.CATCH_INSECT_MODEL:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_42");
                  break;
               default:
                  this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_0");
            }
         }
         if(Boolean(this._gameType))
         {
            addChild(this._gameType);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._gameType))
         {
            TweenMax.killTweensOf(this._gameType);
         }
         if(Boolean(this._glowFilter))
         {
            TweenMax.killTweensOf(this._glowFilter);
         }
         if(Boolean(this._gameType))
         {
            this._gameType.filters = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._gameType = null;
         this._gameTypeBg = null;
         this._glowFilter = null;
         this._versusMc = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

