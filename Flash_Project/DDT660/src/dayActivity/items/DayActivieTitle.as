package dayActivity.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class DayActivieTitle extends Sprite implements Disposeable
   {
      
      private var _bg:MovieClip;
      
      private var _txt1:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _txt3:FilterFrameText;
      
      private var _txt4:FilterFrameText;
      
      public function DayActivieTitle()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var line1:Bitmap = null;
         var line2:Bitmap = null;
         var line3:Bitmap = null;
         var line4:Bitmap = null;
         this._bg = ComponentFactory.Instance.creat("asset.consortion.menberList.bg2");
         this._bg.width = 720;
         this._bg.height = 375;
         this._bg.x = 27;
         this._bg.y = 92;
         addChild(this._bg);
         this._txt1 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.title.itemTxt");
         this._txt1.text = LanguageMgr.GetTranslation("ddt.dayActivity.activityName");
         this._txt1.x = 50;
         this._txt1.y = 102;
         addChild(this._txt1);
         this._txt2 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.title.itemTxt");
         this._txt2.text = LanguageMgr.GetTranslation("ddt.dayActivity.activitytime");
         this._txt2.x = 189;
         this._txt2.y = 100;
         addChild(this._txt2);
         this._txt3 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.title.itemTxt");
         this._txt3.text = LanguageMgr.GetTranslation("ddt.dayActivity.activityNum");
         this._txt3.x = 330;
         this._txt3.y = 100;
         addChild(this._txt3);
         this._txt4 = ComponentFactory.Instance.creatComponentByStylename("day.activieView.title.itemTxt");
         this._txt4.text = LanguageMgr.GetTranslation("ddt.dayActivity.activityOpen");
         this._txt4.x = 494;
         this._txt4.y = 100;
         addChild(this._txt4);
         line1 = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         line1.x = 140;
         line1.y = 93;
         addChild(line1);
         line2 = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         line2.x = 300;
         line2.y = 93;
         addChild(line2);
         line3 = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         line3.x = 430;
         line3.y = 93;
         addChild(line3);
         line4 = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         line4.x = 620;
         line4.y = 93;
         addChild(line4);
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

