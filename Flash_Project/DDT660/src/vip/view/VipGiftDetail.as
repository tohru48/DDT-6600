package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.TiledImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class VipGiftDetail extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _iconBg:DisplayObject;
      
      private var _line:TiledImage;
      
      private var _giftIcon:ScaleBitmapImage;
      
      private var _vipSubIcon:ScaleBitmapImage;
      
      private var _detailTxt:FilterFrameText;
      
      private var _index:int;
      
      public function VipGiftDetail()
      {
         super();
      }
      
      public function setData(index:int) : void
      {
         this._index = index;
         this.updateView();
      }
      
      private function updateView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("vip.GiftContentView.BG");
         this._iconBg = ComponentFactory.Instance.creatCustomObject("vip.GiftContentView.ItemCellBG");
         this._line = ComponentFactory.Instance.creatComponentByStylename("vip.GiftContentView.Line");
         this._giftIcon = ComponentFactory.Instance.creatComponentByStylename("vip.GiftContentView.GiftIcon");
         this._vipSubIcon = ComponentFactory.Instance.creatComponentByStylename("vip.GiftContentView.VipSubIcon" + this._index);
         this._detailTxt = ComponentFactory.Instance.creatComponentByStylename("vip.GiftContentView.DetailTxt");
         var str:String = LanguageMgr.GetTranslation("ddt.vip.GifContentView.itemTxt" + this._index);
         this._detailTxt.text = str;
         addChild(this._bg);
         addChild(this._iconBg);
         addChild(this._line);
         addChild(this._giftIcon);
         addChild(this._vipSubIcon);
         addChild(this._detailTxt);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._iconBg);
         this._iconBg = null;
         ObjectUtils.disposeObject(this._line);
         this._line = null;
         ObjectUtils.disposeObject(this._giftIcon);
         this._giftIcon = null;
         ObjectUtils.disposeObject(this._vipSubIcon);
         this._vipSubIcon = null;
         ObjectUtils.disposeObject(this._detailTxt);
         this._detailTxt = null;
      }
   }
}

