package drgnBoatBuild.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BuildProgress extends Component
   {
      
      private var _progressBg:Bitmap;
      
      private var _progress:Bitmap;
      
      private var _progressMask:Bitmap;
      
      private var _progressTxt:FilterFrameText;
      
      private var _area1:Sprite;
      
      private var _area2:Sprite;
      
      private var _area3:Sprite;
      
      private var _tips:OneLineTip;
      
      public function BuildProgress()
      {
         super();
         this.initView();
         this.initEvents();
         this.setData(0,0,0);
      }
      
      private function initView() : void
      {
         this._progress = ComponentFactory.Instance.creat("drgnBoatBuild.progressImg");
         addChild(this._progress);
         this._progressBg = ComponentFactory.Instance.creat("drgnBoatBuild.progress");
         addChild(this._progressBg);
         this._progressMask = ComponentFactory.Instance.creat("drgnBoatBuild.progressImg");
         addChild(this._progressMask);
         this._progress.mask = this._progressMask;
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.progressTxt");
         addChild(this._progressTxt);
         this._tips = new OneLineTip();
         addChild(this._tips);
         this._tips.visible = false;
         PositionUtils.setPos(this._tips,"drgnBoatBuild.tipsPos");
         this._area1 = new Sprite();
         this._area1.graphics.beginFill(0,0);
         this._area1.graphics.drawRect(0,0,60,16);
         this._area1.graphics.endFill();
         addChild(this._area1);
         this._area1.x = 21;
         this._area1.y = 6;
         this._area2 = new Sprite();
         this._area2.graphics.beginFill(0,0);
         this._area2.graphics.drawRect(0,0,60,16);
         this._area2.graphics.endFill();
         addChild(this._area2);
         this._area2.x = 83;
         this._area2.y = 6;
         this._area3 = new Sprite();
         this._area3.graphics.beginFill(0,0);
         this._area3.graphics.drawRect(0,0,60,16);
         this._area3.graphics.endFill();
         addChild(this._area3);
         this._area3.x = 146;
         this._area3.y = 6;
      }
      
      private function initEvents() : void
      {
         this._area1.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._area1.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         this._area2.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._area2.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         this._area3.addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._area3.addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      protected function __mouseOverHandler(event:MouseEvent) : void
      {
         this._tips.visible = true;
         switch(event.target)
         {
            case this._area1:
               this._tips.tipData = LanguageMgr.GetTranslation("drgnBoatBuild.stage0");
               break;
            case this._area2:
               this._tips.tipData = LanguageMgr.GetTranslation("drgnBoatBuild.stage1");
               break;
            case this._area3:
               this._tips.tipData = LanguageMgr.GetTranslation("drgnBoatBuild.stage2");
         }
      }
      
      protected function __mouseOutHandler(event:MouseEvent) : void
      {
         this._tips.visible = false;
      }
      
      public function setData(completed:int, stage:int, total:int) : void
      {
         this._progressMask.scaleX = completed / total;
         this._progressTxt.text = LanguageMgr.GetTranslation("drgnBoatBuild.completed",int(completed / total * 100) + "%");
      }
      
      private function removeEvents() : void
      {
         this._area1.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._area1.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         this._area2.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._area2.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
         this._area3.removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOverHandler);
         this._area3.removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOutHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._progressBg);
         this._progressBg = null;
         ObjectUtils.disposeObject(this._progressMask);
         this._progressMask = null;
         ObjectUtils.disposeObject(this._progressTxt);
         this._progressTxt = null;
         ObjectUtils.disposeObject(this._tips);
         this._tips = null;
         ObjectUtils.disposeObject(this._area1);
         this._area1 = null;
         ObjectUtils.disposeObject(this._area2);
         this._area2 = null;
         ObjectUtils.disposeObject(this._area3);
         this._area3 = null;
         super.dispose();
      }
      
      override public function get width() : Number
      {
         return displayWidth;
      }
      
      override public function get height() : Number
      {
         return displayHeight;
      }
   }
}

