package fightFootballTime.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import room.events.RoomPlayerEvent;
   import room.model.RoomPlayer;
   
   public class FightFootballTimeLoadingCharacterItem extends Sprite implements Disposeable
   {
      
      public static const LOADING_FINISHED:String = "loadingFinished";
      
      protected var _perecentageTxt:FilterFrameText;
      
      protected var _okTxt:Bitmap;
      
      protected var _info:RoomPlayer;
      
      public function FightFootballTimeLoadingCharacterItem($info:RoomPlayer)
      {
         super();
         this._info = $info;
      }
      
      protected function init() : void
      {
         this._perecentageTxt = ComponentFactory.Instance.creatComponentByStylename("roomLoading.CharacterItemPercentageBlueTxt");
         this._perecentageTxt.text = "0%";
         this._info.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
         addChild(this._perecentageTxt);
      }
      
      protected function __onProgress(event:RoomPlayerEvent) : void
      {
         var pos:Point = null;
         this._perecentageTxt.text = String(int(this._info.progress)) + "%";
         if(this._info.progress > 99)
         {
            this._okTxt = ComponentFactory.Instance.creatBitmap("asset.roomLoading.LoadingOK");
            pos = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.LoadingOKStartPos");
            TweenMax.from(this._okTxt,0.5,{
               "alpha":0,
               "scaleX":2,
               "scaleY":2,
               "x":pos.x,
               "y":pos.y,
               "ease":Quint.easeIn,
               "onStart":this.finishTxt
            });
            addChild(this._okTxt);
            this._info.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
            dispatchEvent(new Event(LOADING_FINISHED));
         }
      }
      
      protected function finishTxt() : void
      {
         this._perecentageTxt.text = "100%";
         this.removeTxt();
      }
      
      protected function removeTxt() : void
      {
         if(Boolean(this._perecentageTxt))
         {
            this._perecentageTxt.parent.removeChild(this._perecentageTxt);
         }
      }
      
      public function dispose() : void
      {
         this._info.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onProgress);
         TweenMax.killTweensOf(this._okTxt);
         if(Boolean(this._perecentageTxt))
         {
            ObjectUtils.disposeObject(this._perecentageTxt);
         }
         this._perecentageTxt = null;
         if(Boolean(this._okTxt))
         {
            ObjectUtils.disposeObject(this._okTxt);
         }
         this._okTxt = null;
      }
   }
}

