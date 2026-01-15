package bombKing.components
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BKingPlayerTip extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _viewInfo:IconButton;
      
      private var userId:int;
      
      private var areaId:int;
      
      public function BKingPlayerTip()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bombKing.tipsBg");
         addChild(this._bg);
         this._viewInfo = ComponentFactory.Instance.creatComponentByStylename("bombKing.viewInfo");
         addChild(this._viewInfo);
      }
      
      private function initEvents() : void
      {
         this._viewInfo.addEventListener(MouseEvent.CLICK,this.__onViewInfo);
      }
      
      protected function __onViewInfo(event:MouseEvent) : void
      {
         if(Boolean(this.userId))
         {
            PlayerInfoViewControl.viewByID(this.userId,this.areaId,true,false,true);
            PlayerInfoViewControl.isOpenFromBag = false;
         }
      }
      
      public function setUserId(userId:int, areaId:int) : void
      {
         this.userId = userId;
         this.areaId = areaId;
      }
      
      private function removeEvents() : void
      {
         this._viewInfo.addEventListener(MouseEvent.CLICK,this.__onViewInfo);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._viewInfo);
         this._viewInfo = null;
      }
   }
}

