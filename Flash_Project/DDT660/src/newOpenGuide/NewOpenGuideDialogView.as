package newOpenGuide
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class NewOpenGuideDialogView extends Sprite implements Disposeable
   {
      
      private var _headImg:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _descTxt:FilterFrameText;
      
      private var _mouseMsgTxt:FilterFrameText;
      
      private var _mouseClickMc:MovieClip;
      
      public function NewOpenGuideDialogView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var topBlack:Sprite = null;
         var bottomBlack:Sprite = null;
         this.graphics.beginFill(0,0.4);
         this.graphics.drawRect(0,0,1000,600);
         this.graphics.endFill();
         topBlack = new Sprite();
         topBlack.graphics.beginFill(0);
         topBlack.graphics.drawRect(0,0,1000,100);
         topBlack.graphics.endFill();
         bottomBlack = new Sprite();
         bottomBlack.graphics.beginFill(0);
         bottomBlack.graphics.drawRect(0,0,1000,130);
         bottomBlack.graphics.endFill();
         bottomBlack.y = 470;
         this._headImg = ComponentFactory.Instance.creatBitmap("asset.hall.nikeImg");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("hall.taskManuGetView.titleTxt");
         this._titleTxt.x = 390;
         this._titleTxt.y = 488;
         this._titleTxt.text = LanguageMgr.GetTranslation("hall.taskManuGetView.titleTxt");
         this._descTxt = ComponentFactory.Instance.creatComponentByStylename("hall.guideDialog.contentTxt");
         this._mouseMsgTxt = ComponentFactory.Instance.creatComponentByStylename("hall.guideDialog.mouseMsgTxt");
         this._mouseMsgTxt.text = LanguageMgr.GetTranslation("hall.guideDialog.mouseMsg");
         this._mouseMsgTxt.visible = false;
         this._mouseClickMc = ComponentFactory.Instance.creat("asset.hall.leftMouseClickMc");
         PositionUtils.setPos(this._mouseClickMc,"hall.leftMouseClickMcPos");
         this._mouseClickMc.stop();
         this._mouseClickMc.visible = false;
         addChild(topBlack);
         addChild(bottomBlack);
         addChild(this._headImg);
         addChild(this._titleTxt);
         addChild(this._descTxt);
         addChild(this._mouseMsgTxt);
         addChild(this._mouseClickMc);
      }
      
      public function showMouseMsgTxt($value:Boolean) : void
      {
         if($value)
         {
            this._mouseMsgTxt.visible = true;
            this._mouseClickMc.visible = true;
            this._mouseClickMc.play();
         }
         else
         {
            this._mouseMsgTxt.visible = false;
            this._mouseClickMc.visible = false;
            this._mouseClickMc.stop();
         }
      }
      
      public function show(desc:String, name:String = "", img:Bitmap = null, pos:Point = null) : void
      {
         this._descTxt.htmlText = desc;
         if(name != "")
         {
            this._titleTxt.text = name + "：";
         }
         else
         {
            this._titleTxt.text = LanguageMgr.GetTranslation("hall.taskManuGetView.titleTxt");
         }
         if(Boolean(this._headImg) && Boolean(this._headImg.parent))
         {
            this._headImg.parent.removeChild(this._headImg);
         }
         if(Boolean(img))
         {
            this._headImg = img;
            this._headImg.x = pos.x;
            this._headImg.y = pos.y;
         }
         else
         {
            this._headImg = ComponentFactory.Instance.creatBitmap("asset.hall.nikeImg");
            this._headImg.x = 116;
            this._headImg.y = 313;
         }
         addChild(this._headImg);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

