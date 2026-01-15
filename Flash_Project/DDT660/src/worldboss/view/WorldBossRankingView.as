package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   import worldboss.player.RankingPersonInfo;
   
   public class WorldBossRankingView extends Component
   {
      
      private var _titleBg:Bitmap;
      
      private var _container:VBox;
      
      public function WorldBossRankingView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._container = ComponentFactory.Instance.creatComponentByStylename("worldBossAward.rankingView.vbox");
         addChild(this._container);
      }
      
      public function set rankingInfos(val:Vector.<RankingPersonInfo>) : void
      {
         var info:RankingPersonInfo = null;
         var item:RankingPersonInfoItem = null;
         var size:Rectangle = null;
         if(val == null)
         {
            return;
         }
         var no:int = 1;
         for each(info in val)
         {
            item = new RankingPersonInfoItem(no++,info,true);
            size = ComponentFactory.Instance.creatCustomObject("worldbossAward.rankingItemSize");
            this._container.addChild(item);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._container);
         this._container = null;
      }
   }
}

