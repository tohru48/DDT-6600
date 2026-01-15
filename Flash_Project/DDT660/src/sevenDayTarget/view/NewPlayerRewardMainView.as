package sevenDayTarget.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sevenDayTarget.controller.NewPlayerRewardManager;
   import sevenDayTarget.model.NewPlayerRewardInfo;
   
   public class NewPlayerRewardMainView extends Sprite
   {
      
      public static var CHONGZHI:int = 1;
      
      public static var XIAOFEI:int = 2;
      
      public static var HUNLI:int = 3;
      
      private var _bg:Bitmap;
      
      private var _downBack:ScaleBitmapImage;
      
      private var _titleText1:FilterFrameText;
      
      private var _titleText2:FilterFrameText;
      
      private var _titleText3:FilterFrameText;
      
      private var _scrollpanel:ScrollPanel;
      
      private var _scrollpanel2:ScrollPanel;
      
      private var _vbox:VBox;
      
      private var _vbox2:VBox;
      
      private var _helpBnt:BaseButton;
      
      public function NewPlayerRewardMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var info:NewPlayerRewardInfo = null;
         var item:NewPlayerRewardItem = null;
         var info1:NewPlayerRewardInfo = null;
         var item1:NewPlayerRewardItem = null;
         var info2:NewPlayerRewardInfo = null;
         var item2:NewPlayerRewardItem = null;
         this._bg = ComponentFactory.Instance.creat("sevenDay.newPlayerBg");
         this._downBack = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.scale9cornerImageTree");
         this._titleText1 = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext1");
         this._titleText2 = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext2");
         this._titleText3 = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext3");
         this._titleText1.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.title1");
         this._titleText2.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.title2");
         this._titleText3.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.title3");
         addChild(this._downBack);
         addChild(this._bg);
         addChild(this._titleText1);
         addChild(this._titleText2);
         addChild(this._titleText3);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.chongzhiVbox");
         this._scrollpanel = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.chongzhiList");
         var chongzhiInfoArr:Array = NewPlayerRewardManager.Instance.model.chongzhiInfoArr;
         for(var i:int = 0; i < chongzhiInfoArr.length; i++)
         {
            info = chongzhiInfoArr[i];
            item = new NewPlayerRewardItem();
            item.setInfo(info);
            this._vbox.addChild(item);
         }
         this._scrollpanel.setView(this._vbox);
         this._scrollpanel.invalidateViewport();
         addChild(this._scrollpanel);
         this._vbox2 = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.xiaofeiVbox");
         this._scrollpanel2 = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.xiaofeiList");
         var xiaofeiInfoArr:Array = NewPlayerRewardManager.Instance.model.xiaofeiInfoArr;
         for(var j:int = 0; j < xiaofeiInfoArr.length; j++)
         {
            info1 = xiaofeiInfoArr[j];
            item1 = new NewPlayerRewardItem();
            item1.setInfo(info1);
            this._vbox2.addChild(item1);
         }
         this._scrollpanel2.setView(this._vbox2);
         this._scrollpanel2.invalidateViewport();
         addChild(this._scrollpanel2);
         var hunliInfoArr:Array = NewPlayerRewardManager.Instance.model.hunliInfoArr;
         for(var k:int = 0; k < hunliInfoArr.length; k++)
         {
            info2 = hunliInfoArr[k];
            item2 = new NewPlayerRewardItem();
            item2.setInfo(info2);
            addChild(item2);
            PositionUtils.setPos(item2,"newSevenDayAndNewPlayer.hunliListPos");
         }
         this.addHelpBnt();
      }
      
      private function addHelpBnt() : void
      {
         this._helpBnt = ComponentFactory.Instance.creatComponentByStylename("newPlayerReward.helpBnt");
         addChild(this._helpBnt);
         PositionUtils.setPos(this._helpBnt,"newPlayerReward.view.helpBntPos");
         this._helpBnt.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
      }
      
      protected function __onHelpClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpView:SevenDayTargetHelpFrame = ComponentFactory.Instance.creat("sevenDayTarget.helpView");
         var helpInfo:MovieClip = ComponentFactory.Instance.creat("newPlayerReward.view.helpContentText");
         helpView.changeContent(helpInfo);
         LayerManager.Instance.addToLayer(helpView,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
      }
   }
}

