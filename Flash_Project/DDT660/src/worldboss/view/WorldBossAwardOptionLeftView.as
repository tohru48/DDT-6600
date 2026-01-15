package worldboss.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import worldboss.WorldBossManager;
   
   public class WorldBossAwardOptionLeftView extends Sprite implements Disposeable
   {
      
      private var _ddtlittlegamebg:MovieImage;
      
      private var _previewLoader:BitmapLoader;
      
      private var _previewMap:Bitmap;
      
      private var _ddtlittlegamebg1:ScaleBitmapImage;
      
      private var _rankingView:WorldBossRankingView;
      
      public function WorldBossAwardOptionLeftView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._ddtlittlegamebg = ComponentFactory.Instance.creatComponentByStylename("ddtlittleGame.BG1");
         addChild(this._ddtlittlegamebg);
         this._ddtlittlegamebg1 = ComponentFactory.Instance.creatComponentByStylename("ddtlittleGameLeftViewBG1");
         addChild(this._ddtlittlegamebg1);
         this._previewLoader = LoadResourceManager.Instance.createLoader(WorldBossManager.Instance.getWorldbossResource() + "/preview/previewmap.png",BaseLoader.BITMAP_LOADER);
         this._previewLoader.addEventListener(LoaderEvent.COMPLETE,this.__previewMapComplete);
         LoadResourceManager.Instance.startLoad(this._previewLoader);
      }
      
      private function __previewMapComplete(evt:LoaderEvent) : void
      {
         if(evt.loader.isSuccess)
         {
            evt.loader.removeEventListener(LoaderEvent.COMPLETE,this.__previewMapComplete);
            ObjectUtils.disposeObject(this._previewMap);
            this._previewMap = null;
            this._previewMap = evt.loader.content as Bitmap;
            addChildAt(this._previewMap,1);
            PositionUtils.setPos(this._previewMap,"asset.worldbossAwardRoom.previewMap");
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._ddtlittlegamebg1);
         this._ddtlittlegamebg1 = null;
         ObjectUtils.disposeObject(this._ddtlittlegamebg);
         this._ddtlittlegamebg = null;
         ObjectUtils.disposeObject(this._previewMap);
         this._previewMap = null;
         ObjectUtils.disposeObject(this._rankingView);
         this._rankingView = null;
      }
   }
}

