package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import worldboss.WorldBossManager;
   import worldboss.event.WorldBossRoomEvent;
   
   public class WorldBossAwardOptionRightView extends Sprite implements Disposeable
   {
      
      private var _rightViewBg:MovieImage;
      
      private var _rightViewBg1:MutipleImage;
      
      private var _rightViewBg2:MutipleImage;
      
      private var _listView:WorldBossAwardListView;
      
      private var _pointBg:Bitmap;
      
      private var _pointInputBg:Scale9CornerImage;
      
      private var _pointTable:FilterFrameText;
      
      private var _pointTxt:FilterFrameText;
      
      private var _btnGoback:BaseButton;
      
      private var _btnEnter:BaseButton;
      
      private var _titlebg:MutipleImage;
      
      public function WorldBossAwardOptionRightView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._rightViewBg = ComponentFactory.Instance.creatComponentByStylename("ddtlittleGameRightViewBG1");
         addChild(this._rightViewBg);
         this._rightViewBg1 = ComponentFactory.Instance.creatComponentByStylename("ddtlittleGameRightViewBG2");
         addChild(this._rightViewBg1);
         this._rightViewBg2 = ComponentFactory.Instance.creatComponentByStylename("ddtlittleGameRightViewBG3");
         addChild(this._rightViewBg2);
         this._titlebg = ComponentFactory.Instance.creatComponentByStylename("asset.worldbossAwardRoom.rightBg");
         addChild(this._titlebg);
         this._pointBg = ComponentFactory.Instance.creatBitmap("asset.ddtlittleGame.pointbg");
         addChild(this._pointBg);
         this._pointInputBg = ComponentFactory.Instance.creatComponentByStylename("ddtlittleGameRightViewBG4");
         addChild(this._pointInputBg);
         this._pointTable = ComponentFactory.Instance.creatComponentByStylename("littleGame.MypointTxt");
         addChild(this._pointTable);
         this._pointTable.text = LanguageMgr.GetTranslation("ddtlittlegame.HaveAwardScore");
         this._pointTxt = ComponentFactory.Instance.creatComponentByStylename("littleGame.pointTxt");
         addChild(this._pointTxt);
         this._pointTxt.text = PlayerManager.Instance.Self.damageScores.toString();
         this._btnGoback = ComponentFactory.Instance.creatComponentByStylename("littleGame.btnGobackHot");
         addChild(this._btnGoback);
         this._btnEnter = ComponentFactory.Instance.creatComponentByStylename("littleGame.btnEnterGame");
         addChild(this._btnEnter);
         if(WorldBossManager.Instance.bossInfo.roomClose)
         {
            this._btnEnter.enable = false;
         }
         this._listView = ComponentFactory.Instance.creatCustomObject("worldbossAwardRoom.awardList");
         addChild(this._listView);
      }
      
      private function addEvent() : void
      {
         this._btnGoback.addEventListener(MouseEvent.CLICK,this.__btnGobackClick);
         this._btnEnter.addEventListener(MouseEvent.CLICK,this.__btnEnterClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.onChange);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.ROOM_CLOSE,this.__roomclose);
      }
      
      private function onChange(event:PlayerPropertyEvent) : void
      {
         this._pointTxt.text = PlayerManager.Instance.Self.damageScores.toString();
      }
      
      private function __btnGobackClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(Event.CLOSE));
         StateManager.setState(StateType.MAIN);
      }
      
      private function __btnEnterClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.enterWorldBossRoom();
      }
      
      private function removeEvent() : void
      {
         this._btnGoback.removeEventListener(MouseEvent.CLICK,this.__btnGobackClick);
         this._btnEnter.removeEventListener(MouseEvent.CLICK,this.__btnEnterClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.onChange);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.ROOM_CLOSE,this.__roomclose);
      }
      
      private function __roomclose(e:WorldBossRoomEvent) : void
      {
         this._btnEnter.enable = false;
         this._listView.updata();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

