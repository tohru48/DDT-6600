package worldBossHelper.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.ServerConfigInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import worldBossHelper.WorldBossHelperManager;
   import worldBossHelper.data.WorldBossHelperTypeData;
   
   public class WorldBossHelperRightView extends Sprite implements Disposeable
   {
      
      private var _disposeArr:Array;
      
      private var _rightBg:ScaleBitmapImage;
      
      private var _buffTxt:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _inputTxt:FilterFrameText;
      
      private var _buffNumTxt:FilterFrameText;
      
      private var _selectBtn1:SelectedCheckButton;
      
      private var _buybornTxt:FilterFrameText;
      
      private var _selectBtn2:SelectedCheckButton;
      
      private var _fightnowTxt:FilterFrameText;
      
      private var _selectBtn3:SelectedCheckButton;
      
      private var _startTxt:FilterFrameText;
      
      private var _selectBtn4:SelectedCheckButton;
      
      private var _startOnceTxt:FilterFrameText;
      
      private var _typeItemGroup1:SelectedButtonGroup;
      
      private var _typeItemGroup2:SelectedButtonGroup;
      
      private var _bitmapArr:Array;
      
      private var _numBg:Bitmap;
      
      private var _buffInputIcon:Bitmap;
      
      private var _selectBg1:Bitmap;
      
      private var _selectBg2:Bitmap;
      
      private var _minNum:int;
      
      private var _maxNum:int;
      
      private var _inputNum:int;
      
      private var _typeData:WorldBossHelperTypeData;
      
      public function WorldBossHelperRightView()
      {
         super();
         this._minNum = 0;
         this._maxNum = 20;
         this._disposeArr = new Array();
         this._bitmapArr = new Array();
         this._typeItemGroup1 = new SelectedButtonGroup(true);
         this._typeItemGroup2 = new SelectedButtonGroup();
         this._typeData = WorldBossHelperManager.Instance.data;
         this.initView();
         this.initEvent();
      }
      
      public function get typeData() : WorldBossHelperTypeData
      {
         if(this._typeItemGroup1.selectIndex != -1)
         {
            if(this._typeItemGroup1.selectedCount != 0)
            {
               this._typeData.type = this._typeItemGroup1.selectIndex + 1;
            }
            else
            {
               this._typeData.type = 0;
            }
         }
         else
         {
            this._typeData.type = 0;
         }
         this._typeData.openType = this._typeItemGroup2.selectIndex + 1;
         this._typeData.buffNum = this._inputNum;
         return this._typeData;
      }
      
      private function initView() : void
      {
         var money:int = 0;
         this._rightBg = ComponentFactory.Instance.creat("worldBossHelper.view.rightBg");
         addChild(this._rightBg);
         this._numBg = ComponentFactory.Instance.creat("worldBossHelper.buff");
         addChild(this._numBg);
         this._buffTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.buffText");
         this._buffTxt.text = LanguageMgr.GetTranslation("worldbosshelper.buyBuff");
         addChild(this._buffTxt);
         this._buffInputIcon = ComponentFactory.Instance.creat("worldBossHelper.num");
         addChild(this._buffInputIcon);
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.NumberInputText");
         this._inputTxt.restrict = "0-9";
         addChild(this._inputTxt);
         this._maxBtn = ComponentFactory.Instance.creat("worldBossHelper.view.maxBtn");
         addChild(this._maxBtn);
         this._selectBg1 = ComponentFactory.Instance.creat("worldBossHelper.frame1");
         addChild(this._selectBg1);
         this._selectBtn1 = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.buybornBtn");
         addChild(this._selectBtn1);
         this._buybornTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.descritionText");
         this._buybornTxt.text = LanguageMgr.GetTranslation("worldbosshelper.buyborn");
         this._buybornTxt.x = this._selectBtn1.x + 20;
         this._buybornTxt.y = this._selectBtn1.y + 22;
         addChild(this._buybornTxt);
         this._selectBtn2 = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.fightnowBtn");
         addChild(this._selectBtn2);
         this._fightnowTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.descritionText");
         this._fightnowTxt.text = LanguageMgr.GetTranslation("worldbosshelper.fightnow");
         this._fightnowTxt.x = this._selectBtn2.x + 20;
         this._fightnowTxt.y = this._selectBtn2.y + 22;
         addChild(this._fightnowTxt);
         this._selectBg2 = ComponentFactory.Instance.creat("worldBossHelper.frame2");
         addChild(this._selectBg2);
         this._selectBtn3 = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.startOnceBtn");
         addChild(this._selectBtn3);
         var moneyNumInfo:ServerConfigInfo = ServerConfigManager.instance.findInfoByName("WorldBossAssistantFightMoney");
         if(Boolean(moneyNumInfo) && Boolean(moneyNumInfo.Value))
         {
            money = int(moneyNumInfo.Value);
         }
         else
         {
            money = 80;
         }
         this._startTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.descritionText");
         this._startTxt.text = LanguageMgr.GetTranslation("worldbosshelper.startOnce",money);
         this._startTxt.x = this._selectBtn3.x + 20;
         this._startTxt.y = this._selectBtn3.y + 22;
         addChild(this._startTxt);
         this._selectBtn4 = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.startBtn");
         addChild(this._selectBtn4);
         this._typeItemGroup1.addSelectItem(this._selectBtn1);
         this._typeItemGroup1.addSelectItem(this._selectBtn2);
         this._typeItemGroup2.addSelectItem(this._selectBtn3);
         this._typeItemGroup2.addSelectItem(this._selectBtn4);
         this._startOnceTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.descritionText");
         this._startOnceTxt.text = LanguageMgr.GetTranslation("worldbosshelper.start",money);
         this._startOnceTxt.x = this._selectBtn4.x + 20;
         this._startOnceTxt.y = this._selectBtn4.y + 22;
         addChild(this._startOnceTxt);
         this._disposeArr.push(this._rightBg,this._buffTxt,this._maxBtn,this._inputTxt,this._buffNumTxt,this._selectBtn1,this._buybornTxt,this._selectBtn2,this._fightnowTxt,this._selectBtn3,this._startTxt,this._selectBtn4,this._startOnceTxt);
         this._bitmapArr.push(this._numBg,this._buffInputIcon,this._selectBg1,this._selectBg2);
      }
      
      public function setState() : void
      {
         this._inputNum = this._typeData.buffNum;
         this._inputTxt.text = "" + this._typeData.buffNum;
         this._typeItemGroup1.selectIndex = this._typeData.type - 1;
         this._selectBtn1.selected = this._typeData.type == 1;
         this._selectBtn2.selected = this._typeData.type == 2;
         this._typeItemGroup2.selectIndex = this._typeData.openType - 1;
         this._maxBtn.enable = this._selectBtn1.enable = this._selectBtn2.enable = this._selectBtn3.enable = this._selectBtn4.enable = !WorldBossHelperManager.Instance.helperOpen;
         WorldBossHelperManager.Instance.isHelperOnlyOnce = this._typeItemGroup2.selectIndex == 0;
         if(WorldBossHelperManager.Instance.helperOpen)
         {
            this._inputTxt.mouseEnabled = false;
         }
         else
         {
            this._inputTxt.mouseEnabled = true;
         }
      }
      
      private function initEvent() : void
      {
         this._selectBtn1.addEventListener(Event.CHANGE,this.__typeItemHandler);
         this._selectBtn2.addEventListener(Event.CHANGE,this.__typeItemHandler);
         this._selectBtn3.addEventListener(Event.CHANGE,this.__typeItemHandler);
         this._selectBtn4.addEventListener(Event.CHANGE,this.__typeItemHandler);
         this._inputTxt.addEventListener(Event.CHANGE,this.__inputHandler);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.__maxBtnHandler);
      }
      
      protected function __typeItemHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function removeEvent() : void
      {
         this._selectBtn1.removeEventListener(Event.CHANGE,this.__typeItemHandler);
         this._selectBtn2.removeEventListener(Event.CHANGE,this.__typeItemHandler);
         this._selectBtn3.removeEventListener(Event.CHANGE,this.__typeItemHandler);
         this._selectBtn4.removeEventListener(Event.CHANGE,this.__typeItemHandler);
         this._inputTxt.removeEventListener(Event.CHANGE,this.__inputHandler);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.__maxBtnHandler);
      }
      
      protected function __inputHandler(event:Event) : void
      {
         if(int(this._inputTxt.text) < this._minNum)
         {
            this._inputTxt.text = "" + this._minNum;
         }
         else if(int(this._inputTxt.text) > this._maxNum)
         {
            this._inputTxt.text = "" + this._maxNum;
         }
         this._inputNum = int(this._inputTxt.text);
         this.updateInputView();
      }
      
      protected function __maxBtnHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._inputNum = 20;
         this.updateInputView();
      }
      
      private function updateInputView() : void
      {
         this._inputTxt.text = "" + this._inputNum;
         this._typeData.buffNum = this._inputNum;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._typeItemGroup1 = null;
         this._typeItemGroup2 = null;
         for(var i:int = 0; i < this._disposeArr.length; i++)
         {
            if(Boolean(this._disposeArr[i]))
            {
               this._disposeArr[i].dispose();
               this._disposeArr[i] = null;
            }
         }
         this._disposeArr = null;
         for(var j:int = 0; j < this._bitmapArr.length; j++)
         {
            if(Boolean(this._bitmapArr[j]))
            {
               (this._bitmapArr[j] as Bitmap).bitmapData.dispose();
               this._bitmapArr[j] = null;
            }
         }
         this._bitmapArr = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

