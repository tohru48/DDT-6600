package entertainmentMode.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import room.model.RoomInfo;
   
   public class EntertainmentListItem extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _roomPlayerNumTxt:FilterFrameText;
      
      private var _info:RoomInfo;
      
      public function EntertainmentListItem(info:RoomInfo = null)
      {
         super();
         this._info = info;
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.Entertainment.mode.random");
         addChild(this._bg);
         this._roomPlayerNumTxt = ComponentFactory.Instance.creat("asset.entertainment.roomPlayerNum");
         addChild(this._roomPlayerNumTxt);
         this.update();
      }
      
      public function set info(value:RoomInfo) : void
      {
         this._info = value;
         this.update();
      }
      
      public function get info() : RoomInfo
      {
         return this._info;
      }
      
      private function update() : void
      {
         if(Boolean(this.info))
         {
            this._roomPlayerNumTxt.text = String(this._info.totalPlayer) + "/" + String(this._info.placeCount);
            if(this._info.isPlaying)
            {
               filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
               filters = null;
            }
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._roomPlayerNumTxt);
         this._roomPlayerNumTxt = null;
      }
   }
}

