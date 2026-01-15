package littleGame.view
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
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import littleGame.LittleGameManager;
   
   public class OptionRightView extends Sprite implements Disposeable
   {
      
      private var _rightViewBg:MovieImage;
      
      private var _rightViewBg1:MutipleImage;
      
      private var _rightViewBg2:MutipleImage;
      
      private var _listView:LittleAwardListView;
      
      private var _pointBg:Bitmap;
      
      private var _pointInputBg:Scale9CornerImage;
      
      private var _pointTable:FilterFrameText;
      
      private var _pointTxt:FilterFrameText;
      
      private var _btnGoback:BaseButton;
      
      private var _btnEnter:BaseButton;
      
      private var _titlebg:Bitmap;
      
      public function OptionRightView()
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
         this._pointBg = ComponentFactory.Instance.creatBitmap("asset.ddtlittleGame.pointbg");
         addChild(this._pointBg);
         this._pointInputBg = ComponentFactory.Instance.creatComponentByStylename("ddtlittleGameRightViewBG4");
         addChild(this._pointInputBg);
         this._pointTable = ComponentFactory.Instance.creatComponentByStylename("littleGame.MypointTxt");
         addChild(this._pointTable);
         this._pointTable.text = LanguageMgr.GetTranslation("ddtlittlegame.HaveAwardScore");
         this._pointTxt = ComponentFactory.Instance.creatComponentByStylename("littleGame.pointTxt");
         addChild(this._pointTxt);
         this._pointTxt.text = PlayerManager.Instance.Self.Score.toString();
         this._btnGoback = ComponentFactory.Instance.creatComponentByStylename("littleGame.btnGobackHot");
         addChild(this._btnGoback);
         this._btnEnter = ComponentFactory.Instance.creatComponentByStylename("littleGame.btnEnterGame");
         addChild(this._btnEnter);
         this._listView = ComponentFactory.Instance.creatCustomObject("littleGame.awardList");
         addChild(this._listView);
         this._titlebg = ComponentFactory.Instance.creatBitmap("asset.ddtlittlegame.titlebg");
         addChild(this._titlebg);
      }
      
      private function addEvent() : void
      {
         this._btnGoback.addEventListener(MouseEvent.CLICK,this.__btnGobackClick);
         this._btnEnter.addEventListener(MouseEvent.CLICK,this.__btnEnterClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.onChange);
      }
      
      private function onChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Score"]))
         {
            this._pointTxt.text = PlayerManager.Instance.Self.Score.toString();
         }
      }
      
      private function __btnGobackClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         StateManager.setState(StateType.MAIN);
      }
      
      private function __btnEnterClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade >= 23)
         {
            this._btnEnter.mouseEnabled = false;
            LittleGameManager.Instance.enterWorld();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("littlegame.MinLvNote",23));
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("littlegame.MinLvNote",23));
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGoback.removeEventListener(MouseEvent.CLICK,this.__btnGobackClick);
         this._btnEnter.removeEventListener(MouseEvent.CLICK,this.__btnEnterClick);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.onChange);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._rightViewBg))
         {
            ObjectUtils.disposeObject(this._rightViewBg);
         }
         this._rightViewBg = null;
         if(Boolean(this._rightViewBg1))
         {
            ObjectUtils.disposeObject(this._rightViewBg1);
         }
         this._rightViewBg1 = null;
         if(Boolean(this._rightViewBg2))
         {
            ObjectUtils.disposeObject(this._rightViewBg2);
         }
         this._rightViewBg2 = null;
         if(Boolean(this._pointInputBg))
         {
            ObjectUtils.disposeObject(this._pointInputBg);
         }
         this._pointInputBg = null;
         if(Boolean(this._pointTable))
         {
            ObjectUtils.disposeObject(this._pointTable);
         }
         this._pointTable = null;
         if(Boolean(this._titlebg))
         {
            ObjectUtils.disposeObject(this._titlebg);
         }
         this._titlebg = null;
         if(Boolean(this._pointBg))
         {
            ObjectUtils.disposeObject(this._pointBg);
         }
         this._pointBg = null;
         if(Boolean(this._pointTxt))
         {
            ObjectUtils.disposeObject(this._pointTxt);
         }
         this._pointTxt = null;
         if(Boolean(this._btnGoback))
         {
            ObjectUtils.disposeObject(this._btnGoback);
         }
         this._btnGoback = null;
         if(Boolean(this._btnEnter))
         {
            ObjectUtils.disposeObject(this._btnEnter);
         }
         this._btnEnter = null;
         if(Boolean(this._listView))
         {
            ObjectUtils.disposeObject(this._listView);
         }
         this._listView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

