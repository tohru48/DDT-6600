package lottery
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.utils.RequestVairableCreater;
   import flash.net.URLVariables;
   import lottery.data.LotteryWorldWagerAnalyzer;
   
   public class LotteryManger
   {
      
      public function LotteryManger()
      {
         super();
      }
      
      public function setup() : void
      {
      }
      
      public function refreshTotalAmount() : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("Casdfsdf.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.data.analyze.MyAcademyPlayersAnalyze");
         loader.analyzer = new LotteryWorldWagerAnalyzer(this.onLoadCardLotteryInfoComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoaderManager.Instance.startLoad(loader);
      }
      
      private function onLoadCardLotteryInfoComplete(analyzer:LotteryWorldWagerAnalyzer) : void
      {
         analyzer.worldWager;
      }
      
      private function __onLoadError(evt:LoaderEvent) : void
      {
      }
   }
}

