package christmas.view.makingSnowmenView
{
   import christmas.manager.ChristmasManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SnowPackDoubleFrame extends BaseAlerFrame
   {
      
      private var _selectedDoubleCheckButton:SelectedCheckButton;
      
      public var buyFunction:Function;
      
      public var clickFunction:Function;
      
      private var _txt:FilterFrameText;
      
      private var _txtTwo:FilterFrameText;
      
      private var _addNumTxt:FilterFrameText;
      
      private var _inputTxt:FilterFrameText;
      
      private var _maxBnt:BaseButton;
      
      private var _inputPng:Bitmap;
      
      private var _target:Sprite;
      
      private var _isOpen:Boolean;
      
      private var _addDoubleNumTxt:FilterFrameText;
      
      public function SnowPackDoubleFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public function set target($target:Sprite) : void
      {
         this._target = $target;
      }
      
      private function initView() : void
      {
         var alerInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"));
         info = alerInfo;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("christmas.alert.txt");
         addToContent(this._txt);
      }
      
      public function initAddView(isOpen:Boolean = false) : void
      {
         this._isOpen = isOpen;
         if(this._isOpen)
         {
            this._addNumTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.addNum.txt");
            this._addNumTxt.text = LanguageMgr.GetTranslation("christmas.addNum.txt.LG");
            this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.input.txt");
            this._inputTxt.text = "1";
            this._inputPng = ComponentFactory.Instance.creatBitmap("christmas.input.png");
            this._maxBnt = ComponentFactory.Instance.creat("christmas.max.Bnt");
            this._maxBnt.addEventListener(MouseEvent.CLICK,this.__addMax);
            this._selectedDoubleCheckButton = ComponentFactory.Instance.creatComponentByStylename("christmas.makingSnowmen.selectBtn");
            this._selectedDoubleCheckButton.selected = false;
            addToContent(this._selectedDoubleCheckButton);
            this._selectedDoubleCheckButton.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
            this._selectedDoubleCheckButton.text = LanguageMgr.GetTranslation("christmas.makingSnowmen.selectedCheckButton.LG");
            this._addDoubleNumTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.alert.txtTwo");
            this._addDoubleNumTxt.text = LanguageMgr.GetTranslation("christmas.snowpack.doubleMoney",ChristmasManager.instance.model.money);
            addToContent(this._addDoubleNumTxt);
            addToContent(this._addNumTxt);
            addToContent(this._inputPng);
            addToContent(this._inputTxt);
            addToContent(this._maxBnt);
         }
      }
      
      public function setIsShow(isShow:Boolean = true, select:int = 0) : void
      {
         if(select == 0)
         {
            info.showCancel = isShow;
         }
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.responseHander);
      }
      
      private function __addMax(e:MouseEvent) : void
      {
         this._inputTxt.text = String(ChristmasManager.instance.getCount());
      }
      
      private function mouseClickHander(e:MouseEvent) : void
      {
         ChristmasManager.instance.model.isSelect = this._selectedDoubleCheckButton.selected;
      }
      
      private function removeEvnets() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.responseHander);
         if(Boolean(this._selectedDoubleCheckButton))
         {
            this._selectedDoubleCheckButton.removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
         }
         if(Boolean(this._maxBnt))
         {
            this._maxBnt.removeEventListener(MouseEvent.CLICK,this.__addMax);
         }
      }
      
      private function responseHander(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(e.responseCode == FrameEvent.SUBMIT_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this.buyFunction != null && this._isOpen)
            {
               this.buyFunction(int(this._inputTxt.text));
               ChristmasManager.instance.model.snowPackNumber = int(this._inputTxt.text);
               this.dispose();
               return;
            }
            if(this.buyFunction != null)
            {
               this.buyFunction(ChristmasManager.instance.model.snowPackNumber);
               this.dispose();
               return;
            }
         }
         else if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.CANCEL_CLICK)
         {
            if(Boolean(this._target))
            {
               if(this._target is ChristmasMakingSnowmenFrame)
               {
               }
            }
         }
         this.dispose();
      }
      
      public function setTxt(str:String) : void
      {
         this._txt.htmlText = str;
      }
      
      override public function dispose() : void
      {
         this.removeEvnets();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._selectedDoubleCheckButton))
         {
            ObjectUtils.disposeObject(this._selectedDoubleCheckButton);
         }
         this._selectedDoubleCheckButton = null;
      }
   }
}

