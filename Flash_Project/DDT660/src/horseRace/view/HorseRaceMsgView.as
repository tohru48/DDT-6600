package horseRace.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class HorseRaceMsgView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      public function HorseRaceMsgView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("horseRace.raceView.msgBg");
         addChild(this._bg);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("horseRace.race.raceView.msgBox");
         addChild(this._vbox);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("horseRace.race.raceView.msgBoxScroll");
         addChild(this._scrollPanel);
         this._scrollPanel.setView(this._vbox);
         this._scrollPanel.invalidateViewport();
      }
      
      private function initEvent() : void
      {
      }
      
      public function addMsg(msg:String) : void
      {
         var _lblName:FilterFrameText = null;
         _lblName = ComponentFactory.Instance.creat("horseRace.race.matchView.msgTxt");
         _lblName.mouseEnabled = false;
         _lblName.htmlText = msg;
         this._vbox.addChild(_lblName);
         this._scrollPanel.invalidateViewport(true);
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

