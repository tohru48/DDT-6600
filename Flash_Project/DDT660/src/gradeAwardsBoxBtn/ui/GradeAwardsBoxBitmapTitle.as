package gradeAwardsBoxBtn.ui
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class GradeAwardsBoxBitmapTitle implements Disposeable
   {
      
      public var _gradeBitmap:Bitmap;
      
      private var _gradeTextDic:Dictionary;
      
      public function GradeAwardsBoxBitmapTitle()
      {
         super();
         this._gradeTextDic = new Dictionary();
         this._gradeBitmap = new Bitmap();
      }
      
      public function init() : void
      {
         this.addGradeBitmap(10,ComponentFactory.Instance.creatBitmapData("asset.hall.grade10"));
         this.addGradeBitmap(12,ComponentFactory.Instance.creatBitmapData("asset.hall.grade12"));
         this.addGradeBitmap(16,ComponentFactory.Instance.creatBitmapData("asset.hall.grade16"));
         this.addGradeBitmap(19,ComponentFactory.Instance.creatBitmapData("asset.hall.grade19"));
      }
      
      public function addGradeBitmap(grade:int, bitmapData:BitmapData) : void
      {
         this._gradeTextDic[grade] = bitmapData;
      }
      
      public function setBitmapData(grade:int) : void
      {
         var bmd:BitmapData = this._gradeTextDic[grade];
         if(bmd != null)
         {
            this._gradeBitmap.bitmapData = bmd;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._gradeBitmap.bitmapData))
         {
            this._gradeBitmap.bitmapData.dispose();
         }
         this._gradeBitmap = null;
         this._gradeTextDic = null;
      }
   }
}

