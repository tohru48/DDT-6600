package room.transnational
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class NationField extends Sprite
   {
      
      private var _bg:Image;
      
      private var _nationFlag:Bitmap;
      
      private var _nationText:FilterFrameText;
      
      private var _flag:DisplayLoader;
      
      public function NationField()
      {
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddt.Transnational.smallFlagBg");
         this._nationText = ComponentFactory.Instance.creatComponentByStylename("Transnational.NationField.Txt");
         addChild(this._bg);
         addChild(this._nationText);
      }
      
      public function setNationId(value:int) : void
      {
         this._flag = LoaderManager.Instance.creatLoader(this.solveNationPath(value),BaseLoader.BITMAP_LOADER);
         this._flag.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoaderManager.Instance.startLoad(this._flag);
         this._nationText.text = LanguageMgr.GetTranslation("ddt.transnationalFlag.name_" + value);
      }
      
      private function __onLoadComplete(evt:LoaderEvent) : void
      {
         if(Boolean(evt.currentTarget.isSuccess))
         {
            if(evt.currentTarget == this._flag)
            {
               this._nationFlag = Bitmap(this._flag.content);
            }
         }
         if(Boolean(this._nationFlag))
         {
            addChild(this._nationFlag);
         }
      }
      
      private function solveNationPath(type:int) : String
      {
         return PathManager.SITE_MAIN + "image/flag/" + type + "-" + type + ".png";
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._nationFlag))
         {
            ObjectUtils.disposeObject(this._nationFlag);
            this._nationFlag = null;
         }
         if(Boolean(this._nationText))
         {
            ObjectUtils.disposeObject(this._nationText);
            this._nationText = null;
         }
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}

