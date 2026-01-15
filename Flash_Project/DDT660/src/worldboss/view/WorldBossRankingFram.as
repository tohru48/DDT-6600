package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import worldboss.player.RankingPersonInfo;
   
   public class WorldBossRankingFram extends BaseAlerFrame
   {
      
      public static var _rankingPersons:Array = new Array();
      
      private var titleLineBg:MutipleImage;
      
      private var titleBg:MovieImage;
      
      private var numTitle:FilterFrameText;
      
      private var nameTitle:FilterFrameText;
      
      private var souceTitle:FilterFrameText;
      
      private var _sureBtn:TextButton;
      
      public function WorldBossRankingFram()
      {
         super();
         try
         {
            this._init();
         }
         catch(error:Error)
         {
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_COREI);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__onCoreiLoaded);
         }
      }
      
      private function __onCoreiLoaded(pEvent:UIModuleEvent) : void
      {
         if(pEvent.module == UIModuleTypes.DDT_COREI)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onCoreiLoaded);
            this._init();
         }
      }
      
      public function _init() : void
      {
         titleText = LanguageMgr.GetTranslation("worldboss.ranking.title");
         this.titleBg = ComponentFactory.Instance.creatComponentByStylename("worldboss.RankingFrame.RankingTitleBg");
         addToContent(this.titleBg);
         this.titleLineBg = ComponentFactory.Instance.creatComponentByStylename("worldboss.RankingItem.bgLine");
         addToContent(this.titleLineBg);
         this.numTitle = ComponentFactory.Instance.creatComponentByStylename("worldboss.ranking.numTitle");
         this.numTitle.text = LanguageMgr.GetTranslation("worldboss.ranking.num");
         addToContent(this.numTitle);
         this.nameTitle = ComponentFactory.Instance.creatComponentByStylename("worldboss.ranking.nameTitle");
         this.nameTitle.text = LanguageMgr.GetTranslation("worldboss.ranking.name");
         addToContent(this.nameTitle);
         this.souceTitle = ComponentFactory.Instance.creatComponentByStylename("worldboss.ranking.souceTitle");
         this.souceTitle.text = LanguageMgr.GetTranslation("worldboss.ranking.socre");
         addToContent(this.souceTitle);
         this._sureBtn = ComponentFactory.Instance.creat("worldboss.ranking.btn");
         this._sureBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         addToContent(this._sureBtn);
         this._sureBtn.addEventListener(MouseEvent.CLICK,this.__sureBtnClick);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      public function addPersonRanking(personInfo:RankingPersonInfo) : void
      {
         var i:int = 0;
         if(_rankingPersons.length == 0)
         {
            _rankingPersons.push(personInfo);
         }
         else
         {
            for(i = 0; i < _rankingPersons.length; i++)
            {
               if((_rankingPersons[i] as RankingPersonInfo).damage < personInfo.damage)
               {
                  _rankingPersons.splice(i,0,personInfo);
                  return;
               }
            }
            _rankingPersons.push(personInfo);
         }
      }
      
      public function show() : void
      {
         var pos:Point = null;
         var i:int = 0;
         var item:RankingPersonInfoItem = null;
         pos = ComponentFactory.Instance.creat("worldBoss.ranking.itemPos");
         for(i = 0; i < _rankingPersons.length; i++)
         {
            item = new RankingPersonInfoItem(i + 1,_rankingPersons[i] as RankingPersonInfo);
            item.x = pos.x;
            item.y = pos.y * (i + 1) + 50;
            addChild(item);
         }
         LayerManager.Instance.addToLayer(this,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      private function __sureBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         while(0 < _rankingPersons.length)
         {
            _rankingPersons.shift();
         }
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

