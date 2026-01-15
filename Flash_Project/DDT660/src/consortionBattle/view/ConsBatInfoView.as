package consortionBattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.PlayerPortraitView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ConsBatInfoView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _hp:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _hpTxt:FilterFrameText;
      
      private var _victoryCountTxt:FilterFrameText;
      
      private var _winningStreakTxt:FilterFrameText;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _portrait:PlayerPortraitView;
      
      private var _hpWidth:Number;
      
      public function ConsBatInfoView()
      {
         super();
         this.initView();
         this.initEvent();
         this.refreshView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortiaBattle.infoView.bg");
         this._hp = ComponentFactory.Instance.creatBitmap("asset.consortiaBattle.infoView.hp");
         this._hpWidth = this._hp.width;
         this._portrait = new PlayerPortraitView(PlayerPortraitView.RIGHT);
         PositionUtils.setPos(this._portrait,"consortiaBattle.portraitPos");
         this._portrait.info = PlayerManager.Instance.Self;
         this._portrait.isShowFrame = false;
         var maskSprite:Sprite = new Sprite();
         maskSprite.graphics.beginFill(16711680,0.5);
         maskSprite.graphics.drawCircle(0,0,35);
         maskSprite.graphics.endFill();
         PositionUtils.setPos(maskSprite,"consortiaBattle.portraitMaskPos");
         this._portrait.mask = maskSprite;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.infoView.nameTxt");
         this._nameTxt.text = PlayerManager.Instance.Self.NickName;
         this._hpTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.infoView.hpTxt");
         this._victoryCountTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.infoView.infoTxt");
         this._winningStreakTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.infoView.infoTxt");
         this._winningStreakTxt.textFormatStyle = "consortiaBattle.infoView.infoTxt2.tf";
         PositionUtils.setPos(this._winningStreakTxt,"consortiaBattle.winningStreakTxtPos");
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.infoView.infoTxt");
         PositionUtils.setPos(this._scoreTxt,"consortiaBattle.socreTxtPos");
         addChild(this._bg);
         addChild(this._portrait);
         addChild(maskSprite);
         addChild(this._hp);
         addChild(this._nameTxt);
         addChild(this._hpTxt);
         addChild(this._victoryCountTxt);
         addChild(this._winningStreakTxt);
         addChild(this._scoreTxt);
      }
      
      private function initEvent() : void
      {
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.UPDATE_SCENE_INFO,this.refreshView);
      }
      
      private function refreshView(event:Event = null) : void
      {
         var totalHp:int = PlayerManager.Instance.Self.hp;
         var tmp:int = ConsortiaBattleManager.instance.curHp == -1 ? totalHp : ConsortiaBattleManager.instance.curHp;
         this._hpTxt.text = tmp + "/" + totalHp;
         this._hp.width = tmp / totalHp * this._hpWidth;
         this._victoryCountTxt.text = ConsortiaBattleManager.instance.victoryCount.toString();
         this._winningStreakTxt.text = ConsortiaBattleManager.instance.winningStreak.toString();
         this._scoreTxt.text = ConsortiaBattleManager.instance.score.toString();
      }
      
      private function removeEvent() : void
      {
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.UPDATE_SCENE_INFO,this.refreshView);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._hp = null;
         this._portrait = null;
         this._nameTxt = null;
         this._hpTxt = null;
         this._victoryCountTxt = null;
         this._winningStreakTxt = null;
         this._scoreTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

