package campbattle.view.rank
{
   import campbattle.CampBattleManager;
   import campbattle.event.MapEvent;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ScoreRankView extends Sprite implements Disposeable
   {
      
      private var _backBtn:MovieClip;
      
      private var _rankSprite:Sprite;
      
      private var _rankListBg:MovieClip;
      
      private var _rankBtn:SimpleBitmapButton;
      
      private var _itemList:Vector.<CampRankItem>;
      
      private var _isOut:Boolean;
      
      private var _capList:Array = [LanguageMgr.GetTranslation("ddt.campBattle.qinglong"),LanguageMgr.GetTranslation("ddt.campBattle.baihu"),LanguageMgr.GetTranslation("ddt.campBattle.zhuque"),LanguageMgr.GetTranslation("ddt.campBattle.xuanwu")];
      
      public function ScoreRankView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._backBtn = ComponentFactory.Instance.creat("asset.map.outIn");
         this._backBtn.buttonMode = true;
         this._backBtn.gotoAndStop(2);
         addChild(this._backBtn);
         this._rankSprite = new Sprite();
         addChild(this._rankSprite);
         this._rankListBg = ComponentFactory.Instance.creat("camp.battle.rankList");
         PositionUtils.setPos(this._rankListBg,"camp.battle.rankListPos");
         this._rankSprite.addChild(this._rankListBg);
         this._rankBtn = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.rankBtn");
         this._rankSprite.addChild(this._rankBtn);
         this.addRankItem();
         this.upDateRankList(CampBattleManager.instance.model.scoreList);
      }
      
      private function addRankItem() : void
      {
         var i:int = 0;
         var item:CampRankItem = null;
         this._itemList = new Vector.<CampRankItem>();
         for(i = 0; i < 4; i++)
         {
            item = new CampRankItem();
            item.tipData = this._capList[i];
            item.y = 32 * i - 32;
            item.x = 109;
            addChild(item);
            this._itemList.push(item);
         }
      }
      
      private function initEvent() : void
      {
         this._backBtn.addEventListener(MouseEvent.CLICK,this.__onClickHander);
         this._rankBtn.addEventListener(MouseEvent.CLICK,this.__onRankBtnClick);
         CampBattleManager.instance.addEventListener(MapEvent.CAMP_SOCER_RANK,this.__onUpdateScore);
      }
      
      private function __onUpdateScore(event:MapEvent) : void
      {
         this.upDateRankList(CampBattleManager.instance.model.scoreList);
      }
      
      private function upDateRankList(arr:Array) : void
      {
         var len:int = 0;
         var i:int = 0;
         if(Boolean(arr))
         {
            len = int(arr.length);
            for(i = 0; i < len; i++)
            {
               this._itemList[i].setItemTxt(arr[i]);
            }
         }
      }
      
      private function __onRankBtnClick(event:MouseEvent) : void
      {
         event.stopImmediatePropagation();
         SoundManager.instance.playButtonSound();
         SocketManager.Instance.out.requestPRankList();
      }
      
      private function __onClickHander(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         SoundManager.instance.playButtonSound();
         if(this._isOut)
         {
            TweenLite.to(this,1,{"x":x - this._rankSprite.width});
            this._backBtn.gotoAndStop(2);
         }
         else
         {
            TweenLite.to(this,1,{"x":x + this._rankSprite.width});
            this._backBtn.gotoAndStop(1);
         }
         this._isOut = !this._isOut;
         SocketManager.Instance.out.requestCRankList();
      }
      
      private function removeEvent() : void
      {
         this._backBtn.removeEventListener(MouseEvent.CLICK,this.__onClickHander);
         this._rankBtn.removeEventListener(MouseEvent.CLICK,this.__onRankBtnClick);
         CampBattleManager.instance.removeEventListener(MapEvent.CAMP_SOCER_RANK,this.__onUpdateScore);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._backBtn))
         {
            ObjectUtils.disposeObject(this._backBtn);
         }
         this._backBtn = null;
      }
   }
}

