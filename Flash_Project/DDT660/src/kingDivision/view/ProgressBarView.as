package kingDivision.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import kingDivision.KingDivisionManager;
   
   public class ProgressBarView extends Sprite implements Disposeable
   {
      
      private var _zoneIndex:int;
      
      private var _dateArr:Array;
      
      private var _zoneImg:ScaleFrameImage;
      
      private var _fristRound:Bitmap;
      
      private var _secondRound:Bitmap;
      
      private var _semifinal:Bitmap;
      
      private var _finals:Bitmap;
      
      private var _proBarAllMovie:MovieClip;
      
      private var _dateAndTimeTxt_Qua:FilterFrameText;
      
      private var _dateAndTimeTxt_FriRou:FilterFrameText;
      
      private var _dateAndTimeTxt_SecRou:FilterFrameText;
      
      private var _dateAndTimeTxt_Sem:FilterFrameText;
      
      private var _dateAndTimeTxt_Fin:FilterFrameText;
      
      private var _index:int;
      
      public function ProgressBarView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._zoneImg = ComponentFactory.Instance.creatComponentByStylename("kingDivision.progressBarView.zoneImg");
         this._zoneImg.setFrame(KingDivisionManager.Instance.zoneIndex + 1);
         this._fristRound = ComponentFactory.Instance.creatBitmap("asset.progressbar.fristRound");
         this._secondRound = ComponentFactory.Instance.creatBitmap("asset.progressbar.secondRound");
         this._semifinal = ComponentFactory.Instance.creatBitmap("asset.progressbar.semifinal");
         this._finals = ComponentFactory.Instance.creatBitmap("asset.progressbar.finals");
         this._proBarAllMovie = ComponentFactory.Instance.creatCustomObject("asset.progressbar.proBarAllMovie");
         addChild(this._zoneImg);
         addChild(this._fristRound);
         addChild(this._secondRound);
         addChild(this._semifinal);
         addChild(this._finals);
         addChild(this._proBarAllMovie);
         this.addDateAndTime(KingDivisionManager.Instance.dateArr,KingDivisionManager.Instance.model.consortiaMatchStartTime);
      }
      
      public function updateZoneImg(value:int) : void
      {
         this._zoneImg.setFrame(value + 1);
         if(value == 0)
         {
            this.updateDateAndTime(KingDivisionManager.Instance.dateArr,KingDivisionManager.Instance.model.consortiaMatchStartTime);
         }
         else if(value == 1)
         {
            this.updateDateAndTime(KingDivisionManager.Instance.allDateArr,KingDivisionManager.Instance.model.consortiaMatchStartTime);
         }
      }
      
      private function addDateAndTime(dateArr:Array, timeArr:Array) : void
      {
         this._dateAndTimeTxt_Qua = ComponentFactory.Instance.creatComponentByStylename("progressBarView.dateAndTimeTxt0");
         this._dateAndTimeTxt_FriRou = ComponentFactory.Instance.creatComponentByStylename("progressBarView.dateAndTimeTxt1");
         this._dateAndTimeTxt_SecRou = ComponentFactory.Instance.creatComponentByStylename("progressBarView.dateAndTimeTxt2");
         this._dateAndTimeTxt_Sem = ComponentFactory.Instance.creatComponentByStylename("progressBarView.dateAndTimeTxt3");
         this._dateAndTimeTxt_Fin = ComponentFactory.Instance.creatComponentByStylename("progressBarView.dateAndTimeTxt4");
         this.updateDateAndTime(dateArr,timeArr);
         addChild(this._dateAndTimeTxt_Qua);
         addChild(this._dateAndTimeTxt_FriRou);
         addChild(this._dateAndTimeTxt_SecRou);
         addChild(this._dateAndTimeTxt_Sem);
         addChild(this._dateAndTimeTxt_Fin);
      }
      
      private function updateDateAndTime(dateArr:Array, timeArr:Array) : void
      {
         if(dateArr == null || timeArr == null)
         {
            return;
         }
         this._dateAndTimeTxt_Qua.text = LanguageMgr.GetTranslation("kingDivision.progressBarView.dateAndTimeTxt",dateArr[0],timeArr[0],timeArr[1]);
         this._dateAndTimeTxt_FriRou.text = LanguageMgr.GetTranslation("kingDivision.progressBarView.dateAndTimeTxt",dateArr[1],timeArr[0],timeArr[1]);
         this._dateAndTimeTxt_SecRou.text = LanguageMgr.GetTranslation("kingDivision.progressBarView.dateAndTimeTxt",dateArr[2],timeArr[0],timeArr[1]);
         this._dateAndTimeTxt_Sem.text = LanguageMgr.GetTranslation("kingDivision.progressBarView.dateAndTimeTxt",dateArr[3],timeArr[0],timeArr[1]);
         this._dateAndTimeTxt_Fin.text = LanguageMgr.GetTranslation("kingDivision.progressBarView.dateAndTimeTxt",dateArr[4],timeArr[0],timeArr[1]);
      }
      
      public function dispose() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get proBarAllMovie() : MovieClip
      {
         return this._proBarAllMovie;
      }
      
      public function set proBarAllMovie(value:MovieClip) : void
      {
         this._proBarAllMovie = value;
      }
   }
}

