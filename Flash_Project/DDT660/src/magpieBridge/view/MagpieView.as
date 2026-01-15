package magpieBridge.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import magpieBridge.MagpieBridgeManager;
   import magpieBridge.event.MagpieBridgeEvent;
   
   public class MagpieView extends Sprite implements Disposeable
   {
      
      private var _magpieVec:Vector.<Bitmap>;
      
      private var _showMagpie:MovieClip;
      
      private var _togetherMovie:MovieClip;
      
      private var _playMeetFlag:Boolean;
      
      private var _packs:ScaleFrameImage;
      
      public function MagpieView()
      {
         super();
         this._magpieVec = new Vector.<Bitmap>();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var magpie:Bitmap = null;
         for(i = 0; i < 10; i++)
         {
            magpie = ComponentFactory.Instance.creat("asset.magpieBridge.magpie");
            magpie.scaleX = i % 2 == 0 ? -1 : 1;
            magpie.visible = false;
            PositionUtils.setPos(magpie,"magpieBridgeView.magpiePos" + i);
            addChild(magpie);
            this._magpieVec.push(magpie);
         }
         this._magpieVec.reverse();
         this._showMagpie = ComponentFactory.Instance.creat("asset.magpieBridge.magpie2");
         this._showMagpie.gotoAndStop(1);
         this._showMagpie.addFrameScript(this._showMagpie.totalFrames - 1,this.setMagpieNum);
         this._showMagpie.visible = false;
         addChild(this._showMagpie);
         this._togetherMovie = ComponentFactory.Instance.creat("asset.magpieBridge.together");
         this._togetherMovie.gotoAndStop(1);
         this._togetherMovie.visible = false;
         this._togetherMovie.addFrameScript(this._togetherMovie.totalFrames - 1,this.hideTogetherMovie);
         addChild(this._togetherMovie);
         this.setMagpieNum();
         this._packs = ComponentFactory.Instance.creatComponentByStylename("magpieBridge.magpieView.packsImage");
         this._packs.tipData = LanguageMgr.GetTranslation("magpieBridgeView.magpie.packs");
         addChild(this._packs);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(MagpieBridgeEvent.PLAYMEETANINMATION,this.__onPlayMeet);
      }
      
      protected function __onPlayMeet(event:MagpieBridgeEvent) : void
      {
         this._playMeetFlag = true;
      }
      
      public function showMagpie() : void
      {
         PositionUtils.setPos(this._showMagpie,this.getCurrentMagpiePos());
         this._showMagpie.scaleX = MagpieBridgeManager.instance.magpieModel.MagpieNum % 2 == 0 ? -1 : 1;
         this._showMagpie.visible = true;
         this._showMagpie.gotoAndPlay(1);
      }
      
      private function setMagpieNum() : void
      {
         var num:int = 0;
         num = MagpieBridgeManager.instance.magpieModel.MagpieNum;
         num = Math.min(num,this._magpieVec.length);
         for(var i:int = 0; i < num; i++)
         {
            this._magpieVec[i].visible = true;
         }
         this._showMagpie.stop();
         this._showMagpie.visible = false;
         if(this._playMeetFlag && num == 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magpieBridgeView.magpieOverTxt"));
            PositionUtils.setPos(this._togetherMovie,"magpieBridgeView.togetherPos");
            this._togetherMovie.visible = true;
            this._togetherMovie.gotoAndPlay(1);
         }
         else
         {
            dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.SETBTNENABLE));
         }
      }
      
      private function hideTogetherMovie() : void
      {
         this._playMeetFlag = false;
         this._togetherMovie.gotoAndStop(1);
         this._togetherMovie.visible = false;
         MagpieBridgeManager.instance.magpieModel.MagpieNum = 0;
         this.resetMagpieState();
         dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.SETBTNENABLE));
      }
      
      private function resetMagpieState() : void
      {
         for(var i:int = 0; i < this._magpieVec.length; i++)
         {
            this._magpieVec[i].visible = false;
         }
      }
      
      public function getCurrentMagpiePos(transFlag:Boolean = false) : Point
      {
         var point:Point = null;
         for(var i:int = 0; i < this._magpieVec.length; i++)
         {
            if(!this._magpieVec[i].visible)
            {
               if(transFlag && i % 2 != 0)
               {
                  point = new Point(this._magpieVec[i].x - this._magpieVec[i].width,this._magpieVec[i].y);
               }
               else
               {
                  point = new Point(this._magpieVec[i].x,this._magpieVec[i].y);
               }
               break;
            }
         }
         return point;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         for(var i:int = 0; i < this._magpieVec.length; i++)
         {
            this._magpieVec[i].bitmapData.dispose();
            this._magpieVec[i] = null;
         }
         this._magpieVec = null;
         ObjectUtils.disposeObject(this._showMagpie);
         this._showMagpie = null;
         ObjectUtils.disposeObject(this._togetherMovie);
         this._togetherMovie = null;
         ObjectUtils.disposeObject(this._packs);
         this._packs = null;
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(MagpieBridgeEvent.PLAYMEETANINMATION,this.__onPlayMeet);
      }
   }
}

