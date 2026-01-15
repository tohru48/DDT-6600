package room.transnational
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class RoomLoadingTransnationalFieldItem extends Sprite implements Disposeable
   {
      
      private var _bg:Scale9CornerImage;
      
      private var _bitmap:Bitmap;
      
      private var _flag:DisplayLoader;
      
      public function RoomLoadingTransnationalFieldItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtTransnationalFlagBg");
         addChild(this._bg);
      }
      
      private function solveFlagPath(type:int) : String
      {
         return PathManager.SITE_MAIN + "image/flag/" + type + ".png";
      }
      
      public function set FlagID(value:int) : void
      {
         this._flag = LoaderManager.Instance.creatLoader(this.solveFlagPath(value),BaseLoader.BITMAP_LOADER);
         this._flag.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoaderManager.Instance.startLoad(this._flag);
      }
      
      private function __onLoadComplete(evt:LoaderEvent) : void
      {
         if(Boolean(evt.currentTarget.isSuccess))
         {
            if(evt.currentTarget == this._flag)
            {
               this._bitmap = Bitmap(this._flag.content);
            }
         }
         if(Boolean(this._bitmap))
         {
            addChild(this._bitmap);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         if(Boolean(this._bitmap))
         {
            ObjectUtils.disposeObject(this._bitmap);
         }
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

