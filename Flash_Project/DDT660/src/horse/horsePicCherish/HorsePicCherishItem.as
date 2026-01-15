package horse.horsePicCherish
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import horse.HorseManager;
   import horse.data.HorsePicCherishVo;
   
   public class HorsePicCherishItem extends Component
   {
      
      private var _index:int;
      
      private var _bg:Bitmap;
      
      private var _horseIcon:Bitmap;
      
      private var _posArr:Array = [new Point(10,20),new Point(9,15),new Point(12,20),new Point(7,22),new Point(14,21),new Point(15,24),new Point(10,22),new Point(10,22),new Point(10,22),new Point(10,22),new Point(10,22),new Point(10,22)];
      
      private var _unKnownPos:Point = new Point(12,23);
      
      private var _data:HorsePicCherishVo;
      
      private var _horseName:FilterFrameText;
      
      private var _myColorMatrix_filter:ColorMatrixFilter;
      
      private var _state:Array;
      
      private var _useBtn:TextButton;
      
      private var _activeBtn:TextButton;
      
      private var _stateArr:Array;
      
      private var _propertyTxtArr:Array;
      
      private var _propertyValueArr:Array;
      
      private var _lastClickTime:int = 0;
      
      public function HorsePicCherishItem(index:int, data:HorsePicCherishVo)
      {
         super();
         this._index = index;
         this._data = data;
         if(Boolean(this._data))
         {
            this._stateArr = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.statusValueTxt").split(",");
            this._propertyTxtArr = LanguageMgr.GetTranslation("horse.horsePicCherish.peopertyTxt").split(",");
            this._propertyValueArr = HorseManager.instance.getHorsePicCherishAddProperty(data.ID);
         }
         this.initView();
         this.initEvent();
         this.updateView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("horse.pic.frame");
         addChild(this._bg);
         width = this._bg.width;
         height = this._bg.height;
         this._horseIcon = ComponentFactory.Instance.creat("horse.pic.icon" + this._index);
         this._horseIcon.y = 16;
         addChild(this._horseIcon);
         if(this._index != -1)
         {
            PositionUtils.setPos(this._horseIcon,this._posArr[this._index - 100 - 1]);
            this._horseName = ComponentFactory.Instance.creatComponentByStylename("horse.HorsePicCherish.nameTxt");
            this._horseName.text = this._data.Name;
            addChild(this._horseName);
            this._useBtn = ComponentFactory.Instance.creatComponentByStylename("horsePicCherish.useBtn");
            addChild(this._useBtn);
            this._useBtn.text = LanguageMgr.GetTranslation("horse.horsePicCherish.use");
            this._activeBtn = ComponentFactory.Instance.creatComponentByStylename("horsePicCherish.activeBtn");
            addChild(this._activeBtn);
            this._activeBtn.text = LanguageMgr.GetTranslation("horse.horsePicCherish.active");
         }
         else
         {
            PositionUtils.setPos(this._horseIcon,this._unKnownPos);
         }
         this._myColorMatrix_filter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._useBtn))
         {
            this._useBtn.addEventListener(MouseEvent.CLICK,this.__useHandler);
         }
         if(Boolean(this._activeBtn))
         {
            this._activeBtn.addEventListener(MouseEvent.CLICK,this.__activeHandler);
         }
         HorseManager.instance.addEventListener(HorseManager.CHANGE_HORSE_BYPICCHERISH,this.__changeHorseHandler);
      }
      
      protected function __changeHorseHandler(event:Event) : void
      {
         this.updateView();
      }
      
      protected function __activeHandler(event:MouseEvent) : void
      {
         var place:int = 0;
         SoundManager.instance.playButtonSound();
         if(getTimer() - this._lastClickTime < 2000)
         {
            return;
         }
         this._lastClickTime = getTimer();
         if(!this._data)
         {
            return;
         }
         this._state = HorseManager.instance.getHorsePicCherishState(this._data.ID,this._data.TemplateId);
         if(Boolean(this._state[0]))
         {
            return;
         }
         if(Boolean(this._state[1]))
         {
            place = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemByTemplateId(this._data.TemplateId).Place;
            SocketManager.Instance.out.sendActiveHorsePicCherish(place);
            return;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.horsePicCherish.noPic"));
      }
      
      protected function __useHandler(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._data || !this._state[0])
         {
            return;
         }
         SocketManager.Instance.out.sendHorseChangeHorse(this._data.ID);
      }
      
      private function updateView() : void
      {
         var i:int = 0;
         var tip:Object = null;
         if(Boolean(this._data))
         {
            this._state = HorseManager.instance.getHorsePicCherishState(this._data.ID,this._data.TemplateId);
            if(!tipData)
            {
               tip = new Object();
               tip.title = LanguageMgr.GetTranslation("horse.horsePicCherish.frameTitleTxt");
               tip.type = LanguageMgr.GetTranslation("horse.horsePicCherish.frameTitleTxt");
               tipData = tip;
            }
            tipData.state = Boolean(this._state[0]) ? this._stateArr[0] : this._stateArr[1];
            tipData.activeValue = ItemManager.Instance.getTemplateById(this._data.TemplateId).Name;
            tipData.propertyValue = "";
            tipData.isActive = this._state[0];
            for(i = 0; i < this._propertyValueArr.length; i++)
            {
               if(this._propertyValueArr[i] != 0)
               {
                  tipData.propertyValue += this._propertyTxtArr[i] + this._propertyValueArr[i] + "\n";
               }
            }
            tipData.getValue = LanguageMgr.GetTranslation("horse.pic.getTxt");
         }
         if(!this._data)
         {
            this._bg.filters = this._horseIcon.filters = [this._myColorMatrix_filter];
         }
         else if(Boolean(this._state[0]))
         {
            if(!this._state[2])
            {
               this._useBtn.visible = true;
               this._activeBtn.visible = false;
            }
            else
            {
               this._useBtn.visible = this._activeBtn.visible = false;
            }
            this._horseName.filters = this._bg.filters = this._horseIcon.filters = null;
         }
         else if(Boolean(this._state[1]))
         {
            this._useBtn.visible = false;
            this._activeBtn.visible = true;
            this._horseName.filters = this._bg.filters = this._horseIcon.filters = [this._myColorMatrix_filter];
         }
         else
         {
            this._useBtn.visible = false;
            this._activeBtn.visible = true;
            this._horseName.filters = this._bg.filters = this._horseIcon.filters = [this._myColorMatrix_filter];
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._useBtn))
         {
            this._useBtn.removeEventListener(MouseEvent.CLICK,this.__useHandler);
         }
         if(Boolean(this._activeBtn))
         {
            this._activeBtn.removeEventListener(MouseEvent.CLICK,this.__activeHandler);
         }
         HorseManager.instance.removeEventListener(HorseManager.CHANGE_HORSE_BYPICCHERISH,this.__changeHorseHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._horseIcon);
         this._horseIcon = null;
         ObjectUtils.disposeObject(this._horseName);
         this._horseName = null;
         ObjectUtils.disposeObject(this._activeBtn);
         this._activeBtn = null;
         ObjectUtils.disposeObject(this._useBtn);
         this._useBtn = null;
         this._propertyTxtArr = this._propertyValueArr = this._posArr = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

