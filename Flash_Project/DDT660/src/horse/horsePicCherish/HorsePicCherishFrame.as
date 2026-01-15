package horse.horsePicCherish
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import horse.HorseManager;
   import horse.data.HorsePicCherishVo;
   
   public class HorsePicCherishFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _scaleBg:ScaleBitmapImage;
      
      private var _leftBtn:SimpleBitmapButton;
      
      private var _rightBtn:SimpleBitmapButton;
      
      private var _currentIndex:int = 1;
      
      private var _sumPage:int;
      
      private var _itemListView:HorsePicCherishItemListView;
      
      private var _itemList:Vector.<HorsePicCherishItem>;
      
      private var _horsePicCherishList:Vector.<HorsePicCherishVo>;
      
      private var _nameStrList:Array = LanguageMgr.GetTranslation("horse.addPropertyNameStr").split(",");
      
      private var _propertyNameArr:Array;
      
      private var _propertyNamePosArr:Array = [new Point(25,365),new Point(134,365),new Point(252,365),new Point(361,365),new Point(475,365)];
      
      private var _propertyValueArr:Array;
      
      private var _propertyValuePosArr:Array = [new Point(78,365),new Point(188,365),new Point(308,365),new Point(428,365),new Point(548,365)];
      
      private var _pageBg:Scale9CornerImage;
      
      private var _pageTxt:FilterFrameText;
      
      public function HorsePicCherishFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
         this.updateView();
      }
      
      private function initView() : void
      {
         var nameTxt:FilterFrameText = null;
         var valueTxt:FilterFrameText = null;
         _titleText = LanguageMgr.GetTranslation("horse.horsePicCherish.frameTitleTxt");
         this._scaleBg = ComponentFactory.Instance.creatComponentByStylename("horse.HorsePicCherish.scale9ImageBg");
         addToContent(this._scaleBg);
         this._bg = ComponentFactory.Instance.creat("horse.pic.bg");
         addToContent(this._bg);
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("horse.HorsePicCherish.leftBtn");
         addToContent(this._leftBtn);
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("horse.HorsePicCherish.rightBtn");
         addToContent(this._rightBtn);
         this._propertyNameArr = new Array();
         this._propertyValueArr = new Array();
         for(var i:int = 0; i < 5; i++)
         {
            nameTxt = ComponentFactory.Instance.creatComponentByStylename("horse.picCHerish.addPorpertyNameTxt");
            nameTxt.text = this._nameStrList[i];
            addToContent(nameTxt);
            PositionUtils.setPos(nameTxt,this._propertyNamePosArr[i]);
            this._propertyNameArr.push(nameTxt);
            valueTxt = ComponentFactory.Instance.creatComponentByStylename("horse.picCHerish.addPorpertyValueTxt");
            valueTxt.text = "0";
            addToContent(valueTxt);
            PositionUtils.setPos(valueTxt,this._propertyValuePosArr[i]);
            this._propertyValueArr.push(valueTxt);
         }
         this._pageBg = ComponentFactory.Instance.creatComponentByStylename("horsePicCherish.pageBG");
         addToContent(this._pageBg);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("horsePicCherish.pageTxt");
         addToContent(this._pageTxt);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__leftHandler);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__rightHandler);
         HorseManager.instance.updateCherishPropertyFunc = this.updateView;
      }
      
      private function initData() : void
      {
         var item:HorsePicCherishItem = null;
         var itemUnKnown:HorsePicCherishItem = null;
         this._itemList = new Vector.<HorsePicCherishItem>();
         this._horsePicCherishList = HorseManager.instance.getHorsePicCherishData();
         for(var i:int = 0; i < this._horsePicCherishList.length; i++)
         {
            item = new HorsePicCherishItem(this._horsePicCherishList[i].ID,this._horsePicCherishList[i]);
            item.tipStyle = "horse.horsePicCherish.HorsePicCherishTip";
            item.tipDirctions = "2,7,5,1,4,6";
            this._itemList.push(item);
         }
         for(var j:int = 0; j < 8 - this._horsePicCherishList.length % 8; j++)
         {
            itemUnKnown = new HorsePicCherishItem(-1,null);
            this._itemList.push(itemUnKnown);
         }
         this._sumPage = Math.ceil(this._itemList.length / 8);
      }
      
      private function updateView() : void
      {
         var hurt:int = 0;
         var guard:int = 0;
         var blood:int = 0;
         var magicAttack:int = 0;
         var magicDefence:int = 0;
         var key:String = null;
         var temp:Array = null;
         var i:int = 0;
         var data:HorsePicCherishVo = null;
         var dataDic:Dictionary = PlayerManager.Instance.Self.horsePicCherishDic;
         var dataVec:Vector.<HorsePicCherishVo> = HorseManager.instance.getHorsePicCherishData();
         for(key in dataDic)
         {
            for each(data in dataVec)
            {
               if(int(key) == data.ID)
               {
                  hurt += data.AddHurt;
                  guard += data.AddGuard;
                  blood += data.AddBlood;
                  magicAttack += data.MagicAttack;
                  magicDefence += data.MagicDefence;
                  break;
               }
            }
         }
         temp = [hurt,guard,blood,magicAttack,magicDefence];
         for(i = 0; i < this._propertyValueArr.length; i++)
         {
            this._propertyValueArr[i].text = temp[i];
         }
      }
      
      public function set index(value:int) : void
      {
         this._currentIndex = value;
         this._pageTxt.text = this._currentIndex + "/" + this._sumPage;
         this.refreshView();
      }
      
      private function refreshView() : void
      {
         if(!this._itemListView)
         {
            this._itemListView = new HorsePicCherishItemListView(this._itemList);
            this._itemListView.x = 8;
            this._itemListView.y = 3;
            addToContent(this._itemListView);
         }
         this._itemListView.show(this._currentIndex);
      }
      
      protected function __rightHandler(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._currentIndex >= this._sumPage)
         {
            return;
         }
         ++this._currentIndex;
         this.index = this._currentIndex;
      }
      
      protected function __leftHandler(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._currentIndex <= 1)
         {
            return;
         }
         --this._currentIndex;
         this.index = this._currentIndex;
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.__leftHandler);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.__rightHandler);
      }
      
      override public function dispose() : void
      {
         var txt:FilterFrameText = null;
         var valueTxt:FilterFrameText = null;
         this.removeEvent();
         HorseManager.instance.isSkipFromBagView = false;
         HorseManager.instance.updateCherishPropertyFunc = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._scaleBg);
         this._scaleBg = null;
         ObjectUtils.disposeObject(this._itemListView);
         this._itemListView = null;
         this._itemList = null;
         ObjectUtils.disposeObject(this._leftBtn);
         this._leftBtn = null;
         ObjectUtils.disposeObject(this._rightBtn);
         this._rightBtn = null;
         for each(txt in this._propertyNameArr)
         {
            ObjectUtils.disposeObject(txt);
            txt = null;
         }
         this._propertyNameArr = null;
         for each(valueTxt in this._propertyValueArr)
         {
            ObjectUtils.disposeObject(valueTxt);
            valueTxt = null;
         }
         this._propertyValueArr = null;
         ObjectUtils.disposeObject(this._pageBg);
         this._pageBg = null;
         ObjectUtils.disposeObject(this._pageTxt);
         this._pageTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

