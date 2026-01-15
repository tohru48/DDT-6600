package consortionBattle.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortionBattle.ConsortiaBattleManager;
   import consortionBattle.event.ConsBatEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class ConsBatScoreView extends Sprite implements Disposeable
   {
      
      private var _moveOutBtn:SimpleBitmapButton;
      
      private var _moveInBtn:SimpleBitmapButton;
      
      private var _playerBtn:SelectedButton;
      
      private var _consortiaBtn:SelectedButton;
      
      private var _playerBg:Bitmap;
      
      private var _consortiaBg:Bitmap;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _list:ListPanel;
      
      private var _selfScoreTxt:FilterFrameText;
      
      private var _consortiaScoreList:Array;
      
      private var _playerScoreList:Array;
      
      private var _timer:Timer;
      
      public function ConsBatScoreView()
      {
         super();
         this.x = 803;
         this.y = 183;
         this.initView();
         this.initEvent();
         this._timer = new Timer(5000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
         this._btnGroup.selectIndex = 0;
      }
      
      private function initView() : void
      {
         this._moveOutBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.moveOutBtn");
         this._moveInBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.moveInBtn");
         this.setInOutVisible(true);
         this._playerBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.playerBtn");
         this._consortiaBtn = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.consortiaBtn");
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._consortiaBtn);
         this._btnGroup.addSelectItem(this._playerBtn);
         this._playerBg = ComponentFactory.Instance.creatBitmap("asset.consortiaBattle.scoreView.player.bg");
         this._consortiaBg = ComponentFactory.Instance.creatBitmap("asset.consortiaBattle.scoreView.consortia.bg");
         this._selfScoreTxt = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.selfTxt");
         this._selfScoreTxt.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.scoreView.selfScoreTxt") + ConsortiaBattleManager.instance.score;
         this._list = ComponentFactory.Instance.creatComponentByStylename("consortiaBattle.scoreView.list");
         addChild(this._moveOutBtn);
         addChild(this._moveInBtn);
         addChild(this._playerBtn);
         addChild(this._consortiaBtn);
         addChild(this._playerBg);
         addChild(this._consortiaBg);
         addChild(this._selfScoreTxt);
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._moveOutBtn.addEventListener(MouseEvent.CLICK,this.outHandler,false,0,true);
         this._moveInBtn.addEventListener(MouseEvent.CLICK,this.inHandler,false,0,true);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler,false,0,true);
         this._playerBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         this._consortiaBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.UPDATE_SCORE,this.updateScore);
      }
      
      private function updateScore(event:ConsBatEvent) : void
      {
         var count:int = 0;
         var i:int = 0;
         var k:int = 0;
         var tmp:Object = null;
         var count2:int = 0;
         var j:int = 0;
         var tmp2:Object = null;
         var pkg:PackageIn = event.data as PackageIn;
         var type:int = pkg.readByte();
         if(type == 1)
         {
            this._consortiaScoreList = [];
            count = pkg.readInt();
            for(i = 0; i < count; i++)
            {
               tmp = {};
               tmp.name = pkg.readUTF();
               tmp.rank = pkg.readInt();
               tmp.score = pkg.readInt();
               this._consortiaScoreList.push(tmp);
            }
            this._consortiaScoreList.sortOn("score",Array.NUMERIC | Array.DESCENDING);
            for(k = 0; k < count; k++)
            {
               this._consortiaScoreList[k].rank = k + 1;
            }
         }
         else
         {
            this._playerScoreList = [];
            count2 = pkg.readInt();
            for(j = 0; j < count2; j++)
            {
               tmp2 = {};
               tmp2.name = pkg.readUTF();
               tmp2.rank = pkg.readInt();
               tmp2.score = pkg.readInt();
               this._playerScoreList.push(tmp2);
            }
            this._playerScoreList.sortOn("rank",Array.NUMERIC);
         }
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._list.vectorListModel.clear();
               this._list.vectorListModel.appendAll(this._consortiaScoreList);
               this._list.list.updateListView();
               break;
            case 1:
               this._list.vectorListModel.clear();
               this._list.vectorListModel.appendAll(this._playerScoreList);
               this._list.list.updateListView();
         }
      }
      
      private function __changeHandler(event:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._playerBg.visible = false;
               this._consortiaBg.visible = true;
               this._list.y = 13;
               this._selfScoreTxt.visible = false;
               this._consortiaBtn.x = 8;
               this._consortiaBtn.y = -32;
               this._playerBtn.x = 93;
               this._playerBtn.y = -26;
               this._list.vectorListModel.clear();
               this._list.vectorListModel.appendAll(this._consortiaScoreList);
               this._list.list.updateListView();
               this._timer.reset();
               this._timer.start();
               SocketManager.Instance.out.sendConsBatUpdateScore(1);
               break;
            case 1:
               this._playerBg.visible = true;
               this._consortiaBg.visible = false;
               this._list.y = 37;
               this._selfScoreTxt.visible = true;
               this._consortiaBtn.x = 6;
               this._consortiaBtn.y = -26;
               this._playerBtn.x = 85;
               this._playerBtn.y = -31;
               this._list.vectorListModel.clear();
               this._list.vectorListModel.appendAll(this._playerScoreList);
               this._list.list.updateListView();
               this._timer.reset();
               this._timer.start();
               SocketManager.Instance.out.sendConsBatUpdateScore(2);
         }
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         var tmp:int = 0;
         if(this._btnGroup.selectIndex == 0)
         {
            tmp = 1;
         }
         else
         {
            tmp = 2;
         }
         SocketManager.Instance.out.sendConsBatUpdateScore(tmp);
      }
      
      private function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(false);
         TweenLite.to(this,0.5,{"x":999});
      }
      
      private function setInOutVisible(isOut:Boolean) : void
      {
         this._moveOutBtn.visible = isOut;
         this._moveInBtn.visible = !isOut;
      }
      
      private function inHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(true);
         TweenLite.to(this,0.5,{"x":803});
      }
      
      private function removeEvent() : void
      {
         this._moveOutBtn.removeEventListener(MouseEvent.CLICK,this.outHandler);
         this._moveInBtn.removeEventListener(MouseEvent.CLICK,this.inHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._playerBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._consortiaBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         ConsortiaBattleManager.instance.removeEventListener(ConsortiaBattleManager.UPDATE_SCORE,this.updateScore);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._moveOutBtn = null;
         this._moveInBtn = null;
         this._playerBtn = null;
         this._consortiaBtn = null;
         this._playerBg = null;
         this._consortiaBg = null;
         this._selfScoreTxt = null;
         this._list = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

