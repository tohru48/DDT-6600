package wonderfulActivity.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class WonderfulInfoView extends Sprite implements Disposeable
   {
      
      private var _bg:MovieClip;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _title:FilterFrameText;
      
      private var _infoText:FilterFrameText;
      
      private var _okBtn:SimpleBitmapButton;
      
      public function WonderfulInfoView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("hall.wonderfulActivity.infoView");
         addChild(this._bg);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.closeBtn");
         addChild(this._closeBtn);
         this._title = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.titleTxt");
         PositionUtils.setPos(this._title,"hall.wonderful.infoView.titlePos");
         addChild(this._title);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.descTxt");
         PositionUtils.setPos(this._infoText,"hall.wonderful.infoView.infoTextPos");
         addChild(this._infoText);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("hall.wonderfulActivity.okBtn");
         addChild(this._okBtn);
      }
      
      public function show(npcIndex:int, titleTxt:String, contentTxt:String) : void
      {
         this._bg.npc.gotoAndStop(npcIndex);
         this._title.text = titleTxt;
         this._infoText.text = contentTxt;
      }
      
      private function initEvent() : void
      {
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__onCloseClickHandler);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__onCloseClickHandler);
      }
      
      protected function __onCloseClickHandler(event:MouseEvent) : void
      {
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__onCloseClickHandler);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__onCloseClickHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

