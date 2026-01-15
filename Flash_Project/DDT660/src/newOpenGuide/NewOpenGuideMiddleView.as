package newOpenGuide
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import trainer.data.Step;
   
   public class NewOpenGuideMiddleView extends Sprite implements Disposeable
   {
      
      private var _lightMc:MovieClip;
      
      private var _frameMc:MovieClip;
      
      private var _titleTxt:FilterFrameText;
      
      private var _iconMc:MovieClip;
      
      private var _btnSprite:Sprite;
      
      private var _titleStrIndexArray:Array;
      
      public function NewOpenGuideMiddleView()
      {
         super();
         this.initView();
         this.initEvent();
         this.refreshContent();
         this.playOpenCartoon();
      }
      
      private function initView() : void
      {
         this._frameMc = ComponentFactory.Instance.creat("asset.newOpenGuide.frameMc");
         this._lightMc = ComponentFactory.Instance.creat("asset.newOpenGuide.lightMc");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("newOpenGuideMiddleView.titleTxt");
         this._iconMc = ComponentFactory.Instance.creat("asset.newOpenGuide.iconMc");
         this._btnSprite = new Sprite();
         this._btnSprite.graphics.beginFill(16711680,0);
         this._btnSprite.graphics.drawRect(-86,-41,166,127);
         this._btnSprite.graphics.endFill();
         this._btnSprite.buttonMode = true;
         this._btnSprite.visible = false;
         addChild(this._frameMc);
         addChild(this._titleTxt);
         addChild(this._lightMc);
         addChild(this._iconMc);
         addChild(this._btnSprite);
      }
      
      private function initEvent() : void
      {
         this._frameMc.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler,false,0,true);
         this._btnSprite.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
      }
      
      private function enterFrameHandler(event:Event) : void
      {
         if(this._frameMc.currentFrame == 8)
         {
            this._btnSprite.visible = true;
            this._frameMc.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         }
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         this._btnSprite.visible = false;
         this._lightMc.gotoAndPlay(1);
         this._lightMc.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler2,false,0,true);
         TweenLite.to(this._iconMc,0.4,{
            "x":-42,
            "y":-37,
            "scaleX":1.2,
            "scaleY":1.2
         });
         var tmp:Array = NewOpenGuideManager.instance.getTitleStrIndexByLevel(PlayerManager.Instance.Self.Grade);
         SocketManager.Instance.out.syncWeakStep(Step.NEW_OPEN_GUIDE_START + tmp[2]);
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
      }
      
      private function enterFrameHandler2(event:Event) : void
      {
         var tmpPoint:Point = null;
         var tmpDescPos:Point = null;
         if(this._lightMc.currentFrame <= 10)
         {
            this._iconMc.x -= 0.5;
            this._iconMc.y -= 0.9;
            this._iconMc.scaleX += 0.02;
            this._iconMc.scaleY += 0.02;
         }
         if(this._lightMc.currentFrame > 13 && this._lightMc.currentFrame <= 18)
         {
            this._iconMc.x += 1;
            this._iconMc.y += 1.8;
            this._iconMc.scaleX -= 0.04;
            this._iconMc.scaleY -= 0.04;
         }
         if(this._lightMc.currentFrame == 11)
         {
            TweenLite.to(this._frameMc,0.4,{"alpha":0});
            TweenLite.to(this._titleTxt,0.4,{"alpha":0});
         }
         if(this._lightMc.currentFrame == 18)
         {
            tmpPoint = this.localToGlobal(new Point(this._iconMc.x,this._iconMc.y));
            LayerManager.Instance.addToLayer(this._iconMc,LayerManager.GAME_TOP_LAYER);
            this._iconMc.x = tmpPoint.x;
            this._iconMc.y = tmpPoint.y;
            tmpDescPos = NewOpenGuideManager.instance.getMovePos();
            TweenLite.to(this._iconMc,0.8,{
               "x":tmpDescPos.x,
               "y":tmpDescPos.y,
               "scaleX":0.6,
               "scaleY":0.6,
               "alpha":0,
               "ease":Quad.easeOut,
               "onComplete":this.allPlayComplete
            });
         }
         if(this._lightMc.currentFrame == this._lightMc.totalFrames)
         {
            this._lightMc.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler2);
         }
      }
      
      private function allPlayComplete() : void
      {
         this.dispose();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function refreshContent() : void
      {
         this._titleStrIndexArray = NewOpenGuideManager.instance.getTitleStrIndexByLevel(PlayerManager.Instance.Self.Grade);
         this._titleTxt.text = this._titleStrIndexArray[1];
         this._iconMc.gotoAndStop(this._titleStrIndexArray[0]);
         if(this._titleStrIndexArray[0] == 1)
         {
            NoviceDataManager.instance.saveNoviceData(410,PathManager.userName(),PathManager.solveRequestPath());
         }
         if(this._titleStrIndexArray[0] == 2)
         {
            NoviceDataManager.instance.saveNoviceData(490,PathManager.userName(),PathManager.solveRequestPath());
         }
         if(this._titleStrIndexArray[0] == 3)
         {
            NoviceDataManager.instance.saveNoviceData(580,PathManager.userName(),PathManager.solveRequestPath());
         }
         if(this._titleStrIndexArray[0] == 4)
         {
            NoviceDataManager.instance.saveNoviceData(630,PathManager.userName(),PathManager.solveRequestPath());
         }
         if(this._titleStrIndexArray[0] == 5)
         {
            NoviceDataManager.instance.saveNoviceData(660,PathManager.userName(),PathManager.solveRequestPath());
         }
         if(this._titleStrIndexArray[0] == 6)
         {
            NoviceDataManager.instance.saveNoviceData(720,PathManager.userName(),PathManager.solveRequestPath());
         }
      }
      
      private function playOpenCartoon() : void
      {
         this._titleTxt.x = -19;
         this._titleTxt.y = 22;
         this._titleTxt.scaleX = 0.3;
         this._titleTxt.scaleY = 0.3;
         this._titleTxt.alpha = 0;
         this._iconMc.x = -11;
         this._iconMc.y = -8;
         this._iconMc.scaleX = 0.3;
         this._iconMc.scaleY = 0.3;
         TweenLite.to(this._titleTxt,0.5,{
            "x":-68,
            "y":51,
            "scaleX":1,
            "scaleY":1,
            "alpha":1
         });
         TweenLite.to(this._iconMc,0.5,{
            "x":-37,
            "y":-28,
            "scaleX":1,
            "scaleY":1
         });
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._frameMc))
         {
            this._frameMc.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         }
         if(Boolean(this._btnSprite))
         {
            this._btnSprite.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._lightMc))
         {
            this._lightMc.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler2);
            this._lightMc.gotoAndStop(this._lightMc.totalFrames);
         }
         if(Boolean(this._frameMc))
         {
            this._frameMc.gotoAndStop(this._frameMc.totalFrames);
         }
         if(Boolean(this._iconMc))
         {
            this._iconMc.gotoAndStop(this._iconMc.totalFrames);
         }
         if(Boolean(this._frameMc))
         {
            this._frameMc.gotoAndStop(this._frameMc.totalFrames);
         }
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._iconMc);
         this._lightMc = null;
         this._frameMc = null;
         this._titleTxt = null;
         this._iconMc = null;
         this._btnSprite = null;
         this._titleStrIndexArray = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

