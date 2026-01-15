package ddt.view
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.CheckCodeData;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class CheckCodeFrame extends BaseAlerFrame
   {
      
      private static var _instance:CheckCodeFrame;
      
      private const BACK_GOUND_GAPE:int = 3;
      
      private var _time:int;
      
      private var _bgI:Bitmap;
      
      private var _bgII:Scale9CornerImage;
      
      private var _isShowed:Boolean = true;
      
      private var _inputArr:Array;
      
      private var _input:String;
      
      private var _countDownTxt:FilterFrameText;
      
      private var _secondTxt:FilterFrameText;
      
      private var coutTimer:Timer;
      
      private var coutTimer_1:Timer;
      
      private var checkCount:int = 0;
      
      private var _alertInfo:AlertInfo;
      
      private var okBtn:BaseButton;
      
      private var clearBtn:BaseButton;
      
      private var _numberArr:Array;
      
      private var _numViewArr:Array;
      
      private var _NOBtnIsOver:Boolean = false;
      
      private var _cheatTime:uint = 0;
      
      private var speed:Number = 10;
      
      private var currentPic:Bitmap;
      
      private var _showTimer:Timer;
      
      private var count:int;
      
      public function CheckCodeFrame()
      {
         this._showTimer = new Timer(1000);
         super();
         try
         {
            this.initCheckCodeFrame();
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__LoadCore2Complete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,__LoadCore2Error);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_COREII);
         }
      }
      
      public static function get Instance() : CheckCodeFrame
      {
         if(_instance == null)
         {
            _instance = ComponentFactory.Instance.creatCustomObject("core.checkCodeFrame");
         }
         return _instance;
      }
      
      private function __LoadCore2Complete(pEvent:UIModuleEvent) : void
      {
         if(pEvent.module == UIModuleTypes.DDT_COREII)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__LoadCore2Complete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__LoadCore2Error);
            this.initCheckCodeFrame();
         }
      }
      
      private function __LoadCore2Error(pEvent:UIModuleEvent) : void
      {
      }
      
      private function initCheckCodeFrame() : void
      {
         var i:int = 0;
         var input:FilterFrameText = null;
         var numView:BaseButton = null;
         var numViewBg:ScaleFrameImage = null;
         var numNOView:Bitmap = null;
         var numObj:Object = null;
         var numSp:Sprite = null;
         this._bgI = ComponentFactory.Instance.creatBitmap("asset.core.checkCodeBgAsset");
         addToContent(this._bgI);
         this._bgII = ComponentFactory.Instance.creatComponentByStylename("store.checkCodeScale9BG");
         addToContent(this._bgII);
         this._inputArr = new Array();
         for(var n:int = 0; n < 4; n++)
         {
            input = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeInputTxt");
            input.type = TextFieldType.DYNAMIC;
            input.text = "*";
            input.x += n * 39;
            this._inputArr.push(input);
            input.visible = false;
            addToContent(input);
         }
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.enthrallCheckFrame.checkCode"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("clear"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this.okBtn = _submitButton;
         this.okBtn.addEventListener(MouseEvent.CLICK,this.__okBtnClick);
         this.okBtn.enable = false;
         this.clearBtn = _cancelButton;
         this.clearBtn.addEventListener(MouseEvent.CLICK,this.__clearBtnClick);
         this.clearBtn.enable = false;
         this._countDownTxt = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeCountDownTxt");
         addToContent(this._countDownTxt);
         this._secondTxt = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeSecTxt");
         addToContent(this._secondTxt);
         this._secondTxt.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second");
         this._numberArr = new Array();
         this._numViewArr = new Array();
         for(i = i; i < 10; i++)
         {
            numView = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeNOBtn");
            numViewBg = ComponentFactory.Instance.creatComponentByStylename("core.checkCodeNOBtnBg");
            numView.backgound = numViewBg;
            numNOView = ComponentFactory.Instance.creatBitmap("asset.core.checkCodeNO" + String(i) + "Asset");
            numNOView.x = (numView.width - numNOView.width) / 2;
            numNOView.y = (numView.height - numNOView.height) / 2;
            numView.addChild(numNOView);
            numObj = new Object();
            numSp = new Sprite();
            numView.x = -numView.width / 2;
            numView.y = -numView.height / 2;
            numSp.addChild(numView);
            numObj.view = numSp;
            numObj.NOView = numNOView;
            numObj.id = i;
            numObj.angle = i * 0.628;
            numObj.axisZ = 100;
            this._numberArr.push(numObj);
            this._numViewArr.push(numSp);
            addToContent(numSp);
            numSp.addEventListener(MouseEvent.CLICK,this.clicknumSp);
            numSp.addEventListener(MouseEvent.MOUSE_OVER,this.overnumSp);
            numSp.addEventListener(MouseEvent.MOUSE_OUT,this.outnumSp);
         }
         this.setnumViewCoord();
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function set time(value:int) : void
      {
         this._time = value;
      }
      
      private function clicknumSp(e:MouseEvent) : void
      {
         if(this._cheatTime == 0)
         {
            this._cheatTime = getTimer();
         }
         SoundManager.instance.play("008");
         if(this._input.length >= 4)
         {
            return;
         }
         this._input += String(this._numViewArr.indexOf(e.currentTarget));
         this.textChange();
      }
      
      private function overnumSp(e:MouseEvent) : void
      {
         this._NOBtnIsOver = true;
      }
      
      private function outnumSp(e:MouseEvent) : void
      {
         this._NOBtnIsOver = false;
      }
      
      private function setnumViewCoord() : void
      {
      }
      
      private function math_z(obj:Object) : void
      {
      }
      
      private function inFrameStart(e:Event) : void
      {
         var axisMouse:int = Math.abs(Math.sqrt((mouseX - 356) * (mouseX - 356) + (mouseY - 166) * (mouseY - 166)) - 100);
         if(axisMouse <= 100)
         {
            this.speed = axisMouse / 200;
         }
         if(axisMouse > 100)
         {
            this.speed = 0.5;
         }
         if(this._NOBtnIsOver == true)
         {
            this.speed = 0.02;
         }
         for(var i:int = 0; i < this._numberArr.length; i++)
         {
            this._numberArr[i].NOView.visible = true;
            if(this._NOBtnIsOver)
            {
               this._numberArr[i].NOView.visible = false;
            }
            this._numberArr[i].angle += this.speed * 0.1;
            this._numberArr[i].view.y = this._numberArr[i].axisZ * Math.cos(this._numberArr[i].angle) + 166;
            this._numberArr[i].view.x = this._numberArr[i].axisZ * Math.sin(this._numberArr[i].angle) + 356;
         }
      }
      
      public function set data(d:CheckCodeData) : void
      {
         if(Boolean(this.currentPic) && Boolean(this.currentPic.parent))
         {
            removeChild(this.currentPic);
            this.currentPic.bitmapData.dispose();
            this.currentPic = null;
         }
         this.currentPic = d.pic;
         this.currentPic.width = 170 - 2 * this.BACK_GOUND_GAPE;
         this.currentPic.height = 75 - 2 * this.BACK_GOUND_GAPE;
         this.currentPic.x = 30 + Math.random() * 2 * this.BACK_GOUND_GAPE;
         this.currentPic.y = 75 + Math.random() * 2 * this.BACK_GOUND_GAPE;
         addChild(this.currentPic);
      }
      
      private function __onTimeComplete(e:TimerEvent) : void
      {
         this._input = "";
         this.coutTimer.stop();
         this.coutTimer.reset();
         this.sendSelected();
      }
      
      private function __onTimeComplete_1(e:TimerEvent) : void
      {
         this._countDownTxt.text = (int(this._countDownTxt.text) - 1).toString();
      }
      
      private function textChange() : void
      {
         this.okBtn.enable = this.isValidText();
         this.clearBtn.enable = this.haveValidText();
         for(var i:int = 0; i < this._inputArr.length; i++)
         {
            this._inputArr[i].visible = false;
            if(i < this._input.length)
            {
               this._inputArr[i].visible = true;
            }
         }
      }
      
      private function haveValidText() : Boolean
      {
         if(this._input.length == 0)
         {
            return false;
         }
         return true;
      }
      
      private function isValidText() : Boolean
      {
         if(FilterWordManager.IsNullorEmpty(this._input))
         {
            return false;
         }
         if(this._input.length != 4)
         {
            return false;
         }
         return true;
      }
      
      public function set tip(value:String) : void
      {
      }
      
      public function show() : void
      {
         this.count = this.time;
         this._countDownTxt.text = (this.time - 1).toString();
         if(Boolean(this.coutTimer))
         {
            this.coutTimer.stop();
            this.coutTimer.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         }
         if(Boolean(this.coutTimer_1))
         {
            this.coutTimer_1.stop();
            this.coutTimer_1.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         }
         this.coutTimer = new Timer(this.time * 1000,1);
         this.coutTimer_1 = new Timer(1000,this.time);
         if(StateManager.currentStateType == StateType.FIGHTING)
         {
            this._showTimer.addEventListener(TimerEvent.TIMER,this.__show);
            this._showTimer.start();
         }
         else
         {
            this.popup();
         }
      }
      
      private function __show(event:TimerEvent) : void
      {
         if(StateManager.currentStateType != StateType.FIGHTING)
         {
            this._showTimer.removeEventListener(TimerEvent.TIMER,this.__show);
            this._showTimer.stop();
            this.popup();
         }
      }
      
      private function popup() : void
      {
         SoundManager.instance.play("057");
         this.isShowed = true;
         this.x = 220 + (Math.random() * 150 - 75);
         this.y = 110 + (Math.random() * 200 - 100);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         this._input = "";
         this.restartTimer();
      }
      
      public function close() : void
      {
         if(Boolean(this.coutTimer))
         {
            this.coutTimer.stop();
            this.coutTimer.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         }
         if(Boolean(this.coutTimer_1))
         {
            this.coutTimer_1.stop();
            this.coutTimer_1.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this.checkCount = 0;
         this._input = "";
         addEventListener(KeyboardEvent.KEY_DOWN,this.__resposeHandler);
         removeEventListener(Event.ENTER_FRAME,this.inFrameStart);
         dispatchEvent(new Event(Event.CLOSE));
         this.textChange();
      }
      
      override protected function __onAddToStage(e:Event) : void
      {
         addEventListener(KeyboardEvent.KEY_DOWN,this.__resposeHandler);
      }
      
      private function __okBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._cheatTime <= 500)
         {
            this._input = "";
            SocketManager.Instance.out.sendCheckCode("cheat");
            return;
         }
         if(this.isValidText())
         {
            this.sendSelected();
         }
      }
      
      private function __clearBtnClick(evt:MouseEvent) : void
      {
         if(this.haveValidText())
         {
            SoundManager.instance.play("008");
            this._input = "";
            this.textChange();
         }
      }
      
      private function __resposeHandler(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == Keyboard.ENTER)
         {
            this.__okBtnClick(null);
         }
      }
      
      private function sendSelected() : void
      {
         this.coutTimer.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         if(!FilterWordManager.IsNullorEmpty(this._input))
         {
            SocketManager.Instance.out.sendCheckCode(this._input);
         }
         else
         {
            SocketManager.Instance.out.sendCheckCode("");
            this.restartTimer();
         }
         this._input = "";
         ++this.checkCount;
         if(this.checkCount == 10)
         {
            this.checkCount = 0;
            this.coutTimer.removeEventListener(TimerEvent.TIMER,this.__onTimeComplete);
            this.close();
         }
      }
      
      private function restartTimer() : void
      {
         this._cheatTime = 0;
         this.coutTimer.stop();
         this.coutTimer.reset();
         this.coutTimer.addEventListener(TimerEvent.TIMER,this.__onTimeComplete);
         this.coutTimer.start();
         this.coutTimer_1.stop();
         this.coutTimer_1.reset();
         this.coutTimer_1.addEventListener(TimerEvent.TIMER,this.__onTimeComplete_1);
         this.coutTimer_1.start();
         this._countDownTxt.text = (this.count - 1).toString();
         this.okBtn.enable = false;
         this.clearBtn.enable = false;
         removeEventListener(Event.ENTER_FRAME,this.inFrameStart);
         addEventListener(Event.ENTER_FRAME,this.inFrameStart);
         this.textChange();
      }
      
      public function get isShowed() : Boolean
      {
         return this._isShowed;
      }
      
      public function set isShowed(value:Boolean) : void
      {
         this._isShowed = value;
      }
   }
}

