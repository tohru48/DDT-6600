package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.CSMBoxManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class CSMBoxView extends Sprite implements Disposeable
   {
      
      private var _closeSprite:Component;
      
      private var _closeBox:MovieImage;
      
      private var _timeBG:Bitmap;
      
      private var _timeText:FilterFrameText;
      
      private var _openBox:MovieImage;
      
      private var _downBox:MovieImage;
      
      private var _showType:int = -1;
      
      public function CSMBoxView()
      {
         super();
         buttonMode = true;
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var pos:Point = null;
         this._closeSprite = ComponentFactory.Instance.creatComponentByStylename("CSMBox.closeBoxTip");
         this._closeSprite.tipData = LanguageMgr.GetTranslation("tanl.timebox.tipMes");
         this._closeSprite.buttonMode = true;
         this._closeBox = ComponentFactory.Instance.creatComponentByStylename("CSMBox.closeBox");
         this._closeSprite.addChild(this._closeBox);
         this._timeBG = ComponentFactory.Instance.creatBitmap("asset.timeBox.timeBGAsset");
         this._closeSprite.addChild(this._timeBG);
         this._timeText = ComponentFactory.Instance.creat("bossbox.TimeBoxStyle");
         this._closeSprite.addChild(this._timeText);
         addChild(this._closeSprite);
         this._openBox = ComponentFactory.Instance.creatComponentByStylename("CSMBox.openBox");
         addChild(this._openBox);
         this._downBox = ComponentFactory.Instance.creatComponentByStylename("CSMBox.downBox");
         addChild(this._downBox);
         pos = PositionUtils.creatPoint("CSMBoxViewPos");
         this._downBox.x -= pos.x;
         this._downBox.y -= pos.y;
         this._downBox.buttonMode = true;
         this._openBox.visible = false;
         this._closeSprite.visible = false;
         this._downBox.visible = false;
      }
      
      public function showBox($type:int = 0) : void
      {
         if(this._showType == $type)
         {
            return;
         }
         this._showType = $type;
         if(!this._openBox || !this._closeSprite || !this._downBox)
         {
            return;
         }
         switch(this._showType)
         {
            case 0:
               this._openBox.visible = false;
               this._closeSprite.visible = true;
               this._downBox.visible = false;
               break;
            case 1:
               this._openBox.visible = true;
               this._closeSprite.visible = false;
               this._downBox.visible = false;
         }
      }
      
      public function updateTime(second:int) : void
      {
         var _timeSum:int = 0;
         var _minute:int = 0;
         var _second:int = 0;
         var str:String = null;
         if(Boolean(this._timeText))
         {
            _timeSum = second;
            _minute = _timeSum / 60;
            _second = _timeSum % 60;
            str = "";
            if(_minute < 10)
            {
               str += "0" + _minute;
            }
            else
            {
               str += _minute;
            }
            str += ":";
            if(_second < 10)
            {
               str += "0" + _second;
            }
            else
            {
               str += _second;
            }
            this._timeText.text = str;
         }
      }
      
      private function initEvent() : void
      {
         this._closeBox.addEventListener(MouseEvent.CLICK,this._boxClick);
         this._openBox.addEventListener(MouseEvent.CLICK,this._boxClick);
         this._downBox.addEventListener(MouseEvent.CLICK,this._boxClick);
      }
      
      private function _boxClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.currentTarget == this._closeBox)
         {
            CSMBoxManager.instance.showAwards();
         }
         else if(e.currentTarget == this._openBox)
         {
            this._openBox.visible = false;
            this._closeSprite.visible = false;
            this._downBox.visible = true;
            this._downBox.movie.stop();
            this._downBox.movie.gotoAndPlay(1);
         }
         else if(e.currentTarget == this._downBox)
         {
            SocketManager.Instance.out.sendGetCSMTimeBox();
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         this._closeBox.removeEventListener(MouseEvent.CLICK,this._boxClick);
         this._openBox.removeEventListener(MouseEvent.CLICK,this._boxClick);
         this._downBox.removeEventListener(MouseEvent.CLICK,this._boxClick);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._closeBox))
         {
            ObjectUtils.disposeObject(this._closeBox);
         }
         this._closeBox = null;
         if(Boolean(this._timeBG))
         {
            ObjectUtils.disposeObject(this._timeBG);
         }
         this._timeBG = null;
         if(Boolean(this._timeText))
         {
            ObjectUtils.disposeObject(this._timeText);
         }
         this._timeText = null;
         if(Boolean(this._closeSprite))
         {
            ObjectUtils.disposeAllChildren(this._closeSprite);
            ObjectUtils.disposeObject(this._closeSprite);
            this._closeSprite = null;
         }
         if(Boolean(this._openBox))
         {
            ObjectUtils.disposeObject(this._openBox);
         }
         this._openBox = null;
         if(Boolean(this._downBox))
         {
            ObjectUtils.disposeObject(this._downBox);
         }
         this._downBox = null;
      }
   }
}

