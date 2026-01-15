package littleGame.view
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
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class OptionLeftView extends Sprite implements Disposeable
   {
      
      private var _ddtlittlegamebg:MovieImage;
      
      private var _previewLoader:BitmapLoader;
      
      private var _previewMap:Bitmap;
      
      private var _ddtlittlegamebg1:ScaleBitmapImage;
      
      public function OptionLeftView()
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
         this._previewLoader = LoadResourceManager.Instance.createLoader(PathManager.solveLittleGameMapPreview(1),BaseLoader.BITMAP_LOADER);
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
            PositionUtils.setPos(this._previewMap,"littleGame.previewMap.pos");
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._previewLoader))
         {
            this._previewLoader.removeEventListener(LoaderEvent.COMPLETE,this.__previewMapComplete);
         }
         this._previewLoader = null;
         ObjectUtils.disposeObject(this._ddtlittlegamebg1);
         this._ddtlittlegamebg1 = null;
         ObjectUtils.disposeObject(this._ddtlittlegamebg);
         this._ddtlittlegamebg = null;
         ObjectUtils.disposeObject(this._previewMap);
         this._previewMap = null;
      }
   }
}

