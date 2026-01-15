package worldboss.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.core.Component;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import worldboss.WorldBossManager;
   import worldboss.model.WorldBossBuffInfo;
   
   public class BuffItem extends Component
   {
      
      private var _buffId:int;
      
      public function BuffItem(id:int)
      {
         super();
         this._buffId = id;
         this.initView();
      }
      
      private function initView() : void
      {
         var buffIconLoader:BitmapLoader = LoadResourceManager.Instance.createLoader(WorldBossRoomView.getImagePath(this._buffId),BaseLoader.BITMAP_LOADER);
         buffIconLoader.addEventListener(LoaderEvent.COMPLETE,this.__buffIconComplete);
         LoadResourceManager.Instance.startLoad(buffIconLoader);
      }
      
      private function __buffIconComplete(evt:LoaderEvent) : void
      {
         var buffBitmap:Bitmap = null;
         if(evt.loader.isSuccess)
         {
            evt.loader.removeEventListener(LoaderEvent.COMPLETE,this.__buffIconComplete);
            buffBitmap = evt.loader.content as Bitmap;
            buffBitmap.width = 50;
            buffBitmap.height = 50;
            addChild(buffBitmap);
         }
         tipStyle = "ddt.view.tips.OneLineTip";
         tipDirctions = "5,1";
         var buffInfo:WorldBossBuffInfo = WorldBossManager.Instance.bossInfo.getbuffInfoByID(this._buffId);
         tipData = buffInfo.name + ":" + LanguageMgr.GetTranslation("worldboss.buff.limit") + "\n" + buffInfo.decription;
      }
   }
}

