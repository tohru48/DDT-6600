package com.pickgliss.ui.controls.alert
{
   import com.pickgliss.geom.InnerRectangle;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class SimpleAlert extends BaseAlerFrame
   {
      
      public static const P_frameInnerRect:String = "frameInnerRect";
      
      public static const P_frameMiniH:String = "frameMiniH";
      
      public static const P_frameMiniW:String = "frameMiniW";
      
      public static const P_textField:String = "textFieldStyle";
      
      protected var _frameMiniH:int = -2147483648;
      
      protected var _frameMiniW:int = -2147483648;
      
      protected var _textField:TextField;
      
      protected var _textFieldStyle:String;
      
      private var _frameInnerRect:InnerRectangle;
      
      private var _frameInnerRectString:String;
      
      private var _selectedBandBtn:SelectedCheckButton;
      
      private var _selectedBtn:SelectedCheckButton;
      
      private var _back:MovieClip;
      
      protected var _seleContent:Sprite;
      
      public function SimpleAlert()
      {
         super();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._textField))
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textField = null;
         if(Boolean(this._selectedBandBtn))
         {
            this._selectedBandBtn.removeEventListener(MouseEvent.CLICK,this.selectedBandHander);
            ObjectUtils.disposeObject(this._selectedBandBtn);
         }
         if(Boolean(this._selectedBtn))
         {
            this._selectedBtn.removeEventListener(MouseEvent.CLICK,this.selectedHander);
            ObjectUtils.disposeObject(this._selectedBtn);
         }
         this._selectedBandBtn = null;
         this._selectedBtn = null;
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         this._frameInnerRect = null;
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         super.dispose();
      }
      
      override public function set info(param1:AlertInfo) : void
      {
         super.info = param1;
         onPropertiesChanged(P_info);
         if(info.type == AlertManager.NOSELECTBTN)
         {
            return;
         }
         this._seleContent = new Sprite();
         addToContent(this._seleContent);
         this._back = ComponentFactory.Instance.creat("asset.core.stranDown2");
         this._back.y = 46;
         this._back.width = this.width;
         this._seleContent.addChild(this._back);
         _isBand = false;
         this._selectedBandBtn = ComponentFactory.Instance.creatComponentByStylename("simpleAlertFrame.moneySelectBtn");
         this._selectedBandBtn.text = "绑定点券";
         this._selectedBandBtn.x = 155;
         this._selectedBandBtn.y = 49;
         this._selectedBandBtn.selected = true;
         this._selectedBandBtn.enable = false;
         this._seleContent.addChild(this._selectedBandBtn);
         this._selectedBandBtn.addEventListener(MouseEvent.CLICK,this.selectedBandHander);
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("simpleAlertFrame.moneySelectBtn");
         this._selectedBtn.text = "点券";
         this._selectedBtn.x = 63;
         this._selectedBtn.y = 49;
         this._seleContent.addChild(this._selectedBtn);
         this._selectedBtn.addEventListener(MouseEvent.CLICK,this.selectedHander);
         this._selectedBtn.x = this._back.width / 2 - 62 - this._back.width / 15;
         this._selectedBandBtn.x = this._back.width / 2 + this._back.width / 15;
         this._seleContent.x = this.width / 2 - this._seleContent.width / 2 - this._seleContent.parent.x;
         this._seleContent.y = this._textField.height + this._textField.y - 95;
         this._seleContent.visible = false;
      }
      
      protected function selectedBandHander(param1:MouseEvent) : void
      {
         if(this._selectedBandBtn.selected)
         {
            _isBand = true;
            this._selectedBandBtn.enable = false;
            this._selectedBtn.enable = true;
            this._selectedBtn.selected = false;
         }
         else
         {
            _isBand = false;
         }
      }
      
      protected function selectedHander(param1:MouseEvent) : void
      {
         if(this._selectedBtn.selected)
         {
            _isBand = false;
            this._selectedBtn.enable = false;
            this._selectedBandBtn.enable = true;
            this._selectedBandBtn.selected = false;
         }
         else
         {
            _isBand = true;
         }
      }
      
      public function set frameInnerRectString(param1:String) : void
      {
         if(this._frameInnerRectString == param1)
         {
            return;
         }
         this._frameInnerRectString = param1;
         this._frameInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._frameInnerRectString));
         onPropertiesChanged(P_frameInnerRect);
      }
      
      public function set frameMiniH(param1:int) : void
      {
         if(this._frameMiniH == param1)
         {
            return;
         }
         this._frameMiniH = param1;
         onPropertiesChanged(P_frameMiniH);
      }
      
      public function set frameMiniW(param1:int) : void
      {
         if(this._frameMiniW == param1)
         {
            return;
         }
         this._frameMiniW = param1;
         onPropertiesChanged(P_frameMiniW);
      }
      
      public function set textStyle(param1:String) : void
      {
         if(this._textFieldStyle == param1)
         {
            return;
         }
         if(Boolean(this._textField))
         {
            ObjectUtils.disposeObject(this._textField);
         }
         this._textFieldStyle = param1;
         this._textField = ComponentFactory.Instance.creat(this._textFieldStyle);
         onPropertiesChanged(P_textField);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._textField))
         {
            addChild(this._textField);
         }
      }
      
      protected function layoutFrameRect() : void
      {
         var _loc1_:Rectangle = null;
         _loc1_ = this._frameInnerRect.getInnerRect(this._textField.width,this._textField.height);
         if(_loc1_.width > this._frameMiniW)
         {
            this._textField.x = this._frameInnerRect.para1;
            _width = _loc1_.width;
         }
         else
         {
            this._textField.x = this._frameInnerRect.para1 + (this._frameMiniW - _loc1_.width) / 2;
            _width = this._frameMiniW;
         }
         if(_loc1_.height > this._frameMiniH)
         {
            this._textField.y = this._frameInnerRect.para3;
            _height = _loc1_.height;
         }
         else
         {
            this._textField.y = this._frameInnerRect.para3 + (this._frameMiniH - _loc1_.height) / 2;
            _height = this._frameMiniH;
         }
      }
      
      override protected function onProppertiesUpdate() : void
      {
         if(Boolean(_changedPropeties[P_info]))
         {
            this.updateMsg();
            if(Boolean(this._frameInnerRect))
            {
               this.layoutFrameRect();
               _changedPropeties[Component.P_width] = true;
               _changedPropeties[Component.P_height] = true;
            }
         }
         super.onProppertiesUpdate();
      }
      
      protected function updateMsg() : void
      {
         this._textField.autoSize = TextFieldAutoSize.LEFT;
         if(_info.mutiline)
         {
            this._textField.multiline = true;
            if(!info.enableHtml)
            {
               this._textField.wordWrap = true;
            }
            if(_info.textShowWidth > 0)
            {
               this._textField.width = _info.textShowWidth;
            }
            else
            {
               this._textField.width = DisplayUtils.getTextFieldMaxLineWidth(String(_info.data),this._textField.defaultTextFormat,info.enableHtml);
            }
         }
         if(_info.enableHtml)
         {
            this._textField.htmlText = String(_info.data);
         }
         else
         {
            this._textField.text = String(_info.data);
         }
      }
   }
}

