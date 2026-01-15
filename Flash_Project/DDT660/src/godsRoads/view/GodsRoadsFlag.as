package godsRoads.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import godsRoads.manager.GodsRoadsManager;
   
   public class GodsRoadsFlag extends Component
   {
      
      private var _lv:int = 1;
      
      private var _alertTxt:FilterFrameText;
      
      private var _btn:BaseButton;
      
      private var _numBitmapArray:Array = [];
      
      private var _pointsNum:Sprite;
      
      private var _offX:int = 6;
      
      private var _perBmp:Bitmap;
      
      private var progressTxt:Bitmap;
      
      private var isOpen:Boolean = false;
      
      private var _progressNum:int;
      
      public function GodsRoadsFlag(lv:int)
      {
         this._lv = lv;
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._btn = ComponentFactory.Instance.creat("godsRoads.ddLevelBtn" + this._lv);
         addChild(this._btn);
         if(this._lv > 1)
         {
            this._alertTxt = ComponentFactory.Instance.creat("godsRoads.conditionsTxt");
            this._alertTxt.text = LanguageMgr.GetTranslation("ddt.godsRoads.openConditions",LanguageMgr.GetTranslation("ddt.godsRoads.lv" + this._lv));
            addChild(this._alertTxt);
         }
         this._pointsNum = new Sprite();
         PositionUtils.setPos(this._pointsNum,"godsRoads.numPos");
         addChild(this._pointsNum);
         this.progressTxt = ComponentFactory.Instance.creat("asset.godsRoads.programeTxt");
         this.progressTxt.visible = false;
         addChild(this.progressTxt);
         this._btn.addEventListener(MouseEvent.CLICK,this.__changeSteps);
      }
      
      public function set enable(val:Boolean) : void
      {
         this.isOpen = val;
         if(val == true)
         {
            this._btn.filterString = "null,lightFilter,null,grayFilter";
            if(Boolean(this._alertTxt))
            {
               this._alertTxt.visible = false;
            }
         }
         else
         {
            if(this._lv == GodsRoadsManager.instance._model.godsRoadsData.currentLevel + 1)
            {
               this._alertTxt.textFormatStyle = "godsRoads.TextFormat";
            }
            this._btn.filterString = "grayFilter,grayFilter,grayFilter,grayFilter";
            if(Boolean(this._alertTxt))
            {
               this._alertTxt.visible = true;
            }
         }
         this._btn.setFrame(1);
      }
      
      public function get isOpened() : Boolean
      {
         return this.isOpen;
      }
      
      private function getFA(str:String) : Array
      {
         return ComponentFactory.Instance.creatFrameFilters(str);
      }
      
      private function __changeSteps(e:MouseEvent) : void
      {
         GodsRoadsManager.instance.changeSteps(this._lv);
      }
      
      public function get enable() : Boolean
      {
         return this.isOpen;
      }
      
      public function set progressNum(val:int) : void
      {
         this._progressNum = val;
         this.setCountDownNumber(this._progressNum);
         this.showProgress = true;
      }
      
      public function get progressNum() : int
      {
         return this._progressNum;
      }
      
      public function set showProgress(val:Boolean) : void
      {
         this.progressTxt.visible = val;
      }
      
      private function setCountDownNumber(points:int) : void
      {
         var bitmap:Bitmap = null;
         var pointsStr:String = String(points);
         var num:String = "";
         var _x:int = 0;
         this.deleteBitmapArray();
         this._numBitmapArray = new Array();
         for(var i:int = 0; i < pointsStr.length; i++)
         {
            num = pointsStr.charAt(i);
            bitmap = ComponentFactory.Instance.creatBitmap("asset.godsRoads.num" + num);
            bitmap.x = bitmap.bitmapData.width * i - i * this._offX;
            _x = bitmap.x + bitmap.bitmapData.width;
            this._pointsNum.addChild(bitmap);
            this._numBitmapArray.push(bitmap);
         }
         this._perBmp = ComponentFactory.Instance.creatBitmap("asset.godsRoads.num%");
         this._perBmp.x = _x - this._offX;
         this._pointsNum.addChild(this._perBmp);
         this._numBitmapArray.push(this._perBmp);
      }
      
      private function deleteBitmapArray() : void
      {
         var i:int = 0;
         if(Boolean(this._numBitmapArray))
         {
            for(i = 0; i < this._numBitmapArray.length; i++)
            {
               this._numBitmapArray[i].bitmapData.dispose();
               this._numBitmapArray[i] = null;
            }
            this._numBitmapArray.length = 0;
            this._numBitmapArray = null;
         }
      }
   }
}

