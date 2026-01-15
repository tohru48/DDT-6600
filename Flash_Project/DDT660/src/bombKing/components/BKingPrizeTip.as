package bombKing.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class BKingPrizeTip extends Sprite implements ITransformableTip
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _label:FilterFrameText;
      
      private var _title:FilterFrameText;
      
      private var _request:FilterFrameText;
      
      private var _content:FilterFrameText;
      
      private var _type:int;
      
      public function BKingPrizeTip()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeTip.bg");
         addChild(this._bg);
         this._label = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeTip.labelTxt");
         addChild(this._label);
         this._label.text = LanguageMgr.GetTranslation("bombKing.prizeTip.label");
         this._request = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeTip.requestTxt");
         addChild(this._request);
         this._request.text = LanguageMgr.GetTranslation("bombKing.prizeTip.request");
         this._content = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeTip.contentTxt");
         addChild(this._content);
      }
      
      public function get tipData() : Object
      {
         return this._type;
      }
      
      public function set tipData(data:Object) : void
      {
         this._type = data as int;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
            this._title = null;
         }
         this._title = ComponentFactory.Instance.creatComponentByStylename("bombKing.prizeTip.titleTxt" + this._type);
         addChild(this._title);
         this._title.text = LanguageMgr.GetTranslation("bombKing.prizeTip.title" + this._type);
         this._content.text = LanguageMgr.GetTranslation("bombKing.prizeTip.content" + this._type);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._label);
         this._label = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._request);
         this._request = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(w:int) : void
      {
      }
      
      public function get tipHeight() : int
      {
         return 0;
      }
      
      public function set tipHeight(h:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

