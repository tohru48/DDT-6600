package store.view.fusion
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import store.data.PreviewInfoII;
   
   public class PreviewItem extends Sprite implements Disposeable
   {
      
      private var _cell:PreviewItemCell;
      
      private var rate_txt:FilterFrameText;
      
      private var title_txt:FilterFrameText;
      
      public function PreviewItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var bg:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("store.PreviewBG");
         addChild(bg);
         this.rate_txt = ComponentFactory.Instance.creatComponentByStylename("store.PreviewSuccessRateTxt");
         addChild(this.rate_txt);
         this.title_txt = ComponentFactory.Instance.creatComponentByStylename("store.PreviewNameTxt");
         addChild(this.title_txt);
         this._cell = ComponentFactory.Instance.creatCustomObject("store.PreviewItemCell");
         this._cell.allowDrag = false;
         addChild(this._cell);
      }
      
      public function set info($info:PreviewInfoII) : void
      {
         this._cell.info = $info.info;
         this.rate_txt.text = $info.rate <= 5 ? LanguageMgr.GetTranslation("store.fusion.preview.LowRate") : String($info.rate) + "%";
         this.title_txt.text = String($info.info.Name);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(Boolean(this.rate_txt))
         {
            ObjectUtils.disposeObject(this.rate_txt);
         }
         this.rate_txt = null;
         if(Boolean(this.title_txt))
         {
            ObjectUtils.disposeObject(this.title_txt);
         }
         this.title_txt = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

