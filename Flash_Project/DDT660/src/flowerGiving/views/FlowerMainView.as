package flowerGiving.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flowerGiving.FlowerGivingManager;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class FlowerMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _bottomBg:ScaleBitmapImage;
      
      private var _desc:FilterFrameText;
      
      private var _givingBtn:SimpleBitmapButton;
      
      private var _frame:Frame;
      
      public function FlowerMainView()
      {
         super();
         this.initView();
         this.addEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("flowerGiving.mainPageBG");
         addChild(this._bg);
         this._bottomBg = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.bottomBG");
         addChild(this._bottomBg);
         this._desc = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.deepBrownTxt");
         PositionUtils.setPos(this._desc,"flowerGiving.descPos");
         this._desc.text = LanguageMgr.GetTranslation("flowerGiving.desc");
         addChild(this._desc);
         this._givingBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.givingBtn");
         addChild(this._givingBtn);
         this.setActDate();
      }
      
      private function addEvents() : void
      {
         this._givingBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      protected function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame = ComponentFactory.Instance.creatCustomObject("flowerGiving.FlowerSendFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.title");
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function setActDate() : void
      {
         var xmlData:GmActivityInfo = FlowerGivingManager.instance.xmlData;
         var beginDate:String = this.dateTrim(xmlData.beginTime,true);
         var endDate:String = this.dateTrim(xmlData.endTime,true);
         var beginShow:String = this.dateTrim(xmlData.beginShowTime,true);
         var endShow:String = this.dateTrim(xmlData.endShowTime,true);
         this._desc.text = LanguageMgr.GetTranslation("flowerGiving.desc",beginDate,endDate,beginShow,endShow);
      }
      
      private function dateTrim(dateStr:String, flag:Boolean = false) : String
      {
         var str:String = "";
         var temp:Array = dateStr.split(" ");
         str = temp[0].replace(/\//g,"-");
         if(flag)
         {
            str += " " + temp[1].slice(0,5);
         }
         return str;
      }
      
      private function removeEvents() : void
      {
         this._givingBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      public function dispose() : void
      {
         this._frame = null;
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._bottomBg);
         this._bottomBg = null;
         ObjectUtils.disposeObject(this._desc);
         this._desc = null;
         ObjectUtils.disposeObject(this._givingBtn);
         this._givingBtn = null;
      }
   }
}

